//
//  NOMMapObjectController.m
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-23.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMMapObjectController.h"
#import "NOMDocumentController.h"
#import "NOMTrafficSpotObjectController.h"
#import "NOMNewsMapObjectController.h"
#import "NOMMyLocationPostAnnotation.h"
#import "NOMPostLocationAnnotation.h"
#import "NOMNewsServiceHelper.h"
#import "NOMSystemConstants.h"
#import "NOMAppWatchConstants.h"

@interface NOMMapObjectController()
{
@private
    NOMDocumentController*              m_ParentController;
    id<IMapViewDelegate>                m_MapView;
    
    NOMTrafficSpotObjectController*     m_TrafficSpotController;
    
    NOMNewsMapObjectController*         m_TrafficNewsController;
    NOMNewsMapObjectController*         m_TaxiNewsController;
    
    
    NOMMyLocationPostAnnotation*        m_MyLocationPostAnnotation;
    NOMPostLocationAnnotation*          m_LocationForPostingAnnotation;
    
    
    BOOL                                m_bMarking;
    BOOL                                m_bMarkPinForPost;
    
    //NOMWatchCommunicationManager*       m_WatchMessager;
}

@end


@implementation NOMMapObjectController

/*
-(void)RegisterWatchMessageManager:(NOMWatchCommunicationManager*)watchMessager
{
    m_WatchMessager = watchMessager;
    [m_TrafficSpotController RegisterWatchMessageManager:watchMessager];
    [m_TrafficNewsController RegisterWatchMessageManager:watchMessager];
    [m_TaxiNewsController RegisterWatchMessageManager:watchMessager];
}
*/

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
//        m_WatchMessager = nil;
        m_ParentController = nil;
        m_MapView = nil;
        m_TrafficSpotController = [[NOMTrafficSpotObjectController alloc] init];
        
        m_TrafficNewsController = [[NOMNewsMapObjectController alloc] init];
        m_TaxiNewsController = [[NOMNewsMapObjectController alloc] init];
        
        m_MyLocationPostAnnotation = [[NOMMyLocationPostAnnotation alloc] init];
        m_LocationForPostingAnnotation = [[NOMPostLocationAnnotation alloc] init];

        m_bMarking = NO;
        m_bMarkPinForPost = NO;
    }
    
    return self;
}

-(BOOL)IsLocationServiceAuthorization
{
    if(m_ParentController != nil)
    {
        return [m_ParentController IsLocationServiceAuthorization];
    }
    
    return NO;
}

-(void)CloseCallout
{
    if(m_ParentController != nil)
    {
        [m_ParentController CloseCallout];
    }
}

-(void)SetParentController:(id)parent
{
    if(parent != nil && [parent isKindOfClass:[NOMDocumentController class]])
    {
        m_ParentController = parent;
    }
}

-(void)RegisterMapView:(id<IMapViewDelegate>)mapView
{
    m_MapView = mapView;
    [m_TrafficSpotController RegisterMapView:mapView];
    [m_TrafficNewsController RegisterMapView:mapView];
    [m_TaxiNewsController RegisterMapView:mapView];
}

-(void)SetMapTypeStandard
{
    if(m_ParentController != nil)
    {
        [m_ParentController OnMenuEvent:-1];
    }
    
    if(m_MapView != nil)
    {
        [m_MapView SetMapTypeStandard];
    }
}

-(void)SetMapTypeSatellite
{
    if(m_ParentController != nil)
    {
        [m_ParentController OnMenuEvent:-1];
    }
    
    if(m_MapView != nil)
    {
        [m_MapView SetMapTypeSatellite];
    }
}

-(void)SetMapTypeHybrid
{
    if(m_ParentController != nil)
    {
        [m_ParentController OnMenuEvent:-1];
    }
    
    if(m_MapView != nil)
    {
        [m_MapView SetMapTypeHybrid];
    }
}

-(void)UpdateAnnotationDrawState
{
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController DrawAnnotions];
    }
    if(m_TrafficNewsController != nil)
    {
        [m_TrafficNewsController UpdateAnnotationDrawState];
    }
    if(m_TaxiNewsController != nil)
    {
        [m_TaxiNewsController UpdateAnnotationDrawState];
    }
}

-(void)MapViewVisualRegionChanged
{
    if(m_ParentController != nil)
    {
        [m_ParentController MapViewVisualRegionChanged];
    }
}

-(void)LoadingMapFinished
{
    if(m_ParentController != nil)
    {
        [m_ParentController LoadingMapFinished];
    }
}

