//
//  NOMTrafficSpotAnnotation.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-18.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficSpotAnnotation.h"
#import "NOMTrafficSpotPin.h"
#import "NOMTrafficSpotRecord.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"
#import "AmazonClientManager.h"
#import "NOMTimeHelper.h"

@implementation NOMTrafficSpotAnnotation

@synthesize m_NOMTrafficSpot = _m_NOMTrafficSpot;

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    m_Coordinate.latitude = newCoordinate.latitude;
    m_Coordinate.longitude = newCoordinate.longitude;
}

-(int)GetAnnotationType
{
    return NOM_MAP_ANNOTATIONTYPE_TRAFFICSPOTPIN;
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        _m_NOMTrafficSpot = nil;
        _m_Index = -1;
        _m_MyPin = nil;
    }
    return self;
}

- (NSString *)title
{
    return [self GetSpotName];
}

- (NSString *)subtitle
{
    
    NSString* szPrice = @"";
    
    if(_m_NOMTrafficSpot != nil && _m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_GASSTATION && 0.0 < _m_NOMTrafficSpot.m_Price)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDate* date = [NOMTimeHelper ConertIntegerToNSDate:_m_NOMTrafficSpot.m_PriceTime];
        
        [dateFormatter setDateFormat:@"MM"];
        int nMonth = [[dateFormatter stringFromDate:date] intValue];
        
        [dateFormatter setDateFormat:@"dd"];
        int nDay = [[dateFormatter stringFromDate:date] intValue];
        
        [dateFormatter setDateFormat:@"yyyy"];
        int nYear = [[dateFormatter stringFromDate:date] intValue];
        
        szPrice = [NSString stringWithFormat:@"%@(%i.%i.%i):%.3f %@", [StringFactory GetString_Price], nYear, nMonth, nDay, _m_NOMTrafficSpot.m_Price, [StringFactory GetString_PriceUnit:_m_NOMTrafficSpot.m_PriceUnit]];
    }
    else if(_m_NOMTrafficSpot != nil && _m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_GASSTATION && _m_NOMTrafficSpot.m_Price <= 0.0)
    {
        szPrice = [NSString stringWithFormat:@"%@: %@ (%@)", [StringFactory GetString_Price], [StringFactory GetString_EmptyString], [StringFactory GetString_AddPrice]];
    }
    else if(_m_NOMTrafficSpot != nil && _m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_PHOTORADAR && _m_NOMTrafficSpot.m_SubType <= NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA)
    {
        if(_m_NOMTrafficSpot.m_ThirdType <= NOM_PHOTORADAR_DIRECTION_NONE)
            szPrice = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_Direction], [StringFactory GetString_EmptyString]];
        else
            szPrice = [NSString stringWithFormat:@"%@", [StringFactory GetString_TrafficDirectFullString:_m_NOMTrafficSpot.m_ThirdType]];
    }
    else if(_m_NOMTrafficSpot != nil && _m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_PHOTORADAR && 0 < _m_NOMTrafficSpot.m_SubType == NOM_PHOTORADAR_TYPE_SPEEDCAMERA)
    {
        szPrice = [NSString stringWithFormat:@"%@: %@ %.3f", [StringFactory GetString_Fine], [StringFactory GetString_DollarSign], _m_NOMTrafficSpot.m_Price];
        if(_m_NOMTrafficSpot.m_ThirdType <= NOM_PHOTORADAR_DIRECTION_NONE)
        {
            if(_m_NOMTrafficSpot.m_FourType <= NOM_SPEEDCAMERA_TYPE_FIXED)
                szPrice = [NSString stringWithFormat:@"%@", [StringFactory GetString_FixedType]];
            else
                szPrice = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_MobileType], [StringFactory GetString_SpeedTrap], [StringFactory GetString_PoliceCar]];
        }
        else
        {
            if(_m_NOMTrafficSpot.m_FourType <= NOM_SPEEDCAMERA_TYPE_FIXED)
            {
                szPrice = [NSString stringWithFormat:@"%@; %@", [StringFactory GetString_TrafficDirectShortString:_m_NOMTrafficSpot.m_ThirdType], [StringFactory GetString_FixedType]];
            }
            else
            {
                szPrice = [NSString stringWithFormat:@"%@; %@/%@/%@", [StringFactory GetString_TrafficDirectShortString:_m_NOMTrafficSpot.m_ThirdType], [StringFactory GetString_MobileType], [StringFactory GetString_SpeedTrap], [StringFactory GetString_PoliceCar]];
            }
        }
    }
    else if(_m_NOMTrafficSpot != nil && _m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_PARKINGGROUND)
    {
        if(_m_NOMTrafficSpot.m_Price <= 0.0)
        {
            szPrice = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_Rate], [StringFactory GetString_EmptyString]];
        }
        else
        {
            szPrice = [NSString stringWithFormat:@"%@(%@): %f", [StringFactory GetString_Rate], [StringFactory GetString_DollarSign], _m_NOMTrafficSpot.m_Price];
        }
    }
    else if(_m_NOMTrafficSpot != nil && (_m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_SCHOOLZONE || _m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_PLAYGROUND))
    {
        if(_m_NOMTrafficSpot.m_SpotAddress == nil || _m_NOMTrafficSpot.m_SpotAddress.length <= 0)
        {
            szPrice = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_Address], [StringFactory GetString_EmptyString]];
        }
        else
        {
            szPrice = [NSString stringWithFormat:@"%@", _m_NOMTrafficSpot.m_SpotAddress];
        }
    }
    
    return szPrice;
}

