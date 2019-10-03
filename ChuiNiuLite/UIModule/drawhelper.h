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

CGImageRef CreateNumericImageWithColor(const char* nNumber, const float clr[4]);

void DrawPatternImage(void *pImage, CGContextRef pContext);
void ReleasePatternImage(void *pImage);
