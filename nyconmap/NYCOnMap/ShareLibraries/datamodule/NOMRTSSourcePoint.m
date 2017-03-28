//
//  NOMRTSSourcePoint.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-12-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMRTSSourcePoint.h"

@interface NOMRTSSourcePoint ()
{
    CLLocation*                                 m_Location;
    NSString*                                   m_NameRawSource;
}
@end

@implementation NOMRTSSourcePoint

@synthesize     m_Location = m_Location;
@synthesize     m_NameRawSource = m_NameRawSource;


-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Location = nil;
        m_NameRawSource = nil;
    }
    
    return self;
}

-(id)initWith:(double)dLat longitude:(double)dLong
{
    self = [super init];
    
    if(self != nil)
    {
        m_Location = [[CLLocation alloc] initWithLatitude:dLat longitude:dLong];
        m_NameRawSource = nil;
    }
    
    return self;
}

-(id)initWith:(double)dLat longitude:(double)dLong source:(NSString*)pRawSource
{
    self = [super init];
    
    if(self != nil)
    {
        m_Location = [[CLLocation alloc] initWithLatitude:dLat longitude:dLong];
        m_NameRawSource = pRawSource;
    }
    
    return self;
}

-(void)SetData:(double)dLat longitude:(double)dLong
{
    m_Location = [[CLLocation alloc] initWithLatitude:dLat longitude:dLong];
    m_NameRawSource = nil;
}

-(void)SetData:(double)dLat longitude:(double)dLong source:(NSString*)pRawSource
{
    m_Location = [[CLLocation alloc] initWithLatitude:dLat longitude:dLong];
    m_NameRawSource = pRawSource;
}

-(double)GetLatitude
{
    double ret = 0.0;
    
    if(m_Location != nil)
        ret = m_Location.coordinate.latitude;
    
    return ret;
}

-(double)GetLongitude
{
    double ret = 0.0;
    
    if(m_Location != nil)
        ret = m_Location.coordinate.longitude;
    
    return ret;
}


@end
