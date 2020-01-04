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
+(float)GetContentViewMaxDimension;
+(float)GetDefaultTitleBarHeight;
+(float)GetAdBannerHeight;
+(float)GetAdBannerWidth;
+(float)GetAdBigBannerHeight;
+(float)GetAdBigBannerWidth;
+(float)GetTitleBarHeight;
+(float)GetDefaultCloseButtonSize;


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


+(float)GetDefaultMapLatitudeSpan;
+(float)GetDefaultMapLongitudeSpan;

+(float)GetDefaultTextEditorWidth;
+(float)GetDefaultTextEditorHeight;

+(float)GetDefaultTextEditorButtonWidth;
+(float)GetDefaultTextEditorButtonHeight;
+(float)GetDefaultTextEditorHeightMargin;

+(float)GetDefaultKeyboardHeight;

+(float)GetRedeemAdViewWidth;
+(float)GetRedeemAdViewHeight;
+(float)GetDefaultRedeemAdViewDisplayTime;

@end
