//
//  QQPoster.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "QQLoginView.h"
#import "QQTPostView.h"

@interface QQPoster : NSObject
{
	QQTPostView*							m_PostView;
	QQLoginView*							m_LoginView;

    BOOL                                    m_bTellFriend;
}

- (id)initWithParent:(UIView*)parent withFrame:(CGRect)frame;

-(void)QQTShareActionLastWin;
-(void)QQTShareActionTotalWin;	
-(void)QQTShareActionTellFriendInStealthMode;

- (void)PostQQTweet:(NSString*)gameTitle withMessage:(NSString*)gameMsg withImage:(NSString*)gameIcon withURL:(NSString*)gameURL;
//- (void)FollowMe;
- (void)LoadQQTEngine;
- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh;
- (void)SetStealthMode;
@end