-(void)MapRenderingFinished
{
    if(m_ParentController != nil)
    {
        [m_ParentController MapRenderingFinished];
    }
}

-(void)HandleMapViewTouchEvent:(CLLocationCoordinate2D)touchPoint
{
    if(m_ParentController != nil)
    {
        [m_ParentController HandleMapViewTouchEvent:touchPoint];
    }
}

-(void)HandleSearchTrafficSpotList:(NSArray*)spotList
{
    [m_TrafficSpotController HandleSearchTrafficSpotList:spotList];
}

-(void)ProcessSpotDataFromNewsData:(NOMNewsMetaDataRecord*)pNewsData
{
    if(pNewsData != nil)
    {
        NOMTrafficSpotRecord* pSpotData = [NOMNewsServiceHelper GenerateSpotDatafromNewsRecord:pNewsData];
        if(pSpotData != nil)
        {
            if(m_TrafficSpotController != nil)
            {
                [m_TrafficSpotController HandleTrafficSpotData:pSpotData];
            }
        }
    }
}

-(void)PinNewsDataOnMap:(NOMNewsMetaDataRecord*)pNewsData
{
    if(pNewsData != nil && [NOMNewsServiceHelper IsValidNewsMetaDataMainCategory:pNewsData.m_NewsMainCategory] == NO)
    {
        [self ProcessSpotDataFromNewsData:pNewsData];
        return;
    }
    
    if(pNewsData != nil && pNewsData.m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI && m_TaxiNewsController != nil)
    {
        [m_TaxiNewsController HandleNewsData:pNewsData];
    }
    else if(m_TrafficNewsController != nil)
    {
        [m_TrafficNewsController HandleNewsData:pNewsData];
    }
}

-(void)RemoveRedlightCameraSpotFromMap
{
    [self CloseCallout];
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController RemoveRedlightCameraSpotFromMap];
    }
}

-(void)RemoveSpeedCameraSpotFromMap
{
    [self CloseCallout];
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController RemoveSpeedCameraSpotFromMap];
    }
}

-(void)RemoveAllPhotoRadarSpotsFromMap
{
    [self CloseCallout];
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController RemoveAllPhotoRadarSpotsFromMap];
    }
}

-(void)RemoveSchoolZoneSpotFromMap
{
    [self CloseCallout];
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController RemoveSchoolZoneSpotFromMap];
    }
}

-(void)RemovePlayGroundSpotFromMap
{
    [self CloseCallout];
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController RemovePlayGroundSpotFromMap];
    }
}

-(void)RemoveAllSpeedLimitSpotsFromMap
{
    [self CloseCallout];
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController RemoveAllSpeedLimitSpotsFromMap];
    }
}

-(void)RemoveGasStationSpotFromMap
{
    [self CloseCallout];
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController RemoveGasStationSpotFromMap];
    }
}

-(void)RemoveParkingGroundSpotFromMap
{
    [self CloseCallout];
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController RemoveParkingGroundSpotFromMap];
    }
}

-(void)RemoveAllTrafficSpotFromMap
{
    [self CloseCallout];
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController RemoveAllTrafficSpotFromMap];
    }
}

-(void)RemoveAllTrafficNewsFromMap
{
    [self CloseCallout];
    if(m_TrafficNewsController != nil)
    {
        [m_TrafficNewsController RemoveAllNewsDataFromMap];
    }
}

-(void)ClearMapTrafficMark
{
    if(m_ParentController != nil)
    {
        [m_ParentController OnMenuEvent:-1];
    }
    [self RemoveAllTrafficNewsFromMap];
}

-(void)ClearMapSpotMark
{
    if(m_ParentController != nil)
    {
        [m_ParentController OnMenuEvent:-1];
    }
    
    [self RemoveAllTrafficSpotFromMap];
}

-(void)ClearMapTaxiDriverMark
{
    if(m_ParentController != nil)
    {
        [m_ParentController OnMenuEvent:-1];
    }
    [self RemoveTaxiDriverFromMap];
}

-(void)ClearMapTaxiPassengerMark
{
    if(m_ParentController != nil)
    {
        [m_ParentController OnMenuEvent:-1];
    }
    [self RemoveTaxiPassengerFromMap];
}

-(void)ClearAllMapTaxiPassengerMark
{
    if(m_ParentController != nil)
    {
        [m_ParentController OnMenuEvent:-1];
    }
    [self RemoveAllTaxiDataFromMap];
}

-(void)ClearAllMapMark
{
    [self ClearMapTrafficMark];
    [self ClearMapSpotMark];
    [self ClearAllMapTaxiPassengerMark];
}

