//
//  GameControllerDelegate.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-09-03.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GameControllerDelegate

-(void)startGame;
-(void)resetGame;
-(void)stopGame;
-(void)pauseGame;
-(void)resumeGame;

@end
