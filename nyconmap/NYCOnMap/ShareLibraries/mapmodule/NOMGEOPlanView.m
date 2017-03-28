//
//  NOMGEOPlanView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-26.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMGEOPlanView.h"
#import "NOMAppInfo.h"
#import "NOMGUILayout.h"
#import "NOMGEOPlanPanel.h"
#import "CustomStatusBar.h"
#import "NOMPlanAnnotation.h"
#import "NOMGEOPlanLine.h"
#import "NOMGEOPlanPolygon.h"
#import "NOMGEOPlanRect.h"
#import "NOMMathHelper.h"
#import "NOMGEOPlanUndoManager.h"
#import "NOMMapPoint.h"
#import "NOMGEOPlanRoute.h"
#import "NOMGEOPlanRouteLineSegment.h"
#import "NOMKMLHelper.h"
#import "NOMReferenceAnnotation.h"
#import "NOMQueryLocationPin.h"

#include "NOMMapConstants.h"


@interface NOMGEOPlanView ()
{
    MKMapView*                                  m_MapView;
    NOMGEOPlanPanel*                            m_ControlPanel;
    CustomStatusBar*                            m_ReminderBar;
    int                                         m_EditMode;
    
    NOMGEOPlanUndoManager*                      m_UndoManager;
    
    NSMutableArray*                             m_PointList;
    
    NOMGEOPlanLine*                             m_RouteLine;
    NOMGEOPlanRoute*                            m_RouteRoutes;
    NOMGEOPlanPolygon*                          m_PolygonArea;
    NOMGEOPlanRect*                             m_RectArea;
    
    BOOL                                        m_bDragging;
    
    NOMReferenceAnnotation*                     m_ReferencePin;
    
}

-(void)UpdateLineOverlay;
-(void)UpdateRouteOverlay;
-(void)UpdatePolyOverlay;
-(void)UpdateRectOverlay;
-(void)AddUndo;
-(void)UpdateUndoButton;

@end

@implementation NOMGEOPlanView

-(void)UpdateUndoButton
{
    BOOL bShowUndo = [m_UndoManager CanUndo];
    [m_ControlPanel UpdateUndoButton:bShowUndo];
}

+(CGFloat)GetGEOPlanPinSize
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 40;
}

+(CGFloat)GetQueryPinWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 90;////120;//180;
    else
        return 60;////90;
}

+(CGFloat)GetQueryPinHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 120;
    else
        return 80;
}

+(CGFloat)GetControlPanelSize:(BOOL)bProtrait
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        if(bProtrait == YES)
            return 70;
        else
            return 80;
    }
    else
    {
        if(bProtrait == YES)
            return 50;
        else
            return 50;
    }
}

+(CGFloat)GetControlPanelSize
{
    return [NOMGEOPlanView GetControlPanelSize:[NOMGUILayout IsProtrait]];
}

+(CGRect)GetCurrentMapFrameRect
{
    CGFloat sx = 0;
    CGFloat sy = 0;
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGFloat psize = [NOMGEOPlanView GetControlPanelSize];
    
    if([NOMGUILayout IsLandscape] == YES)
    {
        w = w - psize;
    }
    else
    {
        h = h - psize;
    }
    
    CGRect rect = CGRectMake(sx, sy, w, h);
    return rect;
}

+(CGRect)GetControlPanelRect
{
    CGFloat sx = 0;
    CGFloat sy = 0;
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGFloat psize = [NOMGEOPlanView GetControlPanelSize];
    
    if([NOMGUILayout IsLandscape] == YES)
    {
        sx = w - psize;
        w = psize;
    }
    else
    {
        sy = h - psize;
        h = psize;
    }
    
    CGRect rect = CGRectMake(sx, sy, w, h);
    return rect;
}

-(void)AddUndo
{
    if(m_EditMode != NOMGEOPLAN_EDITMODE_ROUTE)
    {
        if(0 < (int)m_PointList.count)
        {
            NOMGEOPlanUndoRecord* pRecord = [[NOMGEOPlanUndoRecord alloc] init];
            CLLocationCoordinate2D pts[(int)m_PointList.count];
            for(int i = 0; i < (int)m_PointList.count; ++i)
            {
                pts[i] = [((NOMPlanAnnotation*)[m_PointList objectAtIndex:i]) coordinate];
            }
            [pRecord SetCoordinates:pts count:(int)m_PointList.count];
            [m_UndoManager Push:pRecord];
        }
        else
        {
            NOMGEOPlanUndoRecord* pRecord = [[NOMGEOPlanUndoRecord alloc] init];
            [pRecord SetCoordinates:NULL count:0];
            [m_UndoManager Push:pRecord];
        }
    }
    else
    {
        NOMGEOPlanUndoRecord* pRecord = [[NOMGEOPlanUndoRecord alloc] init];
        [pRecord SetCoordinates:NULL count:0];
        [m_UndoManager Push:pRecord];
        [self UpdateUndoButton];
    }
}

