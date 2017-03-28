//
//  NOMKMLHelper.m
//  xxxxxx
//
//  Created by Zhaohui Xing on 2014-04-06.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMKMLHelper.h"

@implementation NOMKMLHelper

+(KMLPlacemark *)KMLPointWithTag:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate
{
    KMLPlacemark *placemarkElement = [KMLPlacemark new];
    placemarkElement.name = name;
    
    KMLPoint *pointElement = [KMLPoint new];
    placemarkElement.geometry = pointElement;
    
    KMLCoordinate *coordinateElement = [KMLCoordinate new];
    coordinateElement.latitude = coordinate.latitude;
    coordinateElement.longitude = coordinate.longitude;
    pointElement.coordinate = coordinateElement;
    
    return placemarkElement;
}

+(KMLPlacemark *)KMLLineWithTag:(NSString *)name withMKAnnotations:(NSArray *)annotations lineWidth:(int)width lineColor:(UIColor *)color
{
    KMLPlacemark *placemark = [KMLPlacemark new];
    placemark.name = name;
    
    __block KMLLineString *lineString = [KMLLineString new];
    placemark.geometry = lineString;
    
    [annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSObject<MKAnnotation>* point = (NSObject<MKAnnotation>*)obj;
         KMLCoordinate *coordinate = [KMLCoordinate new];
         coordinate.latitude = point.coordinate.latitude;
         coordinate.longitude = point.coordinate.longitude;
         [lineString addCoordinate:coordinate];
     }];
    
    KMLStyle *style = [KMLStyle new];
    [placemark addStyleSelector:style];
    
    KMLLineStyle *lineStyle = [KMLLineStyle new];
    style.lineStyle = lineStyle;
    lineStyle.width = width;
    lineStyle.UIColor = color;
    
    return placemark;
}

+(KMLPlacemark *)KMLLineWithTag:(NSString *)name withMKMapPoints:(MKMapPoint *)points withCount:(int)nCount lineWidth:(int)width lineColor:(UIColor *)color
{
    KMLPlacemark *placemark = [KMLPlacemark new];
    placemark.name = name;
    
    KMLLineString *lineString = [KMLLineString new];
    placemark.geometry = lineString;
    
    for(int i = 0; i < nCount; ++i)
    {
        CLLocationCoordinate2D coord = MKCoordinateForMapPoint((MKMapPoint)points[i]);
        KMLCoordinate *coordinate = [KMLCoordinate new];
        coordinate.latitude = coord.latitude;
        coordinate.longitude = coord.longitude;
        [lineString addCoordinate:coordinate];
    }

    KMLStyle *style = [KMLStyle new];
    [placemark addStyleSelector:style];
    
    KMLLineStyle *lineStyle = [KMLLineStyle new];
    style.lineStyle = lineStyle;
    lineStyle.width = width;
    lineStyle.UIColor = color;
    
    return placemark;
}

+(KMLPlacemark *)KMLPolygonWithTag:(NSString *)name withMKAnnotations:(NSArray *)annotations lineWidth:(int)width withColor:(UIColor *)color
{
    KMLPlacemark *placemark = [KMLPlacemark new];
    placemark.name = name;

    KMLPolygon* polygon = [KMLPolygon new];
    placemark.geometry = polygon;
    
    __block KMLLinearRing* lingRing = [KMLLinearRing new];
    [polygon addInnerBoundaryIs:lingRing];
    
    [annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSObject<MKAnnotation>* point = (NSObject<MKAnnotation>*)obj;
         KMLCoordinate *coordinate = [KMLCoordinate new];
         coordinate.latitude = point.coordinate.latitude;
         coordinate.longitude = point.coordinate.longitude;
         [lingRing addCoordinate:coordinate];
         if(idx == annotations.count - 1)
         {
             NSObject<MKAnnotation>* lastpt = [annotations objectAtIndex:0];
             KMLCoordinate* lastcoord = [KMLCoordinate new];
             lastcoord.latitude = lastpt.coordinate.latitude;
             lastcoord.longitude = lastpt.coordinate.longitude;
             [lingRing addCoordinate:lastcoord];
         }
     }];
    
    KMLStyle *style = [KMLStyle new];
    [placemark addStyleSelector:style];
    
    KMLLineStyle *lineStyle = [KMLLineStyle new];
    style.lineStyle = lineStyle;
    lineStyle.width = width;
    lineStyle.UIColor = color;

    KMLPolyStyle *polyStyle = [KMLPolyStyle new];
    style.polyStyle = polyStyle;
    polyStyle.fill = YES;
    polyStyle.outline = YES;
    polyStyle.UIColor = color;
    
    return placemark;
}

+(KMLPlacemark *)KMLLineWithTag:(NSString *)name withCoordinates:(NSArray*)locationList lineWidth:(int)width lineColor:(UIColor *)color
{
    KMLPlacemark *placemark = [KMLPlacemark new];
    placemark.name = name;
    
    __block KMLLineString *lineString = [KMLLineString new];
    placemark.geometry = lineString;
    
    [locationList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         CLLocation* point = (CLLocation*)obj;
         KMLCoordinate *coordinate = [KMLCoordinate new];
         coordinate.latitude = point.coordinate.latitude;
         coordinate.longitude = point.coordinate.longitude;
         [lineString addCoordinate:coordinate];
     }];
    
    KMLStyle *style = [KMLStyle new];
    [placemark addStyleSelector:style];
    
    KMLLineStyle *lineStyle = [KMLLineStyle new];
    style.lineStyle = lineStyle;
    lineStyle.width = width;
    lineStyle.UIColor = color;
    
    return placemark;
}

+(KMLPlacemark *)KMLPolygonWithTag:(NSString *)name withCoordinates:(NSArray*)locationList lineWidth:(int)width withColor:(UIColor *)color
{
    KMLPlacemark *placemark = [KMLPlacemark new];
    placemark.name = name;
    
    KMLPolygon* polygon = [KMLPolygon new];
    placemark.geometry = polygon;
    
    __block KMLLinearRing* lingRing = [KMLLinearRing new];
    [polygon addInnerBoundaryIs:lingRing];
    
    [locationList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         CLLocation* point = (CLLocation*)obj;
         KMLCoordinate *coordinate = [KMLCoordinate new];
         coordinate.latitude = point.coordinate.latitude;
         coordinate.longitude = point.coordinate.longitude;
         [lingRing addCoordinate:coordinate];
         if(idx == locationList.count - 1)
         {
             CLLocation* lastpt = [locationList objectAtIndex:0];
             KMLCoordinate* lastcoord = [KMLCoordinate new];
             lastcoord.latitude = lastpt.coordinate.latitude;
             lastcoord.longitude = lastpt.coordinate.longitude;
             [lingRing addCoordinate:lastcoord];
         }
     }];
    
    KMLStyle *style = [KMLStyle new];
    [placemark addStyleSelector:style];
    
    KMLLineStyle *lineStyle = [KMLLineStyle new];
    style.lineStyle = lineStyle;
    lineStyle.width = width;
    lineStyle.UIColor = color;
    
    KMLPolyStyle *polyStyle = [KMLPolyStyle new];
    style.polyStyle = polyStyle;
    polyStyle.fill = YES;
    polyStyle.outline = YES;
    polyStyle.UIColor = color;
    
    return placemark;
}


@end
