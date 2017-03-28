//
//  NOMMapView.m
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-18.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMMapView.h"
#import "NOMMapConstants.h"
#import "NOMPlanAnnotation.h"
#import "NOMTrafficSpotAnnotation.h"
#import "NOMTrafficSpotPin.h"
#import "NOMGEOPlanAnnotationView.h"
#import "NOMGEOPlanLine.h"
#import "NOMGEOPlanRouteLineSegment.h"
#import "NOMGEOPlanPolygon.h"
#import "NOMGEOPlanRect.h"
#import "NOMAppInfo.h"
#import "KML.h"
#import "NOMAppRegionHelper.h"
#import "NOMSystemConstants.h"
#import "NOMTrafficSpotRecord.h"
#import "NOMMyLocationPostAnnotation.h"
#import "NOMMyLocationPostPin.h"
#import "NOMPostLocationAnnotation.h"
#import "NOMPostLocationPin.h"
#import "NOMQueryAnnotation.h"
#import "NOMQueryLocationPin.h"
#import "NOMGEOConfigration.h"
#import "GUIBasicConstant.h"
#import "INOMCustomListCalloutInterfaces.h"
#import "NOMNewsMetaDataRecord.h"

@interface NOMMapView()
{
@private
    
    MKMapView*                                  m_MapView;
    MKPolyline*                                 m_AppRegionOverlay;
    id<IMapObjectController>                    m_MapObjectController;
    
    MKMapRect                                   m_CachedMapViewRect;
}

-(double)GetZoomFactor;
-(void)RedrawMapElements;

@end

@implementation NOMMapView

+(CGFloat)GetMyLocationPinHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 200;////120;//180;
    else
        return 120;////90;
}

+(CGFloat)GetMyLocationPinWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 200;//120;
    else
        return 120; //80;//60;
}


+(CGFloat)GetGEOPlanPinSize
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 40;
}

-(float)GetTrafficSpotPinSize
{
    if([NOMAppInfo IsDeviceIPad])
        return 56; //48;//60;
    else
        return 36; //40;
}

-(float)GetQueryPinWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 90;////120;//180;
    else
        return 51; //54; //60;////90;
}

-(float)GetQueryPinHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 120;
    else
        return 68; //72;//80;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_MapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        m_MapView.delegate = self;
        m_MapView.mapType = MKMapTypeStandard;
        
        m_MapView.showsBuildings = YES;
        m_MapView.showsPointsOfInterest = YES;
        m_MapView.pitchEnabled = YES;
        m_MapView.rotateEnabled = YES;
        m_MapView.zoomEnabled = YES;
        m_MapView.scrollEnabled = YES;
        m_MapView.showsUserLocation = NO;
        m_MapObjectController = nil;
        [self addSubview:m_MapView];
        m_CachedMapViewRect = MKMapRectMake(m_MapView.visibleMapRect.origin.x, m_MapView.visibleMapRect.origin.y, m_MapView.visibleMapRect.size.width, m_MapView.visibleMapRect.size.height);
        [NOMAppRegionHelper SetMainMapViewObject:m_MapView];
    }
    return self;
}

-(CGPoint)GetPointFromMapLocation:(CLLocationCoordinate2D)location
{
    CGPoint pt = CGPointMake(0, 0);
    
    pt = [m_MapView convertCoordinate:location toPointToView:m_MapView];
    
    return pt;
}

-(double)GetZoomFactor
{
    CLLocationDegrees longitudeDelta = m_MapView.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomer < 0.0 )
        zoomer = 0.0;
    return zoomer;
}

-(void)UpdateLayout
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [m_MapView setFrame:frame];
}

-(void)SetMapObjectController:(id<IMapObjectController>)controller
{
    m_MapObjectController = controller;
    if(m_MapObjectController != nil)
    {
        [m_MapObjectController RegisterMapView:self];
    }
}

-(void)SetMapTypeStandard
{
    m_MapView.mapType = MKMapTypeStandard;
    m_MapView.showsBuildings = YES;
    m_MapView.showsPointsOfInterest = YES;
    MKCoordinateRegion region = m_MapView.region;
    [m_MapView setRegion:region animated:YES];
}

