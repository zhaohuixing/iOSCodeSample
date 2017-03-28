// 
//  APCScheduler.m 
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

static NSString * const kOneTimeSchedule = @"once";

@interface XZCareScheduler()
@property  (weak, nonatomic)     XZCareDataSubstrate        *dataSubstrate;
@property  (strong, nonatomic)   NSManagedObjectContext  *scheduleMOC;
@property  (nonatomic) BOOL isUpdating;


@property (nonatomic, strong) NSDateFormatter * dateFormatter;

//Properties that need to be cleaned after every upate
@property (nonatomic, strong) NSMutableArray * allScheduledTasksForReferenceDate;
@property (nonatomic, strong) NSMutableArray * validatedScheduledTasksForReferenceDate;

@end

@implementation XZCareScheduler

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil)
    {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return _dateFormatter;
}

- (instancetype)initWithDataSubstrate: (XZCareDataSubstrate*) dataSubstrate
{
    self = [super init];
    if (self)
    {
        self.dataSubstrate = dataSubstrate;
        self.scheduleMOC = self.dataSubstrate.persistentContext;
    }
    return self;
}

- (void)updateScheduledTasksIfNotUpdating: (BOOL) today
{
    [self updateScheduledTasksIfNotUpdatingWithRange:today? kXZCareSchedulerDateRangeToday : kXZCareSchedulerDateRangeTomorrow];
}

-(void)updateScheduledTasksIfNotUpdatingWithRange:(XZCareSchedulerDateRange)range
{
    if (!self.isUpdating)
    {
        self.isUpdating = YES;
        switch (range)
        {
            case kXZCareSchedulerDateRangeYesterday:
                self.referenceRange = [XZCareDateRange yesterdayRange];
                break;
            case kXZCareSchedulerDateRangeToday:
                self.referenceRange = [XZCareDateRange todayRange];
                break;
                
            case kXZCareSchedulerDateRangeTomorrow:
                self.referenceRange = [XZCareDateRange tomorrowRange];
                break;
        }
        [self updateScheduledTasks];
    }
}

- (void) updateScheduledTasks
{
    [self.scheduleMOC performBlockAndWait:^{
        
        //STEP 1: Update inActive property of schedules based on endOn date.
        [self updateSchedulesAsInactiveIfNecessary];
        
        //STEP 2: Disable one time tasks if they are already completed
        [self disableOneTimeTasksIfAlreadyCompleted];
        
        //STEP 3: Get all the current scheduled tasks relevant to reference daterange
        [self filterAllScheduledTasksInReferenceDate];
        
        //STEP 4: Update scheduled tasks
        [self updateScheduledTasksBasedOnActiveSchedules];
        
        //STEP 5: Validate all completed tasks
        [self validateAllCompletedTasks];
        
        //STEP 6: Delete non-validated schedules
        [self deleteAllNonvalidatedScheduledTasks];
        
        //STEP 7: Issue notifications that we've completed a survey
        [[NSNotificationCenter defaultCenter]postNotificationName:XZCareUpdateTasksReminderNotification object:nil];
        
        self.isUpdating = NO;
        XZCareLogEventWithData(kSchedulerEvent, (@{@"event_detail":[NSString stringWithFormat:@"Updated Schedule For %@", self.referenceRange.startDate]}));
    }];
}

/*********************************************************************************/
#pragma mark - Methods Inside MOC
/*********************************************************************************/
- (void) updateSchedulesAsInactiveIfNecessary
{
    NSFetchRequest * request = [XZCareCoreDBSchedule request];
    NSDate * lastEndOnDate = [NSDate yesterdayAtMidnight];
    NSDate * earliestStartOnDate = [NSDate endOfDay:[NSDate tomorrowAtMidnight]];
    request.predicate = [NSPredicate predicateWithFormat:@"(endsOn <= %@) || (startsOn > %@)", lastEndOnDate, earliestStartOnDate];
    NSError * error;
    NSArray * array = [self.scheduleMOC executeFetchRequest:request error:&error];
    XZCareLogError2 (error);
    [array enumerateObjectsUsingBlock:^(XZCareCoreDBSchedule * schedule, NSUInteger __unused idx, BOOL * __unused stop)
    {
        schedule.inActive = @(YES);
        NSError * saveError;
        [schedule saveToPersistentStore:&saveError];
        XZCareLogError2 (saveError);
    }];
}

