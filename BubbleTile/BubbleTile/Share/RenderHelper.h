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

+(void)DefaultPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect;
+(void)DrawGreenPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect;
+(void)DrawRedBubble:(CGContextRef)context at:(CGRect)rect;
+(void)DrawStarBubble:(CGContextRef)context at:(CGRect)rect;
+(void)DrawFrogBubble:(CGContextRef)context at:(CGRect)rect;
+(void)DrawFrogMotionBubble:(CGContextRef)context at:(CGRect)rect;
+(void)DrawHeartBubble:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBlueBubble:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBoard:(CGContextRef)context at:(CGRect)rect;


+(float)GetBubbleImageWidth;
+(float)GetBubbleImageHeight;
+(void)DrawRedIndicator:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGreenIndicator:(CGContextRef)context at:(CGRect)rect;
+(void)DrawQmark:(CGContextRef)context inRect:(CGRect)rect;
+(void)DrawRedQmark:(CGContextRef)context inRect:(CGRect)rect;
+(CGImageRef)GetPlayHelpMarkImage:(int)enBubbleType;
@end
