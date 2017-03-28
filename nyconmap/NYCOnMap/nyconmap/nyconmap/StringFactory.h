//
//  StringFactory.h
//  XXXX
//
//  Created by Zhaohui Xing on 2010-05-12.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

// The helper class to return localized string
// for the game. Current it is hardcode english string
//and update later
@interface StringFactory : NSObject 
{
}

//Localization string
+(BOOL)IsOSLangEN;
+(BOOL)IsOSLangFR;
+(BOOL)IsOSLangGR;
+(BOOL)IsOSLangJP;
//+(BOOL)IsOSLangES;
//+(BOOL)IsOSLangIT;
+(BOOL)IsOSLangZH;
+(BOOL)IsOSLangCH;

+(int)GetString_OSLangID;


+(NSString*)GetString_Commercial;
+(NSString*)GetString_Community;
+(NSString*)GetString_LocalNews;
+(NSString*)GetString_Organization;
+(NSString*)GetString_Traffic;

+(NSString*)GetString_CommercialFoodDrink;
+(NSString*)GetString_CommercialRental;
+(NSString*)GetString_CommercialYardSale;

+(NSString*)GetString_CommunityEvent;
+(NSString*)GetString_CommunityYardSale;
+(NSString*)GetString_CommunityNews;

+(NSString*)GetString_CalenderNew;
+(NSString*)GetString_CalenderCheck;

+(NSString*)GetString_MyGEOFavorite;
+(NSString*)GetString_ManageGEOFavorite;

+(NSString*)GetString_MapStandard;
+(NSString*)GetString_MapHybird;
+(NSString*)GetString_MapSatellite;
+(NSString*)GetString_Configuration;

+(NSString*)GetString_NewsTitle:(int)nCategory subCategory:(int)nSubCategory;
+(NSString*)GetString_NewsMainTitle:(int)nCategory;
+(NSString*)GetString_TrafficTypeTitle:(int)nSubCategory withType:(int)nType;

+(NSString*)GetString_OK;
+(NSString*)GetString_Cancel;
+(NSString*)GetString_Yes;
+(NSString*)GetString_No;
+(NSString*)GetString_Close;

+(NSString*)GetString_LocationForPosting;
+(NSString*)GetString_InputLocationAddress;
+(NSString*)GetString_PinOnMap;
+(NSString*)GetString_CurrentLocation;

+(NSString*)GetString_Street;
+(NSString*)GetString_City;
+(NSString*)GetString_State;
+(NSString*)GetString_Country;
+(NSString*)GetString_ZipCode;

+(NSString*)GetString_InvalidStreet;
+(NSString*)GetString_InvalidCity;
+(NSString*)GetString_InvalidZipCode;

+(NSString*)GetString_LantitudeABV;
+(NSString*)GetString_LongitudeABV;

+(NSString*)GetString_Post;
+(NSString*)GetString_Photo;
+(NSString*)GetString_DeletePhoto;

+(NSString*)GetString_SubjectLabel;
+(NSString*)GetString_PostLabel;

+(NSString*)GetString_KeywordLabel;
+(NSString*)GetString_CopyrightLabel;

+(NSString*)GetString_InvalidSubject;
+(NSString*)GetString_InvalidPost;

+(NSString*)GetString_PostFailed;

+(NSString*)GetString_All;

+(NSString*)GetString_AddDetail;
+(NSString*)GetString_PostNow;

+(NSString*)GetString_Anonymous;

+(NSString*)GetString_PostTime;

+(NSString*)GetString_Period;
+(NSString*)GetString_Refresh;

+(NSString*)GetString_Day;
+(NSString*)GetString_Hour;
+(NSString*)GetString_Minute;

+(NSString*)GetString_Reload;
+(NSString*)GetString_ClearMap;
+(NSString*)GetString_MyLocation;

+(NSString*)GetString_EndQueryTime;
+(NSString*)GetString_StartQueryTime;

