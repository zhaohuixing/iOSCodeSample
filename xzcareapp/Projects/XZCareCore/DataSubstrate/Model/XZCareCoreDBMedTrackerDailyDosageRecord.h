//
//  XZCareCoreDBMedTrackerDailyDosageRecord.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-04.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XZCareCoreDBMedTrackerPrescription;

@interface XZCareCoreDBMedTrackerDailyDosageRecord : NSManagedObject

@property (nonatomic, retain) NSDate * dateThisRecordRepresents;
@property (nonatomic, retain) NSNumber * numberOfDosesTakenForThisDate;
@property (nonatomic, retain) XZCareCoreDBMedTrackerPrescription *prescriptionIAmBasedOn;

@end
