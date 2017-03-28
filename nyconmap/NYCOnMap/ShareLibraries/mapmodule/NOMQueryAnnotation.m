//
//  NOMQueryAnnotation.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMQueryAnnotation.h"
#import "NOMNewsMetaDataRecord.h"
#import "NOMQueryLocationPin.h"
#import "NOMGEOConfigration.h"
#import "StringFactory.h"
#import "NOMTimeHelper.h"
#include "NOMMapConstants.h"
#include "NOMSystemConstants.h"

@implementation NOMQueryAnnotation

@synthesize m_NOMMetaDataList = _m_NOMMetaDataList;
@synthesize m_ActiveView = _m_ActiveView;

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        _m_NOMMetaDataList = [[NSMutableArray alloc] init];
        _m_Index = -1;
        _m_bActive = NO;
        _m_ActiveView = nil;
    }
    return self;
}

-(void)dealloc
{
    _m_ActiveView = nil;
    [_m_NOMMetaDataList removeAllObjects];
}

-(void)SetIndex:(int)index
{
    _m_Index = index;
}

-(void)SetActive:(BOOL)bActive
{
    _m_bActive = bActive;
}

-(BOOL)IsActive
{
    return _m_bActive;
}

-(int)GetIndex
{
    return _m_Index;
}

-(void)Reset
{
    _m_bActive = NO;
    _m_ActiveView = nil;
    [_m_NOMMetaDataList removeAllObjects];
}

-(void)AddData:(NOMNewsMetaDataRecord*)data
{
    [data RegisterLocationUpdateDelegate:self];
    [_m_NOMMetaDataList addObject:data];
}

-(int)CheckPinType
{
    int nType = -1;
    
    if(0 < _m_NOMMetaDataList.count)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil)
            {
                if(pRecord.m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALNEWS)
                {
                    if(nType < 0 || nType == NOM_QUERYPIN_TYPE_PUBLIC)
                    {
                        nType = NOM_QUERYPIN_TYPE_PUBLIC;
                    }
                    else
                    {
                        nType = NOM_QUERYPIN_TYPE_MIXED;
                        break;
                    }
                }
                else if(pRecord.m_NewsMainCategory == NOM_NEWSCATEGORY_COMMUNITY)
                {
                    if(nType < 0 || nType == NOM_QUERYPIN_TYPE_COMMUNIT)
                    {
                        nType = NOM_QUERYPIN_TYPE_COMMUNIT;
                    }
                    else
                    {
                        nType = NOM_QUERYPIN_TYPE_MIXED;
                        break;
                    }
                }
                else if(pRecord.m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
                {
                    if(nType < 0 || nType == NOM_QUERYPIN_TYPE_TRAFFIC)
                    {
                        nType = NOM_QUERYPIN_TYPE_TRAFFIC;
                    }
                    else
                    {
                        nType = NOM_QUERYPIN_TYPE_MIXED;
                        break;
                    }
                }
                else if(pRecord.m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI)
                {
                    nType = NOM_QUERYPIN_TYPE_TAXI;
                    break;
                }
            }
        }
    }
    
    if(nType == -1)
    {
        nType = NOM_QUERYPIN_TYPE_MIXED;
    }
    return nType;
}

-(int)GetNewsSubType
{
    int nType = -1;
    
    int nCacheType = -1;
    if(0 < _m_NOMMetaDataList.count)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            nCacheType = -1;
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil)
            {
                if(pRecord.m_NewsMainCategory != NOM_NEWSCATEGORY_LOCALNEWS)
                    return -1;
        
                switch(pRecord.m_NewsSubCategory)
                {
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_PUBLICISSUE:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_POLITICS:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_BUSINESS:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_MONEY:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_HEALTH:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_SPORTS:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ARTANDENTERTAINMENT:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_EDUCATION:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TECHNOLOGYANDSCIENCE:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_FOODANDDRINK:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TRAVELANDTOURISM:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_LIFESTYLE:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_REALESTATE:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_AUTO:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CRIMEANDDISASTER:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_WEATHER:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CHARITY:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CULTURE:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_RELIGION:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ANIMALPET:
                    case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_MISC:
                        nCacheType = pRecord.m_NewsSubCategory+1;
                        break;
                    default:
                        break;
                }
            }
            if(nType < 0)
            {
                if(0 < nCacheType)
                    nType = nCacheType;
            }
            else
            {
                if(0 < nCacheType)
                {
                    if(nType != nCacheType)
                        return NOM_QUERYPIN_SUBTYPE_PUBLIC_MIX;
                }
            }
        }
    }
    
    return nType;
}

-(int)GetCommunitySubType
{
    int nType = -1;
    
    int nCacheType = -1;
    if(0 < _m_NOMMetaDataList.count)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            nCacheType = -1;
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil)
            {
                if(pRecord.m_NewsMainCategory != NOM_NEWSCATEGORY_COMMUNITY)
                    return -1;
                
                switch(pRecord.m_NewsSubCategory)
                {
                    case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYEVENT:
                    case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYYARDSALE:
                    case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYWIKI:
                        nCacheType = pRecord.m_NewsSubCategory+1;
                        break;
                    default:
                        break;
                }
            }
            if(nType < 0)
            {
                if(0 < nCacheType)
                    nType = nCacheType;
            }
            else
            {
                if(0 < nCacheType)
                {
                    if(nType != nCacheType)
                        return NOM_QUERYPIN_SUBTYPE_COMMUNITY_MIX;
                }
            }
        }
    }
    
    return nType;
}

