//
//  CGameLayout.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-27.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CGameLayout : NSObject 
{
}

+ (void)Intialize;
+ (CGRect)GetBasicCardRect:(int)nIndex;
+ (CGRect)GetTempCardRect:(int)nIndex;
+ (CGPoint)ChangeToLandscape:(CGPoint)pt;
+ (CGPoint)ChangeToProtrait:(CGPoint)pt;
+ (CGRect)GetDealCountAreaRect;
+ (CGRect)GetScoreAreaRect;
+ (CGRect)GetOperand1Rect;
+ (CGRect)GetOperand2Rect;
+ (CGRect)GetResultRect;
+ (CGRect)GetSignsRect;
+ (CGRect)GetEqnViewRect:(int)nIndex;
+ (CGRect)GetGreetViewRect;
+ (float)GetStatusBarAnimatorSize;
+ (float)GetResultViewSize;


+ (float) GetCardWidth;
+ (float) GetCardHeight;

+ (float) GetCardCornerWidth;
+ (float) GetCardCornerHeight;
+ (float) GetCardCornerRadium;

+ (float) GetCardMargin;
+ (float) GetCardSignHeight;
+ (float) GetCardAnimalSignHeight;
+ (float) GetCardInnerMargin;

+ (float) GetGameSignOutterSize;
+ (float) GetGameSignInnerSize;

+ (float) GetGameGreetViewWidth;
+ (float) GetGameGreetViewHeight;

+ (float)GetBulletinUnitSize;

+ (float)GetEqnImageWidth;
+ (float)GetEqnImageHeight;

@end
