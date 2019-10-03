//
//  RenRenPoster.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "RenRenPoster.h"
#import "ApplicationConfigure.h"
#import "StringFactory.h"
#import "Configuration.h"
#import "ScoreRecord.h"
#import "CustomModalAlertView.h"
#import "NSObject+SBJSON.h"

//static BOOL g_bDefault = NO;

@implementation RenRenPoster

- (void)PostRenRenTweet:(NSString*)gameTitle
			withMessage:(NSString*)gameMsg
			  withImage:(NSString*)gameIcon
				withURL:(NSString*)gameURL
{
	if(_m_RRPoster == nil)
		return;
	
	NSString* feedtype = gameTitle;
	NSString* appName = gameTitle;
	NSString* appLink = gameURL;
	NSString* imageSrc = gameIcon;
	NSString* imageHref = gameURL;
	NSString* content = gameMsg;
	NSDictionary* image = [NSDictionary dictionaryWithObjectsAndKeys:imageSrc, @"src", imageHref, @"href", nil];
	NSArray* images = [NSArray arrayWithObject:image];
	NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:feedtype, @"feedtype", appName, @"appName", 
						  appLink, @"appLink", content, @"content", images, @"images", nil];
	
	
	NSString* feedMsg = [data JSONRepresentation];
	NSString* greeting = @"我不吹，牛不飞！";
	NSString* prompt = @"请分享你的乐趣";
	
	[_m_RRPoster postFeed:feedMsg withGreet:greeting withPrompt:prompt withTemplate:1];
}

-(void)RenRenShareActionTellFriend
{
	NSString* feedtype = [StringFactory GetString_GameTitle:NO];
	NSString* appName = [StringFactory GetString_GameTitle:NO];
	NSString* appLink = [StringFactory GetString_GameURL];
	NSString* imageSrc =  @"http://fmn.rrfmn.com/fmn047/20110219/1420/p_large_IrBP_5c0700045d695c44.jpg";
	NSString* imageHref = [StringFactory GetString_GameURL];
	NSString* content = @"我喜欢“吹牛大王，狗吹牛”游戏，向你隆重推荐！";
	NSDictionary* image = [NSDictionary dictionaryWithObjectsAndKeys:imageSrc, @"src", imageHref, @"href", nil];
	NSArray* images = [NSArray arrayWithObject:image];
	NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:feedtype, @"feedtype", appName, @"appName", 
						  appLink, @"appLink", content, @"content", images, @"images", nil];
	
	
	NSString* feedMsg = [data JSONRepresentation];
	NSString* greeting = @"你不吹，牛不飞！";
	NSString* prompt = @"希望你也喜欢“吹牛”";
	
	[_m_RRPoster postFeed:feedMsg withGreet:greeting withPrompt:prompt withTemplate:1];
}

- (void)RenRenShareActionLastWin
{
	BOOL bDefault = NO;
	NSString *gameURL = [StringFactory GetString_GameURL];
	
	NSString *gameTitle = [StringFactory GetString_GameTitle:bDefault];//[jsonWriter stringWithObject:actionLinks];
	
	NSString* gameIcon = @"http://fmn.rrfmn.com/fmn047/20110219/1420/p_large_IrBP_5c0700045d695c44.jpg";
	
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
	NSString* gameMsg = [NSString stringWithFormat:@"%@: %@", szTitle, szBody];
	[self PostRenRenTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}

- (void)RenRenShareActionTotalWin	
{
	BOOL bDefault = NO;
	NSString *gameURL = [StringFactory GetString_GameURL];
	//NSString *gameTitle = [NSString stringWithFormat:@"%@ [%@ ]", [StringFactory GetString_GameTitle:bDefault], gameURL];//[jsonWriter stringWithObject:actionLinks];
	NSString *gameTitle = [StringFactory GetString_GameTitle:bDefault];//[jsonWriter stringWithObject:actionLinks];
	
	NSString* szTitle = [StringFactory GetString_MyTotalWin:bDefault];
	NSString* szBody = @"";
	NSString* gameIcon = @"http://fmn.rrfmn.com/fmn047/20110219/1420/p_large_IrBP_5c0700045d695c44.jpg";
	
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
	
	NSString* gameMsg = [NSString stringWithFormat:@"%@: %@", szTitle, szBody];
	
	[self PostRenRenTweet:gameTitle withMessage:gameMsg withImage:gameIcon withURL:gameURL];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _m_RRPoster = [[[RRInstance alloc] initInstance:[ApplicationConfigure GetRenRenKey] withSecret:[ApplicationConfigure GetRenRenSecret] withDelegate:self] retain];
    }
    
    return self;
}

- (void)dealloc 
{
	[_m_RRPoster release];
	
    [super dealloc];
}

- (void)instanceLoginSuccessed:(RRSession*)session byUser:(RRUID)uid
{
	//[ModalAlert say:@"人人网登录成功！"];
    [CustomModalAlertView SimpleSay:@"人人网登录成功！" closeButton:[StringFactory GetString_Close]];
}

- (void)instanceLoginFailed:(RRSession*)session
{
	//[ModalAlert say:@"人人网登录失败!"];
    [CustomModalAlertView SimpleSay:@"人人网登录失败！" closeButton:[StringFactory GetString_Close]];
}

- (void)instanceWillLogut:(RRSession*)session byUser:(RRUID)uid
{
}

- (void)instanceDidLogout:(RRSession*)session
{
}	


@end
