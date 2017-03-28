//
//  NOMReadUICore.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMReadUICore.h"
#import "NOMAppInfo.h"
#import "StringFactory.h"
#import "NonTouchableImageView.h"
#import "NOMMapConstants.h"
#import "NOMPlanAnnotation.h"
#import "NOMAppInfo.h"
#import "StringFactory.h"
#import "NOMGEOPlanAnnotationView.h"
#import "NOMGEOPlanLine.h"
#import "NOMGEOPlanRouteLineSegment.h"
#import "NOMGEOPlanPolygon.h"
#import "NOMGEOPlanRect.h"
#import "KML.h"
#import "NOMReferenceAnnotation.h"
#import "NOMQueryLocationPin.h"
#import "NOMTimeHelper.h"
#import "NOMS3DataDownloader.h"
#import "NOMFileManager.h"
#import "NOMNewsServiceHelper.h"
#import "NOMSystemConstants.h"

@interface NOMReadUICore ()
{
    UITextField*                m_SubjectEdit;
    UITextView*                 m_PostEdit;
   
    UITextField*                m_AuthorEdit;
    UILabel*                    m_AuthorLabel;
    
//!!!    MKMapView*                  m_MapView;
    NonTouchableImageView*      m_ImagePreview;
    
    UITextField*                m_KeywordEdit;
    UITextField*                m_CopyrightEdit;
    UITextField*                m_EventTimeBox;

    NOMReferenceAnnotation*     m_ReferencePin;
    
    NSURL*                      m_ImageFileURL;
    NOMS3DataDownloader*        m_ImageDownloader;
    NOMFileManager*             m_FileManager;
}

@end

@implementation NOMReadUICore

+(float)GetDefaultEdge
{
    if([NOMAppInfo IsDeviceIPad])
        return 25;
    else
        return 15;
}

+(float)GetDefaultTextHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 70;
    else
        return 40;
}

+(double)GetDefaultLabelWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 120;
    else
        return 80;
}

+(float)GetDefaultLabelHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 40;
    else
        return 20;
}

+(float)GetDefaultReadingViewHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 320;
    else
    {
        return 480;
    }
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

-(void)InitializeSubViews
{
    float textHeight = [NOMReadUICore GetDefaultTextHeight];
    float edge = [NOMReadUICore GetDefaultEdge];
    
    float textWidth = self.frame.size.width-2.0*edge;
    float labelWidth = [NOMReadUICore GetDefaultLabelWidth];
    float labelHeight = [NOMReadUICore GetDefaultLabelHeight];
    
    float sx = edge;
    float sy = edge;

    float lsx = edge;
    float lsy = sy + (textHeight-labelHeight)/2.0;
    
    
    CGRect rect = CGRectMake(sx, sy, textWidth, textHeight);
    m_SubjectEdit = [[UITextField alloc] initWithFrame:rect];
    m_SubjectEdit.borderStyle = UITextBorderStyleRoundedRect;
    m_SubjectEdit.textColor = [UIColor blackColor];
    m_SubjectEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_SubjectEdit.placeholder = [NSString stringWithFormat:@"<%@>", [StringFactory GetString_SubjectLabel]];
    m_SubjectEdit.backgroundColor = [UIColor whiteColor];
    m_SubjectEdit.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_SubjectEdit.keyboardType = UIKeyboardTypeDefault;
    m_SubjectEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_SubjectEdit.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    //m_SubjectEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_SubjectEdit.delegate = self;
    m_SubjectEdit.enabled = NO;
    [self addSubview:m_SubjectEdit];
    
    
    sy += (edge + textHeight);
    lsy = sy + (textHeight-labelHeight)/2.0;

    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    m_AuthorLabel = [[UILabel alloc] initWithFrame:rect];
    m_AuthorLabel.backgroundColor = [UIColor clearColor];
    [m_AuthorLabel setTextColor:[UIColor whiteColor]];
    m_AuthorLabel.highlightedTextColor = [UIColor grayColor];
    [m_AuthorLabel setTextAlignment:NSTextAlignmentRight];
    m_AuthorLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_AuthorLabel.adjustsFontSizeToFitWidth = YES;
    m_AuthorLabel.font = [UIFont systemFontOfSize:labelHeight*0.8];
    NSString* strLabel = [NSString stringWithFormat:@"%@:", [StringFactory GetString_Author]];
    [m_AuthorLabel setText:strLabel];
    [self addSubview:m_AuthorLabel];
   
    sx = edge+labelWidth;
    rect = CGRectMake(sx, sy, textWidth-labelWidth, textHeight);
    m_AuthorEdit = [[UITextField alloc] initWithFrame:rect];
    m_AuthorEdit.borderStyle = UITextBorderStyleRoundedRect;
    m_AuthorEdit.textColor = [UIColor blackColor];
    m_AuthorEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_AuthorEdit.backgroundColor = [UIColor whiteColor];
    m_AuthorEdit.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_AuthorEdit.keyboardType = UIKeyboardTypeDefault;
    m_AuthorEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_AuthorEdit.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    //m_AuthorEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_AuthorEdit.delegate = self;
    m_AuthorEdit.enabled = NO;
    [self addSubview:m_AuthorEdit];
    
    
    sx = edge;
    sy += (edge + textHeight);
    float height = [NOMReadUICore GetDefaultReadingViewHeight];
    rect = CGRectMake(sx, sy, textWidth, height);
    m_PostEdit = [[UITextView alloc] initWithFrame:rect];
    [m_PostEdit setAutocorrectionType:UITextAutocorrectionTypeNo];
    [m_PostEdit setEditable:YES];
    m_PostEdit.scrollEnabled = YES;
    m_PostEdit.backgroundColor = [UIColor whiteColor];
    m_PostEdit.textColor = [UIColor blackColor];
    m_PostEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_PostEdit.editable = NO;
    m_PostEdit.delegate = self;
    [self addSubview:m_PostEdit];
    
    sy += (edge + height);
    rect = CGRectMake(sx, sy, textWidth, textWidth);
    m_ImagePreview = [[NonTouchableImageView alloc] initWithFrame:rect];
    m_ImagePreview.backgroundColor = [UIColor clearColor];
    m_ImagePreview.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:m_ImagePreview];
