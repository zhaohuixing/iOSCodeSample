//
//  DrawHelper2.m
//  XXXXXXXXXXXXX
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "DrawHelper2.h"
//#include "drawhelper.h"
#import "ImageLoader.h"
#import "NOMGUILayout.h"

static CGGradientRef       m_BlueGradient;
static CGGradientRef       m_GreenGradient;
static CGGradientRef       m_BlackGradient;
static CGGradientRef       m_RedGradient;

static CGColorSpaceRef     m_BlueColorspace;

static CGGradientRef       m_HighLightGradient;
static CGGradientRef       m_GreenHighLightGradient;
static CGGradientRef       m_RedHighLightGradient;
static CGColorSpaceRef     m_HighLightColorspace;

static CGPatternRef        m_AlertUIPattern;
static CGColorSpaceRef     m_AlertUIPatternSpace;
static CGColorSpaceRef     m_AlertUIColorspace;
static CGColorRef          m_AlertDefaultDecorColor; 

static CGPatternRef        m_OptionalAlertUIPattern;
static CGColorRef          m_OptionalAlertUIDecorColor; 

static CGPatternRef        m_FrameViewUIPattern;
static CGColorRef          m_FrameViewUIDecorColor; 

static CGPatternRef        m_TextMsgUIPattern;
static CGColorRef          m_GrayUIDecorColor; 


static CGImageRef          m_JamImage;
static CGImageRef          m_PoliceImage;
static CGImageRef          m_ConstructImage;
static CGImageRef          m_CrashImage;
static CGImageRef          m_CrowdImage;
static CGImageRef          m_DelayImage;
static CGImageRef          m_TrafficImage;
static CGImageRef          m_RoadClosureImage;
static CGImageRef          m_BrokenLightImage;

static CGImageRef          m_JamPinImage;
static CGImageRef          m_PolicePinImage;
static CGImageRef          m_ConstructPinImage;
static CGImageRef          m_CrashPinImage;
static CGImageRef          m_CrowdPinImage;
static CGImageRef          m_DelayPinImage;

static CGImageRef          m_TrainDelayPinImage;
static CGImageRef          m_FlightDelayPinImage;

static CGImageRef          m_TrafficPinImage;
static CGImageRef          m_RoadClosurePinImage;
static CGImageRef          m_BrokenLightPinImage;
static CGImageRef          m_StalledCarPinImage;

static CGImageRef          m_FogPinImage;
static CGImageRef          m_DangerousConditionPinImage;
static CGImageRef          m_RainPinImage;
static CGImageRef          m_IcePinImage;
static CGImageRef          m_WindPinImage;
static CGImageRef          m_LaneClosurePinImage;
static CGImageRef          m_SlipRoadClosurePinImage;
static CGImageRef          m_DetourePinImage;


static CGImageRef          m_TrafficBKImage;
static CGImageRef          m_TweetPinImage;
static CGImageRef          m_TweetBKImage;
static CGImageRef          m_TwitterBirdImage;


static CGImageRef          m_CommunityEventImage;
static CGImageRef          m_CommunityYardSaleImage;
static CGImageRef          m_CommunityWikiImage;
static CGImageRef          m_CommunityMixImage;
static CGImageRef          m_BlankPublicImage;

static CGImageRef          m_PublicIssueImage;
static CGImageRef          m_PoliticsImage;
static CGImageRef          m_BusinessImage;
static CGImageRef          m_HealthImage;
static CGImageRef          m_SportsImage;
static CGImageRef          m_ArtImage;
static CGImageRef          m_EducationImage;
static CGImageRef          m_MoneyImage;

static CGImageRef          m_ScienceImage;
static CGImageRef          m_DrinkImage;
static CGImageRef          m_TourImage;
static CGImageRef          m_StyleImage;
static CGImageRef          m_HouseImage;

static CGImageRef          m_AutoImage;
static CGImageRef          m_CrimeImage;
static CGImageRef          m_WeatherImage;

static CGImageRef          m_CharityImage;
static CGImageRef          m_CultureImage;
static CGImageRef          m_ReligionImage;
static CGImageRef          m_PetImage;

static CGImageRef          m_MiscImage;

static CGImageRef           m_PhotoRadarImage;
static CGImageRef           m_SchoolZoneImage;
static CGImageRef           m_PlaygroundImage;
static CGImageRef           m_GasStationImage;
static CGImageRef           m_GasStationImage2;
static CGImageRef           m_DollarSignImage;
static CGImageRef           m_SpeedCameraImage;
static CGImageRef           m_ParkingSpotImage;



