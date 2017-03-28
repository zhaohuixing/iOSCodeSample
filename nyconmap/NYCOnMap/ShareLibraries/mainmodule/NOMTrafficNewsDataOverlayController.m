//
//  NOMTrafficNewsDataOverlayController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-08-20.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficNewsDataOverlayController.h"
#import "NOMSystemConstants.h"
#import "NOMGUILayout.h"
#import "NOMGEOConfigration.h"
#import "KML.h"
#import "NOMMapConstants.h"
#import "NOMGEOPlanAnnotationView.h"
#import "NOMGEOPlanLine.h"
#import "NOMGEOPlanRouteLineSegment.h"
#import "NOMGEOPlanPolygon.h"
#import "NOMGEOPlanRect.h"
#import "NOMAppInfo.h"

@interface NOMTrafficNewsDataOverlayController()
{
@private
    id<IMapViewDelegate>            m_MapView;
    
    NSMutableDictionary*                 m_TrafficOverlays;
    
}

@end

@implementation NOMTrafficNewsDataOverlayController

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_MapView = nil;
        m_TrafficOverlays = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)LoadOverlays
{
    NSArray* overlays = [m_TrafficOverlays allValues];
    
    if(m_MapView != nil && overlays != nil && 0 < overlays.count)
    {
        for(int i = 0; i < overlays.count; ++i)
        {
            id<MKOverlay> obj = [overlays objectAtIndex:i];
            if(obj != nil)
                [m_MapView AddOverlay:obj];
        }
    }
}

-(void)RegisterMapView:(id<IMapViewDelegate>)mapView
{
    m_MapView = mapView;
    [self LoadOverlays];
}

-(void)AddPlanLineOverlay:(NSString*)newsID withKML:(KMLDocument*)kmlDocument
{
    if(kmlDocument != nil && kmlDocument.features != nil)
    {
        for(int i = 0; i < kmlDocument.features.count; ++i)
        {
            KMLPlacemark *kmlPlacemark = [kmlDocument.features objectAtIndex:i];
            if(kmlPlacemark != nil && kmlPlacemark.name != nil)
            {
                //placemarkElement.name
                if([kmlPlacemark.name isEqualToString:KML_TAG_POINT] == YES)
                {
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = ((KMLPoint*)kmlPlacemark.geometry).coordinate.latitude;
                    coordinate.longitude = ((KMLPoint*)kmlPlacemark.geometry).coordinate.longitude;
                    //NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                    //[pAnnotation SetCoordinate:coordinate.longitude withLatitude:coordinate.latitude];
                    //[pAnnotation SetID:i];
                    //[m_MapView addAnnotation:pAnnotation];
                }
                else if([kmlPlacemark.name isEqualToString:KML_TAG_MARKLINE] == YES)
                {
                    if(((KMLLineString*)kmlPlacemark.geometry).coordinates != nil && 0 < ((KMLLineString*)kmlPlacemark.geometry).coordinates.count)
                    {
                        CLLocationCoordinate2D pts[((KMLLineString*)kmlPlacemark.geometry).coordinates.count];
                        for(int i = 0; i < ((KMLLineString*)kmlPlacemark.geometry).coordinates.count; ++i)
                        {
                            KMLCoordinate *coordinate = [((KMLLineString*)kmlPlacemark.geometry).coordinates objectAtIndex:i];
                            pts[i].latitude = coordinate.latitude;
                            pts[i].longitude = coordinate.longitude;
                        }
                        
                        NOMGEOPlanLine* lineOverlay = [[NOMGEOPlanLine alloc] initWithCoordinates:(CLLocationCoordinate2D *)pts count:((KMLLineString*)kmlPlacemark.geometry).coordinates.count];
                        [lineOverlay SetID:newsID];
                        [m_TrafficOverlays setObject:lineOverlay forKey:newsID];
                        if(m_MapView != nil)
                            [m_MapView AddOverlay:lineOverlay];
                        
                    }
                }
            }
        }
    }
}