-(BOOL)IsMarkPinForPost
{
    return m_bMarkPinForPost;
}

-(void)SetMarkPinForPost:(BOOL)bPost
{
    m_bMarkPinForPost = bPost;
}

-(void)SetMapMode:(BOOL)bMarking
{
    m_bMarking = bMarking;
}

-(BOOL)IsMarkingMode
{
    return m_bMarking;
}

-(void)ShowMyLocationPostAnnotation:(CLLocationCoordinate2D)location
{
    if(m_MapView != nil)
    {
        [m_MapView ShowMyLocationPostAnnotation];
        [m_MyLocationPostAnnotation SetCoordinate:location];
        [m_MapView AddAnnotation:m_MyLocationPostAnnotation];
    }
}

-(void)HideMyLocationPostAnnotation
{
    if(m_MapView != nil)
    {
        [m_MapView RemoveAnnotation:m_MyLocationPostAnnotation];
        [m_MapView HideMyLocationPostAnnotation];
    }
}

-(void)SetShowCurrentLocation:(BOOL)bShow
{
    if(m_MapView != nil)
    {
        [m_MapView SetShowCurrentLocation:bShow];
    }
}

-(void)ShowPostPinAnnotation:(CLLocationCoordinate2D)location
{
    if(m_MapView != nil)
    {
        [m_LocationForPostingAnnotation SetCoordinate:location];
        [m_MapView AddAnnotation:m_LocationForPostingAnnotation];
    }
}

-(void)HidePostPinAnnotation
{
    if(m_MapView != nil)
    {
        [m_MapView RemoveAnnotation:m_LocationForPostingAnnotation];
    }
}

-(CLLocationCoordinate2D)GetMyPostPinLocation
{
    return m_MyLocationPostAnnotation.coordinate;
}

-(CLLocationCoordinate2D)GetPostPinLocation
{
    return m_LocationForPostingAnnotation.coordinate;
}

-(void)HandleSpotRecord:(NOMTrafficSpotRecord*)pSpotData
{
    if(pSpotData != nil)
    {
        if(m_TrafficSpotController != nil)
        {
            [m_TrafficSpotController HandleTrafficSpotData:pSpotData];
        }
    }
}

-(void)StartUpdateSpotData:(NOMTrafficSpotRecord*)pSpot
{
    if(m_ParentController != nil)
    {
        [m_ParentController StartUpdateSpotData:pSpot];
    }
}

-(double)GetVisibleRegionMinimumSpan
{
    double dRet = 0.00001;
    
    if(m_MapView != nil)
    {
        MKCoordinateRegion region = [m_MapView GetVisibleRegion];
        dRet = MIN(region.span.latitudeDelta, region.span.longitudeDelta);
    }
                                     
    return dRet;
}

-(MKCoordinateRegion)GetMapViewVisibleRegion
{
    MKCoordinateRegion region;
    if(m_MapView != nil)
    {
        region = [m_MapView GetVisibleRegion];
    }
    return region;
}

-(MKMapRect)GetMapViewVisibleRect
{
    MKMapRect rect;
    if(m_MapView != nil)
    {
        rect = [m_MapView GetVisibleRect];
    }
    return rect;
}

-(void)SetMapViewVisibleRegion:(MKCoordinateRegion)region
{
    if(m_MapView != nil)
    {
        [m_MapView SetVisibleRegion:region];
    }
}

-(NOMNewsMetaDataRecord*)GetNewsRecord:(NSString*)pNewsID
{
    NOMNewsMetaDataRecord* pNews = nil;
    
    if(m_TrafficNewsController != nil)
    {
        pNews = [m_TrafficNewsController GetNewsRecord:pNewsID];
        if(pNews != nil)
            return pNews;
    }
    
    if(m_TaxiNewsController != nil)
    {
        pNews = [m_TaxiNewsController GetNewsRecord:pNewsID];
        if(pNews != nil)
            return pNews;
    }
    
    return pNews;
}

-(void)RemoveNewsRecordByTimeStamp:(int64_t)nTimeBefore
{
    if(m_TrafficNewsController != nil)
    {
        [m_TrafficNewsController RemoveNewsRecordByTimeStamp:nTimeBefore];
    }
}

-(void)RemoveTaxiNewsRecordByTimeStamp:(int64_t)nTimeBefore
{
    [self CloseCallout];
    if(m_TaxiNewsController != nil)
    {
        [m_TaxiNewsController RemoveNewsRecordByTimeStamp:nTimeBefore];
    }
}

