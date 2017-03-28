//
//  NOMGUILayout.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMGUILayout : NSObject

+(void)SetOrientation:(BOOL)bLandscape;
+(BOOL)IsLandscape;
+(BOOL)IsProtrait;

+(CGFloat)GetAdBannerHeight;
+(CGFloat)GetiADBannerHeight;
+(CGFloat)GetAdBannerWidth;
+(CGFloat)GetAdBannerHeight:(BOOL)bProtrait;

+(void)SetLayoutDimension:(CGFloat)w withHeight:(CGFloat)h;
+(CGFloat)GetLayoutWidth;
+(CGFloat)GetLayoutHeight;

+(void)SetRootViewController:(UIViewController*)controller;
+(UIViewController*)GetRootViewController;

+(CGFloat)GetMapViewOriginY;
+(CGFloat)GetMapViewHeight;

+(CGFloat)GetRealContentViewHeight;

+(CGFloat)GetActivateButtonSize;

+(float)GetDefaultTextEditorButtonHeight;

+(id)GetGlobalDocumentController;
+(void)SetGlobalDocumentController:(id)documentController;


@end
