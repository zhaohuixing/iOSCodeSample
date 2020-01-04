//
//  GreetLayer.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-27.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GameBaseView.h"

@interface GreetLayer : GameBaseView 
{
	int					m_nAnimationStep;
	int                 m_nTimeSlowPace;
	BOOL				m_bWin;
    UILabel*            m_GreetText;
}

- (id)initView:(CGRect)frame;
- (void)OnTimerEvent;
- (int)GetViewType;
- (void)UpdateGameViewLayout;
- (void)Show;
- (void)Hide;
- (void)SetWinGreet;
- (void)SetLoseGreet;
@end
