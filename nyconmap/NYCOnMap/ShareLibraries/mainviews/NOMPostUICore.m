//
//  NOMPostUICore.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMPostUICore.h"
#import "NOMMapConstants.h"
#import "NOMPlanAnnotation.h"
#import "NOMAppInfo.h"
#import "StringFactory.h"
#import "NonTouchableImageView.h"
#import "NOMGEOPlanAnnotationView.h"
#import "NOMGEOPlanLine.h"
#import "NOMGEOPlanRouteLineSegment.h"
#import "NOMGEOPlanPolygon.h"
#import "NOMGEOPlanRect.h"
#import "NOMAppInfo.h"
#import "KML.h"
#import "NOMReferenceAnnotation.h"
#import "NOMQueryLocationPin.h"

#define NOM_SUBJECTEDIT_TAG                 0
#define NOM_POSTEDIT_TAG                    1
#define NOM_KEYWORDSEDIT_TAG                2
#define NOM_COPYRIGHTEDIT_TAG               3

@interface NOMPostUICore ()
{
    UITextField*                m_SubjectEdit;
    UITextView*                 m_PostEdit;
    UIButton*                   m_AddMapElementButton;
//    UIButton*                   m_StandardBtn;
//    UIButton*                   m_SatelliteBtn;
//    UIButton*                   m_HybirdBtn;
//    MKMapView*                  m_MapView;
    UIButton*                   m_PhotoButton;
    UIButton*                   m_DeletePhotoButton;
    NonTouchableImageView*      m_ImagePreview;
    
    UITextField*                m_KeywordEdit;
    UITextField*                m_CopyrightEdit;
    UITextField*                m_EventTimeBox;
    UIButton*                   m_EventTimeButton;

    NSString*                   m_CachedKML;
    
    //MKPolyline*                 m_AppRegionOverlay;
    NOMReferenceAnnotation*     m_ReferencePin;
    
    UIImage*                     m_PostImage;
}
@end

@implementation NOMPostUICore

+(float)GetDefaultEdge
{
    if([NOMAppInfo IsDeviceIPad])
        return 20;
    else
        return 10;
}

+ (float)GetButtonWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 90;
    else
        return 60;
}

+ (float)GetButtonHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 40;
}

+(float)GetDefaultTextHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 70;
    else
        return 40;
}

+(float)GetDefaultLabelHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 40;
    else
        return 20;
}

+(float)GetDefaultLabelWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 120;
    else
        return 80;
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

-(float)GetDefaultPostViewHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 400;
    else
    {
        if(self.superview != nil)
        {
            if(self.superview.frame.size.width < self.superview.frame.size.height)
            {
                float labelHeight = [NOMPostUICore GetDefaultTextHeight];
                float edge = [NOMPostUICore GetDefaultEdge];
                float fRet = self.superview.frame.size.height - 216- edge*2 - labelHeight;
                return fRet;
            }
            else
            {
                float fRet = self.superview.frame.size.height - 216;
                return fRet;
            }
        }
        else
        {
            if(self.frame.size.width < self.frame.size.height)
            {
                float labelHeight = [NOMPostUICore GetDefaultTextHeight];
                float edge = [NOMPostUICore GetDefaultEdge];
                float fRet = self.frame.size.height - 216- edge*2 - labelHeight;
                return fRet;
            }
            else
            {
                float fRet = self.frame.size.height - 216;
                return fRet;
            }
        }
    }
}

-(void)OnStandardMapTypeButtonClick
{
    [self HideKeyboard];
//    m_MapView.mapType = MKMapTypeStandard;
}

-(void)OnSatelliteMapTypeButtonClick
{
    [self HideKeyboard];
//    m_MapView.mapType = MKMapTypeSatellite;
}

-(void)OnHybirdMapTypeButtonClick
{
    [self HideKeyboard];
//    m_MapView.mapType = MKMapTypeHybrid;
}

-(void)OnAddPhotoClick
{
    [self HideKeyboard];
    [NOMAppInfo SetCurrentImageResourceReceiver:self];
    id<IImageSelectorDelegate> imageSelector = [NOMAppInfo GetImageResourceSelector];
    if(imageSelector != nil)
    {
        [imageSelector SelectPicture];
    }
}

