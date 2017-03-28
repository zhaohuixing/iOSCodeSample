//
//  XZCareCoreDBMedTrackerMedication.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-04.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <XZCareCore/XZCareCoreDBMedTrackerInflatableItem.h>

@class XZCareCoreDBMedTrackerPrescription;

@interface XZCareCoreDBMedTrackerMedication : XZCareCoreDBMedTrackerInflatableItem

@property (nonatomic, retain) NSSet *prescriptionsWhereIAmUsed;
@end

@interface XZCareCoreDBMedTrackerMedication (CoreDataGeneratedAccessors)

- (void)addPrescriptionsWhereIAmUsedObject:(XZCareCoreDBMedTrackerPrescription *)value;
- (void)removePrescriptionsWhereIAmUsedObject:(XZCareCoreDBMedTrackerPrescription *)value;
- (void)addPrescriptionsWhereIAmUsed:(NSSet *)values;
- (void)removePrescriptionsWhereIAmUsed:(NSSet *)values;

@end
