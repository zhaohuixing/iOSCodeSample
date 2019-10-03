//
//  Blockage.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 10-08-11.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameEventNotification.h"
#import "BlockTarget.h"

@class AlienData;

@interface Blockage : NSObject <BlockDelegate>
{
	id<GameEventNotification>	m_EventDispatcher;
	id<BlockTarget>				m_BlockTarget;
	AlienData*					m_Alien;
	
	int                         m_nTimerElaspe;
	int							m_nTimerStep;
	//CGImageRef					m_Image;
    int                         m_nImageType;
	BOOL						m_bShaking;
	float						m_fShakingAngle;
	int							m_nShakeStep;
}

@property (nonatomic, retain)id<GameEventNotification>	m_EventDispatcher;
@property (nonatomic, retain)id<BlockTarget>			m_BlockTarget;

//-(void)setImage:(CGImageRef)image;
-(void)setImageType:(int)nType;
-(void)setShaking:(BOOL)bShaking;

//Alien Data functions
-(void)reset;
-(void)blast;
-(void)startMotion;
-(BOOL)isBlast;
-(BOOL)isMotion;
-(BOOL)isStop;

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

-(void)detachTarget;

-(BOOL)onTimerEvent;
-(BOOL)outOfSceneBound;
-(void)setTimerElaspe:(int)nInterval;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;

@end
