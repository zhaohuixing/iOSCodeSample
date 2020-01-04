//
//  GameStatusBar.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface GameStatusBar : UIView
{
    BOOL                        m_bWin;
    int                         m_nAnimationFrame;
    NSTimeInterval              m_timerCount;
    NSTimeInterval              m_timerStartShow;
}

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(void)UpdateViewLayout;
-(void)SetWinState:(BOOL)bWin;
-(void)OnTimerEvent;
@end
