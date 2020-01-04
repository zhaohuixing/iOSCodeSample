//
//  ResultView.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-19.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"
@class DealController;
@class EqnViewController;
@class Bulletin;

@interface ResultView : FrameView 
{
	EqnViewController*		m_ResultController;
	UIButton*				m_PrevButton;
	UIButton*				m_NextButton;
	Bulletin*				m_Bulletin;
}

- (id)initView:(CGRect)frame withGame:(DealController*)game;
- (int)GetViewType;
- (void)UpdateGameViewLayout;
- (void)OnTimerEvent;
- (void)StartResult:(int)nPoint withScore:(int)nScore;
- (void)EndResult;
- (void)GotoNext;
- (void)GotoPrev;
//- (void)CloseView;
@end


@interface ResultViewParent : UIView 
{
    ResultView*             m_ResultView;
}

- (id)initView:(CGRect)frame withGame:(DealController*)game;
- (void)UpdateGameViewLayout;
- (void)OnTimerEvent;
- (void)StartResult:(int)nPoint withScore:(int)nScore;
- (void)EndResult;
- (void)CloseView;
- (void)OpenView;
@end


