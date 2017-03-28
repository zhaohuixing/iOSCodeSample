//
//  CustomMapViewPinCallout.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-16.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "TwoStateButton.h"
#import "CustomMapViewPinDisplayView.h"
#import "CustomMapViewPinFrame.h"
#import "CustomMapViewPinCallout.h"
#import "NOMAppInfo.h"
#import "ImageLoader.h"
//#include "drawhelper.h"


@interface CustomMapViewPinCallout ()
{
@private
    CGPoint                 m_ArchorPoint;
    
    TwoStateButton*         m_CloseButton;
    
    //CGGradientRef           m_Gradient;
    //CGColorSpaceRef         m_Colorspace;
    
    //CustomMapViewPinDisplayView*    m_DisplayView;
    CustomMapViewPinFrame*             m_DisplayView;
    
    //CGImageRef          m_UpSign;
    //CGImageRef          m_DownSign;
    
    CLLocationCoordinate2D          m_CurrentLocation;
    
    BOOL                m_bFixedLocation;
}

@end

@implementation CustomMapViewPinCallout

+(float)GetContainerViewMaxHeight
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 360;
    }
    else
    {
        return 168;
    }
}

+(float)GetContainerViewWidth
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 240;
    }
    else
    {
        return 180;
    }
}

+(float)GetDefaultContainerViewHeight
{
    float fRet = [CustomMapViewPinCallout GetCalloutItemHeight] + 2.0*[CustomMapViewPinCallout GetCornerSize] + [CustomMapViewPinCallout GetAchorSize];
    
    return fRet;
}

+(float)GetAchorSize
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 42;////50;
    }
    else
    {
        return 30;//36
    }
}

+(float)GetCornerSize
{
    float w = [CustomMapViewPinCallout GetContainerViewWidth];
    float ret = w*0.05;
    return ret;
}

+(float)GetCalloutItemWidth
{
    float w = [CustomMapViewPinCallout GetContainerViewWidth];
    float ret = w*0.9;
    return ret;
}

+(float)GetCalloutItemHeight
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 72;
    }
    else
    {
        return 56;
    }
}

+(int)GetMaxDisplayCalloutItemNumber
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 5;
    }
    else
    {
        return 3;
    }
}

+(int)GetMinDisplayCalloutItemNumber
{
    return 1;
}

-(void)OnCloseButtonClick
{
    [self Close:YES];
}

