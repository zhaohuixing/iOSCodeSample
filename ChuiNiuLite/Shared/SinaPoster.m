//
//  SinaPoster.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "SinaPoster.h"
#import "ApplicationConfigure.h"
#import "StringFactory.h"
#import "Configuration.h"
#import "ScoreRecord.h"
#import "GUILayout.h"
#import "CustomModalAlertView.h"

@implementation SinaPoster

- (void)dismissPost
{
    [m_PostView.superview sendSubviewToBack: m_PostView];
    m_PostView.hidden = YES;
}

- (void)PostSinaTweet:(NSString*)gameTitle
		  withMessage:(NSString*)gameMsg
			withImage:(NSString*)gameIcon
			  withURL:(NSString*)gameURL
{
    m_PostView.hidden = NO;
    [m_PostView.superview bringSubviewToFront:m_PostView];
	[self LoadSinTEngine];
	[m_PostView PostSinaTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}	


- (void)SinaTShareActionLastWin
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
	[self PostSinaTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}


- (void)SinaTShareActionTotalWin	
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
//		[ModalAlert say:[StringFactory GetString_NoRecordPostWarn:NO]];
        [CustomModalAlertView SimpleSay:[StringFactory GetString_NoRecordPostWarn:NO] closeButton:[StringFactory GetString_Close]];
		return;
	}	
	gameIcon = [[NSBundle mainBundle] pathForResource:@"feiniu.png" ofType:nil];
	
	NSString* gameMsg = [NSString stringWithFormat:@"%@: %@ 我不吹,牛不飞!!!", szTitle, szBody];
	
	[self PostSinaTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}	

