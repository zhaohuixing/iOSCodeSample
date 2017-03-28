/*
 *  drawhelper.h
 *  XXXX
 *
 *  Created by Zhaohui Xing on 10-02-13.
 *  Copyright 2010 Zhaohui Xing. All rights reserved.
 *
 */
//#include <QuartzCore/QuartzCore.h>
//#include <QuartzCore.h>
#import <Foundation/Foundation.h>

CGFunctionRef CreateSadingFunctionWithColors(const CGFloat startColor[3], const CGFloat endColor[3]);
void DrawLine1(CGContextRef context, CGPoint startPt, CGPoint endPt);
void DrawLine2(CGContextRef context, CGFloat startx, CGFloat starty, CGFloat endx, CGFloat endy);
CGImageRef CreateNumericImage(const char* nNumber);
CGPoint demoLGStart(CGRect bounds);
CGPoint demoLGEnd(CGRect bounds);
CGPoint demoRGCenter(CGRect bounds);
CGFloat demoRGInnerRadius(CGRect bounds);
CGFloat demoRGOuterRadius(CGRect bounds);

void AddRoundRectToPath(CGContextRef context, CGRect rect, CGSize oval, CGFloat fr);

CGImageRef CreateNumericImageWithColor(const char* nNumber, const CGFloat clr[4]);

/*
void DrawPatternImage(void *pImage, CGContextRef pContext);
void ReleasePatternImage(void *pImage);
*/
CGImageRef CloneImage(CGImageRef srcImage, bool bFlip);

//void DrawTextAtCenter(CGContextRef context, NSString *fontname, float textsize, NSString *text, CGPoint point, UIColor *color);