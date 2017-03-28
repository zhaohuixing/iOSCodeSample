//
//  NOMLocationController.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-22.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMLocationController.h"
#import "NOMAppInfo.h"

@interface NOMLocationController ()
{
@private
    CLLocationManager*                      m_LocationManager;
    
    id<NOMLocationControllerDelegate>       m_Delegate;
    
    BOOL                                    m_bCheckingLocation;
    BOOL                                    m_bCheckingForPosting;
    //int64_t                                 m_LastStaticCheckTimeStamp;
    //int64_t                                 m_LastDrivingCheckTimeStamp;
    //int16_t                                 m_nOver
}



@end


@implementation NOMLocationController

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_LocationManager = [[CLLocationManager alloc] init];
        m_LocationManager.delegate = self;
        m_LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        m_LocationManager.distanceFilter = kCLDistanceFilterNone;
        m_Delegate = nil;
        m_bCheckingLocation = NO;
        m_bCheckingForPosting = NO;
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [self AuthorizeLocationService];
        });
    }
    
    return self;
}

-(void)AuthorizeLocationServiceVersion8
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [m_LocationManager requestAlwaysAuthorization];
        [m_LocationManager requestWhenInUseAuthorization];
    });
}

-(void)AuthorizeLocationServiceLowerVersion
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [CLLocationManager authorizationStatus];
    });
}


-(void)AuthorizeLocationService
{
    if([NOMAppInfo IsVersion8] == YES)
    {
        [self AuthorizeLocationServiceVersion8];
    }
    else
    {
        [self AuthorizeLocationServiceLowerVersion];
    }
}

-(void)AttachDelegate:(id<NOMLocationControllerDelegate>)delgate
{
    m_Delegate = delgate;
}

-(void)Reset
{
    m_bCheckingLocation = NO;
    m_bCheckingForPosting = NO;
    [m_LocationManager stopUpdatingLocation];
}

-(void)CheckCurrentLocation:(BOOL)bCheckForPost
{
    if(m_bCheckingLocation == NO)
    {
        m_bCheckingLocation = YES;
        m_bCheckingForPosting = bCheckForPost;
        m_LocationManager.delegate = self;
        [m_LocationManager startUpdatingLocation];
    }
}

-(BOOL)IsCheckingLocation
{
    return m_bCheckingLocation;
}

-(BOOL)IsCheckForPosting
{
    return m_bCheckingForPosting;
}

-(void)SetCheckForPosting:(BOOL)bCheckForPost
{
    m_bCheckingForPosting = bCheckForPost;
}

-(CLLocation*)GetLocation
{
    return m_LocationManager.location;
}

-(BOOL)LocationServiceEnable
{
    return ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
}

#pragma mark - CLLocationManagerDelegate Implementations
//
//CLLocationManagerDelegate Implementations
//

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region");
#endif
    if(m_Delegate && m_bCheckingLocation == YES)
        [m_Delegate LocationUpdateCompleted:YES];

    m_bCheckingLocation = NO;
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region");
#endif
    if(m_Delegate && m_bCheckingLocation == YES)
        [m_Delegate LocationUpdateCompleted:YES];

    m_bCheckingLocation = NO;
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region");
#endif
    if(m_Delegate && m_bCheckingLocation == YES)
        [m_Delegate LocationUpdateCompleted:YES];

    m_bCheckingLocation = NO;
}


//Failed
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error");
#endif
    if(m_Delegate)
    {
        [m_Delegate LocationUpdateCompleted:NO];
        m_bCheckingForPosting = NO;
    }

    m_bCheckingLocation = NO;
}

//Failed
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error. Reason:%@", error.description);
    NSLog(@"locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error. Debug:%@", error.debugDescription);
#endif
    if(m_Delegate)
    {
        [m_Delegate LocationUpdateCompleted:NO];
        m_bCheckingForPosting = NO;
    }

    m_bCheckingLocation = NO;
}

//Authorization
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status");
#endif
    
    if(status == kCLAuthorizationStatusDenied)
    {
        if(m_Delegate)
            [m_Delegate LocationServiceNotAvaliable];
        m_bCheckingForPosting = NO;
    }
    else if(m_Delegate && status != kCLAuthorizationStatusNotDetermined)
    {
        [m_Delegate LocationUpdateCompleted:YES];
    }

    m_bCheckingLocation = NO;
}

//Deprecated
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation");
#endif
    if(m_Delegate && m_bCheckingLocation == YES)
        [m_Delegate LocationUpdateCompleted:YES];

    m_bCheckingLocation = NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations");
#endif
    if(m_Delegate && m_bCheckingLocation == YES)
        [m_Delegate LocationUpdateCompleted:YES];
    
    m_bCheckingLocation = NO;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading");
#endif
}

/*
 *  locationManager:didDetermineState:forRegion:
 *
 *  Discussion:
 *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
 *    a call to requestStateForRegion:.
 */
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region");
#endif
}

/*
 *  locationManager:didRangeBeacons:inRegion:
 *
 *  Discussion:
 *    Invoked when a new set of beacons are available in the specified region.
 *    beacons is an array of CLBeacon objects.
 *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
 *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
 *    by the device.
 */
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region");
#endif
}

/*
 *  locationManager:rangingBeaconsDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error");
#endif
}

/*
 *  Discussion:
 *    Invoked when location updates are automatically paused.
 */
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
#ifdef DEBUG
    NSLog(@"locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager");
#endif
}

/*
 *  Discussion:
 *    Invoked when location updates are automatically resumed.
 *
 *    In the event that your application is terminated while suspended, you will
 *	  not receive this notification.
 */
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
#ifdef DEBUG
    NSLog(@"locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager");
#endif
}

/*
 *  locationManager:didFinishDeferredUpdatesWithError:
 *
 *  Discussion:
 *    Invoked when deferred updates will no longer be delivered. Stopping
 *    location, disallowing deferred updates, and meeting a specified criterion
 *    are all possible reasons for finishing deferred updates.
 *
 *    An error will be returned if deferred updates end before the specified
 *    criteria are met (see CLError).
 */
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error");
#endif
}

/*
 *  locationManager:didVisit:
 *
 *  Discussion:
 *    Invoked when the CLLocationManager determines that the device has visited
 *    a location, if visit monitoring is currently started (possibly from a
 *    prior launch).
 */
- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
#ifdef DEBUG
    NSLog(@"locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit");
#endif
}


@end
