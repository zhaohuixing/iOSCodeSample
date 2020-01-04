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

- (NSString*)GetCachedAdPost;
- (int)GetRepostLimit;
- (void)SetRepostLimit:(int)nLimit;
- (int)GetRepostCount;
- (int)GetRepostTimerInterval;
- (void)SetRepostTimerInterval:(int)nTiming;

- (void)OnAdRepostHandlingTimer;
- (void)ResendAdRequest;

- (void)HandleFreeVersionOnlineOption;
- (void)HandleFreeVersionGameCenterScorePost:(int)nScore withPoint:(int)nPoint withSpeed:(int)nSpeed;
- (void)HandleFreeVersionOnlineInvitation;

-(void)CompleteFacebookFeedMySelf;
-(void)CompleteFacebookSuggestToFriends;

@end
