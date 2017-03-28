//
//  NOMAppWatchDataHelper.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-03-31.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMAppWatchDataHelper.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"
#import "NOMAppWatchConstants.h"

#define NOM_SEARCH_MODE_SIMPLE      YES
static  BOOL m_bSearchMode = NOM_SEARCH_MODE_SIMPLE;

@implementation NOMAppWatchDataHelper

+(void)SetSimpleSearchMode:(BOOL)bSimpleMode
{
    m_bSearchMode = bSimpleMode;
}

+(BOOL)IsSimpleSearchMode
{
    return m_bSearchMode;
}

+(NSString*)GetWatchTrafficChoiceTitle:(int16_t)nWKTrafficID
{
    NSString* label = @"";
    if(nWKTrafficID == NOM_WATCH_LOCALTRAFFIC_ALL)
    {
        label = [StringFactory GetString_All];
    }
    else if(NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_JAM <= nWKTrafficID && nWKTrafficID <= NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_DETOUR)
    {
        label = [StringFactory GetString_DrivingConditionTypeString:nWKTrafficID];
    }
    else if(NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_BUS_DELAY <= nWKTrafficID && nWKTrafficID <= NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_PASSENGERSTUCK)
    {
        label = [StringFactory GetString_PublicTransitTypeString:(nWKTrafficID - NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_BUS_DELAY)];
    }
    
    return label;
}

+(NSString*)GetWatchSpotChoiceTitle:(int16_t)nWKSpotID
{
    NSString* label = @"";
    if(nWKSpotID == NOM_WATCH_TRAFFICSPOT_ALL)
    {
        label = [StringFactory GetString_All];
    }
    else if(NOM_WATCH_TRAFFICSPOT_REDLIGHTCAMERA <= nWKSpotID && nWKSpotID <= NOM_WATCH_TRAFFICSPOT_SPEEDCAMERA)
    {
        label = [StringFactory GetString_SpotSubTitle:NOM_TRAFFICSPOT_PHOTORADAR sithSubTitle:nWKSpotID];
    }
    else
    {
        label = [StringFactory GetString_SpotTitle:(nWKSpotID-1)];
    }
    return label;
}

+(NSString*)GetWatchTaxiChoiceTitle:(int16_t)nWKTaxiID
{
    NSString* label = @"";
    if(nWKTaxiID == NOM_WATCH_TAXI_ALL)
    {
        label = [StringFactory GetString_Both];
    }
    else if(NOM_WATCH_TAXI_TAXIAVAILABLEBYDRIVER == nWKTaxiID)
    {
        label = [StringFactory GetString_Taxi];
    }
    else if(nWKTaxiID == NOM_WATCH_TAXI_TAXIREQUESTBYPASSENGER)
    {
        label = [StringFactory GetString_Passenger];
    }
    return label;
}

static double g_WKMapViewSpan = 0.1; //0.12;

+(double)GetDefaultWatchMapViewMaxSpan
{
    return g_WKMapViewSpan;
}

+(void)SetDefaultWatchMapViewMaxSpan:(double)dSpan
{
    g_WKMapViewSpan = dSpan;
}

+(int16_t)GetPostUserModeTypeFromWatchActionChoice:(int16_t)nWKChoice
{
    int16_t nRet = NOM_USERMODE_POST;
    
    if(nWKChoice == NOM_WATCH_ACTION_CHOICE_SPOT)
    {
        nRet = NOM_USERMODE_MARKTRAFFICSPOT;
    }
    
    return nRet;
}

+(int16_t)GetSearchUserModeTypeFromWatchActionChoice:(int16_t)nWKChoice
{
    int16_t nRet = NOM_USERMODE_QUERY;
    
    if(nWKChoice == NOM_WATCH_ACTION_CHOICE_SPOT)
    {
        nRet = NOM_USERMODE_QUERYTRAFFICSPOT;
    }
    return nRet;
}

