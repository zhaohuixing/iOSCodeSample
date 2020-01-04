//
//  ImageLoader.h
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-08-04.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageLoader : NSObject 
{
}

+ (void)Initialize;
+ (void)Release;

+ (CGImageRef)CreateLandScapeBKImage;
+ (CGImageRef)CreateProtraitBKImage;

+ (CGPatternRef)CreateImageFillPattern:(NSString*)file withWidth:(float)w withHeight:(float)h isFlipped:(BOOL)bFlipped;

+ (CGImageRef)CreateTextImage:(NSString*)szText;

+ (UIColor*)GetDefaultViewBackgroundColor;
+ (float)GetDefaultViewFillAlpha;

+(CGImageRef)getTransformResizImage:(CGImageRef)srcImage subRect:(CGRect)rect;

+(CGImageRef)LoadResourceImage:(NSString*)imageName; 	
+(CGImageRef)LoadImageWithName:(NSString*)imageName; 	

+(CGImageRef)LoadImage:(NSString*)imageName withWidth:(float)width withHeight:(float)height; 	

+ (void)DrawNumber:(CGContextRef)context withNumber:(int)value inRect:(CGRect)rect;

@end
