//
//  XZCareConstants.h
//  XZCareCore
//
//  Created by Zhaohui Xing on 2015-07-15.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#ifndef __XZCARECONSTANTS_H__
#define __XZCARECONSTANTS_H__

#import <Foundation/Foundation.h>
#import "XZCareConfigure.h"

// ---------------------------------------------------------
//Notification constants
// ---------------------------------------------------------

#define XZCareUserSignedUpNotification                                  @"XZCareUserSignedUpNotification"
#define XZCareUserSignedInNotification                                  @"XZCareUserSignedInNotification"
#define XZCareUserLogOutNotification                                    @"XZCareUserLogOutNotification"
#define XZCareUserWithdrawStudyNotification                             @"XZCareUserWithdrawStudyNotification"
#define XZCareUserDidConsentNotification                                @"XZCareUserDidConsentNotification"

#define XZCareScheduleUpdatedNotification                               @"XZCareScheduleUpdatedNotification"
#define XZCareUpdateActivityNotification                                @"XZCareUpdateActivityNotification"
#define XZCareDayChangedNotification                                    @"XZCareDayChangedNotification"

#define XZCareAppDidRegisterUserNotification                            @"XZCareAppDidRegisterUserNotification"
#define XZCareAppDidFailToRegisterForRemoteNotification                 @"XZCareAppDidFailToRegisterForRemoteNotifications"

#define XZCareScoringHealthKitDataIsAvailableNotification               @"XZCareScoringHealthKitDataIsAvailableNotification"
#define XZCareTaskResultsProcessedNotification                          @"XZCareTaskResultsProcessedNotification"

#define XZCareUpdateTasksReminderNotification                           @"XZCareUpdateTasksReminderNotification"

#define XZCareConsentCompletedWithDisagreeNotification                  @"goToSignInJoinScreen"

#define XZCareMotionHistoryReporterDoneNotification                     @"XZCareMotionHistoryReporterDoneNotification"

#define XZCareHealthKitObserverQueryUpdateForSampleTypeNotification     @"XZCareHealthKitObserverQueryUpdateForSampleTypeNotification"


//
// Keys constants
//
#define kStudyIdentifierKey                                     @"XZCare_StudyIdentifierKey"
#define kAppPrefixKey                                           @"XZCare_AppPrefixKey"
#define kBridgeEnvironmentKey                                   @"XZCare_BridgeEnvironmentKey"
#define kDatabaseNameKey                                        @"XZCare_DatabaseNameKey"
#define kTasksAndSchedulesJSONFileNameKey                       @"XZCare_TasksAndSchedulesJSONFileNameKey"
#define kConsentSectionFileNameKey                              @"XZCare_ConsentSectionFileNameKey"
#define kHKWritePermissionsKey                                  @"XZCare_HKWritePermissions"
#define kHKReadPermissionsKey                                   @"XZCare_HKReadPermissions"
#define kAppServicesListRequiredKey                             @"XZCare_AppServicesListRequired"
#define kAppServicesDescriptionsKey                             @"XZCare_AppServicesDescriptions"
#define kAppProfileElementsListKey                              @"XZCare_AppProfileElementsListKey"
#define kVideoURLKey                                            @"XZCare_VideoURLKey"
#define kTaskReminderStartupDefaultOnOffKey                     @"XZCare_TaskReminderStartupDefaultOnOffKey"
#define kTaskReminderStartupDefaultTimeKey                      @"XZCare_TaskReminderStartupDefaultTimeKey"
#define kDelayReminderIdentifier                                @"XZCare_DelayReminderIdentifier"
#define kTaskReminderDelayCategory                              @"XZCare_DelayCategory"
#define kDBStatusVersionKey                                     @"XZCare_DBStatusVersionKey"
#define kShareMessageKey                                        @"XZCare_ShareMessageKey"

#define kHKQuantityTypeKey                                      @"XZCare_HKQuantityType"
#define kHKCategoryTypeKey                                      @"XZCare_HKCategoryType"
#define kHKCharacteristicTypeKey                                @"XZCare_HKCharacteristicType"
#define kHKCorrelationTypeKey                                   @"XZCare_HKCorrelationType"
#define kHKWorkoutTypeKey                                       @"XZCare_kHKWorkoutTypeKey"


