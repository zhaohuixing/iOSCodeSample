//
//  NOMSocialTweetHelper.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficSpotRecord.h"
#import "NOMSocialTweetHelper.h"
#import "NOMSystemConstants.h"
#import "SocialAPIConstants.h"
#import "StringFactory.h"
#import "NOMAppInfo.h"

@implementation NOMSocialTweetHelper


+(NSString*)GetCurrentCityTwitterHashKey
{
    return [NOMAppInfo GetCurrentCityTwitterHashKey];
}

+(NSString*)GetLocalNewsHashTag:(int16_t)nSubCate
{
    NSString* strTitle = @"";
    switch (nSubCate)
    {
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_PUBLICISSUE:
            strTitle = @"#Public";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_POLITICS:
            strTitle = @"#Politics";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_BUSINESS:
            strTitle = @"#Business";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_MONEY:
            strTitle = @"#Finance #Money";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_HEALTH:
            strTitle = @"#Health";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_SPORTS:
            strTitle = @"#Sports";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ARTANDENTERTAINMENT:
            strTitle = @"#Art #Entertainment";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_EDUCATION:
            strTitle = @"#Education";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TECHNOLOGYANDSCIENCE:
            strTitle = @"#Technology #Science";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_FOODANDDRINK:
            strTitle = @"#Food #Drink";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TRAVELANDTOURISM:
            strTitle = @"#Travel #Tourism";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_LIFESTYLE:
            strTitle = @"#LifeStyle";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_REALESTATE:
            strTitle = @"#RealEstate";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_AUTO:
            strTitle = @"#Auto";
            break;
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CRIMEANDDISASTER:
            strTitle = @"#Crime #Disaster";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_WEATHER:
            strTitle = @"#Weather";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CHARITY:
            strTitle = @"#Charity";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CULTURE:
            strTitle = @"#Culture";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_RELIGION:
            strTitle = @"#Religion";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ANIMALPET:
            strTitle = @"#Animal #Pet";
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_MISC:
            strTitle = @"#LocalNews";
            break;
        default:
            break;
    }
    
    return strTitle;
}

+(NSString*)GetCommunityHashTag:(int16_t)nSubCate
{
    NSString* szKey = @"";
    
    switch (nSubCate)
    {
        case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYEVENT:
            szKey = @"#CommunityEvent";
            break;
            
        case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYYARDSALE:
            szKey = @"#YardSale #garagesale";
            break;
            
        case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYWIKI:
            szKey = @"#CommunityWiki";
            break;
            
        case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_ALL:
            szKey = @"#Community";
            break;
            
        default:
            break;
    }
    
    return szKey;
}