-(void)AddPlanRouteOverlay:(NSString*)newsID withKML:(KMLDocument*)kmlDocument
{
    if(kmlDocument != nil && kmlDocument.features != nil)
    {
        for(int i = 0; i < kmlDocument.features.count; ++i)
        {
            KMLPlacemark *kmlPlacemark = [kmlDocument.features objectAtIndex:i];
            if(kmlPlacemark != nil && kmlPlacemark.name != nil)
            {
                //placemarkElement.name
                if([kmlPlacemark.name isEqualToString:KML_TAG_POINT] == YES)
                {
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = ((KMLPoint*)kmlPlacemark.geometry).coordinate.latitude;
                    coordinate.longitude = ((KMLPoint*)kmlPlacemark.geometry).coordinate.longitude;
                    //NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                    //[pAnnotation SetCoordinate:coordinate.longitude withLatitude:coordinate.latitude];
                    //[pAnnotation SetID:i];
                    //[m_MapView addAnnotation:pAnnotation];
                }
                else if([kmlPlacemark.name isEqualToString:KML_TAG_MARKROUTE] == YES)
                {
                    if(((KMLLineString*)kmlPlacemark.geometry).coordinates != nil && 0 < ((KMLLineString*)kmlPlacemark.geometry).coordinates.count)
                    {
                        CLLocationCoordinate2D pts[((KMLLineString*)kmlPlacemark.geometry).coordinates.count];
                        for(int i = 0; i < ((KMLLineString*)kmlPlacemark.geometry).coordinates.count; ++i)
                        {
                            KMLCoordinate *coordinate = [((KMLLineString*)kmlPlacemark.geometry).coordinates objectAtIndex:i];
                            pts[i].latitude = coordinate.latitude;
                            pts[i].longitude = coordinate.longitude;
                        }
                        
                        NOMGEOPlanRouteLineSegment* lineOverlay = [[NOMGEOPlanRouteLineSegment alloc] initWithCoordinates:(CLLocationCoordinate2D *)pts count:((KMLLineString*)kmlPlacemark.geometry).coordinates.count];
                        [lineOverlay SetID:newsID];
                        [m_TrafficOverlays setObject:lineOverlay forKey:newsID];
                        if(m_MapView != nil)
                            [m_MapView AddOverlay:lineOverlay];
                    }
                }
            }
        }
    }
}