#define kPasswordKey                                            @"XZCare_Password"

#define kHairlineEnDashJoinerKey                                @"\u200a\u2013\u200a"

#define kTasksReminderDefaultsOnOffKey                          @"XZCare_TasksReminderDefaultsOnOffKey"
#define kTasksReminderDefaultsTimeKey                           @"XZCare_TasksReminderDefaultsTimeKey"

#define kScheduleOffsetTaskIdKey                                @"XZCare_scheduleOffsetTaskIdKey"
#define kScheduleOffsetOffsetKey                                @"XZCare_scheduleOffsetOffsetKey"


#define kXZCareStudyLandingCollectionViewCellIdentifier                  @"XZCareStudyLandingCollectionViewCell"
#define kXZCareStudyVideoCollectionViewCellIdentifier                    @"XZCareStudyVideoCollectionViewCell"

#define kDatasetDateKey                                                     @"datasetDateKey"
#define kDatasetValueKey                                                    @"datasetValueKey"
#define kDatasetRangeValueKey                                               @"datasetRangeValueKey"
#define kDatasetRawDataKey                                                  @"datasetRawData"
#define kDatasetSegmentNameKey                                  @"datasetSegmentNameKey"
#define kDatasetSegmentColorKey                                 @"datasetSegmentColorKey"
#define kDatasetSegmentKey                                      @"segmentKey"
#define kDatasetDateHourKey                                     @"dateHourKey"
#define kSegmentSumKey                                          @"segmentSumKey"
#define kSevenDayFitnessStartDateKey                            @"sevenDayFitnessStartDateKey"
#define kDataset7DayDateKey                                     @"datasetDateKey"
#define kDataset7DayValueKey                                    @"datasetValueKey"

#define kDatasetDateKeyFormat                                   @"YYYY-MM-dd-hh"

#define XZCareSevenDayAllocationDataIsReadyNotification             @"XZCareSevenDayAllocationDataIsReadyNotification"
#define XZCareSevenDayAllocationSleepDataIsReadyNotification        @"XZCareSevenDayAllocationSleepDataIsReadyNotification"
#define XZCareSevenDayAllocationHealthKitDataIsReadyNotification    @"XZCareSevenDayAllocationHealthKitIsReadyNotification"

//
//Storyboard names
//
#define kXZCareCoreTabBarStoryboard                             @"XZCareCoreTabBar"
#define kXZCareCoreStudyOverviewStoryboardOld                   @"XZCareStudyOverviewOld"
#define kXZCareCoreStudyOverviewStoryboard                      @"XZCareStudyOverview"
#define kXZCareCoreParametersStoryboard                         @"XZCareParameters"
#define kXZCareCoreSpinnerViewControllerXIB                     @"XZCareSpinnerViewController"

//
//
//
#define kOnboardingStoryboardName                               @"XZCareOnboarding"

#define kXZCareCoreStudyOverviewControlIdentifier               @"CaseStudyOverviewController"
#define kXZCareCoreParametersControlIdentifier                  @"ParametersViewController"

#define kXZCareTintedTableViewCellIdentifier                    @"XZCareTintedTableViewCell"

#define kXZCareActivitiesSectionHeaderViewIdentifier            @"XZCareActivitiesSectionHeaderView"
#define kXZCareActivitiesTintedTableViewCellIdentifier          @"XZCareActivitiesTintedTableViewCell"
#define kXZCareActivitiesBasicTableViewCellIdentifier           @"XZCareActivitiesBasicTableViewCell"
#define kXZCareActivitiesIconTableViewCellIdentifier            @"XZCareActivitiesIconTableViewCell"

#define kXZCareDashboardEditTableViewCellIdentifier             @"XZCareDashboardEditTableViewCell"
#define kXZCareDashboardGraphTableViewCellIdentifier            @"XZCareDashboardLineGraphTableViewCell"
#define kXZCareDashboardMessageTableViewCellIdentifier          @"XZCareDashboardMessageTableViewCell"
#define kXZCareDashboardPieGraphTableViewCellIdentifier         @"XZCareDashboardPieGraphTableViewCell"
#define kXZCareDashboardProgressTableViewCellIdentifier         @"XZCareDashboardProgressTableViewCell"