+(void)QueryUserModeDetailFromWatchActionChoice:(int16_t)nWKChoice actionOption:(int16_t)nOption toMainCate:(int16_t*)pMainCate toSubCate:(int16_t*)pSubCate toThirdCate:(int16_t*)pThirdCate
{
    if(nWKChoice == NOM_WATCH_ACTION_CHOICE_TRAFIC)
    {
        *pMainCate = NOM_NEWSCATEGORY_LOCALTRAFFIC;
        
        if(nOption == NOM_WATCH_LOCALTRAFFIC_ALL)
        {
            *pSubCate = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_ALL;
        }
        else if(NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_JAM <= nOption && nOption <= NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_DETOUR)
        {
            *pSubCate = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION;
            *pThirdCate = nOption;
        }
        else if(NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_BUS_DELAY <= nOption && nOption <= NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_PASSENGERSTUCK)
        {
            *pSubCate = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT;
            *pThirdCate = nOption - NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_BUS_DELAY;
        }
    }
    else if(nWKChoice == NOM_WATCH_ACTION_CHOICE_SPOT)
    {
        *pMainCate = NOM_USERMODE_MARKTRAFFICSPOT;
        *pThirdCate = 0;
        if(nOption == NOM_WATCH_TRAFFICSPOT_ALL)
        {
            *pSubCate = NOM_TRAFFICSPOT_ALL_SPEEDLIMIT;
        }
        else if(nOption == NOM_WATCH_TRAFFICSPOT_REDLIGHTCAMERA)
        {
            *pSubCate = NOM_TRAFFICSPOT_PHOTORADAR;
            *pThirdCate = NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA;
        }
        else if(nOption == NOM_WATCH_TRAFFICSPOT_SPEEDCAMERA)
        {
            *pSubCate = NOM_TRAFFICSPOT_PHOTORADAR;
            *pThirdCate = NOM_PHOTORADAR_TYPE_SPEEDCAMERA;
        }
        else if(nOption == NOM_WATCH_TRAFFICSPOT_SCHOOLZONE)
        {
            *pSubCate = NOM_TRAFFICSPOT_SCHOOLZONE;
        }
        else if(nOption == NOM_WATCH_TRAFFICSPOT_PLAYGROUND)
        {
            *pSubCate = NOM_TRAFFICSPOT_PLAYGROUND;
        }
        else if(nOption == NOM_WATCH_TRAFFICSPOT_GASSTATION)
        {
            *pSubCate = NOM_TRAFFICSPOT_GASSTATION;
        }
        else if(nOption == NOM_WATCH_TRAFFICSPOT_PARKINGGROUND)
        {
            *pSubCate = NOM_TRAFFICSPOT_PARKINGGROUND;
        }
    }
    else if(nWKChoice == NOM_WATCH_ACTION_CHOICE_TAXI)
    {
        *pMainCate = NOM_NEWSCATEGORY_TAXI;
        *pThirdCate = -1;
        if(nOption == NOM_WATCH_TAXI_ALL)
        {
            *pSubCate = NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_ALL;
        }
        else if(nOption == NOM_WATCH_TAXI_TAXIAVAILABLEBYDRIVER)
        {
            *pSubCate = NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIAVAILABLEBYDRIVER;
        }
        else if(nOption == NOM_WATCH_TAXI_TAXIREQUESTBYPASSENGER)
        {
            *pSubCate = NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIREQUESTBYPASSENGER;
        }
    }
}

