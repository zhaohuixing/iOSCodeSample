// 
//  APCBaseTaskViewController.m 
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
 
#import <XZCareCore/XZCareCore.h>

@interface XZCareBaseTaskViewController () <UIViewControllerRestoration>
@property (strong, nonatomic) ORKStepViewController * stepVC;
@property (nonatomic, strong) ORKStep * step;
@property (nonatomic, strong) NSData * localRestorationData;
@end

@implementation XZCareBaseTaskViewController

#pragma  mark  -  Instance Initialisation
+ (instancetype)customTaskViewController: (XZCareCoreDBScheduledTask*) scheduledTask
{
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    id<ORKTask> task = [self createTask: scheduledTask];
    NSUUID * taskRunUUID = [NSUUID UUID];
    XZCareBaseTaskViewController * controller = task ? [[self alloc] initWithTask:task taskRunUUID:taskRunUUID] : nil;
//    controller.restorationIdentifier = [task identifier];
//    controller.restorationClass = self;
    controller.scheduledTask = scheduledTask;
    controller.delegate = controller;
    return  controller;
}

+ (id<ORKTask>)createTask: (XZCareCoreDBScheduledTask*) __unused scheduledTask
{
    //To be overridden by child classes
    return  nil;
}

- (NSString *) createResultSummary
{
    //To be overridden by child classes
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    if (self.outputDirectory == nil)
    {
        self.outputDirectory = [NSURL fileURLWithPath:self.taskResultsFilePath];
    }
    [super viewWillAppear:animated];
    XZCareLogViewControllerAppeared();
    XZCareLogEventWithData(kTaskEvent, (@{
                                       @"task_status":@"Started",
                                       @"task_title": (self.scheduledTask.task.taskTitle == nil) ? @"No Title Provided": self.scheduledTask.task.taskTitle,
                                       @"task_view_controller":NSStringFromClass([self class])
                                       }));
}
/*********************************************************************************/
#pragma mark - ORKOrderedTaskDelegate
/*********************************************************************************/
- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(nullable NSError *)error
{
    
    NSString *currentStepIdentifier = @"Step identifier not available";
    
    if ( self.currentStepViewController.step.identifier != nil)
    {
        currentStepIdentifier = self.currentStepViewController.step.identifier;
    }
    
    if (reason == ORKTaskViewControllerFinishReasonCompleted)
    {
        [self processTaskResult];
        
        [self.scheduledTask completeScheduledTask];
        XZCareCoreAppDelegate* appDelegate = (XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate.scheduler updateScheduledTasksIfNotUpdating:NO];
        [taskViewController dismissViewControllerAnimated:YES completion:nil];
        
        XZCareLogEventWithData(kTaskEvent, (@{
                                           @"task_status":@"ResultCompleted",
                                           @"task_title": self.scheduledTask.task.taskTitle,
                                           @"task_view_controller":NSStringFromClass([self class]),
                                           @"task_step" : currentStepIdentifier
                                           }));
    }
    else if (reason == ORKTaskViewControllerFinishReasonFailed)
    {
        if (error.code == 4 && error.domain == NSCocoaErrorDomain)
        {
            
        }
        else if (error.code == 260 && error.domain == NSCocoaErrorDomain)
        {
            //  Ignore this condition as it's due to no collected data.
        }
        else
        {
            [taskViewController dismissViewControllerAnimated:YES completion:nil];
            XZCareLogEventWithData(kTaskEvent, (@{
                                               @"task_status":@"ResultFailed",
                                               @"task_title": self.scheduledTask.task.taskTitle,
                                               @"task_view_controller":NSStringFromClass([self class]),
                                               @"task_step" : currentStepIdentifier
                                               }));
            

        }
        
        XZCareLogError2(error);
    }
    else if (reason == ORKTaskViewControllerFinishReasonDiscarded)
    {
        [taskViewController dismissViewControllerAnimated:YES completion:nil];
        XZCareLogEventWithData(kTaskEvent, (@{
                                           @"task_status":@"ResultDiscarded",
                                           @"task_title": self.scheduledTask.task.taskTitle,
                                           @"task_view_controller":NSStringFromClass([self class]),
                                           @"task_step" : currentStepIdentifier
                                           }));
    }
    else if (reason == ORKTaskViewControllerFinishReasonSaved)
    {
        [taskViewController dismissViewControllerAnimated:YES completion:nil];
        XZCareLogEventWithData(kTaskEvent, (@{
                                           @"task_status":@"ResultSaved",
                                           @"task_title": self.scheduledTask.task.taskTitle,
                                           @"task_view_controller":NSStringFromClass([self class]),
                                           @"task_step" : currentStepIdentifier
                                           }));
    }
    else
    {
        XZCareLogError2(error);
        XZCareLogEvent(@"The ORKTaskViewControllerFinishReason for this task is not set");
    }
}


- (NSString *)taskResultsFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [[paths lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.taskRunUUID.UUIDString]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError* fileError;
        BOOL     created = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                     withIntermediateDirectories:YES
                                                                      attributes:@{ NSFileProtectionKey : NSFileProtectionCompleteUntilFirstUserAuthentication }
                                                                           error:&fileError];
        
        if (created == NO)
        {
            XZCareLogError2 (fileError);
        }
    }
    
    return path;
}

- (ORKResult *) answerForSurveyStepIdentifier: (NSString*) identifier
{
    NSArray * stepResults = [(ORKStepResult*)[self.result resultForIdentifier:identifier] results];
    ORKStepResult *answer = (ORKStepResult *)[stepResults firstObject];
    return answer;
}

