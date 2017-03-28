//
//  TCMCareOneDownTimesViewController.h
//  TACMCareDiabeteCare
//
//
//  Created by Zhaohui Xing on 2015-05-25.
//  Copyright (c) 2015 E-XZCare. All rights reserved.

#import <UIKit/UIKit.h>

#import <XZCareCore/XZCareCore.h>

extern NSString *const kOneDownBreakfastTime;
extern NSString *const kOneDownLunchTime;
extern NSString *const kOneDownSupperTime;

extern NSString *const kOneDownTimeOfDayKey;

extern NSString *const kOneDownTimePeriodKey;
extern NSString *const kOneDownTimeBreakfastKey;
extern NSString *const kOneDownTimeLunchKey;
extern NSString *const kOneDownTimeSupperKey;

@interface XZCareOneDownMedicineTimesViewController : XZCareSignUpInfoViewController

@property (strong, nonatomic) NSString *pickedDays;
@property (nonatomic) BOOL isConfigureMode;

@end