static UIImage*             m_BlueSliderThumb;
static UIImage*             m_RedSliderThumb;

static UIImage*             m_BasicSliderThumb;
static CGImageRef           m_SqureThumbImageSource;
static CGImageRef           m_RoundThumbImageSource;

//
static CGImageRef           m_GEOPlanPinImage;
static CGImageRef           m_GEOPlanPinHighlighImage;

static CGImageRef           m_TaxiPinImage;
static CGImageRef           m_PassengerPinImage;

static void DrawPatternImage(void *pImage, CGContextRef pContext)
{
    CGImageRef image = (CGImageRef) pImage;
    float width = CGImageGetWidth(image);
    float height =CGImageGetHeight(image);
    
    CGContextDrawImage(pContext, CGRectMake(0, 0, width, height), image);
}

static void ReleasePatternImage(void *pImage)
{
    //    CGImageRef image = (CGImageRef) pImage;
    //    CGImageRelease(image);
}

@implementation DrawHelper2

+(void)InitializeSliders
{
    CGImageRef          BlueImage = [ImageLoader LoadImageWithName:@"bthumb160.png"];
    
    CGRect baseRect = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    
    UIGraphicsBeginImageContext(baseRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, baseRect, BlueImage);
    
    m_BlueSliderThumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //CGImageRelease(BlueImage);
    
    
//??    CGImageRef  RedImage = [ImageLoader LoadImageWithName:@"rthumb160.png"];
    UIGraphicsBeginImageContext(baseRect.size);
    context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, baseRect, BlueImage);
    
    m_BlueSliderThumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //CGImageRelease(RedImage);
    
    
    baseRect = CGRectMake(0.0f, 0.0f, 40.0f, 100.0f);
    CGRect thumbRect = CGRectMake(0.0f, 40.0f, 40.0f, 20.0f);
    m_SqureThumbImageSource = [ImageLoader LoadImageWithName:@"sthumb160.png"];
    
    UIGraphicsBeginImageContext(baseRect.size);
    context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, thumbRect, m_SqureThumbImageSource);
    m_BasicSliderThumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    m_RoundThumbImageSource = [ImageLoader LoadImageWithName:@"cthumb160.png"];
}

+(void)ReleaseCommunitySigns
{
    //CGImageRelease(m_CommunityEventImage);
    //CGImageRelease(m_CommunityYardSaleImage);
    //CGImageRelease(m_CommunityWikiImage);
    //CGImageRelease(m_CommunityMixImage);
    //CGImageRelease(m_BlankPublicImage);
}

+(void)ReleaseTrafficSigns
{
//????????????????????????????
    //CGImageRelease(m_JamImage);
    //CGImageRelease(m_PoliceImage);
    //CGImageRelease(m_ConstructImage);
    //CGImageRelease(m_CrashImage);
    //CGImageRelease(m_CrowdImage);
    //CGImageRelease(m_DelayImage);
    //CGImageRelease(m_TrafficImage);
    //CGImageRelease(m_RoadClosureImage);
    //CGImageRelease(m_BrokenLightImage);
//???????????????????????????????
   
    //CGImageRelease(m_JamPinImage);
    //CGImageRelease(m_PolicePinImage);
    //CGImageRelease(m_ConstructPinImage);
    //CGImageRelease(m_CrashPinImage);
    //CGImageRelease(m_CrowdPinImage);
    //CGImageRelease(m_DelayPinImage);
    //CGImageRelease(m_TrafficPinImage);
    //CGImageRelease(m_RoadClosurePinImage);
    //CGImageRelease(m_BrokenLightPinImage);
    //CGImageRelease(m_StalledCarPinImage);
    //CGImageRelease(m_TrafficBKImage);
    //CGImageRelease(m_TweetPinImage);
    //CGImageRelease(m_TweetBKImage);
    //CGImageRelease(m_TwitterBirdImage);
    
    //CGImageRelease(m_PhotoRadarImage);
    //CGImageRelease(m_SchoolZoneImage);
    //CGImageRelease(m_PlaygroundImage);
    //CGImageRelease(m_GasStationImage);
    //CGImageRelease(m_GasStationImage2);
    //CGImageRelease(m_DollarSignImage);
    
    //CGImageRelease(m_SpeedCameraImage);
    //CGImageRelease(m_ParkingSpotImage);
    
}

