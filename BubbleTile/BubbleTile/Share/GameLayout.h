//
//  GameLayout.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-06.
//  Copyright 2011 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameLayout : NSObject 
{
    
}

+(float)GetPlayBoardSize;

//This is related to Application main window coordinate 
+(CGRect)GetPlayBoardRect;

//This is related to Application main window coordinate 
+(CGPoint)GetPlayBoardCenter;

//This is related to Play board coordinate 
//+(float)GetGridMaxSize;

//This is related to Play board coordinate 
+(float)GetGridMaxSize:(float)nGrid;

//This is related to Play board coordinate 
+(CGPoint)GetGridCenter;

+(float)GetTouchSensitivity;

+(float)GetIconViewSize;

+(float)GetBubbleIconViewSize;

+(float)GetPlayBoardMargin;

+(float)GetDefaultIconImageSize;

+(float)GetLayoutSignSize;

+(float)GetArrowAnimationStep;

+(float)GetArrowAnimationLimitRatio;

+(float)GetBubbleMotionThreshold:(float)fBubbleSize;

+(float)GetDefaultScoreLabelHeight;

+(float)GetGameDifficultyIndicatorSize;

+(CGRect)GetGameDifficultyIndicatorRect;

+(float)GetDefaultPreviewImageSize;

+(float)GetDefaultLocationViewSize;

+(float)GetPurchaseSuggestViewWidth;
+(float)GetPurchaseSuggestViewHeight;

@end
