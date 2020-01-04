//
//  StdAdPostAppDelegate.h
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-10-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "MainApplicationDelegateTemplate.h"
#import <CoreLocation/CoreLocation.h>

@interface StdAdPostAppDelegate : NSObject<UIApplicationDelegate, MainStdAdApplicationDelegateTemplate, FBRequestDelegate, FBDialogDelegate,FBSessionDelegate, FBLoginDialogDelegate>
{
    Facebook*                   m_Facebook;
    FB_apiCall                  m_FB_currentAPICall;
    NSArray*                    m_Permissions;
}

-(void)HandleAdRequest:(NSURL*)url;
//-(void)AdViewClicked:(int)nType;
-(void)InitializeFacebookInstance;
-(void)ProcesUserPermission;
-(BOOL)handleOpenURL:(NSURL *)url;
-(void)UserDidGrantPermission;
-(void)FacebookLogin;
-(void)FacebookLogout;

///////////////////////////////////////////////
//
// Facebook Graph API call functions: begin (from Facebook SDK sample)
//
///////////////////////////////////////////////
- (void)apiGraphMe;
- (void)apiGraphFriends; 
- (void)apiGraphUserPermissions; 
- (void)apiGraphUserCheckins; 
- (void)apiGraphSearchPlace:(CLLocation *)location withDistance:(float)fDistance;
- (void)apiGraphUserVideosPost:(NSURL*)url withDataFmt:(NSString*)dataType withType:(NSString*)videoFormat withTitle:(NSString*)title withDescription:(NSString*)description;
- (void)apiGraphUserPermissionsDelete; 
- (void)apiRESTGetAppUsers;
//- (void)apiGraphPostMessageToAllFriend:(NSString*)msg;

///////////////////////////////////////////////
//
// Facebook Graph API call functions: end
//
///////////////////////////////////////////////


///////////////////////////////////////////////
//
// Facebook Feed API call functions: begin (from Facebook SDK sample)
//
///////////////////////////////////////////////
-(void)PostFacebookFeedToUser:(NSString*)msgFeed;
-(void)PostFacebookFeedToFriend:(NSString *)friendID withFeed:(NSString*)msgFeed;
///////////////////////////////////////////////
//
// Facebook Feed API call functions: end
//
///////////////////////////////////////////////

///////////////////////////////////////////////
//
// Facebook Request API call functions: begin (from Facebook SDK sample)
//
///////////////////////////////////////////////
- (void)SendRequestsSendToMany:(NSString*)msg withAlert:(NSString*)notification;
- (void)apiDialogRequestsSendToNonUsers:(NSArray *)selectIDs withMessage:(NSString*)msg withAlert:(NSString*)notification;
- (void)apiDialogRequestsSendToFriend:(NSString *)friendID withMessage:(NSString*)msg withAlert:(NSString*)notification;
///////////////////////////////////////////////
//
// Facebook Request API call functions: end
//
///////////////////////////////////////////////
@end
