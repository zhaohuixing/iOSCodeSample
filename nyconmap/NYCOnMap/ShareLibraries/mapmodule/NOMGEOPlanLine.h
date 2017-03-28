//
//  NOMGEOPlanLine.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-31.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "IIDGEOOverlay.h"

@interface NOMGEOPlanLine : MKPolyline<IIDGEOOverlay>

-(id)initWith:(MKMapPoint *)points withCount:(NSUInteger)count;
-(id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
-(void)SetID:(NSString*)overlayID;
-(NSString*)GetID;

@end
