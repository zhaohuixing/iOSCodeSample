//
//  CCompassRender.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
@import UIKit;
@import CoreGraphics;


@interface CCompassRender : NSObject

+(CGFloat)GetCompassImageSize;
+(CGFloat)GetCompassRenderContextSize;

+(CGImageRef)CreateCompass8Image;
+(CGImageRef)CreateCompass6Image;
+(CGImageRef)CreateCompass4Image;
+(CGImageRef)CreateCompass2Image;

-(void)DrawGameReadyHighlight:(CGContextRef)context at:(CGRect)rect;
-(void)DrawGameResultHighlight:(CGContextRef)context at:(CGRect)rect index:(int)WinIndex;
-(void)DrawCompass:(CGContextRef)context at:(CGRect)rect;
-(void)SetCurrentGameType:(int)nType theme:(int)themeType;
-(void)OnTimerEventReady;
-(void)OnTimerEventResult;
-(void)Reset;

@end
