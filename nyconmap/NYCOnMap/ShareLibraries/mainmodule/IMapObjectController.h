//
//  IMapObjectController.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-23.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMapViewDelegate.h"
#import "NOMTrafficSpotRecord.h"

@protocol IMapObjectController <NSObject>

@optional

-(void)RegisterMapView:(id<IMapViewDelegate>)mapView;
-(void)SetMapTypeStandard;
-(void)SetMapTypeSatellite;
-(void)SetMapTypeHybrid;

-(void)ClearMapTrafficMark;
-(void)ClearMapSpotMark;
-(void)ClearAllMapMark;

-(void)MapViewVisualRegionChanged;
-(void)UpdateAnnotationDrawState;
-(void)HandleMapViewTouchEvent:(CLLocationCoordinate2D)touchPoint;
-(void)LoadingMapFinished;
-(void)MapRenderingFinished;

-(CLLocationCoordinate2D)GetMyPostPinLocation;
-(CLLocationCoordinate2D)GetPostPinLocation;

-(void)StartUpdateSpotData:(NOMTrafficSpotRecord*)pSpot;

-(BOOL)IsLocationServiceAuthorization;

-(MKCoordinateRegion)GetMapViewVisibleRegion;
-(MKMapRect)GetMapViewVisibleRect;

@end