-(void)SetMapTypeSatellite
{
    m_MapView.mapType = MKMapTypeSatellite;
    MKCoordinateRegion region = m_MapView.region;
    [m_MapView setRegion:region animated:YES];
}

-(void)SetMapTypeHybrid
{
    m_MapView.mapType = MKMapTypeHybrid;
    MKCoordinateRegion region = m_MapView.region;
    [m_MapView setRegion:region animated:YES];
}

-(void)AdjustQueryPin:(NOMQueryLocationPin*)pQueryView by:(NOMQueryAnnotation*)annotation
{
    [pQueryView ReloadInformation];
    pQueryView.canShowCallout = NO;
    pQueryView.draggable = NO;
    annotation.m_ActiveView = pQueryView;
}

-(void)UpdateQueryPinState:(int16_t)nMainCate withIndex:(int)index
{
    NOMQueryLocationPin* pQueryView = nil;
    NSString* szTagBase = @"QueryLocationAnnotationIdentifier";
    if(nMainCate == NOM_NEWSCATEGORY_LOCALTRAFFIC)
        szTagBase = @"QueryTrafficAnnotationIdentifier";
    
    NSString *QueryLocationAnnotationIdentifier = [NSString stringWithFormat:@"%@_%i",szTagBase, index];
    
    pQueryView = (NOMQueryLocationPin *)[m_MapView dequeueReusableAnnotationViewWithIdentifier:QueryLocationAnnotationIdentifier];
    if (pQueryView)
    {
        [pQueryView ReloadInformation];
        pQueryView.canShowCallout = NO;
        pQueryView.draggable = NO;
    }
}

-(NOMTrafficSpotPin*)GetSpotPinView:(NOMTrafficSpotAnnotation*)annotation
{
    NOMTrafficSpotPin* pSpotView = nil;
    
    if(annotation != nil && annotation.m_NOMTrafficSpot != nil)
    {
        int index = [annotation GetIndex];
        NSString *TrafficSpotAnnotationIdentifier = @"";
        if(annotation.m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_GASSTATION)
        {
            TrafficSpotAnnotationIdentifier = [NSString stringWithFormat:@"GasStationAnnotationIdentifier_%i", index];
        }
        else if(annotation.m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_PHOTORADAR)
        {
            TrafficSpotAnnotationIdentifier = [NSString stringWithFormat:@"PhotoRadarSpotAnnotationIdentifier_%i", index];
        }
        else if(annotation.m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_SCHOOLZONE)
        {
            TrafficSpotAnnotationIdentifier = [NSString stringWithFormat:@"SchoolZoneSpotAnnotationIdentifier_%i", index];
        }
        else if(annotation.m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_PLAYGROUND)
        {
            TrafficSpotAnnotationIdentifier = [NSString stringWithFormat:@"PlaygroundSpotAnnotationIdentifier_%i", index];
        }
        else if(annotation.m_NOMTrafficSpot.m_Type == NOM_TRAFFICSPOT_PARKINGGROUND)
        {
            TrafficSpotAnnotationIdentifier = [NSString stringWithFormat:@"ParkingSpotAnnotationIdentifier_%i", index];
        }
        pSpotView = (NOMTrafficSpotPin *)[m_MapView dequeueReusableAnnotationViewWithIdentifier:TrafficSpotAnnotationIdentifier];
        
        CGSize size = CGSizeMake([self GetTrafficSpotPinSize], [self GetTrafficSpotPinSize]);
        if (!pSpotView)
        {
            // if an existing pin view was not available, create one
            pSpotView = [[NOMTrafficSpotPin alloc] initWithAnnotation:annotation reuseIdentifier:TrafficSpotAnnotationIdentifier withSize:size];
            [annotation RegisterMyPin:pSpotView];
        }
        else
        {
            pSpotView.annotation = annotation;
            [annotation RegisterMyPin:pSpotView];
        }
        
        if(pSpotView)
        {
            [pSpotView RegisterMap:m_MapView];
            [pSpotView ReloadInformation];
            pSpotView.draggable = NO;
            pSpotView.canShowCallout = YES;
        }
    }
    
    return pSpotView;
}

