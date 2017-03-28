//
//  XZCareCoreDBMedTrackerPrescription.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-04.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XZCareCoreDBMedTrackerDailyDosageRecord, XZCareCoreDBMedTrackerMedication, XZCareCoreDBMedTrackerPossibleDosage, XZCareCoreDBMedTrackerPrescriptionColor;

@interface XZCareCoreDBMedTrackerPrescription : NSManagedObject

@property (nonatomic, retain) NSDate * dateStartedUsing;
@property (nonatomic, retain) NSDate * dateStoppedUsing;
@property (nonatomic, retain) NSNumber * didStopUsingOnDoctorsOrders;
@property (nonatomic, retain) NSNumber * numberOfTimesPerDay;
@property (nonatomic, retain) NSString * zeroBasedDaysOfTheWeek;
@property (nonatomic, retain) NSSet *actualDosesTaken;
@property (nonatomic, retain) XZCareCoreDBMedTrackerPrescriptionColor *color;
@property (nonatomic, retain) XZCareCoreDBMedTrackerPossibleDosage *dosage;
@property (nonatomic, retain) XZCareCoreDBMedTrackerMedication *medication;
@end

@interface XZCareCoreDBMedTrackerPrescription (CoreDataGeneratedAccessors)

- (void)addActualDosesTakenObject:(XZCareCoreDBMedTrackerDailyDosageRecord *)value;
- (void)removeActualDosesTakenObject:(XZCareCoreDBMedTrackerDailyDosageRecord *)value;
- (void)addActualDosesTaken:(NSSet *)values;
- (void)removeActualDosesTaken:(NSSet *)values;

@end
