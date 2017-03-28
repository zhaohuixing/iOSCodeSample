//
//  NOMMathHelper.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NOMMathHelper : NSObject

+(int)CounterClockwise:(CGFloat)x0 y0:(CGFloat)y0 x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2;
+(int)CounterClockwise:(CLLocationCoordinate2D)pt0 point1:(CLLocationCoordinate2D)pt1 point2:(CLLocationCoordinate2D)pt2;


+(BOOL)Intersect:(CLLocationCoordinate2D)Line1Start line1End:(CLLocationCoordinate2D)Line1End line2Start:(CLLocationCoordinate2D)Line2Start line2End:(CLLocationCoordinate2D)Line2End;

@end
