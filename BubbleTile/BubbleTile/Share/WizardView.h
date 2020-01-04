//
//  WizardView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"

@class BubbleView;
@class LayoutView;
@class NumericView;
@class PatternView;
@class LevelView;

@interface WizardView : FrameView 
{
	UIButton*				m_PrevButton;
	UIButton*				m_NextButton;
 
    BubbleView*             m_BubbleView;
    LayoutView*             m_LayoutView;
    NumericView*            m_EdgeView;
    PatternView*            m_PatternView;
    LevelView*              m_LevelView;

    int                     m_CurrentTab;
    BOOL                    m_bAnimation;
}

-(void)PrevButtonClick;
-(void)NextButtonClick;
-(void)CloseView:(BOOL)bAnimation;

@end
