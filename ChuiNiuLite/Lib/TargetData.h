//
//  TargetData.h
//  XXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameBaseObject;


@interface TargetData : GameBaseObject 
{
	enTargetState		m_enState;
}

-(enObjectType)getType;

-(enTargetState)getState;
-(void)reset;
-(void)shoot;
-(void)crash;
-(void)blowout;
-(void)knockdown;

-(BOOL)isShoot;
-(BOOL)isCrash;
-(BOOL)isBlowout;
-(BOOL)isKnockout;
-(BOOL)isNormal;
@end
