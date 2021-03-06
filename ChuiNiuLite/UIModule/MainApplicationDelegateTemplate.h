//
//  MainApplicationDelegateTemplate.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

typedef enum FB_apiCall 
{
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} FB_apiCall;

@protocol AdRequestHandlerDelegate <NSObject>
- (void)HandleAdRequest:(NSURL*)url;
- (void)AdViewClicked;
- (void)DismissExtendAdView;
- (void)InterstitialAdViewClicked;
- (void)CloseRedeemAdView;
@end

@protocol MainStdAdApplicationDelegateTemplate <NSObject>
- (UIViewController *)MainViewController;
- (id<AdRequestHandlerDelegate>)GetAdRequestHandler;
- (Facebook *)GetFacebookInstance;
@end