- (void) disableOneTimeTasksIfAlreadyCompleted
{
    //List remoteupdatable, one time tasks
    NSFetchRequest * request = [XZCareCoreDBSchedule request];
    request.predicate = [NSPredicate predicateWithFormat:@"remoteUpdatable == %@ && scheduleType == %@", @(YES), kOneTimeSchedule];
    NSError * error;
    NSArray * scheduleArray = [self.scheduleMOC executeFetchRequest:request error:&error];
    XZCareLogError2 (error);
    
    //Get completed scheduled tasks with that one time task. If they exist make the schedule inactive
    [scheduleArray enumerateObjectsUsingBlock:^(XZCareCoreDBSchedule * obj, NSUInteger __unused idx, BOOL * __unused stop)
    {
        NSFetchRequest * request = [XZCareCoreDBScheduledTask request];
        request.predicate = [NSPredicate predicateWithFormat:@"completed == %@ && task.taskID == %@", @(YES), obj.taskID];
        NSError * error;
        NSArray * scheduledTaskArray = [self.scheduleMOC executeFetchRequest:request error:&error];
        if (scheduledTaskArray.count > 0)
        {
            obj.inActive = @(YES);
        }
        XZCareLogError2 (error);
    }];
    
    XZCareCoreDBSchedule * lastSchedule = [scheduleArray lastObject];
    NSError * saveError;
    [lastSchedule saveToPersistentStore:&saveError];
    XZCareLogError2 (saveError);
}

- (void) filterAllScheduledTasksInReferenceDate
{
    NSFetchRequest * request = [XZCareCoreDBScheduledTask request];
    NSDate * startOfDay = [NSDate startOfDay:self.referenceRange.startDate];
    request.predicate = [NSPredicate predicateWithFormat:@"endOn > %@", startOfDay];
    NSError * error;
    NSArray * array = [self.scheduleMOC executeFetchRequest:request error:&error];
    XZCareLogError2 (error);
    NSMutableArray * filteredArray = [NSMutableArray array];
    
    for (XZCareCoreDBScheduledTask * scheduledTask in array)
    {
        if ([scheduledTask.dateRange compare:self.referenceRange] != kXZCareDateRangeComparisonOutOfRange)
        {
            [filteredArray addObject:scheduledTask];
        }
    }
    self.allScheduledTasksForReferenceDate = filteredArray;
}

- (void) updateScheduledTasksBasedOnActiveSchedules
{
    NSArray * activeSchedules = [self readActiveSchedules];
    [activeSchedules enumerateObjectsUsingBlock:^(XZCareCoreDBSchedule * schedule, NSUInteger __unused idx, BOOL * __unused stop)
    {
        [self updateScheduledTasksForSchedule:schedule];
    }];
}

- (NSArray*) readActiveSchedules
{
    NSFetchRequest * request = [XZCareCoreDBSchedule request];
    NSDate * lastStartOnDate = [NSDate startOfTomorrow:self.referenceRange.startDate];
    request.predicate = [NSPredicate predicateWithFormat:@"(inActive == nil || inActive == %@) && (startsOn == nil || startsOn < %@)", @(NO), lastStartOnDate];
    NSError * error;
    NSArray * array = [self.scheduleMOC executeFetchRequest:request error:&error];
    XZCareLogError2 (error);
    return array.count ? array : nil;
}

-(NSArray *) allScheduledTasks
{
    __block NSArray * scheduledTaskArray;
    NSFetchRequest * request = [XZCareCoreDBScheduledTask request];
    [request setShouldRefreshRefetchedObjects:YES];
    NSError * error;
    scheduledTaskArray = [self.scheduleMOC executeFetchRequest:request error:&error];
    if (scheduledTaskArray.count == 0) {
        XZCareLogError2 (error);
    }
    
    return scheduledTaskArray;
}


- (void) updateScheduledTasksForSchedule: (XZCareCoreDBSchedule*) schedule
{
    XZCareCoreDBTask * task = [XZCareCoreDBTask taskWithTaskID:schedule.taskID inContext:self.scheduleMOC];
    NSAssert(task,@"Task is nil");
    if (schedule.isOneTimeSchedule)
    {
        [self findOrCreateOneTimeScheduledTask:schedule task:task];
    }
    else
    {
        XZBaseScheduleExpression * scheduleExpression = schedule.scheduleExpression;
        NSDate * beginningTime = (schedule.expires !=nil) ? [self.referenceRange.startDate dateByAddingTimeInterval:(-1*schedule.expiresInterval)] : self.referenceRange.startDate;
        
        NSEnumerator*   enumerator = [scheduleExpression enumeratorBeginningAtTime:beginningTime endingAtTime:self.referenceRange.endDate];
        NSDate * startOnDate;
        while ((startOnDate = enumerator.nextObject))
        {
            XZCareDateRange * range;
            BOOL doFindOrCreate = NO;
            if (schedule.expires != nil)
            {
                range = [[XZCareDateRange alloc] initWithStartDate:startOnDate durationInterval:schedule.expiresInterval];
                if ([range compare:self.referenceRange] != kXZCareDateRangeComparisonOutOfRange)
                {
                    doFindOrCreate = YES;
                }
                else
                {
                    XZCareLogDebug(@"Created out of range dateRange: %@ for %@", range, task.taskTitle);
                }
            }
            else
            {
                range = [[XZCareDateRange alloc] initWithStartDate:startOnDate endDate:self.referenceRange.endDate];
                doFindOrCreate = YES;
            }
            if (doFindOrCreate)
            {
                [self findOrCreateRecurringScheduledTask:schedule task:task dateRange:range];
            }
        }
    }
}

