//
//  BulletData.h
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameBaseObject;

@interface BulletData : GameBaseObject 
{
	enBulletState		m_enState;
}

-(enObjectType)getType;
-(enBulletState)getBulletState;	
-(void)shoot;
-(void)blast;
-(void)reset;
-(BOOL)isShoot;
-(BOOL)isBlast;
-(BOOL)isReady;

@end
