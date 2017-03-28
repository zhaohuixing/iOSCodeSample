//
//  AdBannerHostView.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <GoogleMobileAds/GADBannerView.h>

@interface AdBannerHostView : UIView<GADBannerViewDelegate, ADBannerViewDelegate>
{
@private
    ADBannerView*                       m_AdView;
    GADBannerView*                      m_AdmobView;
    BOOL                                m_bShowIAD;
}

-(void)UpdateLayout;

@end
