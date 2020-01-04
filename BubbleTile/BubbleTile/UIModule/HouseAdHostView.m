//
//  HouseAdHostView.m
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-10-20.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "HouseAdHostView.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"
#include "drawhelper.h"

//Lucky Compass 
#define HOUSE_AD1_URL_ZH            @"http://itunes.apple.com/us/app/compass-luck-chinese-version/id360529479?ls=1&mt=8"
#define HOUSE_AD1_URL               @"http://itunes.apple.com/us/app/compass-of-luck/id356446633?ls=1&mt=8"
#define HOUSE_AD1_ICON_1            @"lcicon1.png"
#define HOUSE_AD1_ICON_2            @"lcicon2.png"
#define HOUSE_AD1_ICON_3            @"lcicon3.png"
#define HOUSE_AD1_ICON_4            @"lcicon4.png"

//Mind Fire
#define HOUSE_AD2_URL               @"http://itunes.apple.com/us/app/panda-cards/id517550842"
#define HOUSE_AD2_ICON_1            @"mficon1.png"
#define HOUSE_AD2_ICON_2            @"mficon2.png"
#define HOUSE_AD2_ICON_3            @"mficon3.png"
#define HOUSE_AD2_ICON_4            @"mficon4.png"

//Flying Cow Chinese
#define HOUSE_AD3_URL_ZH               @"http://itunes.apple.com/us/app/id391435459?ls=1&mt=8"
#define HOUSE_AD3_URL               @"http://itunes.apple.com/us/app/flying-cow-chuiniu-lite-version/id396255432?ls=1&mt=8"
#define HOUSE_AD3_ICON_1            @"cowicon1.png"
#define HOUSE_AD3_ICON_2            @"cowicon2.png"
#define HOUSE_AD3_ICON_3            @"cowicon3.png"
#define HOUSE_AD3_ICON_4            @"cowicon2.png"


//Gamble Wheel
#define HOUSE_AD4_URL               @"http://itunes.apple.com/us/app/easy-gamble-wheel/id492115652?ls=1&mt=8"
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
    if([ApplicationConfigure IsChineseVersion])
        [m_AdViews[0] SetURL:HOUSE_AD1_URL_ZH];
    else
        [m_AdViews[0] SetURL:HOUSE_AD1_URL];
    [m_AdViews[0] LoadImages:HOUSE_AD1_ICON_1 image2:HOUSE_AD1_ICON_2 image3:HOUSE_AD1_ICON_3 image4:HOUSE_AD1_ICON_4];
    [self addSubview:m_AdViews[0]];
    [m_AdViews[0] release];

    m_AdViews[1] = [[HouseAdView alloc] initWithFrame:rect];
    [m_AdViews[1] SetURL:HOUSE_AD2_URL];
    [m_AdViews[1] LoadImages:HOUSE_AD2_ICON_1 image2:HOUSE_AD2_ICON_2 image3:HOUSE_AD2_ICON_3 image4:HOUSE_AD2_ICON_4];
    [self addSubview:m_AdViews[1]];
    [m_AdViews[1] release];
    
    m_AdViews[2] = [[HouseAdView alloc] initWithFrame:rect];
    if([ApplicationConfigure IsChineseVersion])
        [m_AdViews[2] SetURL:HOUSE_AD3_URL_ZH];
    else
        [m_AdViews[2] SetURL:HOUSE_AD3_URL];
    [m_AdViews[2] LoadImages:HOUSE_AD3_ICON_1 image2:HOUSE_AD3_ICON_2 image3:HOUSE_AD3_ICON_3 image4:HOUSE_AD3_ICON_4];
    [self addSubview:m_AdViews[2]];
    [m_AdViews[2] release];

    m_AdViews[3] = [[HouseAdView alloc] initWithFrame:rect];
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

@end