-(void)InitializeReminderBar
{
    CGFloat h = [NOMGEOPlanView GetControlPanelSize:YES];
    CGFloat w = [NOMGEOPlanPanel GetSmallDemensionSize];
    
    CGFloat sx = (self.frame.size.width - w)*0.5;
    CGFloat sy = 0;
    
    CGRect rect = CGRectMake(sx, sy, w, h);
    
    m_ReminderBar = [[CustomStatusBar alloc] initWithFrame:rect];
    
    [self addSubview:m_ReminderBar];
    
    [m_ReminderBar CloseView:NO];
}

-(void)initMapView
{
    CGRect rect = [NOMGEOPlanView GetCurrentMapFrameRect];
    m_MapView = [[MKMapView alloc] initWithFrame:rect];
    m_MapView.delegate = self;
    m_MapView.mapType = MKMapTypeStandard;
    
    m_MapView.showsBuildings = YES;
    m_MapView.showsPointsOfInterest = YES;
    m_MapView.pitchEnabled = YES;
    m_MapView.rotateEnabled = YES;
    m_MapView.zoomEnabled = YES;
    m_MapView.scrollEnabled = YES;
    [self addSubview:m_MapView];
    
}

-(void)unloadMapView
{
    if(m_MapView != nil)
    {
        [m_MapView removeFromSuperview];
        m_MapView = nil;
    }
}

-(void)initControlPanel
{
    CGRect rect = [NOMGEOPlanView GetControlPanelRect];
    m_ControlPanel = [[NOMGEOPlanPanel alloc] initWithFrame:rect];
    [self addSubview:m_ControlPanel];
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        m_UndoManager = [[NOMGEOPlanUndoManager alloc] init];
        
        
        m_PointList = [[NSMutableArray alloc] init];
        m_RouteLine = nil;
        m_RectArea = nil;
        m_PolygonArea = nil;
        
        m_RouteRoutes = [[NOMGEOPlanRoute alloc] init];
        [m_RouteRoutes RegisterParent:self];
        
        m_EditMode = NOMGEOPLAN_EDITMODE_NONE;
        
        m_bDragging = NO;
        m_ReferencePin = [[NOMReferenceAnnotation alloc] init];
        
        m_MapView = nil;
        [self initMapView];
        [self initControlPanel];
        [self InitializeReminderBar];
    }
    return self;
}

-(void)ClearMap
{
    if(m_MapView != nil)
    {
        [m_MapView removeAnnotations:m_PointList];
    
        if(m_RouteLine != nil)
            [m_MapView removeOverlay:m_RouteLine];
    
        if(m_PolygonArea != nil)
            [m_MapView removeOverlay:m_PolygonArea];
    
        if(m_RectArea != nil)
            [m_MapView removeOverlay:m_RectArea];
    }
    [m_UndoManager Reset];
    [m_RouteRoutes Reset];
    [m_PointList removeAllObjects];
    m_RouteLine = nil;
    m_PolygonArea = nil;
    m_RectArea = nil;
    [self willChangeValueForKey:@"isDragging"];
    m_bDragging = NO;
    [self didChangeValueForKey:@"isDragging"];
    
}

-(void)RemoveOverlay:(id <MKOverlay>)overlay
{
    if(m_MapView != nil)
        [m_MapView removeOverlay:overlay];
}

-(void)RemoveOverlays:(NSArray *)overlays
{
    if(m_MapView != nil)
        [m_MapView removeOverlays:overlays];
}

-(void)AddOverlay:(id <MKOverlay>)overlay
{
    if(m_MapView != nil)
        [m_MapView addOverlay:overlay];
}

-(void)Reset
{
    [self ClearMap];
    [self SetMapTypeStandard];
    [m_ControlPanel Reset];
    m_EditMode = NOMGEOPLAN_EDITMODE_NONE;
}

-(void)UpdateLayout
{
    CGRect rect = [NOMGEOPlanView GetCurrentMapFrameRect];
    if(m_MapView != nil)
        [m_MapView setFrame:rect];
    rect = [NOMGEOPlanView GetControlPanelRect];
    [m_ControlPanel setFrame:rect];
    [m_ControlPanel UpdateLayout];
    
    CGFloat h = [NOMGEOPlanView GetControlPanelSize:YES];
    CGFloat w = [NOMGEOPlanPanel GetSmallDemensionSize];
    
    CGFloat sx = (self.frame.size.width - w)*0.5;
    CGFloat sy = 0;
    
    rect = CGRectMake(sx, sy, w, h);
    
    [m_ReminderBar setFrame:rect];
    [m_ReminderBar UpdateLayout];
}