-(void)RemoveTaxiDriverFromMap
{
    [self CloseCallout];
    if(m_TaxiNewsController != nil)
    {
        [m_TaxiNewsController RemoveNewsDataByMainCate:NOM_NEWSCATEGORY_TAXI subCate:NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIAVAILABLEBYDRIVER];
    }
}

-(void)RemoveTaxiPassengerFromMap
{
    [self CloseCallout];
    if(m_TaxiNewsController != nil)
    {
        [m_TaxiNewsController RemoveNewsDataByMainCate:NOM_NEWSCATEGORY_TAXI subCate:NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIREQUESTBYPASSENGER];
    }
}

-(void)RemoveAllTaxiDataFromMap
{
    [self CloseCallout];
    if(m_TaxiNewsController != nil)
    {
        //[m_TaxiNewsController RemoveNewsDataByMainCate:NOM_NEWSCATEGORY_TAXI];
        [m_TaxiNewsController RemoveAllNewsDataFromMap];
    }
}

//
//Apple Watch opening event
//
-(void)HandleAppleWatchOpenRequest:(NSMutableDictionary*)appData
{
    if(m_TrafficNewsController != nil)
    {
        [m_TrafficNewsController CollectNewsDataForAppleWatch:appData storageKey:EMSG_KEY_TRAFFICMESSAGE];
        [m_TrafficNewsController CollectNewsDataFromSocialMediaForAppleWatch:appData storageKey:EMSG_KEY_SOCIALTRAFFICMESSAGE];
    }
    if(m_TaxiNewsController != nil)
    {
        [m_TaxiNewsController CollectNewsDataForAppleWatch:appData storageKey:EMSG_KEY_TAXIMESSAGE];
    }
    
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController CollectSpotDataForAppleWatch:appData];
    }
    
    MKCoordinateRegion region = [self GetMapViewVisibleRegion];
  
    NSNumber* pLatitude = [[NSNumber alloc] initWithDouble:region.center.latitude];
    NSNumber* pLongitude = [[NSNumber alloc] initWithDouble:region.center.longitude];
    
    [appData setValue:pLatitude forKey:EMSG_KEY_LOCATIONLATITUDE];
    [appData setValue:pLongitude forKey:EMSG_KEY_LOCATIONLONGITUDE];
}

-(BOOL)CanHandleAppleWatchRequest
{
    if(m_TrafficNewsController != nil && [m_TrafficNewsController CanHandleAppleWatchRequest] == YES)
    {
        return YES;
    }
    if(m_TaxiNewsController != nil && [m_TaxiNewsController CanHandleAppleWatchRequest] == YES)
    {
        return YES;
    }
    if(m_TrafficSpotController != nil && [m_TrafficSpotController CanHandleAppleWatchRequest] == YES)
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)CanHandleAppleWatchRequestSearchTraffic
{
    if(m_TrafficNewsController != nil && [m_TrafficNewsController CanHandleAppleWatchRequest] == YES)
    {
        return YES;
    }
    return NO;
}

-(void)HandleAppleWatchOpenRequestSearchTraffic:(NSMutableDictionary*)appData
{
    if(m_TrafficNewsController != nil)
    {
        [m_TrafficNewsController CollectNewsDataForAppleWatch:appData storageKey:EMSG_KEY_TRAFFICMESSAGE];
        [m_TrafficNewsController CollectNewsDataFromSocialMediaForAppleWatch:appData storageKey:EMSG_KEY_SOCIALTRAFFICMESSAGE];
    }
}

-(BOOL)CanHandleAppleWatchRequestSearchTaxi
{
    if(m_TaxiNewsController != nil && [m_TaxiNewsController CanHandleAppleWatchRequest] == YES)
    {
        return YES;
    }
    return NO;
}

-(void)HandleAppleWatchOpenRequestSearchTaxi:(NSMutableDictionary*)appData
{
    if(m_TaxiNewsController != nil)
    {
        [m_TaxiNewsController CollectNewsDataForAppleWatch:appData storageKey:EMSG_KEY_TAXIMESSAGE];
    }
}

-(BOOL)CanHandleAppleWatchRequestSearchSpot
{
    if(m_TrafficSpotController != nil && [m_TrafficSpotController CanHandleAppleWatchRequest] == YES)
    {
        return YES;
    }
    
    return NO;
}

-(void)HandleAppleWatchOpenRequestSearchSpot:(NSMutableDictionary*)appData
{
    if(m_TrafficSpotController != nil)
    {
        [m_TrafficSpotController CollectSpotDataForAppleWatch:appData];
    }
}

@end
