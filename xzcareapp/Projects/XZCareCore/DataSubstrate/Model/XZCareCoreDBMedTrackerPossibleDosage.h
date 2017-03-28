//
//  XZCareCoreDBMedTrackerPossibleDosage.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-04.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <XZCareCore/XZCareCoreDBMedTrackerInflatableItem.h>

@class XZCareCoreDBMedTrackerPrescription;

@interface XZCareCoreDBMedTrackerPossibleDosage : XZCareCoreDBMedTrackerInflatableItem

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSSet *prescriptionsWhereIAmUsed;
@end

@interface XZCareCoreDBMedTrackerPossibleDosage (CoreDataGeneratedAccessors)

- (void)addPrescriptionsWhereIAmUsedObject:(XZCareCoreDBMedTrackerPrescription *)value;
- (void)removePrescriptionsWhereIAmUsedObject:(XZCareCoreDBMedTrackerPrescription *)value;
- (void)addPrescriptionsWhereIAmUsed:(NSSet *)values;
- (void)removePrescriptionsWhereIAmUsed:(NSSet *)values;

@end
