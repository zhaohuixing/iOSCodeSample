//
//  NOMTrafficSpotRecord.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficSpotRecord.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"
#import "NOMAppWatchConstants.h"
#import "NOMAppWatchDataHelper.h"

@interface NOMTrafficSpotRecord ()
{
@private
    NSString*                   _m_SpotID;
    NSString*                   _m_SpotName;
    NSString*                   _m_SpotAddress;
    double                      _m_SpotLatitude;
    double                      _m_SpotLongitude;
    int16_t                     _m_Type;
    int16_t                     _m_SubType;
    int16_t                     _m_ThirdType;
    int16_t                     _m_FourType;
    double                      _m_Price;
    int64_t                     _m_PriceTime;
    int16_t                     _m_PriceUnit;
}

@end

@implementation NOMTrafficSpotRecord

@synthesize m_SpotID = _m_SpotID;
@synthesize m_SpotName = _m_SpotName;
@synthesize m_SpotAddress = _m_SpotAddress;
@synthesize m_SpotLatitude = _m_SpotLatitude;
@synthesize m_SpotLongitude = _m_SpotLongitude;
@synthesize m_Type = _m_Type;
@synthesize m_SubType = _m_SubType;
@synthesize m_ThirdType = _m_ThirdType;
@synthesize m_FourType = _m_FourType;
@synthesize m_Price = _m_Price;
@synthesize m_PriceTime = _m_PriceTime;
@synthesize m_PriceUnit = _m_PriceUnit;

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = nil;
        _m_SpotName = nil;
        _m_SpotLatitude = 0;
        _m_SpotLongitude = 0;
        _m_Type = 0;
        _m_SubType = -1;
        _m_SpotAddress = nil;
        _m_Price = 0.0;
        _m_PriceTime = 0;
        _m_PriceUnit = 0;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}

-(id)initWithID:(NSString*)spotID withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType;
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotName = nil;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = 0.0;
        _m_PriceTime = 0;
        _m_PriceUnit = 0;
        _m_SubType = -1;
        _m_SpotAddress = nil;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}

-(id)initWithID:(NSString*)spotID withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withPrice:(double)dPrice withTime:(int64_t)nTime withUnit:(int16_t)nUnit
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotName = nil;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = dPrice;
        _m_PriceTime = nTime;
        _m_PriceUnit = nUnit;
        _m_SubType = -1;
        _m_SpotAddress = nil;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}

-(id)initWithID:(NSString*)spotID withName:(NSString*)spotName withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType;
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotName = spotName;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = 0.0;
        _m_PriceTime = 0;
        _m_PriceUnit = 0;
        _m_SubType = -1;
        _m_SpotAddress = nil;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}

-(id)initWithID:(NSString*)spotID withName:(NSString*)spotName withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withPrice:(double)dPrice withTime:(int64_t)nTime withUnit:(int16_t)nUnit
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotName = spotName;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = dPrice;
        _m_PriceTime = nTime;
        _m_PriceUnit = nUnit;
        _m_SubType = -1;
        _m_SpotAddress = nil;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}

-(id)initWithID:(NSString*)spotID withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withSubType:(int16_t)nSubType
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotName = nil;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = 0.0;
        _m_PriceTime = 0;
        _m_PriceUnit = 0;
        _m_SubType = nSubType;
        _m_SpotAddress = nil;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}


-(id)initWithID:(NSString*)spotID withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withSubType:(int16_t)nSubType withPrice:(double)dPrice
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotName = nil;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = dPrice;
        _m_PriceTime = 0;
        _m_PriceUnit = 0;
        _m_SubType = nSubType;
        _m_SpotAddress = nil;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}

-(id)initWithID:(NSString*)spotID withAddress:(NSString*)address withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withSubType:(int16_t)nSubType
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotAddress = address;
        _m_SpotName = nil;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = 0.0;
        _m_PriceTime = 0;
        _m_PriceUnit = 0;
        _m_SubType = nSubType;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}


-(id)initWithID:(NSString*)spotID withAddress:(NSString*)address withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withSubType:(int16_t)nSubType withPrice:(double)dPrice
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotAddress = address;
        _m_SpotName = nil;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = dPrice;
        _m_PriceTime = 0;
        _m_PriceUnit = 0;
        _m_SubType = nSubType;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}


-(id)initWithID:(NSString*)spotID withName:(NSString*)spotName withAddress:(NSString*)address withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotName = spotName;
        _m_SpotAddress = address;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = 0.0;
        _m_PriceTime = 0;
        _m_PriceUnit = 0;
        _m_SubType = -1;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}


-(id)initWithID:(NSString*)spotID withName:(NSString*)spotName withAddress:(NSString*)address withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withPrice:(double)dPrice withTime:(int64_t)nTime withUnit:(int16_t)nUnit
{
    self = [super init];
    if(self != nil)
    {
        _m_SpotID = spotID;
        _m_SpotName = spotName;
        _m_SpotAddress = address;
        _m_SpotLatitude = lat;
        _m_SpotLongitude = lon;
        _m_Type = nType;
        _m_Price = dPrice;
        _m_PriceTime = nTime;
        _m_PriceUnit = nUnit;
        _m_SubType = -1;
        _m_ThirdType = -1;
        _m_FourType = -1;
    }
    return self;
}

-(NOMWatchMapAnnotation*)CreateWatchAnnotation
{
    NOMWatchMapAnnotation* pAnnotation = [[NOMWatchMapAnnotation alloc] init];
    
    pAnnotation.m_AnnotationID = _m_SpotID;
    pAnnotation.m_Latitude = _m_SpotLatitude;
    pAnnotation.m_Longitude = _m_SpotLongitude;
    pAnnotation.m_AnnotationType = [NOMAppWatchDataHelper GetWatchAnnotationTypeFromSpotData:_m_Type subCate:_m_SubType];
    
    return pAnnotation;
}

-(NSDictionary*)CreateWatchAnnotationKeyValueBlock
{
    int16_t nType = [NOMAppWatchDataHelper GetWatchAnnotationTypeFromSpotData:_m_Type subCate:_m_SubType];
    
    NSString* pID = [NSString stringWithFormat:@"%@", _m_SpotID];
    NSNumber* pType = [[NSNumber alloc] initWithInt:nType];
    NSNumber* pLatitude = [[NSNumber alloc] initWithDouble:_m_SpotLatitude];
    NSNumber* pLongitude = [[NSNumber alloc] initWithDouble:_m_SpotLongitude];
    
    NSDictionary *messageData =   [NSDictionary dictionaryWithObjectsAndKeys:
                                   pID, EMSG_KEY_ANNOTATIONID,
                                   pType, EMSG_KEY_ANNOTATIONTYPE,
                                   pLatitude, EMSG_KEY_LOCATIONLATITUDE,
                                   pLongitude, EMSG_KEY_LOCATIONLONGITUDE,
                                   nil];
    
    return messageData;
}


@end
