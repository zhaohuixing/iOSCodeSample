//
//  CSignSlider.h
//  MindFire
//
//  Created by Zhaohui Xing on 10-04-07.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameBaseView;

@interface CSignsBtn : GameBaseView 
{
	BOOL			m_bHighlight;
	int				m_nOperation;
}

- (id)initView:(CGRect)frame;
- (int)GetViewType;
- (void)OnTimerEvent;
- (void)UpdateGameViewLayout;
- (int)GetOperation;
- (void)SetHighlight;
- (BOOL)IsHighlight;
- (void)RemoveHighlight;
- (BOOL)HitBtn:(CGPoint)point;
- (void)Reset;

@end
