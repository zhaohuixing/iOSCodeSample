//
//  EquationView.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-24.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardEquation.h"
#import "GameBaseView.h"

@interface EquationView : GameBaseView 
{
	CardEquation*		m_Equation;
	CGImageRef			m_EquationImage;
}

- (id)initView:(CGRect)frame;// withRoot:(UIView*)root;
- (void)Reset;
- (void)OnTimerEvent;
- (void)UpdateGameViewLayout;
- (int)GetViewType;
- (void)SetEquation:(CardEquation*)eqn;
- (void)SetEquation:(int)op1 withOprand2:(int)op2 withResult:(int)res withOperator:(int)oper;

@end
