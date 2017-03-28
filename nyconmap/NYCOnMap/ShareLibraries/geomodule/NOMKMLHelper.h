//
//  NOMKMLHelper.h
//  xxxxx
//
//  Created by Zhaohui Xing on 2014-04-06.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "KML.h"

@interface NOMKMLHelper : NSObject

+(KMLPlacemark *)KMLPointWithTag:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate;
+(KMLPlacemark *)KMLLineWithTag:(NSString *)name withMKAnnotations:(NSArray *)annotations lineWidth:(int)width lineColor:(UIColor *)color;
+(KMLPlacemark *)KMLLineWithTag:(NSString *)name withMKMapPoints:(MKMapPoint *)points withCount:(int)nCount lineWidth:(int)width lineColor:(UIColor *)color;
+(KMLPlacemark *)KMLPolygonWithTag:(NSString *)name withMKAnnotations:(NSArray *)annotations lineWidth:(int)width withColor:(UIColor *)color;


+(KMLPlacemark *)KMLLineWithTag:(NSString *)name withCoordinates:(NSArray*)locationList lineWidth:(int)width lineColor:(UIColor *)color;
+(KMLPlacemark *)KMLPolygonWithTag:(NSString *)name withCoordinates:(NSArray*)locationList lineWidth:(int)width withColor:(UIColor *)color;

@end
