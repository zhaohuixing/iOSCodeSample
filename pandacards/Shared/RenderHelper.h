//
//  RenderHelper.h
//  MindFire
//
//  Created by Zhaohui Xing on 10-03-22.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RenderHelper : NSObject 
{
}

+ (void)Intialize;
+ (void)Release;
+ (void)DrawTempCard:(CGContextRef)context withImage:(CGImageRef)cardImg inRect:(CGRect)rect witHit:(BOOL)bHighlight;
+ (void)AddRoundRectToPath:(CGContextRef)context withRect:(CGRect)rect withOval:(CGSize)oval;
+ (CGImageRef)GetTempCardImage_p:(int)nCard;
+ (void)DrawSigns:(CGContextRef)context withSign:(int)nOperator witHit:(BOOL)bHighlight inRect:(CGRect)rect;
+ (void)DrawSingleSign:(CGContextRef)context withSign:(int)nOperator witHit:(BOOL)bHighlight inRect:(CGRect)rect;
+ (void)DrawGhost:(CGContextRef)context inRect:(CGRect)rect withIndex:(int)aniIndex;
//+ (void)DrawGhostHorizontalFlip:(CGContextRef)context inRect:(CGRect)rect;
+ (void)CreateFourFlowerPath:(CGContextRef)context withRect:(CGRect)rect;
+ (void)CreateQuarterFlowerPath:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)i;
+ (void)ReloadGhostImage;


+ (void)DrawBasicCardAnimation:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect witHit:(BOOL)bHighlight;

+ (void)DrawBulletinSign:(CGContextRef)context withSign:(int)nCount inRect:(CGRect)rect withType:(BOOL)bWinSign;
+ (void)DrawRotateBulletinSign:(CGContextRef)context withSign:(int)nCount inRect:(CGRect)rect withAngle:(float)fRotateAngle;

+ (void)DrawBulletinSign2:(CGContextRef)context withSign:(int)nCount inRect:(CGRect)rect withType:(BOOL)bWinSign;


+ (void)DrawSimpleCardNumber:(CGContextRef)context withCard:(int)index inRect:(CGRect)rect;
+ (void)drawSimpleCardNumber:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect;

+(void)DefaultPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect;
+(void)DrawGreenPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect;
+(void)DrawNumericPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect;

+(void)DrawAvatarIdle:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withFlag:(BOOL)isMe;
+(void)DrawAvatarPlay:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withFlag:(BOOL)isMe;
+(void)DrawAvatarResult:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withResult:(BOOL)bWinResult withFlag:(BOOL)isMe;

+(void)DrawOnlinePlayerGesture:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index;
+(void)DrawOnlinePlayeHat:(CGContextRef)context withRect:(CGRect)rect;

@end
