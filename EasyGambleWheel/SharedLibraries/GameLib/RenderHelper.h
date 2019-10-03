//
//  RenderHelper.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@import UIKit;

@interface RenderHelper : NSObject

+(void)InitializeResource;
+(void)ReleaseResource;

+(void)DrawAvatarIdle:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withFlag:(BOOL)isMe;
+(void)DrawAvatarPlay:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withFlag:(BOOL)isMe;
+(void)DrawAvatarResult:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withResult:(BOOL)bWinResult withFlag:(BOOL)isMe;
+(void)DrawLuckSignBackground:(CGContextRef)context at:(CGRect)rect;
+(void)DrawLuckSignBackground2:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBetSignBackground:(CGContextRef)context at:(CGRect)rect;
+(void)DrawRedStar:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCashPaper:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCrossSign:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCashOctagon:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCashEarnIconMe:(CGContextRef)context at:(CGRect)rect;
+(void)DrawCashEarnIconOther:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDisableCashEarnIconMe:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDisableCashEarnIconOther:(CGContextRef)context at:(CGRect)rect;
+(void)DefaultPatternFill:(CGContextRef)context withAlpha:(CGFloat)fAlpha atRect:(CGRect)rect;
+(void)DrawOnLineGroupIcon:(CGContextRef)context at:(CGRect)rect;
+(void)DrawEnableDisableSign:(CGContextRef)context at:(CGRect)rect sign:(BOOL)bEnable;
+(void)DrawGreenQmark:(CGContextRef)context at:(CGRect)rect;
+(void)DrawYellowQmark:(CGContextRef)context at:(CGRect)rect;

+(void)DrawBlueGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBlueHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;

+(void)DrawOnlinePlayerGesture:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index;
+(void)DrawOnlinePlayeHat:(CGContextRef)context withRect:(CGRect)rect;
+(void)DrawFoodIcon:(CGContextRef)context at:(CGRect)rect index:(int)i;
+(void)DrawFlowerIcon:(CGContextRef)context at:(CGRect)rect index:(int)i;
+(void)DrawAnimalIcon:(CGContextRef)context at:(CGRect)rect index:(int)i;
+(void)DrawEasterEggIcon:(CGContextRef)context at:(CGRect)rect index:(int)i;
+(void)DrawAnimal1Icon:(CGContextRef)context at:(CGRect)rect index:(int)i;
+(void)DrawAnimal2Icon:(CGContextRef)context at:(CGRect)rect index:(int)i;
+(void)DrawKuloIcon:(CGContextRef)context at:(CGRect)rect index:(int)i;

+(void)DrawSpiral:(CGContextRef)context at:(CGRect)rect;

@end
