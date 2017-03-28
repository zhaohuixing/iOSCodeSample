//
//  NOMMapObjectController.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-23.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NOMTrafficSpotRecord.h"
#import "IMapObjectController.h"
#import "NOMNewsMetaDataRecord.h"
//#import "NOMWatchCommunicationManager.h"

@interface NOMMapObjectController : NSObject<IMapObjectController>

-(void)SetParentController:(id)parent;
-(void)RegisterMapView:(id<IMapViewDelegate>)mapView;
-(void)SetMapTypeStandard;
-(void)SetMapTypeSatellite;
-(void)SetMapTypeHybrid;
-(void)MapViewVisualRegionChanged;
-(void)UpdateAnnotationDrawState;
-(void)HandleSearchTrafficSpotList:(NSArray*)spotList;
-(void)HandleMapViewTouchEvent:(CLLocationCoordinate2D)touchPoint;
-(void)PinNewsDataOnMap:(NOMNewsMetaDataRecord*)pNewsData;

-(MKCoordinateRegion)GetMapViewVisibleRegion;
-(MKMapRect)GetMapViewVisibleRect;
-(void)SetMapViewVisibleRegion:(MKCoordinateRegion)region;

-(void)ClearMapTrafficMark;
-(void)ClearMapSpotMark;
-(void)ClearAllMapMark;

-(void)RemoveRedlightCameraSpotFromMap;
-(void)RemoveSpeedCameraSpotFromMap;
-(void)RemoveAllPhotoRadarSpotsFromMap;
-(void)RemoveSchoolZoneSpotFromMap;
-(void)RemovePlayGroundSpotFromMap;
-(void)RemoveAllSpeedLimitSpotsFromMap;
-(void)RemoveGasStationSpotFromMap;
-(void)RemoveParkingGroundSpotFromMap;
-(void)RemoveAllTrafficSpotFromMap;

-(BOOL)IsMarkPinForPost;
-(void)SetMarkPinForPost:(BOOL)bPost;
-(void)SetMapMode:(BOOL)bMarking;
-(BOOL)IsMarkingMode;

-(void)ShowMyLocationPostAnnotation:(CLLocationCoordinate2D)location;
-(void)HideMyLocationPostAnnotation;
-(void)ShowPostPinAnnotation:(CLLocationCoordinate2D)location;
-(void)HidePostPinAnnotation;
-(void)SetShowCurrentLocation:(BOOL)bShow;

-(CLLocationCoordinate2D)GetMyPostPinLocation;
-(CLLocationCoordinate2D)GetPostPinLocation;

-(void)HandleSpotRecord:(NOMTrafficSpotRecord*)pSpotData;
-(void)StartUpdateSpotData:(NOMTrafficSpotRecord*)pSpot;
-(double)GetVisibleRegionMinimumSpan;

-(NOMNewsMetaDataRecord*)GetNewsRecord:(NSString*)pNewsID;

-(BOOL)IsLocationServiceAuthorization;

-(void)RemoveNewsRecordByTimeStamp:(int64_t)nTimeBefore;

-(void)RemoveTaxiNewsRecordByTimeStamp:(int64_t)nTimeBefore;
-(void)RemoveTaxiDriverFromMap;
-(void)RemoveTaxiPassengerFromMap;
-(void)RemoveAllTaxiDataFromMap;

-(void)ClearMapTaxiDriverMark;
-(void)ClearMapTaxiPassengerMark;
-(void)ClearAllMapTaxiPassengerMark;

//
//Apple Watch opening event
//
-(void)HandleAppleWatchOpenRequest:(NSMutableDictionary*)appData;
-(BOOL)CanHandleAppleWatchRequest;

-(BOOL)CanHandleAppleWatchRequestSearchTraffic;
-(void)HandleAppleWatchOpenRequestSearchTraffic:(NSMutableDictionary*)appData;

-(BOOL)CanHandleAppleWatchRequestSearchTaxi;
-(void)HandleAppleWatchOpenRequestSearchTaxi:(NSMutableDictionary*)appData;

-(BOOL)CanHandleAppleWatchRequestSearchSpot;
-(void)HandleAppleWatchOpenRequestSearchSpot:(NSMutableDictionary*)appData;

@end
