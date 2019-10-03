//
//  PlayerObject.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-27.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GunOwnership.h"
#import "GunTarget.h" 
#import "GameEventNotification.h"
#import "BlockTarget.h"

@class PlayerData;
@class Gun;

#define GAME_SHOOT_FRAME		5
#define GAME_TAP_STEP			40

@interface PlayerObject : NSObject <GunOwnership, GunTarget, BlockTarget> 
{
	id<GameEventNotification>	m_EventDispatcher;
	
	PlayerData*		m_Player;
	Gun*			m_Gun;
	CGPoint			m_touchPoint;
	int				m_nTimerStep;
	int				m_nAnimationStep;

	int				m_nShootStep;
	
	int				m_nJumpStep;
	float			m_fJumpAngle;
	int				m_nJumpShootStep;

	int				m_nTapStep1;
	int				m_nTapStep2;
	
	BOOL			m_bTouched;
	int				m_nDeadStep;	
	CGPoint			m_DeathAnimationOffset;
	
	id<BlockDelegate>          m_Blockage;
    
	CGColorSpaceRef             m_ShadowClrSpace;
	CGColorRef                  m_ShadowClrs;
	CGSize                      m_ShadowSize;
}

@property (nonatomic, retain)Gun*						m_Gun;
@property (nonatomic)CGPoint							m_touchPoint;
@property (nonatomic, retain)id<GameEventNotification>	m_EventDispatcher;
@property (nonatomic, retain)id<BlockDelegate>          m_Blockage;

-(BOOL)isNormalAnimation;
-(BOOL)isNormalShootAnimation;
-(BOOL)isNormalJumpAnimation;
-(BOOL)isJumpShootAnimation;

-(BOOL)isInTap1;
-(void)enterTap1;
-(BOOL)isInWaitTap2;
-(BOOL)isInTapState;
-(void)enterTap2;
-(void)cleanTapFlags;

-(void)setTouched:(BOOL)bTouched;
-(BOOL)isTouched;

//PlayData handle function
-(void)reset;
-(void)startMotion;
-(void)stopMotion;
-(void)startJump;
-(void)stopJump;
-(void)startShoot;
-(void)stopShoot;
-(void)dead;
-(void)deadToGround;
-(BOOL)isMotion;
-(BOOL)isJump;
-(BOOL)isShoot;
-(BOOL)isShootAndMotion;
-(BOOL)isShootAndJump;
-(BOOL)isStop;
-(BOOL)isDead;

//GameBaseData handle function
-(void)moveTo:(CGPoint)pt;
-(void)setSize:(CGSize)size;
-(CGPoint)getPosition;
-(CGPoint)getHeadPosition;
-(CGSize)getSize;
-(CGRect)getBound;
-(enHitObjectState)getHitTestState;
-(BOOL)hitTestWithPoint:(CGPoint)point;
-(BOOL)hitTestWithRect:(CGRect)rect;
-(BOOL)hitHead:(CGPoint)point;
-(BOOL)hitBody:(CGPoint)point;

//Location and size in screen view coordinate
-(CGSize)getSizeInView;						//Base on game view coordinate system
-(CGRect)getBoundInView;					//Base on game view coordinate system
-(CGPoint)getPositionInView;				//Base on game view coordinate system

//GunOwnership funtion
-(void)fire;
-(int)bulletInGun;

//GunTarget function
-(BOOL)hit:(BulletObject*)bullet;

//BlockTarget function
-(void)pushBack:(CGPoint)pt;
-(BOOL)blockBy:(id)blockage;
-(BOOL)hitTestWithBlockage:(id)blockage;
-(void)escapeFromBlockage:(id)blockage;
-(BOOL)moveBackFromBlockage:(float)x;


-(BOOL)isBlocked;

-(BOOL)resetPosition;

-(BOOL)onTimerEvent;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;
-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect;
@end
