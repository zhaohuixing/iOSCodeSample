//
//  MapFrameView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MapFrameView.h"
#import "MapUIAnnotation.h"
#import "GUILayout.h"

@implementation MapFrameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float fSize = [GUILayout GetDefaultAlertUIEdge];
        float w = self.frame.size.width-fSize*2.0;
        float h = self.frame.size.height-fSize*2.0;
        CGRect rt = CGRectMake(fSize, fSize, w, h);
        m_MapView = [[MKMapView alloc] initWithFrame:rt];
        m_MapView.delegate = self;
        m_MapView.mapType = MKMapTypeStandard; 
        [self addSubview:m_MapView];
        [m_MapView release];
        m_MapAnnotationList = [[NSMutableArray alloc] init];
        [self bringSubviewToFront:m_CloseButton];
    }
    return self;
}

- (void)dealloc
{
    [self Reset];
    [m_MapAnnotationList release];
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

- (void)OnViewClose
{
    [super OnViewClose];
    if([self.superview respondsToSelector:@selector(CloseView)])
    {
        [self.superview performSelector:@selector(CloseView)];
    }
}

-(void)UpdateViewLayout
{
    [super UpdateViewLayout];
    float fSize = [GUILayout GetDefaultAlertUIEdge];
    float w = self.frame.size.width-fSize*2.0;
    float h = self.frame.size.height-fSize*2.0;
    CGRect rt = CGRectMake(fSize, fSize, w, h);
    [m_MapView setFrame:rt];
    [m_MapView setNeedsDisplay];
}

-(void)Reset
{
    [m_MapAnnotationList removeAllObjects];
}

-(void)AddMKAnnotation:(UIImage*)icon withTitle:(NSString*)title withText:(NSString*)text withLatitude:(float)fLatitude withLongitude:(float)fLongitude withID:(int)nID isMaster:(BOOL)bMaster
{
    MapUIAnnotation* pAnnotation = [[[MapUIAnnotation alloc] init] autorelease];
    pAnnotation.m_Icon = icon;
    pAnnotation.m_Title = title;
    pAnnotation.m_Text = text;
    pAnnotation.m_fLatitude = fLatitude;
    pAnnotation.m_fLongitude = fLongitude;
    pAnnotation.m_nAnnotionID = nID;
    pAnnotation.m_bMaster = bMaster;
    [m_MapAnnotationList addObject:pAnnotation];
}

-(void)ShowMap:(MapUIAnnotation*)pAnnotation
{
    [m_MapView addAnnotation:pAnnotation];
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = pAnnotation.m_fLatitude;
    newRegion.center.longitude = pAnnotation.m_fLongitude;
    newRegion.span.latitudeDelta = [GUILayout GetDefaultMapLatitudeSpan];
    newRegion.span.longitudeDelta = [GUILayout GetDefaultMapLongitudeSpan];
    [m_MapView setRegion:newRegion animated:YES];
}

-(void)ShowAllLocations
{
    int nCount =[m_MapAnnotationList count];
    if(nCount <= 0)
        return;
    
    float minLatitude = 0;
    float maxLatitude = 0;
    float minLongitude = 0;
    float maxLongitude = 0;
    float centerLatitude = 0;
    float centerLongitude = 0;
    float spanLatitude = 0;
    float spanLongitude = 0;

    MapUIAnnotation* pAnnotation = (MapUIAnnotation*)[m_MapAnnotationList objectAtIndex:0];
    if(pAnnotation.m_fLatitude < minLatitude)
        minLatitude = pAnnotation.m_fLatitude;
    if(maxLatitude < pAnnotation.m_fLatitude)
        maxLatitude = pAnnotation.m_fLatitude;
    if(pAnnotation.m_fLongitude < minLongitude)
        minLongitude = pAnnotation.m_fLongitude;
    if(maxLongitude < pAnnotation.m_fLongitude)
        maxLongitude = pAnnotation.m_fLongitude;
    
    for (int i = 1; i < nCount; ++i) 
    {
        pAnnotation = (MapUIAnnotation*)[m_MapAnnotationList objectAtIndex:i];
        if(pAnnotation.m_fLatitude < minLatitude)
            minLatitude = pAnnotation.m_fLatitude;
        if(maxLatitude < pAnnotation.m_fLatitude)
            maxLatitude = pAnnotation.m_fLatitude;
        if(pAnnotation.m_fLongitude < minLongitude)
            minLongitude = pAnnotation.m_fLongitude;
        if(maxLongitude < pAnnotation.m_fLongitude)
            maxLongitude = pAnnotation.m_fLongitude;
    }

    centerLatitude = (minLatitude + maxLatitude)/2.0;
    centerLongitude = (minLongitude + maxLongitude)/2.0;
    spanLatitude = (maxLatitude - minLatitude);
    spanLongitude = (maxLongitude - minLongitude);

    MKCoordinateRegion region;
    region.center.latitude = centerLatitude;
    region.center.longitude = centerLongitude;
    region.span.latitudeDelta = spanLatitude;
    region.span.longitudeDelta = spanLongitude;
    [m_MapView setRegion:region animated:YES];
}

-(void)ShowAnnotation:(int)nID
{
    [m_MapView removeAnnotations:m_MapView.annotations];
    int nCount = [m_MapAnnotationList count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            MapUIAnnotation* pAnnotation = (MapUIAnnotation*)[m_MapAnnotationList objectAtIndex:i];
            if(pAnnotation.m_nAnnotionID == nID)
            {
                [m_MapView addAnnotation:pAnnotation];
                MKCoordinateRegion region;
                region.center.latitude = pAnnotation.m_fLatitude;
                region.center.longitude = pAnnotation.m_fLongitude;
                region.span.latitudeDelta = [GUILayout GetDefaultMapLatitudeSpan];
                region.span.longitudeDelta = [GUILayout GetDefaultMapLongitudeSpan];
                [m_MapView setRegion:region animated:YES];
                break;
            }
        }
    }
}

