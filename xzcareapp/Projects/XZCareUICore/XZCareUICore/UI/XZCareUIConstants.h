//
//  XZCareUIconstants.h
//  XZCareUICore
//
//  Created by Zhaohui Xing on 2015-10-20.
//  Copyright © 2015 xz-care. All rights reserved.
//

#ifndef __XZCAREUICONSTANTS_H__
#define __XZCAREUICONSTANTS_H__

#import <Foundation/Foundation.h>

#define kRegularFontNameKey                                     @"XZCare_RegularFontNameKey"
#define kMediumFontNameKey                                      @"XZCare_MediumFontNameKey"
#define kLightFontNameKey                                       @"XZCare_LightFontNameKey"

#define kPrimaryAppColorKey                                     @"XZCare_PrimaryAppColorKey"

#define kSecondaryColor1Key                                     @"XZCare_SecondaryColor1Key"
#define kSecondaryColor2Key                                     @"XZCare_SecondaryColor2Key"
#define kSecondaryColor3Key                                     @"XZCare_SecondaryColor3Key"
#define kSecondaryColor4Key                                     @"XZCare_SecondaryColor4Key"

#define kTertiaryColor1Key                                      @"XZCare_TertiaryColor1Key"
#define kTertiaryColor2Key                                      @"XZCare_TertiaryColor2Key"

#define kTertiaryGreenColorKey                                  @"XZCare_TertiaryGreenColorKey"
#define kTertiaryBlueColorKey                                   @"XZCare_TertiaryBlueColorKey"
#define kTertiaryRedColorKey                                    @"XZCare_TertiaryRedColorKey"
#define kTertiaryYellowColorKey                                 @"XZCare_TertiaryYellowColorKey"
#define kTertiaryPurpleColorKey                                 @"XZCare_TertiaryPurpleColorKey"
#define kTertiaryGrayColorKey                                   @"XZCare_TertiaryGrayColorKey"
#define kBorderLineColor                                        @"XZCare_LightGrayBorderColorKey"

#define kXZCarePickerTableViewCellIdentifier                    @"XZCarePickerTableViewCell"


#define kInsightsNotEnoughData                              @"Not enough data"


typedef NS_ENUM(NSInteger, XZCareStepProgressBarStyle)
{
    XZCareStepProgressBarStyleDefault = 0,
    XZCareStepProgressBarStyleOnlyProgressView
};

typedef NS_ENUM(NSUInteger, XZCareDashboardMessageType)
{
    kXZCareDashboardMessageTypeAlert,
    kXZCareDashboardMessageTypeInsight,
};

typedef NS_ENUM(NSUInteger, XZCareDashboardGraphType)
{
    kXZCareDashboardGraphTypeLine,
    kXZCareDashboardGraphTypeDiscrete,
};

typedef NS_ENUM(NSUInteger, XZCareDefaultTableViewCellType)
{
    kXZCareDefaultTableViewCellTypeLeft,
    kXZCareDefaultTableViewCellTypeRight,
};

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

typedef NS_ENUM(NSUInteger, XZCareSignUpPermissionsType) //APCSignUpPermissionsType
{
    kXZCareSignUpPermissionsTypeNone = 0,
    kXZCareSignUpPermissionsTypeHealthKit,
    kXZCareSignUpPermissionsTypeLocation,
    kXZCareSignUpPermissionsTypeLocalNotifications,
    kXZCareSignUpPermissionsTypeCoremotion,
    kXZCareSignUpPermissionsTypeMicrophone,
    kXZCareSignUpPermissionsTypeCamera,
    kXZCareSignUpPermissionsTypePhotoLibrary
};

typedef NS_ENUM(NSUInteger, XZCarePermissionStatus)
{
    kPermissionStatusNotDetermined,
    kPermissionStatusDenied,
    kPermissionStatusAuthorized,
};

typedef NS_ENUM(XZCareTableViewItemType, XZCareUserInfoItemType)
{
    kXZCareUserInfoItemTypeName = 0,
    kXZCareUserInfoItemTypeEmail,
    kXZCareUserInfoItemTypePassword,
    kXZCareUserInfoItemTypeDateOfBirth,
    kXZCareUserInfoItemTypeMedicalCondition,
    kXZCareUserInfoItemTypeMedication,
    kXZCareUserInfoItemTypeBloodType,
    kXZCareUserInfoItemTypeBloodPressureSystolic,
    kXZCareUserInfoItemTypeBloodPressureDiastolic,
    kXZCareUserInfoItemTypeWeight,
    kXZCareUserInfoItemTypeHeight,
    kXZCareUserInfoItemTypeBiologicalSex,
    kXZCareUserInfoItemTypeSleepTime,
    kXZCareUserInfoItemTypeWakeUpTime,
    kXZCareUserInfoItemTypeGlucoseLevel,
    kXZCareUserInfoItemTypeCustomSurvey,
    kXZCareSettingsItemTypeAutoLock,
    kXZCareSettingsItemTypePasscode,
    kXZCareSettingsItemTypeReminderOnOff,
    kXZCareSettingsItemTypeReminderTime,
    kXZCareSettingsItemTypePermissions,
    kXZCareUserInfoItemTypeReviewConsent,
    kXZCareSettingsItemTypePrivacyPolicy,
    kXZCareSettingsItemTypeLicenseInformation,
#ifndef __USING_NOSHARING_OPTION__
    kXZCareSettingsItemTypeSharingOptions,
#endif
};

#endif /* __XZCAREUICONSTANTS_H__ */
