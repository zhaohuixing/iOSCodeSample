//
//  HouseAdView.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-17.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "HouseAdView.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"
#import "ImageLoader.h"
#import "GameCenterConstant.h"
#include "drawhelper.h"

#define ADPICTUREDISPLAYCOUNT           10
@implementation HouseAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        m_adURL = nil;
        for(int i = 0; i < 4; ++i)
            m_AppIcon[i] = NULL;
        
        m_nImage = 0;
        m_nShowTime = ADPICTUREDISPLAYCOUNT;
        m_nTimerCount = 0;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)dealloc
{
    if(m_adURL != nil)
    {
        [m_adURL release];
    }
    for(int i = 0; i < 4; ++i)
    {
        if(m_AppIcon[i] != NULL)
            CGImageRelease(m_AppIcon[i]);
    }
    [super dealloc];
}

-(void)SetURL:(NSString*)strURL
{
    m_adURL = [[NSURL URLWithString:strURL] retain];
}

-(void)LoadImages:(NSString*)file1 image2:(NSString*)file2 image3:(NSString*)file3 image4:(NSString*)file4
{
    m_AppIcon[0] = [ImageLoader LoadImageWithName:file1];
    m_AppIcon[1] = [ImageLoader LoadImageWithName:file2];
    m_AppIcon[2] = [ImageLoader LoadImageWithName:file3];
    m_AppIcon[3] = [ImageLoader LoadImageWithName:file4];
}

-(void)OnTimerEvent
{
    ++m_nTimerCount;
    if(m_nShowTime <= m_nTimerCount)
    {
        m_nTimerCount = 0;
        m_nImage = (m_nImage+1)%4;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    if( 0 <= m_nImage && m_nImage < 4 && m_AppIcon[m_nImage] != NULL)
    {
        CGContextSaveGState(context);
        AddRoundRectToPath(context, rect, CGSizeMake(8, 8), 0.5);
        CGContextClip(context);
        CGContextDrawImage(context, rect, m_AppIcon[m_nImage]);
        CGContextRestoreGState(context);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [ApplicationConfigure EnableLaunchHouseAd];
    [[UIApplication sharedApplication] openURL:m_adURL];
}

@end