- (NOMQueryLocationPin*)GetQueryPinView:(NOMQueryAnnotation*)annotation
{
    NOMQueryLocationPin* pQueryView = nil;
    id<INOMCustomListCalloutDelegate> pDelegate = nil;
    if([[self superview] respondsToSelector:@selector(GetCalloutDelegate)] == YES)
    {
        pDelegate = [((id<INOMCustomListCalloutDelegate>)[self superview]) GetCalloutDelegate];
    }
    
    int index = [annotation GetIndex];
    NSString* szTagBase = @"QueryLocationAnnotationIdentifier";
    int16_t nMainCate = [annotation GetMainDataCateType];
    if(nMainCate == NOM_NEWSCATEGORY_LOCALTRAFFIC)
        szTagBase = @"QueryTrafficAnnotationIdentifier";
    
    NSString *QueryLocationAnnotationIdentifier = [NSString stringWithFormat:@"%@_%i",szTagBase, index];
    pQueryView = (NOMQueryLocationPin *)[m_MapView dequeueReusableAnnotationViewWithIdentifier:QueryLocationAnnotationIdentifier];
    
    CGSize size = CGSizeMake([self GetQueryPinWidth], [self GetQueryPinHeight]);
    if (!pQueryView)
    {
        // if an existing pin view was not available, create one
        pQueryView = [[NOMQueryLocationPin alloc] initWithAnnotation:annotation reuseIdentifier:QueryLocationAnnotationIdentifier withSize:size];
        
        [pQueryView RegisterMap:m_MapView];
        [self AdjustQueryPin:pQueryView by:annotation];
        if([annotation CheckPinType] == NOM_QUERYPIN_TYPE_TAXI)
        {
            [pQueryView RegisterCallout:nil];
            pQueryView.draggable = NO;
            pQueryView.canShowCallout = YES;
        }
        else
        {
            [pQueryView RegisterCallout:pDelegate];
            pQueryView.draggable = NO;
            pQueryView.canShowCallout = NO;
        }
        return pQueryView;
    }
    else
    {
        [pQueryView RegisterMap:m_MapView];
        pQueryView.annotation = annotation;
        if([annotation CheckPinType] == NOM_QUERYPIN_TYPE_TAXI)
        {
            [pQueryView RegisterCallout:nil];
            pQueryView.draggable = NO;
        }
        else
        {
            [pQueryView RegisterCallout:pDelegate];
            pQueryView.draggable = NO;
        }
        [self AdjustQueryPin:pQueryView by:annotation];
    }
    
    return pQueryView;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
    if(touch != nil)
    {
        CGPoint touchPoint = [touch locationInView:m_MapView]; //here locationInView it would be mapView
#if DEBUG
        NSLog(@"Test touch post point: X:%f  Y:%f", touchPoint.x, touchPoint.y);
#endif
        
        CLLocationCoordinate2D touchCoordinate = [m_MapView convertPoint:touchPoint toCoordinateFromView:m_MapView];
        
#if DEBUG
        NSLog(@"Test touch post geo location: Latitude:%f  Longitude:%f", touchCoordinate.latitude, touchCoordinate.longitude);
#endif
        if(m_MapObjectController != nil)
        {
            [m_MapObjectController HandleMapViewTouchEvent:touchCoordinate];
        }
    }
}

