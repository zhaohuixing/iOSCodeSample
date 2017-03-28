// 
//  APCMedTrackerDataStorageManager.m 
//  APCAppCore 
// 
// Copyright (c) 2015, Apple Inc. All rights reserved. 
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2.  Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution. 
// 
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission. No license is granted to the trademarks of 
// the copyright holders even if such marks are included in this software. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
// 
 
#import "XZCareMedTrackerDataStorageManager.h"
#import "XZCareCoreDBMedTrackerMedication+XZCareCore.h"
#import "XZCareCoreDBMedTrackerPrescriptionColor+XZCareCore.h"
#import "XZCareCoreDBMedTrackerPossibleDosage+XZCareCore.h"
#import <XZCareBase/NSOperationQueue+XZBaseCore.h>
#import "XZCareCoreAppDelegate.h"
#import <XZCareBase/NSManagedObject+XZBaseCore.h>
#import <XZCareBase/XZBaseLog.h>


static XZCareMedTrackerDataStorageManager *_defaultManager = nil;

static NSString * const FILE_WITH_PREDEFINED_MEDICATIONS = @"XZCareMedTrackerPredefinedMedications.plist";
static NSString * const FILE_WITH_PREDEFINED_POSSIBLE_DOSAGES = @"XZCareMedTrackerPredefinedPossibleDosages.plist";
static NSString * const FILE_WITH_PREDEFINED_PRESCRIPTION_COLORS = @"XZCareMedTrackerPredefinedPrescriptionColors.plist";
static NSString * const QUEUE_NAME = @"MedicationTracker query queue";
static dispatch_once_t _startupComplete = 0;



@interface XZCareMedTrackerDataStorageManager ()

@property (nonatomic, strong) NSOperationQueue *masterQueue;
@property (nonatomic, strong) NSManagedObjectContext *masterContext;

@end


@implementation XZCareMedTrackerDataStorageManager

+ (void) startupReloadingDefaults: (BOOL) shouldReloadPlistFiles
              andThenUseThisQueue: (NSOperationQueue *) queue
                         toDoThis: (XZCareMedTrackerGenericCallback) callbackBlock
{
    if (! _defaultManager)
    {
        dispatch_once (& _startupComplete, ^{

            XZCareMedTrackerDataStorageManager *__block manager = [XZCareMedTrackerDataStorageManager new];
            _defaultManager = manager;

            manager.masterQueue = [NSOperationQueue sequentialOperationQueueWithName: QUEUE_NAME];
            
            [manager.masterQueue addOperationWithBlock:^{

                manager.masterContext = [manager newContextOnCurrentQueue];

                XZCareLogDebug (@"MedTracker defaultManager has been created.");
                
                if (shouldReloadPlistFiles)
                {
                    [self reloadStaticContentFromPlistFiles];
                }

                [self doThis: callbackBlock onThisQueue: queue];
            }];
        });
    }
    else
    {
        [self doThis: callbackBlock onThisQueue: queue];
    }
}

+ (void) doThis: (XZCareMedTrackerGenericCallback) callbackBlock
    onThisQueue: (NSOperationQueue *) consumerQueue
{
    if (consumerQueue != nil && callbackBlock != NULL)
    {
        [consumerQueue addOperationWithBlock:^{
            callbackBlock ();
        }];
    }
}

/**
 (Re)load current static data values from disk
 (in case, say, we now have more medications, or
 our designers have changed the color palette).

 This should be called exactly once, from +startup.
 This is called from within a block on our special
 queue.
 */
+ (void) reloadStaticContentFromPlistFiles
{
    XZCareMedTrackerDataStorageManager *manager = [self defaultManager];
    NSManagedObjectContext *context = manager.masterContext;
    NSMutableArray *allInflatedObjects = [NSMutableArray new];
    NSDate *startDate = [NSDate date];

    /*
     These methods are sequential, in-line methods,
     because I designed them to be called from this
     method.
     */
    [allInflatedObjects addObjectsFromArray: [XZCareCoreDBMedTrackerMedication reloadAllObjectsFromPlistFileNamed: FILE_WITH_PREDEFINED_MEDICATIONS usingContext: context]];
    [allInflatedObjects addObjectsFromArray: [XZCareCoreDBMedTrackerPossibleDosage reloadAllObjectsFromPlistFileNamed: FILE_WITH_PREDEFINED_POSSIBLE_DOSAGES usingContext: context]];
    [allInflatedObjects addObjectsFromArray: [XZCareCoreDBMedTrackerPrescriptionColor reloadAllObjectsFromPlistFileNamed: FILE_WITH_PREDEFINED_PRESCRIPTION_COLORS usingContext: context]];


    /*
     Save to CoreData.
     */
    NSString *errorMessage = nil;

    if (allInflatedObjects.count > 0)
    {
        NSError *error = nil;
        XZCareCoreDBMedTrackerInflatableItem *someObject = allInflatedObjects.firstObject;

        BOOL itWorked = [someObject saveToPersistentStore: &error];

        if (itWorked)
        {
            errorMessage = @"Everything seems to have worked perfectly.";
        }
        else if (error == nil)
        {
            errorMessage = @"Error: [Couldn't load files, but I have no information about why... ?!?]";
        }
        else
        {
            errorMessage = [NSString stringWithFormat: @"Error: [%@]", error];
        }
    }


    NSTimeInterval operationDuration = [[NSDate date] timeIntervalSinceDate: startDate];

    XZCareLogDebug (@"(Re)loaded static MedTracker items from disk in %f seconds.  %@  Loaded these items: %@", operationDuration, errorMessage, allInflatedObjects);
}

+ (instancetype) defaultManager
{
    return _defaultManager;
}

/**
 Should be called exactly once, by +startup.
 */
- (id) init
{
    self = [super init];

    if (self)
    {
        // I'll fill these in shortly.
        _masterContext = nil;
        _masterQueue = nil;
    }

    return self;
}

- (NSManagedObjectContext *) context
{
    return self.masterContext;
}

- (NSOperationQueue *) queue
{
    return self.masterQueue;
}

- (NSManagedObjectContext *) newContextOnCurrentQueue
{
    XZCareCoreAppDelegate *appDelegate = (XZCareCoreAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *masterContextIThink = appDelegate.dataSubstrate.persistentContext;
    NSManagedObjectContext *localContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    localContext.parentContext = masterContextIThink;
    return localContext;
}

@end












