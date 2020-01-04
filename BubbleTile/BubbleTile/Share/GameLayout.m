//
//  GameLayout.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-06.
//  Copyright 2011 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "GameLayout.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"

#define PLAYVIEW_MARGIN             10
#define GRID_SIZE_RATIO_TO_BOARD    0.7
#define PLAYAREA_RATIO_BOARD        0.9
#define ARROW_MOTION_STEP           20.0
#define ARROW_MOTION_RATIO          1.0
#define BUBLE_MOTION_THRESHOLD_RATIO      0.01

#define DEFAULT_SCORELABEL_HEIGHT      90

#define DEFAULT_INDICATOR_SIZE_IPHONE   15
#define DEFAULT_INDICATOR_SIZE_IPAD     30

@implementation GameLayout

+(float)GetPlayBoardSize
{
    float fSize = [GUILayout GetContentViewMinDimension] - [GUILayout GetTitleBarHeight] - 2*PLAYVIEW_MARGIN;

    if([GUILayout IsProtrait])
        fSize += [GUILayout GetTitleBarHeight] - PLAYVIEW_MARGIN;
    
    return fSize;
}

//This is related to Application main window coordinate 
+(CGRect)GetPlayBoardRect
{
    CGPoint pt = [GameLayout GetPlayBoardCenter];
    float f = [GameLayout GetPlayBoardSize];
    CGRect rect = CGRectMake(pt.x-f/2, pt.y-f/2, f, f);
    return rect;
}

//This is related to Application main window coordinate 
+(CGPoint)GetPlayBoardCenter
{
    float x = [GUILayout GetContentViewWidth]/2;
    float y = ([GUILayout GetContentViewHeight]+[GUILayout GetTitleBarHeight])/2;
    CGPoint pt = CGPointMake(x, y);
    return pt;
}

/*
//This is related to Play board coordinate 
+(float)GetGridMaxSize
{
    float fRet = [GameLayout GetPlayBoardSize]*GRID_SIZE_RATIO_TO_BOARD;
    return fRet;
}
*/

+(float)GetGridMaxSize:(float)nGrid
{
    float fSize = [GameLayout GetPlayBoardSize]*PLAYAREA_RATIO_BOARD;
    float fRet = fSize*nGrid/(nGrid+1.0);
    return fRet;
}

//This is related to Play board coordinate 
+(CGPoint)GetGridCenter
{
    float f = [GameLayout GetPlayBoardSize];
    CGPoint pt = CGPointMake(f/2.0, f/2.0);
    return pt;
}

+(float)GetTouchSensitivity
{
    return 0.5;
}

+(float)GetIconViewSize
{
    float fSize = 0.5*([GUILayout GetContentViewMinDimension] - [GUILayout GetTitleBarHeight] - 4*PLAYVIEW_MARGIN);
     
    return fSize;
}

+(float)GetBubbleIconViewSize;
{
    float fsize1 = [GameLayout GetIconViewSize];
    float fBarSize = [GUILayout GetTitleBarHeight];
    if([GUILayout IsLandscape])
        fBarSize = 0.0;
    float fsize2 = ([GUILayout GetContentViewMaxDimension] - fBarSize - 4*PLAYVIEW_MARGIN)/3.0;
    float fRet = MIN(fsize1, fsize2);
    return fRet;
}

+(float)GetPlayBoardMargin
{
    return PLAYVIEW_MARGIN;
}

+(float)GetDefaultIconImageSize
{
    if([ApplicationConfigure iPhoneDevice])
        return 160.0;
    else
        return 380.0;
}

+(float)GetDefaultPreviewImageSize
{
    if([ApplicationConfigure iPhoneDevice])
        return 280.0;
    else
        return 400.0;
}

+(float)GetLayoutSignSize
{
    if([ApplicationConfigure iPhoneDevice])
        return 2.0*[GUILayout GetDefaultTitleBarHeight];
    else
        return 3.0*[GUILayout GetDefaultTitleBarHeight];
}

+(float)GetArrowAnimationStep
{
    return ARROW_MOTION_STEP;
}

+(float)GetArrowAnimationLimitRatio
{
    return ARROW_MOTION_RATIO;
}

+(float)GetBubbleMotionThreshold:(float)fBubbleSize
{
    float fRet = fmaxf(fBubbleSize*0.2, BUBLE_MOTION_THRESHOLD_RATIO*[GameLayout GetPlayBoardSize]);
    return fRet;
}

+(float)GetDefaultScoreLabelHeight
{
    return DEFAULT_SCORELABEL_HEIGHT;
}

+(float)GetGameDifficultyIndicatorSize
{
    if([ApplicationConfigure iPhoneDevice])
        return DEFAULT_INDICATOR_SIZE_IPHONE;
    else
        return DEFAULT_INDICATOR_SIZE_IPAD;
}

+(CGRect)GetGameDifficultyIndicatorRect;
{
    float s = 2;//[GameLayout GetPlayBoardSize]*(1-PLAYAREA_RATIO_BOARD)*0.5;
    if([ApplicationConfigure iPhoneDevice])
        s = 1;
    float f = [GameLayout GetGameDifficultyIndicatorSize];
    CGRect rect = CGRectMake(s, s, f, f);
    return rect;
}

+(float)GetDefaultLocationViewSize
{
    if([ApplicationConfigure iPhoneDevice])
        return 300;
    else
        return 700;
    
}

+(float)GetPurchaseSuggestViewWidth
{
    if([ApplicationConfigure iPhoneDevice])
        return 240;
    else
        return 420;
}

+(float)GetPurchaseSuggestViewHeight;
{
    if([ApplicationConfigure iPhoneDevice])
        return 90;
    else
        return 140;
}


@end
