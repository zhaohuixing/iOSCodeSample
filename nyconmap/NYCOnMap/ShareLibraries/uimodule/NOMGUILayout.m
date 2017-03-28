//
//  NOMGUILayout.m
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMGUILayout.h"
#import "NOMAppInfo.h"
#import "NOMGUILayout.h"
#import "NOMDocumentController.h"

static BOOL g_bLandscape = NO;

@implementation NOMGUILayout

static CGFloat g_Width = 320;
static CGFloat g_Height = 480;

+(void)SetLayoutDimension:(CGFloat)w withHeight:(CGFloat)h
{
    g_Width = w;
    g_Height = h;
}

+(CGFloat)GetLayoutWidth
{
    return g_Width;
}

+(CGFloat)GetLayoutHeight
{
    return g_Height;
}

+(void)SetOrientation:(BOOL)bLandscape
{
    g_bLandscape = bLandscape;
}

+(BOOL)IsLandscape
{
    return g_bLandscape;
}

+(BOOL)IsProtrait
{
    return (!g_bLandscape);
}

+(CGFloat)GetiPadAdBannerHeight:(BOOL)bProtrait
{
    CGFloat hRet = 90;
    
    return hRet;
}

+(CGFloat)GetiPhoneAdBannerHeight:(BOOL)bProtrait
{
    CGFloat hRet = 50;
    
    if(!bProtrait)
        hRet = 32;
    
    return hRet;
}


+(CGFloat)GetiPadAdBannerHeight
{
    CGFloat hRet = [NOMGUILayout GetiPadAdBannerHeight:!g_bLandscape];;

    return hRet;
}

+(CGFloat)GetiPhoneAdBannerHeight
{
    CGFloat hRet = [NOMGUILayout GetiPhoneAdBannerHeight:!g_bLandscape];

    return hRet;
}

+(CGFloat)GetAdBannerHeight;
{
/*
    CGFloat hRet = 50;
    
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        hRet = [NOMGUILayout GetiPadAdBannerHeight];
    }
    else
    {
        hRet = [NOMGUILayout GetiPhoneAdBannerHeight];
    }
    
    return hRet;
*/
    return [NOMGUILayout GetiADBannerHeight];
}

+(CGFloat)GetiADBannerHeight
{
    CGFloat hRet = 50;
    
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        hRet = 66;
    }
    else
    {
        if(g_bLandscape)
            hRet = 32;
        else
            hRet = 50;
    }
    
    return hRet;
}

+(CGFloat)GetAdBannerWidth
{
    CGFloat hRet = 320;
    
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        if(g_bLandscape)
            hRet = 1024;
        else
            hRet = 768;
    }
    else
    {
        if(g_bLandscape)
            hRet = 480;
        else
            hRet = 320;
    }
    
    return hRet;
}


+(CGFloat)GetAdBannerHeight:(BOOL)bProtrait
{
    CGFloat hRet = 50;
    
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        hRet = [NOMGUILayout GetiPadAdBannerHeight:bProtrait];
    }
    else
    {
        hRet = [NOMGUILayout GetiPhoneAdBannerHeight:bProtrait];
    }
    
    return hRet;
}

static UIViewController* g_ViewController = nil;

+(void)SetRootViewController:(UIViewController*)controller
{
    g_ViewController = controller;
}

+(UIViewController*)GetRootViewController
{
    return g_ViewController;
}

+(CGFloat)GetMapViewOriginY
{
    if([NOMAppInfo ShowAdBanner] == YES)
    {
        return [NOMGUILayout GetAdBannerHeight];
    }
    else
    {
        return 0.0;
    }
}

+(CGFloat)GetMapViewHeight
{
    if([NOMAppInfo ShowAdBanner] == YES)
    {
        return [NOMGUILayout GetLayoutHeight] - [NOMGUILayout GetAdBannerHeight];
    }
    else
    {
        return [NOMGUILayout GetLayoutHeight];
    }
}

+(CGFloat)GetRealContentViewHeight
{
    return [NOMGUILayout GetMapViewHeight];
}

+(CGFloat)GetActivateButtonSize
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 90;
    }
    else
    {
        return 60;
    }
}

#define DEFAULT_TEXTEDITOR_BUTTON_HEIGHT_IPHONE         30
#define DEFAULT_TEXTEDITOR_BUTTON_HEIGHT_IPAD           40
+(float)GetDefaultTextEditorButtonHeight
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return DEFAULT_TEXTEDITOR_BUTTON_HEIGHT_IPAD;
    }
    else
    {
        return DEFAULT_TEXTEDITOR_BUTTON_HEIGHT_IPHONE;
    }
}

static NOMDocumentController*       g_DocumentController = nil;

+(id)GetGlobalDocumentController
{
    return g_DocumentController;
}

+(void)SetGlobalDocumentController:(id)documentController
{
    if(documentController == nil || [documentController isKindOfClass:[NOMDocumentController class]] == NO)
    {
#ifdef DEBUG
        assert(false);
#endif
        if(g_DocumentController == nil)
        {
            g_DocumentController = [[NOMDocumentController alloc] init];
        }
        return;
    }
    
    g_DocumentController = documentController;
}


@end