- (void) processTaskResult
{
    //Should be implemented in child classes
#ifdef DEBUG
    NSLog(@"XZCareBaseTaskViewController processTaskResult need real implementation in sub classes");
#endif
    NSString * szSummary = [self createResultSummary];
    
    if(self.scheduledTask.results != nil && 0 < self.scheduledTask.results.count)
    {
        NSArray *scheduledTaskResults = [self.scheduledTask.results allObjects];
        for (XZCareCoreDBResult *result in scheduledTaskResults)
        {
            if(result != nil)
            {
                result.resultSummary = szSummary;
                NSError * error;
                [result saveToPersistentStore:&error];
            }
        }
    }
    else
    {
        NSManagedObjectContext * context = [self.scheduledTask managedObjectContext];//((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.mainContext;
        NSManagedObjectID * objectID = [XZCareCoreDBResult storeTaskResult:self.result inContext:context];
        XZCareCoreDBResult * result = (XZCareCoreDBResult*)[context objectWithID:objectID];
        result.archiveFilename = @"";
        result.resultSummary = szSummary;
        result.scheduledTask = self.scheduledTask;
        self.scheduledTask.results = [NSSet setWithObject:result];
        NSError * error;
        [result saveToPersistentStore:&error];
    }
    self.scheduledTask.completed = @YES;
    return;
    //????

//    NSString * resultSummary = [self createResultSummary];
  
/*????
    XZCareDataArchiver * archiver = [[XZCareDataArchiver alloc] initWithTaskResult:self.result];
???*/
 
	/*
	 See comment at bottom of this method.
	 */
//	#ifdef USE_DATA_VERIFICATION_CLIENT

//????		archiver.preserveUnencryptedFile = YES;

//	#endif
/*????
    
    NSString * archiveFileName = [archiver writeToOutputDirectory:self.taskResultsFilePath];
    [self storeInCoreDataWithFileName:archiveFileName resultSummary:resultSummary];
???*/
	
	/*
	 This will COPY the unencrypted file to a local
	 server.  (The code above here uploads it to Sage.)
	 We're #if-ing it to make sure this code isn't
	 accessible to Bad Guys in production.  Even if
	 the code isn't called, if it's in RAM at all,
     it can be exploited.
	 */
//???	#ifdef USE_DATA_VERIFICATION_CLIENT

//???		[XZCareDataVerificationClient uploadDataFromFileAtPath: archiver.unencryptedFilePath];

//???	#endif
//    [self storeInCoreDataWithFileName:@"unencrypted.zip" resultSummary:resultSummary];

}

- (void) storeInCoreDataWithFileName: (NSString *) fileName resultSummary: (NSString *) resultSummary
{
    NSManagedObjectContext * context = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.mainContext;
    [self storeInCoreDataWithFileName: fileName resultSummary: resultSummary usingContext: context];
}

- (void) storeInCoreDataWithFileName: (NSString *) fileName
                       resultSummary: (NSString *) resultSummary
                        usingContext: (NSManagedObjectContext *) context
{
    NSManagedObjectID * objectID = [XZCareCoreDBResult storeTaskResult:self.result inContext:context];
    XZCareCoreDBResult * result = (XZCareCoreDBResult*)[context objectWithID:objectID];
    result.archiveFilename = fileName;
    result.resultSummary = resultSummary;
    result.scheduledTask = self.scheduledTask;
    NSError * error;
    [result saveToPersistentStore:&error];
    XZCareLogError2 (error);
    XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate;
    
/*???
#ifndef NOT_USE_BRIDGE
    [appDelegate.dataMonitor batchUploadDataToBridgeOnCompletion:^(NSError *error)
    {
        APCLogError2 (error);
    }];
#endif
?????
*/
    if (self.createResultSummaryBlock)
    {
        [appDelegate.dataMonitor performCoreDataBlockInBackground:self.createResultSummaryBlock];
    }
}

/*********************************************************************************/
#pragma mark - State Restoration
/*********************************************************************************/

-(void)stepViewControllerWillAppear:(ORKStepViewController *)viewController
{
    [super stepViewControllerWillAppear:viewController];
    self.localRestorationData = self.restorationData; //Cached to store during encode state
    
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_scheduledTask.objectID.URIRepresentation.absoluteString forKey:@"scheduledTask"];
    [coder encodeObject:_localRestorationData forKey:@"restorationData"];
    [coder encodeObject:self.task forKey:@"task"];
    [super encodeRestorableStateWithCoder:coder];
}

+ (UIViewController *) viewControllerWithRestorationIdentifierPath: (NSArray *) __unused identifierComponents
                                                             coder: (NSCoder *) coder
{
    id<ORKTask> task = [coder decodeObjectForKey:@"task"];
    NSString * scheduledTaskID = [coder decodeObjectForKey:@"scheduledTask"];
    NSManagedObjectID * objID = [((XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate).dataSubstrate.persistentStoreCoordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:scheduledTaskID]];
    XZCareCoreDBScheduledTask * scheduledTask = (XZCareCoreDBScheduledTask*)[((XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate).dataSubstrate.mainContext objectWithID:objID];
    id localRestorationData = [coder decodeObjectForKey:@"restorationData"];
    if (scheduledTask)
    {
        XZCareBaseTaskViewController * tvc =[[self alloc] initWithTask:task restorationData:localRestorationData delegate:nil];
        tvc.scheduledTask = scheduledTask;
        tvc.restorationIdentifier = [task identifier];
        tvc.restorationClass = self;
        tvc.delegate = tvc;
        return tvc;
    }
    return nil;
}

@end
