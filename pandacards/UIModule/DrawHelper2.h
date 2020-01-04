//
//  DrawHelper2.h
//  XXXXXXXXXXXXX
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawHelper2 : NSObject

+(void)InitializeResource;
+(void)ReleaseResource;

+(void)DrawBlueGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBlueHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGreenGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGreenHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect;

+(void)DrawDefaultAlertBackground:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDefaultAlertBackgroundDecoration:(CGContextRef)context;
+(void)DrawOptionalAlertBackground:(CGContextRef)context at:(CGRect)rect;
+(void)DrawOptionalAlertBackgroundDecoration:(CGContextRef)context;
+(void)DrawDefaultFrameViewBackground:(CGContextRef)context at:(CGRect)rect;
+(void)DrawDefaultFrameViewBackgroundDecoration:(CGContextRef)context;
+(void)DrawGrayFrameViewBackgroundDecoration:(CGContextRef)context;
+(void)DrawHalfSizeGrayBackgroundDecoration:(CGContextRef)context;

+(void)DrawBlueTextureRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawBlueTexturePath:(CGContextRef)context;
+(void)DrawRedTextureRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGreenTextureRect:(CGContextRef)context at:(CGRect)rect;
+(void)DrawGrayTextureRect:(CGContextRef)context at:(CGRect)rect;

@end
