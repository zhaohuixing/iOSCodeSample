//
//  ImageLoader.h
//  ChuiNiu
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

+ (CGImageRef)LoadCowImage1:(float)width andHeight:(float)height;
+ (CGImageRef)LoadCowImage2:(float)width andHeight:(float)height;
+ (CGImageRef)LoadCowImage3:(float)width andHeight:(float)height;
+ (CGImageRef)LoadCowImage4:(float)width andHeight:(float)height;
+ (CGImageRef)LoadDeadCowImage:(float)width andHeight:(float)height;

+ (CGImageRef)LoadBlastImage:(float)width andHeight:(float)height;

+ (CGImageRef)CreatClockBackGround:(float)r;

+ (CGImageRef)LoadRainBowImage;
+ (CGImageRef)LoadCloudImage1;
+ (CGImageRef)LoadCloudImage2;
+ (CGImageRef)LoadRainImage1;
+ (CGImageRef)LoadRainImage2;
+ (CGImageRef)LoadLightImage1;
+ (CGImageRef)LoadLightImage2;

+ (CGImageRef)CreateLandScapeBKImage;
+ (CGImageRef)CreateProtraitBKImage;
+ (CGImageRef)CreatePaperBkgndImage;

+ (CGPatternRef)CreateImageFillPattern:(NSString*)file withWidth:(float)w withHeight:(float)h isFlipped:(BOOL)bFlipped;
+ (CGImageRef)CreateLandScapeNightImage;
+ (CGImageRef)CreateProtraitNightImage;

+ (CGImageRef)CreateTextImage:(NSString*)szText;

+ (UIColor*)GetDefaultViewBackgroundColor;
+ (float)GetDefaultViewFillAlpha;

+(CGImageRef)LoadImageWithName:(NSString*)imageName; 

@end