-(void)AddPlanPolyOverlay:(NSString*)newsID withKML:(KMLDocument*)kmlDocument
{
    if(kmlDocument != nil && kmlDocument.features != nil)
    {
        for(int i = 0; i < kmlDocument.features.count; ++i)
        {
            KMLPlacemark *kmlPlacemark = [kmlDocument.features objectAtIndex:i];
            if(kmlPlacemark != nil && kmlPlacemark.name != nil)
            {
                //placemarkElement.name
                if([kmlPlacemark.name isEqualToString:KML_TAG_POINT] == YES)
                {
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = ((KMLPoint*)kmlPlacemark.geometry).coordinate.latitude;
                    coordinate.longitude = ((KMLPoint*)kmlPlacemark.geometry).coordinate.longitude;
                    //NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                    //[pAnnotation SetCoordinate:coordinate.longitude withLatitude:coordinate.latitude];
                    //[pAnnotation SetID:i];
                    //[m_MapView addAnnotation:pAnnotation];
                }
                else if([kmlPlacemark.name isEqualToString:KML_TAG_MARKPOLY] == YES)
                {
                    if(kmlPlacemark.geometry != nil)
                    {
                        KMLPolygon* polygon = (KMLPolygon*)kmlPlacemark.geometry;
                        if(polygon != nil && polygon.innerBoundaryIsList != nil && 0 < polygon.innerBoundaryIsList.count)
                        {
                            KMLLinearRing* pLine = (KMLLinearRing*)[polygon.innerBoundaryIsList objectAtIndex:0];
                            if(pLine != nil && pLine.coordinates != nil && 0 < pLine.coordinates.count)
                            {
                                CLLocationCoordinate2D pts[pLine.coordinates.count];
                                for(int i = 0; i < pLine.coordinates.count; ++i)
                                {
                                    KMLCoordinate *coordinate = [pLine.coordinates objectAtIndex:i];
                                    pts[i].latitude = coordinate.latitude;
                                    pts[i].longitude = coordinate.longitude;
                                }
                                NOMGEOPlanPolygon* polygonArea = [[NOMGEOPlanPolygon alloc] initWithCoordinates:pts count:pLine.coordinates.count];
                                [polygonArea SetID:newsID];
                                [m_TrafficOverlays setObject:polygonArea forKey:newsID];
                                if(m_MapView != nil)
                                    [m_MapView AddOverlay:polygonArea];
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)AddPlanRectOverlay:(NSString*)newsID withKML:(KMLDocument*)kmlDocument
{
    if(kmlDocument != nil && kmlDocument.features != nil && 2 <= kmlDocument.features.count)
    {
        CLLocationCoordinate2D pts[2];
        int k = 0;
        for(int i = 0; i < kmlDocument.features.count; ++i)
        {
            KMLPlacemark *kmlPlacemark = [kmlDocument.features objectAtIndex:i];
            if(kmlPlacemark != nil && kmlPlacemark.name != nil && [kmlPlacemark.name isEqualToString:KML_TAG_POINT] == YES)
            {
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = ((KMLPoint*)kmlPlacemark.geometry).coordinate.latitude;
                coordinate.longitude = ((KMLPoint*)kmlPlacemark.geometry).coordinate.longitude;
                //NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                //[pAnnotation SetCoordinate:coordinate.longitude withLatitude:coordinate.latitude];
                //[pAnnotation SetID:i];
                //[m_MapView addAnnotation:pAnnotation];
                pts[k].latitude = coordinate.latitude;
                pts[k].longitude = coordinate.longitude;
                ++k;
                if(2 <= k)
                {
                    NOMGEOPlanRect* rectArea = [[NOMGEOPlanRect alloc] initWithStart:pts[0] end:pts[1]];
                    [rectArea SetID:newsID];
                    [m_TrafficOverlays setObject:rectArea forKey:newsID];
                    if(m_MapView != nil)
                        [m_MapView AddOverlay:rectArea];
                    break;
                }
            }
        }
    }
}


-(void)AddOverlay:(NSString*)newsID withKML:(NSString*)newsKMLSource
{
    if([m_TrafficOverlays objectForKey:newsID] != nil)
        return;
    
    KMLRoot* kmlObject = [KMLParser parseKMLWithString:newsKMLSource];
    if(kmlObject != nil)
    {
        KMLDocument *kmlDocument = (KMLDocument*)kmlObject.feature;
        if(kmlDocument != nil && kmlDocument.name != nil && 0 < kmlDocument.name.length)
        {
            if([kmlDocument.name isEqualToString:MAP_PLAN_LINE_ID] == YES)
            {
                [self AddPlanLineOverlay:newsID withKML:kmlDocument];
            }
            else if([kmlDocument.name isEqualToString:MAP_PLAN_ROUTE_ID] == YES)
            {
                [self AddPlanRouteOverlay:newsID withKML:kmlDocument];
            }
            else if([kmlDocument.name isEqualToString:MAP_PLAN_POLY_ID] == YES)
            {
                [self AddPlanPolyOverlay:newsID withKML:kmlDocument];
            }
            else if([kmlDocument.name isEqualToString:MAP_PLAN_RECT_ID] == YES)
            {
                [self AddPlanRectOverlay:newsID withKML:kmlDocument];
            }
        }
    }
}

-(void)RemoveOverlay:(NSString*)newsID
{
    id<MKOverlay> overlay = [m_TrafficOverlays objectForKey:newsID];
    if(overlay != nil )
    {
        if(m_MapView != nil)
            [m_MapView RemoveOverlay:overlay];
        [m_TrafficOverlays removeObjectForKey:newsID];
    }
}

-(void)RemoveAllOverlays
{
    NSArray* overlays = [m_TrafficOverlays allValues];
    
    if(m_MapView != nil)
        [m_MapView RemoveOverlays:overlays];
    [m_TrafficOverlays removeAllObjects];
}

-(void)UpdateLayout
{
    
}

@end
