//
//  RedeemClickAdHostView.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 2011-11-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AdViewConstants.h"
#import "MainApplicationDelegateTemplate.h"
#import "RectAdViewHolder.h"
#import "RectAdViewHolderMM.h"

//@class FullScreenAdViewHolder;
@class RectAdViewHolder;


@interface MyClickTroughLabel : UILabel
{
   
}

@end

@interface RedeemClickAdHostView : UIView<AdViewHolderDelegate, AdInterstitialHolderDelegate>
{
    id<AdRequestHandlerDelegate>        m_Delegate;
    RectAdViewHolder*                   m_RectAdBanner;
    RectAdViewHolder*                   m_RectAdBannerGoogle_iPAD;
    RectAdViewHolderMM*                 m_RectAdBannerMM_iPAD;
    //RectAdViewHolderMM*                 m_RectAdBannerMM_iPAD2;
    RectAdViewHolder*                   m_RectAdBannerGoogle_iPAD2;
    
    MyClickTroughLabel*                 m_Label;
    BOOL                                m_bPaused;
    UILabel*                            m_NetWarnLabel;

    
    int                                 m_nRedeemType;
    
    int                                 m_nRedeemClickThreshold;
    int                                 m_nRedeemClickCount;
    
    int                                 m_nPostPoint;
    int                                 m_nPostSpeed;
    int                                 m_nPostScore;
}

-(void)RegisterDelegate:(id<AdRequestHandlerDelegate>)delegate;
-(void)AdViewClicked:(int)nType;
-(void)AdViewClosed:(int)nType;
-(void)AdViewLoaded:(int)nType;
-(void)AdViewFailed;
-(void)AdLoadSucceed;
-(void)AdLoadFailed;
-(void)StartShowAd;
-(void)StopShowAd;
-(void)OnTimerEvent;
//-(void)SetPlayerName:(NSString*)szName;
-(void)PauseAd;
-(void)ResumeAd;
-(void)RedeemAdViewClosed;
-(void)FinishRedeem;

-(void)SetRedeemType:(int)nType;
-(void)SetScorePost:(int)nScore withPoint:(int)nPoint withSpeed:(int)nSpeed;

@end
