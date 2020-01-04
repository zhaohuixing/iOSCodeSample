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
#import "CustomModalAlertView.h"
#import "StringFactory.h"
#import "NSObject+SBJSON.h"
#import "StringFactory.h"
//#import "Configuration.h"
//#import "ScoreRecord.h"


static BOOL g_bDefault = NO;

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
	NSString* greeting = @"脑子着火烧的人聪明";
	NSString* prompt = @"请分享你的乐趣";
	
	[_m_RRPoster postFeed:feedMsg withGreet:greeting withPrompt:prompt withTemplate:1];
}

-(void)RenRenPostScore:(NSString*)sScore
{
	BOOL bDefault = NO;
	NSString *gameURL = [StringFactory GetString_GameURL];
	
	NSString *gameTitle = [StringFactory GetString_GameTitle:bDefault];//[jsonWriter stringWithObject:actionLinks];
	
	NSString* gameIcon = @"http://fmn.xnpic.com/fmn049/20110401/2045/p_large_4v2U_3fd000000f165c43.jpg";
	
	[self PostRenRenTweet:gameTitle withMessage:sScore withImage:gameIcon withURL:gameURL];
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
    [CustomModalAlertView SimpleSay:@"人人网登录成功!" closeButton:[StringFactory GetString_Close]];
}

- (void)instanceLoginFailed:(RRSession*)session
{
    [CustomModalAlertView SimpleSay:@"人人网登录失败!" closeButton:[StringFactory GetString_Close]];
}

- (void)instanceWillLogut:(RRSession*)session byUser:(RRUID)uid
{
}

- (void)instanceDidLogout:(RRSession*)session
{
}	


@end
