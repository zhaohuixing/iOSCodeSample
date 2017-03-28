//
//  XZCareCoreDBTask.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-04.
//  Copyright (c) 2015 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XZCareCoreDBScheduledTask;

@interface XZCareCoreDBTask : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * taskClassName;
@property (nonatomic, retain) NSString * taskCompletionTimeString;
@property (nonatomic, retain) NSData * taskDescription;
@property (nonatomic, retain) NSString * taskHRef;
@property (nonatomic, retain) NSString * taskID;
@property (nonatomic, retain) NSString * taskTitle;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *scheduledTasks_unused;
@end

@interface XZCareCoreDBTask (CoreDataGeneratedAccessors)

- (void)addScheduledTasks_unusedObject:(XZCareCoreDBScheduledTask *)value;
- (void)removeScheduledTasks_unusedObject:(XZCareCoreDBScheduledTask *)value;
- (void)addScheduledTasks_unused:(NSSet *)values;
- (void)removeScheduledTasks_unused:(NSSet *)values;

@end