+(NSString*)GetString_Now;
+(NSString*)GetString_CustomizeSearchTime;
+(NSString*)GetString_SearchTime;
+(NSString*)GetString_EnableAutoload;

+(NSString*)GetString_InstallNewVersion;

+(NSString*)GetString_CopyrightSign;
+(NSString*)GetString_CopyrightCompany;

+(NSString*)GetString_NewVersionAlert;

+(NSString*)GetString_Login;
+(NSString*)GetString_Password;
+(NSString*)GetString_Email;
+(NSString*)GetString_ForgetPW;
+(NSString*)GetString_LoginFailedByUnknown;
+(NSString*)GetString_InvalidEmail;
+(NSString*)GetString_InvalidPW;
+(NSString*)GetString_EmptyEmail;
+(NSString*)GetString_EmptyPW;

+(NSString*)GetString_UserPWEmailSubject;

+(NSString*)GetString_CustomerEmailHead;

+(NSString*)GetString_CustomerSupportTeam;

+(NSString*)GetString_QueryConfiguration;

+(NSString*)GetString_UserConfiguration;

+(NSString*)GetString_DisplayName;

+(NSString*)GetString_LastName;

+(NSString*)GetString_FirstName;

+(NSString*)GetString_CreateUserAccount;
+(NSString*)GetString_UpdateUserAccount;

+(NSString*)GetString_EmptyDName;

+(NSString*)GetString_UserUpdateSucceed;
+(NSString*)GetString_UserUpdateFailed;
+(NSString*)GetString_UserCreateSucceed;
+(NSString*)GetString_UserCreateFailed;

+(NSString*)GetString_PleaseEnableLocationService;

+(NSString*)GetString_PostSucceed;

+(NSString*)GetString_LoginOrCreateAccountWarn;

+(NSString*)GetString_CloseAdCaptionFormat;

+(NSString*)GetString_CannotPostNonLocalMsgWarn;

+(NSString*)GetString_Time;
+(NSString*)GetString_InvalidTime;
+(NSString*)GetString_NobodyPostWarn;
+(NSString*)GetString_NoCommunityEventWarn;
+(NSString*)GetString_NetworkWarn;

+(NSString*)GetString_Accept;
+(NSString*)GetString_Reject;

+(NSString*)GetString_Privacy;
+(NSString*)GetString_TermOfUse;

+(NSString*)GetString_AcceptedTermOfUseFMT;
+(NSString*)GetString_DonotAcceptedTermOfUseFMT;

+(NSString*)GetString_ReportPost;
+(NSString*)GetString_ReportFailed;
+(NSString*)GetString_ReportSucceed;

+(NSString*)GetString_Slight;
+(NSString*)GetString_Moderate;
+(NSString*)GetString_Severe;
+(NSString*)GetString_ComplainReportTitle;

+(NSString*)GetString_SeverityString:(int)nSeverity;
+(NSString*)GetString_HigherSeverityWarn;

+(NSString*)GetString_BanForWronPost;
+(NSString*)GetString_BanForever;

+(NSString*)GetString_ImproperPostWarn;

+(NSString*)GetString_MarkSpot;
+(NSString*)GetString_TrafficSpot;
+(NSString*)GetString_PhotoRadar;
+(NSString*)GetString_SchoolZone;
+(NSString*)GetString_SpeedCamera;
+(NSString*)GetString_Playground;
+(NSString*)GetString_GasStation;
+(NSString*)GetString_ParkingGround;
+(NSString*)GetString_SpeedTrap;
+(NSString*)GetString_Type;
+(NSString*)GetString_Address;
+(NSString*)GetString_CarWash;
+(NSString*)GetString_FixedType;
+(NSString*)GetString_MobileType;
+(NSString*)GetString_EnforcementRadar;
+(NSString*)GetString_PoliceCar;
+(NSString*)GetString_SpotTitle:(int16_t)nType;
+(NSString*)GetString_SpotSubTitle:(int16_t)nType sithSubTitle:(int16_t)nSubType;

+(NSString*)GetString_MapType;