-(void)OnDeletePhotoClick
{
    m_PostImage = nil;
    [self HideKeyboard];
    [m_ImagePreview setImage:nil];
    [NOMAppInfo SetCurrentImageResourceReceiver:nil];
    
    if(m_ImagePreview.image == nil)
        m_DeletePhotoButton.hidden = YES;
    else
        m_DeletePhotoButton.hidden = NO;
}

-(void)OnAddTimeClick
{
    [self HideKeyboard];
}

-(void)InitializeSubViews
{
    float textHeight = [NOMPostUICore GetDefaultTextHeight];
    float edge = [NOMPostUICore GetDefaultEdge];
    
    float textWidth = self.frame.size.width-2.0*edge;
    
    float sx = edge;
    float sy = edge;
    
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
    m_SubjectEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_SubjectEdit.delegate = self;
    m_SubjectEdit.tag = NOM_SUBJECTEDIT_TAG;
    [self addSubview:m_SubjectEdit];
    
 
    sy += (edge + textHeight);
    float height = [self GetDefaultPostViewHeight];
    rect = CGRectMake(sx, sy, textWidth, height);
    m_PostEdit = [[UITextView alloc] initWithFrame:rect];
    [m_PostEdit setAutocorrectionType:UITextAutocorrectionTypeNo];
    [m_PostEdit setEditable:YES];
    m_PostEdit.scrollEnabled = YES;
    m_PostEdit.backgroundColor = [UIColor whiteColor];
    m_PostEdit.textColor = [UIColor blackColor];
    m_PostEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_PostEdit.delegate = self;
    m_PostEdit.tag = NOM_POSTEDIT_TAG;
    //m_PostEdit.placeholder = [NSString stringWithFormat:@"<%@>", [StringFactory GetString_Post]];
    [self addSubview:m_PostEdit];

    sy += (edge + height);
    rect = CGRectMake(sx, sy, (textWidth - edge)/2.0, textHeight);
    m_PhotoButton = [[UIButton alloc] initWithFrame:rect];
    m_PhotoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_PhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_PhotoButton addTarget:self action:@selector(OnAddPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    m_PhotoButton.backgroundColor = [UIColor colorWithRed:0.5 green:1.0 blue:0.5 alpha:1.0];
    [m_PhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_PhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [m_PhotoButton setTitle:[StringFactory GetString_Photo] forState:UIControlStateNormal];
    m_PhotoButton.reversesTitleShadowWhenHighlighted = YES;
    m_PhotoButton.titleLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [self addSubview:m_PhotoButton];
    
    rect = CGRectMake(sx + (textWidth + edge)/2.0, sy, (textWidth - edge)/2.0, textHeight);
    m_DeletePhotoButton = [[UIButton alloc] initWithFrame:rect];
    m_DeletePhotoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_DeletePhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_DeletePhotoButton addTarget:self action:@selector(OnDeletePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    m_DeletePhotoButton.backgroundColor = [UIColor colorWithRed:0.5 green:1.0 blue:0.5 alpha:1.0];
    [m_DeletePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_DeletePhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [m_DeletePhotoButton setTitle:[StringFactory GetString_DeletePhoto] forState:UIControlStateNormal];
    m_DeletePhotoButton.reversesTitleShadowWhenHighlighted = YES;
    m_DeletePhotoButton.titleLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [self addSubview:m_DeletePhotoButton];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textWidth);
    m_ImagePreview = [[NonTouchableImageView alloc] initWithFrame:rect];
    m_ImagePreview.backgroundColor = [UIColor blackColor];
    m_ImagePreview.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:m_ImagePreview];
    
    sy += (edge + textWidth);
    rect = CGRectMake(sx, sy, (textWidth - edge)/2.0, textHeight);
    m_AddMapElementButton = [[UIButton alloc] initWithFrame:rect];
    m_AddMapElementButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_AddMapElementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_AddMapElementButton addTarget:self.superview action:@selector(OnAddMapElementClick) forControlEvents:UIControlEventTouchUpInside];
    m_AddMapElementButton.backgroundColor = [UIColor colorWithRed:0.5 green:1.0 blue:0.5 alpha:1.0];
    [m_AddMapElementButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_AddMapElementButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [m_AddMapElementButton setTitle:@"Add Route/Region" forState:UIControlStateNormal];
    m_AddMapElementButton.reversesTitleShadowWhenHighlighted = YES;
    m_AddMapElementButton.titleLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [self addSubview:m_AddMapElementButton];

/*
    float btnsy = sy;
    float btnsx = sx + textWidth - textHeight*3;
    rect = CGRectMake(btnsx, btnsy, textHeight, textHeight);
    m_StandardBtn = [[UIButton alloc] initWithFrame:rect];
    m_StandardBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_StandardBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_StandardBtn addTarget:self action:@selector(OnStandardMapTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_StandardBtn setBackgroundImage:[UIImage imageNamed:@"std200.png"] forState:UIControlStateNormal];
    [self addSubview:m_StandardBtn];
    
    btnsx = sx + textWidth - textHeight*2;
    rect = CGRectMake(btnsx, btnsy, textHeight, textHeight);
    m_SatelliteBtn = [[UIButton alloc] initWithFrame:rect];
    m_SatelliteBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_SatelliteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_SatelliteBtn addTarget:self action:@selector(OnSatelliteMapTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_SatelliteBtn setBackgroundImage:[UIImage imageNamed:@"satellite200.png"] forState:UIControlStateNormal];
    [self addSubview:m_SatelliteBtn];
    
    btnsx = sx + textWidth - textHeight;
    rect = CGRectMake(btnsx, btnsy, textHeight, textHeight);
    m_HybirdBtn = [[UIButton alloc] initWithFrame:rect];
    m_HybirdBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_HybirdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_HybirdBtn addTarget:self action:@selector(OnHybirdMapTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_HybirdBtn setBackgroundImage:[UIImage imageNamed:@"hybird200.png"] forState:UIControlStateNormal];
    [self addSubview:m_HybirdBtn];
*/
  
/*
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textWidth);
    m_MapView = [[MKMapView alloc] initWithFrame:rect];
    m_MapView.delegate = self;
    m_MapView.mapType = MKMapTypeStandard;
    [self addSubview:m_MapView];
*/
    //sy += (edge + textWidth);
    sy += (edge + textHeight);  //!!!
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    m_KeywordEdit = [[UITextField alloc] initWithFrame:rect];
    m_KeywordEdit.borderStyle = UITextBorderStyleRoundedRect;
    m_KeywordEdit.textColor = [UIColor blackColor];
    m_KeywordEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_KeywordEdit.placeholder = [NSString stringWithFormat:@"<%@>", [StringFactory GetString_KeywordLabel]];
    m_KeywordEdit.backgroundColor = [UIColor whiteColor];
    m_KeywordEdit.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_KeywordEdit.keyboardType = UIKeyboardTypeDefault;
    m_KeywordEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_KeywordEdit.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_KeywordEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_KeywordEdit.delegate = self;
    m_KeywordEdit.tag = NOM_KEYWORDSEDIT_TAG;
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
    m_CopyrightEdit.tag = NOM_KEYWORDSEDIT_TAG;
    [self addSubview:m_CopyrightEdit];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    float w = self.frame.size.width - 3*edge - [NOMPostUICore GetButtonWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    m_EventTimeBox = [[UITextField alloc] initWithFrame:rect];
    m_EventTimeBox.borderStyle = UITextBorderStyleRoundedRect;
    m_EventTimeBox.textColor = [UIColor blackColor];
    m_EventTimeBox.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_EventTimeBox.placeholder = [NSString stringWithFormat:@"<%@>", [StringFactory GetString_Time]];
    m_EventTimeBox.backgroundColor = [UIColor whiteColor];
    m_EventTimeBox.enabled = NO;
    m_EventTimeBox.adjustsFontSizeToFitWidth = YES;
    [self addSubview:m_EventTimeBox];
    m_EventTimeBox.hidden = YES;
    
    sx += w + edge;
    rect = CGRectMake(sx, sy, [NOMPostUICore GetButtonWidth], textHeight);
    m_EventTimeButton = [[UIButton alloc] initWithFrame:rect];
    m_EventTimeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_EventTimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_EventTimeButton addTarget:self action:@selector(OnAddTimeClick) forControlEvents:UIControlEventTouchUpInside];
    m_EventTimeButton.backgroundColor = [UIColor colorWithRed:0.5 green:1.0 blue:0.5 alpha:1.0];
    [m_EventTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_EventTimeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [m_EventTimeButton setTitle:[StringFactory GetString_Time] forState:UIControlStateNormal];
    m_EventTimeButton.reversesTitleShadowWhenHighlighted = YES;
    m_EventTimeButton.titleLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [self addSubview:m_EventTimeButton];
    m_EventTimeButton.hidden = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_CachedKML = nil;
        m_PostImage = nil;
        //m_AppRegionOverlay = nil;
        m_ReferencePin = [[NOMReferenceAnnotation alloc] init];
        [self InitializeSubViews];
    }
    return self;
}

-(void)CleanControlState
{
    [m_SubjectEdit setText:@""];
    [m_PostEdit setText:@""];
    [m_ImagePreview setImage:nil];
    
    [m_KeywordEdit setText:@""];
    [m_CopyrightEdit setText:@""];
    [m_EventTimeBox setText:@""];
    
    UIImage* image = m_ImagePreview.image;
    
    if(image == nil)
        m_DeletePhotoButton.hidden = YES;
    else
        m_DeletePhotoButton.hidden = NO;
    
    m_CachedKML = nil;
/*    NSArray *overlays = [m_MapView overlays];
    if(overlays != nil && 0 < overlays.count)
    {
        [m_MapView removeOverlays:overlays];
    }

    NSArray *annotations = [m_MapView annotations];
    if(annotations != nil && 0 < annotations.count)
    {
        [m_MapView removeAnnotations:annotations];
    }*/
}

-(void)UpdateLayout
{
    [self HideKeyboard];
    float textHeight = [NOMPostUICore GetDefaultTextHeight];
    float edge = [NOMPostUICore GetDefaultEdge];
    
    float textWidth = self.frame.size.width-2.0*edge;
    
    float sx = edge;
    float sy = edge;
    if(self.superview != nil)
    {
        if(self.superview.frame.size.height < self.superview.frame.size.width)
        {
            sx = edge*2;
            textWidth = self.superview.frame.size.width-4.0*edge;
        }
    }
    CGRect rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_SubjectEdit setFrame:rect];
    sy += (edge + textHeight);
    float height = [self GetDefaultPostViewHeight];
    rect = CGRectMake(sx, sy, textWidth, height);
    [m_PostEdit setFrame:rect];
  
    sy += (edge + height);
    
    rect = CGRectMake(sx, sy, (textWidth - edge)/2.0, textHeight);
    [m_PhotoButton setFrame:rect];
    
    rect = CGRectMake(sx + (textWidth + edge)/2.0, sy, (textWidth - edge)/2.0, textHeight);
    [m_DeletePhotoButton setFrame:rect];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textWidth);
    [m_ImagePreview setFrame:rect];
    
    sy += (edge + textWidth);
    rect = CGRectMake(sx, sy, (textWidth - edge)/2.0, textHeight);
    [m_AddMapElementButton setFrame:rect];
/*
    float btnsy = sy;
    float btnsx = sx + textWidth - textHeight*3;
    rect = CGRectMake(btnsx, btnsy, textHeight, textHeight);
    [m_StandardBtn setFrame:rect];
    
    btnsx = sx + textWidth - textHeight*2;
    rect = CGRectMake(btnsx, btnsy, textHeight, textHeight);
    [m_SatelliteBtn setFrame:rect];
    
    btnsx = sx + textWidth - textHeight;
    rect = CGRectMake(btnsx, btnsy, textHeight, textHeight);
    [m_HybirdBtn setFrame:rect];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textWidth);
    [m_MapView setFrame:rect];
*/
//    sy += (edge + textWidth);
    sy += (edge + textHeight); //!!!!
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_KeywordEdit setFrame:rect];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_CopyrightEdit setFrame:rect];
    
    sy += (edge + textHeight);
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    float w = self.frame.size.width - 3*edge - [NOMPostUICore GetButtonWidth];
    if(m_EventTimeButton.hidden == YES)
    {
        w = textWidth;
    }
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_EventTimeBox setFrame:rect];
    
    sx += w + edge;
    rect = CGRectMake(sx, sy, [NOMPostUICore GetButtonWidth], textHeight);
    [m_EventTimeButton setFrame:rect];
}

