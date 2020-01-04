//
//  QQPoster.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "QQPoster.h"
#import "ApplicationConfigure.h"
#import "CustomModalAlertView.h"
#import "StringFactory.h"
#import "ScoreRecord.h"
#import "QOauthConfigure.h"
#import "QWeiboSyncApi.h"
#import "QWeiboAsyncApi.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "StringFactory.h"

@implementation QQPoster


- (void)Dismiss
{
    [m_PostView.superview sendSubviewToBack: m_PostView];
    m_PostView.hidden = YES;
}

- (void)PostQQTweet:(NSString*)gameTitle
		withMessage:(NSString*)gameMsg
		  withImage:(NSString*)gameIcon
			withURL:(NSString*)gameURL
{
    m_PostView.hidden = NO;
    [m_PostView.superview bringSubviewToFront:m_PostView];
	[self LoadQQTEngine];
	[m_PostView PostQQTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}	


-(void)QQTPostScore:(NSString*)sScore
{
	BOOL bDefault = NO;
	NSString *gameURL = [StringFactory GetString_GameURL];
	
	NSString *gameTitle = [NSString stringWithFormat:@"%@ [%@ ]", [StringFactory GetString_GameTitle:bDefault], gameURL];//[jsonWriter stringWithObject:actionLinks];
	
	NSString* gameIcon;
	
	gameIcon = [[NSBundle mainBundle] pathForResource:@"feiniu.png" ofType:nil];
	
	
	[self PostQQTweet:gameTitle withMessage:sScore withImage:gameIcon withURL:gameURL];
}

- (void)QQLoginFailed:(id)sender
{
	[CustomModalAlertView SimpleSay:@"未能登录QQ微博帐户,不能发布微博!" closeButton:[StringFactory GetString_Close]];
	[self Dismiss];
	return;
}	

- (void)QQLoginSucceed:(id)sender
{
    [m_PostView SetInitialized];
    [m_PostView SetCloseButtonEnable:YES];
	return;
}	

- (id)initWithParent:(UIView*)parent withFrame:(CGRect)frame;
{
    self = [super init];
    if(self)
    {
        m_LoginView = [[QQLoginView alloc] initWithFrame:frame];
        m_LoginView.backgroundColor = [UIColor whiteColor];
        
        m_PostView = [[QQTPostView alloc] initWithFrame:frame];
        m_PostView.backgroundColor = [UIColor lightGrayColor];
        [m_PostView SetCloseButtonEnable:NO];
        [m_PostView addSubview: m_LoginView];
        [m_LoginView release];
        [m_PostView sendSubviewToBack:m_LoginView];
        m_LoginView.hidden = YES;

        [parent addSubview: m_PostView];
        [m_PostView release];
        [parent sendSubviewToBack:m_PostView];
        m_PostView.hidden = YES;
        
		[GUIEventLoop RegisterEvent:GUIID_EVENT_QQLOGINFAILED eventHandler:@selector(QQLoginFailed:) eventReceiver:self eventSender:m_LoginView];
		[GUIEventLoop RegisterEvent:GUIID_EVENT_QQLOGINSUCCEED eventHandler:@selector(QQLoginSucceed:) eventReceiver:self eventSender:m_LoginView];
    }
    
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)LoginQQWebsite
{
    m_LoginView.hidden = NO;
	[m_PostView bringSubviewToFront:m_LoginView];
	[m_LoginView setNeedsDisplay];
	[m_LoginView Login];
	
}	

- (void)LoadQQTEngine
{
	NSString* szTokeKey = [QOauthConfigure GetTokenKey];
	NSString* szTokeSecret = [QOauthConfigure GetTokenSecret];
	
	if(szTokeKey == nil || [szTokeKey isEqualToString:@""] || 
	   szTokeSecret == nil || [szTokeKey isEqualToString:@""])
	{
		QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
		NSString *retString = [api getRequestTokenWithConsumerKey:[QOauthConfigure GetAppKey] consumerSecret:[QOauthConfigure GetAppSecret]];
		
		[QOauthConfigure ParseTokenKeyWithResponse:retString];
		
		[self LoginQQWebsite];
		[m_PostView SetCloseButtonEnable:YES];
	}	
	else 
	{
		[m_PostView SetInitialized];
		[m_PostView SetCloseButtonEnable:YES];
	}
}	

- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh
{
    [m_LoginView AdjusetViewLocation:nw withHeight:nh];
    [m_PostView AdjusetViewLocation:nw withHeight:nh];
}

@end
