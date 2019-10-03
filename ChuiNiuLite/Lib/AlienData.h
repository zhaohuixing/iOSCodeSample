//
//  AlienData.h
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameBaseObject;

@interface AlienData : GameBaseObject 
{
	enAlienState	m_enState;
    enAlienType     m_enAlienType;
    enAlienBirdState m_enBirdState;
    CGSize          m_BaseSize;
    int             m_nBirdBubbleSizeChangeCount;
}

-(enObjectType)getType;
-(enAlienState)getState;
-(enAlienType)getAlienType;
-(void)setAlienType:(enAlienType)enType;
-(void)setSize:(CGSize)size;
-(void)setBirdState:(enAlienBirdState)enBirdState;
-(enAlienBirdState)getBirdState;
-(void)updateBirdBubbleSize;

-(void)reset;
-(void)blast;
-(void)startMotion;
-(BOOL)isBlast;
-(BOOL)isMotion;
-(BOOL)isStop;

@end