#define kXZCareAddressTableViewCellIdentifier                   @"XZCareAddressTableViewCell"
#define kXZCareCheckTableViewCellIdentifier                     @"XZCareCheckTableViewCell"
#define kXZCareDefaultTableViewCellIdentifier                   @"XZCareDefaultTableViewCell"
#define kSignUpPermissionsCellIdentifier                        @"XZCarePermissionsCell"

#define kXZCareSegmentedTableViewCellIdentifier                 @"XZCareSegmentedTableViewCell"

#define kXZCareShareTableViewCellIdentifier                     @"ShareTableViewCellIdentifier"
#define kXZCareSwitchCellIdentifier                             @"XZCareSwitchTableViewCell"
#define kXZCareTextFieldTableViewCellIdentifier                 @"XZCareTextFieldTableViewCell"


#define kXZCareBasicTableViewCellIdentifier                     @"XZCareBasicTableViewCell"
#define kXZCareRightDetailTableViewCellIdentifier               @"XZCareRightDetailTableViewCell"
#define kSharingOptionsTableViewCellIdentifier                  @"SharingOptionsTableViewCell"

#define kGlucoseLogSurveyIdentifier                             @"XZCareLog3_Glucose-42449E07-7124-40EF-AC93-CA5BBF95FC15"


//
//
//
#define kXZCareUserInfoFieldNameRegEx               @"[A-Za-z\\ ]+"
#define kXZCareGeneralInfoItemUserNameRegEx         @"[A-Za-z0-9_.]+"
#define kXZCareGeneralInfoItemEmailRegEx            @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define kXZCareMedicalInfoItemWeightRegEx           @"[0-9]{1,4}"
#define kXZCareMedicalInfoItemNumericRegEx           @"[0-9]{1,4}"
#define kXZCareMedicalInfoItemSleepTimeFormat       @"hh:mm a"
#define kXZCareAppStateKey                          @"XZCareAppState"


/**
 These constants are used by a couple of different classes
 which prepare stuff for me to serialize.
 
 Imported (stolen, duplicated) from APCDataArchiver.
 Working on normalizing that.
 
 Publicly-declared constants (in my header file).
 
 These constants are used by a couple of different classes
 which prepare stuff for me to serialize.
 
 Imported (stolen, duplicated) from APCDataArchiver.
 Working on normalizing that.
 */
#define kXZCareSerializedDataKey_QuestionType            @"questionType"
#define kXZCareSerializedDataKey_QuestionTypeName        @"questionTypeName"
#define kXZCareSerializedDataKey_UserInfo                @"userInfo"
#define kXZCareSerializedDataKey_Identifier              @"identifier"
#define kXZCareSerializedDataKey_Item                    @"item"
#define kXZCareSerializedDataKey_TaskRun                 @"taskRun"
#define kXZCareSerializedDataKey_Files                   @"files"
#define kXZCareSerializedDataKey_AppName                 @"appName"
#define kXZCareSerializedDataKey_AppVersion              @"appVersion"
#define kXZCareSerializedDataKey_FileInfoName            @"filename"
#define kXZCareSerializedDataKey_FileInfoTimeStamp       @"timestamp"
#define kXZCareSerializedDataKey_FileInfoContentType     @"contentType"


#define kXZCareDashboardRowItemsOrder                       @"DashboardRowItemsOrder"






/**
 We use this regular-expression pattern to extract UUIDs
 from CoreData object IDs.
 */
#define kRegularExpressionPatternMatchingUUIDs              (@"[a-fA-F0-9]{8}\\-"  \
                                                             "[a-fA-F0-9]{4}\\-"   \
                                                             "[a-fA-F0-9]{4}\\-"   \
                                                             "[a-fA-F0-9]{4}\\-"   \
                                                             "[a-fA-F0-9]{12}")    

//
//
//
#define kXZCareAppCoreBundleID                                  @"com.xz-care.XZCareCore"


#define kIndexOfProfileTab                              3
#define kIndexOfActivitesTab                            0
#define kXZCareSignUpProgressBarHeight                14.0f
#define kXZCarePasswordMinimumLength                    2
#define kNumberOfDaysToDisplay                          7                    

