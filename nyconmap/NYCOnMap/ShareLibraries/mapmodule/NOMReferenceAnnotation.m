//
//  NOMReferenceAnnotation.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-19.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMReferenceAnnotation.h"
#import "NOMQueryAnnotation.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"

@interface NOMReferenceAnnotation()
{
    int16_t                     m_NewsMainCategory;
    int16_t                     m_NewsSubCategory;
    int16_t                     m_NewsThirdCategory;
    BOOL                        m_bTweet;
}
@end

@implementation NOMReferenceAnnotation

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_NewsMainCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC;
        m_NewsSubCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION;
        m_NewsThirdCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM;
        m_bTweet = NO;
    }
    
    return self;
}

-(int)GetAnnotationType
{
    return NOM_MAP_ANNOTATIONTYPE_REFERENCEPIN;
}

- (NSString *)title
{
    NSString* szRet = [StringFactory GetString_NewsTitle:m_NewsMainCategory subCategory:m_NewsSubCategory];
    if(m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        szRet = [StringFactory GetString_TrafficTypeTitle:m_NewsSubCategory withType:m_NewsThirdCategory];
    }
    
    return szRet;
}

// optional
- (NSString *)subtitle
{
    NSString* szLat = @"";
    NSString* szLon = @"";
    
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
    
    NSString* szRet = [NSString stringWithFormat:@"%@; %@", szLat, szLon];
    
    return szRet;
}

-(void)SetNewsDataMainType:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType
{
    m_NewsMainCategory = nMainCate;
    m_NewsSubCategory = nSubCate;
    m_NewsThirdCategory = nThirdType;
}

-(void)SetTwitterTweet:(BOOL)bTweet
{
    m_bTweet = bTweet;
}

-(BOOL)IsTwitterTweet
{
    return m_bTweet;
}

-(int16_t)GetPinType
{
    int16_t nType = -1;
    
    if(m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALNEWS)
    {
        nType = NOM_QUERYPIN_TYPE_PUBLIC;
    }
    else if(m_NewsMainCategory == NOM_NEWSCATEGORY_COMMUNITY)
    {
        nType = NOM_QUERYPIN_TYPE_COMMUNIT;
    }
    else if(m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        nType = NOM_QUERYPIN_TYPE_TRAFFIC;
    }
    else if(m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI)
    {
        nType = NOM_QUERYPIN_TYPE_TAXI;
    }
    
    if(nType == -1)
    {
        nType = NOM_NEWSCATEGORY_LOCALTRAFFIC;
    }
    return nType;
}

-(int16_t)GetNewsSubType
{
    int16_t nType = -1;
    nType = m_NewsSubCategory+1;
    return nType;
}

-(int16_t)GetCommunitySubType
{
    int16_t nType = -1;
    nType = m_NewsSubCategory+1;
    return nType;
}

-(int16_t)GetTrafficSubType;
{
    int16_t nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_JAM;
    
    if(m_NewsSubCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT)
    {
        //if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_DELAY)
        //{
        //    nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_DELAY;
        //}
        if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_BUS_DELAY;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_TRAIN_DELAY)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_TRAIN_DELAY;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_FLIGHT_DELAY)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_FLIGHT_DELAY;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_PASSENGERSTUCK;
        }
    }
    else if(m_NewsSubCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION)
    {
        if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_JAM;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_CRASH;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_POLICE;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_CONSTRUCTION;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_ROADCLOSURE;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_BROKENTRAFFICLIGHT;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_STALLEDCAR;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_FOG;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_DANGEROUSCONDITION;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_RAIN;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_ICE;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_WIND;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_LANECLOSURE;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_LANECLOSURE;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_SLIPROADCLOSURE;
        }
        else if(m_NewsThirdCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR)
        {
            nType = NOM_QUERYPIN_SUBTYPE_TRAFFIC_DETOUR;
        }
    }
    
    return nType;
}

-(int16_t)GetTaxiSubType
{
    int16_t nType = NOM_QUERYPIN_SUBTYPE_TAXI_DRIVER;
    
    if(m_NewsSubCategory == NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIAVAILABLEBYDRIVER)
        nType = NOM_QUERYPIN_SUBTYPE_TAXI_DRIVER;
    else if(m_NewsSubCategory == NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIREQUESTBYPASSENGER)
    nType = NOM_QUERYPIN_SUBTYPE_TAXI_PASSENGER;
    
    return nType;
}

-(int16_t)GetPinSubType
{
    int16_t nType = -1;
    
    if(m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALNEWS)
    {
        nType = NOM_QUERYPIN_TYPE_PUBLIC;
    }
    else if(m_NewsMainCategory == NOM_NEWSCATEGORY_COMMUNITY)
    {
        nType = NOM_QUERYPIN_TYPE_COMMUNIT;
    }
    else if(m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        nType = NOM_QUERYPIN_TYPE_TRAFFIC;
    }
    else if(m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI)
    {
        nType = NOM_QUERYPIN_TYPE_TAXI;
    }
    
    if(nType == -1)
    {
        nType = NOM_NEWSCATEGORY_LOCALTRAFFIC;
    }
    
    int16_t nSubType = -1;
    
    if(nType == NOM_QUERYPIN_TYPE_PUBLIC)
    {
        nSubType = [self GetNewsSubType];
    }
    else if(nType == NOM_QUERYPIN_TYPE_COMMUNIT)
    {
        nSubType = [self GetCommunitySubType];
    }
    else if(nType == NOM_QUERYPIN_TYPE_TRAFFIC)
    {
        nSubType = [self GetTrafficSubType];
    }
    else if(nType == NOM_QUERYPIN_TYPE_TAXI)
    {
        nSubType = [self GetTaxiSubType];
    }
    
    return nSubType;
}

@end