-(float)GetPostViewHeight
{
    float textHeight = [NOMPostUICore GetDefaultTextHeight];
    float edge = [NOMPostUICore GetDefaultEdge];
    float textWidth = self.frame.size.width-2.0*edge;
    
    if(self.superview != nil)
    {
        if(self.superview.frame.size.height < self.superview.frame.size.width)
        {
            textWidth = self.superview.frame.size.width-4.0*edge;
        }
    }
    
    float h = [self GetDefaultPostViewHeight];

    float fRet = textHeight*6 + edge*10 + textWidth*2 + h;
    
    return fRet;
}

-(void)ReceiveImage:(UIImage*)image
{
    m_PostImage = image;
    [m_ImagePreview setImage:image];
    [NOMAppInfo SetCurrentImageResourceReceiver:nil];

    if(image == nil)
        m_DeletePhotoButton.hidden = YES;
    else
        m_DeletePhotoButton.hidden = NO;
    
    if([self.superview respondsToSelector:@selector(ScrollViewTo:)] == YES)
    {
        SEL sel = @selector(ScrollViewTo:);
        float y = m_ImagePreview.frame.origin.y;
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self.superview methodSignatureForSelector:sel]];
        [inv setSelector:sel];
        [inv setTarget:self.superview];
        [inv setArgument:&y atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [inv invoke];
    }
}

