//
//  RainBow.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-25.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <Foundation/Foundation.h>

@class AlienData;

@interface RainBow : NSObject 
{
	AlienData*					m_Alien;
	CGImageRef					m_Image;
	int                         m_nTimerElaspe;
	int							m_nTimerStep;
    int                         m_nBirdStep;
}

-(void)setToStartPosition;

//Alien Data functions
-(void)reset;
-(void)startMotion;
-(void)stopAtWin;
-(BOOL)isMotion;
-(BOOL)isWin;

//GameBaseData handle function
-(void)moveTo:(CGPoint)pt;
-(CGPoint)getPosition;
-(CGSize)getSize;
-(void)setSize:(CGSize)size;
-(CGRect)getBound;
-(void)setSpeed:(CGPoint)pt;
-(CGPoint)getSpeed;

//Location and size in screen view coordinate
-(CGSize)getSizeInView;						//Base on game view coordinate system
-(CGRect)getBoundInView;					//Base on game view coordinate system
-(CGPoint)getPositionInView;				//Base on game view coordinate system


-(BOOL)onTimerEvent;
-(void)draw:(CGContextRef)context inRect:(CGRect)rect;
-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect;

@end
