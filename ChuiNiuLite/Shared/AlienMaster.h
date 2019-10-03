//
//  AlienMaster.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-09.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameEventNotification.h"
#import "AlienTarget.h"
#import "RainBow.h"

@interface AlienMaster : NSObject <GunTarget> 
{
	id<GameEventNotification>	m_EventDispatcher;
	NSMutableArray*				m_Aliens;
	int                         m_nTimerElaspe;
	int							m_nTimerStep;
	int							m_nShootStep;
	int							m_nShootThreshold;
	//int							m_nShootMaxInterval;
	id<AlienTarget>				m_Target;
	RainBow*					m_Rainbow;
	int							m_nShootRainBowTime;
}

@property (nonatomic, retain)id<GameEventNotification>	m_EventDispatcher;
@property (nonatomic, retain)id<AlienTarget>			m_Target;

-(void)reset;
-(BOOL)hit:(BulletObject*)bullet;
-(void)shootAt:(CGPoint)fromPt withSpeed:(CGPoint)speed;
-(BOOL)shoot;
-(int)aliensInQueue;
-(BOOL)onTimerEvent;
-(void)addAlien:(AlienObject*)alien;
-(BOOL)knockDown:(id<AlienTarget>)target;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;
-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect;

-(void)ShootRainBow;
@end