+(NSString*)GetString_LocationForMarkSpot;

+(NSString*)GetString_AskAddSpotName;

+(NSString*)GetString_Name;

+(NSString*)GetString_Spot;

+(NSString*)GetString_SpeedLimit;

+(NSString*)GetString_Add2Calender;

+(NSString*)GetString_Price;

+(NSString*)GetString_PriceUnit:(int16_t)nUnitType;

+(NSString*)GetString_PriceUnitDescription:(int16_t)nUnitType;

+(NSString*)GetString_Unit;

+(NSString*)GetString_Change;

+(NSString*)GetString_EmptyString;

+(NSString*)GetString_AddName;

+(NSString*)GetString_AddPrice;

+(NSString*)GetString_Fine;

+(NSString*)GetString_DollarSign;

+(NSString*)GetString_Direction;

+(NSString*)GetString_NorthBound;

+(NSString*)GetString_SouthBound;

+(NSString*)GetString_EastBound;

+(NSString*)GetString_WestBound;

+(NSString*)GetString_NBDir;

+(NSString*)GetString_SBDir;

+(NSString*)GetString_EBDir;

+(NSString*)GetString_WBDir;

+(NSString*)GetString_TrafficDirectFullString:(int16_t)nDirection;
+(NSString*)GetString_TrafficDirectShortString:(int16_t)nDirection;

+(NSString*)GetString_Rate;

+(NSString*)GetString_ParkingRate:(int16_t)nUnit;
+(NSString*)GetString_OneHour;
+(NSString*)GetString_QuarterHour;
+(NSString*)GetString_TwoHour;

+(NSString*)GetString_EnableTwitterService;
+(NSString*)GetString_TwitterSetting;

+(NSString*)GetString_PublicTransitTypeString:(int)nType;
+(NSString*)GetString_DrivingConditionTypeString:(int)nType;
+(NSString*)GetString_LocalNewsTitle:(int)nSubCategory;
+(NSString*)GetString_CommunityTitle:(int)nSubCategory;


+(NSString*)GetString_ReadLink;

+(NSString*)GetString_AskAddSpotInformation;

+(NSString*)GetString_TP_PREP_OF;

+(NSString*)GetString_TP_PREP_ON;

+(NSString*)GetString_TP_PREP_AT;

+(NSString*)GetString_TP_PREP_FROM;

+(NSString*)GetString_TP_PREP_TO;

+(NSString*)GetString_TP_PREP_IN;

+(NSString*)GetString_TP_PREP_AND;

+(NSString*)GetString_TP_PREP_BETWEEN;

+(NSString*)GetString_TP_DIRWORD_NB;
+(NSString*)GetString_TP_DIRWORD_EB;
+(NSString*)GetString_TP_DIRWORD_SB;
+(NSString*)GetString_TP_DIRWORD_WB;
+(NSString*)GetString_TP_DIRWORD_APPROACHING;

+(NSString*)GetString_PostLocationOutAppRegion;
+(NSString*)GetString_WhatIsNext;

+(NSString*)GetString_Author;

+(NSString*)GetString_LocationServiceRequired;
+(NSString*)GetString_Enable;

+(NSString*)GetString_Warning;
+(NSString*)GetString_NotAcceptTermOfUse;
+(NSString*)GetString_CarWashIncluded;

+(NSString*)GetString_TaxiInfo;
+(NSString*)GetString_TaxiAvailableByDriver;
+(NSString*)GetString_TaxiPassengerAvailable;
+(NSString*)GetString_Taxi;
+(NSString*)GetString_Passenger;
+(NSString*)GetString_Both;

+(NSString*)GetString_LowMemoryAndCloseApps;

/*
+(NSString*)GetString_Kindergarten;
+(NSString*)GetString_Elementary;
+(NSString*)GetString_JuniorHigh;
+(NSString*)GetString_HighSchool;
+(NSString*)GetString_College;
+(NSString*)GetString_University;
+(NSString*)GetString_MiscType;

*/

@end
