//
//  FacebookPoster.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "FacebookPoster.h"
#import "ApplicationConfigure.h"
#import "ModalAlert.h"
#import "StringFactory.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"
//#import "Configuration.h"
//#import "ScoreRecord.h"


static BOOL g_bDefault = NO;

@implementation FacebookPoster
//@synthesize m_Facebook = _m_Facebook;


- (void)FBShareGameResultMessage:(NSString*)szMsg byLangDefault:(BOOL)bDefault
{
/*	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
														   [StringFactory GetString_GameTitle:bDefault], @"text",[StringFactory GetString_GameURL], @"href", nil], nil];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								[StringFactory GetString_GameTitle:bDefault], @"name",
								[StringFactory GetString_PostTitle:bDefault], @"caption",
								szMsg, @"description",
								[StringFactory GetString_GameURL], @"href", nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   [ApplicationConfigure GetFacebookKey], @"api_key",
								   [StringFactory GetString_FBUserMsgPrompt:bDefault],  @"user_message_prompt",
								   actionLinksStr, @"action_links",
								   attachmentStr, @"attachment",
								   nil];
	
	
	[_m_Facebook dialog:@"stream.publish" andParams:params andDelegate:self];*/
}	

- (void)FaceBookPostScore:(NSString*)sScore
{
	BOOL bUseEn = NO;
	/*if(g_bDefault == YES)
		bUseEn = YES;
	if([StringFactory IsOSLangEN] == YES)
		bUseEn = YES;
	*/
    [self FBShareGameResultMessage:sScore byLangDefault:bUseEn];
}

- (void)FaceBookPostMessage:(NSString*)sScore
{
    [self FBShareGameResultMessage:sScore byLangDefault:NO];
}

-(id)init
{
    self = [super init];
    if(self)
    {
//		_m_Permissions =  [[NSArray arrayWithObjects: @"read_stream", @"offline_access",nil] retain];
//        _m_Facebook = [[Facebook alloc] init];
    }
    
    return self;
}

- (void)dealloc 
{
//	[_m_Facebook release];
//	[_m_Permissions release];
	
    [super dealloc];
}

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin 
{
	NSLog(@"Facebbok login");
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled 
{
	NSLog(@"Facebook did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout 
{
	NSLog(@"Facebook logout");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
	NSLog(@"Facebook received response");
};

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on the format of the API response.
 * If you need access to the raw response, use
 * (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result 
{
	NSLog(@"Facebook load request");
};

/**
 * Called when an error prevents the Facebook API request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{
	NSLog(@"Facebook requst failed");
};


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog 
{
	NSLog(@"Facebook dialog completed");
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url
{
	NSLog(@"Facebook dialog dialogCompleteWithUrl");
    [GUIEventLoop SendEvent:GUIID_POSTEDONSOICALNETWORK eventSender:nil];
}

/**
 * Called when the dialog get canceled by the user.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
	NSLog(@"Facebook dialog dialogDidNotCompleteWithUrl");
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog
{
	NSLog(@"Facebook dialog dialogDidNotComplete");
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
	NSLog(@"Facebook dialog didFailWithError");
}

@end
