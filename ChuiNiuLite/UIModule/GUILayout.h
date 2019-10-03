//
//  GUILayout.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "StdAdPostAppDelegate.h"

@interface GUILayout : NSObject 
{
}

+(void)SetMainUIDimension:(float)width withHeight:(float)height;
+(float)GetMainUIWidth;
+(float)GetMainUIHeight;
+(BOOL)IsProtrait;
+(BOOL)IsLandscape;
+(float)GetGlossyMenuSize;
+(float)GetDefaultGlossyMenuLayoutRadium;
+(float)GetContentViewHeight;
+(float)GetContentViewWidth;
+(float)GetAdBannerHeight;
+(float)GetAdBannerWidth;
+(float)GetAdBigBannerHeight;
+(float)GetAdBigBannerWidth;
+(float)GetTitleBarHeight;

+(float)GetDefaultListCellHeight;
+(float)GetDefaultListCellMargin;
+(float)GetDefaultListCellStroke;
+(float)GetDefaulSwitchIconCellHeight;

+(float)GetDefaultExtendAdViewWidth;
+(float)GetDefaultExtendAdViewHeight;
+(float)GetExtendAdViewCornerWidth;
+(float)GetExtendAdViewCornerHeight;
+(float)GetHouseAdViewSize;

+(float)GetDefaultExtendAdViewDisplayTime;
+(float)GetDefaultHouseAdDisplayTime;
+(float)GetDefaultHouseAdViewDisplayTime;
+(float)GetDefaultHouseAdViewDisplayInterval;

+(UIViewController *)GetMainViewController;
+(Facebook*)GetFacebookInstance;
+(StdAdPostAppDelegate*)GetApplicationDelegate;

+(float)GetTMSButtonWidth;
+(float)GetTMSButtonHeight;
+(float)GetTextMsgViewWidth;
+(float)GetTextMsgViewHeight;
+(float)GetTMSViewRoundRatio;
+(float)GetTMSViewAchorRatio;
+(float)GetCloseButtonSize;
+(float)GetMsgBoardViewWidth;
+(float)GetMsgBoardViewHeight;
+(float)GetAvatarWidth;
+(float)GetAvatarHeight;
+(float)GetPlayerBadgetRatioToAvatar;

+(float)GetDefaultAlertUIConner;
+(float)GetDefaultAlertWidth:(BOOL)bLandScape;
+(float)GetDefaultAlertLabelLineHeight;
+(float)GetDefaultAlertUIEdge;
+(float)GetDefaultAlertButtonHeight;
+(float)GetDefaultAlertButtonWidth;
+(float)GetDefaultAlertFontSize;
+(float)GetOptionalAlertButtonHeight;
+(float)GetOptionalAlertButtonWidth;
+(float)GetOptionalAlertUIConner;
+(float)GetFileSaveUIButtonHeight;
+(float)GetFileSaveUIButtonWidth;
+(float)GetMapViewButtonHeight;
+(float)GetMapViewButtonWidth;

+(float)GetDefaultDummyAlertWidth;
+(float)GetDefaultDummyAlertHeight;

+(float)GetRedeemAdViewWidth;
+(float)GetRedeemAdViewHeight;
+(float)GetDefaultRedeemAdViewDisplayTime;

@end
