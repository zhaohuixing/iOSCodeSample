//
//  XZCareAppConstants.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-23.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#ifndef __XZCAREONEDOWNCONSTANTS_H__
#define __XZCAREONEDOWNCONSTANTS_H__
#import <XZCareCore/XZCareConstants.h>

/*********************************************************************************/
#pragma mark - Survey Identifiers
/*********************************************************************************/
#define kDailySleepCheckSurveyIdentifier      @"xxxxxx"
#define kDailyFeetCheckSurveyIdentifier      @"xxxxxx"

#define kWeeklyCheckSurveyIdentifier     @"xxxxxx"
#define kWaistCheckSurveyIdentifier      @"xxxxxx"
#define kWeightCheckSurveyIdentifier     @"xxxxxx"
#define kFoodLogSurveyIdentifier         @"xxxxxx"

//Add medicine
#define kDrugLogSurveyIdentifier         @"xxxxxx"


#define kOneDownMorningLogIdentifier            @"xxxxxx"
#define kOneDownNoonLogIdentifier               @"xxxxxx"
#define kOneDownEveningLogIdentifier            @""

#define kXZCareHerbOneDownLogIdentifier         @"xxxxxx"
#define kXZCareHerbIRRTeaLogIdentifier          @"xxxxxx"
#define kXZCareHerbThreeDownLogIdentifier       @"xxxxxx"
#define kXZCareHerbEnergyCalmLogIdentifier     @"xxxxxx"

#define kSevenDayAllocationIdentifier    @"xxxxxx"
#define kBaselineSurveyIdentifier        @"xxxxxx"
#define kSleepSurveyIdentifier           @"xxxxxx"
#define kQualityOfLifeSurveyIdentifier   @"xxxxxx"

#define kFeetCheckStepIdentifier               @"XZCare_Foot_Check"
#define kSleepCheckStepIdentifier               @"XZCare_Sleep_Time"

#define kFeetCheckResultValueKey               kFeetCheckStepIdentifier
#define kSleepCheckResultValueKey              kSleepCheckStepIdentifier

#define kWaistStepIntroKey              @"xxxxxx"
#define kWaistStep101Key                @"Waist_Step_101"
#define kWaistStep102Key                @"Waist_Step_102"
#define kWaistResultDateKey             @"waistResultDateKey"
#define kWaistResultValueKey            @"waistResultValueKey"

#define kOneDownDosageResultValueKey            @"xxxxxx"

#define kBloodPressureCheckIdentifier       @"xxxxxx"
#define kSystolicResultValueKey             @"SystolicResultValueKey"
#define kDiastolicResultValueKey            @"DiastolicResultValueKey"

#define kWeightResultValueKey               @"kWeightResultValueKey"

#define kMultipleSurveyStepTaskTotalValueKey               @"multipleSurveyStepTaskTotalValueKey"


/*********************************************************************************/
#pragma mark - Initializations Options
/*********************************************************************************/
#define kStudyIdentifier                 @"studyname"
#define kAppPrefix                       @"studyname"
#define kConsentPropertiesFileName       @"xxxxxx"

#define kJSONScheduleStringKey           @"scheduleString"
#define kJSONTasksKey                    @"tasks"
#define kJSONScheduleTaskIDKey           @"taskID"
#define kJSONSchedulesKey                @"schedules"

#define kVideoShownKey                   @"VideoShown"


#define kOneDownDashboardStoryboard                   @"xxxxxx"

typedef NS_ENUM(XZCareTableViewItemType, XZCareDashboardItemType)
{
    kAPHDashboardItemTypeGlucose,
    kAPHDashboardItemTypeWeight,
    kAPHDashboardItemTypeWaist,
    kAPHDashboardItemTypeSystolic,
    kAPHDashboardItemTypeDiastolic,
    kAPHDashboardItemTypeCarbohydrate,
    kAPHDashboardItemTypeSugar,
    kAPHDashboardItemTypeSteps,
    kAPHDashboardItemTypeCalories,
    kAPHDashboardItemTypeAlerts,
    kAPHDashboardItemTypeInsights,
    kAPHDashboardItemTypeFitness,
    kAPHDashboardItemTypeGlucoseInsights,
    kAPHDashboardItemTypeDietInsights,
    kAPHDashboardItemTypeSevenDayFitness,
//    kAPHDashboardItemTypeOneDown
    
    kAPHDashboardItemTypeDailySleep,
    kAPHDashboardItemTypeDailyFeet,
    
    kAPHDashboardItemTypeOneDownMorning,
    kAPHDashboardItemTypeOneDownNoon,
    kAPHDashboardItemTypeOneDownEvening,

    kAPHDashboardItemTypeOneDownDaily,
    kAPHDashboardItemTypeIRRTeaDaily,
    kAPHDashboardItemTypeEnergyCalmDaily,
    kAPHDashboardItemTypeThreeDownDaily
};


#endif
