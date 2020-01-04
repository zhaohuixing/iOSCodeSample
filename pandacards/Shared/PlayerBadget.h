//
//  PlayerBadget.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-08-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GameRobo.h"
#import "RoboListBoard.h"

@interface PlayerBadget : GameRobo2
{
}

-(id)initWithAchorPoint:(CGPoint)pt;
-(void)UpdateLargeViewLayout;
-(void)UpdateSmallViewLayout;

@end
