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
	//out[0] = (startColor[0]*in[0] + endColor[0]*in[1]);
	//out[1] = (startColor[1]*in[0] + endColor[1]*in[1]);
	//out[2] = (startColor[2]*in[0] + endColor[2]*in[1]);
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
	range[6] = 0;//0;//0.6;//0.5;
	range[7] = 1; //1;//0.6;//0.5;
	
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
	 
	//CGContextSelectFont(bmpContext, "Helvetica",  fFontSize, kCGEncodingMacRoman);
	CGContextSelectFont(bmpContext, "Times New Roman",  fFontSize, kCGEncodingMacRoman);
	CGContextSetCharacterSpacing(bmpContext, fCharspce);
	
	//CGContextSetRGBFillColor(bmpContext, 1, 0, 0, 1);
	//CGContextSetRGBStrokeColor(bmpContext, 1, 0, 0, 1);
	CGContextSetRGBFillColor(bmpContext, 0.0, 0.0, 0.0, 1);
	CGContextSetRGBStrokeColor(bmpContext, 0.0, 0.0, 0.0, 1);
	
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

CGImageRef CreateNumericImageWithColor(const char* sNumber, const float colors[4])
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
    
	//CGContextSelectFont(bmpContext, "Helvetica",  fFontSize, kCGEncodingMacRoman);
	CGContextSelectFont(bmpContext, "Times New Roman",  fFontSize, kCGEncodingMacRoman);
	CGContextSetCharacterSpacing(bmpContext, fCharspce);
	
	CGContextSetRGBFillColor(bmpContext, colors[0], colors[1], colors[2], colors[3]);
	CGContextSetRGBStrokeColor(bmpContext, colors[0], colors[1], colors[2], colors[3]);
	
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

void AddRoundedRectToPathWithoutScale (CGContextRef context, CGRect rect, float fr)
{
	float xleft = rect.origin.x;
	float xleftcenter = xleft + fr;
	float xright = rect.origin.x + rect.size.width;
	float xrightcenter = xright - fr;
	float ytop = rect.origin.y;
	float ytopcenter = ytop + fr;
	float ybottom = rect.origin.y + rect.size.height;
	float ybottomcenter = ybottom - fr;
	
	CGContextBeginPath(context); 
	CGContextMoveToPoint(context, xleft, ytopcenter); 
	CGContextAddArcToPoint(context, xleft, ytop, xleftcenter, ytop, fr);
	CGContextAddLineToPoint(context, xrightcenter, ytop);
	CGContextAddArcToPoint(context, xright, ytop, xright, ytopcenter, fr);
	CGContextAddLineToPoint(context, xright, ybottomcenter);
	CGContextAddArcToPoint(context, xright, ybottom, xrightcenter, ybottom, fr);
	CGContextAddLineToPoint(context, xleftcenter, ybottom);
	CGContextAddArcToPoint(context, xleft, ybottom, xleft, ybottomcenter, fr);
	CGContextAddLineToPoint(context, xleft, ytopcenter);
	CGContextClosePath(context);
    
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

CGImageRef CreateDSatr(float imageSize, const float clr[4])
{
	CGImageRef image = NULL;

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmpContext = CGBitmapContextCreate(nil, imageSize, imageSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));    

    float fSzie = imageSize/sqrtf(2.0);
    float sx = (imageSize-fSzie)*0.5;
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, fSzie, fSzie);     
    CGContextSetRGBFillColor(bmpContext, clr[0], clr[1], clr[2], clr[3]);
    CGContextFillRect(bmpContext, rect);
    
    CGContextSaveGState(bmpContext);
	CGContextTranslateCTM(bmpContext, imageSize/2.0, imageSize/2.0);
	CGContextRotateCTM(bmpContext, 45.0*M_PI/180.0f);
	CGContextTranslateCTM(bmpContext, -imageSize/2.0, -imageSize/2.0);
    CGContextFillRect(bmpContext, rect);
    CGContextRestoreGState(bmpContext);
   
	image = CGBitmapContextCreateImage(bmpContext);
	CGContextRelease(bmpContext);
	CGColorSpaceRelease(colorSpace);

    return image;
}

