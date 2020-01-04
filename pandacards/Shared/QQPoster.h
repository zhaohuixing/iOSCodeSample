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
}

- (id)initWithParent:(UIView*)parent withFrame:(CGRect)frame;

-(void)QQTPostScore:(NSString*)sScore;

- (void)PostQQTweet:(NSString*)gameTitle withMessage:(NSString*)gameMsg withImage:(NSString*)gameIcon withURL:(NSString*)gameURL;
//- (void)FollowMe;
- (void)LoadQQTEngine;
- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh;
@end
