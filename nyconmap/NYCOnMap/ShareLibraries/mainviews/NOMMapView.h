//
//  NOMMapView.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-18.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "IMapObjectController.h"
#import "IMapViewDelegate.h"

@interface NOMMapView : UIView <MKMapViewDelegate, IMapViewDelegate>

-(MKCoordinateRegion)GetMapViewVisibleRegion;
-(void)UpdateLayout;
-(void)SetMapObjectController:(id<IMapObjectController>)controller;
-(void)SetMapTypeStandard;
-(void)SetMapTypeSatellite;
-(void)SetMapTypeHybrid;
-(CGPoint)GetPointFromMapLocation:(CLLocationCoordinate2D)location;


-(void)HandleGneralKML:(NSString*)kml;
-(void)MakeAppLocationOnMap;
-(void)ShowAppRegion:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd;
-(void)RemoveAnnotations:(NSArray*)annotions;
-(void)RemoveAnnotation:(id<MKAnnotation>)annotion;
-(void)UpdateAnnotationViewData;
-(MKAnnotationView*)GetAnnotationView:(id <MKAnnotation>)pAnnotation;
-(MKCoordinateRegion)GetVisibleRegion;
-(void)SetVisibleRegion:(MKCoordinateRegion)region;
-(double)GetVisibleRegionGEOWidthInMeter;

-(BOOL)CheckAnnotationWithMetaDataID:(NSString*)szID;

@end