- (void) validateAllCompletedTasks
{
    NSArray * filteredArray = [self.allScheduledTasksForReferenceDate filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"completed == %@", @YES]];
    
    [self.validatedScheduledTasksForReferenceDate addObjectsFromArray:filteredArray];
    [self.allScheduledTasksForReferenceDate removeObjectsInArray:filteredArray];
}

/*********************************************************************************/
#pragma mark - One Time Task Find Or Create
/*********************************************************************************/
- (void) findOrCreateOneTimeScheduledTask:(XZCareCoreDBSchedule *) schedule task: (XZCareCoreDBTask*) task
{
     NSArray * scheduledTasksArray = [[self allScheduledTasks] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"task.taskID == %@", task.taskID]];
    
    if (scheduledTasksArray.count > 0)
    {
        XZCareLogDebug(@"task already scheduled: %@", task);
        XZCareCoreDBScheduledTask * validatedTask = scheduledTasksArray.firstObject;
        [self validateScheduledTask:validatedTask];
    }
    else
    {
        //One time not created, create it        
        NSDate *startOnDate = [self.referenceRange.startDate startOfDay];
        
        NSDate * endDate = (schedule.expires !=nil) ? [startOnDate dateByAddingTimeInterval:schedule.expiresInterval] : [startOnDate dateByAddingTimeInterval:[NSDate parseISO8601DurationString:@"P2Y"]];
        endDate = [NSDate endOfDay:endDate];
        [self createScheduledTask:schedule task:task dateRange:[[XZCareDateRange alloc] initWithStartDate:startOnDate endDate:endDate]];
    }
}

- (void) findOrCreateOneTimeScheduledTask:(XZCareCoreDBSchedule *) schedule task: (XZCareCoreDBTask*) task andStartDateReference: (NSDate *)startOn
{
    
    NSArray * scheduledTasksArray = [[self allScheduledTasks] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"task.taskID == %@", task.taskID]];
    
    if (scheduledTasksArray.count > 0)
    {
        XZCareLogDebug(@"task already scheduled: %@", task);
        XZCareCoreDBScheduledTask * validatedTask = scheduledTasksArray.firstObject;
        [self validateScheduledTask:validatedTask];
    }
    else
    {
        //One time not created, create it
        NSDate *startOnDate = [startOn startOfDay];
        
        NSDate * endDate = (schedule.expires !=nil) ? [startOnDate dateByAddingTimeInterval:schedule.expiresInterval] : [startOnDate dateByAddingTimeInterval:[NSDate parseISO8601DurationString:@"P2Y"]];
        endDate = [NSDate endOfDay:endDate];
        [self createScheduledTask:schedule task:task dateRange:[[XZCareDateRange alloc] initWithStartDate:startOnDate endDate:endDate]];
    }
    
}

/*********************************************************************************/
#pragma mark - Recurring Task Find or Create
/*********************************************************************************/
- (void) findOrCreateRecurringScheduledTask: (XZCareCoreDBSchedule*) schedule task: (XZCareCoreDBTask*) task dateRange: (XZCareDateRange*) range
{
    NSArray * scheduledTasksArray = [self.allScheduledTasksForReferenceDate filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"task == %@", task]];
    
    NSMutableArray * filteredArray = [NSMutableArray array];
    [scheduledTasksArray enumerateObjectsUsingBlock:^(XZCareCoreDBScheduledTask * scheduledTask, NSUInteger __unused idx, BOOL * __unused stop) {
        if ([scheduledTask.dateRange compare:range] == kXZCareDateRangeComparisonSameRange)
        {
            [filteredArray addObject:scheduledTask];
        }
    }];
    
    if (filteredArray.count == 0)
    {
        //Schedule not created, create it
        [self createScheduledTask:schedule task:task dateRange:range];
    }
    else if (filteredArray.count == 1)
    {
        XZCareCoreDBScheduledTask * validatedTask = filteredArray.firstObject;
        [self validateScheduledTask:validatedTask];
    }
    else
    {
        XZCareLogError(@"Many recurring scheduled tasks %@ present with the exact same range: %@", task.taskTitle, range);
    }
}