+(NSString*)GetPublicTransitHashTag:(int16_t)nThirdCate
{
    NSString* szKey = @"";
    
    switch (nThirdCate)
    {
//        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_DELAY:
 
            //szKey = @"#publictransit #delay";
            //szKey = NSLocalizedString(@"#publictransitdelay", @"#publictransitdelay label string");
            //break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY:
            szKey = NSLocalizedString(@"#BusDelay", @"Bus Delay label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_TRAIN_DELAY:
            szKey = NSLocalizedString(@"#TrainDelay", @"Train Delay label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_FLIGHT_DELAY:
            szKey = NSLocalizedString(@"#FlightDelay", @"Flight Delay label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK:
            //szKey = @"#publictransit #passenger";
            szKey = NSLocalizedString(@"#publictransitpassengerstuck", @"#publictransitpassengerstuck label string");
            break;
//        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_ALL:
//            szKey = [StringFactory GetString_All];
//            break;
        default:
            break;
    }
    
    return szKey;
}

+(NSString*)GetDrivingConditionTag:(int16_t)nThirdCate
{
    NSString* szKey = @"";
    
    switch (nThirdCate)
    {
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM:
            szKey = NSLocalizedString(@"#TrafficJam", @"Traffic Jam label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH:
            szKey = NSLocalizedString(@"#CarCrash", @"Car Crash label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE:
            szKey = NSLocalizedString(@"#PoliceCheckpoint", @"Police Checkpoint label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION:
            szKey = NSLocalizedString(@"#ConstructionZone", @"Construction Zone label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE:
            szKey = NSLocalizedString(@"#RoadClosure", @"Road Closure label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT:
            szKey = NSLocalizedString(@"#BrokenTrafficLight", @"Broken Traffic Light label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR:
            szKey = NSLocalizedString(@"#StalledCar", @"Stalled Car label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG:
            szKey = NSLocalizedString(@"#FoggyConditions", @"Foggy Conditions label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION:
            szKey = NSLocalizedString(@"#DangerousConditions", @"Dangerous Conditions label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN:
            szKey = NSLocalizedString(@"#Rain", @"Rain label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE:
            szKey = NSLocalizedString(@"#IcyConditions", @"Icy Conditions label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND:
            szKey = NSLocalizedString(@"#StrongWinds", @"Strong Winds label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE:
            szKey = NSLocalizedString(@"#LaneClosure", @"Lane Closure label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE:
            szKey = NSLocalizedString(@"#HighwayRampClosure", @"Highway Ramp Closure label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR:
            szKey = NSLocalizedString(@"#Detour", @"Detour label string");
            break;
//        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ALL:
//            strTitle = [StringFactory GetString_All];
//            break;
        default:
            break;
    }
    
    return szKey;
}

+(NSString*)GetTrafficHashTag:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate
{
    NSString* szKey = @"";
    
    switch (nSubCate)
    {
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT:
            szKey = [NOMSocialTweetHelper GetPublicTransitHashTag:nThirdCate];
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION:
            szKey = [NOMSocialTweetHelper GetDrivingConditionTag:nThirdCate];
            break;
        default:
            break;
    }
    
    return szKey;
}

+(NSString*)GetNewsHashTag:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate
{
    NSString* szKey = @"";
    
    switch (nMainCate)
    {
        case NOM_NEWSCATEGORY_LOCALNEWS:
            szKey = [NOMSocialTweetHelper GetLocalNewsHashTag:nSubCate];
            break;
        case NOM_NEWSCATEGORY_COMMUNITY:
            szKey = [NOMSocialTweetHelper GetCommunityHashTag:nSubCate];
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC:
            szKey = [NOMSocialTweetHelper GetTrafficHashTag:nSubCate withThirdCate:nThirdCate];
            break;
        default:
            break;
    }
    
    return szKey;
}

+(NSString*)CreateTwitterTweet:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate withPost:(NSString*)szSrcPost
{
    NSString* szTweet = @"";
    
    NSString* szAppKey = [NOMAppInfo GetAppTwitterHashKey];
    NSString* szCityKey = [NOMSocialTweetHelper GetCurrentCityTwitterHashKey];
    NSString* szNewsKey = [NOMSocialTweetHelper GetNewsHashTag:nMainCate withSubCate:nSubCate withThirdCate:nThirdCate];
    NSString* szHashKey = [NSString stringWithFormat:@"%@%@ %@", szAppKey, szCityKey, szNewsKey];
    
    if(szHashKey.length < TTPOST_TWEET_LENGTH)
    {
        if(szSrcPost != nil && 0 < szSrcPost.length)
        {
            NSString* szContent;
            int nLeft = TTPOST_TWEET_LENGTH - (int)szHashKey.length;
            if(nLeft < szSrcPost.length)
            {
                NSRange range = NSMakeRange(0, nLeft);
                szContent = [szSrcPost substringWithRange:range];
            }
            else
            {
                szContent = szSrcPost;
            }
            szTweet = [NSString stringWithFormat:@"%@ %@", szHashKey, szContent];
        }
        else
        {
            szTweet = szHashKey;
        }
    }
    else
    {
        NSRange range = NSMakeRange(0, TTPOST_TWEET_LENGTH);
        szTweet = [szHashKey substringWithRange:range];
    }
    
    return szTweet;
}

+(NSString*)GetSearchNewsHashTag:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate
{
    NSString* szHashKey = [NOMSocialTweetHelper GetNewsHashTag:nMainCate withSubCate:nSubCate withThirdCate:nThirdCate];
    
    return szHashKey;
}

+(NSArray*)GetSearchTrafficTagList
{
    NSMutableArray* pArray = [[NSMutableArray alloc] init];

    [pArray addObject:@"traffic"];
    
    for(int16_t i = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY; i <= NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK; ++i)
    {
        [pArray addObject:[NOMSocialTweetHelper GetPublicTransitHashTag:i]];
    }

    for(int16_t i = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM; i <= NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR; ++i)
    {
        [pArray addObject:[NOMSocialTweetHelper GetDrivingConditionTag:i]];
    }
    
    [pArray addObject:@"stalledvehicle"];
    [pArray addObject:@"caraccident"];
    [pArray addObject:@"speedcheck"];
    
    return pArray;
}

+(NSArray*)GetSearchNewsTagList:(int16_t)nMainCate
{
    NSArray* array = nil;
    
    if(nMainCate == NOM_NEWSCATEGORY_LOCALTRAFFIC)
        array = [NOMSocialTweetHelper GetSearchTrafficTagList];
    
    return array;
}

+(BOOL)CheckTweetApphashTag:(NSString*)tweet
{
    if(tweet != nil && 0 < tweet.length)
    {
        NSString* szAppKey = [NOMAppInfo GetAppTwitterHashKey];
        NSRange hasTag = [tweet rangeOfString:szAppKey];
        if(hasTag.location == NSNotFound)
            return NO;
        else
            return YES;
        
    }
    return NO;
}

+(BOOL)IsPublicTransitKeyword:(NSString*)szWord
{
    BOOL bRet = NO;
    
    if(szWord == nil || szWord.length <= 0)
        return bRet;
    
    NSString* szWordTestString = [szWord lowercaseString];

    NSString* szTestString = [[NOMSocialTweetHelper GetPublicTransitHashTag:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"Public Transit Delay" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"Public Transit Cancel" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"Bus Delay" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"Bus Cancel" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;

    szTestString = [[NOMSocialTweetHelper GetPublicTransitHashTag:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_TRAIN_DELAY] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"Train Delay" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"Train Cancel" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;

    szTestString = [[NOMSocialTweetHelper GetPublicTransitHashTag:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_FLIGHT_DELAY] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"Flight Delay" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"Flight Cancel" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [[NOMSocialTweetHelper GetPublicTransitHashTag:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"passengers stuck" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"passenger crowd" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"transit" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"pblic transit" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"public transportation" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    return bRet;
}

+(BOOL)IsDrivingConditionKeyword:(NSString*)szWord
{
    BOOL bRet = NO;
    
    if(szWord == nil || szWord.length <= 0)
        return bRet;
    
    NSString* szWordTestString = [szWord lowercaseString];
  
/*
    NSString* szTestString = [[StringFactory GetString_DrivingConditionTypeString:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"heavy traffic" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"traffic jam" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"slow traffic" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [[StringFactory GetString_DrivingConditionTypeString:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"crash" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"collision" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [[StringFactory GetString_DrivingConditionTypeString:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"police car" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"speed monitor" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"speed camera" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"police check point" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [[StringFactory GetString_DrivingConditionTypeString:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [[StringFactory GetString_DrivingConditionTypeString:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [[StringFactory GetString_DrivingConditionTypeString:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [[StringFactory GetString_DrivingConditionTypeString:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR] lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"stalled" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"broken car" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"traffic" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"traffic condition" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
    
    szTestString = [@"road condition" lowercaseString];
    if([szWordTestString isEqualToString:szTestString] == YES)
        return YES;
*/    
    return bRet;
}

+(BOOL)IsSearchingKeyWord:(NSString*)szTestString
{
    BOOL bRet = NO;
    
    if(szTestString == nil || szTestString.length <= 0)
        return bRet;
  

    bRet = [NOMSocialTweetHelper IsPublicTransitKeyword:szTestString];
    if(bRet)
        return bRet;

    bRet = [NOMSocialTweetHelper IsDrivingConditionKeyword:szTestString];
    if(bRet)
        return bRet;
/*
    bRet = [NOMSocialTweetHelper IsCommunityNewsKeyword:szTestString];
    if(bRet)
        return bRet;
*/
 
    return bRet;
}

+(NSArray*)GetSearchTrafficAccountList
{
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    NSArray* array = [NOMAppInfo GetHardCodedRecommededTrafficTwitterScreenNameList];
    
    return array;
}

+(NSArray*)GetSearchNewsAccountList:(int16_t)nMainCate
{
    NSArray* array = nil;
    
    if(nMainCate == NOM_NEWSCATEGORY_LOCALTRAFFIC)
        array = [NOMSocialTweetHelper GetSearchTrafficAccountList];
    
    return array;
}

+(NSString*)FormatRedLightCameraTweetString:(NOMTrafficSpotRecord*)pSpot
{
    NSString* szRet = nil;
    
    NSString* szLabel = [StringFactory GetString_PhotoRadar];
    
    szRet = [NSString stringWithFormat:@"#%@", szLabel];
    
    if(pSpot != nil)
    {
        if(pSpot.m_SpotAddress != nil && 0 < (int)pSpot.m_SpotAddress.length)
        {
            szRet = [NSString stringWithFormat:@"%@ at %@", szRet, pSpot.m_SpotAddress];
        }
        else
        {
            szRet = [NSString stringWithFormat:@"%@ at lat:%.6f long:%.6f", szRet, pSpot.m_SpotLatitude, pSpot.m_SpotLongitude];
        }

        if(NOM_PHOTORADAR_DIRECTION_NONE < pSpot.m_ThirdType)
        {
            szRet = [NSString stringWithFormat:@"%@; %@", szRet, [StringFactory GetString_TrafficDirectFullString:pSpot.m_ThirdType]];
        }
        
        if(pSpot.m_FourType <= NOM_SPEEDCAMERA_TYPE_FIXED)
        {
            szRet = [NSString stringWithFormat:@"%@; %@", szRet, [StringFactory GetString_FixedType]];
        }
        else
        {
            szRet = [NSString stringWithFormat:@"%@; %@/%@/%@", szRet, [StringFactory GetString_MobileType], [StringFactory GetString_SpeedTrap], [StringFactory GetString_PoliceCar]];
        }
    }
    
    return szRet;
}

+(NSString*)FormatSpeedCameraTweetString:(NOMTrafficSpotRecord*)pSpot
{
    NSString* szRet = nil;
    
    NSString* szLabel = [StringFactory GetString_SpeedCamera];
    
    szRet = [NSString stringWithFormat:@"#%@", szLabel];
    
    if(pSpot != nil)
    {
        if(pSpot.m_SpotAddress != nil && 0 < (int)pSpot.m_SpotAddress.length)
        {
            szRet = [NSString stringWithFormat:@"%@ at %@", szRet, pSpot.m_SpotAddress];
        }
        else
        {
            szRet = [NSString stringWithFormat:@"%@ at lat:%.6f long:%.6f", szRet, pSpot.m_SpotLatitude, pSpot.m_SpotLongitude];
        }
        
        if(NOM_PHOTORADAR_DIRECTION_NONE < pSpot.m_ThirdType)
        {
            szRet = [NSString stringWithFormat:@"%@; %@", szRet, [StringFactory GetString_TrafficDirectFullString:pSpot.m_ThirdType]];
        }
        
        if(pSpot.m_FourType <= NOM_SPEEDCAMERA_TYPE_FIXED)
        {
            szRet = [NSString stringWithFormat:@"%@; %@", szRet, [StringFactory GetString_FixedType]];
        }
        else
        {
            szRet = [NSString stringWithFormat:@"%@; %@/%@/%@", szRet, [StringFactory GetString_MobileType], [StringFactory GetString_SpeedTrap], [StringFactory GetString_PoliceCar]];
        }
    }
    
    return szRet;
}

+(NSString*)FormatSchoolZoneTweetString:(NOMTrafficSpotRecord*)pSpot
{
    NSString* szRet = nil;
    
    NSString* szLabel = [StringFactory GetString_SchoolZone];
    NSString* szSpeedLimit = [StringFactory GetString_SpeedLimit];
    
    szRet = [NSString stringWithFormat:@"%@ %@", szLabel, szSpeedLimit];

    if(pSpot != nil)
    {
        if(pSpot.m_SpotName != nil && 0 < (int)pSpot.m_SpotName.length)
        {
            szRet = [NSString stringWithFormat:@"%@ at %@; ", szRet, pSpot.m_SpotName];
        }
        
        if(pSpot.m_SpotAddress != nil && 0 < (int)pSpot.m_SpotAddress.length)
        {
            szRet = [NSString stringWithFormat:@"%@ at %@", szRet, pSpot.m_SpotAddress];
        }
    }
    
    return szRet;
}

+(NSString*)FormatPlayGroundTweetString:(NOMTrafficSpotRecord*)pSpot
{
    NSString* szRet = nil;
    
    NSString* szLabel = [StringFactory GetString_Playground];
    NSString* szSpeedLimit = [StringFactory GetString_SpeedLimit];
    
    szRet = [NSString stringWithFormat:@"%@ %@", szLabel, szSpeedLimit];
    
    if(pSpot != nil)
    {
        if(pSpot.m_SpotName != nil && 0 < (int)pSpot.m_SpotName.length)
        {
            szRet = [NSString stringWithFormat:@"%@ at %@; ", szRet, pSpot.m_SpotName];
        }
        
        if(pSpot.m_SpotAddress != nil && 0 < (int)pSpot.m_SpotAddress.length)
        {
            szRet = [NSString stringWithFormat:@"%@ at %@", szRet, pSpot.m_SpotAddress];
        }
    }
    
    return szRet;
}

+(NSString*)FormatParkingGroundTweetString:(NOMTrafficSpotRecord*)pSpot
{
    NSString* szRet = nil;
    
    NSString* szLabel = [StringFactory GetString_ParkingGround];
    
    szRet = [NSString stringWithFormat:@"#%@", szLabel];
    
    if(pSpot != nil)
    {
        if(pSpot.m_SpotName != nil && 0 < (int)pSpot.m_SpotName.length)
        {
            szRet = [NSString stringWithFormat:@"%@ %@", szRet, pSpot.m_SpotName];
        }
        
        if(pSpot.m_SpotAddress != nil && 0 < (int)pSpot.m_SpotAddress.length)
        {
            szRet = [NSString stringWithFormat:@"%@ at %@", szRet, pSpot.m_SpotAddress];
        }
        else
        {
            szRet = [NSString stringWithFormat:@"%@ at lat:%.6f long:%.6f", szRet, pSpot.m_SpotLatitude, pSpot.m_SpotLongitude];
        }
        
        if(0.0 < pSpot.m_Price)
        {
            szRet = [NSString stringWithFormat:@"%@;%@:%f", szRet, [StringFactory GetString_Price], pSpot.m_Price];
            szRet = [NSString stringWithFormat:@"%@%@", szRet, [StringFactory GetString_PriceUnit:pSpot.m_PriceUnit]];
        }
    }
    
    return szRet;
}

+(NSString*)FormatGasStationTweetString:(NOMTrafficSpotRecord*)pSpot
{
    NSString* szRet = nil;
    
    NSString* szLabel = [StringFactory GetString_GasStation];
    
    szRet = [NSString stringWithFormat:@"#%@", szLabel];
    
    if(pSpot != nil)
    {
        if(pSpot.m_SpotName != nil && 0 < (int)pSpot.m_SpotName.length)
        {
            szRet = [NSString stringWithFormat:@"%@ %@", szRet, pSpot.m_SpotName];
        }
        
        if(pSpot.m_SpotAddress != nil && 0 < (int)pSpot.m_SpotAddress.length)
        {
            szRet = [NSString stringWithFormat:@"%@ at %@", szRet, pSpot.m_SpotAddress];
        }
        else
        {
            szRet = [NSString stringWithFormat:@"%@ at lat:%.6f long:%.6f", szRet, pSpot.m_SpotLatitude, pSpot.m_SpotLongitude];
        }
        
        if(0.0 < pSpot.m_Price)
        {
            szRet = [NSString stringWithFormat:@"%@;%@:%f", szRet, [StringFactory GetString_Price], pSpot.m_Price];
            szRet = [NSString stringWithFormat:@"%@%@", szRet, [StringFactory GetString_PriceUnit:pSpot.m_PriceUnit]];
        }
        
        if(pSpot.m_SubType == NOM_GASSTATION_CARWASH_TYPE_HAVE)
        {
            szRet = [NSString stringWithFormat:@"%@. %@", szRet, [StringFactory GetString_CarWashIncluded]];
        }
    }
    
    return szRet;
}

+(NSString*)CreateTwitterTweet:(NOMTrafficSpotRecord*)pSpot
{
    NSString* szTweet = @"";

    NSString* szAppKey = [NOMAppInfo GetAppTwitterHashKey];

    NSString* szCityKey = [NOMSocialTweetHelper GetCurrentCityTwitterHashKey];
    
    NSString* szContent = nil;
    if(pSpot != nil)
    {
        int16_t spotType = pSpot.m_Type;
        int16_t spotSubType = pSpot.m_SubType;
        if(spotType == NOM_TRAFFICSPOT_PHOTORADAR && spotSubType <= NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA)
        {
            szContent = [NOMSocialTweetHelper FormatRedLightCameraTweetString:pSpot];
        }
        else if(spotType == NOM_TRAFFICSPOT_PHOTORADAR && spotSubType == NOM_PHOTORADAR_TYPE_SPEEDCAMERA)
        {
            szContent = [NOMSocialTweetHelper FormatSpeedCameraTweetString:pSpot];
        }
        else if(spotType == NOM_TRAFFICSPOT_SCHOOLZONE)
        {
            szContent = [NOMSocialTweetHelper FormatSchoolZoneTweetString:pSpot];
        }
        else if(spotType == NOM_TRAFFICSPOT_PLAYGROUND)
        {
            szContent = [NOMSocialTweetHelper FormatPlayGroundTweetString:pSpot];
        }
        else if(spotType == NOM_TRAFFICSPOT_PARKINGGROUND)
        {
            szContent = [NOMSocialTweetHelper FormatParkingGroundTweetString:pSpot];
        }
        else if(spotType == NOM_TRAFFICSPOT_GASSTATION)
        {
            szContent = [NOMSocialTweetHelper FormatGasStationTweetString:pSpot];
        }
    }
    
    szTweet = [NSString stringWithFormat:@"%@%@%@", szAppKey, szCityKey, szContent];
    
    return szTweet;
}

+(int16_t)GetPublicTransitTypeFromKeyword:(NSString*)szWord
{
    int16_t nType = -1;
    
    NSString* szWordTestString = [szWord lowercaseString];
    
    if([szWordTestString rangeOfString:NSLocalizedString(@"bus delay", @"bus delay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"busdelay", @"busdelay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"bus cancel", @"bus cancel string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"no bus", @"no bus label string")].location != NSNotFound )
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY;
    }
    
    if([szWordTestString rangeOfString:NSLocalizedString(@"train delay", @"train delay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"traindelay", @"traindelay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"train cancel", @"train cancel string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"train station closed", @"train cancel string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"freight delay", @"freight delay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"freightdelay", @"freightdelay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"freight cancel", @"freight cancel string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"ferry delay", @"ferry delay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"ferrydelay", @"ferrydelay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"ferry cancel", @"ferry cancel string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"port closed", @"port closed string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"no train", @"no train string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"train station closed", @"train station closed string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"subwaydelay", @"subwaydelay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"subway delay", @"subway delay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"subway cancel", @"subway cancel string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"no subway", @"no subway string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"subway station closed", @"subway station closed string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_TRAIN_DELAY;
    }
    
    if([szWordTestString rangeOfString:NSLocalizedString(@"flight delay", @"flight delay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"flightdelay", @"flightdelay string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"flightcancel", @"flightcancel string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"flight cancel", @"flight cancel string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_FLIGHT_DELAY;
    }
    
    return nType;
}

+(int16_t)GetDrivingConditionTypeFromKeyword:(NSString*)szWord
{
    int16_t nType = -1;

    NSString* szWordTestString = [szWord lowercaseString];

    if([szWordTestString rangeOfString:NSLocalizedString(@"traffic jam", @"traffic jam string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"slow traffic", @"slow traffic string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"stopped traffic", @"stopped traffic string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"lanes blocked", @"lanes blocked string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"lane blocked", @"lane blocked string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"queuing traffic", @"queuing traffic string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"delay", @"delay traffic string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"delays", @"delays traffic string")].location != NSNotFound )
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"car accident", @"car accident string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"car crash", @"car crash string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"car collision", @"car collision string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"car crash", @"car crash string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"traffic accident", @"traffic accident string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"vehicle accident", @"traffic accident string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"automobile accident", @"automobile accident string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"traffic collision", @"traffic collision string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"car wreck", @"car wreck string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"car smash", @"car smash string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"vehicle wreck", @"vehicle wreck string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"traffic wreck", @"traffic wreck string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"fender bender", @"fender bender string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"vehicle collision", @"vehicle collision string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"incident", @"incident string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"accident", @"accident string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"police checkpoint", @"police checkpoint string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"mobile speed camera", @"mobile speed camera traffic string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"speed camera", @"speed camera string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE;
    }
    
    if([szWordTestString rangeOfString:NSLocalizedString(@"road construction", @"road construction string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"construction zone", @"construction zone string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"construction", @"construction string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"road closure", @"road closure string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"road shutdown", @"road shutdown string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"road closed", @"road closed string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"street closure", @"street closure string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"street closed", @"street closed string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"street shutdown", @"street shutdown string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"tunnel closure", @"street closure string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"tunnel closed", @"street closed string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"tunnel shutdown", @"street shutdown string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"canal closure", @"street closure string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"canal closed", @"street closed string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"canal shutdown", @"street shutdown string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"channel closure", @"street closure string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"channel closed", @"street closed string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"channel shutdown", @"street shutdown string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"bridge closure", @"street closure string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"bridge closed", @"street closed string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"bridge shutdown", @"street shutdown string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"broken traffic light", @"broken traffic light string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"broken traffic signal", @"broken traffic signal string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"traffic light broken", @"traffic light broken string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"traffic signal broken", @"traffic signal broken string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"malfunctioning traffic light", @"malfunctioning traffic light string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"malfunctioning traffic signal", @"malfunctioning traffic signal string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"traffic light  malfunction", @"traffic light  malfunction string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"traffic signal malfunction", @"broken traffic signal string")].location != NSNotFound )
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"stalled car", @"stalled car string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"stalled vehicle", @"stalled vehicle string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"disabled car", @"disabled car string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"disabled vehicle", @"disabled vehicle string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"broken vehicle", @"broken vehicle string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"broken car", @"broken car string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"foggy condition", @"foggy condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"foggy weather", @"foggy weather string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"fog condition", @"fog condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"fog patch", @"fog patch string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"fog", @"fog traffic string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"dangerous road condition", @"dangerous road condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"dangerous driving condition", @"dangerous driving condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"worse driving condition", @"worse driving condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"worse road condition", @"worse road condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"worst driving condition", @"worst driving condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"worst road condition", @"worst road condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"bad driving condition", @"bad driving condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"bad road condition", @"bad road condition string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"rainy weather", @"rainy weather string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"rainy condition", @"rainy condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"rain", @"rain string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"icy weather", @"icy weather string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"icy condition", @"icy condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"snow weather", @"snow weather string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"snow condition", @"snow condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"snow", @"snow string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"icy", @"rain string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"windy weather", @"windy weather string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"windy condition", @"windy condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"strong wind", @"strong wind string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"windy", @"windy string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"wind", @"wind string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"lane closure", @"lane closure string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"lane shutdown", @"lane shutdown string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"reduced to one lane", @"reduced to one lane string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"reduced to two lanes", @"reduced to two lanes string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"reduced to three lanes", @"reduced to three lanes string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"reduced to four lanes", @"reduced to four lanes string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"reduced to five lanes", @"reduced to five lanes string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"lane closed", @"lane closed string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"slippery road condition", @"slippery road condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"slippery road", @"slippery road string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"slippery driving condition", @"slippery driving condition string")].location != NSNotFound ||
       [szWordTestString rangeOfString:NSLocalizedString(@"slippery", @"slippery string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE;
    }

    if([szWordTestString rangeOfString:NSLocalizedString(@"detour", @"detour string")].location != NSNotFound)
    {
        return NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR;
    }
    
    return nType;
}

@end
