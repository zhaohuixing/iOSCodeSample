//
//  ExtendAdView.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FrameView.h"

@interface ExtendAdView : FrameView<UIWebViewDelegate>
{
@private
    UIWebView*       m_InternalWebView;
    BOOL             m_bDisplay;
    NSTimeInterval   m_StartTime;
}

- (void)OpenWebPage:(NSURL*)url withAnimation:(BOOL)bAnimation;
- (BOOL)IsDisplay;
- (void)OnTimerEvent;

@end
