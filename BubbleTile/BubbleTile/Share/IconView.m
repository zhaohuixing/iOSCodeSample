//
//  IconView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "IconView.h"
#import "ImageLoader.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"
#import "GameConstants.h"
#include "drawhelper.h"


@implementation IconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        m_IconImage = NULL;
        self.backgroundColor = [UIColor clearColor];
        m_CheckSign = [ImageLoader LoadResourceImage:@"redled.png"];
        m_StopSign = [ImageLoader LoadResourceImage:@"stopsign.png"];
        m_bSelected = NO;
        m_nClickEvent = -1;
        m_bEnable = YES;
    }
    return self;
}

-(void)RegisterEvent:(int)nClick
{
    m_nClickEvent = nClick;
}


-(void)SetIconImage:(CGImageRef)image
{
    if(m_IconImage)
    {    
        CGImageRelease(m_IconImage);
        m_IconImage = NULL;
    }    
    m_IconImage = image;
}

-(void)SetSelected:(BOOL)bSelected
{
    m_bSelected = bSelected;
    [self setNeedsDisplay];
}

-(void)SetEnable:(BOOL)bEnable
{
    m_bEnable = bEnable;
    [self setNeedsDisplay];
}

-(void)drawBackground:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.6, 1.00);
    CGContextFillRect(context, rect);
}

-(void)drawOverlay:(CGContextRef)context withRect:(CGRect)rect
{
    CGGradientRef gradientFill;
    CGColorSpaceRef fillColorspace;
    size_t num_locations = 4;
    CGFloat locations[4] = {0.0, 0.5, 0.5, 1.0};
    CGFloat colors[16] = 
    {
        1.0, 1.0, 1.0, 0.6,
        0.2, 0.2, 0.4, 0.5, 
        0.0, 0.0, 0.2, 0.5, 
        0.0, 0.0, 0.15, 0.5, 
    };
    
    fillColorspace = CGColorSpaceCreateDeviceRGB();
    gradientFill = CGGradientCreateWithColorComponents (fillColorspace, colors, locations, num_locations);
    
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = rect.origin.y+rect.size.height;
    CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
    
    CGColorSpaceRelease(fillColorspace);
    CFRelease(gradientFill);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);

    float fSize = 0.1*fminf(rect.size.width, rect.size.height);
    AddRoundedRectToPathWithoutScale(context, rect, fSize);
    CGContextClip(context);
    [self drawBackground:context withRect:rect];
    
    if(m_IconImage)
    {   
        CGRect rt = CGRectInset(rect, fSize, fSize);
        CGContextDrawImage(context, rt, m_IconImage);
    }

    [self drawOverlay:context withRect:rect];
    if(m_bSelected) //&& m_bEnable == YES)
    {    
        CGRect rt = CGRectMake(rect.origin.x+rect.size.width*0.5-fSize*0.5, rect.origin.y+2, fSize, fSize);
        CGContextDrawImage(context, rt, m_CheckSign);
    }
    if(m_bEnable == NO)
    {
        CGContextSaveGState(context);    
       
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, rect.origin.x+rect.size.width, rect.origin.y);
		CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
		CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+rect.size.height);
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.75);
        CGContextFillPath(context);
        CGContextClosePath(context);
        CGContextRestoreGState(context);    
        
        float x = rect.origin.x+rect.size.width - (fSize/4.0+fSize);
        float y = rect.origin.y+rect.size.height - (fSize/4.0+fSize);
        CGRect rt1 = CGRectMake(x, y, fSize, fSize);
        CGContextDrawImage(context, rt1, m_StopSign);
    }
    
	CGContextRestoreGState(context);
}


- (void)dealloc
{
    if(m_IconImage)
        CGImageRelease(m_IconImage);
    if(m_CheckSign)
        CGImageRelease(m_CheckSign);
    if(m_StopSign)
        CGImageRelease(m_StopSign);
    
    [super dealloc];
}

-(void)PostClickEvent:(CGPoint)pt
{
    if(m_bEnable)
    {    
        [GUIEventLoop SendEvent:m_nClickEvent eventSender:self];
    }    
    else
    {
        float v1 = pt.x + pt.y;
        float v2 = self.frame.size.width;
        if(v1 <= v2)
        {
            [GUIEventLoop SendEvent:m_nClickEvent eventSender:self];
        }
        else
        {    
            [GUIEventLoop SendEvent:GUIID_EVENT_DISABLEICONVIEWCLICK eventSender:self];
        }    
    }    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
/*	NSArray *points = [touches allObjects];
	CGPoint pt;
	pt = POINT(0);
    
    if(!m_bSelected)
    {    
        [self PostClickEvent:pt];
    }    
    else if(!m_bEnable)
    {
        float v1 = pt.x + pt.y;
        float v2 = self.frame.size.width;
        if(v2 < v1)
        {
            [GUIEventLoop SendEvent:GUIID_EVENT_DISABLEICONVIEWCLICK eventSender:self];
        }    
    }*/
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
/*	NSArray *points = [touches allObjects];
	CGPoint pt;
	pt = POINT(0);
    
    if(!m_bSelected)
    {    
        [self PostClickEvent:pt];
    }    
    else if(!m_bEnable)
    {
        float v1 = pt.x + pt.y;
        float v2 = self.frame.size.width;
        if(v2 < v1)
        {
            [GUIEventLoop SendEvent:GUIID_EVENT_DISABLEICONVIEWCLICK eventSender:self];
        }    
    }*/
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *points = [touches allObjects];
	CGPoint pt;
	pt = POINT(0);
    
    if(!m_bSelected)
    {    
        [self PostClickEvent:pt];
    }    
    else if(!m_bEnable)
    {
        float v1 = pt.x + pt.y;
        float v2 = self.frame.size.width;
        if(v2 < v1)
        {
            [GUIEventLoop SendEvent:GUIID_EVENT_DISABLEICONVIEWCLICK eventSender:self];
        }    
    }
}
@end
