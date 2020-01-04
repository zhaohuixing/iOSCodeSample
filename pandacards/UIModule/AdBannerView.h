//
//  AdBannerView.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobclixAds.h"
//#import "AdMobDelegateProtocol.h"
#import "MobclixFullScreenAdViewController.h"
#import "GADBannerView.h"


@interface AdBannerView : UIView <MobclixAdViewDelegate, MobclixFullScreenAdDelegate, GADBannerViewDelegate>
{
    //iPhone Adview
	MobclixAdViewiPhone_300x250*            m_iPhoneBigAdViewMobclix;
	MobclixFullScreenAdViewController*      m_MobClixFS;
    BOOL                                    m_bAutoHide;
	
    //iPad Adview
	MobclixAdViewiPad_300x250*		m_iPadBigAdViewMobclix[2];
    GADBannerView*                  m_AdmobView300x250[2];
}

-(BOOL)CanAutoHide;
-(void)ShowAd;
-(void)HideAd;

-(void)ShowiPhoneAd;
-(void)ShowiPadAd;
-(void)HideiPhoneAd;
-(void)HideiPadAd;

-(void)ResumeAd;
-(void)PauseAd;

@end
