//
//  MainUIController.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainApplicationDelegateTemplate.h"
@class MainUIView;


@interface MainUIController : UIViewController<AdRequestHandlerDelegate> 
{
	MainUIView*				m_MainView;
    
@private
    NSString*               m_CachedAdPostURL;
    int                     m_nRepostLimit;
    int                     m_nRepostCount;
    int                     m_nRepostTimerInterval;
    int                     m_nRepostTimerCount;
	NSURLConnection*        m_URLConnection;
}

- (void)HandleAdRequest:(NSURL*)url;
- (void)AdViewClicked;
- (void)DismissExtendAdView;
- (void)InterstitialAdViewClicked;
- (void)CloseRedeemAdView;

- (NSString*)GetCachedAdPost;
- (int)GetRepostLimit;
- (void)SetRepostLimit:(int)nLimit;
- (int)GetRepostCount;
- (int)GetRepostTimerInterval;
- (void)SetRepostTimerInterval:(int)nTiming;

- (void)OnAdRepostHandlingTimer;
- (void)ResendAdRequest;

@end