/*
    sy += (edge + textWidth);
    rect = CGRectMake(sx, sy, textWidth, textWidth);
    m_MapView = [[MKMapView alloc] initWithFrame:rect];
    m_MapView.delegate = self;
    m_MapView.mapType = MKMapTypeStandard;
    [self addSubview:m_MapView];
*/
    sy += (edge + textWidth);
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    m_KeywordEdit = [[UITextField alloc] initWithFrame:rect];
    m_KeywordEdit.borderStyle = UITextBorderStyleRoundedRect;
    m_KeywordEdit.textColor = [UIColor blackColor];
    m_KeywordEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_KeywordEdit.placeholder = [NSString stringWithFormat:@"<%@>", [StringFactory GetString_KeywordLabel]];
    m_KeywordEdit.backgroundColor = [UIColor whiteColor];
    m_KeywordEdit.enabled = NO;
    m_KeywordEdit.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_KeywordEdit.keyboardType = UIKeyboardTypeDefault;
    m_KeywordEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_KeywordEdit.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_KeywordEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_KeywordEdit.delegate = self;
    [self addSubview:m_KeywordEdit];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    m_CopyrightEdit = [[UITextField alloc] initWithFrame:rect];
    m_CopyrightEdit.borderStyle = UITextBorderStyleRoundedRect;
    m_CopyrightEdit.textColor = [UIColor blackColor];
    m_CopyrightEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_CopyrightEdit.placeholder = [NSString stringWithFormat:@"<%@>", [StringFactory GetString_CopyrightLabel]];
    m_CopyrightEdit.backgroundColor = [UIColor whiteColor];
    m_CopyrightEdit.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_CopyrightEdit.keyboardType = UIKeyboardTypeDefault;
    m_CopyrightEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_CopyrightEdit.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_CopyrightEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_CopyrightEdit.delegate = self;
    m_CopyrightEdit.enabled = NO;
    [self addSubview:m_CopyrightEdit];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    m_EventTimeBox = [[UITextField alloc] initWithFrame:rect];
    m_EventTimeBox.borderStyle = UITextBorderStyleRoundedRect;
    m_EventTimeBox.textColor = [UIColor blackColor];
    m_EventTimeBox.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_EventTimeBox.placeholder = [NSString stringWithFormat:@"<%@>", [StringFactory GetString_Time]];
    m_EventTimeBox.backgroundColor = [UIColor whiteColor];
    m_EventTimeBox.enabled = NO;
    m_EventTimeBox.adjustsFontSizeToFitWidth = YES;
    [self addSubview:m_EventTimeBox];
   
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_ReferencePin = [[NOMReferenceAnnotation alloc] init];
        [self InitializeSubViews];
        m_ImageFileURL = nil;
        m_ImageDownloader = nil;
        m_FileManager = [[NOMFileManager alloc] initNoneOperationFileManager];
        [m_FileManager AssignDelegate:self];
    }
    return self;
}

