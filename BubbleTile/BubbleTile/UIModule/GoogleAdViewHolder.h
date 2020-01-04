//
//  GoogleAdViewHolder.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-05.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdViewConstants.h"
#import "GADBannerView.h"


@interface GoogleAdViewHolder : UIView <AdViewTemplate, GADBannerViewDelegate>
{
    //For both iPhone and iPad
    GADBannerView*                  m_AdmobView;
    
    //For iPad only
    GADBannerView*                  m_AdmobView728;
    
    id<AdViewHolderDelegate>        m_Delegate;
    BOOL                            m_bClicked;
}

@property(nonatomic, assign)id<AdViewHolderDelegate>    m_Delegate;

-(void)CloseAdView;
-(void)OpenAdView;
-(void)PauseAd;
-(void)ResumeAd;

@end