+(void)InitializeTrafficSigns
{
//???????????????????????????????????
	m_JamImage = [ImageLoader LoadImageWithName:@"jam400.png"];
	m_PoliceImage = [ImageLoader LoadImageWithName:@"police400.png"];
    m_ConstructImage = [ImageLoader LoadImageWithName:@"construct400.png"];
    m_CrashImage = [ImageLoader LoadImageWithName:@"crash400.png"];
    m_CrowdImage = [ImageLoader LoadImageWithName:@"crowd400.png"];
    m_DelayImage = [ImageLoader LoadImageWithName:@"delay400.png"];
    m_TrafficImage = [ImageLoader LoadImageWithName:@"traffic400.png"];
    m_RoadClosureImage = [ImageLoader LoadImageWithName:@"roadclose400.png"];
    m_BrokenLightImage = [ImageLoader LoadImageWithName:@"brokenlight400.png"];
//???????????????????????????????????
    
    m_JamPinImage = [ImageLoader LoadImageWithName:@"jampin.png"];
    m_PolicePinImage = [ImageLoader LoadImageWithName:@"policepin.png"];
    m_ConstructPinImage = [ImageLoader LoadImageWithName:@"constructpin.png"];
    m_CrashPinImage = [ImageLoader LoadImageWithName:@"crashpin.png"];
    m_CrowdPinImage = [ImageLoader LoadImageWithName:@"crowdpin.png"];
    m_DelayPinImage = [ImageLoader LoadImageWithName:@"delaypin.png"];
    
    m_TrainDelayPinImage = [ImageLoader LoadImageWithName:@"delaytrainpin.png"];
    m_FlightDelayPinImage = [ImageLoader LoadImageWithName:@"delayflightpin.png"];
    
    
    m_TrafficPinImage = [ImageLoader LoadImageWithName:@"tmixpin.png"];//@"trafficpin.png"];
    m_RoadClosurePinImage = [ImageLoader LoadImageWithName:@"roadclosepin.png"];
    m_BrokenLightPinImage = [ImageLoader LoadImageWithName:@"brokenlightpin.png"];
    m_StalledCarPinImage = [ImageLoader LoadImageWithName:@"stallcarpin.png"];
    m_TrafficBKImage = [ImageLoader LoadImageWithName:@"trafficpinbk.png"];
    m_TweetPinImage = [ImageLoader LoadImageWithName:@"tweetpin.png"];
    m_TweetBKImage = [ImageLoader LoadImageWithName:@"tweetbk.png"];
    
    m_TwitterBirdImage = [ImageLoader LoadImageWithName:@"twitterbird.png"];
    
    m_PhotoRadarImage = [ImageLoader LoadImageWithName:@"photoradarspot.png"];
    m_SchoolZoneImage = [ImageLoader LoadImageWithName:@"schoolszonepot.png"];
    m_PlaygroundImage = [ImageLoader LoadImageWithName:@"playgroundspot.png"];
    m_GasStationImage = [ImageLoader LoadImageWithName:@"gasstationspot.png"];
    m_GasStationImage2 = [ImageLoader LoadImageWithName:@"gscwspot.png"];
    
    m_SpeedCameraImage = [ImageLoader LoadImageWithName:@"speedcameraspot.png"];
    m_ParkingSpotImage = [ImageLoader LoadImageWithName:@"parkingpin.png"];
    
    m_DollarSignImage = [ImageLoader LoadImageWithName:@"dollar100.png"];
    
    
    m_GEOPlanPinImage = [ImageLoader LoadImageWithName:@"planpin.png"];
    m_GEOPlanPinHighlighImage = [ImageLoader LoadImageWithName:@"planpinhi.png"];
    
    m_TaxiPinImage = [ImageLoader LoadImageWithName:@"taxi400.png"];
    m_PassengerPinImage = [ImageLoader LoadImageWithName:@"pas400.png"];
    
    m_FogPinImage = [ImageLoader LoadImageWithName:@"fogpin.png"];
    m_DangerousConditionPinImage= [ImageLoader LoadImageWithName:@"dangerpin.png"];
    m_RainPinImage= [ImageLoader LoadImageWithName:@"rainpin.png"];
    m_IcePinImage= [ImageLoader LoadImageWithName:@"icepin.png"];
    m_WindPinImage= [ImageLoader LoadImageWithName:@"windpin.png"];
    m_LaneClosurePinImage= [ImageLoader LoadImageWithName:@"lanepin.png"];
    m_SlipRoadClosurePinImage= [ImageLoader LoadImageWithName:@"sliproadpin.png"];
    m_DetourePinImage= [ImageLoader LoadImageWithName:@"detourpin.png"];
    
}