-(void)CleanControlState
{
    [m_SubjectEdit setText:@""];
    [m_PostEdit setText:@""];
    
    [m_AuthorEdit setText:@""];
    [m_ImagePreview setImage:nil];
    
    [m_KeywordEdit setText:@""];
    [m_CopyrightEdit setText:@""];
    [m_EventTimeBox setText:@""];
    
    m_ImageFileURL = nil;
    m_ImageDownloader = nil;
    [self UpdateLayout];
/*
    NSArray *overlays = [m_MapView overlays];
    if(overlays != nil && 0 < overlays.count)
    {
        [m_MapView removeOverlays:overlays];
    }
    
    NSArray *annotations = [m_MapView annotations];
    if(annotations != nil && 0 < annotations.count)
    {
        [m_MapView removeAnnotations:annotations];
    }
*/
}

-(void)UpdateLayout
{
    float textHeight = [NOMReadUICore GetDefaultTextHeight];
    float edge = [NOMReadUICore GetDefaultEdge];
    
    float textWidth = self.frame.size.width-2.0*edge;
    float labelWidth = [NOMReadUICore GetDefaultLabelWidth];
    float labelHeight = [NOMReadUICore GetDefaultLabelHeight];
    
    float sx = edge;
    float sy = edge;

    float lsx = edge;
    float lsy = sy + (textHeight-labelHeight)/2.0;
    
    CGRect rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_SubjectEdit setFrame:rect];
    
    sy += (edge + textHeight);
    lsy = sy + (textHeight-labelHeight)/2.0;
    
    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    [m_AuthorLabel setFrame:rect];
    
    sx = edge+labelWidth;
    rect = CGRectMake(sx, sy, textWidth-labelWidth, textHeight);
    [m_AuthorEdit setFrame:rect];
    
    sx = edge;
    sy += (edge + textHeight);
    float height = [NOMReadUICore GetDefaultReadingViewHeight];
    rect = CGRectMake(sx, sy, textWidth, height);
    [m_PostEdit setFrame:rect];
    
    if([m_ImagePreview image] != nil)
    {
        sy += (edge + height);
        rect = CGRectMake(sx, sy, textWidth, textWidth);
        [m_ImagePreview setFrame:rect];
        sy += (edge + textWidth);
    }
    else
    {
        sy += (edge + height);
    }
/*
    sy += (edge + textWidth);
    rect = CGRectMake(sx, sy, textWidth, textWidth);
    [m_MapView setFrame:rect];
*/
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_KeywordEdit setFrame:rect];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_CopyrightEdit setFrame:rect];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_EventTimeBox setFrame:rect];
}

-(double)GetZoomFactor
{
/*    CLLocationDegrees longitudeDelta = m_MapView.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomer < 0.0 )
        zoomer = 0.0;
    return zoomer;
*/
    
    return 1.0;
}

-(void)RedrawMapElements
{
/*
    NSArray *annotations = [m_MapView annotations];
    if(annotations != nil && 0 < annotations.count)
    {
        for(int i = 0; i < annotations.count; ++i)
        {
            MKAnnotationView* pPin = [m_MapView  viewForAnnotation:[annotations objectAtIndex:i]];
            if(pPin != nil)
            {
                if([pPin isKindOfClass:[NOMQueryLocationPin class]] == YES)
                {
                    [((NOMQueryLocationPin*)pPin) UpdateZoomSize];
                }
                else
                {
                    [pPin setNeedsDisplay];
                }
            }
        }
    }
*/
}

/*
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self RedrawMapElements];
}
*/

+(CGFloat)GetGEOPlanPinSize
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 40;
}

