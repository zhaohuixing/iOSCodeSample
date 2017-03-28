//
//  TCMCareGlucoseLevelsMealTimesViewController.h
//  TACMCareDiabeteCare
//
//
//  Created by Zhaohui Xing on 2015-05-25.
//  Copyright (c) 2015 E-XZCare. All rights reserved.

#import <UIKit/UIKit.h>

#import <XZCareCore/XZCareCore.h>

extern NSString *const kTimeOfDayBreakfast;
extern NSString *const kTimeOfDayLunch;
extern NSString *const kTimeOfDayDinner;
extern NSString *const kTimeOfDayBedTime;
extern NSString *const kTimeOfDayAfter;
extern NSString *const kTimeOfDayBefore;
extern NSString *const kTimeOfDayMorningFasting;
extern NSString *const kTimeOfDayOther;

extern NSString *const kGlucoseLevelTimeOfDayKey;
extern NSString *const kGlucoseLevelPeriodKey;
extern NSString *const kGlucoseLevelBeforeKey;
extern NSString *const kGlucoseLevelAfterKey;
extern NSString *const kGlucoseLevelScheduledHourKey;
extern NSString *const kGlucoseLevelValueKey;

@interface XZCareGlucoseLevelsMealTimesViewController : XZCareSignUpInfoViewController

@property (strong, nonatomic) NSString *pickedDays;
@property (nonatomic) BOOL isConfigureMode;

@end
