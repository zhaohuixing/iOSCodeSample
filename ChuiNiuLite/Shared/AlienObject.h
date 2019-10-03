//
//  AlienObject.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-28.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameEventNotification.h"
#import "GunTarget.h"

@class AlienData;

@interface AlienObject : NSObject <GunTarget> 
{
	id<GameEventNotification>	m_EventDispatcher;
	AlienData*	m_Alien;
	
	int                         m_nTimerElaspe;
	int							m_nTimerStep;
	int							m_nBlastAnimationStep;
	int							m_nBlastCount;
	//CGImageRef					m_Image;
	//CGImageRef					m_BlastAnimation;
	//CGImageRef					m_Image2;
    int                         m_ImageType;
    
    int                         m_nBirdAnimation;
//int                         m_nBirdShootAnimation;
    
	float						m_fShakeY;
	float						m_nShakingStep;
	float						m_nShakingCount;

}

@property (nonatomic, retain)id<GameEventNotification>	m_EventDispatcher;

-(id)init:(int)index;

//Alien Data functions
-(void)reset;
-(void)blast;
-(void)startMotion;
-(BOOL)isBlast;
-(BOOL)isMotion;
-(BOOL)isStop;
-(enAlienType)getAlienType;
-(void)setAlienType:(enAlienType)enType;


//GameBaseData handle function
-(void)moveTo:(CGPoint)pt;
-(CGPoint)getPosition;
-(CGSize)getSize;
-(void)setSize:(CGSize)size;
-(CGRect)getBound;
-(enHitObjectState)getHitTestState;
-(BOOL)hitTestWithPoint:(CGPoint)point;
-(BOOL)hitTestWithRect:(CGRect)rect;
-(void)setSpeed:(CGPoint)pt;
-(CGPoint)getSpeed;

//Location and size in screen view coordinate
-(CGSize)getSizeInView;						//Base on game view coordinate system
-(CGRect)getBoundInView;					//Base on game view coordinate system
-(CGPoint)getPositionInView;				//Base on game view coordinate system

-(BOOL)hit:(BulletObject*)bullet;

-(BOOL)onTimerEvent;
-(BOOL)outOfSceneBound;
-(void)setTimerElaspe:(int)nInterval;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;

@end