-(int)GetTrafficSubType;
{
    int nType = -1;
    int nSubCatogery = -1;
    
    int nCacheType = -1;
    int nCacheCatogery = -1;
    if(0 < _m_NOMMetaDataList.count)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            nCacheType = -1;
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil)
            {
                if(pRecord.m_NewsMainCategory != NOM_NEWSCATEGORY_LOCALTRAFFIC)
                    return -1;
                
                nCacheCatogery = pRecord.m_NewsSubCategory;
                if(nSubCatogery < 0)
                {
                    if(0 < nCacheCatogery)
                        nSubCatogery = nCacheCatogery;
                }
             /*   else
                {
                    if(nSubCatogery != nCacheCatogery)
                        return NOM_QUERYPIN_SUBTYPE_TRAFFIC_MIX;
                }
             */
                if(nCacheCatogery == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT)
                {
                    //if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_DELAY)
                    //{
                    //    nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_DELAY;
                    //}
                    if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_BUS_DELAY;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_TRAIN_DELAY)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_TRAIN_DELAY;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_FLIGHT_DELAY)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_FLIGHT_DELAY;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_PASSENGERSTUCK;
                    }
                    if(nType < 0)
                    {
                        if(0 < nCacheType)
                            nType = nCacheType;
                    }
                    else
                    {
                        if(0 < nCacheType)
                        {
                            if(nType != nCacheType)
                            {
                                //return NOM_QUERYPIN_SUBTYPE_TRAFFIC_MIX;
                                return nCacheType;
                            }
                        }
                    }
                }
                else if(nCacheCatogery == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION)
                {
                    if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_JAM;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_CRASH;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_POLICE;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_CONSTRUCTION;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_ROADCLOSURE;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_BROKENTRAFFICLIGHT;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_STALLEDCAR;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_FOG;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_DANGEROUSCONDITION;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_RAIN;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_ICE;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_WIND;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_LANECLOSURE;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_LANECLOSURE;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_SLIPROADCLOSURE;
                    }
                    else if(pRecord.m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR)
                    {
                        nCacheType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_DETOUR;
                    }
                    if(nType < 0)
                    {
                        if(0 < nCacheType)
                            nType = nCacheType;
                    }
                    else
                    {
                        if(0 < nCacheType)
                        {
                            if(nType != nCacheType)
                            {
                                //return NOM_QUERYPIN_SUBTYPE_TRAFFIC_MIX;
                                return nCacheType;
                            }
                        }
                    }
                }
            }
        }
    }
    
    return nType;
}

-(int)GetTaxiSubType
{
    int nType = NOM_QUERYPIN_SUBTYPE_TAXI_DRIVER;
    
    if(0 < _m_NOMMetaDataList.count)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil)
            {
                if(pRecord.m_NewsMainCategory != NOM_NEWSCATEGORY_TAXI)
                    return -1;
                
                if(pRecord.m_NewsSubCategory == NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIAVAILABLEBYDRIVER)
                    return NOM_QUERYPIN_SUBTYPE_TAXI_DRIVER;
                else if(pRecord.m_NewsSubCategory == NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIREQUESTBYPASSENGER)
                    return NOM_QUERYPIN_SUBTYPE_TAXI_PASSENGER;
            }
        }
    }
    
    return nType;
}


-(BOOL)IsDrivingConditionType
{
    BOOL bRet = NO;
    
    if(0 < _m_NOMMetaDataList.count)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil)
            {
                if(pRecord.m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC && pRecord.m_NewsSubCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION)
                {
                    return YES;
                }
            }
        }
    }
    
    return bRet;
}

-(int)GetSubType:(int)nPinType
{
    int nType = -1;
    
    if(nPinType == NOM_QUERYPIN_TYPE_PUBLIC)
    {
        nType = [self GetNewsSubType];
    }
    else if(nPinType == NOM_QUERYPIN_TYPE_COMMUNIT)
    {
        nType = [self GetCommunitySubType];
    }
    else if(nPinType == NOM_QUERYPIN_TYPE_TRAFFIC)
    {
        nType = [self GetTrafficSubType];
    }
    else if(nPinType == NOM_QUERYPIN_TYPE_TAXI)
    {
        nType = [self GetTaxiSubType];
    }
    
    return nType;
}

-(int)GetAnnotationType
{
    return NOM_MAP_ANNOTATIONTYPE_QUERYPIN;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    if([self CheckPinType] == NOM_QUERYPIN_TYPE_TAXI)
    {
        int nSubType = [self GetTaxiSubType];
        NSString* szTile = nil;
        if(nSubType == NOM_QUERYPIN_SUBTYPE_TAXI_DRIVER)
            szTile = [StringFactory GetString_NewsTitle:NOM_NEWSCATEGORY_TAXI subCategory:NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIAVAILABLEBYDRIVER];
        else if(nSubType == NOM_QUERYPIN_SUBTYPE_TAXI_PASSENGER)
            szTile = [StringFactory GetString_NewsTitle:NOM_NEWSCATEGORY_TAXI subCategory:NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIREQUESTBYPASSENGER];
        return szTile;
    }
    return m_Title;
}

