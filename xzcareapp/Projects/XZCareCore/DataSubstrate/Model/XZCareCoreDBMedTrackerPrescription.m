//
//  XZCareCoreDBMedTrackerPrescription.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-04.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import "XZCareCoreDBMedTrackerPrescription.h"
#import "XZCareCoreDBMedTrackerDailyDosageRecord.h"
#import "XZCareCoreDBMedTrackerMedication.h"
#import "XZCareCoreDBMedTrackerPossibleDosage.h"
#import "XZCareCoreDBMedTrackerPrescriptionColor.h"


@implementation XZCareCoreDBMedTrackerPrescription

@dynamic dateStartedUsing;
@dynamic dateStoppedUsing;
@dynamic didStopUsingOnDoctorsOrders;
@dynamic numberOfTimesPerDay;
@dynamic zeroBasedDaysOfTheWeek;
@dynamic actualDosesTaken;
@dynamic color;
@dynamic dosage;
@dynamic medication;

@end
