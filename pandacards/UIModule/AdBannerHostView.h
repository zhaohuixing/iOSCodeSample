//
//  AdBannerHostView.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-02.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AdViewConstants.h"
#import "MainApplicationDelegateTemplate.h"
#import "CustomDummyAlertView.h"

@class iAdViewHolder;
@class MobclixAdViewHolder;
@class GoogleAdViewHolder;

@interface AdBannerHostView : UIView<AdViewHolderDelegate>
{
    id<AdRequestHandlerDelegate>        m_Delegate;
    iAdViewHolder*                      m_iADView;
    MobclixAdViewHolder*                m_MobclixView;
    GoogleAdViewHolder*                 m_GoogleView;
    int                                 m_nCurrentAdType;
    BOOL                                m_bCountTimer;
    NSTimeInterval                      m_TimerStart;
    BOOL                                m_bPaused;

    CustomDummyAlertView*           m_AlertView;
    float                           m_TimerCount;
}

-(void)AdViewClicked:(int)nType;
-(void)AdViewClosed:(int)nType;
-(void)AdViewLoaded:(int)nType;
-(void)AdViewFailed;
-(void)RegisterDelegate:(id<AdRequestHandlerDelegate>)delegate;
-(void)Start;
-(void)OnTimerEvent;
-(void)PauseAd;
-(void)ResumeAd;
-(void)SetAlertMessage:(NSString*)text;

@end
