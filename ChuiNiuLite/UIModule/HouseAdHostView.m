//
//  HouseAdHostView.m
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-10-20.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "HouseAdHostView.h"
#import "GUILayout.h"
#include "drawhelper.h"
#import "ApplicationConfigure.h"

//Lucky Compass 
#define HOUSE_AD1_URL               @"xxxxxxxxxxxx"

#define HOUSE_AD1_URL_91COM         @"xxxxxxxxxxxx"

#define HOUSE_AD1_ICON_1            @"lcicon1.png"
#define HOUSE_AD1_ICON_2            @"lcicon2.png"
#define HOUSE_AD1_ICON_3            @"lcicon3.png"
#define HOUSE_AD1_ICON_4            @"lcicon4.png"


//Bubble Tile
#define HOUSE_AD2_URL               @"xxxxxxxxxxxx"

#define HOUSE_AD2_URL_91COM         @"xxxxxxxxxxxx"

#define HOUSE_AD2_ICON_1            @"bticon1.png"
#define HOUSE_AD2_ICON_2            @"bticon2.png"
#define HOUSE_AD2_ICON_3            @"bticon3.png"
#define HOUSE_AD2_ICON_4            @"bticon4.png"

//Mind Fire
#define HOUSE_AD3_URL               @"xxxxxxxxxxxx"

#define HOUSE_AD3_URL_91COM         @"xxxxxxxxxxxx"

#define HOUSE_AD3_ICON_1            @"mficon1.png"
#define HOUSE_AD3_ICON_2            @"mficon2.png"
#define HOUSE_AD3_ICON_3            @"mficon3.png"
#define HOUSE_AD3_ICON_4            @"mficon4.png"

//Gamble Wheel
#define HOUSE_AD4_URL               @"xxxxxxxxxxxx"

#define HOUSE_AD4_URL_91COM         @"xxxxxxxxxxxx"

#define HOUSE_AD4_ICON_1            @"egwicon1.png"
#define HOUSE_AD4_ICON_2            @"egwicon2.png"
#define HOUSE_AD4_ICON_3            @"egwicon3.png"
#define HOUSE_AD4_ICON_4            @"egwicon4.png"

#define HOUSE_AD_SHOWTIME           20

@implementation HouseAdHostView


- (void)initHouseAds
{
    float fSize = [GUILayout GetHouseAdViewSize];
    CGRect rect = CGRectMake(0, 0, fSize, fSize);
    m_AdViews[0] = [[HouseAdView alloc] initWithFrame:rect];
    if([ApplicationConfigure IsFor91DotCom])
        [m_AdViews[0] SetURL:HOUSE_AD1_URL_91COM];
    else    
        [m_AdViews[0] SetURL:HOUSE_AD1_URL];
    [m_AdViews[0] LoadImages:HOUSE_AD1_ICON_1 image2:HOUSE_AD1_ICON_2 image3:HOUSE_AD1_ICON_3 image4:HOUSE_AD1_ICON_4];
    [self addSubview:m_AdViews[0]];
    [m_AdViews[0] release];

    m_AdViews[1] = [[HouseAdView alloc] initWithFrame:rect];
    if([ApplicationConfigure IsFor91DotCom])
        [m_AdViews[1] SetURL:HOUSE_AD2_URL_91COM];
    else    
        [m_AdViews[1] SetURL:HOUSE_AD2_URL];
    [m_AdViews[1] LoadImages:HOUSE_AD2_ICON_1 image2:HOUSE_AD2_ICON_2 image3:HOUSE_AD2_ICON_3 image4:HOUSE_AD2_ICON_4];
    [self addSubview:m_AdViews[1]];
    [m_AdViews[1] release];
    
    m_AdViews[2] = [[HouseAdView alloc] initWithFrame:rect];
    if([ApplicationConfigure IsFor91DotCom])
        [m_AdViews[2] SetURL:HOUSE_AD3_URL_91COM];
    else    
        [m_AdViews[2] SetURL:HOUSE_AD3_URL];
    [m_AdViews[2] LoadImages:HOUSE_AD3_ICON_1 image2:HOUSE_AD3_ICON_2 image3:HOUSE_AD3_ICON_3 image4:HOUSE_AD3_ICON_4];
    [self addSubview:m_AdViews[2]];
    [m_AdViews[2] release];

    m_AdViews[3] = [[HouseAdView alloc] initWithFrame:rect];
    if([ApplicationConfigure IsFor91DotCom])
        [m_AdViews[3] SetURL:HOUSE_AD4_URL_91COM];
    else    
        [m_AdViews[3] SetURL:HOUSE_AD4_URL];
    [m_AdViews[3] LoadImages:HOUSE_AD4_ICON_1 image2:HOUSE_AD4_ICON_2 image3:HOUSE_AD4_ICON_3 image4:HOUSE_AD4_ICON_4];
    [self addSubview:m_AdViews[3]];
    [m_AdViews[3] release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self initHouseAds];
        m_nActiveAd = 0;
        self.backgroundColor = [UIColor clearColor];
        [self bringSubviewToFront:m_AdViews[m_nActiveAd]];
        for(int i = 0; i < 4; ++i)
        {
            if(i == m_nActiveAd)
            {
                m_AdViews[i].hidden = NO;
            }
            else
            {
                m_AdViews[i].hidden = YES;
            }
        }
        [m_AdViews[m_nActiveAd] setNeedsDisplay];
        m_StartTime = [[NSProcessInfo processInfo] systemUptime];
    }
    return self;
}

- (void)SwitchAd
{
    m_StartTime = [[NSProcessInfo processInfo] systemUptime];
    m_nActiveAd = (m_nActiveAd+1)%4;
    [self bringSubviewToFront:m_AdViews[m_nActiveAd]];
    for(int i = 0; i < 4; ++i)
    {
        if(i == m_nActiveAd)
        {
            m_AdViews[i].hidden = NO;
        }
        else
        {
            m_AdViews[i].hidden = YES;
        }
    }
}

- (void)OnTimerEvent
{
    [m_AdViews[m_nActiveAd] OnTimerEvent];
    NSTimeInterval curTime = [[NSProcessInfo processInfo] systemUptime];
    if(HOUSE_AD_SHOWTIME <= (curTime - m_StartTime))
    {
        [self SwitchAd];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    AddRoundRectToPath(context, rect, CGSizeMake(8, 8), 0.5);
    CGContextClip(context);

    CGGradientRef gradientFill;
    CGColorSpaceRef fillColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat colors[8] = 
    {
        0.0, 0.0, 0.5, 1.0,
        0.5, 0.5, 1.0, 1.0, 
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
    CGGradientRelease(gradientFill);
    
    CGContextRestoreGState(context);
}


@end
