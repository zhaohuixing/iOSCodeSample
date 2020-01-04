//
//  BTFilePlayerData.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 2012-01-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "BTFilePlayerData.h"

@implementation BTFilePlayerData
@synthesize m_Auther;
@synthesize m_Email;
@synthesize m_GameCenterPlayerID;
@synthesize m_fLatitude;
@synthesize m_fLongitude;
@synthesize m_bLocationEnable;

-(id)init
{
    self = [super init];
    if(self)
    {
        m_Auther = @"Human Being";
        m_Email = @"HumanBeing@Earth.Universe";
        m_fLatitude = -1.0;
        m_fLongitude = -1.0;
        m_GameCenterPlayerID = @"";
        m_bLocationEnable = NO;
        m_LocationManager = nil;
    }
    return self;
}

-(void)dealloc
{
    if(m_LocationManager != nil)
    {
        [m_LocationManager release];
    }
    [super dealloc];
}

-(void)Reset
{
    m_Auther = @"Human Being";
    m_Email = @"HumanBeing@Earth.Universe";
    m_GameCenterPlayerID = @"";
    m_fLatitude = -1.0;
    m_fLongitude = -1.0;
    m_bLocationEnable = NO;
}

-(BOOL)FetchLocation
{
    if(![CLLocationManager locationServicesEnabled])
    {    
        m_bLocationEnable = NO;
        return NO;
    }
    if(m_LocationManager == nil)
    {    
        m_LocationManager = [[CLLocationManager alloc] init];
        m_LocationManager.delegate = self;
        m_LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
	if (m_LocationManager)
	{
        [m_LocationManager startUpdatingLocation];
        m_bLocationEnable = YES;
        m_fLatitude = (CGFloat)m_LocationManager.location.coordinate.latitude;
        m_fLongitude = (CGFloat)m_LocationManager.location.coordinate.longitude;
        return YES;
	}
    else
    {
        m_bLocationEnable = NO;
        m_fLatitude = -1.0;
        m_fLongitude = -1.0;
        return NO;
    }
}

-(void)DisableLocation
{
    m_fLatitude = -1.0;
    m_fLongitude = -1.0;
    m_bLocationEnable = NO;
}

-(void)SaveAutherToMessage:(GameMessage*)msg withKey:(NSString*)szKey
{
    if(msg)
    {
        [msg AddMessage:szKey withString:m_Auther];
    }
}

-(void)SaveEmailToMessage:(GameMessage*)msg withKey:(NSString*)szKey
{
    if(msg)
    {
        [msg AddMessage:szKey withString:m_Email];
    }
}

-(void)SaveGameCenterPlayerIDToMessage:(GameMessage*)msg withKey:(NSString*)szKey
{
    if(msg)
    {
        [msg AddMessage:szKey withString:m_GameCenterPlayerID];
    }
}

-(void)SaveLocationEnableToMessage:(GameMessage*)msg withKey:(NSString*)szKey
{
    if(msg)
    {
        NSNumber* msgLocationEnable = [[[NSNumber alloc] initWithBool:m_bLocationEnable] autorelease]; 
        [msg AddMessage:szKey withNumber:msgLocationEnable];
    }
}

-(void)SaveLatitudeToMessage:(GameMessage*)msg withKey:(NSString*)szKey
{
    if(msg)
    {
        NSNumber* msgLatitude = [[[NSNumber alloc] initWithFloat:m_fLatitude] autorelease]; 
        [msg AddMessage:szKey withNumber:msgLatitude];
    }
}

-(void)SaveLongitudeToMessage:(GameMessage*)msg withKey:(NSString*)szKey
{
    if(msg)
    {
        NSNumber* msgLongitude = [[[NSNumber alloc] initWithFloat:m_fLongitude] autorelease]; 
        [msg AddMessage:szKey withNumber:msgLongitude];
    }
}

-(void)LoadAutherFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey
{
    if(msgData)
    {
        m_Auther = [[msgData valueForKey:szKey] copy];
    }
}

-(void)LoadEmailFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey
{
    if(msgData)
    {
        m_Email = [[msgData valueForKey:szKey] copy];
    }
}

-(void)LoadGameCenterPlayerIDFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey
{
    if(msgData)
    {
        m_GameCenterPlayerID = [[msgData valueForKey:szKey] copy];
    }
}

-(void)LoadLocationEnableToMessage:(NSDictionary*)msgData withKey:(NSString*)szKey
{
    if(msgData)
    {
        NSNumber* msgLocationEnable = [msgData valueForKey:szKey];
        if(msgLocationEnable != nil)
        {
            m_bLocationEnable = [msgLocationEnable boolValue];
        }
        else 
        {
            m_bLocationEnable = NO;
        }
    }    
}

-(void)LoadLatitudeFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey
{
    if(msgData)
    {
        NSNumber* msgLatitude = [msgData valueForKey:szKey];
        if(msgLatitude != nil)
        {
            m_fLatitude = [msgLatitude floatValue];
        }
        else
        {
            [self DisableLocation];
        }
    }
}

-(void)LoadLongitudeFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey
{
    if(msgData)
    {
        NSNumber* msgLongitude = [msgData valueForKey:szKey];
        if(msgLongitude != nil)
        {
            m_fLongitude = [msgLongitude floatValue];
        }
        else
        {
            [self DisableLocation];
        }
    }
}

-(BOOL)IsLocationEnable
{
    return (m_bLocationEnable && [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
}

-(void)SetLocationEnable:(BOOL)bEnable
{
    m_bLocationEnable = bEnable;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    m_bLocationEnable = YES;
    m_fLatitude = (CGFloat)newLocation.coordinate.latitude;
    m_fLongitude = (CGFloat)newLocation.coordinate.longitude;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    NSLog(@"Error getting Location:%@", errorType);
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status != kCLAuthorizationStatusAuthorized)
    {
        m_bLocationEnable = NO;
        if(m_LocationManager != nil)
        {
            [m_LocationManager release];
            m_LocationManager = nil;
        }
    }
    else
    {
        m_bLocationEnable = YES;
        [m_LocationManager startUpdatingLocation];
        if(manager)
        {
            m_fLatitude = (CGFloat)manager.location.coordinate.latitude;
            m_fLongitude = (CGFloat)manager.location.coordinate.longitude;
        }
    }
}
@end
