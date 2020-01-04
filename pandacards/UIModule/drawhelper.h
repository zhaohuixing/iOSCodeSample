/*
 *  drawhelper.h
 *  XXXX
 *
 *  Created by Zhaohui Xing on 10-02-13.
 *  Copyright 2010 Zhaohui Xing. All rights reserved.
 *
 */
#include <QuartzCore/QuartzCore.h>

CGFunctionRef CreateSadingFunctionWithColors(const float startColor[3], const float endColor[3]);
void DrawLine1(CGContextRef context, CGPoint startPt, CGPoint endPt);
void DrawLine2(CGContextRef context, float startx, float starty, float endx, float endy);
CGImageRef CreateNumericImage(const char* nNumber);
CGPoint demoLGStart(CGRect bounds);
CGPoint demoLGEnd(CGRect bounds);
CGPoint demoRGCenter(CGRect bounds);
CGFloat demoRGInnerRadius(CGRect bounds);
CGFloat demoRGOuterRadius(CGRect bounds);

void AddRoundRectToPath(CGContextRef context, CGRect rect, CGSize oval, float fr);
void AddRoundedRectToPathWithoutScale (CGContextRef context, CGRect rect, float fr);

CGImageRef CreateNumericImageWithColor(const char* nNumber, const float clr[4]);

void DrawPatternImage(void *pImage, CGContextRef pContext);
void ReleasePatternImage(void *pImage);

CGImageRef CreateDSatr(float imageSize, const float clr[4]);
CGImageRef CreateGradientDSatrImage(float imageSize, const float clr1[4], const float clr2[4]);
CGImageRef CreateGradientHSatrImage(float imageSize, const float clr1[4], const float clr2[4]);
CGImageRef CreateGradientSSatrImage(float imageSize, const float clr1[4], const float clr2[4]);

CGImageRef CreateGradientFlowerNumberImage(char* number, float imageSize, const float clr1[4], const float clr2[4]);
CGImageRef CreateGradientBubbleImage(float imageSize, const float clr1[4], const float clr2[4]);

CGImageRef CreateRedNoiseImage(int nSize);


int GetRandNumber(void);
int CounterClockWise(float x1, float y1, float x2, float y2, float xc, float yc);

CGImageRef CloneImage(CGImageRef srcImage, bool bFlip);

