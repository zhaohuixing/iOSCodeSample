//
//  GameEventNotification.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-08.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GameEventNotification

-(void)GameLose;
-(void)GameWin;
-(BOOL)IsPlayingSound;
-(void)PlaySound:(int)sndID;
-(void)StopSound:(int)sndID;
-(void)PlayBlockageSound;
-(void)SwitchToBackgroundSound;


@end