#pragma mark -
#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[NOMTrafficSpotAnnotation class]])
    {
        NOMTrafficSpotAnnotation* pSpotAnno = (NOMTrafficSpotAnnotation*)annotation;
        if(pSpotAnno && pSpotAnno.m_NOMTrafficSpot != nil) //Allow editing all spot name
        {
            if(m_MapObjectController != nil)
            {
                [m_MapObjectController StartUpdateSpotData:pSpotAnno.m_NOMTrafficSpot];
            }
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[NOMPlanAnnotation class]])
    {
        int nID = [((NOMPlanAnnotation *)annotation) GetID];
        NSString *JustPlanMarkerAnnotationIdentifier = [NSString stringWithFormat:@"JustPlanMarkerAnnotationIdentifier_%i", nID];
        
        NOMGEOPlanAnnotationView *pinView = (NOMGEOPlanAnnotationView *)[m_MapView dequeueReusableAnnotationViewWithIdentifier:JustPlanMarkerAnnotationIdentifier];
        if (pinView == nil)
        {
            CGSize size = CGSizeMake([NOMMapView GetGEOPlanPinSize], [NOMMapView GetGEOPlanPinSize]);
            
            // if an existing pin view was not available, create one
            NOMGEOPlanAnnotationView *customPinView = [[NOMGEOPlanAnnotationView alloc]
                                                       initWithAnnotation:annotation
                                                       reuseIdentifier:JustPlanMarkerAnnotationIdentifier
                                                       withSize:size
                                                       withParent:nil];
            
            customPinView.draggable = NO;
            customPinView.canShowCallout = NO;
            [customPinView setNeedsDisplay];
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else if([annotation isKindOfClass:[NOMQueryAnnotation class]])
    {
        NOMQueryLocationPin* pQueryView = [self GetQueryPinView:(NOMQueryAnnotation*)annotation];
        return pQueryView;
    }
    else if([annotation isKindOfClass:[NOMTrafficSpotAnnotation class]])
    {
        NOMTrafficSpotPin* pSpotView = [self GetSpotPinView:(NOMTrafficSpotAnnotation*)annotation];
        return pSpotView;
    }
    else if([annotation isKindOfClass:[NOMMyLocationPostAnnotation class]])
    {
        //Dequeue an existing pin view first
        static NSString *MyLocationAnnotationIdentifier = @"MyLocationPostAnnotationIdentifier";
        NOMMyLocationPostPin* myPinView = (NOMMyLocationPostPin *)[m_MapView dequeueReusableAnnotationViewWithIdentifier:MyLocationAnnotationIdentifier];
        
        CGSize size = CGSizeMake([NOMMapView GetMyLocationPinWidth], [NOMMapView GetMyLocationPinHeight]);
        if (!myPinView)
        {
            // if an existing pin view was not available, create one
            myPinView = [[NOMMyLocationPostPin alloc] initWithAnnotation:annotation reuseIdentifier:MyLocationAnnotationIdentifier withSize:size withOK:GUIID_MAPVIEW_PIN_MYLOCATION_OKBUTTON_CLICKDOWN withCancel:GUIID_MAPVIEW_PIN_MYLOCATION_CANCELBUTTON_CLICKDOWN];

            myPinView.canShowCallout = YES;
            return myPinView;
        }
        else
        {
            myPinView.annotation = annotation;
        }
        return myPinView;
    }
    else if([annotation isKindOfClass:[NOMPostLocationAnnotation class]])
    {
        //Dequeue an existing pin view first
        static NSString *PostLocationAnnotationIdentifier = @"PostLocationAnnotationIdentifier";
        NOMPostLocationPin* postPinView = (NOMPostLocationPin *)[m_MapView dequeueReusableAnnotationViewWithIdentifier:PostLocationAnnotationIdentifier];
        
        CGSize size = CGSizeMake([NOMMapView GetMyLocationPinWidth], [NOMMapView GetMyLocationPinHeight]);
        if (!postPinView)
        {
            // if an existing pin view was not available, create one
            postPinView = [[NOMPostLocationPin alloc] initWithAnnotation:annotation reuseIdentifier:PostLocationAnnotationIdentifier withSize:size withOK:GUIID_MAPVIEW_PIN_POSTLOCATION_OKBUTTON_CLICKDOWN withCancel:GUIID_MAPVIEW_PIN_POSTLOCATION_CANCELBUTTON_CLICKDOWN];
            //postPinView.animatesDrop = YES;
            postPinView.canShowCallout = YES;
            postPinView.draggable = YES;
            return postPinView;
        }
        else
        {
            postPinView.annotation = annotation;
        }
        return postPinView;
    }
    
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if([overlay isKindOfClass:[NOMGEOPlanLine class]])
    {
        double dZoom = [self GetZoomFactor]/MAX_MKMAPVIEW_ZOOM;
        
        if(dZoom <= MIN_MKMAPOBJECT_ZOOM)
            dZoom = MIN_MKMAPOBJECT_ZOOM;
        if(1.0 < dZoom)
            dZoom = 1.0;
        
        MKPolylineRenderer *routeRender = [[MKPolylineRenderer alloc] initWithPolyline:((MKPolyline*)overlay)];
        routeRender.lineWidth = (CGFloat)(MAP_PLAN_LINE_DEFAULT_WIDTH*dZoom);
        routeRender.strokeColor = MAP_PLAN_LINE_COLOR;
        return routeRender;
    }
    if([overlay isKindOfClass:[NOMGEOPlanRouteLineSegment class]] == YES)
    {
        MKPolylineRenderer *routeRender = [[MKPolylineRenderer alloc] initWithPolyline:((MKPolyline*)overlay)];
        routeRender.lineWidth = MAP_PLAN_ROUTE_DEFAULT_WIDTH;
        routeRender.strokeColor = MAP_PLAN_ROUTE_COLOR;
        return routeRender;
    }
    if([overlay isKindOfClass:[NOMGEOPlanPolygon class]] || [overlay isKindOfClass:[NOMGEOPlanRect class]])
    {
        
        MKPolygonRenderer *polyRender = [[MKPolygonRenderer alloc] initWithPolygon:((MKPolygon *)overlay)];
        polyRender.lineWidth = 2;
        polyRender.strokeColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        polyRender.fillColor = polyRender.strokeColor;
        return polyRender;
    }
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        double dZoom = [self GetZoomFactor]/MAX_MKMAPVIEW_ZOOM;
        
        if(0.8 < dZoom)
            dZoom = 1.0;
        
        if(dZoom <= MIN_MKMAPOBJECT_ZOOM)
            dZoom = MIN_MKMAPOBJECT_ZOOM;
        if(1.0 < dZoom)
            dZoom = 1.0;
        
        MKPolylineRenderer *queryRegion = [[MKPolylineRenderer alloc] initWithPolyline:((MKPolyline*)overlay)];
        queryRegion.lineWidth = DEFAULT_APP_COVER_LINE_WIDTH*dZoom;
        queryRegion.strokeColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:0.5];
        
        queryRegion.lineJoin = kCGLineJoinMiter;
        queryRegion.lineCap = kCGLineCapButt;
        
        
        
        double ptlen = DEFAULT_APP_COVER_LINE_DASH_LENGHT*dZoom;
        double ptgap = DEFAULT_APP_COVER_LINE_DASH_GAP*dZoom;
      
        queryRegion.lineDashPattern = @[[[NSNumber alloc] initWithDouble:ptlen], [[NSNumber alloc] initWithDouble:ptgap]];
        return queryRegion;
    }
    
    
    return nil;
}