-(void)InitDisplayView
{
    float fSize = [CustomMapViewPinCallout GetAchorSize];
    float sy = 0;//[CustomMapViewPinCallout GetCornerSize];
    if(m_ArchorPoint.y == 0)
    {
        sy += fSize;
    }
    float sx = 0; //[CustomMapViewPinCallout GetCornerSize];
    float w = self.frame.size.width; //[CustomMapViewPinCallout GetCalloutItemWidth];
    float h = self.frame.size.height - fSize;//[CustomMapViewPinCallout GetCalloutItemHeight];
    CGRect rect = CGRectMake(sx, sy, w, h);
    //m_DisplayView = [[CustomMapViewPinDisplayView alloc] initWithFrame:rect];
    m_DisplayView = [[CustomMapViewPinFrame alloc] initWithFrame:rect];

    [self addSubview:m_DisplayView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        //size_t num_locations = 2;
        //CGFloat locations[2] = {0.0, 1.0};
        //CGFloat colors[8] =
        //{
        //    0.1, 0.1, 0.1, 0.7,
        //    0.0, 0.0, 0.0, 1.0,
        //};
        //m_Colorspace = CGColorSpaceCreateDeviceRGB();
        //m_Gradient = CGGradientCreateWithColorComponents (m_Colorspace, colors, locations, num_locations);

        //m_UpSign = [ImageLoader LoadImageWithName:@"scrollup.png"];
        //m_DownSign = [ImageLoader LoadImageWithName:@"scrolldown.png"];
        
        m_ArchorPoint.x = frame.size.width*0.5;
        m_ArchorPoint.y = 0;
        float fSize = [CustomMapViewPinCallout GetAchorSize];
        float sx = m_ArchorPoint.x - fSize*0.5;
        float sy = 0;
        
        CGRect rect = CGRectMake(sx, sy, fSize, fSize);
        m_CloseButton = [[TwoStateButton alloc] initWithFrame:rect];
        m_CloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_CloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [m_CloseButton addTarget:self action:@selector(OnCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [m_CloseButton SetStateImage:[UIImage imageNamed:@"closearchor.png"] withImageTwo:[UIImage imageNamed:@"rclosearchor.png"]];
        [self addSubview:m_CloseButton];
        
        m_CurrentLocation.latitude = -1.0;
        m_CurrentLocation.longitude = -1.0;

        m_bFixedLocation = NO;
        
        [self InitDisplayView];
    }
    return self;
}

- (void)dealloc
{
    //if(m_UpSign != NULL)
    //    CGImageRelease(m_UpSign);
    //if(m_DownSign != NULL)
    //    CGImageRelease(m_DownSign);
    
//    CGColorSpaceRelease(m_Colorspace);
//    CGGradientRelease(m_Gradient);
}

-(void)SetArchor:(CGPoint)pt
{
    m_ArchorPoint.x = pt.x;
    m_ArchorPoint.y = pt.y;
    [self UpdateLayout];
}

-(float)GetLayoutWidth
{
    float width = [CustomMapViewPinCallout GetContainerViewWidth];
    return width;
}

-(float)GetLayoutHeight
{
    float height = [CustomMapViewPinCallout GetContainerViewMaxHeight];
    
    if(m_DisplayView != nil)
    {
        height = [m_DisplayView GetCalloutItemHeight];
        height += [CustomMapViewPinCallout GetAchorSize] + [CustomMapViewPinCallout GetCornerSize]*2;
    }
    
    return height;
}


-(void)UpdateFrameSize
{
    float h = [self GetLayoutHeight];
    
    float bottom;
    float top;
    
    if(m_ArchorPoint.y == 0)
    {
        top = self.frame.origin.y;
        bottom = top + h;
    }
    else
    {
        bottom = self.frame.origin.y + self.frame.size.height;
        top = bottom - h;
        m_ArchorPoint.y = h;
    }
    float left = self.frame.origin.x;
    float w = self.frame.size.width;
    CGRect rect = CGRectMake(left, top, w, h);
    [self setFrame:rect];
}

-(void)UpdateLayout
{
    [self UpdateFrameSize];
    CGRect rect;
    float size = [CustomMapViewPinCallout GetAchorSize];
    
    float sx =  m_ArchorPoint.x - size*0.5;//(self.frame.size.width - size)*0.5;
    if(sx < 0.0)
        sx = 0.0;
    if((self.frame.size.width-size) < sx)
        sx = self.frame.size.width-size;
    BOOL bFlipped = NO;
    float sy = self.frame.size.height -size;
    if(m_ArchorPoint.y == 0)
    {
        sy = 0;
        bFlipped = YES;
    }
    
    rect = CGRectMake(sx, sy, size, size);
    [m_CloseButton setFrame:rect];
    [m_CloseButton SetState:!bFlipped];
    if(m_DisplayView != nil)
    {
        rect = m_DisplayView.frame;

        rect.origin.y = 0; //[CustomMapViewPinCallout GetCornerSize];
        if(m_ArchorPoint.y == 0)
        {
            rect.origin.y = /*[CustomMapViewPinCallout GetCornerSize] + */ size;
        }
        
        rect.size.height = self.frame.size.height - size; //[m_DisplayView GetCalloutItemHeight];
        [m_DisplayView setFrame:rect];
        //[m_DisplayView setContentSize:CGSizeMake(rect.size.width, [m_DisplayView GetAllCalloutItemHeight])];
        [m_DisplayView SetFlipState:bFlipped];
        [m_DisplayView UpdateLayout];
        [m_DisplayView setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

/*
- (void)DrawScrollUpSign:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    float srcw = CGImageGetWidth(m_UpSign);
    float srch = CGImageGetHeight(m_UpSign);
    float ratio = srcw/srch;
    float cornerHeight = [CustomMapViewPinCallout GetCornerSize];
    float h = cornerHeight;
    float w = ratio*h;
    float sx = rect.origin.x + (rect.size.width - w)*0.5;
    float sy = rect.origin.y;
    CGRect rt = CGRectMake(sx, sy, w, h);
    
    CGFloat clr[] = {0, 0, 0, 0.5};
    CGContextSetFillColor(context, clr);
    CGContextFillRect(context, rt);
    
    CGContextDrawImage(context, rt, m_UpSign);
    CGContextRestoreGState(context);
}

- (void)DrawScrollDownSign:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    float srcw = CGImageGetWidth(m_DownSign);
    float srch = CGImageGetHeight(m_DownSign);
    float ratio = srcw/srch;
    float cornerHeight = [CustomMapViewPinCallout GetCornerSize];
    float h = cornerHeight;
    float w = ratio*h;
    float sx = rect.origin.x + (rect.size.width - w)*0.5;
    float sy = rect.origin.y + rect.size.height - h;
    CGRect rt = CGRectMake(sx, sy, w, h);
    
    CGFloat clr[] = {0, 0, 0, 1};
    CGContextSetFillColor(context, clr);
    CGContextFillRect(context, rt);
    
    CGContextDrawImage(context, rt, m_DownSign);
    CGContextRestoreGState(context);
}


- (void)DrawScrollSigns:(CGContextRef)context inRect:(CGRect)rect
{
    [self DrawScrollUpSign:context inRect:rect];
    [self DrawScrollDownSign:context inRect:rect];
}

- (void)DrawBasicBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    float fsize = rect.size.width*0.1;
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_Gradient, pt1, pt2, 0);
    
    CGContextRestoreGState(context);
    if(m_DisplayView != nil)
    {
        int nMenuCount = [m_DisplayView GetCalloutItemCount];
        if([CustomMapViewPinCallout GetMaxDisplayCalloutItemNumber] < nMenuCount)
        {
            [self DrawScrollSigns:context inRect:rect];
        }
    }
}

- (void)DrawGlossyBackground:(CGContextRef)context inRect:(CGRect)rect
{
    [self DrawBasicBackground:context inRect:rect];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    //??????
    CGRect rt = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - [CustomMapViewPinCallout GetAchorSize]);
    if(m_ArchorPoint.y == 0 || m_ArchorPoint.y == rect.origin.y)
    {
        rt = CGRectMake(rect.origin.x, rect.origin.y + [CustomMapViewPinCallout GetAchorSize], rect.size.width, rect.size.height - [CustomMapViewPinCallout GetAchorSize]);
    }
   
    [self DrawGlossyBackground:context inRect:rt];
}
*/
 
-(void)RemoveAllPinItems
{
    m_bFixedLocation = NO;
    [m_DisplayView RemoveAllPinItems];
}

-(void)AddPinItem:(CustomMapViewPinItem*)item
{
    [m_DisplayView AddPinItem:item];
    [self UpdateLayout];
}

-(void)OnCalloutOpen
{
    [self UpdateLayout];
    [m_DisplayView setNeedsDisplay];
}

-(void)Open:(BOOL)bAnimation
{
    if(self.hidden == NO)
    {
        [self OnCalloutOpen];
        return;
    }
    if(bAnimation == YES)
    {
        [self.superview bringSubviewToFront:self];
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(OnCalloutOpen)];
        self.hidden = NO;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        [UIView commitAnimations];
    }
    else
    {
        [self.superview bringSubviewToFront:self];
        self.hidden = NO;
        [self OnCalloutOpen];
    }
}

-(void)OnCalloutClose
{
    [m_DisplayView setNeedsDisplay];
    [self.superview sendSubviewToBack:self];
}

-(void)Close:(BOOL)bAnimation
{
    if(self.hidden == YES)
        return;
    
    if(bAnimation == YES)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(OnCalloutClose)];
        self.hidden = YES;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        [UIView commitAnimations];
    }
    else
    {
        self.hidden = YES;
        [self OnCalloutClose];
    }
}

-(void)SetCurrentLocation:(CLLocationCoordinate2D)location
{
    m_CurrentLocation.latitude = location.latitude;
    m_CurrentLocation.longitude = location.longitude;
}

-(CLLocationCoordinate2D)GetCurrentLocation
{
    return m_CurrentLocation;
}

-(void)SetFixedLocation:(BOOL)bFixedLocation
{
    m_bFixedLocation = bFixedLocation;
}

-(BOOL)IsFixedLocation
{
    return m_bFixedLocation;
}

@end
