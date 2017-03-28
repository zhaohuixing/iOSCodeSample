//
//  DrawHelper2.h
//  XXXXXXXXXXXXX
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawHelper2 : NSObject

+(void)InitializeResource;
+(void)ReleaseResource;

+(void)DrawBlueGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBlueHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGreenGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGreenHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;
+(void)DrawRedGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;
+(void)DrawRedHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;

+(void)DrawDefaultAlertGradientBackground:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDefaultAlertBackground:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDefaultAlertBackgroundDecoration:(CGContextRef)context;
+(void)DrawOptionalAlertBackground:(CGContextRef)context at:(CGRect)rect;
+(void)DrawOptionalAlertBackgroundDecoration:(CGContextRef)context;
+(void)DrawDefaultFrameViewBackground:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDefaultFrameViewBackgroundDecoration:(CGContextRef)context;
+(void)DrawGrayFrameViewBackgroundDecoration:(CGContextRef)context;
+(void)DrawHalfSizeGrayBackgroundDecoration:(CGContextRef)context;

+(void)DrawBlueTextureRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBlueTexturePath:(CGContextRef)context;

//??????????????????
//??????????????????
//??????????????????
+(void)DrawJamSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawPoliceSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawConstructSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCrashSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCrowdSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDelaySignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawTrafficSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawRoadClosureSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBrokenLightSignRect:(CGContextRef)context at:(CGRect)rect;
//??????????????????
//??????????????????
//??????????????????

+(void)DrawJamPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawPolicePinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawConstructPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCrashPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCrowdPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDelayPinRect:(CGContextRef)context at:(CGRect)rect;

+(void)DrawBusDelayPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawTrainDelayPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawFlightDelayPinRect:(CGContextRef)context at:(CGRect)rect;

+(void)DrawTrafficPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawRoadClosurePinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBrokenLightPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawStalledCarPinRect:(CGContextRef)context at:(CGRect)rect;
//??????????????????
//??????????????????
//??????????????????
+(void)DrawFogPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDangerousConditionPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawRainPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawIcePinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawWindPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawLaneClosurePinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawSlipRoadClosurePinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDetourPinRect:(CGContextRef)context at:(CGRect)rect;
//??????????????????
//??????????????????
//??????????????????

+(void)DrawTweetPinRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawTrafficBKRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawTweetBKRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawTwitterBirdRect:(CGContextRef)context at:(CGRect)rect;

+(void)DrawCommunityEventSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCommunityYardSaleSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCommunityWikiSignRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCommunityMixSignRect:(CGContextRef)context at:(CGRect)rect;

+(void)DrawBlankPublicSignRect:(CGContextRef)context at:(CGRect)rect;

+(void)DrawPublicIssueSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawPoliticsSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBusinessSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawHealthSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawSportsSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawArtSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawEducationSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawMoneySign:(CGContextRef)context at:(CGRect)rect;

+(void)DrawScienceSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDrinkSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawTourSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawStyleSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawHouseSign:(CGContextRef)context at:(CGRect)rect;

+(void)DrawAutoSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCrimeSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawWeatherSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCharitySign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCultureSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawReligionSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawPetSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawMiscSign:(CGContextRef)context at:(CGRect)rect;

+(void)DrawPhotoRadarSpot:(CGContextRef)context at:(CGRect)rect;
+(void)DrawSchoolZoneSpot:(CGContextRef)context at:(CGRect)rect;
+(void)DrawPlaygroundSpot:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGasStationSpot:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGasStationCarWashSpot:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDollarSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawSpeedCameraSpot:(CGContextRef)context at:(CGRect)rect;
+(void)DrawParkingSpot:(CGContextRef)context at:(CGRect)rect;

+(void)DrawGEOPlanPin:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGEOPlanPinHighlight:(CGContextRef)context at:(CGRect)rect;

+(void)DrawTaxiPin:(CGContextRef)context at:(CGRect)rect;
+(void)DrawPassengerPin:(CGContextRef)context at:(CGRect)rect;

+(UIImage*)GetBlueSliderThumb;
+(UIImage*)GetRedSliderThumb;

+(UIImage*)GetBasicSliderThumb;
+(UIImage*)GetStringSliderThumb:(NSString*)text;

+(CGImageRef)CloneImage:(CGImageRef)srcImage withFlip:(BOOL)bFlip;
+(void)AddRoundRectToPath:(CGContextRef)context in:(CGRect)rect radius:(CGSize)oval size:(CGFloat)fr;

@end