-(void)UpdateMapViewRenderingState
{
    if([NOMAppInfo CanScaleMapElement] == YES)
    {
        double dZoom = [self GetZoomFactor];
        [NOMGEOConfigration SetMapZoomFactor:dZoom];
    
        if(m_MapObjectController != nil)
        {
            [m_MapObjectController UpdateAnnotationDrawState];
        }
        [self RedrawMapElements];
    }
}

-(void)SetCachedMapViewRegion
{
    double latStart, latEnd, lonStart, lonEnd;
    MKMapRect mapRect = m_MapView.visibleMapRect;
    MKMapPoint ptStart = mapRect.origin;
    MKMapPoint ptEnd = MKMapPointMake(mapRect.origin.x + mapRect.size.width, mapRect.origin.y + mapRect.size.height);
    CLLocationCoordinate2D coordStart = MKCoordinateForMapPoint(ptStart);
    CLLocationCoordinate2D coordEnd = MKCoordinateForMapPoint(ptEnd);
    latStart = MIN(coordStart.latitude, coordEnd.latitude);
    latEnd = MAX(coordStart.latitude, coordEnd.latitude);
    lonStart = MIN(coordStart.longitude, coordEnd.longitude);
    lonEnd = MAX(coordStart.longitude, coordEnd.longitude);
    [NOMAppRegionHelper SetCachedMapViewRegion:latStart endLatitude:latEnd startLongitude:lonStart endLongitude:lonEnd];
    m_CachedMapViewRect = MKMapRectMake(m_MapView.visibleMapRect.origin.x, m_MapView.visibleMapRect.origin.y, m_MapView.visibleMapRect.size.width, m_MapView.visibleMapRect.size.height);
}

-(BOOL)IsMapViewPureZoomIn
{
    BOOL bRet = MKMapRectContainsRect(m_CachedMapViewRect, m_MapView.visibleMapRect);
    
    return bRet;
}

