//
//  XZCareCoreDBScheduledTask.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-04.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XZCareCoreDBResult, XZCareCoreDBSchedule, XZCareCoreDBTask;

@interface XZCareCoreDBScheduledTask : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * endOn;
@property (nonatomic, retain) NSDate * startOn;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) XZCareCoreDBSchedule *generatedSchedule;
@property (nonatomic, retain) NSSet *results;
@property (nonatomic, retain) XZCareCoreDBTask *task;
@end

@interface XZCareCoreDBScheduledTask (CoreDataGeneratedAccessors)

- (void)addResultsObject:(XZCareCoreDBResult *)value;
- (void)removeResultsObject:(XZCareCoreDBResult *)value;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;

@end
