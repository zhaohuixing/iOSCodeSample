//
//  BulletObject.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-28.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GameEventNotification.h"

@class BulletData; 
@protocol GunEventDelegate; 


@interface BulletObject : NSObject
{
	id<GameEventNotification>	m_EventDispatcher;
	
	BulletData*					m_Bullet;
	id<GunEventDelegate>		m_Gun;
	int                         m_nTimerElaspe;
	int							m_nTimerStep;
	int							m_nBlastAnimationStep;
	int							m_nBlastCount;
	//CGImageRef					m_Image;
	BOOL                        m_bBubble;
	float						m_fOriginalWith;
	float						m_fOriginalHeight;
	float						m_fStartRatioX;
	float						m_fStartRatioY;
	float						m_fChangeRatioX;
	float						m_fChangeRatioY;
    
	CGColorSpaceRef             m_ShadowClrSpace;
	CGColorRef                  m_ShadowClrs;
	CGSize                      m_ShadowSize;
}

@property (nonatomic, retain)id<GameEventNotification>	m_EventDispatcher;
@property (nonatomic)BOOL                               m_bBubble;
@property (nonatomic)float								m_fStartRatioX;
@property (nonatomic)float								m_fStartRatioY;
@property (nonatomic)float								m_fChangeRatioX;
@property (nonatomic)float								m_fChangeRatioY;


-(id)initWithGun:(id)gun inFrame:(CGRect)frame;
-(BOOL)onTimerEvent;
-(BOOL)outOfSceneBound;
-(void)setTimerElaspe:(int)nInterval;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;

//Bullet data function
-(void)shoot;
-(void)blast;
-(void)reset;
-(BOOL)isShoot;
-(BOOL)isBlast;
-(BOOL)isReady;

//GameBaseData handle function
-(void)moveTo:(CGPoint)pt;
-(CGPoint)getPosition;
-(CGSize)getSize;
-(CGRect)getBound;
-(void)setSpeed:(CGPoint)pt;
-(CGPoint)getSpeed;
-(enHitObjectState)getHitTestState;
-(BOOL)hitTestWithPoint:(CGPoint)point;
-(BOOL)hitTestWithRect:(CGRect)rect;
-(BOOL)hit:(BulletObject*)bullet;

//Location and size in screen view coordinate
-(CGSize)getSizeInView;						//Base on game view coordinate system
-(CGRect)getBoundInView;					//Base on game view coordinate system
-(CGPoint)getPositionInView;				//Base on game view coordinate system


@end