-(BOOL)IsMapViewPureZoomOut
{
    BOOL bRet = MKMapRectContainsRect(m_MapView.visibleMapRect, m_CachedMapViewRect);
    
    return bRet;
}

-(void)MapViewVisualRegionChanged
{
    if(m_MapObjectController != nil)
    {
        [m_MapObjectController MapViewVisualRegionChanged];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if([NOMAppRegionHelper IsMapViewRegionCached] == NO)
    {
        [self SetCachedMapViewRegion];
        [self UpdateMapViewRenderingState];
        return;
    }
    
    if([self IsMapViewPureZoomIn] == YES || [self IsMapViewPureZoomOut] == YES)
    {
        [self SetCachedMapViewRegion];
        [self UpdateMapViewRenderingState];
        return;
    }
    
    [self MapViewVisualRegionChanged];
//    [self UpdateMapViewRenderingState];

    //????????????????
    //????????????????
    NSLog(@"Map region changed");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
//??    [self MapViewVisualRegionChanged];
//??    [self UpdateMapViewRenderingState];
    if(m_MapObjectController != nil)
    {
        [m_MapObjectController LoadingMapFinished];
    }
}

-(void)HandleMapRenderingFinishedEvent
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(HandleMapRenderingFinishedEvent) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(m_MapObjectController != nil)
    {
        [m_MapObjectController MapRenderingFinished];
    }
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    // Image creation code here
    NSLog(@"Map rendering finished");
//??    [self UpdateMapViewRenderingState];
    [m_MapView setNeedsDisplay];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self HandleMapRenderingFinishedEvent];
    });
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
//    [self UpdateMapViewRenderingState];
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers
{
//    [self UpdateMapViewRenderingState];
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
//    [self MapViewVisualRegionChanged];
//    [self UpdateMapViewRenderingState];
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
//    [self MapViewVisualRegionChanged];
//    [self UpdateMapViewRenderingState];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    [self MapViewVisualRegionChanged];
//    [self UpdateMapViewRenderingState];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
//    [self MapViewVisualRegionChanged];
//    [self UpdateMapViewRenderingState];
}


-(void)HandlePlanLineKML:(KMLDocument *)kmlDocument
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
                    NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                    [pAnnotation SetCoordinate:coordinate.longitude withLatitude:coordinate.latitude];
                     [pAnnotation SetID:i];
                    [m_MapView addAnnotation:pAnnotation];
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
                        [m_MapView addOverlay:lineOverlay];
                    }
                }
            }
        }
    }
}

-(void)HandlePlanRouteKML:(KMLDocument *)kmlDocument
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
                    NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                    [pAnnotation SetCoordinate:coordinate.longitude withLatitude:coordinate.latitude];
                    [pAnnotation SetID:i];
                    [m_MapView addAnnotation:pAnnotation];
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
                        [m_MapView addOverlay:lineOverlay];
                    }
                }
            }
        }
    }
}

-(void)HandlePlanPolyKML:(KMLDocument *)kmlDocument
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
                    NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                    [pAnnotation SetCoordinate:coordinate.longitude withLatitude:coordinate.latitude];
                    [pAnnotation SetID:i];
                    [m_MapView addAnnotation:pAnnotation];
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
                                [m_MapView addOverlay:polygonArea];
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)HandlePlanRectKML:(KMLDocument *)kmlDocument
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
                NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                [pAnnotation SetCoordinate:coordinate.longitude withLatitude:coordinate.latitude];
                [pAnnotation SetID:i];
                [m_MapView addAnnotation:pAnnotation];
                pts[k].latitude = coordinate.latitude;
                pts[k].longitude = coordinate.longitude;
                ++k;
                if(2 <= k)
                {
                    NOMGEOPlanRect* rectArea = [[NOMGEOPlanRect alloc] initWithStart:pts[0] end:pts[1]];
                    [m_MapView addOverlay:rectArea];
                    break;
                }
            }
        }
    }
}

