//
//  TargetObject.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-28.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GunTarget.h" 
#import "GameEventNotification.h"
#import "AlienTarget.h"

@class TargetData;
@class Gun;

#define GAME_TARGET_ANIMATION_FRAME		6
#define GAME_TARGET_KNOCKDOWN_FRAME		12
#define GAME_TARGET_BLOWOUT_FRAME		3

@interface TargetObject : NSObject <GunOwnership, GunTarget, AlienTarget>
{
	id<GameEventNotification>	m_EventDispatcher;
	
	TargetData*		m_Target;
	Gun*			m_Gun;
	int				m_nTimerStep;
	int				m_nTimerElapse;
	float			m_fBack;
	int				m_nShootStep;
	int				m_nShootThreshold;
	int				m_nShootMaxInterval;
	int				m_nAnimationStep;
	int				m_nAnimationDelay;
	int				m_nAnimationDelayThreshold;
	CGImageRef		m_Animations[GAME_TARGET_ANIMATION_FRAME];
	float			m_AnimationAngle[GAME_TARGET_ANIMATION_FRAME];
	int				m_nKnockDownStep;
	float           m_fKnockDownStepLenght;
	CGImageRef		m_DeathAnimation;
	
	int				m_nHitThreshold;
	int				m_nHitCount;
	int				m_nHitCountStep;
	int				m_nHitDeducable;
	
	int				m_nBlowOutStep;
	//CGImageRef		m_BlastAnimation;

	CGColorSpaceRef             m_ShadowClrSpace;
	CGColorRef                  m_ShadowClrs;
	CGSize                      m_ShadowSize;
    
}

@property (nonatomic, retain)Gun*						m_Gun;
@property (nonatomic, retain)id<GameEventNotification>	m_EventDispatcher;

//Target data functions
-(void)reset;
-(void)shoot;
-(void)crash;
-(void)blowout;
-(void)knockdown;
-(BOOL)hit:(BulletObject*)bullet;
-(BOOL)isShoot;
-(BOOL)isCrash;
-(BOOL)isBlowout;
-(BOOL)isKnockout;
-(BOOL)isNormal;

//GameBaseData handle function
-(void)moveTo:(CGPoint)pt;
-(void)setSize:(CGSize)size;
-(CGPoint)getPosition;
-(CGSize)getSize;
-(CGRect)getBound;
-(void)setSpeed:(CGPoint)pt;
-(CGPoint)getSpeed;
-(enHitObjectState)getHitTestState;
-(BOOL)hitTestWithPoint:(CGPoint)point;
-(BOOL)hitTestWithRect:(CGRect)rect;

-(BOOL)hit:(BulletObject*)bullet;
-(BOOL)knockdownBy:(AlienObject*)alien;


//Location and size in screen view coordinate
-(CGSize)getSizeInView;						//Base on game view coordinate system
-(CGRect)getBoundInView;					//Base on game view coordinate system
-(CGPoint)getPositionInView;				//Base on game view coordinate system


-(CGPoint)getGunPoint;

//GunOwnership funtion
-(void)fire;
-(int)bulletInGun;

-(BOOL)onTimerEvent;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;
-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect;

@end
