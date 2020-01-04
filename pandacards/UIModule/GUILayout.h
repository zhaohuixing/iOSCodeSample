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
+(float)GetContentViewMinDimension;
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

+(float)GetRedeemAdViewWidth;
+(float)GetRedeemAdViewHeight;
+(float)GetDefaultRedeemAdViewDisplayTime;

+(float)GetFullScreenAdButtonSize;
+(float)GetFullScreenAdLabelHeight;
+(float)GetFullScreenAdLabelFont;
+(float)GetFullScreenAdButtonImageSize;

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

////////Cash adornment
+(float)GetCashFaucetSize;

+(float)GetGoldenCoinBoundWidth;
+(float)GetGoldenCoinBoundHeight;
+(float)GetGoldenCoinMinBoundWidth;
+(float)GetGoldenCoinMinBoundHeight;

+(float)GetCashBagSize;
+(float)GetCashBagMinSize;

+(float)GetCashBagLabelHeight;
+(float)GetCashBagLabelMinHeight;

+(float)GetCashBagLabelFont;
+(float)GetCashBagLabelMinFont;

+(float)GetAvatarImageSize;
+(float)GetChipImageSize;

+(float)GetAvatarDislaySize;
+(float)GetAvatarDislayVerticalMargin;
+(float)GetAvatarDislayHorizontalMargin;

+(float)GetWinnerAnimatorDislayRatio;

+(float)GetCashMachineSize;

+(float)GetCashEarnDislayImageWidth;
//+(float)GetCashEarnDislayIconImageHeight;
+(float)GetCashEarnDislayIPhoneRatio;

+(float)GetCashEarnDislayWidth;
+(float)GetCashEarnDislayIconHeight;

+(float)GetLuckyNumberPickViewWidth;
+(float)GetLuckyNumberPickViewIconHeight;
+(float)GetLuckyNumberPickViewLabelHeight;
+(float)GetLuckyNumberPickViewPikcerHeight;
+(float)GetLuckyNumberPickViewHeight;
+(float)GetPlayerPopuoMenueHeightRatio;


+(float)GetDefaultCloseButtonSize;
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

+(float)GetStatusBarWidth;
+(float)GetStatusBarHeight;

@end
