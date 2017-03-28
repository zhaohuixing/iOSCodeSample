//
//  CustomMapViewPinFrame.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "CustomMapViewPinFrame.h"
#import "CustomMapViewPinDisplayView.h"
#import "CustomMapViewPinCallout.h"
#import "NOMAppInfo.h"
#import "ImageLoader.h"
#import "DrawHelper2.h"
//#include "drawhelper.h"


@interface CustomMapViewPinFrame ()
{
    CGGradientRef           m_Gradient;
    CGColorSpaceRef         m_Colorspace;
    
    CustomMapViewPinDisplayView*    m_DisplayView;
    
    CGImageRef          m_UpSign;
    CGImageRef          m_DownSign;
    BOOL                m_bFlipped;
}

@end

@implementation CustomMapViewPinFrame

-(void)SetFlipState:(BOOL)bFlipped
{
    m_bFlipped = bFlipped;
    [self setNeedsDisplay];
}

-(void)InitDisplayView
{
    float size = [CustomMapViewPinCallout GetCornerSize];
    float sx = size;
    float sy = size;
    
   CGRect rect = CGRectMake(sx, sy, self.frame.size.width-2*size, self.frame.size.height-2*size);
    m_DisplayView = [[CustomMapViewPinDisplayView alloc] initWithFrame:rect];
    [self addSubview:m_DisplayView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_bFlipped = NO;
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};
        CGFloat colors[8] =
        {
//            0.1, 0.1, 0.1, 0.7,
//            0.0, 0.0, 0.0, 1.0,
            0.4, 0.4, 0.4, 0.7,
            0.0, 0.0, 0.0, 1.0,
        };
        m_Colorspace = CGColorSpaceCreateDeviceRGB();
        m_Gradient = CGGradientCreateWithColorComponents (m_Colorspace, colors, locations, num_locations);
        
        m_UpSign = [ImageLoader LoadImageWithName:@"scrollup.png"];
        m_DownSign = [ImageLoader LoadImageWithName:@"scrolldown.png"];
        
        [self InitDisplayView];
    }
    return self;
}

- (void)dealloc
{
    CGColorSpaceRelease(m_Colorspace);
    CGGradientRelease(m_Gradient);
}

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
    //AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    [DrawHelper2 AddRoundRectToPath:context in:rect radius:CGSizeMake(fsize, fsize) size:0.5];
    CGContextClip(context);
    CGPoint pt1, pt2;
    
    if(m_bFlipped == YES)
    {
        pt2.x = rect.origin.x;
        pt2.y = rect.origin.y;
        pt1.x = rect.origin.x;
        pt1.y = pt2.y+rect.size.height;
    }
    else
    {
        pt1.x = rect.origin.x;
        pt1.y = rect.origin.y;
        pt2.x = rect.origin.x;
        pt2.y = pt1.y+rect.size.height;
    }
    
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
    [self DrawGlossyBackground:context inRect:rect];
}

-(float)GetCalloutItemHeight
{
    float fRet = 1.0;
    
    fRet = [m_DisplayView GetCalloutItemHeight];
    
    return fRet;
}

-(float)GetAllCalloutItemHeight
{
    float fRet = 1.0;

    fRet = [m_DisplayView GetAllCalloutItemHeight];
    
    return fRet;
}

-(int)GetCalloutItemCount
{
    int nRet = 1;
    
    nRet = [m_DisplayView GetCalloutItemCount];
    
    return nRet;
}

-(void)UpdateLayout
{
    float size = [CustomMapViewPinCallout GetCornerSize];
    float sx = size;
    float sy = size;
    
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width-2*size, self.frame.size.height-2*size);
    [m_DisplayView setFrame:rect];
    [m_DisplayView setContentSize:CGSizeMake(rect.size.width, [m_DisplayView GetAllCalloutItemHeight])];
    [m_DisplayView UpdateLayout];
    [self setNeedsDisplay];
}

-(void)RemoveAllPinItems
{
    [m_DisplayView RemoveAllPinItems];
}

-(void)AddPinItem:(CustomMapViewPinItem*)item
{
    [m_DisplayView AddPinItem:item];
}

@end