#define kTheEntireDataModelOfTheApp                     0 //3


#define kXZCareGlucoseLevelMinValue                         90
#define kXZCareGlucoseLevelMaxValue                         500
#define kXZCareSystolicValueMinValue                        70
#define kXZCareSystolicValueMaxValue                        190
#define kXZCareDiastolicValueMinValue                       40
#define kXZCareDiastolicValueMaxValue                       100


//
//
//

#define kTasksAndSchedulesJSONFileName                          @"XZCareTasksAndSchedules"




// ---------------------------------------------------------
#pragma mark - Events
// ---------------------------------------------------------
#define kAppStateChangedEvent    @"XZCare_AppStateChanged"
#define kNetworkEvent            @"XZCare_NetworkEvent"
#define kSchedulerEvent          @"XZCare_SchedulerEvent"
#define kTaskEvent               @"XZCare_TaskEvent"
#define kPageViewEvent           @"XZCare_PageViewEvent"
#define kErrorEvent              @"XZCare_ErrorEvent"
#define kPassiveCollectorEvent   @"XZCare_PassiveCollectorEvent"


// ---------------------------------------------------------
#pragma mark - Insight string
// ---------------------------------------------------------
#define kInsightKeyGoodDayValue                 @"insightKeyGoodDayValue"
#define kInsightKeyGlucoseGoodDayValue          @"insightKeyGlucoseGoodDayValue"
#define kInsightKeyGlucoseBadDayValue           @"insightKeyGlucoseBadDayValue"
#define kInsightKeyBadDayValue                  @"insightKeyBadDayValue"

#define kXZCareInsightFactorValueKey            @"insightFactorValueKey"
#define kXZCareInsightFactorNameKey             @"insightFactorNameKey"

#define kXZCareInsightSampleTypeKey             @"insightSampleTypeKey"
#define kXZCareInsightSampleUnitKey             @"insightSampleUnitKey"

#define kInsightDatasetIsGoodDayKey             @"insightDatasetIsGoodDayKey"
#define kInsightDatasetAverageReadingKey        @"insightDatasetAverageReadingKey"
#define kInsightDatasetDayAverage               @"insightDatasetDayAverage"
#define kInsightDatasetHighKey                  @"insightDatasetHighKey"
#define kInsightDatasetLowKey                   @"InsightDatasetLowKey"

#define kXZCareInsightDataCollectionIsCompletedNotification         @"XZCareInsightDataCollectionIsCompletedNotification"


#define kLoseItBundleIdentifier             @"com.fitnow.loseit"
#define kLoseItFoodImageNameKey             @"HKFoodImageName"

#define kFoodInsightFoodNameKey             @"foodNameKey"
#define kFoodInsightFoodGenericNameKey      @"foodGenericNameKey"
#define kFoodInsightValueKey                @"foodValueKey"
#define kFoodInsightCaloriesValueKey        @"foodCaloriesValueKey"
#define kFoodInsightFrequencyKey            @"foodFrequencyKey"
#define kFoodInsightUUIDKey                 @"foodUUIDKey"
#define kFoodInsightSugarCaloriesValueKey   @"sugarCaloriesValueKey"

#define kXZCareFoodInsightDataCollectionIsCompletedNotification  @"XZCareFoodInsightDataCollectionIsCompletedNotification"

// ---------------------------------------------------------
#pragma mark - Scoring string
// ---------------------------------------------------------
#define kDatasetSortKey         @"datasetSortKey"
#define kDatasetValueKindKey    @"datasetValueKindKey"
#define kDatasetValueNoDataKey  @"datasetValueNoDataKey"
#define kDatasetGroupByDay      @"datasetGroupByDay"
#define kDatasetGroupByWeek     @"datasetGroupByWeek"
#define kDatasetGroupByMonth    @"datasetGroupByMonth"
#define kDatasetGroupByYear     @"datasetGroupByYear"


/*********************************************************************************/
#pragma mark - Tab bar Constants
/*********************************************************************************/
#define kDashBoardStoryBoardKey         @"XZCareOnboarding"
#define kLearnStoryBoardKey             @"XZCareLearn"
#define kActivitiesStoryBoardKey        @"XZCareActivities"
#define kHealthProfileStoryBoardKey     @"XZCareProfile"