-(void)ShowAllAnnotation
{
    [m_MapView removeAnnotations:m_MapView.annotations];
    [m_MapView addAnnotations:m_MapAnnotationList];
    [self ShowAllLocations];
}

-(void)DisplayStandardMap
{
    m_MapView.mapType = MKMapTypeStandard; 
    
    //Refresh map view
    MKCoordinateRegion region = m_MapView.region;
    [m_MapView setRegion:region animated:YES];
}

-(void)DisplaySatelliteMap
{
    m_MapView.mapType = MKMapTypeSatellite; 
    
    //Refresh map view
    MKCoordinateRegion region = m_MapView.region;
    [m_MapView setRegion:region animated:YES];
}

-(void)DisplayHybridMap
{
    m_MapView.mapType = MKMapTypeHybrid; 
    
    //Refresh map view
    MKCoordinateRegion region = m_MapView.region;
    [m_MapView setRegion:region animated:YES];
}

-(int)GetMKAnnotationCount
{
    int nRet = [m_MapAnnotationList count];
    return nRet;
}

#pragma mark -
#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MapUIAnnotation class]]) 
    {
        //Dequeue an existing pin view first
        NSString* AnnotationPinViewIdentifier = [NSString stringWithFormat:@"AnnotationPinViewIdentifier%i", ((MapUIAnnotation*)annotation).m_nAnnotionID];
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [m_MapView dequeueReusableAnnotationViewWithIdentifier:AnnotationPinViewIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:AnnotationPinViewIdentifier] autorelease];
            if(((MapUIAnnotation*)annotation).m_bMaster)
                customPinView.pinColor = MKPinAnnotationColorRed;
            else 
                customPinView.pinColor = MKPinAnnotationColorGreen;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            if(((MapUIAnnotation*)annotation).m_Icon)
            {
                UIImageView *iconView = [[UIImageView alloc] initWithImage:[((MapUIAnnotation*)annotation).m_Icon retain]];
                customPinView.leftCalloutAccessoryView = iconView;
                [iconView release];
            }
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

@end
