// 
//  APCTasksAndSchedulesMigrationUtility.m 
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
 
#import "XZCareTasksAndSchedulesMigrationUtility.h"

@implementation XZCareTasksAndSchedulesMigrationUtility

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tasksAndSchedules = [self sharedInit:kTasksAndSchedulesJSONFileName];
    }

    return self;
}

- (instancetype)initWithFileName:(NSString *)tasksAndSchedulesFileName
{
    self = [super init];
    if (self)
    {
        self.tasksAndSchedules = [self sharedInit:tasksAndSchedulesFileName];
    }
    
    return self;
}

- (NSDictionary *)sharedInit:(NSString *)tasksAndSchedulesFileName
{
    self.dataSubstrate  = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate;
    self.needsMigration = NO;
    
    NSString*       resource = [[NSBundle mainBundle] pathForResource:tasksAndSchedulesFileName ofType:@"json"];
    NSData*         jsonData = [NSData dataWithContentsOfFile:resource];
    NSError*        error;
    NSDictionary*   taskAndSchedules = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&error];
    
    if (taskAndSchedules == nil)
    {
        XZCareLogError(@"Empty or non-existent file");
    }
    
    XZCareLogError2 (error);
    
    return taskAndSchedules;
}

- (void)migrateScheduleAndTasks
{
    //TODO check for tasks that are in the datasubstrate
    /* Compare schedule expression if they exist */
    /* Delete if they exist in the datasubstrate and if they are no longer in the JSON */
    
    
    //TODO check for tasks in the dictionary that are not in the datasubstrate
    /* Create if they are in the JSON and do not exist in the datasubstrate */

    //    jsonDictionary[@"tasks"]
    //    jsonDictionary[@"schedules"]
    
    if (self.needsMigration)
    {
        [self.dataSubstrate loadStaticTasksAndSchedules:@{@"BLAH" : @"BLAH"}];
    }
}

// This will eventually become code
//- (void)modifyTask:(NSString *)taskIdentifier scheduleExpression:(NSString *)expression {
//    
//}
//
//- (void)deleteScheduledTask:(NSString *)taskIdentifier {
//    
//}
//
//- (void)createTaskAndSchedule:(NSDictionary *)taskAndSchedule {
//    
//}


@end
