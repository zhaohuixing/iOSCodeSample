//
//  NOMGEOPlanPolygon.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "IIDGEOOverlay.h"

@interface NOMGEOPlanPolygon : MKPolygon<IIDGEOOverlay>

- (id)initWithPoints:(MKMapPoint *)points count:(NSUInteger)count;
- (id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
- (void)SetID:(NSString*)overlayID;
- (NSString*)GetID;

@end