+(void)InitializeCommunitySigns
{
    m_CommunityEventImage = [ImageLoader LoadImageWithName:@"compin400.png"];
    m_CommunityYardSaleImage = [ImageLoader LoadImageWithName:@"yardsale400.png"];
    m_CommunityWikiImage = [ImageLoader LoadImageWithName:@"wiki400.png"];
    m_CommunityMixImage = [ImageLoader LoadImageWithName:@"commix400.png"];
    m_BlankPublicImage = [ImageLoader LoadImageWithName:@"publicpin200.png"];
}

+(void)InitializeLocalNewsSigns
{
    m_PublicIssueImage = [ImageLoader LoadImageWithName:@"pi200.png"];
    m_PoliticsImage = [ImageLoader LoadImageWithName:@"politics200.png"];
    
    m_BusinessImage = [ImageLoader LoadImageWithName:@"buz200.png"];
    m_HealthImage = [ImageLoader LoadImageWithName:@"health200.png"];
    m_SportsImage = [ImageLoader LoadImageWithName:@"sport200.png"];
    m_ArtImage = [ImageLoader LoadImageWithName:@"art200.png"];
    m_EducationImage = [ImageLoader LoadImageWithName:@"edu200.png"];
    
    m_MoneyImage = [ImageLoader LoadImageWithName:@"money200.png"];
    
    m_ScienceImage = [ImageLoader LoadImageWithName:@"science200.png"];
    m_DrinkImage = [ImageLoader LoadImageWithName:@"drink200.png"];
    m_TourImage = [ImageLoader LoadImageWithName:@"tour200.png"];
    m_StyleImage = [ImageLoader LoadImageWithName:@"style200.png"];
    m_HouseImage = [ImageLoader LoadImageWithName:@"house200.png"];
    
    m_AutoImage = [ImageLoader LoadImageWithName:@"auto200.png"];
    m_CrimeImage = [ImageLoader LoadImageWithName:@"crime200.png"];
    m_WeatherImage = [ImageLoader LoadImageWithName:@"weather200.png"];
    
    m_CharityImage = [ImageLoader LoadImageWithName:@"charity200.png"];
    m_CultureImage = [ImageLoader LoadImageWithName:@"culture200.png"];
    m_ReligionImage = [ImageLoader LoadImageWithName:@"religion200.png"];
    m_PetImage = [ImageLoader LoadImageWithName:@"pet200.png"];
    
    m_MiscImage = [ImageLoader LoadImageWithName:@"misc200.png"];
}

+(void)ReleaseLocalNewsSigns
{
    //CGImageRelease(m_PublicIssueImage);
    //CGImageRelease(m_PoliticsImage);
    //CGImageRelease(m_BusinessImage);
    //CGImageRelease(m_HealthImage);
    //CGImageRelease(m_SportsImage);
    //CGImageRelease(m_ArtImage);
    //CGImageRelease(m_EducationImage);
    //CGImageRelease(m_MoneyImage);


    //CGImageRelease(m_ScienceImage);
    //CGImageRelease(m_DrinkImage);
    //CGImageRelease(m_TourImage);
    //CGImageRelease(m_StyleImage);
    //CGImageRelease(m_HouseImage);

    
    //CGImageRelease(m_AutoImage);
    //CGImageRelease(m_CrimeImage);
    //CGImageRelease(m_WeatherImage);
    
    //CGImageRelease(m_CharityImage);
    //CGImageRelease(m_CultureImage);
    //CGImageRelease(m_ReligionImage);
    //CGImageRelease(m_PetImage);
    
    //CGImageRelease(m_MiscImage);
    
}

