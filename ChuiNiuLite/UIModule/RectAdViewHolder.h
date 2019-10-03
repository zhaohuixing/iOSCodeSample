//
//  RectAdViewHolder.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdViewConstants.h"
#import "MobclixAds.h"
#import "GADBannerView.h"

@interface RectAdViewHolder : UIView<AdViewTemplate, GADBannerViewDelegate, MobclixAdViewDelegate>
{
    id<AdViewHolderDelegate>        m_Delegate;
    
    MobclixAdView*                  m_MobclixAd;
    GADBannerView*                  m_GoogleAd;
  
    int                             m_nPrevAdType;
    int                             m_nCurrentType;
    
    BOOL                            m_bGoogleAdClicked;

    //UILabel*                        m_Label;
    //BOOL                            m_bShowCongratulation;
    //NSTimeInterval                  m_TimeStartShowCongratulation;
    NSTimeInterval                  m_TimeStartLoadAd;
    //UIActivityIndicatorView*        m_Spinner;
    BOOL                            m_bAdViewIdle;
    BOOL                            m_bStartLoadAd;
}

@property(nonatomic, assign)id<AdViewHolderDelegate>    m_Delegate;

-(void)CloseAdView;
-(void)OpenAdView;
-(void)OpenAdViewGoogleFirst;
-(void)OnTimerEvent;
-(void)TryNextAdUnit;
-(void)PauseAd;
-(void)ResumeAd;
@end
