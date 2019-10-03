//
//  RenderHelper.h
//  XXXXXXXXXXXXX
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RenderHelper : NSObject

+(void)InitializeResource;
+(void)ReleaseResource;

+(void)DrawStartPattern1Fill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect;
+(void)DrawStartPattern2Fill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect;
+(void)DrawMoon:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawGroundMud:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawGrassUnit:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawHat:(CGContextRef)context atRect:(CGRect)rect;

+(void)DrawDogStand:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogWalk1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogWalk2:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogWalk3:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogWalk4:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogWalk:(CGContextRef)context withIndex:(int)nAniStep atRect:(CGRect)rect;

+(void)DrawDogStopShoot:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogShoot1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogShoot2:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogShoot3:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogShoot:(CGContextRef)context withIndex:(int)nAniStep atRect:(CGRect)rect;

+(void)DrawDogJump1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogJump2:(CGContextRef)context atRect:(CGRect)rect;

+(void)DrawDogJump:(CGContextRef)context withIndex:(int)nAniStep atRect:(CGRect)rect;

+(void)DrawDogJumpShoot1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogJumpShoot2:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawDogJumpShoot:(CGContextRef)context withIndex:(int)nAniStep atRect:(CGRect)rect;
+(void)DrawDogDeath:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawAirBubble:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawPoop:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawRock1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawSnail:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawRock2:(CGContextRef)context atRect:(CGRect)rect;

+(void)DrawCloud1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawCloud2:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawRainCloud1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawRainCloud2:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawBlast:(CGContextRef)context atRect:(CGRect)rect;

+(void)DrawBirdFly1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawBirdFly2:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawBirdShoot1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawBirdShoot2:(CGContextRef)context atRect:(CGRect)rect;

+(void)DrawBirdBubble:(CGContextRef)context atRect:(CGRect)rect;

+(void)DrawFlyingCowIconPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect;

+(void)DrawMouthNormal:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawMouthBeath1:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawMouthBeath2:(CGContextRef)context atRect:(CGRect)rect;
+(void)DrawMouthBeath3:(CGContextRef)context atRect:(CGRect)rect;


@end
