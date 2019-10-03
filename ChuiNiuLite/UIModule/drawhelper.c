/*
 *  drawhelper.c
 *  XXXX
 *
 *  Created by Zhaohui Xing on 10-02-13.
 *  Copyright 2010 Zhaohui Xing. All rights reserved.
 *
 */
#include "drawhelper.h"

typedef struct stColorSet
{
	float m_StartColor[3];
	float m_EndColor[3];
} CMyColorSet;	

static void EvaluateColorsInfo(void* info, const float* in, float* out)
{
	if(info == NULL || in == NULL || out == NULL)
		return;
	
	CMyColorSet* colorMap = (CMyColorSet*)info;
	float* startColor = colorMap->m_StartColor;
	float* endColor = colorMap->m_EndColor;
	float input = in[0];
	out[0] = (startColor[0]*(1-input) + endColor[0]*input);
	out[1] = (startColor[1]*(1-input) + endColor[1]*input);
	out[2] = (startColor[2]*(1-input) + endColor[2]*input);

	out[3] = 1;
}	

static void ReleaseColorInfo(void* info)
{
	if(info)
		free(info);
}	

CGFunctionRef CreateSadingFunctionWithColors(const float startColor[3], const float endColor[3])
{
	CGFunctionRef			function;
	float					domain[2];
	float					range[8];
	CGFunctionCallbacks		shadingCallbacks;
	CMyColorSet				*colorMap;
	
	colorMap = (CMyColorSet*)malloc(sizeof(CMyColorSet));
	if(colorMap == NULL)
		return NULL;

	colorMap->m_StartColor[0] = startColor[0]; 
	colorMap->m_StartColor[1] = startColor[1];
	colorMap->m_StartColor[2] = startColor[2];
	
	colorMap->m_EndColor[0] = endColor[0]; 
	colorMap->m_EndColor[1] = endColor[1];
	colorMap->m_EndColor[2] = endColor[2];
	
	domain[0] = 0;
	domain[1] = 1; 
	
	//Red component
	range[0] = 0;
	range[1] = 1;

	//Green component
	range[2] = 0;
	range[3] = 1;

	//Blue component
	range[4] = 0;
	range[5] = 1;
	
	//Alpha component
	range[6] = 0;//0.6;//0.5;
	range[7] = 1;//0.6;//0.5;
	
	shadingCallbacks.version = 0;
	shadingCallbacks.evaluate = EvaluateColorsInfo;
	shadingCallbacks.releaseInfo = ReleaseColorInfo;
	
	function = CGFunctionCreate(colorMap, 1, domain, 4, range, &shadingCallbacks);
	if(function == NULL)
	{
		free(colorMap);
	}	
	
	return function;
}

void DrawLine1(CGContextRef context, CGPoint startPt, CGPoint endPt)
{
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, startPt.x, startPt.y);
	CGContextAddLineToPoint(context, endPt.x, endPt.y);
	CGContextDrawPath(context, kCGPathStroke);
}

void DrawLine2(CGContextRef context, float startx, float starty, float endx, float endy)
{
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, startx, starty);
	CGContextAddLineToPoint(context, endx, endy);
	CGContextDrawPath(context, kCGPathStroke);
}

CGImageRef CreateNumericImage(const char* sNumber)
{
	CGImageRef image = NULL;
	
	if(sNumber == NULL)
		return image;
	
	int nLen = strlen(sNumber);
	float fCharspce = 0;
	float fFontSize = 70;

	float width = fFontSize*0.8*((float)nLen); 
	float height = fFontSize;
	 
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmpContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	 
	CGContextSelectFont(bmpContext, "Helvetica",  fFontSize, kCGEncodingMacRoman);
	CGContextSetCharacterSpacing(bmpContext, fCharspce);
	
	CGContextSetRGBFillColor(bmpContext, 1, 0, 0, 1);
	CGContextSetRGBStrokeColor(bmpContext, 1, 0, 0, 1);
	
	CGContextSetTextDrawingMode(bmpContext, kCGTextInvisible);
	CGContextShowTextAtPoint(bmpContext, 0, 0, sNumber, nLen);
	CGPoint pt = CGContextGetTextPosition(bmpContext);
	
	CGContextSetTextDrawingMode(bmpContext, kCGTextFillStroke);
	CGContextScaleCTM(bmpContext, 1.0, -1.0);
	CGContextShowTextAtPoint(bmpContext, (width-pt.x)/2, -(height+40)/2, sNumber, nLen);
	image = CGBitmapContextCreateImage(bmpContext);
	CGContextRelease(bmpContext);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}	

// Returns an appropriate starting point for the demonstration of a linear gradient
CGPoint demoLGStart(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
}

// Returns an appropriate ending point for the demonstration of a linear gradient
CGPoint demoLGEnd(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.75);
}

// Returns the center point for for the demonstration of the radial gradient
CGPoint demoRGCenter(CGRect bounds)
{
	return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

// Returns an appropriate inner radius for the demonstration of the radial gradient
CGFloat demoRGInnerRadius(CGRect bounds)
{
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.125;
}

// Returns an appropriate outer radius for the demonstration of the radial gradient
CGFloat demoRGOuterRadius(CGRect bounds)
{
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.5;
}

void AddRoundRectToPath(CGContextRef context, CGRect rect, CGSize oval, float fr)
{
	float fw, fh;
	if (oval.width == 0 || oval.height == 0)
	{
		CGContextAddRect(context, rect);
	}	
	else 
	{
		CGContextBeginPath(context);
		CGContextSaveGState(context);
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextScaleCTM(context, oval.width, oval.height);
		fw = CGRectGetWidth(rect)/oval.width;
		fh = CGRectGetHeight(rect)/oval.height;
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, fr);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, fr);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, fr);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, fr);
		CGContextRestoreGState(context);
		CGContextClosePath(context);
	}
}

void DrawPatternImage(void *pImage, CGContextRef pContext)
{
    CGImageRef image = (CGImageRef) pImage;
	float width = CGImageGetWidth(image);
	float height =CGImageGetHeight(image);
	
	CGContextDrawImage(pContext, CGRectMake(0, 0, width, height), image); 
}

void ReleasePatternImage(void *pImage)
{
    CGImageRef image = (CGImageRef) pImage;
	CGImageRelease(image);	
}




