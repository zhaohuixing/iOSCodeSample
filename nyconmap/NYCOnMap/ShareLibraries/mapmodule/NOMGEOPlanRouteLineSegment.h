//
//  NOMGEOPlanRouteLineSegment.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "IIDGEOOverlay.h"

@interface NOMGEOPlanRouteLineSegment : MKPolyline<IIDGEOOverlay>

-(id)initWithPolyline:(MKPolyline*)pline;
-(id)initWith:(CLLocationCoordinate2D)startPoint end:(CLLocationCoordinate2D)endPoint;
-(id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
-(void)SetID:(NSString*)overlayID;
-(NSString*)GetID;

@end
