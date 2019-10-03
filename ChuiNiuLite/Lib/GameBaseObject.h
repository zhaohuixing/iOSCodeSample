//
//  GameBaseObject.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameBaseObject : NSObject 
{
	CGPoint					m_Position;  //Base on game scence coordinate system
	CGPoint					m_Velocity;  //Base on game scence coordinate system
	CGSize					m_Size;		 //Base on game scence coordinate system	
	enHitObjectState		m_HitTestState;
}

-(void)moveTo:(CGPoint)pt;					//Base on game scence coordinate system
-(CGPoint)getPosition;						//Base on game scence coordinate system
-(void)setSize:(CGSize)size;				//Base on game scence coordinate system
-(CGSize)getSize;							//Base on game scence coordinate system
-(CGRect)getBound;							//Base on game scence coordinate system
-(void)setSpeed:(CGPoint)pt;				//Base on game scence coordinate system
-(CGPoint)getSpeed;							//Base on game scence coordinate system
-(void)setHitTestState:(enHitObjectState)hitTest;	//Base on game scence coordinate system
-(enHitObjectState)getHitTestState;					//Base on game scence coordinate system
-(BOOL)hitTestWithPoint:(CGPoint)point;				//Base on game scence coordinate system
-(BOOL)hitTestWithRect:(CGRect)rect;				//Base on game scence coordinate system
-(enObjectType)getType;
-(BOOL)outOfSceneBound;

//Location and size in screen view coordinate
-(CGSize)getSizeInView;						//Base on game view coordinate system
-(CGRect)getBoundInView;					//Base on game view coordinate system
-(CGPoint)getPositionInView;				//Base on game view coordinate system

@end