/*********************************************************************************/
#pragma mark - User Defaults Keys
/*********************************************************************************/
#define kDemographicDataWasUploadedKey    @"kDemographicDataWasUploadedKey"
#define kLastUsedTimeKey                  @"XZCareLastUsedTime"
#define kAppWillEnterForegroundTimeKey    @"XZCareWillEnterForegroundTime"

//
//
//
#define kFinishedProperty           @"finished"

//
//Onboarding teask ids
//
#define kXZCareSignUpInclusionCriteriaStepIdentifier   @"InclusionCriteria"
#define kXZCareSignUpEligibleStepIdentifier            @"Eligible"
#define kXZCareSignUpIneligibleStepIdentifier          @"Ineligible"
#define kXZCareSignUpGeneralInfoStepIdentifier         @"GeneralInfo"
#define kXZCareSignUpMedicalInfoStepIdentifier         @"MedicalInfo"
#define kXZCareSignUpCustomInfoStepIdentifier          @"CustomInfo"
#define kXZCareSignUpPasscodeStepIdentifier            @"Passcode"
#define kXZCareSignUpPermissionsStepIdentifier         @"Permissions"
#define kXZCareSignUpThankYouStepIdentifier            @"ThankYou"
#define kXZCareSignInStepIdentifier                    @"SignIn"
#define kXZCareSignUpPermissionsPrimingStepIdentifier  @"PermissionsPriming"


#define kReviewConsentActionPDF                         @"PDF"
#define kReviewConsentActionVideo                       @"VIDEO"
#define kReviewConsentActionSlides                      @"SLIDES"


#define kAllSetActivitiesTextOriginal                   @"XZCare_allSetActivitiesTextOriginal"
#define kAllSetActivitiesTextAdditional                 @"XZCare_allSetActivitiesTextAdditional"
#define kAllSetDashboardTextOriginal                    @"XZCare_allSetDashboardTextOriginal"
#define kAllSetDashboardTextAdditional                  @"XZCare_allSetDashboardTextAdditional"
#define kActivitiesSectionKeepGoing                     @"XZCare_activitiesSectionKeepGoing"
#define kActivitiesSectionYesterday                     @"XZCare_activitiesSectionYesterday"
#define kActivitiesSectionToday                         @"XZCare_activitiesSectionToday"
#define kActivitiesRequiresMotionSensor                 @"XZCare_activitiesRequireMotionSensor"


#define XZCAREPATIENTPREFIX                             @"XZCare_Patient_"

#define kXZCarePreviousVersionKey                       @"previousVersion"


/*********************************************************************************/
#pragma mark - Initializations Option Defaults
/*********************************************************************************/
static NSString*    const kDataSubstrateClassName           = @"XZCareDataSubstrate"; //Not used in this app!!
static NSString*    const kDatabaseName                     = @"xzcarecodedb.sqlite";
static NSString*    const kConsentSectionFileName           = @"XZCareConsentSection";
static NSString*    const kDBStatusCurrentVersion           = @"v1.0.0.0";



//
//??
//
/*
 
typedef NSUInteger XZCareTableViewItemType;

typedef NS_ENUM(XZCareTableViewItemType, XZCareTableViewStudyItemType)
{
    kXZCareTableViewStudyItemTypeStudyDetails,
    kXZCareTableViewStudyItemTypeShare,
    kXZCareTableViewStudyItemTypeReviewConsent
};

typedef NS_ENUM(XZCareTableViewItemType, XZCareTableViewLearnItemType)
{
    kXZCareTableViewLearnItemTypeStudyDetails,
    kXZCareTableViewLearnItemTypeOtherDetails,
    kXZCareTableViewLearnItemTypeReviewConsent,
    kXZCareTableViewLearnItemTypeShare,
};


typedef NS_ENUM(NSUInteger, XZCareStepProgressBarStyle)
{
    XZCareStepProgressBarStyleDefault = 0,
    XZCareStepProgressBarStyleOnlyProgressView
};
*/
 
typedef NS_ENUM(NSUInteger, XZCareDateRangeComparison)
{
    kXZCareDateRangeComparisonSameRange,
    kXZCareDateRangeComparisonWithinRange,
    kXZCareDateRangeComparisonOutOfRange
};


