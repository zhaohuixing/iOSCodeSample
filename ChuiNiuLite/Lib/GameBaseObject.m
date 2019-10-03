//
//  GameBaseObject.m
//  XXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h" 
#import "GameBaseObject.h"


@implementation GameBaseObject

-(id)init
{
	if((self = [super init]))
	{
		m_Position = CGPointMake(0.0, 0.0);
		m_Velocity = CGPointMake(0.0, 0.0);
		m_Size = CGSizeMake(1.0, 1.0);
		m_HitTestState = GAME_HITOBJECT_NONE;
	}	
	
	return self;
}	

-(void)moveTo:(CGPoint)pt
{
	m_Position.x = pt.x;
	m_Position.y = pt.y;
}

-(CGPoint)getPosition
{
	return m_Position;
}

-(void)setSize:(CGSize)size
{
	m_Size.width = size.width;
	m_Size.height = size.height;
}

-(CGSize)getSize
{
	return m_Size;
}	

-(CGRect)getBound
{
	float w = m_Size.width*[CGameLayout GetGameSceneDMScaleY]/[CGameLayout GetGameSceneDMScaleX];
	float h = m_Size.height;
	CGRect rect = CGRectMake(m_Position.x-w*0.5, 
							 m_Position.y-h*0.5, 
							 w, 
							 h);
	
	return rect;
}	

-(BOOL)outOfSceneBound
{
	BOOL bRet = NO;

	float w = [CGameLayout GetGameSceneWidth]*0.5f;
	float h = [CGameLayout GetGameSceneHeight];

	
	if(m_Position.x < -w || w < m_Position.x || m_Position.y < 0 || h < m_Position.y)
		bRet = YES;
	
	return bRet;
}	

-(void)setSpeed:(CGPoint)pt
{
	m_Velocity.x = pt.x;
	m_Velocity.y = pt.y;
}

-(CGPoint)getSpeed
{
	return m_Velocity;
}

-(void)setHitTestState:(enHitObjectState)hitTest
{
	m_HitTestState = hitTest;
}

-(enHitObjectState)getHitTestState
{
	return m_HitTestState;
}	

-(BOOL)hitTestWithPoint:(CGPoint)point
{
	CGRect rect = [self getBound];
	if(CGRectContainsPoint(rect, point) == true)
		return YES;
	else 
		return NO;
}

-(BOOL)hitTestWithRect:(CGRect)rt
{
	CGRect rect = [self getBound];
	if(CGRectContainsRect(rect, rt) == true ||
	   CGRectContainsRect(rt, rect) == true ||
	   CGRectIntersectsRect(rect, rt) == true ||
	   CGRectEqualToRect(rect, rt) == true )
		return YES;
	else 
		return NO;
}	

-(enObjectType)getType
{
	return GAME_OBJECT_NONE; 
}	

//Location and size in screen view coordinate
-(CGSize)getSizeInView						//Base on game view coordinate system
{
	float x = [CGameLayout ObjectMeasureToDevice:m_Size.width];
	float y = [CGameLayout ObjectMeasureToDevice:m_Size.height];
	
	CGSize size = CGSizeMake(x, y);
	return size;
}

-(CGRect)getBoundInView					//Base on game view coordinate system
{
	float x = [CGameLayout GameSceneToDeviceX:m_Position.x];
	float y = [CGameLayout GameSceneToDeviceY:m_Position.y];
	float w = [CGameLayout ObjectMeasureToDevice:m_Size.width];
	float h = [CGameLayout ObjectMeasureToDevice:m_Size.height];

	CGRect rect = CGRectMake(x-w*0.5, y-h*0.5, w, h);
	
	return rect;
}

-(CGPoint)getPositionInView				//Base on game view coordinate system
{
	float x = [CGameLayout GameSceneToDeviceX:m_Position.x];
	float y = [CGameLayout GameSceneToDeviceY:m_Position.y];
	
	CGPoint pt = CGPointMake(x, y);
	return pt;
}

@end
