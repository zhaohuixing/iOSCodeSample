//
//  IMapViewDelegate.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-23.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMapViewDelegate <NSObject>

@optional

-(void)SetMapTypeStandard;
-(void)SetMapTypeSatellite;
-(void)SetMapTypeHybrid;

-(void)RemoveAnnotations:(NSArray*)annotions;
-(void)RemoveAnnotation:(id<MKAnnotation>)annotion;
-(void)AddAnnotation:(id<MKAnnotation>)annotion;
-(void)AddOverlay:(id<MKOverlay>)overlay;
-(void)RemoveOverlay:(id<MKOverlay>)overlay;
-(void)RemoveOverlays:(NSArray*)overlays;

-(void)ShowMyLocationPostAnnotation;
-(void)HideMyLocationPostAnnotation;
-(void)UpdateAnnotationViewData;
-(MKAnnotationView*)GetAnnotationView:(id <MKAnnotation>)pAnnotation;
-(MKCoordinateRegion)GetVisibleRegion;
-(void)SetVisibleRegion:(MKCoordinateRegion)region;
-(MKMapRect)GetVisibleRect;
-(double)GetVisibleRegionGEOWidthInMeter;

-(void)SetShowCurrentLocation:(BOOL)bShow;

-(BOOL)CheckAnnotationWithMetaDataID:(NSString*)szID;

@end