+(int16_t)GetWatchAnnotationTypeFromTrafficMetaData:(int16_t)nSubCate thirdCate:(int16_t)nThirdCate
{
    int16_t nRet = NOM_WATCH_ANNOTATION_INVALID;

    if(nSubCate == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION)
    {
        if(NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST <= nThirdCate && nThirdCate <= NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_LAST)
        {
            int16_t nCount = nThirdCate - NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST;
            nRet = NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST + nCount;
            if(NOM_WATCH_ANNOTATION_TRAFFIC_DC_LAST < nRet)
            {
                nRet = NOM_WATCH_ANNOTATION_INVALID;
#ifdef DEBUG
                assert(false);
#endif
            }
        }
    }
    else if(nSubCate == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT)
    {
        if(NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_FIRST <= nThirdCate && nThirdCate <= NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_LAST)
        {
            int16_t nCount = nThirdCate - NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_FIRST;
            nRet = NOM_WATCH_ANNOTATION_TRAFFIC_PT_FIRST + nCount;
            if(NOM_WATCH_ANNOTATION_TRAFFIC_PT_LAST < nRet)
            {
                nRet = NOM_WATCH_ANNOTATION_INVALID;
#ifdef DEBUG
                assert(false);
#endif
            }
        }
    }
    
    return nRet;
}

+(int16_t)GetWatchAnnotationTypeFromTaxiMetaData:(int16_t)nSubCate thirdCate:(int16_t)nThirdCate
{
    int16_t nRet = NOM_WATCH_ANNOTATION_INVALID;
    
    if(nSubCate == NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIAVAILABLEBYDRIVER)
    {
        nRet = NOM_WATCH_ANNOTATION_TAXI_TAXIAVAILABLEBYDRIVER;
    }
    else if(nSubCate == NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIREQUESTBYPASSENGER)
    {
        nRet = NOM_WATCH_ANNOTATION_TAXI_TAXIREQUESTBYPASSENGER;
    }
    
    return nRet;
}

+(int16_t)GetWatchAnnotationTypeFromMetaData:(int16_t)nMainCate subCate:(int16_t)nSubCate thirdCate:(int16_t)nThirdCate
{
    int16_t nRet = NOM_WATCH_ANNOTATION_INVALID;
    
    if(nMainCate == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        nRet = [NOMAppWatchDataHelper GetWatchAnnotationTypeFromTrafficMetaData:nSubCate thirdCate:nThirdCate];
    }
    else if(nMainCate == NOM_NEWSCATEGORY_TAXI)
    {
        nRet = [NOMAppWatchDataHelper GetWatchAnnotationTypeFromTaxiMetaData:nSubCate thirdCate:nThirdCate];
    }
    
    return nRet;
}

+(int16_t)GetWatchAnnotationTypeFromSpotData:(int16_t)nType subCate:(int16_t)nSubType
{
    int16_t nRet = NOM_WATCH_ANNOTATION_SPOT_REDLIGHTCAMERA;//NOM_WATCH_ANNOTATION_INVALID;

    if(nType == NOM_TRAFFICSPOT_PHOTORADAR)
    {
        nRet = NOM_WATCH_ANNOTATION_SPOT_REDLIGHTCAMERA;
        if(nSubType == NOM_PHOTORADAR_TYPE_SPEEDCAMERA)
        {
            nRet = NOM_WATCH_ANNOTATION_SPOT_SPEEDCAMERA;
        }
        else if(nSubType == NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA)
        {
            nRet = NOM_WATCH_ANNOTATION_SPOT_REDLIGHTCAMERA;
        }
    }
    else if(nType == NOM_TRAFFICSPOT_SCHOOLZONE)
    {
        nRet = NOM_WATCH_ANNOTATION_SPOT_SCHOOLZONE;
    }
    else if(nType == NOM_TRAFFICSPOT_PLAYGROUND)
    {
        nRet = NOM_WATCH_ANNOTATION_SPOT_PLAYGROUND;
    }
    else if(nType == NOM_TRAFFICSPOT_GASSTATION)
    {
        nRet = NOM_WATCH_ANNOTATION_SPOT_GASSTATION;
    }
    else if(nType == NOM_TRAFFICSPOT_PARKINGGROUND)
    {
        nRet = NOM_WATCH_ANNOTATION_SPOT_PARKINGGROUND;
    }
    return nRet;
}


@end