/*
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[NOMPlanAnnotation class]])
    {
        int nID = [((NOMPlanAnnotation *)annotation) GetID];
        NSString *JustPlanMarkerAnnotationIdentifier = [NSString stringWithFormat:@"JustPlanMarkerAnnotationIdentifier_%i", nID];
        
        NOMGEOPlanAnnotationView *pinView = (NOMGEOPlanAnnotationView *)[m_MapView dequeueReusableAnnotationViewWithIdentifier:JustPlanMarkerAnnotationIdentifier];
        if (pinView == nil)
        {
            CGSize size = CGSizeMake([NOMReadUICore GetGEOPlanPinSize], [NOMReadUICore GetGEOPlanPinSize]);
            
            // if an existing pin view was not available, create one
            NOMGEOPlanAnnotationView *customPinView = [[NOMGEOPlanAnnotationView alloc]
                                                       initWithAnnotation:annotation
                                                       reuseIdentifier:JustPlanMarkerAnnotationIdentifier
                                                       withSize:size
                                                       withParent:self];
            [customPinView SetZoomThreshold:0.1 maxZoom:1.0];
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
        static NSString *PinAnnotationIdentifier = @"PostViewReferencePintAnnotationIdentifier";
        
        NOMQueryLocationPin *pinView =
        (NOMQueryLocationPin *) [m_MapView dequeueReusableAnnotationViewWithIdentifier:PinAnnotationIdentifier];
        if (pinView == nil)
        {
            
            CGSize size = CGSizeMake([NOMReadUICore GetQueryPinWidth], [NOMReadUICore GetQueryPinHeight]);
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
*/

-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span
{
/*    if(m_ReferencePin != nil)
    {
        [m_ReferencePin SetCoordinate:dLong withLatitude:dLat];
        [m_MapView addAnnotation:m_ReferencePin];
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(m_MapView.visibleMapRect);
        region.center.latitude = dLat;
        region.center.longitude = dLong;
        region.span.latitudeDelta = Span;
        region.span.longitudeDelta = Span;
        [m_MapView setRegion:region animated:YES];
    }*/
}

/*
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
*/

-(float)GetReadViewHeight
{
    float textHeight = [NOMReadUICore GetDefaultTextHeight];
    float edge = [NOMReadUICore GetDefaultEdge];
    float textWidth = self.frame.size.width-2.0*edge;
    
    if(self.superview != nil)
    {
        if(self.superview.frame.size.height < self.superview.frame.size.width)
        {
            textWidth = self.superview.frame.size.width-4.0*edge;
        }
    }
    
    float h = [NOMReadUICore GetDefaultReadingViewHeight];
    
    float fRet = textHeight*6 + edge*12 + textWidth*2 + h;
    
    return fRet;
}

-(void)OpenView
{
    
}

-(void)SetSubject:(NSString*)szTitle
{
    if(szTitle != nil && 0 < szTitle.length)
        [m_SubjectEdit setText:szTitle];
}

-(void)SetAuthor:(NSString*)szAuthor
{
    if(szAuthor != nil && 0 < szAuthor.length)
        [m_AuthorEdit setText:szAuthor];
}

-(void)SetPost:(NSString*)szPost
{
    if(szPost != nil && 0 < szPost.length)
        [m_PostEdit setText:szPost];
}

-(void)SetKeywords:(NSString*)szKeywords
{
    if(szKeywords != nil && 0 < szKeywords.length)
        [m_KeywordEdit setText:szKeywords];
}

-(void)SetCopyright:(NSString*)szCopyright
{
    if(szCopyright != nil && 0 < szCopyright.length)
        [m_CopyrightEdit setText:szCopyright];
}

-(void)SetGeographicKML:(NSString*)szKML
{
/*
    KMLRoot* kmlObject = [KMLParser parseKMLWithString:szKML];
    if(kmlObject != nil)
    {
        KMLDocument *kmlDocument = (KMLDocument*)kmlObject.feature;
        if(kmlDocument != nil && kmlDocument.name != nil && 0 < kmlDocument.name.length)
        {
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
*/
}

-(void)SetImage:(UIImage*)image
{
    if(image != nil)
    {
        [m_ImagePreview setImage:image];
    }
}

-(void)SetImageFromURL:(NSString*)imageURL
{
    if(imageURL != nil && 0 < imageURL.length)
    {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        [m_ImagePreview setImage:[UIImage imageWithData:data]];
    }
}

-(void)SetPostTime:(int64_t)nTime
{
    NSDate* time = [NOMTimeHelper ConertIntegerToNSDate:nTime];
    if(time != nil)
    {
        [m_EventTimeBox setText:[time description]];
    }
}

