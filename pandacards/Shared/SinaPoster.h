//
//  SinaPoster.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WeiboClient.h"
#import "OAuthEngine.h"
#import "OAuthController.h"
#import "SinaTPostView.h"

@interface SinaPoster : NSObject <OAuthControllerDelegate>
{
	OAuthEngine*							m_Engine;
	SinaTPostView*							m_PostView;
}

-(void)SinaTShareActionLastWin;	
-(void)SinaTShareActionTotalWin;	

- (void)PostSinaTweet:(NSString*)gameTitle withMessage:(NSString*)gameMsg withImage:(NSString*)gameIcon withURL:(NSString*)gameURL;
- (void)FollowMe;
- (void)LoadSinTEngine;
- (void)Dismiss;

- (void)Authenticate;

- (id)initWithParent:(UIView*)parent withFrame:(CGRect)frame;
- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh;

@end