// optional
- (NSString *)subtitle
{
    if(0 < _m_NOMMetaDataList.count && [self CheckPinType] == NOM_QUERYPIN_TYPE_TAXI)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil && pRecord.m_NewsID != nil && pRecord.m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI)
            {
                NSDate* time = [NOMTimeHelper ConertIntegerToNSDate:pRecord.m_nNewsTime];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                return [formatter stringFromDate:time];
            }
        }
    }
    
    NSString* szLat = @"";
    NSString* szLon = @"";
/*
    if(0 <= m_Coordinate.latitude)
    {
        szLat = [NSString stringWithFormat:@"%@:%f N", [StringFactory GetString_LantitudeABV], m_Coordinate.latitude];
    }
    else
    {
        szLat = [NSString stringWithFormat:@"%@:%f S", [StringFactory GetString_LantitudeABV], fabs(m_Coordinate.latitude)];
    }
    if(0 <= m_Coordinate.longitude)
    {
        szLon = [NSString stringWithFormat:@"%@:%f E", [StringFactory GetString_LongitudeABV], m_Coordinate.longitude];
    }
    else
    {
        szLon = [NSString stringWithFormat:@"%@:%f W", [StringFactory GetString_LongitudeABV], fabs(m_Coordinate.longitude)];
    }
*/
    if([self IsTwitterTweet] == NO)
    {
        NSString* szRet = [NSString stringWithFormat:@"%@; %@", szLat, szLon];
    
        return szRet;
    }
    else
    {
        return [self GetTwitterAutherDisplayName];
    }
}

-(int)GetNewsDataIndex:(NSString*)szNewsID
{
    int nRet = -1;
    if(0 < _m_NOMMetaDataList.count)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil && pRecord.m_NewsID != nil)
            {
                if([pRecord.m_NewsID isEqualToString:szNewsID] == YES)
                    return i;
            }
        }
    }
    
    return nRet;
}

-(NOMNewsMetaDataRecord*)GetNewsData:(NSString*)szNewsID
{
    NOMNewsMetaDataRecord* pRet = nil;
    if(0 < _m_NOMMetaDataList.count)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil && pRecord.m_NewsID != nil)
            {
                if([pRecord.m_NewsID isEqualToString:szNewsID] == YES)
                    return pRecord;
            }
        }
    }
    
    return pRet;
}

-(int)NewsDataCount
{
    return (int)_m_NOMMetaDataList.count;
}

-(void)RemoveData:(int)index
{
    if(0 < _m_NOMMetaDataList.count && 0 <= index && index < _m_NOMMetaDataList.count)
    {
        [_m_NOMMetaDataList removeObjectAtIndex:index];
    }
}

-(void)ShowAlert
{
    if(_m_ActiveView != nil)
        [_m_ActiveView ShowAlert];
}

-(BOOL)IsTwitterTweet
{
    if(0 < _m_NOMMetaDataList.count)
    {
        for(int i = 0; i < _m_NOMMetaDataList.count; ++i)
        {
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:i];
            if(pRecord != nil && pRecord.m_bTwitterTweet == YES)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

-(NSString*)GetTwitterAutherDisplayName
{
    if(_m_NOMMetaDataList != nil && 0 < _m_NOMMetaDataList.count)
    {
        NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:0];
        if(pRecord != nil && pRecord.m_bTwitterTweet == YES)
        {
            return pRecord.m_NewsPosterDisplayName;
        }
    }
    
    return @"";
}

-(void)LocationUpdated:(NOMNewsMetaDataRecord*)pMetaData
{
    if((_m_NOMMetaDataList == nil && _m_NOMMetaDataList.count <= 0) || pMetaData == nil)
        return;
    
    if(_m_NOMMetaDataList.count == 1)
    {
        [self SetCoordinate:pMetaData.m_NewsLongitude withLatitude:pMetaData.m_NewsLatitude];
        [_m_ActiveView ReloadInformation];
        return;
    }
    else
    {
        int index = [self GetNewsDataIndex:pMetaData.m_NewsID];
        if(0 <= index)
        {
            [self RemoveData:index];
        }
        id<NOMQueryAnnotationDataDelegate> pDelegate = [NOMGEOConfigration GetNOMQueryAnnotationDataDelegate];
        [pDelegate QueryAnnontationDataChanged:pMetaData];
    }
}

-(int16_t)GetMainDataCateType
{
    int16_t nMainCate = NOM_NEWSCATEGORY_LOCALTRAFFIC;
    
    if(_m_NOMMetaDataList != nil && 0 < _m_NOMMetaDataList.count)
    {
        NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[_m_NOMMetaDataList objectAtIndex:0];
        if(pRecord != nil)
        {
            return pRecord.m_NewsMainCategory;
        }
    }
    
    return nMainCate;
}

@end