+(void)InitializeResource
{
    size_t num_locations = 3;
    CGFloat locations[3] = {0.0, 0.5, 1.0};
    CGFloat colors[12] = 
    {
        //0.1, 0.1, 0.4, 1.0,
        //0.6, 0.6, 1.0, 1.0,
        //0.1, 0.1, 0.4, 1.0,
        0.4, 0.4, 0.8, 1.0,
        0.2, 0.2, 0.6, 1.0,
        0.1, 0.1, 0.4, 1.0,
    };

    CGFloat colorsG[12] = 
    {
        //0.05, 0.3, 0.05, 1.0,
        //0.4, 0.8, 0.4, 1.0,
        //0.05, 0.3, 0.05, 1.0,
        0.4, 0.8, 0.4, 1.0,
        0.2, 0.6, 0.2, 1.0,
        0.1, 0.4, 0.1, 1.0,
   };
    
    CGFloat colorsB[12] =
    {
        0.2, 0.2, 0.2, 0.3,
        0.1, 0.1, 0.1, 0.6,
        0.0, 0.0, 0.0, 0.9,
    };

    CGFloat colorsR[12] =
    {
        0.8, 0.4, 0.4, 1.0,
        0.6, 0.2, 0.2, 1.0,
        0.4, 0.1, 0.1, 1.0,
    };
    
    
    m_BlueColorspace = CGColorSpaceCreateDeviceRGB();
    m_BlueGradient = CGGradientCreateWithColorComponents (m_BlueColorspace, colors, locations, num_locations);
    m_GreenGradient = CGGradientCreateWithColorComponents (m_BlueColorspace, colorsG, locations, num_locations);
    m_BlackGradient = CGGradientCreateWithColorComponents (m_BlueColorspace, colorsB, locations, num_locations);
    m_RedGradient = CGGradientCreateWithColorComponents (m_BlueColorspace, colorsR, locations, num_locations);
    
    size_t num_locations2 = 2;
    CGFloat locations2[2] = {0.0, 1.0};
    CGFloat colors2[8] = 
    {
        0.8, 0.8, 1.0, 1.0,
        0.6, 0.6, 0.9, 0.5,
    };

    CGFloat colors2G[8] =
    {
        0.7, 1.0, 0.7, 1.0,
        0.5, 0.9, 0.5, 0.5,
    };

    CGFloat colors2R[8] =
    {
        1.0, 0.7, 0.7, 1.0,
        0.9, 0.5, 0.5, 0.5,
    };
    
    m_HighLightColorspace = CGColorSpaceCreateDeviceRGB();
    m_HighLightGradient = CGGradientCreateWithColorComponents (m_HighLightColorspace, colors2, locations2, num_locations2);
    m_GreenHighLightGradient = CGGradientCreateWithColorComponents (m_HighLightColorspace, colors2G, locations2, num_locations2);
    m_RedHighLightGradient = CGGradientCreateWithColorComponents (m_HighLightColorspace, colors2R, locations2, num_locations2);
    
	CGAffineTransform transform;
    CGPatternCallbacks callbacks;
	callbacks.version = 0;
	callbacks.drawPattern = &DrawPatternImage;
	callbacks.releaseInfo = &ReleasePatternImage;
	CGImageRef image = [ImageLoader LoadImageWithName:@"blacktex.png"];
	
	float width = CGImageGetWidth(image);
	float height = CGImageGetHeight(image);
	
	transform = CGAffineTransformIdentity;
    
    
	m_AlertUIPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    m_AlertUIPatternSpace = CGColorSpaceCreatePattern(NULL);
    m_AlertUIColorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat colorsYellow[4] = 
    {
        //0.99, 0.99, 0.4, 0.4,
        //0.99, 0.99, 0.4, 1.0,
        0.1, 1.0, 0.6, 0.4,
    };
    m_AlertDefaultDecorColor = CGColorCreate(m_AlertUIColorspace, colorsYellow); 

	image = [ImageLoader LoadImageWithName:@"greentex.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);

	m_OptionalAlertUIPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    CGFloat colorsRed[4] = 
    {
        1.0, 0.0, 0.0, 1.0,
    };
    m_OptionalAlertUIDecorColor = CGColorCreate(m_AlertUIColorspace, colorsRed); 
    
	image = [ImageLoader LoadImageWithName:@"lightbrowntex.png"];
	//image = [ImageLoader LoadImageWithName:@"redtext.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
    
	m_FrameViewUIPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    CGFloat colorsBlue[4] = 
    {
        0.2, 0.2, 1.0, 1.0,
    };
    m_FrameViewUIDecorColor = CGColorCreate(m_AlertUIColorspace, colorsBlue); 

	image = [ImageLoader LoadImageWithName:@"bluetex.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
	m_TextMsgUIPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
 
    CGFloat colorsGray[4] = 
    {
        0.75, 0.75, 0.75, 1.0,
    };
    m_GrayUIDecorColor = CGColorCreate(m_AlertUIColorspace, colorsGray);
    [DrawHelper2 InitializeTrafficSigns];
    [DrawHelper2 InitializeCommunitySigns];
    [DrawHelper2 InitializeLocalNewsSigns];
    [DrawHelper2 InitializeSliders];
}

+(void)ReleaseResource
{
    CGColorSpaceRelease(m_BlueColorspace);
    CGGradientRelease(m_BlueGradient);
    
    CGColorSpaceRelease(m_HighLightColorspace);
    CGGradientRelease(m_HighLightGradient);

    CGGradientRelease(m_GreenGradient);
    CGGradientRelease(m_GreenHighLightGradient);

    CGGradientRelease(m_RedGradient);
    CGGradientRelease(m_RedHighLightGradient);
   
    CGGradientRelease(m_BlackGradient);
    
    CGPatternRelease(m_AlertUIPattern);
    CGColorSpaceRelease(m_AlertUIPatternSpace);
    CGColorSpaceRelease(m_AlertUIColorspace);
    CGColorRelease(m_AlertDefaultDecorColor);

    CGPatternRelease(m_OptionalAlertUIPattern);
    CGColorRelease(m_OptionalAlertUIDecorColor); 

    CGPatternRelease(m_FrameViewUIPattern);
    CGColorRelease(m_FrameViewUIDecorColor); 
    
    CGPatternRelease(m_TextMsgUIPattern);
    
    CGColorRelease(m_GrayUIDecorColor);
    
    [DrawHelper2 ReleaseTrafficSigns];
    [DrawHelper2 ReleaseCommunitySigns];
    [DrawHelper2 ReleaseLocalNewsSigns];
    
    //CGImageRelease(m_SqureThumbImageSource);
    //CGImageRelease(m_RoundThumbImageSource);
}

+(void)DrawBlueGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_BlueGradient, pt1, pt2, 0);
}

