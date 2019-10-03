//
//  MobclixAdViewHolder.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 2011-11-03.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AdViewConstants.h"
#import "MobclixAds.h"

@interface MobclixAdViewHolder : UIView <AdViewTemplate, MobclixAdViewDelegate>
{
	//iPhone
    MobclixAdViewiPhone_320x50*		m_iPhoneAdViewMobclix; //Mobclix adview
	
    //iPad Adview
	MobclixAdViewiPad_728x90*		m_iPadAdViewMobclix;
    MobclixAdViewiPad_468x60*       m_iPadSmallAdViewMobclix;

    id<AdViewHolderDelegate>        m_Delegate;
    
    BOOL                            m_bClicked;
}

@property(nonatomic, assign)id<AdViewHolderDelegate>    m_Delegate;

-(void)CloseAdView;
-(void)OpenAdView;
-(void)PauseAd;
-(void)ResumeAd;

@end