CGImageRef CreateGradientDSatrImage(float imageSize, const float clr1[4], const float clr2[4])
{
	CGImageRef image = NULL;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmpContext = CGBitmapContextCreate(nil, imageSize, imageSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));    
    
    float fSzie = imageSize/sqrtf(2.0);
    float sx = (imageSize-fSzie)*0.5;
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, fSzie, fSzie);     
    CGContextSaveGState(bmpContext);
    CGContextAddRect(bmpContext, rect);
    CGContextSaveGState(bmpContext);
	CGContextTranslateCTM(bmpContext, imageSize/2.0, imageSize/2.0);
	CGContextRotateCTM(bmpContext, 45.0*M_PI/180.0f);
	CGContextTranslateCTM(bmpContext, -imageSize/2.0, -imageSize/2.0);
    CGContextAddRect(bmpContext, rect);
    CGContextRestoreGState(bmpContext);

    CGPoint center = CGPointMake(imageSize/2, imageSize/2);
    float r  = imageSize/2.0;
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clr1, clr2);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.72, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);
	
    CGContextClip(bmpContext);
    CGContextDrawShading(bmpContext,shading);
    CGShadingRelease(shading);
    CGColorSpaceRelease(clrSpace);
    
    CGContextRestoreGState(bmpContext);
    
	image = CGBitmapContextCreateImage(bmpContext);
	CGContextRelease(bmpContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

CGImageRef CreateGradientHSatrImage(float imageSize, const float clr1[4], const float clr2[4])
{
	CGImageRef image = NULL;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmpContext = CGBitmapContextCreate(nil, imageSize, imageSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));    
    
    CGContextSaveGState(bmpContext);//??
    
    float edge = imageSize*sqrtf(3.0)*0.5;
    float dx = edge/6.0;
    float dy = imageSize*0.25;
    float cx = imageSize*0.5;
    float cy = imageSize*0.5;
    
    CGContextSaveGState(bmpContext); //??
    CGContextBeginPath(bmpContext);
    CGContextMoveToPoint(bmpContext, cx, 0); //1
    CGContextAddLineToPoint(bmpContext, cx-dx, dy); //2
    CGContextAddLineToPoint(bmpContext, cx-3.0*dx, dy);  //3
    CGContextAddLineToPoint(bmpContext, cx-2*dx, cy);  //4
    CGContextAddLineToPoint(bmpContext, cx-3.0*dx, cy+dy);  //5
    CGContextAddLineToPoint(bmpContext, cx-dx, cy+dy);  //6
    CGContextAddLineToPoint(bmpContext, cx, imageSize);  //7
    CGContextAddLineToPoint(bmpContext, cx+dx, cy+dy);  //8
    CGContextAddLineToPoint(bmpContext, cx+3.0*dx, cy+dy);  //9
    CGContextAddLineToPoint(bmpContext, cx+2.0*dx, cy);  //10
    CGContextAddLineToPoint(bmpContext, cx+3.0*dx, dy);  //11
    CGContextAddLineToPoint(bmpContext, cx+dx, dy);  //12
    CGContextAddLineToPoint(bmpContext, cx, 0);  //0
    CGContextClosePath(bmpContext);
    CGContextRestoreGState(bmpContext); //XX
    
    CGPoint center = CGPointMake(imageSize/2, imageSize/2);
    float r  = imageSize/2.0;
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clr1, clr2);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.56, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);
	
    CGContextClip(bmpContext);
    CGContextDrawShading(bmpContext,shading);
    CGShadingRelease(shading);
    CGColorSpaceRelease(clrSpace); 
    
    CGContextRestoreGState(bmpContext); //??
    
	image = CGBitmapContextCreateImage(bmpContext);
	CGContextRelease(bmpContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

CGImageRef CreateGradientSSatrImage(float imageSize, const float clr1[4], const float clr2[4])
{
	CGImageRef image = NULL;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmpContext = CGBitmapContextCreate(nil, imageSize, imageSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));    
    
    CGContextSaveGState(bmpContext);//??
    
    float dx = imageSize/8.0;
    float dy = imageSize/8.0;
    float cx = imageSize*0.5;
    float cy = imageSize*0.5;
    
    CGContextSaveGState(bmpContext); //??
    CGContextBeginPath(bmpContext);
    CGContextMoveToPoint(bmpContext, cx, 0); //1
    //CGContextAddLineToPoint(bmpContext, 0, cy); //2
    //CGContextAddLineToPoint(bmpContext, cx, imageSize); //3
    //CGContextAddLineToPoint(bmpContext, imageSize, cy); //3
    
    CGContextAddLineToPoint(bmpContext, cx-dx, 3*dy); //2
    CGContextAddLineToPoint(bmpContext, 0, cy);  //3
    CGContextAddLineToPoint(bmpContext, cx-dx, cy+dy);  //4
    CGContextAddLineToPoint(bmpContext, cx, imageSize);  //5
    CGContextAddLineToPoint(bmpContext, cx+dx, cy+dy);  //6
    CGContextAddLineToPoint(bmpContext, imageSize, cy);  //7
    CGContextAddLineToPoint(bmpContext, cx+dx, cy-dy);  //8
    CGContextAddLineToPoint(bmpContext, cx, 0);  //0
    CGContextClosePath(bmpContext);
    CGContextRestoreGState(bmpContext); //XX
    
    CGPoint center = CGPointMake(imageSize/2, imageSize/2);
    float r  = imageSize/2.0;
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clr1, clr2);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.56, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);
	
    CGContextClip(bmpContext);
    CGContextDrawShading(bmpContext,shading);
    CGShadingRelease(shading);
    CGColorSpaceRelease(clrSpace); 
    
    CGContextRestoreGState(bmpContext); //??
    
	image = CGBitmapContextCreateImage(bmpContext);
	CGContextRelease(bmpContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


CGImageRef CreateGradientFlowerNumberImage(char* number, float imageSize, const float clr1[4], const float clr2[4])
{
	CGImageRef image = NULL;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmpContext = CGBitmapContextCreate(nil, imageSize, imageSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));    
    
    float fSzie = imageSize;
    float sx = (imageSize-fSzie)*0.5;
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, fSzie, fSzie);     
    CGContextSaveGState(bmpContext);
    CGContextAddEllipseInRect(bmpContext, rect);
    
    CGPoint center = CGPointMake(imageSize/2, imageSize/2);
    float r  = imageSize*0.5;
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clr1, clr2);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.3, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);
	
    CGContextClip(bmpContext);
    CGContextDrawShading(bmpContext,shading);
    CGShadingRelease(shading);
    CGColorSpaceRelease(clrSpace);
    
    CGContextRestoreGState(bmpContext);
	
    float clrBlue[4] = {0.0, 0.0, 1.0, 1.0}; 
    CGImageRef numImage =  CreateNumericImageWithColor(number, clrBlue);
    float nw = CGImageGetWidth(numImage);
    float nh = CGImageGetWidth(numImage);
    float ratio = nw/nh;
    float realnh = 0.8*imageSize;
    float realnw = ratio*realnh;
    sx = (imageSize-realnw)*0.5;
    sy = (imageSize-realnh)*0.5;
    rect = CGRectMake(sx, sy, realnw, realnh);     
    
	CGColorSpaceRef		ShadowClrSpace;
	CGColorRef			ShadowClrs;
	CGSize				ShadowSize;
    float clrvals[] = {0.1, 0.1, 0.1, 0.3};
    ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
    ShadowClrs = CGColorCreate(ShadowClrSpace, clrvals);
    ShadowSize = CGSizeMake(4, 4);
	CGContextSetShadowWithColor(bmpContext, ShadowSize, 2, ShadowClrs);
    
    CGContextDrawImage(bmpContext, rect, numImage);
    
	CGColorSpaceRelease(ShadowClrSpace);
	CGColorRelease(ShadowClrs);
    
    image = CGBitmapContextCreateImage(bmpContext);
	CGContextRelease(bmpContext);
	CGColorSpaceRelease(colorSpace);
    CGImageRelease(numImage);
    return image;
}