+(void)DrawBlueHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_HighLightGradient, pt1, pt2, 0);
}

+(void)DrawGreenGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_GreenGradient, pt1, pt2, 0);
}

+(void)DrawGreenHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_GreenHighLightGradient, pt1, pt2, 0);
}

+(void)DrawRedGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_RedGradient, pt1, pt2, 0);
}

+(void)DrawRedHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_RedHighLightGradient, pt1, pt2, 0);
}

+(void)DrawDefaultAlertBackground:(CGContextRef)context at:(CGRect)rect
{
    CGFloat fAlpha = 1.0;
    CGContextSetFillColorSpace(context, m_AlertUIPatternSpace);
    CGContextSetFillPattern(context, m_AlertUIPattern, &fAlpha);
	CGContextFillRect (context, rect);	
}

+(void)DrawDefaultAlertGradientBackground:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_BlackGradient, pt1, pt2, 0);
}

+(void)DrawDefaultAlertBackgroundDecoration:(CGContextRef)context
{
//??    CGContextSetStrokeColorWithColor(context, m_AlertDefaultDecorColor);
//??	CGContextSetLineWidth(context, [GUILayout GetDefaultAlertUIEdge]);
//??    CGContextDrawPath(context, kCGPathStroke);
}

+(void)DrawOptionalAlertBackground:(CGContextRef)context at:(CGRect)rect
{
    CGFloat fAlpha = 1.0;
    CGContextSetFillColorSpace(context, m_AlertUIPatternSpace);
    CGContextSetFillPattern(context, m_OptionalAlertUIPattern, &fAlpha);
	CGContextFillRect (context, rect);	
}

+(void)DrawOptionalAlertBackgroundDecoration:(CGContextRef)context
{
//??    CGContextSetStrokeColorWithColor(context, m_OptionalAlertUIDecorColor);
//??	CGContextSetLineWidth(context, [GUILayout GetDefaultAlertUIEdge]);
//??    CGContextDrawPath(context, kCGPathStroke);
}

+(void)DrawDefaultFrameViewBackground:(CGContextRef)context at:(CGRect)rect
{
    CGFloat fAlpha = 1.0;
    CGContextSetFillColorSpace(context, m_AlertUIPatternSpace);
    CGContextSetFillPattern(context, m_FrameViewUIPattern, &fAlpha);
	CGContextFillRect (context, rect);	
}

+(void)DrawDefaultFrameViewBackgroundDecoration:(CGContextRef)context
{
//??    CGContextSetStrokeColorWithColor(context, m_FrameViewUIDecorColor);
//??	CGContextSetLineWidth(context, [GUILayout GetDefaultAlertUIEdge]);
//??    CGContextDrawPath(context, kCGPathStroke);
}

+(void)DrawGrayFrameViewBackgroundDecoration:(CGContextRef)context
{
//??    CGContextSetStrokeColorWithColor(context, m_GrayUIDecorColor);
//??	CGContextSetLineWidth(context, [GUILayout GetDefaultAlertUIEdge]);
//??    CGContextDrawPath(context, kCGPathStroke);
}

+(void)DrawHalfSizeGrayBackgroundDecoration:(CGContextRef)context
{
//??    CGContextSetStrokeColorWithColor(context, m_GrayUIDecorColor);
//??	CGContextSetLineWidth(context, [GUILayout GetDefaultAlertUIEdge]*0.5);
//??    CGContextDrawPath(context, kCGPathStroke);
}