-(void)SetReferenceInfo:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType
{
    if(m_ReferencePin != nil)
    {
        [m_ReferencePin SetNewsDataMainType:nMainCate withSubType:nSubCate withThirdType:nThirdType];
        [m_ReferencePin SetTwitterTweet:NO];
    }
}

-(void)DownloadImageResource:(NSString*)newsImageURL
{
    if(newsImageURL != nil && 0 < [newsImageURL length] && m_ImageFileURL != nil)
    {
        if(m_ImageDownloader == nil)
            m_ImageDownloader = [[NOMS3DataDownloader alloc] init];
        
        NSString* s3Bucket = [NOMNewsServiceHelper GetNewsResourceS3Bucket];
        
        [m_ImageDownloader AssignDelegate:self];
        [m_ImageDownloader SetSource:NOM_NEWSIMAGE_CONTENTTYPE withS3Bucket:s3Bucket withS3Key:newsImageURL withDestination:m_ImageFileURL];
        [m_ImageDownloader Start];
    }
}

-(void)HandleImageResource:(NSString*)newsImageURL withIDKey:(NSString*)pNewsID
{
    if(newsImageURL != nil && 0 < [newsImageURL length])
    {
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg", pNewsID];
        m_ImageFileURL = [NOMFileManager GetFilePath:fileName];
        if(m_ImageFileURL != nil)
        {
            if([m_FileManager FileExistByURL:m_ImageFileURL] == YES)
            {
                [m_FileManager LoadFile:m_ImageFileURL];
            }
            else
            {
                [self DownloadImageResource:newsImageURL];
            }
        }
    }
    else
    {
        m_ImageFileURL = nil;
        m_ImageDownloader = nil;
        [m_ImagePreview setImage:nil];
        [self UpdateLayout];
    }
}

-(void)SetNewsData:(NOMNewsMetaDataRecord*)pNews
{
    [self SetSubject:pNews.m_NewsTitleSource];
    [self SetAuthor:pNews.m_NewsPosterDisplayName];
    [self SetPost:pNews.m_NewsBodySource];
    [self SetKeywords:pNews.m_NewsKeywordSource];
    [self SetCopyright:pNews.m_NewsCopyRightSource];
    //!!![self SetGeographicKML:pNews.m_NewsKMLSource];
    //[self SetImageFromURL:pNews.m_NewsImageURL];
    [self HandleImageResource:pNews.m_NewsImageURL withIDKey:pNews.m_NewsID];
    [self SetPostTime:pNews.m_nNewsTime];
    [self SetReferenceInfo:pNews.m_NewsMainCategory withSubType:pNews.m_NewsSubCategory withThirdType:pNews.m_NewsThirdCategory];
}

////////////////////////////////////////////////////////////////////////
//
// INOMS3DataDownloaderDelegate method
//
////////////////////////////////////////////////////////////////////////
-(void)NOMS3DataDownloadDone:(id)dataDownloader withResult:(BOOL)bSucceed
{
    if(bSucceed == YES && [dataDownloader isKindOfClass:[NOMS3DataDownloader class]])
    {
        if([m_FileManager FileExistByURL:m_ImageFileURL] == YES)
        {
            [m_FileManager LoadFile:m_ImageFileURL];
        }
    }
    [self UpdateLayout];
}
////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////
//
// NOMFileManagerDelegate methods
//
////////////////////////////////////////////////////////////////////////
-(void)NOMFileSaveDone:(BOOL)bSucceed forFile:(NSURL*)fileURL
{
    
}

-(void)NOMFileLoadDone:(NSData*)data forFile:(NSURL*)fileURL
{
    if(data != nil)
    {
        UIImage* image = [UIImage imageWithData:data];
        if(image != nil)
        {
            [m_ImagePreview setImage:image];
            [self UpdateLayout];
        }
    }
}

-(void)NOMJsonFileLoadDone:(NSData*)data forFile:(NSURL*)fileURL
{
    
}

-(void)NOMImageFileLoadDone:(NSData*)data forFile:(NSURL*)fileURL
{
    if(data != nil)
    {
        UIImage* image = [UIImage imageWithData:data];
        if(image != nil)
        {
            [m_ImagePreview setImage:image];
            [self UpdateLayout];
        }
    }
}

-(void)NOMFileLoadFailed
{
    m_ImageFileURL = nil;
    m_ImageDownloader = nil;
    [m_ImagePreview setImage:nil];
    [self UpdateLayout];
}
////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////

@end
