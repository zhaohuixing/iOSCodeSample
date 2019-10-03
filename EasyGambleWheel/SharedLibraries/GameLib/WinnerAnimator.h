//
//  WinnerAnimator.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinnerFlying : UIView
{
}

@end

@interface WinnerAnimator : UIView
{
    WinnerFlying*       m_Flyer;
    BOOL                m_bFirstFrame;
    BOOL                m_bActive;
}

-(BOOL)IsActive;
-(void)StartAnimation;
-(void)StopAnimation;
-(void)FlyIn;

@end
