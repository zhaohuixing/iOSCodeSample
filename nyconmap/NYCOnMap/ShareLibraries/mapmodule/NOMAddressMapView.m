//
//  AddressMapView.m
//  newsonmap
//
//  Created by Zhaohui Xing on 27/6/13.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "NOMAddressMapView.h"
#import "NOMAppInfo.h"
#import "NOMGUILayout.h"
#import "NOMGEOConfigration.h"

#import "NOMAddressMapAnnotation.h"

@interface NOMAddressMapView ()
{
    UIButton*                   m_StandardBtn;
    UIButton*                   m_SatelliteBtn;
    UIButton*                   m_HybirdBtn;
    
    UIButton*                   m_OKBtn;
    MKMapView*                  m_MapView;
    
    BOOL                        m_bPinLocation;
    CLLocationCoordinate2D      m_PinLocation;
    
    
    NOMAddressMapAnnotation*    m_Annotation;
}

@end

@implementation NOMAddressMapView

-(double)GetDefaultEdge
{
    if([NOMAppInfo IsDeviceIPad])
        return 20;
    else
        return 10;
}

-(double)GetDefaultBasicUISize
{
    if([NOMAppInfo IsDeviceIPad])
        return 90;
    else
        return 50;
}

-(void)SetMapType:(MKMapType)type
{
    m_MapView.mapType = type;
    MKCoordinateRegion region = m_MapView.region;
    [m_MapView setRegion:region animated:YES];
}

-(void)OnStandardMapTypeButtonClick
{
    [self SetMapType:MKMapTypeStandard];
}

-(void)OnSatelliteMapTypeButtonClick
{
    [self SetMapType:MKMapTypeSatellite];
}

-(void)OnHybirdMapTypeButtonClick
{
    [self SetMapType:MKMapTypeHybrid];
}

-(void)OnOKButtonClick
{
    [self CloseView:YES];
}

-(void)InitializeSubViews
{
    float fSize = [self GetDefaultBasicUISize];
    float edge = [self GetDefaultEdge];
    
    float sx = edge;
    float sy = edge;
    
    float fHeight = self.frame.size.height - fSize - 3*edge;
    float fWidth = self.frame.size.width - 2*edge;
    CGRect rect = CGRectMake(sx, sy, fWidth, fHeight);
    m_MapView = [[MKMapView alloc] initWithFrame:rect];
    m_MapView.delegate = self;
    m_MapView.mapType = MKMapTypeStandard;
    [self addSubview:m_MapView];

    sy += fHeight + edge;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_StandardBtn = [[UIButton alloc] initWithFrame:rect];
    m_StandardBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_StandardBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_StandardBtn addTarget:self action:@selector(OnStandardMapTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_StandardBtn setBackgroundImage:[UIImage imageNamed:@"std200.png"] forState:UIControlStateNormal];
    [self addSubview:m_StandardBtn];
    
    sx += fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_SatelliteBtn = [[UIButton alloc] initWithFrame:rect];
    m_SatelliteBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_SatelliteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_SatelliteBtn addTarget:self action:@selector(OnSatelliteMapTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_SatelliteBtn setBackgroundImage:[UIImage imageNamed:@"satellite200.png"] forState:UIControlStateNormal];
    [self addSubview:m_SatelliteBtn];
    
    sx += fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_HybirdBtn = [[UIButton alloc] initWithFrame:rect];
    m_HybirdBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_HybirdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_HybirdBtn addTarget:self action:@selector(OnHybirdMapTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_HybirdBtn setBackgroundImage:[UIImage imageNamed:@"hybird200.png"] forState:UIControlStateNormal];
    [self addSubview:m_HybirdBtn];
    
    sx = self.frame.size.width - fSize - edge;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_OKBtn = [[UIButton alloc] initWithFrame:rect];
    m_OKBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OKBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_OKBtn addTarget:self action:@selector(OnOKButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OKBtn setBackgroundImage:[UIImage imageNamed:@"ok200.png"] forState:UIControlStateNormal];
    [self addSubview:m_OKBtn];

    m_Annotation = [[NOMAddressMapAnnotation alloc] init];
    
    [self UpdateLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_StandardBtn = nil;
        m_SatelliteBtn = nil;
        m_HybirdBtn = nil;
        m_OKBtn = nil;
        m_MapView = nil;
        m_Annotation = nil;
        
        self.backgroundColor = [UIColor darkGrayColor];
        [self InitializeSubViews];
        m_bPinLocation = NO;
    }
    return self;
}

