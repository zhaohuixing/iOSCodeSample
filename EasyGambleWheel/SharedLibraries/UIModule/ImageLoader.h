//
//  ImageLoader.h
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-08-04.
//  Copyright 2010 xgadget. All rights reserved.
//

@import UIKit;


@interface ImageLoader : NSObject 
{
}

+ (void)Initialize;
+ (void)Release;

+ (CGPatternRef)CreateImageFillPattern:(NSString*)file withWidth:(CGFloat)w withHeight:(CGFloat)h isFlipped:(BOOL)bFlipped;

+ (CGImageRef)CreateTextImage:(NSString*)szText;

+ (UIColor*)GetDefaultViewBackgroundColor;
+ (CGFloat)GetDefaultViewFillAlpha;

+(CGImageRef)getTransformResizImage:(CGImageRef)srcImage subRect:(CGRect)rect;

+(CGImageRef)LoadResourceImage:(NSString*)imageName; 	
+(CGImageRef)LoadImageWithName:(NSString*)imageName; 	

+(CGImageRef)LoadImage:(NSString*)imageName withWidth:(float)width withHeight:(float)height; 	

+ (void)DrawNumber:(CGContextRef)context withNumber:(int)value inRect:(CGRect)rect;


@end
