// 
//  APCDataMonitor.m 
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


@interface XZCareDataMonitor ()

@end

@implementation XZCareDataMonitor

- (instancetype)initWithDataSubstrate:(XZCareDataSubstrate *)dataSubstrate  scheduler:(XZCareScheduler *)scheduler
{
    self = [super init];
    if (self)
    {
        self.dataSubstrate = dataSubstrate;
        self.scheduler = scheduler;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScheduledTasks) name:XZCareScheduleUpdatedNotification object:nil];
    }
    return self;
}

- (void) appFinishedLaunching
{
    if (self.dataSubstrate.currentUser.isConsented)
    {
        [(XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate setUpCollectors];
    }
    XZCareLogEventWithData(kAppStateChangedEvent, @{@"state":@"App Launched"});
}
- (void)appBecameActive
{
/*???
    [self refreshFromBridgeOnCompletion:^(NSError *error)
    {
        XZCareLogError2 (error);
        [self batchUploadDataToBridgeOnCompletion:^(NSError *error) {
            XZCareLogError2 (error);
        }];
    }];
??*/
    XZCareLogEventWithData(kAppStateChangedEvent, @{@"state":@"App Became Active"});
}

- (void) addDidEnterBackground
{
    XZCareLogEventWithData(kAppStateChangedEvent, @{@"state":@"App Did Enter Background"});
}

- (void) userConsented
{
    [(XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate setUpCollectors];
    [self.scheduler updateScheduledTasksIfNotUpdatingWithRange:kXZCareSchedulerDateRangeToday];
    [self.scheduler updateScheduledTasksIfNotUpdatingWithRange:kXZCareSchedulerDateRangeTomorrow];
//???    [self refreshFromBridgeOnCompletion:^(NSError *error) {
//??        XZCareLogError2 (error);
        //??????[self batchUploadDataToBridgeOnCompletion:NULL];
//???    }];
}

- (void) updateScheduledTasks
{
    [self.scheduler updateScheduledTasksIfNotUpdatingWithRange:kXZCareSchedulerDateRangeToday];
    [self.scheduler updateScheduledTasksIfNotUpdatingWithRange:kXZCareSchedulerDateRangeTomorrow];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)performCoreDataBlockInBackground:(void (^)(NSManagedObjectContext *))coreDataBlock
{
    NSManagedObjectContext * privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    privateContext.parentContext = self.dataSubstrate.persistentContext;
    [privateContext performBlock:^{
        if (coreDataBlock)
        {
            coreDataBlock(privateContext);
        }
    }];
}

@end