-(void)StealthPostTellFriend
{
	BOOL bDefault = NO;
	NSString *gameURL = [StringFactory GetString_GameURL];
	NSString *gameTitle = [NSString stringWithFormat:@"%@ [%@ ]", [StringFactory GetString_GameTitle:bDefault], gameURL];
	
	NSString* szTitle = @"强力推荐“吹牛大王，狗吹牛”游戏";
	NSString* szBody = @"我很喜欢“吹牛大王，狗吹牛”游戏，向大家隆重推荐！";
	NSString* gameIcon = nil;
	
	gameIcon = [[NSBundle mainBundle] pathForResource:@"feiniu.png" ofType:nil];
	
	NSString* gameMsg = [NSString stringWithFormat:@"%@: %@ 我不吹,牛不飞!!!", szTitle, szBody];
	
	[m_PostView StealthPostSinaTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}

-(void)SinaTShareActionTellFriendInStealthMode
{
    [self SetStealthMode];
    m_PostView.hidden = NO;
    [m_PostView.superview bringSubviewToFront:m_PostView];
	[self LoadSinTEngine];
}

- (void)dealloc 
{
 	if(m_Engine != nil)
		[m_Engine release];
    [super dealloc];
}

//=============================================================================================================================
#pragma mark OAuthEngineDelegate
- (void) storeCachedOAuthData: (NSString *) data forUsername: (NSString *) username 
{
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedOAuthDataForUsername: (NSString *) username 
{
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (void)removeCachedOAuthDataForUsername:(NSString *) username
{
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults removeObjectForKey: @"authData"];
	[defaults synchronize];
}
//=============================================================================================================================
#pragma mark OAuthSinaWeiboControllerDelegate
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username 
{
	NSLog(@"Authenicated for %@", username);
	/*if (controller)
	{	
		[[GUILayout GetMainViewController] presentModalViewController: controller animated: NO];
	    [self FollowMe]; 
    }	
	else 
	{
		NSLog(@"Authenicated for %@..", m_Engine.username);
		[OAuthEngine setCurrentOAuthEngine:m_Engine];
		if(m_PostView != nil)
		{
			[m_PostView SetInitialized];
			[m_PostView SetCloseButtonEnable:YES];
		}	
	}*/
    [self Authenticate]; 
}

- (void) OAuthControllerFailed: (OAuthController *) controller 
{
	NSLog(@"Authentication Failed!");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
    //[ModalAlert say:@"登录新浪微博失败,不能发布微博!"];
    [CustomModalAlertView SimpleSay:@"登录新浪微博失败,不能发布微博!" closeButton:[StringFactory GetString_Close]];

	if (controller) 
		[controller dismissModalViewControllerAnimated:YES];
	
	[self dismissPost];
}

- (void) OAuthControllerCanceled: (OAuthController *) controller 
{
	NSLog(@"Authentication Canceled.");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	[m_PostView SetCloseButtonEnable:YES];
    //[ModalAlert say:@"新浪微博登录取消,不能发布微博!"];
    [CustomModalAlertView SimpleSay:@"新浪微博登录取消,不能发布微博!" closeButton:[StringFactory GetString_Close]];

    if (controller) 
		[controller dismissModalViewControllerAnimated:YES];

	[self dismissPost];
}

- (void)followDidReceive:(WeiboClient*)sender obj:(NSObject*)obj 
{
	if (sender.hasError) 
	{		
		NSLog(@"followDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        
		//[self dismissPost];
		return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) 
	{
		NSLog(@"followDidReceive data format error.%@", @"");
		//[self dismissPost];
        return;
    }
    
    
    NSDictionary *dic = (NSDictionary*)obj;
	User *responseUser = [[[User alloc]initWithJsonDictionary:dic] autorelease];
	NSLog(@"follow user success:.%@", responseUser.screenName);
}


- (void)openAuthenticateView 
{
	[self removeCachedOAuthDataForUsername:m_Engine.username];
	[m_Engine signOut];
	UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: m_Engine delegate: self];
	
	if (controller) 
		[[GUILayout GetMainViewController] presentModalViewController: controller animated: YES];
}

//=============================================================================================================================

- (void)FollowMe
{
	WeiboClient *followClient = [[WeiboClient alloc] initWithTarget:self 
															 engine:m_Engine
															 action:@selector(followDidReceive:obj:)];
	[followClient follow:[ApplicationConfigure GetSinaAutherID]]; // follow the author!
}	

- (void)Dismiss
{
	[self dismissPost];
}

- (void)LoadSinTEngine
{
	if (!m_Engine)
	{
		m_Engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
		m_Engine.consumerKey = [ApplicationConfigure GetSinaKey];
		m_Engine.consumerSecret = [ApplicationConfigure GetSinaSecret];
	}
	[self performSelector:@selector(Authenticate) withObject:nil afterDelay:0.5];
}	

- (void)Authenticate 
{
	UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: m_Engine delegate: self];
	
	if (controller)
	{	
		[[GUILayout GetMainViewController] presentModalViewController: controller animated: NO];
	    [self FollowMe]; 
    }	
	else 
	{
		NSLog(@"Authenicated for %@..", m_Engine.username);
		[OAuthEngine setCurrentOAuthEngine:m_Engine];
		if(m_PostView != nil)
		{
			[m_PostView SetInitialized];
			[m_PostView SetCloseButtonEnable:YES];
		}	
	}
    if(m_bTellFriend)
    {
        [self StealthPostTellFriend];
    }
}

- (id)initWithParent:(UIView*)parent withFrame:(CGRect)frame;
{
    self = [super init];
    if(self)
    {
        m_PostView = [[SinaTPostView alloc] initWithFrame:frame];
        m_PostView.backgroundColor = [UIColor lightGrayColor];
        [m_PostView SetCloseButtonEnable:NO];
        
        [parent addSubview: m_PostView];
        [m_PostView release];
        [parent sendSubviewToBack:m_PostView];
        m_PostView.hidden = YES;
        m_bTellFriend = NO;
    }
    
    return self;
}

- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh
{
    [m_PostView AdjusetViewLocation:nw withHeight:nh];
}

- (void)SetStealthMode
{
    [m_PostView SetStealthMode];
    m_bTellFriend = YES;
}


@end