-(void)SetPlanEditMode:(int)nEditMode
{
    if(NOMGEOPLAN_EDITMODE_NONE <= nEditMode && nEditMode <= NOMGEOPLAN_EDITMODE_RECT)
    {
        m_EditMode = nEditMode;
    }
}

-(void)OnViewClose
{
	self.hidden = YES;
	[[self superview] sendSubviewToBack:self];
    //[self unloadMapView]; //!!!
}

-(void)CloseView:(BOOL)bAnimation
{
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[self setAlpha:0.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewClose)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
		[UIView commitAnimations];
	}
	else
	{
		[self OnViewClose];
	}
}

-(void)OnViewOpen
{
}

-(void)OpenView:(BOOL)bAnimation
{
    [self Reset];
    //[self initMapView];//!!!!!
	self.hidden = NO;
	[[self superview] bringSubviewToFront:self];
    [self setAlpha:1.0];
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewOpen)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
		[UIView commitAnimations];
	}
	else
	{
		[self OnViewOpen];
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

-(void)OpenReminderBar
{
/*    [m_ReminderBar SetText:@"This is test string"];
    if(m_ReminderBar.hidden == YES)
    {
        [m_ReminderBar StartAutoDisplay:20];
    }*/
}

-(void)CloseReminderBar
{
    if(m_ReminderBar.hidden == NO)
    {
        [m_ReminderBar CloseView:YES];
    }
}

-(void)UpdateLineOverlay
{
    if(m_RouteLine != nil)
        [m_MapView removeOverlay:m_RouteLine];
    
    m_RouteLine = nil;
    
    if(2 <= m_PointList.count)
    {
        
        int nCount = (int)m_PointList.count;
        MKMapPoint pts[nCount];
        for(int i = 0; i < nCount; ++i)
        {
            pts[i] = MKMapPointForCoordinate([((NOMPlanAnnotation*)[m_PointList objectAtIndex:i]) coordinate]);
        }
        
        m_RouteLine = [[NOMGEOPlanLine alloc] initWith:(MKMapPoint *)pts withCount:nCount];
        [m_MapView addOverlay:m_RouteLine];
    }
    
    [self UpdateUndoButton];
}

-(void)UpdateRouteOverlay
{
    [self UpdateUndoButton];
}

-(void)UpdatePolyOverlay
{
    if(m_PolygonArea != nil)
        [m_MapView removeOverlay:m_PolygonArea];
    
    m_PolygonArea = nil;
    
    if(3 <= m_PointList.count)
    {
        int nCount = (int)m_PointList.count;
        CLLocationCoordinate2D pts[nCount];
        for(int i = 0; i < nCount; ++i)
        {
            pts[i] = [((NOMPlanAnnotation*)[m_PointList objectAtIndex:i]) coordinate];
        }
        
        m_PolygonArea = [[NOMGEOPlanPolygon alloc] initWithCoordinates:pts count:nCount];
        [m_MapView addOverlay:m_PolygonArea];
    }
    [self UpdateUndoButton];
}

-(void)UpdateRectOverlay
{
    if(m_RectArea != nil)
        [m_MapView removeOverlay:m_RectArea];
    m_RectArea = nil;

    if(2 <= m_PointList.count)
    {
        m_RectArea = [[NOMGEOPlanRect alloc] initWithStart:[((NOMPlanAnnotation*)[m_PointList objectAtIndex:0]) coordinate] end:[((NOMPlanAnnotation*)[m_PointList objectAtIndex:1]) coordinate]];
        [m_MapView addOverlay:m_RectArea];
    }

    [self UpdateUndoButton];
}

-(void)HandleLineTouchPoint:(CLLocationCoordinate2D)touchPoint
{
    NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
    [pAnnotation SetCoordinate:touchPoint.longitude withLatitude:touchPoint.latitude];
    [m_MapView addAnnotation:pAnnotation];
    int nCount = (int)m_PointList.count;
    [pAnnotation SetID:nCount];
    [m_PointList addObject:pAnnotation];
    [self UpdateLineOverlay];
}

-(void)HandleRouteTouchPoint:(CLLocationCoordinate2D)touchPoint
{
    NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
    [pAnnotation SetCoordinate:touchPoint.longitude withLatitude:touchPoint.latitude];
    [m_MapView addAnnotation:pAnnotation];
    int nCount = (int)m_PointList.count;
    [pAnnotation SetID:nCount];
    [m_PointList addObject:pAnnotation];
    if(2 <= m_PointList.count)
    {
        CLLocationCoordinate2D startPoint = ((NOMPlanAnnotation*)[m_PointList objectAtIndex:(m_PointList.count-2)]).coordinate;
        CLLocationCoordinate2D endPoint = ((NOMPlanAnnotation*)[m_PointList objectAtIndex:(m_PointList.count-1)]).coordinate;
        [m_RouteRoutes AddRoute:startPoint end:endPoint];
    }
    /*[self UpdateRouteOverlay];*/
}

-(void)HandlePolyTouchPoint:(CLLocationCoordinate2D)touchPoint
{
    NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
    [pAnnotation SetCoordinate:touchPoint.longitude withLatitude:touchPoint.latitude];
    [m_MapView addAnnotation:pAnnotation];

    BOOL bAnnotationAdded = NO;
    if(3 <= m_PointList.count)
    {
        CLLocationCoordinate2D Line1Start = [(NOMPlanAnnotation*)[m_PointList objectAtIndex:(m_PointList.count-1)] coordinate];
        CLLocationCoordinate2D Line1End = [pAnnotation coordinate];
 /*
        for(int i = m_PointList.count-2; 0 < i; --i)
        {
            CLLocationCoordinate2D Line2Start = [[m_PointList objectAtIndex:i] coordinate];
            CLLocationCoordinate2D Line2End = [[m_PointList objectAtIndex:i-1] coordinate];
            BOOL bIntersect = [NOMMathHelper Intersect:Line1Start line1End:Line1End line2Start:Line2Start line2End:Line2End];
            if(bIntersect == YES)
            {
                bAnnotationAdded = YES;
                [m_PointList insertObject:pAnnotation atIndex:i];
                break;
            }
        }
        if(bAnnotationAdded == NO)
        {
            Line1Start = [[m_PointList objectAtIndex:0] coordinate];
            Line1End = [pAnnotation coordinate];
            for(int i = m_PointList.count-1; 1 < i; --i)
            {
                CLLocationCoordinate2D Line2Start = [[m_PointList objectAtIndex:i] coordinate];
                CLLocationCoordinate2D Line2End = [[m_PointList objectAtIndex:i-1] coordinate];
                BOOL bIntersect = [NOMMathHelper Intersect:Line1Start line1End:Line1End line2Start:Line2Start line2End:Line2End];
                if(bIntersect == YES)
                {
                    bAnnotationAdded = YES;
                    [m_PointList insertObject:pAnnotation atIndex:i];
                    break;
                }
            }
        }
 */

        for(int i = 0; i < m_PointList.count-2; ++i)
        {
            CLLocationCoordinate2D Line2Start = [(NOMPlanAnnotation*)[m_PointList objectAtIndex:i] coordinate];
            CLLocationCoordinate2D Line2End = [(NOMPlanAnnotation*)[m_PointList objectAtIndex:i+1] coordinate];
            BOOL bIntersect = [NOMMathHelper Intersect:Line1Start line1End:Line1End line2Start:Line2Start line2End:Line2End];
            if(bIntersect == YES)
            {
                bAnnotationAdded = YES;
                int nCount = (int)m_PointList.count;
                [pAnnotation SetID:nCount];
                [m_PointList insertObject:pAnnotation atIndex:i+1];
                break;
            }
        }
        if(bAnnotationAdded == NO)
        {
            Line1Start = [(NOMPlanAnnotation*)[m_PointList objectAtIndex:0] coordinate];
            Line1End = [pAnnotation coordinate];
            for(int i = 1; i <= m_PointList.count-2; ++i)
            {
                CLLocationCoordinate2D Line2Start = [(NOMPlanAnnotation*)[m_PointList objectAtIndex:i] coordinate];
                CLLocationCoordinate2D Line2End = [(NOMPlanAnnotation*)[m_PointList objectAtIndex:i+1] coordinate];
                BOOL bIntersect = [NOMMathHelper Intersect:Line1Start line1End:Line1End line2Start:Line2Start line2End:Line2End];
                if(bIntersect == YES)
                {
                    bAnnotationAdded = YES;
                    int nCount = (int)m_PointList.count;
                    [pAnnotation SetID:nCount];
                    [m_PointList insertObject:pAnnotation atIndex:i+1];
                    break;
                }
            }
        }
    }
    if(bAnnotationAdded == NO)
    {
        int nCount = (int)m_PointList.count;
        [pAnnotation SetID:nCount];
        [m_PointList addObject:pAnnotation];
    }
    [self UpdatePolyOverlay];
}

-(void)HandleRectTouchPoint:(CLLocationCoordinate2D)touchPoint
{
    if(m_PointList.count < 2)
    {
        NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
        [pAnnotation SetCoordinate:touchPoint.longitude withLatitude:touchPoint.latitude];
        int nCount = (int)m_PointList.count;
        [pAnnotation SetID:nCount];
        [m_MapView addAnnotation:pAnnotation];
        [m_PointList addObject:pAnnotation];
        [self UpdateRectOverlay];
    }
    else if(2 <= m_PointList.count)
    {
        [m_MapView removeAnnotation:[m_PointList objectAtIndex:(m_PointList.count -1)]];
        [m_PointList removeLastObject];
        NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
        [pAnnotation SetCoordinate:touchPoint.longitude withLatitude:touchPoint.latitude];
        int nCount = (int)m_PointList.count;
        [pAnnotation SetID:nCount];
        [m_MapView addAnnotation:pAnnotation];
        [m_PointList addObject:pAnnotation];
        [self UpdateRectOverlay];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_EditMode == NOMGEOPLAN_EDITMODE_NONE)
    {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    if(m_bDragging == YES)
    {
        [self willChangeValueForKey:@"isDragging"];
        m_bDragging = NO;
        [self didChangeValueForKey:@"isDragging"];
        [super touchesEnded:touches withEvent:event];
        return;
    }
    UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
    if(touch != nil)
    {
        CGPoint touchPoint = [touch locationInView:m_MapView]; //here locationInView it would be mapView
        CLLocationCoordinate2D touchCoordinate = [m_MapView convertPoint:touchPoint toCoordinateFromView:m_MapView];
        if(m_EditMode == NOMGEOPLAN_EDITMODE_LINE)
        {
            [self AddUndo];
            [self HandleLineTouchPoint:touchCoordinate];
        }
        else if(m_EditMode == NOMGEOPLAN_EDITMODE_ROUTE)
        {
            [self AddUndo];
            [self HandleRouteTouchPoint:touchCoordinate];
        }
        else if(m_EditMode == NOMGEOPLAN_EDITMODE_POLY)
        {
            [self AddUndo];
            [self HandlePolyTouchPoint:touchCoordinate];
        }
        else if(m_EditMode == NOMGEOPLAN_EDITMODE_RECT)
        {
            [self AddUndo];
            [self HandleRectTouchPoint:touchCoordinate];
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_bDragging == YES)
    {
        [self SetPinDragState:NO];
    }
    [super touchesCancelled:touches withEvent:event];
    return;
}

-(CLLocationCoordinate2D)GetTouchCoordinate:(UITouch*)touch
{
    CGPoint touchPoint = [touch locationInView:m_MapView]; //here locationInView it would be mapView
    CLLocationCoordinate2D touchCoordinate = [m_MapView convertPoint:touchPoint toCoordinateFromView:m_MapView];
    return touchCoordinate;
}


-(void)Undo
{
    if(m_EditMode != NOMGEOPLAN_EDITMODE_ROUTE)
    {
        if([m_UndoManager CanUndo])
        {
            [m_MapView removeAnnotations:m_PointList];
            [m_PointList removeAllObjects];
        
            if(m_RouteLine != nil)
                [m_MapView removeOverlay:m_RouteLine];
            m_RouteLine = nil;
        
            if(m_PolygonArea != nil)
                [m_MapView removeOverlay:m_PolygonArea];
            m_PolygonArea = nil;
        
            if(m_RectArea != nil)
                [m_MapView removeOverlay:m_RectArea];
            m_RectArea = nil;
        
            NOMGEOPlanUndoRecord* pRecord = [m_UndoManager Popup];
        
            if(pRecord != nil)
            {
                NSArray* pts = [pRecord GetPoints];
                if(pts != nil && 0 < pts.count)
                {
                    int nCount = (int)pts.count;
                    for(int i = 0; i < nCount; ++i)
                    {
                        NOMMapPoint* pt = (NOMMapPoint*)[pts objectAtIndex:i];
                        NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                        [pAnnotation SetCoordinate:pt.coordinate.longitude withLatitude:pt.coordinate.latitude];
                        [pAnnotation SetID:i];
                        [m_PointList addObject:pAnnotation];
                    }
                    [m_MapView addAnnotations:m_PointList];
                    [self UpdateOverlay];
                }
            }
        }
        [self UpdateUndoButton];
    }
    else
    {
        NOMGEOPlanUndoRecord* pRecord = [m_UndoManager Popup];
        pRecord = nil;
        int nLastID = (int)m_PointList.count - 1;
        if(0 <= nLastID)
        {
            NOMPlanAnnotation* pAnnotation = [m_PointList objectAtIndex:nLastID];
            [m_MapView removeAnnotation:pAnnotation];
            
            [m_PointList removeLastObject];
        }
        [m_RouteRoutes Undo];
        
        [self UpdateUndoButton];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[NOMPlanAnnotation class]])
    {
        int nID = [((NOMPlanAnnotation *)annotation) GetID];
        NSString *JustPlanMarkerAnnotationIdentifier = [NSString stringWithFormat:@"JustPlanMarkerAnnotationIdentifier_%i", nID];
        
        NOMGEOPlanAnnotationView *pinView = nil;//(NOMGEOPlanAnnotationView *) [m_MapView dequeueReusableAnnotationViewWithIdentifier:JustPlanMarkerAnnotationIdentifier];
        if (pinView == nil)
        {
            CGSize size = CGSizeMake([NOMGEOPlanView GetGEOPlanPinSize], [NOMGEOPlanView GetGEOPlanPinSize]);
            
            // if an existing pin view was not available, create one
            NOMGEOPlanAnnotationView *customPinView = [[NOMGEOPlanAnnotationView alloc]
                                                       initWithAnnotation:annotation
                                                       reuseIdentifier:JustPlanMarkerAnnotationIdentifier
                                                       withSize:size
                                                       withParent:self];
            
            if(m_EditMode != NOMGEOPLAN_EDITMODE_ROUTE)
                customPinView.draggable = YES;
            else
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
    if([annotation isKindOfClass:[NOMReferenceAnnotation class]])
    {
        static NSString *PinAnnotationIdentifier = @"GEOPlanViewReferencePintAnnotationIdentifier";
        
        NOMQueryLocationPin *pinView =
        (NOMQueryLocationPin *) [m_MapView dequeueReusableAnnotationViewWithIdentifier:PinAnnotationIdentifier];
        if (pinView == nil)
        {
            
            CGSize size = CGSizeMake([NOMGEOPlanView GetQueryPinWidth], [NOMGEOPlanView GetQueryPinHeight]);
            // if an existing pin view was not available, create one
            NOMQueryLocationPin *customPinView = [[NOMQueryLocationPin alloc] initWithAnnotation:annotation reuseIdentifier:PinAnnotationIdentifier withSize:size];
                
            //customPinView.pinColor = MKPinAnnotationColorGreen;
            customPinView.canShowCallout = YES;
            [customPinView RegisterCallout:nil];
            [customPinView RegisterMap:m_MapView];
            [customPinView ReloadInformation];
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
            [pinView ReloadInformation];
        }
        return pinView;
    }
    
    return nil;
}

-(void)UpdateOverlay
{
    if(m_EditMode == NOMGEOPLAN_EDITMODE_LINE)
    {
        [self UpdateLineOverlay];
    }
    else if(m_EditMode == NOMGEOPLAN_EDITMODE_ROUTE)
    {
        [self UpdateRouteOverlay];
    }
    else if(m_EditMode == NOMGEOPLAN_EDITMODE_POLY)
    {
        [self UpdatePolyOverlay];
    }
    else if(m_EditMode == NOMGEOPLAN_EDITMODE_RECT)
    {
        [self UpdateRectOverlay];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if(newState == MKAnnotationViewDragStateStarting || newState == MKAnnotationViewDragStateStarting)
    {
        [self AddUndo];
        [self SetPinDragState:YES];
    }
    else if(newState == MKAnnotationViewDragStateCanceling || newState == MKAnnotationViewDragStateEnding)
    //if (newState == MKAnnotationViewDragStateNone && oldState == MKAnnotationViewDragStateEnding)
    {
        /*
        if(view != nil && view.annotation != nil && [view.annotation isKindOfClass:[NOMPlanAnnotation class]])
        {
            int index = [m_PointList indexOfObject:view.annotation];
            if(0 <= index && index < m_PointList.count)
            {
                CLLocationDegrees latitude = ((NOMPlanAnnotation*)view.annotation).coordinate.latitude;
                CLLocationDegrees longitude = ((NOMPlanAnnotation*)view.annotation).coordinate.longitude;
                [m_MapView removeAnnotation:view.annotation];
                [m_PointList removeObjectAtIndex:index];
                NOMPlanAnnotation* pAnnotation = [[NOMPlanAnnotation alloc] init];
                [pAnnotation SetCoordinate:longitude withLatitude:latitude];
                [m_MapView addAnnotation:pAnnotation];
                [m_PointList insertObject:pAnnotation atIndex:index];
            }
            [self UpdateOverlay];
        }
        */
        [self UpdateOverlay];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if([overlay isKindOfClass:[NOMGEOPlanLine class]])
    {
        double dZoom = [self GetZoomFactor]/MAX_MKMAPVIEW_ZOOM;
        
        if(dZoom <= 0.1)
            dZoom = 0.1;
        if(1.0 < dZoom)
            dZoom = 1.0;
        
        MKPolylineRenderer *routeRender = [[MKPolylineRenderer alloc] initWithPolyline:((MKPolyline*)overlay)];
        routeRender.lineWidth = (CGFloat)(MAP_PLAN_LINE_DEFAULT_WIDTH*dZoom);
        routeRender.strokeColor = MAP_PLAN_LINE_COLOR;
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
    if([overlay isKindOfClass:[NOMGEOPlanRouteLineSegment class]] == YES)
    {
        MKPolylineRenderer *routeRender = [[MKPolylineRenderer alloc] initWithPolyline:((MKPolyline*)overlay)];
        routeRender.lineWidth = MAP_PLAN_ROUTE_DEFAULT_WIDTH;
        routeRender.strokeColor = MAP_PLAN_ROUTE_COLOR;
        return routeRender;
    }
    
    return nil;
}

-(void)SetPinDragState:(BOOL)bDragging
{
    [self willChangeValueForKey:@"isDragging"];
    m_bDragging = bDragging;
    [self didChangeValueForKey:@"isDragging"];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(0 < m_PointList.count)
    {
        for(int i = 0; i < m_PointList.count; ++i)
        {
            MKAnnotationView* pPin = [m_MapView  viewForAnnotation:[m_PointList objectAtIndex:i]];
            if(pPin != nil)
            {
                [pPin setNeedsDisplay];
            }
        }
    }
    
    NOMQueryLocationPin* pQueryPin = (NOMQueryLocationPin*)[m_MapView viewForAnnotation:m_ReferencePin];
    if(pQueryPin != nil)
    {
        [pQueryPin UpdateZoomSize];
    }
    [self UpdateOverlay];
}

-(KMLRoot*)GetLineKMLObject
{
    KMLRoot* kmlObject = [KMLRoot new];
    KMLDocument *kmlDocument = [KMLDocument new];
    kmlObject.feature = kmlDocument;
    kmlDocument.name = MAP_PLAN_LINE_ID;
    
    KMLSchema* idSchema = [KMLSchema new];
    idSchema.objectID = MAP_PLAN_LINE_ID;
    idSchema.name = MAP_PLAN_LINE_ID;
    [kmlDocument addSchema:idSchema];
    
    if(m_PointList.count == 1)
    {
        KMLPlacemark *poitPlacemark = [NOMKMLHelper KMLPointWithTag:KML_TAG_POINT coordinate:((NOMAnnotationBase*)[m_PointList objectAtIndex:0]).coordinate];
        [kmlDocument addFeature:poitPlacemark];
    }
    else
    {
        for(int i = 0; i < m_PointList.count; ++i)
        {
            KMLPlacemark *poitPlacemark = [NOMKMLHelper KMLPointWithTag:KML_TAG_POINT coordinate:((NOMAnnotationBase*)[m_PointList objectAtIndex:i]).coordinate];
            [kmlDocument addFeature:poitPlacemark];
        }
        KMLPlacemark *linePlacemark = [NOMKMLHelper KMLLineWithTag:KML_TAG_MARKLINE withMKAnnotations:m_PointList lineWidth:MAP_PLAN_LINE_DEFAULT_WIDTH lineColor:MAP_PLAN_LINE_COLOR];
        [kmlDocument addFeature:linePlacemark];
    }
    
    return kmlObject;
}

-(KMLRoot*)GetRouteKMLObject
{
    KMLRoot* kmlObject = [KMLRoot new];
    
    KMLDocument *kmlDocument = [KMLDocument new];
    kmlObject.feature = kmlDocument;
    kmlDocument.name = MAP_PLAN_ROUTE_ID;
    
    KMLSchema* idSchema = [KMLSchema new];
    idSchema.objectID = MAP_PLAN_ROUTE_ID;
    idSchema.name = MAP_PLAN_ROUTE_ID;
    [kmlDocument addSchema:idSchema];
    
    if(m_PointList.count == 1)
    {
        KMLPlacemark *poitPlacemark = [NOMKMLHelper KMLPointWithTag:KML_TAG_POINT coordinate:((NOMAnnotationBase*)[m_PointList objectAtIndex:0]).coordinate];
        [kmlDocument addFeature:poitPlacemark];
    }
    else
    {
        for(int i = 0; i < m_PointList.count; ++i)
        {
            KMLPlacemark *poitPlacemark = [NOMKMLHelper KMLPointWithTag:KML_TAG_POINT coordinate:((NOMAnnotationBase*)[m_PointList objectAtIndex:i]).coordinate];
            [kmlDocument addFeature:poitPlacemark];
        }
        NSArray* routes = [m_RouteRoutes GetRoutes];
        if(routes != nil && 0 < routes.count)
        {
            for(int i = 0; i < routes.count; ++i)
            {
                NOMGEOPlanRouteLineSegment* pSegment = (NOMGEOPlanRouteLineSegment*)[routes objectAtIndex:i];
                if(pSegment != nil && pSegment.points != NULL && 0 < pSegment.pointCount)
                {
                    KMLPlacemark *linePlacemark = [NOMKMLHelper KMLLineWithTag:KML_TAG_MARKROUTE withMKMapPoints:pSegment.points withCount:(int)pSegment.pointCount lineWidth:MAP_PLAN_ROUTE_DEFAULT_WIDTH lineColor:MAP_PLAN_ROUTE_COLOR];
                    [kmlDocument addFeature:linePlacemark];
                }
            }
        }
    }
    
    return kmlObject;
}

-(KMLRoot*)GetPolyKMLObject
{
    KMLRoot* kmlObject = [KMLRoot new];

    KMLDocument *kmlDocument = [KMLDocument new];
    kmlObject.feature = kmlDocument;
    kmlDocument.name = MAP_PLAN_POLY_ID;
    
    KMLSchema* idSchema = [KMLSchema new];
    idSchema.objectID = MAP_PLAN_POLY_ID;
    idSchema.name = MAP_PLAN_POLY_ID;
    [kmlDocument addSchema:idSchema];
    
    for(int i = 0; i < m_PointList.count; ++i)
    {
        KMLPlacemark *poitPlacemark = [NOMKMLHelper KMLPointWithTag:KML_TAG_POINT coordinate:((NOMAnnotationBase*)[m_PointList objectAtIndex:i]).coordinate];
        [kmlDocument addFeature:poitPlacemark];
    }
    if(2 <= m_PointList.count)
    {
        KMLPlacemark *polyPlacemark = [NOMKMLHelper KMLPolygonWithTag:KML_TAG_MARKPOLY withMKAnnotations:m_PointList lineWidth:MAP_PLAN_ROUTE_DEFAULT_WIDTH withColor:MAP_PLAN_ROUTE_COLOR];
        [kmlDocument addFeature:polyPlacemark];
    }
    return kmlObject;
}

-(KMLRoot*)GetRectKMLObject
{
    KMLRoot* kmlObject = [KMLRoot new];

    KMLDocument *kmlDocument = [KMLDocument new];
    kmlObject.feature = kmlDocument;
    kmlDocument.name = MAP_PLAN_RECT_ID;
    
    KMLSchema* idSchema = [KMLSchema new];
    idSchema.objectID = MAP_PLAN_RECT_ID;
    idSchema.name = MAP_PLAN_RECT_ID;
    [kmlDocument addSchema:idSchema];
    
    if(2 <= m_PointList.count)
    {
        for(int i = 0; i < 2; ++i)
        {
            KMLPlacemark *poitPlacemark = [NOMKMLHelper KMLPointWithTag:KML_TAG_POINT coordinate:((NOMAnnotationBase*)[m_PointList objectAtIndex:i]).coordinate];
            [kmlDocument addFeature:poitPlacemark];
        }
    }
    
    return kmlObject;
}

-(KMLRoot*)GetKMLObject
{
    KMLRoot* kmlObject = nil;
    
    if(0 < m_PointList.count)
    {
        if(m_EditMode == NOMGEOPLAN_EDITMODE_LINE)
        {
            kmlObject = [self GetLineKMLObject];
        }
        else if(m_EditMode == NOMGEOPLAN_EDITMODE_ROUTE)
        {
            kmlObject = [self GetRouteKMLObject];
        }
        else if(m_EditMode == NOMGEOPLAN_EDITMODE_POLY)
        {
            kmlObject = [self GetPolyKMLObject];
        }
        else if(m_EditMode == NOMGEOPLAN_EDITMODE_RECT)
        {
            kmlObject = [self GetRectKMLObject];
        }
    }
    return kmlObject;
}

-(void)OnPlanCompleted
{
    [self CloseView:YES];
    
    KMLRoot* kml = [self GetKMLObject];
    if(kml != nil && kml.kml != nil && 0 < kml.kml.length)
    {
        if([self.superview respondsToSelector:@selector(HandlePlanCompleted:)] == YES)
        {
            [self.superview performSelector:@selector(HandlePlanCompleted:) withObject:kml.kml];
        }
    }
}

-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span
{
    if(m_ReferencePin != nil)
    {
        [m_ReferencePin SetCoordinate:dLong withLatitude:dLat];
        [m_MapView addAnnotation:m_ReferencePin];
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(m_MapView.visibleMapRect);
        region.center.latitude = dLat;
        region.center.longitude = dLong;
        region.span.latitudeDelta = Span;
        region.span.longitudeDelta = Span;
        [m_MapView setRegion:region animated:YES];
    }
}

-(void)ClearReferencePoint
{
    if(m_MapView)
    [m_MapView removeAnnotation:m_ReferencePin];
}

-(void)SetReferenceInfo:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType isTTweet:(BOOL)bTwitterTweet
{
    if(m_ReferencePin != nil)
    {
        [m_ReferencePin SetNewsDataMainType:nMainCate withSubType:nSubCate withThirdType:nThirdType];
        [m_ReferencePin SetTwitterTweet:bTwitterTweet];
    }
}
@end