CGImageRef CreateGradientBubbleImage(float imageSize, const float clr1[4], const float clr2[4])
{
	CGImageRef image = NULL;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmpContext = CGBitmapContextCreate(nil, imageSize, imageSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));    
    
    float fSzie = imageSize;
    float sx = (imageSize-fSzie)*0.5;
    float sy = sx;
    CGRect rect = CGRectMake(sx, sy, fSzie, fSzie);     
    CGContextSaveGState(bmpContext);
    CGContextAddEllipseInRect(bmpContext, rect);
    
    CGPoint center = CGPointMake(imageSize/2, imageSize/2);
    float r  = imageSize*0.5;
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clr1, clr2);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.3, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);
	
    CGContextClip(bmpContext);
    CGContextDrawShading(bmpContext,shading);
    CGShadingRelease(shading);
    CGColorSpaceRelease(clrSpace);
    
    CGContextRestoreGState(bmpContext);
    
    image = CGBitmapContextCreateImage(bmpContext);
	CGContextRelease(bmpContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


CGImageRef CreateRedNoiseImage(int nSize)
{
	CGImageRef image = NULL;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmpContext = CGBitmapContextCreate(nil, nSize, nSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));    

    int nR;
    int nG;
    int nB;
    int nA;
    float fRed, fGreen, fBlue, fAlpha;
    for(int i = -1; i <= nSize; ++i)
    {
        for(int j = -1; j <= nSize/2+1; ++j)
        {
            if((i + j)%4 == 0)
            {
                fRed = 0.9;
                fGreen = 0.2;
                fBlue = 0.1;
                fAlpha = 1.0;
            }
            else
            {    
                nR = GetRandNumber()%100;
                nG = GetRandNumber()%60;
                nB = GetRandNumber()%60;
                nA = GetRandNumber()%100;
                fRed = ((float)nR)/100.0;
                fGreen = ((float)nG)/100.0;
                fBlue = ((float)nB)/100.0;
                fAlpha = ((float)nA)/100.0;
            }
            CGContextSaveGState(bmpContext);
            CGContextBeginPath(bmpContext);
            CGContextSetRGBStrokeColor(bmpContext, fRed, fGreen, fBlue, fAlpha);
            CGContextSetLineWidth(bmpContext, 2);
            CGContextMoveToPoint(bmpContext, (float)(j*2), (float)i);
            CGContextAddLineToPoint(bmpContext, (float)(j*2+1), (float)i);
            CGContextDrawPath(bmpContext, kCGPathStroke);
            CGContextRestoreGState(bmpContext);
        }
    }
    
    image = CGBitmapContextCreateImage(bmpContext);
	CGContextRelease(bmpContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

int GetRandNumber(void)
{
	int nRet = 0;
	srand((unsigned)time(NULL)%10000000);
	nRet = rand();
	return nRet;
}

int CounterClockWise(float x1, float y1, float x2, float y2, float xc, float yc)
{
	int bRet = 0;
    
	float dx1, dx2, dy1, dy2;
	dx1 = x2 - x1;
	dx2 = xc - x1;
	dy1 = y2 - y1;
	dy2 = yc - y1;
    
	if(dx1*dy2 > dy1*dx2)
	{
   		bRet = 1;
    	return bRet;
	}
    
	if(dx1*dy2 < dy1*dx2)
	{
    	bRet = 0;
    	return bRet;
    }
    
	if((dx1*dx2 < 0.0f) || (dy1*dy2 < 0.0f))
    {
    	bRet = 0;
    	return bRet;
    }
    
	if((dx1*dx1 + dy1*dy1) < (dx2*dx2 + dy2*dy2))
    {
    	bRet = 1;
    	return bRet;
    }
    
    if(y1 == y2)
    {
    	if(x2 < x1)
    	{
       		bRet = 1;
        	return bRet;
    	}
    	else
    	{
        	bRet = 0;
        	return bRet;
    	}
    }
    
   	if(y2 < y1)
   	{
      	bRet = 0;
       	return bRet;
   	}
   	else
   	{
       	bRet = 1;
       	return bRet;
   	}
}

CGImageRef CloneImage(CGImageRef srcImage, bool bFlip)
{
    float w =CGImageGetWidth(srcImage);
    float h =CGImageGetHeight(srcImage);
    
	CGImageRef image = NULL;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmpContext = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));    
    CGContextSaveGState(bmpContext);
    if(bFlip == true)
    {    
        CGContextTranslateCTM(bmpContext, 0, h);
        CGContextScaleCTM(bmpContext, 1, -1);
    }
    CGContextDrawImage(bmpContext, CGRectMake(0, 0, w, h), srcImage);
    CGContextRestoreGState(bmpContext);
    image = CGBitmapContextCreateImage(bmpContext);
	CGContextRelease(bmpContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
    
}
