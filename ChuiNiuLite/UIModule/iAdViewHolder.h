//
//  iAdViewHolder.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AdViewConstants.h"
#import "MMAdView.h"
#import "MobFox/MobFoxBannerView.h"

@interface iAdViewHolder : UIView<AdViewTemplate, MobFoxBannerViewDelegate, MMAdDelegate>
{
    id<AdViewHolderDelegate>    m_Delegate;
    BOOL                        m_bProtraitOnly;
@private
    MobFoxBannerView*          m_MobFoxBannerView;
    MMAdView*                   m_MMAdView;
}
@property(nonatomic, assign)id<AdViewHolderDelegate>    m_Delegate;
@property(nonatomic, assign)BOOL                        m_bProtraitOnly;

-(void)CloseAdView;
-(void)OpenAdView;
-(void)PauseAd;
-(void)ResumeAd;
@end
