//
//  XZCareCoreDBSchedule.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-04.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XZCareCoreDBScheduledTask;

@interface XZCareCoreDBSchedule : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * endsOn;
@property (nonatomic, retain) NSString * expires;
@property (nonatomic, retain) NSNumber * inActive;
@property (nonatomic, retain) NSString * reminderMessage;
@property (nonatomic, retain) NSNumber * reminderOffset;
@property (nonatomic, retain) NSNumber * remoteUpdatable;
@property (nonatomic, retain) NSString * scheduleString;
@property (nonatomic, retain) NSString * scheduleType;
@property (nonatomic, retain) NSNumber * shouldRemind;
@property (nonatomic, retain) NSDate * startsOn;
@property (nonatomic, retain) NSString * taskID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *scheduleTasks;
@end

@interface XZCareCoreDBSchedule (CoreDataGeneratedAccessors)

- (void)addScheduleTasksObject:(XZCareCoreDBScheduledTask *)value;
- (void)removeScheduleTasksObject:(XZCareCoreDBScheduledTask *)value;
- (void)addScheduleTasks:(NSSet *)values;
- (void)removeScheduleTasks:(NSSet *)values;

@end