+(void)DrawBlueTextureRect:(CGContextRef)context at:(CGRect)rect
{
    CGFloat fAlpha = 1.0;
    CGContextSetFillColorSpace(context, m_AlertUIPatternSpace);
    CGContextSetFillPattern(context, m_TextMsgUIPattern, &fAlpha);
	CGContextFillRect (context, rect);	
}

+(void)DrawBlueTexturePath:(CGContextRef)context
{
    
}

//????????????????????????
//????????????????????????
//????????????????????????
+(void)DrawJamSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_JamImage);
}

+(void)DrawPoliceSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_PoliceImage);
}

+(void)DrawConstructSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_ConstructImage);
}

+(void)DrawCrashSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CrashImage);
}

+(void)DrawCrowdSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CrowdImage);
}

+(void)DrawDelaySignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DelayImage);
}

+(void)DrawTrafficSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_TrafficImage);
}

+(void)DrawRoadClosureSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_RoadClosureImage);
}

+(void)DrawBrokenLightSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BrokenLightImage);
}
//????????????????????????
//????????????????????????

/*
 m_TrafficBKImage = [ImageLoader LoadImageWithName:@"trafficpinbk.png"];
 */


+(void)DrawJamPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_JamPinImage);
}

+(void)DrawPolicePinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_PolicePinImage);
}

+(void)DrawConstructPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_ConstructPinImage);
}

+(void)DrawCrashPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CrashPinImage);
}

+(void)DrawCrowdPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CrowdPinImage);
}

+(void)DrawDelayPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DelayPinImage);
}

+(void)DrawBusDelayPinRect:(CGContextRef)context at:(CGRect)rect
{
    [DrawHelper2 DrawDelayPinRect:context at:rect];
}

+(void)DrawTrainDelayPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_TrainDelayPinImage);
}

+(void)DrawFlightDelayPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_FlightDelayPinImage);
}

+(void)DrawTrafficPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_TrafficPinImage);
}

+(void)DrawRoadClosurePinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_RoadClosurePinImage);
}

+(void)DrawBrokenLightPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BrokenLightPinImage);
}

+(void)DrawStalledCarPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_StalledCarPinImage);
}

//??????????????????
//??????????????????
//??????????????????
+(void)DrawFogPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_FogPinImage);
}

+(void)DrawDangerousConditionPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DangerousConditionPinImage);
}

+(void)DrawRainPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_RainPinImage);
}

+(void)DrawIcePinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_IcePinImage);
}

+(void)DrawWindPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_WindPinImage);
}

+(void)DrawLaneClosurePinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_LaneClosurePinImage);
}

+(void)DrawSlipRoadClosurePinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_SlipRoadClosurePinImage);
}

+(void)DrawDetourPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DetourePinImage);
}
//??????????????????
//??????????????????
//??????????????????

+(void)DrawTrafficBKRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_TrafficBKImage);
}

+(void)DrawTweetPinRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_TweetPinImage);
}

+(void)DrawTweetBKRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_TweetBKImage);
}

+(void)DrawTwitterBirdRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_TwitterBirdImage);
}

//????????????????????????
//????????????????????????


+(void)DrawCommunityEventSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CommunityEventImage);
}

+(void)DrawCommunityYardSaleSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CommunityYardSaleImage);
}

+(void)DrawCommunityWikiSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CommunityWikiImage);
}

+(void)DrawCommunityMixSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CommunityMixImage);
}

+(void)DrawBlankPublicSignRect:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BlankPublicImage);
}

+(void)DrawPublicIssueSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_PublicIssueImage);
}

+(void)DrawPoliticsSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_PoliticsImage);
}

+(void)DrawBusinessSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BusinessImage);
}

+(void)DrawHealthSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_HealthImage);
}

+(void)DrawSportsSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_SportsImage);
}

+(void)DrawArtSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_ArtImage);
}

+(void)DrawEducationSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_EducationImage);
}

+(void)DrawMoneySign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_MoneyImage);
}

+(void)DrawScienceSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_ScienceImage);
}

+(void)DrawDrinkSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DrinkImage);
}

+(void)DrawTourSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_TourImage);
}

+(void)DrawStyleSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_StyleImage);
}

+(void)DrawHouseSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_HouseImage);
}


+(void)DrawAutoSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_AutoImage);
}

+(void)DrawCrimeSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CrimeImage);
}

+(void)DrawWeatherSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_WeatherImage);
}

+(void)DrawCharitySign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CharityImage);
}

+(void)DrawCultureSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CultureImage);
}

+(void)DrawReligionSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_ReligionImage);
}

+(void)DrawPetSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_PetImage);
}

