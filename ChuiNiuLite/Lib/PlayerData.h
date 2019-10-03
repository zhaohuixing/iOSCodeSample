//
//  PlayerData.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameBaseObject;

@interface PlayerData : GameBaseObject 
{
	enPlayerState  m_enState;
}

-(enObjectType)getType;
-(enPlayerState)getState;
-(void)reset;
-(void)startMotion;
-(void)stopMotion;
-(void)startJump;
-(void)stopJump;
-(void)startShoot;
-(void)stopShoot;
-(void)dead;
-(BOOL)isMotion;
-(BOOL)isJump;
-(BOOL)isShoot;
-(BOOL)isShootAndMotion;
-(BOOL)isShootAndJump;
-(BOOL)isStop;
-(BOOL)isDead;

-(BOOL)hitHead:(CGPoint)point;
-(BOOL)hitBody:(CGPoint)point;
-(CGPoint)getHeadPosition;

@end