-(void)OpenView
{
    [self OnDeletePhotoClick];
    [self HideKeyboard];
}

-(void)SetPinDragState:(BOOL)bYES
{
    
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
/*    NSArray *annotations = [m_MapView annotations];
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
    }*/
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self RedrawMapElements];
}

-(void)HandlePlanLineKML:(KMLDocument *)kmlDocument
{
/*    if(kmlDocument != nil && kmlDocument.features != nil)
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
 */
}

-(void)HandlePlanRouteKML:(KMLDocument *)kmlDocument
{
/*
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
*/
}

-(void)HandlePlanPolyKML:(KMLDocument *)kmlDocument
{
/*
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
*/
}

-(void)HandlePlanRectKML:(KMLDocument *)kmlDocument
{
/*
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
*/
}

-(void)SetKML:(NSString*)kml
{
    m_CachedKML = kml;
/*    KMLRoot* kmlObject = [KMLParser parseKMLWithString:kml];
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
    }*/
}

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
            CGSize size = CGSizeMake([NOMPostUICore GetGEOPlanPinSize], [NOMPostUICore GetGEOPlanPinSize]);
            
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
            
            CGSize size = CGSizeMake([NOMPostUICore GetQueryPinWidth], [NOMPostUICore GetQueryPinHeight]);
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
    if(m_ReferencePin != nil)
    {
        [m_ReferencePin SetCoordinate:dLong withLatitude:dLat];
 /*       [m_MapView addAnnotation:m_ReferencePin];
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(m_MapView.visibleMapRect);
        region.center.latitude = dLat;
        region.center.longitude = dLong;
        region.span.latitudeDelta = Span;
        region.span.longitudeDelta = Span;
        [m_MapView setRegion:region animated:YES];*/
    }
}

