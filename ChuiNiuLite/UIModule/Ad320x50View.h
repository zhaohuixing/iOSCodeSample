//
//  Ad320x50View.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobclixAds.h"
#import "GADBannerView.h"
#import "CustomDummyAlertView.h"

@interface Ad320x50View : UIView <MobclixAdViewDelegate, GADBannerViewDelegate>
{
	//iPhone
    MobclixAdViewiPhone_320x50*		m_iPhoneAdViewMobclix1; //Mobclix adview
    GADBannerView*                  m_AdmobView320;
	
    //iPad Adview
	MobclixAdViewiPad_728x90*		m_iPadAdViewMobclix1;
	MobclixAdViewiPad_728x90*		m_iPadAdViewMobclix2;
    MobclixAdViewiPad_468x60*       m_iPadSmallAdViewMobclix1;
    MobclixAdViewiPad_468x60*       m_iPadSmallAdViewMobclix2;

    GADBannerView*                  m_AdmobView468_1;
    GADBannerView*                  m_AdmobView468_2;
    GADBannerView*                  m_AdmobView728_1;
    GADBannerView*                  m_AdmobView728_2;
    CustomDummyAlertView*           m_AlertView;
    float                           m_TimerCount;
}

-(id)initAdViewWithFrame:(CGRect)frame enableMobFox:(BOOL)bEnable;
-(void)OnOrientationChange;
-(void)ResumeAd;
-(void)PauseAd;
-(void)OnTimerEvent;
-(void)SetAlertMessage:(NSString*)text;


@end
