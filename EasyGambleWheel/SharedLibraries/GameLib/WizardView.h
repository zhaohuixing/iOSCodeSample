//
//  WizardView.h
//  XXXXXXXX
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"

@class PlayModeView;
@class NumericView;
@class BetMethodView;
@class PlayTurnView;
@class ThemeSelectView;

@interface WizardView : FrameView 
{
	UIButton*				m_PrevButton;
	UIButton*				m_NextButton;
 
    PlayModeView*           m_PlayModeView;
    PlayTurnView*           m_OnlinePlayTurnView;
    NumericView*            m_LuckyNumberView;
    ThemeSelectView*        m_ThemeSelectionView;
    BetMethodView*          m_BetMethodView;
    
    int                     m_CurrentTab;
    BOOL                    m_bAnimation;
    BOOL                    m_bNetworkConnected;
}

-(void)PrevButtonClick;
-(void)NextButtonClick;
-(void)CloseView:(BOOL)bAnimation;
-(void)OnTimerEvent;
@end