+(void)DrawMiscSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_MiscImage);
}

+(void)DrawPhotoRadarSpot:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_PhotoRadarImage);
}

+(void)DrawSchoolZoneSpot:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_SchoolZoneImage);
}

+(void)DrawPlaygroundSpot:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_PlaygroundImage);
}

+(void)DrawGasStationSpot:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_GasStationImage);
}

+(void)DrawGasStationCarWashSpot:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_GasStationImage2);
}

+(void)DrawDollarSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DollarSignImage);
}


+(void)DrawSpeedCameraSpot:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_SpeedCameraImage);
}

+(void)DrawParkingSpot:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_ParkingSpotImage);
}


+(UIImage*)GetBlueSliderThumb
{
    return m_BlueSliderThumb;
}

+(UIImage*)GetRedSliderThumb
{
    return m_RedSliderThumb;
}

+(UIImage*)GetBasicSliderThumb
{
    return m_BasicSliderThumb;
}

void DrawTextAtCenter(CGContextRef context, NSString *fontname, float textsize, NSString *text, CGPoint point, UIColor *color)
{
    CGContextSaveGState(context);
    CGContextSelectFont(context, [fontname UTF8String], textsize, kCGEncodingMacRoman);
    
    // Retrieve the text width without actually drawing anything
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextInvisible);
    CGContextShowTextAtPoint(context, 0.0f, 0.0f, [text UTF8String], text.length);
    CGPoint endpoint = CGContextGetTextPosition(context);
    CGContextRestoreGState(context);
    
    // Query for size to recover height. Width is less reliable
    CGSize stringSize = [text sizeWithFont:[UIFont fontWithName:fontname size:textsize]];
    
    // Draw the text
    [color setFill];
    CGContextSetShouldAntialias(context, true);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextMatrix (context, CGAffineTransformMake(1, 0, 0, -1, 0, 0));
    CGContextShowTextAtPoint(context, point.x - endpoint.x / 2.0f, point.y + stringSize.height / 4.0f, [text UTF8String], text.length);
    CGContextRestoreGState(context);
}


+(UIImage*)GetStringSliderThumb:(NSString*)text
{
    CGRect baseRect = CGRectMake(0.0f, 0.0f, 40.0f, 100.0f);
    CGRect thumbRect = CGRectMake(0.0f, 40.0f, 40.0f, 20.0f);
    
    UIGraphicsBeginImageContext(baseRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
 
    CGContextDrawImage(context, thumbRect, m_SqureThumbImageSource);
    
    // Create a filled ellipse for the indicator
    CGRect ellipseRect = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    CGContextDrawImage(context, ellipseRect, m_RoundThumbImageSource);
    
    // Label with a number
    UIColor *textColor = [UIColor blackColor];
    DrawTextAtCenter(context, @"Georgia", 12.0f, text, CGPointMake(20.0f, 20.0f), textColor);
    
    // Build and return the image
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(void)DrawGEOPlanPin:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_GEOPlanPinImage);
}

+(void)DrawGEOPlanPinHighlight:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_GEOPlanPinHighlighImage);
}

+(void)DrawTaxiPin:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_TaxiPinImage);
}

+(void)DrawPassengerPin:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_PassengerPinImage);
}

+(CGImageRef)CloneImage:(CGImageRef)srcImage withFlip:(BOOL)bFlip
{
    float w =CGImageGetWidth(srcImage);
    float h =CGImageGetHeight(srcImage);
    
    CGImageRef image = NULL;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmpContext = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGContextSaveGState(bmpContext);
    if(bFlip == YES)
    {
        CGContextTranslateCTM(bmpContext, 0, h);
        CGContextScaleCTM(bmpContext, 1, -1);
    }
    CGContextDrawImage(bmpContext, CGRectMake(0, 0, w, h), srcImage);
    CGContextRestoreGState(bmpContext);
    image = CGBitmapContextCreateImage(bmpContext);
    CGContextRelease(bmpContext);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(void)AddRoundRectToPath:(CGContextRef)context in:(CGRect)rect radius:(CGSize)oval size:(CGFloat)fr
{
    float fw, fh;
    if (oval.width == 0 || oval.height == 0)
    {
        CGContextAddRect(context, rect);
    }
    else
    {
        CGContextBeginPath(context);
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(context, oval.width, oval.height);
        fw = CGRectGetWidth(rect)/oval.width;
        fh = CGRectGetHeight(rect)/oval.height;
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, fr);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, fr);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, fr);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, fr);
        CGContextRestoreGState(context);
        CGContextClosePath(context);
    }
}

@end