-(void)SetIndex:(int)index
{
    _m_Index = index;
}

-(int)GetIndex
{
    return _m_Index;
}

-(void)Reset
{
    _m_NOMTrafficSpot = nil;
}

-(void)AddData:(NOMTrafficSpotRecord*)data
{
    [self Reset];
    _m_NOMTrafficSpot = data;
    if(_m_NOMTrafficSpot != nil)
    {
        [self SetCoordinate:_m_NOMTrafficSpot.m_SpotLongitude withLatitude:_m_NOMTrafficSpot.m_SpotLatitude];
    }
}

-(int)CheckPinType
{
    int nType = -1;
    
    if(_m_NOMTrafficSpot != nil)
    {
        return _m_NOMTrafficSpot.m_Type;
    }
    
    return nType;
}

-(NSString*)GetSpotName
{
    NSString* szRet = @"";
    if(_m_NOMTrafficSpot.m_Type != NOM_TRAFFICSPOT_PHOTORADAR)
    {
        //szRet = [StringFactory GetString_EmptyString];
        szRet = [NSString stringWithFormat:@"%@ (%@)", [StringFactory GetString_EmptyString], [StringFactory GetString_AddName]];
    //}
        if(_m_NOMTrafficSpot != nil && _m_NOMTrafficSpot.m_SpotName != nil && 0 < _m_NOMTrafficSpot.m_SpotName.length)
        {
            szRet = _m_NOMTrafficSpot.m_SpotName;
        }
        
        if(_m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_GASSTATION && _m_NOMTrafficSpot.m_SubType == NOM_GASSTATION_CARWASH_TYPE_HAVE)
        {
            szRet = [NSString stringWithFormat:@"%@ (%@)", szRet, [StringFactory GetString_CarWash]];
        }
    }
    else
    {
        if(_m_NOMTrafficSpot.m_SubType == NOM_PHOTORADAR_TYPE_SPEEDCAMERA)
            szRet = [StringFactory GetString_SpeedCamera];
        else
            szRet = [StringFactory GetString_PhotoRadar];
        
        if(0.0 < _m_NOMTrafficSpot.m_Price)
        {
            NSString* szPrice = [NSString stringWithFormat:@"(%@: %@%.2f)", [StringFactory GetString_Fine], [StringFactory GetString_DollarSign], _m_NOMTrafficSpot.m_Price];
            szRet = [NSString stringWithFormat:@"%@ %@", szRet, szPrice];
        }
        
    }
    return szRet;
}

-(double)GetSpotPrice
{
    double dPrice = 0.0;
    
    if(_m_NOMTrafficSpot != nil && 0 < _m_NOMTrafficSpot.m_Price)
    {
        dPrice = _m_NOMTrafficSpot.m_Price;
    }
    return dPrice;
}

-(int64_t)GetSpotPriceTime
{
    int64_t nTime = 0;
    
    if(_m_NOMTrafficSpot != nil && 0 < _m_NOMTrafficSpot.m_PriceTime)
    {
        nTime = _m_NOMTrafficSpot.m_PriceTime;
    }
    
    return nTime;
}

-(int16_t)GetSubType
{
    int16_t nRet = -1;
    
    if(_m_NOMTrafficSpot != nil)
    {
        nRet = _m_NOMTrafficSpot.m_SubType;
    }
    
    return nRet;
}

-(int16_t)GetThirdType
{
    int16_t nRet = -1;
    
    if(_m_NOMTrafficSpot != nil)
    {
        nRet = _m_NOMTrafficSpot.m_ThirdType;
    }
    
    return nRet;
}

-(void)RegisterMyPin:(NOMTrafficSpotPin*)pin
{
    _m_MyPin = pin;
}

-(void)DrawAnnotationView
{
    if(_m_MyPin != nil)
    {
        //[_m_MyPin setNeedsDisplay];
        [_m_MyPin UpdateZoomSize];
    }
}

@end
