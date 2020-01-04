//
//  RoboListBoard.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "RoboListBoard.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#import "ApplicationConfigure.h"
#import "CGameLayout.h"
#include "drawhelper.h"
#import "DrawHelper2.h"

@implementation RoboListBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_AchorPoint = CGPointMake(frame.size.width*0.3, 0);
        
        float fFontSize = 18.0;
        if([ApplicationConfigure iPhoneDevice])
            fFontSize = 12.0;
        
        float roundSize = [GUILayout GetDefaultAlertUIEdge];         
        float width = self.frame.size.width-2.0*roundSize;
        float height = (self.frame.size.height-2.0*roundSize-5)*0.25;
        
        float sx = roundSize;
        float sy = roundSize;
        CGRect rect = CGRectMake(sx, sy, width, height);

		m_Title = [[UILabel alloc] initWithFrame:rect];
		m_Title.backgroundColor = [UIColor clearColor];
		[m_Title setTextColor:[UIColor redColor]];
		m_Title.font = [UIFont fontWithName:@"Times New Roman" size:fFontSize];
        [m_Title setTextAlignment:UITextAlignmentCenter];
        m_Title.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Title.adjustsFontSizeToFitWidth = YES;
		[m_Title setText:@"Test Title"];
		[self addSubview:m_Title];
		[m_Title release];
        
        m_Image1 = NULL;
        m_Image2 = NULL;
        m_Image3 = NULL;
    
        [self UpdateViewLayout];
    }
    return self;
}

-(void)SetAchorAtTop:(float)fPostion
{
    m_AchorPoint = CGPointMake(self.frame.size.width*fPostion, 0);
    [self UpdateViewLayout];
}

-(void)SetAchorAtBottom:(float)fPostion
{
    m_AchorPoint = CGPointMake(self.frame.size.width*fPostion, self.frame.size.height);
    [self UpdateViewLayout];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawBackground:(CGContextRef)context inRect:(CGRect)rect;
{
    CGContextSaveGState(context);
    float fsize = [GUILayout GetDefaultAlertUIConner];
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    [DrawHelper2 DrawGrayTextureRect:context at:rect];
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float foffset = [GUILayout GetDefaultAlertUIEdge]/4.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawHalfSizeGrayBackgroundDecoration:context];
    CGContextRestoreGState(context);
}

-(void)drawNoTransformedImage:(CGContextRef)context withImage:(CGImageRef)image inRect:(CGRect)rect
{
    float imgw = CGImageGetWidth(image);
    float imgh = CGImageGetHeight(image);
    float ratio = imgw/imgh;
    float ra2 = rect.size.width/rect.size.height;
    float w, h;
    CGRect rt;
    if(ra2 < ratio)
    {
        w = rect.size.width;
        h = w/ratio;
        rt = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - h)/2.0, w, h);
    }
    else
    {
        h = rect.size.height;
        w = h*ratio;
        rt = CGRectMake(rect.origin.x + (rect.size.width - w)/2.0, rect.origin.y, w, h);
    }
    CGContextDrawImage(context, rt, image);
}

-(void)drawListImage:(CGContextRef)context inRect:(CGRect)rect;
{
    float roundSize = [GUILayout GetDefaultAlertUIEdge]; 
    float width = self.frame.size.width-roundSize;
    float height = (self.frame.size.height-2.0*roundSize-5)*0.25;
    
    float cardWidth = [CGameLayout GetCardWidth];
    float cardHeight = [CGameLayout GetCardHeight];
    
    width = height*cardWidth*5.0/cardHeight; 
    if((self.frame.size.width-roundSize) <= width)
        width = (self.frame.size.width-roundSize)*0.9; 
    
    float sx = (self.frame.size.width-width)*0.5; //roundSize*0.5;
    float sy = roundSize;
    sy += height+1;
    CGRect rt = CGRectMake(sx, sy, width, height);
    if(m_Image1 != NULL)
    {    
        [self drawNoTransformedImage:context withImage:m_Image1 inRect:rt];
    }
    
    sy += height+1;
    rt = CGRectMake(sx, sy, width, height);
    if(m_Image2 != NULL)
    {    
        [self drawNoTransformedImage:context withImage:m_Image2 inRect:rt];
    }
    
    sy += height+1;
    rt = CGRectMake(sx, sy, width, height);
    if(m_Image3 != NULL)
    {    
        [self drawNoTransformedImage:context withImage:m_Image3 inRect:rt];
    }
  
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
    [self drawListImage:context inRect: rect];
}

-(void)UpdateViewLayout
{
    [self setNeedsDisplay];
}

-(void)SetTitle:(NSString*)szTitle
{
    [m_Title setText:szTitle];
}

-(void)SetImage1:(CGImageRef)image
{
    if(m_Image1 != NULL)
        CGImageRelease(m_Image1);
    
    m_Image1 = image;
}

-(void)SetImage2:(CGImageRef)image
{
    if(m_Image2 != NULL)
        CGImageRelease(m_Image2);
    
    m_Image2 = image;
}

-(void)SetImage3:(CGImageRef)image
{
    if(m_Image3 != NULL)
        CGImageRelease(m_Image3);
    
    m_Image3 = image;
}

-(void)ResetImages
{
    if(m_Image1 != NULL)
    {    
        CGImageRelease(m_Image1);
        m_Image1 = NULL;
    }
    if(m_Image2 != NULL)
    {    
        CGImageRelease(m_Image2);
        m_Image2 = NULL;
    }
    if(m_Image3 != NULL)
    {    
        CGImageRelease(m_Image3);
        m_Image3 = NULL;
    }
    /*if(m_Image4 != NULL)
    {    
        CGImageRelease(m_Image4);
        m_Image4 = NULL;
    }*/
}

-(void)dealloc
{
    [self ResetImages];
    [super dealloc];
}

@end