-(void)SetReferenceInfo:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType isTTweet:(BOOL)bTwitterTweet
{
    if(m_ReferencePin != nil)
    {
        [m_ReferencePin SetNewsDataMainType:nMainCate withSubType:nSubCate withThirdType:nThirdType];
        [m_ReferencePin SetTwitterTweet:bTwitterTweet];
    }
}

-(NSString*)GetSubject
{
    NSString* szRet = m_SubjectEdit.text;
    return szRet;
}

-(NSString*)GetPost
{
    NSString* szRet = m_PostEdit.text;
    return szRet;
}

-(NSString*)GetKeywords
{
    NSString* szRet = m_KeywordEdit.text;
    return szRet;
}

-(NSString*)GetCopyright
{
    NSString* szRet = m_CopyrightEdit.text;
    return szRet;
}

-(NSString*)GetGeographicKML
{
    return m_CachedKML;
}

-(UIImage*)GetImage
{
    return m_PostImage;
    //UIImage* pImage = m_ImagePreview.image;
    //return pImage;
}

-(void)HideKeyboard
{
    [m_SubjectEdit resignFirstResponder];
    [m_PostEdit resignFirstResponder];
    [m_KeywordEdit resignFirstResponder];
    [m_CopyrightEdit resignFirstResponder];
    [m_EventTimeBox resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self HideKeyboard];
}
@end
