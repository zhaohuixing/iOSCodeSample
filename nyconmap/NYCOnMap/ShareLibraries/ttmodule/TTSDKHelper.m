//
//  TTSDKHelper.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/25/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "TTSDKHelper.h"
#import "NOMSystemConstants.h"
#import <TomTomLBS/TTLBSSDK.h>

@implementation TTSDKHelper

+(int16_t)ConvertTrafficType:(int16_t)nTTIconCategory
{
    int16_t nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ALL;
    
    switch(nTTIconCategory)
    {
        case TTAPITrafficIconServerCategoryAccident:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH;
            return nRet;
        case TTAPITrafficIconServerCategoryFog:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG;
            return nRet;
        case TTAPITrafficIconServerCategoryDangerousConditions:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION;
            return nRet;
        case TTAPITrafficIconServerCategoryRain:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN;
            return nRet;
        case TTAPITrafficIconServerCategoryIce:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE;
            return nRet;
        case TTAPITrafficIconServerCategoryJam:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM;
            return nRet;
        case TTAPITrafficIconServerCategoryLaneClosed:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE;
            return nRet;
        case TTAPITrafficIconServerCategoryRoadClosure:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE;
            return nRet;
        case TTAPITrafficIconServerCategoryRoadWork:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION;
            return nRet;
        case TTAPITrafficIconServerCategoryWind:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND;
            return nRet;
        case TTAPITrafficIconServerCategorySlipRoadClosed:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE;
            return nRet;
        case TTAPITrafficIconServerCategoryDetour:
            nRet = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR;
            return nRet;
    }
    
    return nRet;
}

@end
