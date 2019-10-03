/*
 *  drawhelper.h
 *  XXXX
 *
 *  Created by Zhaohui Xing on 10-02-13.
 *  Copyright 2010 Zhaohui Xing. All rights reserved.
 *
 */
@import UIKit;
#include <QuartzCore/QuartzCore.h>

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
void AddRoundedRectToPathWithoutScale (CGContextRef context, CGRect rect, CGFloat fr);

CGImageRef CreateNumericImageWithColor(const char* nNumber, const CGFloat clr[4]);

void DrawPatternImage(void *pImage, CGContextRef pContext);
void ReleasePatternImage(void *pImage);

CGImageRef CreateDSatr(CGFloat imageSize, const CGFloat clr[4]);
CGImageRef CreateGradientDSatrImage(CGFloat imageSize, const CGFloat clr1[4], const CGFloat clr2[4]);
CGImageRef CreateGradientHSatrImage(CGFloat imageSize, const CGFloat clr1[4], const CGFloat clr2[4]);
CGImageRef CreateGradientSSatrImage(CGFloat imageSize, const CGFloat clr1[4], const CGFloat clr2[4]);

CGImageRef CreateGradientFlowerNumberImage(char* number, CGFloat imageSize, const CGFloat clr1[4], const CGFloat clr2[4]);
CGImageRef CreateGradientBubbleImage(CGFloat imageSize, const CGFloat clr1[4], const CGFloat clr2[4]);

CGImageRef CreateRedNoiseImage(int nSize);


int GetRandNumber(void);
int CounterClockWise(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat xc, CGFloat yc);

CGImageRef CloneImage(CGImageRef srcImage, bool bFlip);

CFStringRef CreateCFStringFromASCIIString(const char* str);