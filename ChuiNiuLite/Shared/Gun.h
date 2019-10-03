//
//  Gun.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-28.
//  Copyright xgadget. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GunOwnership.h"
#import "GunEventDelegate.h"
#import "GunTarget.h"

@interface Gun : GameBaseObject <GunEventDelegate>
{
	id<GameEventNotification>	m_EventDispatcher;
	
	id<GunOwnership>	m_Shooter;
	id<GunTarget>		m_Target;
	id<GunTarget>       m_Aliens;
	NSMutableArray*		m_Bullets;
	BOOL				m_bBulletReusable;
	Gun*				m_EmenyGun;
}

@property (nonatomic, retain)id<GameEventNotification>	m_EventDispatcher;
@property (nonatomic, retain)id<GunOwnership>	m_Shooter;
@property (nonatomic, retain)id<GunTarget>		m_Target;
@property (nonatomic, retain)id<GunTarget>      m_Aliens;
@property (nonatomic, retain)Gun*				m_EmenyGun;
@property (nonatomic)BOOL						m_bBulletReusable;

-(void)reset;

-(void)shootAt:(CGPoint)fromPt withSpeed:(CGPoint)speed;
-(void)shoot;
-(int)bulletInGun;
-(BOOL)onTimerEvent;
-(void)addBullet:(BulletObject*)bullet;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;

-(BOOL)bulletHitByEmeny:(BulletObject*)bullet;

//GunEventDelegate function
-(void)bulletBlasted:(BulletObject*)bullet;


@end
