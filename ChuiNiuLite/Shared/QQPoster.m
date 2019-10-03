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
#import "StringFactory.h"
#import "Configuration.h"
#import "ScoreRecord.h"
#import "QOauthConfigure.h"
#import "QWeiboSyncApi.h"
#import "QWeiboAsyncApi.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "CustomModalAlertView.h"

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


- (void)QQTShareActionLastWin
{
	BOOL bDefault = NO;
	NSString *gameURL = [StringFactory GetString_GameURL];
	
	NSString *gameTitle = [NSString stringWithFormat:@"%@ [%@ ]", [StringFactory GetString_GameTitle:bDefault], gameURL];//[jsonWriter stringWithObject:actionLinks];
	
	NSString* gameIcon;
	
	NSString* szTitle =  [StringFactory GetString_MyLastWin:bDefault];
	NSString* szBody = @"";
	int nSkill = [ScoreRecord getLastWinSkill];
	int nLevel = [ScoreRecord getLastWinLevel];
	
	if(nSkill == -1 || nLevel == -1)
	{
		//[ModalAlert say:[StringFactory GetString_NoRecordPostWarn:NO]];
        [CustomModalAlertView SimpleSay:[StringFactory GetString_NoRecordPostWarn:NO] closeButton:[StringFactory GetString_Close]];
		return;
	}	
	NSString* szSkill = [StringFactory GetString_SkillString:nSkill withDefault:bDefault];
	NSString* szLevel = [StringFactory GetString_LevelString:nLevel withDefault:bDefault];
	szBody = [NSString stringWithFormat:@"%@/%@", szLevel, szSkill];
	gameIcon = [[NSBundle mainBundle] pathForResource:@"feiniu.png" ofType:nil];
	
	
	NSString* gameMsg = [NSString stringWithFormat:@"%@: %@. 我不吹,牛不飞!!!", szTitle, szBody];
	[self PostQQTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}

- (void)QQTShareActionTotalWin	
{
	BOOL bDefault = NO;
	NSString *gameURL = [StringFactory GetString_GameURL];
	NSString *gameTitle = [NSString stringWithFormat:@"%@ [%@ ]", [StringFactory GetString_GameTitle:bDefault], gameURL];//[jsonWriter stringWithObject:actionLinks];
	
	NSString* szTitle = [StringFactory GetString_MyTotalWin:bDefault];
	NSString* szBody = @"";
	NSString* gameIcon;
	
	BOOL bHasRecord = NO;
	
	NSString* szSkill = @"";//[StringFactory GetString_SkillString:nSkill withDefault:bUseEn];
	NSString* szLevel = @"";//[StringFactory GetString_LevelString:nLevel withDefault:bUseEn];
	NSString* szScore = @"";//[StringFactory GetString_LevelString:nLevel withDefault:bUseEn];
	int nScore = 0;
	for(int i = GAME_PLAY_LEVEL_ONE; i <= GAME_PLAY_LEVEL_FOUR; ++i)
	{
		szLevel = [StringFactory GetString_LevelString:i withDefault:bDefault];
		for(int j = GAME_SKILL_LEVEL_ONE; j <= GAME_SKILL_LEVEL_THREE; ++j)
		{
			szSkill = [StringFactory GetString_SkillString:j withDefault:bDefault];
			nScore = [ScoreRecord getScore:j atLevel:i];
			if(0 < nScore)
			{
				szScore = [NSString stringWithFormat:@"%@/%@=%i.  ", szLevel, szSkill, nScore];
				bHasRecord = YES;	
				szBody = [szBody stringByAppendingString:szScore]; 
			}	
		}	
	}	
	
	if(bHasRecord == NO)
	{
		//[ModalAlert say:[StringFactory GetString_NoRecordPostWarn:NO]];
        [CustomModalAlertView SimpleSay:[StringFactory GetString_NoRecordPostWarn:NO] closeButton:[StringFactory GetString_Close]];
		return;
	}	
	gameIcon = [[NSBundle mainBundle] pathForResource:@"feiniu.png" ofType:nil];
	
	NSString* gameMsg = [NSString stringWithFormat:@"%@: %@ 我不吹,牛不飞!!!", szTitle, szBody];
	
	[self PostQQTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}	


-(void)StealthPostTellFriend
{
	BOOL bDefault = NO;
	NSString *gameURL = [StringFactory GetString_GameURL];
	NSString *gameTitle = [NSString stringWithFormat:@"%@ [%@ ]", [StringFactory GetString_GameTitle:bDefault], gameURL];
	
	NSString* szTitle = @"强力推荐“吹牛大王，狗吹牛”游戏";
	NSString* szBody = @"我很喜欢“吹牛大王，狗吹牛”游戏，向大家隆重推荐！";
	NSString* gameIcon;
	
	gameIcon = [[NSBundle mainBundle] pathForResource:@"feiniu.png" ofType:nil];
	
	NSString* gameMsg = [NSString stringWithFormat:@"%@: %@ 我不吹,牛不飞!!!", szTitle, szBody];
	
	[m_PostView StealthPostQQTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}

-(void)QQTShareActionTellFriendInStealthMode
{
    [self SetStealthMode];
    m_PostView.hidden = NO;
    [m_PostView.superview bringSubviewToFront:m_PostView];
	[self LoadQQTEngine];
}


- (void)QQLoginFailed:(id)sender
{
	//[ModalAlert say:@"未能登录QQ微博帐户,不能发布微博!"];
    [CustomModalAlertView SimpleSay:@"未能登录QQ微博帐户,不能发布微博!" closeButton:[StringFactory GetString_Close]];
	[self Dismiss];
	return;
}	

- (void)QQLoginSucceed:(id)sender
{
    [m_PostView SetInitialized];
    [m_PostView SetCloseButtonEnable:YES];
    if(m_bTellFriend)
    {
        [self StealthPostTellFriend];
    }
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
        
        m_bTellFriend = NO;
        
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
        if(m_bTellFriend)
        {
            [self StealthPostTellFriend];
        }
	}
}	

- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh
{
    [m_LoginView AdjusetViewLocation:nw withHeight:nh];
    [m_PostView AdjusetViewLocation:nw withHeight:nh];
}

- (void)SetStealthMode
{
    [m_PostView SetStealthMode];
    m_bTellFriend = YES;
}


@end