-(void)OnViewClose
{
    m_bPinLocation = NO;
    if(m_MapView != nil)
    {
        [m_MapView removeAnnotation:m_Annotation];
    }
	self.hidden = YES;
	[self setAlpha:1.0];
	[[self superview] sendSubviewToBack:self];
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

-(void)PinLocation
{
    [m_MapView addAnnotation:m_Annotation];
}

-(void)SetLocation:(CLLocationCoordinate2D)location
{
    m_bPinLocation = YES;
    m_PinLocation = location;
    [m_Annotation SetCoordinate:location];
    if(self.hidden == NO)
    {
        [self PinLocation];
    }
}

-(void)OnViewOpen
{
    if(m_bPinLocation == YES && m_MapView != nil)
    {
        //Refresh map view
        MKCoordinateRegion region = m_MapView.region;
 
        double w = [NOMGEOConfigration GetQueryGEOSpanLimit]/2.0;
        double h = m_MapView.frame.size.height*w/m_MapView.frame.size.width;
        
        region.span.longitudeDelta = [NOMGEOConfigration LongitudeDifferenceByDistance:w alongLantitude:m_PinLocation.latitude];
        region.span.latitudeDelta = [NOMGEOConfigration LantitudeDifferenceByDistance:h];
        
        region.center = m_PinLocation;
      
        [m_MapView setRegion:region animated:YES];
        [self PinLocation];
    }
}

-(void)OpenView:(BOOL)bAnimation
{
    [self SetMapType:MKMapTypeStandard];
	self.hidden = NO;
	[[self superview] bringSubviewToFront:self];
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

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[NOMAddressMapAnnotation class]])
    {
        static NSString *PinAnnotationIdentifier = @"AddressInputMapViewAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [m_MapView dequeueReusableAnnotationViewWithIdentifier:PinAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:PinAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
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

-(void)UpdateHorizontalLayout
{
    float fSize = [self GetDefaultBasicUISize];
    float edge = [self GetDefaultEdge];
    
    float sx = edge;
    float sy = edge;
    
    float fWidth = self.frame.size.width - fSize - 3*edge;
    float fHeight = self.frame.size.height - 2*edge;
    CGRect rect = CGRectMake(sx, sy, fWidth, fHeight);
    if(m_MapView != nil)
        [m_MapView setFrame:rect];
    
    sx += fWidth + edge;
    rect = CGRectMake(sx, sy, fSize, fSize);
    if(m_StandardBtn != nil)
        [m_StandardBtn setFrame:rect];
    
    sy += fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    if(m_SatelliteBtn != nil)
        [m_SatelliteBtn setFrame:rect];
    
    sy += fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    if(m_HybirdBtn != nil)
        [m_HybirdBtn setFrame:rect];
    
    sy = self.frame.size.width - fSize - edge;
    rect = CGRectMake(sx, sy, fSize, fSize);
    if(m_OKBtn != nil)
        [m_OKBtn setFrame:rect];
}


-(void)UpdateVerticalLayout
{
    float fSize = [self GetDefaultBasicUISize];
    float edge = [self GetDefaultEdge];
    
    float sx = edge;
    float sy = edge;
    
    float fHeight = self.frame.size.height - fSize - 3*edge;
    float fWidth = self.frame.size.width - 2*edge;
    CGRect rect = CGRectMake(sx, sy, fWidth, fHeight);
    if(m_MapView != nil)
        [m_MapView setFrame:rect];
    
    sy += fHeight + edge;
    rect = CGRectMake(sx, sy, fSize, fSize);
    if(m_StandardBtn != nil)
        [m_StandardBtn setFrame:rect];
    
    sx += fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    if(m_SatelliteBtn != nil)
        [m_SatelliteBtn setFrame:rect];
    
    sx += fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    if(m_HybirdBtn != nil)
        [m_HybirdBtn setFrame:rect];
    
    sx = self.frame.size.width - fSize - edge;
    rect = CGRectMake(sx, sy, fSize, fSize);
    if(m_OKBtn != nil)
        [m_OKBtn setFrame:rect];
}


-(void)UpdateLayout
{
    if(self.frame.size.width < self.frame.size.height)
    {
        [self UpdateVerticalLayout];
    }
    else
    {
        [self UpdateHorizontalLayout];
    }
}

@end
