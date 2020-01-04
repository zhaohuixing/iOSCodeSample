//
//  EqnViewController.h
//  MindFire
//
//  Created by Zhaohui Xing on 10-04-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EquationView;
@class DealController;
@class Bulletin;

@interface EqnViewController : NSObject 
{
    DealController*                 m_Game;
	EquationView*					m_View[3];
	int								m_nCurrentAnswer;
	int								m_nAnimationLock;
	BOOL							m_bGotoNext;
}

- (id)initController:(UIView*)ParentView withGame:(DealController*)game;
- (void)UpdateGameViewLayout;
- (void)OnTimerEvent;
- (void)Start;
- (void)GoToNextAnswer;
- (void)GoToPrevAnswer;
- (void)Reset;
- (void)touchesBegan:(NSSet*)touches withEvent: (UIEvent*)event;
- (void)touchesMoved:(NSSet*)touches withEvent: (UIEvent*)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;



@end
