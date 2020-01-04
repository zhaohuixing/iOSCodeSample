//
//  PreviewView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "PreviewView.h"
#import "GUILayout.h"
#import "GameLayout.h"
#import "RenderHelper.h"
#import "ApplicationConfigure.h"

///////////////////////////////////
//
@implementation PreviewView
//
///////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float centerx = self.frame.size.width/2.0;
        float centery = self.frame.size.height/2.0;
        float fSzie = [GameLayout GetDefaultPreviewImageSize];
        CGRect rect = CGRectMake(centerx-fSzie/2.0, centery-fSzie/2.0, fSzie, fSzie);
        m_Preview = [[PreviewUI alloc] initWithFrame:rect];
        m_Preview.hidden = YES;
        [self addSubview:m_Preview];
        [m_Preview release];
    }
    return self;
}

-(void)UpdateSubViewsOrientation
{
    float centerx = self.frame.size.width/2.0;
    float centery = self.frame.size.height/2.0;
    [m_Preview setCenter:CGPointMake(centerx, centery)];
    [m_Preview setNeedsDisplay];
}

-(void)CloseView
{
    [self.superview sendSubviewToBack:self];
    self.hidden = YES;
}

-(void)OpenView
{
    [self.superview bringSubviewToFront:self];
    self.hidden = NO;
    [m_Preview OpenView:YES];
    [m_Preview setNeedsDisplay];
}

-(void)SetPreview:(CGImageRef)image withLevel:(BOOL)bEasy
{
    [m_Preview SetPreview:image withLevel:bEasy];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

///////////////////////////////////
//
@implementation PreviewUI
//
///////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_Preview = NULL;
        m_bEasy = NO;
    }
    return self;
}

- (void)dealloc
{
    if(m_Preview)
    {
        CGImageRelease(m_Preview);
        m_Preview = NULL;
    }
    [super dealloc];
}

-(void)SetPreview:(CGImageRef)image withLevel:(BOOL)bEasy
{
    if(m_Preview)
    {
        CGImageRelease(m_Preview);
        m_Preview = NULL;
    }
    m_Preview = image;
    m_bEasy = bEasy;
    [self setNeedsDisplay];
}

- (void)drawPreview:(CGContextRef)context inRect:(CGRect)rect
{
    float fRatio = 0.8;
    if([ApplicationConfigure iPADDevice])
        fRatio = 0.85;
    
    float centerx = self.frame.size.width/2.0;
    float centery = self.frame.size.height/2.0;
    
    float fSize = self.frame.size.width - [GUILayout GetDefaultAlertUIEdge]*2.0;
    float fImageSize = fSize*fRatio;
    centery += fSize*(1.0-fRatio)/4.0;
    
    float fIndicatorSize = centery-fImageSize/2.0-[GUILayout GetDefaultAlertUIEdge];
    float fIndicatorImageSize = fIndicatorSize*0.8; 
    
    CGRect rt = CGRectMake(centerx-fImageSize/2.0, centery-fImageSize/2.0, fImageSize, fImageSize);
    CGContextDrawImage(context, rt, m_Preview);
    rt = CGRectMake(centerx-fIndicatorImageSize/2.0, [GUILayout GetDefaultAlertUIEdge]+(fIndicatorSize-fIndicatorImageSize)/2.0, fIndicatorImageSize, fIndicatorImageSize);
    if(m_bEasy)
        [RenderHelper DrawGreenIndicator:context at:rt];
    else 
        [RenderHelper DrawRedIndicator:context at:rt];
}

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
     // Drawing code
     CGContextRef context = UIGraphicsGetCurrentContext();
     [self drawBackground:context inRect: rect];
     if(m_Preview)
         [self drawPreview:context inRect: rect];
 }

- (void)OnViewClose
{
    [super OnViewClose];
    [((PreviewView*)self.superview) CloseView];
}
@end