-(void)HandleGneralKML:(NSString*)kml
{
    KMLRoot* kmlObject = [KMLParser parseKMLWithString:kml];
    if(kmlObject != nil)
    {
        KMLDocument *kmlDocument = (KMLDocument*)kmlObject.feature;
        if(kmlDocument != nil && kmlDocument.name != nil && 0 < kmlDocument.name.length  /*&& kmlDocument.schemata != nil && 0 < kmlDocument.schemata.count*/)
        {
            //KMLSchema* schemaData = (KMLSchema*)[kmlDocument.schemata objectAtIndex:0];
            //if(schemaData != nil && schemaData.objectID != nil && [schemaData.objectID isEqualToString:MAP_PLAN_LINE_ID] == YES)
            if([kmlDocument.name isEqualToString:MAP_PLAN_LINE_ID] == YES)
            {
                [self HandlePlanLineKML:kmlDocument];
            }
            else if([kmlDocument.name isEqualToString:MAP_PLAN_ROUTE_ID] == YES)
            {
                [self HandlePlanRouteKML:kmlDocument];
            }
            else if([kmlDocument.name isEqualToString:MAP_PLAN_POLY_ID] == YES)
            {
                [self HandlePlanPolyKML:kmlDocument];
            }
            else if([kmlDocument.name isEqualToString:MAP_PLAN_RECT_ID] == YES)
            {
                [self HandlePlanRectKML:kmlDocument];
            }
        }
    }
}

-(void)MakeAppLocationOnMap
{
    double dLat = [NOMAppInfo GetAppLatitude];
    double dLong = [NOMAppInfo GetAppLongitude];
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(m_MapView.visibleMapRect);
    region.center.latitude = dLat;
    region.center.longitude = dLong;
    region.span.latitudeDelta = [NOMAppInfo GetAppRegionRangeDegree]/10;
    region.span.longitudeDelta = [NOMAppInfo GetAppRegionRangeDegree]/10;
    [m_MapView setRegion:region animated:YES];
    
    double latStart = [NOMAppInfo GetAppLatitudeStart];
    double latEnd = [NOMAppInfo GetAppLatitudeEnd];
    double lonStart = [NOMAppInfo GetAppLongitudeStart];
    double lonEnd = [NOMAppInfo GetAppLongitudeEnd];
 
    [self ShowAppRegion:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd];
}

-(void)ShowAppRegion:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd
{
    CLLocationCoordinate2D pts[5];
    pts[0].longitude = lonStart;
    pts[0].latitude = latStart;
    pts[1].longitude = lonEnd;
    pts[1].latitude = latStart;
    pts[2].longitude = lonEnd;
    pts[2].latitude = latEnd;
    pts[3].longitude = lonStart;
    pts[3].latitude = latEnd;
    pts[4].longitude = lonStart;
    pts[4].latitude = latStart;
    m_AppRegionOverlay = [MKPolyline polylineWithCoordinates:pts count:5];
    [m_MapView addOverlay:m_AppRegionOverlay];
}

-(void)RedrawMapElements
{
    if(m_AppRegionOverlay != nil)
    {
        double dZoom = [self GetZoomFactor]/MAX_MKMAPVIEW_ZOOM;
        
        if(0.8 < dZoom)
            dZoom = 1.0;
        
        if(dZoom <= MIN_MKMAPOBJECT_ZOOM)
            dZoom = MIN_MKMAPOBJECT_ZOOM;
        if(1.0 < dZoom)
            dZoom = 1.0;
        
        MKPolylineRenderer* polyRender = (MKPolylineRenderer*)[m_MapView rendererForOverlay:m_AppRegionOverlay];
        if(polyRender != nil)
        {
            polyRender.lineWidth = DEFAULT_APP_COVER_LINE_WIDTH*dZoom;
            double ptlen = DEFAULT_APP_COVER_LINE_DASH_LENGHT*dZoom;
            double ptgap = DEFAULT_APP_COVER_LINE_DASH_GAP*dZoom;
            
            polyRender.lineDashPattern = @[[[NSNumber alloc] initWithDouble:ptlen], [[NSNumber alloc] initWithDouble:ptgap]];
        }
    }
}

-(void)RemoveAnnotations:(NSArray*)annotions
{
    [m_MapView removeAnnotations:annotions];
}

-(void)RemoveAnnotation:(id<MKAnnotation>)annotion
{
    [m_MapView removeAnnotation:annotion];
}