/*********************************************************************************/
#pragma mark - Helpers
/*********************************************************************************/
- (void) createScheduledTask:(XZCareCoreDBSchedule*) schedule task: (XZCareCoreDBTask*) task dateRange: (XZCareDateRange*) dateRange
{
    XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSArray *offsetsForTask = [appDelegate offsetForTaskSchedules];
    
    XZCareCoreDBScheduledTask * createdScheduledTask = [XZCareCoreDBScheduledTask newObjectForContext:self.scheduleMOC];
    
    NSDate *taskStartDate = dateRange.startDate;
    NSDate *taskEndDate = dateRange.endDate;

    
    NSPredicate *predicate = nil;
    NSArray *matchedTasks = nil;
    NSNumber *daysToOffset = nil;
    NSString *currentTaskID = nil;
    NSDate *offsetStartDate = nil;
    NSDate *todaysDate = [NSDate todayAtMidnight];
    
    if (offsetsForTask)
    {
        predicate = [NSPredicate predicateWithFormat:@"%K == %@", kScheduleOffsetTaskIdKey, task.taskID];
        matchedTasks = [offsetsForTask filteredArrayUsingPredicate:predicate];
        daysToOffset = nil;
        
        if (matchedTasks.count > 0)
        {
            daysToOffset = [[matchedTasks firstObject] valueForKey:kScheduleOffsetOffsetKey];
            currentTaskID = [[matchedTasks firstObject] valueForKey:kScheduleOffsetTaskIdKey];
        }
        
    }
    
    if (daysToOffset)
    {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:[daysToOffset integerValue]];
        
        offsetStartDate = [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                                        toDate:task.createdAt
                                                                       options:0];
        
        offsetStartDate = [offsetStartDate startOfDay];
        
        XZCareLogDebug(@"Task %@ scheduled offset by %lu days. New start date is %@", task.taskTitle, [daysToOffset integerValue], taskStartDate);
    }
    
    if (([task.taskID isEqualToString:currentTaskID] && currentTaskID != nil)
        && (([offsetStartDate isEqualToDate:todaysDate]) ||
            ([[todaysDate laterDate:offsetStartDate] isEqualToDate:todaysDate])))
    {
        
        createdScheduledTask.startOn = taskStartDate;
        createdScheduledTask.endOn = taskEndDate;
        createdScheduledTask.generatedSchedule = schedule;
        createdScheduledTask.task = task;
        
        NSError * saveError = nil;
        BOOL saveSuccess = [createdScheduledTask saveToPersistentStore:&saveError];
        
        if (!saveSuccess)
        {
            XZCareLogError2 (saveError);
        }
        
        //Validate the task
        [self.validatedScheduledTasksForReferenceDate addObject:createdScheduledTask];
        
    }
    else if (daysToOffset == nil || daysToOffset <= 0)
    {
        createdScheduledTask.startOn = taskStartDate;
        createdScheduledTask.endOn = taskEndDate;
        createdScheduledTask.generatedSchedule = schedule;
        createdScheduledTask.task = task;
        
        NSError * saveError = nil;
        BOOL saveSuccess = [createdScheduledTask saveToPersistentStore:&saveError];
        
        if (!saveSuccess)
        {
            XZCareLogError2 (saveError);
        }
        
        //Validate the task
        [self.validatedScheduledTasksForReferenceDate addObject:createdScheduledTask];
    }
    else
    {
        XZCareLogDebug(@"Nothing should be happening here!");
    }
}

- (void) validateScheduledTask: (XZCareCoreDBScheduledTask*) scheduledTask
{
    [self.validatedScheduledTasksForReferenceDate addObject:scheduledTask];
    [self.allScheduledTasksForReferenceDate removeObject:scheduledTask];
}

- (void) deleteAllNonvalidatedScheduledTasks
{
    while (self.allScheduledTasksForReferenceDate.count)
    {
        XZCareCoreDBScheduledTask * task = [self.allScheduledTasksForReferenceDate lastObject];
        [self.allScheduledTasksForReferenceDate removeLastObject];
        [task deleteScheduledTask];
    }
}

@end
