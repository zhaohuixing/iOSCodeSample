//
//  GameGround.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-10.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BlockTarget.h"

@class Blockage;

@interface GameGround : NSObject 
{
	id<BlockTarget> m_BlockTarget;
	NSMutableArray*	m_Skill1Blocks;
	NSMutableArray*	m_Skill2Blocks;
	NSMutableArray*	m_Skill3Blocks;
	int				m_nShootStep;
	int				m_nShootThreshold;
	int				m_nShootMaxInterval;
	
	int				m_nTimerStep;
	int				m_nAnimationStep;
	//CGImageRef		m_MudImage;
}
@property (nonatomic, retain)id<BlockTarget>			m_BlockTarget;

-(void)reset;
-(void)shootAt:(CGPoint)fromPt withSpeed:(CGPoint)speed;
-(int)blocksInQueue;
-(void)addBlocks:(Blockage*)block atSkill:(int)nSkill;
-(void)adjustTargetFreePosition;
-(BOOL)blockageHitTestWithTarget;

-(BOOL)onTimerEvent;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;
-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect;
-(void)drawGrass:(CGContextRef)context inRect:(CGRect)rect;

@end