typedef NS_ENUM(NSInteger, XZCareUserConsentSharingScope)
{
    XZCareUserConsentSharingScopeNone = 0,
    XZCareUserConsentSharingScopeStudy,
    XZCareUserConsentSharingScopeAll,
};

typedef NS_ENUM(NSUInteger, XZCareSchedulerDateRange)
{
    kXZCareSchedulerDateRangeYesterday,
    kXZCareSchedulerDateRangeToday,
    kXZCareSchedulerDateRangeTomorrow
};



typedef NS_ENUM(NSUInteger, XZCareAppState)
{
    kXZCareAppStateNotConsented,
    kXZCareAppStateConsented
};

typedef NS_ENUM(NSInteger, XZCarePatientActivityType)
{
    XZCarePatientActivityTypeStationary = 1,
    XZCarePatientActivityTypeWalking,
    XZCarePatientActivityTypeRunning,
    XZCarePatientActivityTypeAutomotive,
    XZCarePatientActivityTypeCycling,
    XZCarePatientActivityTypeUnknown,
    XZCarePatientActivityTypeSleeping,
    XZCarePatientActivityTypeLight,
    XZCarePatientActivityTypeModerate,
    XZCarePatientActivityTypeSedentary
};

typedef NS_ENUM(NSUInteger, XZCareInsightFactors)
{
    XZCareInsightFactorActivity = 0,
    XZCareInsightFactorCalories,
    XZCareInsightFactorSteps,
    XZCareInsightFactorSugarConsumption,
    XZCareInsightFactorSugarCalories,
    XZCareInsightFactorTimeSlept,
    XZCareInsightFactorCarbohydrateConsumption,
    XZCareInsightFactorCarbohydrateCalories
};

typedef NS_ENUM(NSUInteger, XZCareTintColorType)
{
    kXZCareTintColorTypeGreen,
    kXZCareTintColorTypeRed,
    kXZCareTintColorTypeYellow,
    kXZCareTintColorTypePurple,
    kXZCareTintColorTypeBlue
};

/*
 
typedef NS_ENUM(NSUInteger, XZCareDefaultTableViewCellType)
{
    kXZCareDefaultTableViewCellTypeLeft,
    kXZCareDefaultTableViewCellTypeRight,
};

*/
/*

typedef NS_ENUM(NSUInteger, XZCarePickerCellType)
{
    kXZCarePickerCellTypeDate,
    kXZCarePickerCellTypeCustom
};

typedef NS_ENUM(NSUInteger, XZCareTextFieldCellType)
{
    kXZCareTextFieldCellTypeLeft,
    kXZCareTextFieldCellTypeRight,
};

*/
typedef NS_ENUM(NSUInteger, XZCareShareType)
{
    kXZCareShareTypeTwitter,
    kXZCareShareTypeFacebook,
    kXZCareShareTypeEmail,
    kXZCareShareTypeSMS
};

typedef NS_ENUM(NSUInteger, XZCareOnboardingTaskType)
{
    kXZCareOnboardingTaskTypeSignUp,
    kXZCareOnboardingTaskTypeSignIn,
};

typedef NS_ENUM(NSUInteger, XZCarePasscodeEntryType)
{
    kXZCarePasscodeEntryTypeOld,
    kXZCarePasscodeEntryTypeNew,
    kXZCarePasscodeEntryTypeReEnter,
};

typedef NS_ENUM(NSUInteger, XZCareFitnessDaysShows)
{
    XZCareFitnessDaysShowsRemaining = 0,
    XZCareFitnessDaysShowsLapsed
};

typedef NS_ENUM(NSUInteger, SevenDayFitnessDatasetKinds)
{
    SevenDayFitnessDatasetKindToday = 0,
    SevenDayFitnessDatasetKindWeek,
    SevenDayFitnessDataSetKindYesterday
};

typedef NS_ENUM(NSUInteger, SevenDayFitnessQueryType)
{
    SevenDayFitnessQueryTypeWake = 0,
    SevenDayFitnessQueryTypeSleep,
    SevenDayFitnessQueryTypeTotal
};

#endif