-(void)AddAnnotation:(id<MKAnnotation>)annotion
{
    [m_MapView addAnnotation:annotion];
//    [m_MapView setVisibleMapRect:m_MapView.visibleMapRect animated:YES];
    //??[self UpdateMapViewRenderingState];
}

-(void)AddOverlay:(id<MKOverlay>)overlay
{
    [m_MapView addOverlay:overlay];
    //??[self UpdateMapViewRenderingState];
}

-(void)RemoveOverlay:(id<MKOverlay>)overlay
{
    [m_MapView removeOverlay:overlay];
}

-(void)RemoveOverlays:(NSArray*)overlays
{
    [m_MapView removeOverlays:overlays];
}

-(void)SetShowCurrentLocation:(BOOL)bShow
{
    if(m_MapObjectController == nil || [m_MapObjectController IsLocationServiceAuthorization] == NO)
    {
        if(bShow == YES)
            return;
    }

    m_MapView.showsUserLocation = bShow;
}

-(void)ShowMyLocationPostAnnotation
{
    if(m_MapObjectController != nil && [m_MapObjectController IsLocationServiceAuthorization] == YES)
        m_MapView.showsUserLocation = YES;
}

-(void)HideMyLocationPostAnnotation
{
    m_MapView.showsUserLocation = NO;
}

-(void)UpdateAnnotationViewData
{
    NSArray* annotationList = [m_MapView annotations];
    if(annotationList != nil && 0 < annotationList.count)
    {
        for(int i = 0; i < annotationList.count; ++i)
        {
            id<MKAnnotation> pAnnotation = [annotationList objectAtIndex:i];
            if(pAnnotation != nil)
            {
                MKAnnotationView* pView = [m_MapView viewForAnnotation:pAnnotation];
                if(pView != nil)
                {
                    if([pView respondsToSelector:@selector(ReloadInformation)] == YES)
                    {
                        [pView performSelector:@selector(ReloadInformation)];
                    }
                }
            }
        }
    }
}

-(MKAnnotationView*)GetAnnotationView:(id <MKAnnotation>)pAnnotation
{
    MKAnnotationView* pRet = nil;
    if(pAnnotation != nil)
    {
        pRet = [m_MapView viewForAnnotation:pAnnotation];
    }
    return pRet;
}

-(MKCoordinateRegion)GetVisibleRegion
{
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(m_MapView.visibleMapRect);
    return region;
}

-(void)SetVisibleRegion:(MKCoordinateRegion)region
{
    [m_MapView setRegion:region animated:YES];
}

-(MKMapRect)GetVisibleRect
{
    MKMapRect rect = m_MapView.visibleMapRect;
    return rect;
}

-(MKCoordinateRegion)GetMapViewVisibleRegion
{
    return [self GetVisibleRegion];
}

-(double)GetVisibleRegionGEOWidthInMeter
{
    MKCoordinateRegion region = [self GetVisibleRegion];
    double cy = region.center.latitude;
    double cx = region.center.longitude;
    double left = cx - region.span.longitudeDelta;//*0.5;
    double right = cx + region.span.longitudeDelta;//*0.5;
    
    CLLocation* leftPt = [[CLLocation alloc] initWithLatitude:cy longitude:left];
    CLLocation* rightPt = [[CLLocation alloc] initWithLatitude:cy longitude:right];
    double distMeter = [rightPt distanceFromLocation:leftPt];
    
    return distMeter;
}

-(BOOL)CheckAnnotationWithMetaDataID:(NSString*)szID
{
    BOOL bRet = NO;
    
    NSArray* annotationList = [m_MapView annotations];
    if(annotationList != nil && 0 < annotationList.count)
    {
        for(int i = 0; i < annotationList.count; ++i)
        {
            id<MKAnnotation> pAnnoObject = [annotationList objectAtIndex:i];
            if(pAnnoObject != nil && [pAnnoObject isKindOfClass:[NOMQueryAnnotation class]] == YES)
            {
                NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)pAnnoObject;
                if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
                {
                    for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                    {
                        NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                        if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:szID] == YES)
                        {
                            return YES;
                        }
                    }
                }
            }
        }
    }
    
    return bRet;
}

@end
