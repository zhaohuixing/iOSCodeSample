//
//  CCompassRender.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "CCompassRender.h"
#import "ApplicationConfigure.h"
#import "ImageLoader.h"
#import "GameConstants.h"
#include "drawhelper.h"
#import "RenderHelper.h"


#define COMPASS_RADIUM_IPHONE           200 //240  //480    //240
#define COMPASS_RADIUM_IPAD             420 //600

#define MAX_COMPASS_DELAY_IPHONE         3
#define MAX_COMPASS_DELAY_IPAD           1



@interface CCompassRender()
{
    CGImageRef          m_Compass8;
    CGImageRef          m_Compass6;
    CGImageRef          m_Compass4;
    CGImageRef          m_Compass2;
    
    CGImageRef          m_Compass8Animal;
    CGImageRef          m_Compass6Animal;
    CGImageRef          m_Compass4Animal;
    CGImageRef          m_Compass2Animal;
    
    CGImageRef          m_Compass8Food;
    CGImageRef          m_Compass6Food;
    CGImageRef          m_Compass4Food;
    CGImageRef          m_Compass2Food;
    
    CGImageRef          m_Compass8Flower;
    CGImageRef          m_Compass6Flower;
    CGImageRef          m_Compass4Flower;
    CGImageRef          m_Compass2Flower;
    
    CGImageRef          m_Compass8EasterEgg;
    CGImageRef          m_Compass6EasterEgg;
    CGImageRef          m_Compass4EasterEgg;
    CGImageRef          m_Compass2EasterEgg;
    
    CGImageRef          m_Compass8Kulo;
    CGImageRef          m_Compass6Kulo;
    CGImageRef          m_Compass4Kulo;
    CGImageRef          m_Compass2Kulo;
    
    CGImageRef          m_Compass8Animal1;
    CGImageRef          m_Compass6Animal1;
    CGImageRef          m_Compass4Animal1;
    CGImageRef          m_Compass2Animal1;
    
    CGImageRef          m_Compass8Animal2;
    CGImageRef          m_Compass6Animal2;
    CGImageRef          m_Compass4Animal2;
    CGImageRef          m_Compass2Animal2;
    
    CGColorSpaceRef		m_ShadowClrSpace;
    CGColorRef			m_ShadowClrs;
    CGSize				m_ShadowSize;
    
    int                 m_CompassType;
    int                 m_ThemeType;
    
    int                 m_HighlightIndex;
    int                 m_nFlashIndex;
    int                 m_nTimerDelay;
    
    CGImageRef          m_LightShadow;
    CGImageRef          m_DarkShadow;
    CGColorSpaceRef		m_HLShadowClrSpace;
    CGColorRef			m_HLShadowClrs;
    CGSize				m_HLShadowSize;
}
@end

@implementation CCompassRender

+(CGFloat)GetCompassImageSize
{
    CGFloat fSize = COMPASS_RADIUM_IPHONE;
    if([ApplicationConfigure iPADDevice])
        fSize = COMPASS_RADIUM_IPAD;
    CGFloat fScale = [ApplicationConfigure GetCurrentDisplayScale];
    fSize = fSize*fScale; 
    
    return fSize;
}

+(CGFloat)GetCompassRenderContextSize
{
    CGFloat fSize = COMPASS_RADIUM_IPHONE*[ApplicationConfigure GetCurrentDisplayScale]; //COMPASS_RADIUM_IPHONE*0.5;
    if([ApplicationConfigure iPADDevice])
        fSize = COMPASS_RADIUM_IPAD*[ApplicationConfigure GetCurrentDisplayScale];
    
    return fSize;
}

+(void)DrawCompassBase:(CGContextRef)context
{
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGRect rect;
    CGFloat rv = 0.01;
    CGFloat gv = 0.0;
    CGFloat bv = 0.0;
    CGFloat av = 1.0;

    //Fill circle
    rect = CGRectMake(0, 0, fSize, fSize);
    rv = 0.01;
    gv = 0.0;
    bv = 0.0;
    av = 1.0;
    CGContextSaveGState(context);
    CGContextSetRGBStrokeColor(context, rv, gv, bv, av);
    CGContextSetRGBFillColor(context, rv, gv, bv, av);
    CGContextFillEllipseInRect(context, rect);
    CGContextRestoreGState(context);
    
    //Draw outter edge
    rv = 1.0;
    gv = 0.55;
    bv = 0.0;
    CGFloat pw = 1;
    if([ApplicationConfigure iPADDevice])
        pw = 2;
    CGContextSaveGState(context);
    CGContextSetRGBStrokeColor(context, rv, gv, bv, av);
    CGContextSetRGBFillColor(context, rv, gv, bv, av);
    CGContextSetLineWidth(context, pw);    
    //if([ApplicationConfigure iPADDevice])
        rect = CGRectMake(pw/2, pw/2, fSize-pw, fSize-pw);
    //else
    //    rect = CGRectMake(pw, pw, fSize-pw*2, fSize-pw*2);
    CGContextStrokeEllipseInRect(context, rect);
    //CGContextFillEllipseInRect(context, rect);

    //Draw inner edge
    CGFloat edge = fSize/20.0;
    if([ApplicationConfigure iPADDevice])
        rect = CGRectMake(edge+pw/2, edge+pw/2, fSize-edge*2-pw, fSize-edge*2-pw);
    else
        rect = CGRectMake(edge, edge, fSize-edge*2, fSize-edge*2);
    CGContextStrokeEllipseInRect(context, rect);
    
    CGContextRestoreGState(context);
   
    CGContextSaveGState(context);
	rect = CGRectMake(0, 0, fSize, fSize);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGGradientRef gradientFill;
    CGColorSpaceRef fillColorspace;
    size_t num_locations = 4;
    CGFloat locations[4] = {0.0, 0.15, 0.4, 1.0};
    CGFloat colors[16] = 
    {
        0.4, 0.2, 0.1, 0.4,
        0.8, 0.4, 0.1, 0.8,
        0.2, 0.1, 0.02, 0.3,
        0.02, 0.01, 0.0,  0.05, 
    };
    
    fillColorspace = CGColorSpaceCreateDeviceRGB();
    gradientFill = CGGradientCreateWithColorComponents (fillColorspace, colors, locations, num_locations);
    
    CGPoint pt1, pt2;
    pt1.x = 0;
    pt1.y = 0;
    pt2.x = 0;
    pt2.y = fSize;
    CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
    
    CGColorSpaceRelease(fillColorspace);
    CGGradientRelease(gradientFill);
    
    CGContextRestoreGState(context);
}


+(void)DrawCompassInnerBase:(CGContextRef)context
{
    CGRect rect;
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat pw = 2;
    CGFloat edge = fSize/20.0+pw;
    rect = CGRectMake(edge+pw/2, edge+pw/2, fSize-edge*2-pw, fSize-edge*2-pw);
    CGFloat r = rect.size.width/2;
    CGFloat clrStart[3] = {1.0, 0.95, 0.0};
    CGFloat clrEnd[3] = {0.8, 0.4, 0.0};
    CGPoint center = CGPointMake(fSize/2, fSize/2);
    //CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clrStart, clrEnd);
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clrEnd, clrStart);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.6, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);
	
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawShading(context,shading);
    CGShadingRelease(shading);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(clrSpace);
}

//////////////////////////////////////////////////////////////////////////////
//
//   Compass 8
//
//
//////////////////////////////////////////////////////////////////////////////

+(void)DrawCompassInnerStrip8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat pw = 2;
    CGFloat edge = fSize/20.0+pw;
    CGFloat r = (fSize-edge*2-pw)/2;
 
    CGFloat clrStart[3] = {0.8, 1.0, 0.2};
    CGFloat clrEnd[3] = {0.0, 0.4, 0.0};
    CGPoint center = CGPointMake(fSize/2, fSize/2);
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clrEnd, clrStart);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.6, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);

    CGFloat fAngle = 0.0;
    for(int i = 0; i < 4; ++i)
    {    
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, center.x, center.y);
        CGContextMoveToPoint(context, 0, 0);
        fAngle = (-45.0f+90.0*((CGFloat)i));
        CGContextAddArc(context, 0, 0, r, fAngle*M_PI/180.0f, (fAngle+45.0)*M_PI/180.0f, FALSE); 
        CGContextTranslateCTM(context, -center.x, -center.y);
        CGContextClip(context);
        CGContextDrawShading(context,shading);
        CGContextRestoreGState(context);
    }
    
    CGShadingRelease(shading);
    CGColorSpaceRelease(clrSpace);
    
}

+(void)DrawInnerDStars8:(CGContextRef)context
{
    CGRect rect;
    CGFloat sx;
    CGFloat r;
    CGFloat sizeEdge;
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat edge = fSize/3.5;
    CGFloat srcSize = fSize-edge*2;
    rect = CGRectMake(edge, edge, srcSize, srcSize);
    CGFloat clr1A[4] = {0.0, 0.0, 1.0, 1.0};
    CGFloat clr1[4] = {1.0, 1.0, 0.0, 1.0};
    CGImageRef image = CreateGradientDSatrImage(srcSize, clr1A, clr1);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGImageRelease(image);

    sizeEdge = srcSize/sqrtf(2.0);
    srcSize = sizeEdge*sqrtf(10.0)/3.0;
    CGFloat clr2[4] = {1.0, 1.0, 1.0, 1.0};
    image = CreateGradientDSatrImage(srcSize, clr2, clr1A);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextTranslateCTM(context, r, r);
	CGContextRotateCTM(context, 22.5*M_PI/180.0f);
	CGContextTranslateCTM(context, -r, -r);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    

    sizeEdge = srcSize/sqrtf(2.0);
    srcSize = sizeEdge*sqrtf(10.0)/3.0;
    CGFloat clr3[4] = {1.0, 0.0, 0.0, 1.0};
    image = CreateGradientDSatrImage(srcSize, clr3, clr2);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    

    sizeEdge = srcSize/sqrtf(2.0);
    srcSize = sizeEdge*sqrtf(10.0)/3.0;
    CGFloat clr4[4] = {0.0, 1.0, 0.0, 1.0};
    image = CreateGradientDSatrImage(srcSize, clr4, clr3);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextTranslateCTM(context, r, r);
	CGContextRotateCTM(context, 22.5*M_PI/180.0f);
	CGContextTranslateCTM(context, -r, -r);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    

    sizeEdge = srcSize/sqrtf(2.0);
    srcSize = sizeEdge*sqrtf(10.0)/3.0;
    CGFloat clr5[4] = {1.0, 1.0, 0.0, 1.0};
    CGFloat clr5A[4] = {0.6, 0.6, 0.3, 1.0};
    image = CreateGradientDSatrImage(srcSize, clr5, clr5A);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    

    sizeEdge = srcSize/sqrtf(2.0);
    srcSize = sizeEdge*sqrtf(10.0)/3.0;
    CGFloat clr6[4] = {0.0, 0.0, 0.0, 1.0};
    image = CreateGradientDSatrImage(srcSize, clr6, clr5);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextTranslateCTM(context, r, r);
	CGContextRotateCTM(context, 22.5*M_PI/180.0f);
	CGContextTranslateCTM(context, -r, -r);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    
 
    if([ApplicationConfigure iPADDevice])
    {
        sizeEdge = srcSize/sqrtf(2.0);
        srcSize = sizeEdge*sqrtf(10.0)/3.0;
        CGFloat clr7[4] = {0.0, 1.0, 1.0, 1.0};
        image = CreateGradientDSatrImage(srcSize, clr7, clr6);
        CGContextSaveGState(context);
        sx = (fSize-srcSize)*0.5;
        rect = CGRectMake(sx, sx, srcSize, srcSize);
        r = fSize/2.0;
        CGContextSetAlpha(context, 0.75);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
        CGImageRelease(image);    
    
        sizeEdge = srcSize/sqrtf(2.0);
        srcSize = sizeEdge*sqrtf(10.0)/3.0;
        CGFloat clr8[4] = {1.0, 1.0, 0.0, 1.0};
        image = CreateDSatr(srcSize, clr8);
        CGContextSaveGState(context);
        sx = (fSize-srcSize)*0.5;
        rect = CGRectMake(sx, sx, srcSize, srcSize);
        r = fSize/2.0;
        CGContextTranslateCTM(context, r, r);
        CGContextRotateCTM(context, 22.5*M_PI/180.0f);
        CGContextTranslateCTM(context, -r, -r);
        CGContextSetAlpha(context, 0.75);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
        CGImageRelease(image);    
   }
    sizeEdge = srcSize/sqrtf(2.0);
    srcSize = 0.8*sizeEdge*sqrtf(10.0)/3.0;
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
    CGContextSetRGBFillColor(context, 1, 0.3, 0.3, 1);
    CGContextFillEllipseInRect(context, rect);
    CGContextRestoreGState(context);
}

+(void)DrawOutterEdgeDecoration:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat iconSize = fSize/24.0;
    CGFloat pw = 4;
    CGFloat sx = (fSize - iconSize)/2.0;
    CGFloat sy = iconSize+pw;
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    CGImageRef image = [ImageLoader LoadImageWithName:@"club.png"];
    
    CGFloat r = fSize/2.0;
    
    CGContextDrawImage(context, rect, image);
    
    for(int i = 1; i < 72; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, r, r);
        CGContextRotateCTM(context, ((CGFloat)i)*5.0*M_PI/180.0);
        CGContextTranslateCTM(context, -r, -r);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
    }
    
    CGImageRelease(image);
}

+(void)DrawNumberSigns8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5; 
    CGFloat fAlpha = 0.6;
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    CGFloat clr1[4] = {0.8, 0.5, 0.2, 1.0};
    CGFloat clr1A[4] = {0.9, 0.9, 0.0, 1.0};
    CGFloat clr2A[4] = {0.95, 0.95, 0.1, 1.0};
    CGFloat clr2[4] = {0.1, 0.6, 0.1, 1.0};
    CGImageRef image;
   
    for(int i = 0; i < 8; ++i)
    {
        NSString* str = [NSString stringWithFormat:@"%i", i+1];
        char* snum = (char*)[str UTF8String];
        if(i%2 == 0)
        {
            image = CreateGradientFlowerNumberImage(snum, iconSize, clr1A, clr1);
        }
        else
        {
            image = CreateGradientFlowerNumberImage(snum, iconSize, clr2A, clr2);
        }
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (22.5+((CGFloat)i)*45.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        
        CGContextDrawImage(context, rect, image);
        
        CGContextRestoreGState(context);
        CGImageRelease(image);
    }
}


+(void)DrawAnimalSigns8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
  
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;

    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 8; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (22.5+((CGFloat)i)*45.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimalIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }

	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);

}

+(void)DrawFoodSigns8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;

    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 8; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (22.5+((CGFloat)i)*45.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawFoodIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }

	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    
    
}

+(void)DrawFlowerSigns8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 8; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (22.5+((CGFloat)i)*45.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawFlowerIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawEasterEggSigns8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 8; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (22.5+((CGFloat)i)*45.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawEasterEggIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawKuloSigns8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 8; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (22.5+((CGFloat)i)*45.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawKuloIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawAnimal1Signs8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 8; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (22.5+((CGFloat)i)*45.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimal1Icon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}


+(void)DrawAnimal2Signs8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 8; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (22.5+((CGFloat)i)*45.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimal2Icon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}


+(void)DrawOutterStart8:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat iconSize = fSize/20.0;
    CGFloat sx = (fSize - iconSize)/2.0;
    CGFloat sy = 0;
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    CGImageRef image = [ImageLoader LoadImageWithName:@"star1.png"];
    
    CGFloat r = fSize/2.0;
    
    CGContextDrawImage(context, rect, image);
    
    for(int i = 1; i < 8; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, r, r);
        CGContextRotateCTM(context, ((CGFloat)i)*45.0*M_PI/180.0);
        CGContextTranslateCTM(context, -r, -r);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
    }
    
    CGImageRelease(image);
}

+(CGImageRef)CreateCompass8Image
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip8:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawNumberSigns8:bitmapContext];
    [CCompassRender DrawOutterStart8:bitmapContext];

    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


+(CGImageRef)CreateCompass8AnimalThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip8:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimalSigns8:bitmapContext];
    [CCompassRender DrawOutterStart8:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass8FoodThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip8:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawFoodSigns8:bitmapContext];
    [CCompassRender DrawOutterStart8:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


+(CGImageRef)CreateCompass8FlowerThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip8:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawFlowerSigns8:bitmapContext];
    [CCompassRender DrawOutterStart8:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass8EasterEggThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip8:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawEasterEggSigns8:bitmapContext];
    [CCompassRender DrawOutterStart8:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass8KuloThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip8:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawKuloSigns8:bitmapContext];
    [CCompassRender DrawOutterStart8:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


+(CGImageRef)CreateCompass8Animal1ThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip8:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimal1Signs8:bitmapContext];
    [CCompassRender DrawOutterStart8:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass8Animal2ThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip8:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimal2Signs8:bitmapContext];
    [CCompassRender DrawOutterStart8:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


//////////////////////////////////////////////////////////////////////////////
//
//   Compass 6
//
//
//////////////////////////////////////////////////////////////////////////////
+(void)DrawCompassInnerStrip6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat pw = 2;
    CGFloat edge = fSize/20.0+pw;
    CGFloat r = (fSize-edge*2-pw)/2;
    
    CGFloat clrStart[3] = {0.8, 1.0, 0.2};
    CGFloat clrEnd[3] = {0.0, 0.4, 0.0};
    CGPoint center = CGPointMake(fSize/2, fSize/2);
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clrEnd, clrStart);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.6, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);
    
    CGFloat fAngle = 0.0;
    for(int i = 0; i < 3; ++i)
    {    
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, center.x, center.y);
        CGContextMoveToPoint(context, 0, 0);
        fAngle = (-30.0f+120.0*((CGFloat)i));
        CGContextAddArc(context, 0, 0, r, fAngle*M_PI/180.0f, (fAngle+60.0)*M_PI/180.0f, FALSE); 
        CGContextTranslateCTM(context, -center.x, -center.y);
        CGContextClip(context);
        CGContextDrawShading(context,shading);
        CGContextRestoreGState(context);
    }
    
    CGShadingRelease(shading);
    CGColorSpaceRelease(clrSpace);
}

+(void)DrawInnerDStars6:(CGContextRef)context
{
    CGRect rect;
    CGFloat sx;
    CGFloat r;
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat edge = fSize/3.5;
    CGFloat srcSize = fSize-edge*2;
    rect = CGRectMake(edge, edge, srcSize, srcSize);
    CGFloat clr1A[4] = {0.0, 0.0, 1.0, 1.0};
    CGFloat clr1[4] = {1.0, 1.0, 0.0, 1.0};
    CGImageRef image = CreateGradientHSatrImage(srcSize, clr1A, clr1);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGImageRelease(image);
    
    srcSize = srcSize/sqrtf(3.0);
    CGFloat clr2[4] = {1.0, 1.0, 1.0, 1.0};
    image = CreateGradientHSatrImage(srcSize, clr2, clr1A);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextTranslateCTM(context, r, r);
	CGContextRotateCTM(context, 30.0*M_PI/180.0f);
	CGContextTranslateCTM(context, -r, -r);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    
    
    srcSize = srcSize/sqrtf(3.0);
    CGFloat clr3[4] = {1.0, 0.0, 0.0, 1.0};
    image = CreateGradientHSatrImage(srcSize, clr3, clr2);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    
    
    srcSize = srcSize/sqrtf(3.0);
    CGFloat clr4[4] = {0.0, 1.0, 0.0, 1.0};
    image = CreateGradientHSatrImage(srcSize, clr4, clr3);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextTranslateCTM(context, r, r);
	CGContextRotateCTM(context, 30.0*M_PI/180.0f);
	CGContextTranslateCTM(context, -r, -r);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    
    
    if([ApplicationConfigure iPADDevice])
    {
        srcSize = srcSize/sqrtf(3.0);
        CGFloat clr5[4] = {1.0, 1.0, 0.0, 1.0};
        CGFloat clr5A[4] = {0.6, 0.6, 0.3, 1.0};
        image = CreateGradientHSatrImage(srcSize, clr5, clr5A);
        CGContextSaveGState(context);
        sx = (fSize-srcSize)*0.5;
        rect = CGRectMake(sx, sx, srcSize, srcSize);
        r = fSize/2.0;
        CGContextSetAlpha(context, 0.75);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
        CGImageRelease(image);    
    }
    srcSize = srcSize/sqrtf(3.0);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
    CGContextSetRGBFillColor(context, 1, 0.3, 0.3, 1);
    CGContextFillEllipseInRect(context, rect);
    CGContextRestoreGState(context);
}

+(void)DrawNumberSigns6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5; 
    CGFloat fAlpha = 0.6;
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    CGFloat clr1[4] = {0.8, 0.5, 0.2, 1.0};
    CGFloat clr1A[4] = {0.9, 0.9, 0.0, 1.0};
    CGFloat clr2A[4] = {0.95, 0.95, 0.1, 1.0};
    CGFloat clr2[4] = {0.1, 0.6, 0.1, 1.0};
    CGImageRef image;
    
    for(int i = 0; i < 6; ++i)
    {
        NSString* str = [NSString stringWithFormat:@"%i", i+1];
        char* snum = (char*)[str UTF8String];
        if(i%2 == 0)
        {
            image = CreateGradientFlowerNumberImage(snum, iconSize, clr1A, clr1);
        }
        else
        {
            image = CreateGradientFlowerNumberImage(snum, iconSize, clr2A, clr2);
        }
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (30 + ((CGFloat)i)*60.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
        CGImageRelease(image);
    }
}


+(void)DrawAnimalSigns6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 6; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (30 + ((CGFloat)i)*60.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimalIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    
}

+(void)DrawFoodSigns6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 6; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (30 + ((CGFloat)i)*60.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawFoodIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    
    
}

+(void)DrawFlowerSigns6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 6; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (30 + ((CGFloat)i)*60.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawFlowerIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawEasterEggSigns6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 6; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (30 + ((CGFloat)i)*60.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawEasterEggIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawKuloSigns6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 6; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (30 + ((CGFloat)i)*60.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawKuloIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawAnimal1Signs6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 6; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (30 + ((CGFloat)i)*60.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimal1Icon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawAnimal2Signs6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 6; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (30 + ((CGFloat)i)*60.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimal2Icon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}



+(void)DrawOutterStart6:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat iconSize = fSize/20.0;
    CGFloat sx = (fSize - iconSize)/2.0;
    CGFloat sy = 0;
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    CGImageRef image = [ImageLoader LoadImageWithName:@"star1.png"];
    
    CGFloat r = fSize/2.0;
    
    CGContextDrawImage(context, rect, image);
    
    for(int i = 1; i < 6; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, r, r);
        CGContextRotateCTM(context, ((CGFloat)i)*60.0*M_PI/180.0);
        CGContextTranslateCTM(context, -r, -r);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
    }
    
    CGImageRelease(image);
}


+(CGImageRef)CreateCompass6Image
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip6:bitmapContext];
    [CCompassRender DrawInnerDStars6:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawNumberSigns6:bitmapContext];
    [CCompassRender DrawOutterStart6:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


+(CGImageRef)CreateCompass6AnimalThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip6:bitmapContext];
    [CCompassRender DrawInnerDStars6:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimalSigns6:bitmapContext];
    [CCompassRender DrawOutterStart6:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass6FoodThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip6:bitmapContext];
    [CCompassRender DrawInnerDStars6:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawFoodSigns6:bitmapContext];
    [CCompassRender DrawOutterStart6:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass6FlowerThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip6:bitmapContext];
    [CCompassRender DrawInnerDStars6:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawFlowerSigns6:bitmapContext];
    [CCompassRender DrawOutterStart6:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass6EasterEggThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip6:bitmapContext];
    [CCompassRender DrawInnerDStars6:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawEasterEggSigns6:bitmapContext];
    [CCompassRender DrawOutterStart6:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


+(CGImageRef)CreateCompass6KuloThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip6:bitmapContext];
    [CCompassRender DrawInnerDStars6:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawKuloSigns6:bitmapContext];
    [CCompassRender DrawOutterStart6:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass6Animal1ThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip6:bitmapContext];
    [CCompassRender DrawInnerDStars6:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimal1Signs6:bitmapContext];
    [CCompassRender DrawOutterStart6:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass6Animal2ThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip6:bitmapContext];
    [CCompassRender DrawInnerDStars6:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimal2Signs6:bitmapContext];
    [CCompassRender DrawOutterStart6:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


//////////////////////////////////////////////////////////////////////////////
//
//   Compass 4
//
//
//////////////////////////////////////////////////////////////////////////////

+(void)DrawCompassInnerStrip4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat pw = 2;
    CGFloat edge = fSize/20.0+pw;
    CGFloat r = (fSize-edge*2-pw)/2;
    
    CGFloat clrStart[3] = {0.8, 1.0, 0.2};
    CGFloat clrEnd[3] = {0.0, 0.4, 0.0};
    CGPoint center = CGPointMake(fSize/2, fSize/2);
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clrEnd, clrStart);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.6, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);
    
    CGFloat fAngle = 0.0;
    for(int i = 0; i < 2; ++i)
    {    
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, center.x, center.y);
        CGContextMoveToPoint(context, 0, 0);
        fAngle = (0.0f+180.0*((CGFloat)i));
        CGContextAddArc(context, 0, 0, r, fAngle*M_PI/180.0f, (fAngle+90.0)*M_PI/180.0f, FALSE); 
        CGContextTranslateCTM(context, -center.x, -center.y);
        CGContextClip(context);
        CGContextDrawShading(context,shading);
        CGContextRestoreGState(context);
    }
    
    CGShadingRelease(shading);
    CGColorSpaceRelease(clrSpace);
    
}

+(void)DrawInnerDStars4:(CGContextRef)context
{
    CGRect rect;
    CGFloat sx;
    CGFloat r;
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat edge = fSize*0.36;
    CGFloat srcSize = fSize-edge*2;
    rect = CGRectMake(edge, edge, srcSize, srcSize);
    CGFloat clr1A[4] = {0.0, 0.0, 1.0, 1.0};
    CGFloat clr1[4] = {1.0, 1.0, 0.0, 1.0};
    CGImageRef image = CreateGradientSSatrImage(srcSize, clr1A, clr1);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGImageRelease(image);
    
    srcSize = srcSize/sqrtf(2.0);
    CGFloat clr2[4] = {1.0, 1.0, 1.0, 1.0};
    image = CreateGradientSSatrImage(srcSize, clr2, clr1A);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextTranslateCTM(context, r, r);
	CGContextRotateCTM(context, 45*M_PI/180.0f);
	CGContextTranslateCTM(context, -r, -r);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    
    
    srcSize = srcSize/sqrtf(2.0);
    CGFloat clr3[4] = {1.0, 0.0, 0.0, 1.0};
    image = CreateGradientSSatrImage(srcSize, clr3, clr2);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    
    
    srcSize = srcSize/sqrtf(2.0);
    CGFloat clr4[4] = {0.0, 1.0, 0.0, 1.0};
    image = CreateGradientSSatrImage(srcSize, clr4, clr3);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextTranslateCTM(context, r, r);
	CGContextRotateCTM(context, 45*M_PI/180.0f);
	CGContextTranslateCTM(context, -r, -r);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    
    
    srcSize = srcSize/sqrtf(2.0);
    CGFloat clr5[4] = {1.0, 1.0, 0.0, 1.0};
    CGFloat clr5A[4] = {0.6, 0.6, 0.3, 1.0};
    image = CreateGradientSSatrImage(srcSize, clr5, clr5A);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    
    
    srcSize = srcSize/sqrtf(2.0);
    CGFloat clr6[4] = {0.0, 0.0, 0.0, 1.0};
    image = CreateGradientSSatrImage(srcSize, clr6, clr5);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
	r = fSize/2.0;
    CGContextTranslateCTM(context, r, r);
	CGContextRotateCTM(context, 45*M_PI/180.0f);
	CGContextTranslateCTM(context, -r, -r);
    CGContextSetAlpha(context, 0.75);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);    
    
    if([ApplicationConfigure iPADDevice])
    {
        srcSize = srcSize/sqrtf(2.0);
        CGFloat clr7[4] = {0.0, 1.0, 1.0, 1.0};
        image = CreateGradientSSatrImage(srcSize, clr7, clr6);
        CGContextSaveGState(context);
        sx = (fSize-srcSize)*0.5;
        rect = CGRectMake(sx, sx, srcSize, srcSize);
        r = fSize/2.0;
        CGContextSetAlpha(context, 0.75);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
        CGImageRelease(image);    
    }
    srcSize = srcSize/sqrtf(2.0);
    CGContextSaveGState(context);
    sx = (fSize-srcSize)*0.5;
    rect = CGRectMake(sx, sx, srcSize, srcSize);
    CGContextSetRGBFillColor(context, 1, 0.3, 0.3, 1);
    CGContextFillEllipseInRect(context, rect);
    CGContextRestoreGState(context);
}

+(void)DrawNumberSigns4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5; 
    CGFloat fAlpha = 0.6;
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    CGFloat clr1[4] = {0.8, 0.5, 0.2, 1.0};
    CGFloat clr1A[4] = {0.9, 0.9, 0.0, 1.0};
    CGFloat clr2A[4] = {0.95, 0.95, 0.1, 1.0};
    CGFloat clr2[4] = {0.1, 0.6, 0.1, 1.0};
    CGImageRef image;
    
    for(int i = 0; i < 4; ++i)
    {
        NSString* str = [NSString stringWithFormat:@"%i", i+1];
        char* snum = (char*)[str UTF8String];
        if(i%2 == 0)
        {
            image = CreateGradientFlowerNumberImage(snum, iconSize, clr1A, clr1);
        }
        else
        {
            image = CreateGradientFlowerNumberImage(snum, iconSize, clr2A, clr2);
        }
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (45 + ((CGFloat)i)*90.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
        CGImageRelease(image);
    }
}


+(void)DrawAnimalSigns4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 4; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (45 + ((CGFloat)i)*90.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimalIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    
}

+(void)DrawFoodSigns4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 4; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (45 + ((CGFloat)i)*90.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawFoodIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    
    
}

+(void)DrawFlowerSigns4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 4; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (45 + ((CGFloat)i)*90.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawFlowerIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawEasterEggSigns4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 4; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (45 + ((CGFloat)i)*90.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawEasterEggIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawKuloSigns4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 4; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (45 + ((CGFloat)i)*90.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawKuloIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawAnimal1Signs4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 4; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (45 + ((CGFloat)i)*90.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimal1Icon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}


+(void)DrawAnimal2Signs4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 4; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (45 + ((CGFloat)i)*90.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimal2Icon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}


+(void)DrawOutterStart4:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat iconSize = fSize/20.0;
    CGFloat sx = (fSize - iconSize)/2.0;
    CGFloat sy = 0;
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    CGImageRef image = [ImageLoader LoadImageWithName:@"star1.png"];
    
    CGFloat r = fSize/2.0;
    
    CGContextDrawImage(context, rect, image);
    
    for(int i = 1; i < 4; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, r, r);
        CGContextRotateCTM(context, ((CGFloat)i)*90.0*M_PI/180.0);
        CGContextTranslateCTM(context, -r, -r);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
    }
    
    CGImageRelease(image);
}

+(CGImageRef)CreateCompass4Image
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip4:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawNumberSigns4:bitmapContext];
    [CCompassRender DrawOutterStart4:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass4AnimalThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip4:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimalSigns4:bitmapContext];
    [CCompassRender DrawOutterStart4:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass4FoodThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip4:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawFoodSigns4:bitmapContext];
    [CCompassRender DrawOutterStart4:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass4FlowerThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip4:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawFlowerSigns4:bitmapContext];
    [CCompassRender DrawOutterStart4:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass4EasterEggThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip4:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawEasterEggSigns4:bitmapContext];
    [CCompassRender DrawOutterStart4:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass4KuloThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip4:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawKuloSigns4:bitmapContext];
    [CCompassRender DrawOutterStart4:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass4Animal1ThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip4:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimal1Signs4:bitmapContext];
    [CCompassRender DrawOutterStart4:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass4Animal2ThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip4:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimal2Signs4:bitmapContext];
    [CCompassRender DrawOutterStart4:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}



//////////////////////////////////////////////////////////////////////////////
//
//   Compass 8
//
//
//////////////////////////////////////////////////////////////////////////////

+(void)DrawCompassInnerStrip2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat pw = 2;
    CGFloat edge = fSize/20.0+pw;
    CGFloat r = (fSize-edge*2-pw)/2;
    
    CGFloat clrStart[3] = {0.8, 1.0, 0.2};
    CGFloat clrEnd[3] = {0.0, 0.4, 0.0};
    CGPoint center = CGPointMake(fSize/2, fSize/2);
    CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clrEnd, clrStart);
    CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r*0.6, center, r, colorFunction, TRUE, TRUE);
    CGFunctionRelease(colorFunction);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddArc(context, 0, 0, r, 0.5*M_PI, 1.5*M_PI, FALSE); 
    CGContextTranslateCTM(context, -center.x, -center.y);
    CGContextClip(context);
    CGContextDrawShading(context,shading);
    CGContextRestoreGState(context);
    
    CGShadingRelease(shading);
    CGColorSpaceRelease(clrSpace);
    
}

+(void)DrawNumberSigns2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5; 
    CGFloat fAlpha = 0.6;
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    CGFloat clr1[4] = {0.8, 0.5, 0.2, 1.0};
    CGFloat clr1A[4] = {0.9, 0.9, 0.0, 1.0};
    CGFloat clr2A[4] = {0.95, 0.95, 0.1, 1.0};
    CGFloat clr2[4] = {0.1, 0.6, 0.1, 1.0};
    CGImageRef image;
    
    for(int i = 0; i < 2; ++i)
    {
        NSString* str = [NSString stringWithFormat:@"%i", i+1];
        char* snum = (char*)[str UTF8String];
        if(i%2 == 0)
        {
            image = CreateGradientFlowerNumberImage(snum, iconSize, clr1A, clr1);
        }
        else
        {
            image = CreateGradientFlowerNumberImage(snum, iconSize, clr2A, clr2);
        }
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (90 + ((CGFloat)i)*180.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
        CGImageRelease(image);
    }
}

+(void)DrawAnimalSigns2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 2; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (90 + ((CGFloat)i)*180.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimalIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    
}

+(void)DrawFoodSigns2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 2; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (90 + ((CGFloat)i)*180.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawFoodIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    
    
}

+(void)DrawFlowerSigns2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 2; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (90 + ((CGFloat)i)*180.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawFlowerIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawEasterEggSigns2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 2; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (90 + ((CGFloat)i)*180.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawEasterEggIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawKuloSigns2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 2; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (90 + ((CGFloat)i)*180.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawKuloIcon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawAnimal1Signs2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 2; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (90 + ((CGFloat)i)*180.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimal1Icon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawAnimal2Signs2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = (fSize-iconSize)*0.5;
    CGFloat sy = (rBase-rSign)-iconSize*0.5;
    CGFloat fAlpha = 1.0;
    
    CGFloat clrvals[] = {0.1, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(3, 3);
    
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    
    for(int i = 0; i < 2; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rBase, rBase);
        CGContextRotateCTM(context, (90 + ((CGFloat)i)*180.0)*M_PI/180.0);
        CGContextTranslateCTM(context, -rBase, -rBase);
        CGContextSetAlpha(context, fAlpha);
        CGContextSetShadowWithColor(context, shadowSize, 6, shadowClrs);
        [RenderHelper DrawAnimal2Icon:context at:rect index:i];
        CGContextRestoreGState(context);
    }
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}

+(void)DrawOutterStart2:(CGContextRef)context
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat iconSize = fSize/20.0;
    CGFloat sx = (fSize - iconSize)/2.0;
    CGFloat sy = 0;
    CGRect rect = CGRectMake(sx, sy, iconSize, iconSize);
    CGImageRef image = [ImageLoader LoadImageWithName:@"star1.png"];
    
    CGFloat r = fSize/2.0;
    
    CGContextDrawImage(context, rect, image);
    
    for(int i = 1; i < 2; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, r, r);
        CGContextRotateCTM(context, ((CGFloat)i)*M_PI);
        CGContextTranslateCTM(context, -r, -r);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
    }
    
    CGImageRelease(image);
}

+(CGImageRef)CreateCompass2Image
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip2:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawNumberSigns2:bitmapContext];
    [CCompassRender DrawOutterStart2:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass2AnimalThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip2:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimalSigns2:bitmapContext];
    [CCompassRender DrawOutterStart2:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}


+(CGImageRef)CreateCompass2FoodThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip2:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawFoodSigns2:bitmapContext];
    [CCompassRender DrawOutterStart2:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass2FlowerThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip2:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawFlowerSigns2:bitmapContext];
    [CCompassRender DrawOutterStart2:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass2EasterEggThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip2:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawEasterEggSigns2:bitmapContext];
    [CCompassRender DrawOutterStart2:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass2KuloThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip2:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawKuloSigns2:bitmapContext];
    [CCompassRender DrawOutterStart2:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass2Animal1ThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip2:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimal1Signs2:bitmapContext];
    [CCompassRender DrawOutterStart2:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

+(CGImageRef)CreateCompass2Animal2ThemeImage
{
    CGImageRef image = NULL;
    
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CCompassRender DrawCompassBase:bitmapContext];
    [CCompassRender DrawCompassInnerBase:bitmapContext];
    [CCompassRender DrawCompassInnerStrip2:bitmapContext];
    [CCompassRender DrawInnerDStars8:bitmapContext];
    [CCompassRender DrawOutterEdgeDecoration:bitmapContext];
    [CCompassRender DrawAnimal2Signs2:bitmapContext];
    [CCompassRender DrawOutterStart2:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

//////////////////////////////////////////////////////////////////////////////
//
//   Class member functions
//
//
//////////////////////////////////////////////////////////////////////////////

-(void)initHighlightImages
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat iconSize = fSize*0.125;
    CGFloat litAlpha = 1.0;
    CGFloat darkAlpha = 1.0;
    CGFloat clrlight1[4] = {1.0, 0.8, 0.4, litAlpha};
    CGFloat clrlight2[4] = {0.6, 0.4, 0.1, litAlpha};

    CGFloat clrdark1[4] = {0.2, 0.6, 0.2, darkAlpha};
    CGFloat clrdark2[4] = {0.1, 0.3, 0.1, darkAlpha};
    m_LightShadow = CreateGradientBubbleImage(iconSize, clrlight1, clrlight2);
    m_DarkShadow = CreateGradientBubbleImage(iconSize, clrdark1, clrdark2);
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_Compass8 = [CCompassRender CreateCompass8Image];
        m_Compass6 = [CCompassRender CreateCompass6Image];
        m_Compass4 = [CCompassRender CreateCompass4Image];
        m_Compass2 = [CCompassRender CreateCompass2Image];
        
        m_Compass8Animal = [CCompassRender CreateCompass8AnimalThemeImage];
        m_Compass6Animal = [CCompassRender CreateCompass6AnimalThemeImage];
        m_Compass4Animal = [CCompassRender CreateCompass4AnimalThemeImage];
        m_Compass2Animal = [CCompassRender CreateCompass2AnimalThemeImage];
        
        m_Compass8Food = [CCompassRender CreateCompass8FoodThemeImage];
        m_Compass6Food = [CCompassRender CreateCompass6FoodThemeImage];
        m_Compass4Food = [CCompassRender CreateCompass4FoodThemeImage];
        m_Compass2Food = [CCompassRender CreateCompass2FoodThemeImage];
        
        m_Compass8Flower = [CCompassRender CreateCompass8FlowerThemeImage];
        m_Compass6Flower = [CCompassRender CreateCompass6FlowerThemeImage];
        m_Compass4Flower = [CCompassRender CreateCompass4FlowerThemeImage];
        m_Compass2Flower = [CCompassRender CreateCompass2FlowerThemeImage];
     
        m_Compass8EasterEgg = [CCompassRender CreateCompass8EasterEggThemeImage];
        m_Compass6EasterEgg = [CCompassRender CreateCompass6EasterEggThemeImage];
        m_Compass4EasterEgg = [CCompassRender CreateCompass4EasterEggThemeImage];
        m_Compass2EasterEgg = [CCompassRender CreateCompass2EasterEggThemeImage];
        
        m_Compass8Kulo = [CCompassRender CreateCompass8KuloThemeImage];
        m_Compass6Kulo = [CCompassRender CreateCompass6KuloThemeImage];
        m_Compass4Kulo = [CCompassRender CreateCompass4KuloThemeImage];
        m_Compass2Kulo = [CCompassRender CreateCompass2KuloThemeImage];
        
     
        m_Compass8Animal1 = [CCompassRender CreateCompass8Animal1ThemeImage];
        m_Compass6Animal1 = [CCompassRender CreateCompass6Animal1ThemeImage];
        m_Compass4Animal1 = [CCompassRender CreateCompass4Animal1ThemeImage];
        m_Compass2Animal1 = [CCompassRender CreateCompass2Animal1ThemeImage];
        

        m_Compass8Animal2 = [CCompassRender CreateCompass8Animal2ThemeImage];
        m_Compass6Animal2 = [CCompassRender CreateCompass6Animal2ThemeImage];
        m_Compass4Animal2 = [CCompassRender CreateCompass4Animal2ThemeImage];
        m_Compass2Animal2 = [CCompassRender CreateCompass2Animal2ThemeImage];
        
		CGFloat clrvals[] = {0.5, 0.2, 0.05, 1.0};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_ShadowSize = CGSizeMake(8, 4);
        m_CompassType = GAME_TYPE_8LUCK;
        m_ThemeType = GAME_THEME_ANIMAL;
        m_HighlightIndex = 0;
        m_nFlashIndex = 0;    
        m_nTimerDelay = 0;
        
        [self initHighlightImages];
 		m_HLShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_HLShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_HLShadowSize = CGSizeMake(2, 3);
    }
    return self;    
}

-(void)dealloc
{
    CGImageRelease(m_Compass8);
    CGImageRelease(m_Compass6);
    CGImageRelease(m_Compass4);
    CGImageRelease(m_Compass2);
    
    CGImageRelease(m_Compass8Animal);
    CGImageRelease(m_Compass6Animal);
    CGImageRelease(m_Compass4Animal);
    CGImageRelease(m_Compass2Animal);
    
    CGImageRelease(m_Compass8Food);
    CGImageRelease(m_Compass6Food);
    CGImageRelease(m_Compass4Food);
    CGImageRelease(m_Compass2Food);
    
    CGImageRelease(m_Compass8Flower);
    CGImageRelease(m_Compass6Flower);
    CGImageRelease(m_Compass4Flower);
    CGImageRelease(m_Compass2Flower);
    
    CGImageRelease(m_Compass8EasterEgg);
    CGImageRelease(m_Compass6EasterEgg);
    CGImageRelease(m_Compass4EasterEgg);
    CGImageRelease(m_Compass2EasterEgg);

    CGImageRelease(m_Compass8Animal1);
    CGImageRelease(m_Compass6Animal1);
    CGImageRelease(m_Compass4Animal1);
    CGImageRelease(m_Compass2Animal1);
    
    CGImageRelease(m_Compass8Animal2);
    CGImageRelease(m_Compass6Animal2);
    CGImageRelease(m_Compass4Animal2);
    CGImageRelease(m_Compass2Animal2);
    
    CGImageRelease(m_Compass8Kulo);
    CGImageRelease(m_Compass6Kulo);
    CGImageRelease(m_Compass4Kulo);
    CGImageRelease(m_Compass2Kulo);
    
	CGColorSpaceRelease(m_ShadowClrSpace);
	CGColorRelease(m_ShadowClrs);
    
    CGImageRelease(m_LightShadow);
    CGImageRelease(m_DarkShadow);
 
	CGColorSpaceRelease(m_HLShadowClrSpace);
	CGColorRelease(m_HLShadowClrs);
}

-(void)DrawCompassNumber8:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass8);
}

-(void)DrawCompassAnimal8:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass8Animal);
}

-(void)DrawCompassFood8:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass8Food);
}

-(void)DrawCompassFlower8:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass8Flower);
}

-(void)DrawCompassEasterEgg8:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass8EasterEgg);
}

-(void)DrawCompassKulo8:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass8Kulo);
}

-(void)DrawCompass1Animal8:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass8Animal1);
}

-(void)DrawCompass2Animal8:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass8Animal2);
}

-(void)DrawCompass8:(CGContextRef)context at:(CGRect)rect
{
    if(m_ThemeType == GAME_THEME_KULO)
        [self DrawCompassKulo8:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL1)
        [self DrawCompass1Animal8:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL2)
        [self DrawCompass2Animal8:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL)
        [self DrawCompassAnimal8:context at:rect];
    else if(m_ThemeType == GAME_THEME_FOOD)
        [self DrawCompassFood8:context at:rect];
    else if(m_ThemeType == GAME_THEME_FLOWER)
        [self DrawCompassFlower8:context at:rect];
    else if(m_ThemeType == GAME_THEME_EASTEREGG)
        [self DrawCompassEasterEgg8:context at:rect];
    else
        [self DrawCompassNumber8:context at:rect];
}

-(void)DrawCompassNumber6:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass6);
}

-(void)DrawCompassAnimal6:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass6Animal);
}

-(void)DrawCompassFood6:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass6Food);
}

-(void)DrawCompassFlower6:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass6Flower);
}

-(void)DrawCompassEasterEgg6:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass6EasterEgg);
}

-(void)DrawCompassKulo6:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass6Kulo);
}

-(void)DrawCompass1Animal6:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass6Animal1);
}

-(void)DrawCompass2Animal6:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass6Animal2);
}

-(void)DrawCompass6:(CGContextRef)context at:(CGRect)rect
{
    if(m_ThemeType == GAME_THEME_KULO)
        [self DrawCompassKulo6:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL1)
        [self DrawCompass1Animal6:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL2)
        [self DrawCompass2Animal6:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL)
        [self DrawCompassAnimal6:context at:rect];
    else if(m_ThemeType == GAME_THEME_FOOD)
        [self DrawCompassFood6:context at:rect];
    else if(m_ThemeType == GAME_THEME_FLOWER)
        [self DrawCompassFlower6:context at:rect];
    else if(m_ThemeType == GAME_THEME_EASTEREGG)
        [self DrawCompassEasterEgg6:context at:rect];
    else
        [self DrawCompassNumber6:context at:rect];
}

-(void)DrawCompassNumber4:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass4);
}

-(void)DrawCompassAnimal4:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass4Animal);
}

-(void)DrawCompassFood4:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass4Food);
}

-(void)DrawCompassFlower4:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass4Flower);
}

-(void)DrawCompassEasterEgg4:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass4EasterEgg);
}

-(void)DrawCompassKulo4:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass4Kulo);
}

-(void)DrawCompass1Animal4:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass4Animal1);
}

-(void)DrawCompass2Animal4:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass4Animal2);
}


-(void)DrawCompass4:(CGContextRef)context at:(CGRect)rect
{
    if(m_ThemeType == GAME_THEME_KULO)
        [self DrawCompassKulo4:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL1)
        [self DrawCompass1Animal4:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL2)
        [self DrawCompass2Animal4:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL)
        [self DrawCompassAnimal4:context at:rect];
    else if(m_ThemeType == GAME_THEME_FOOD)
        [self DrawCompassFood4:context at:rect];
    else if(m_ThemeType == GAME_THEME_FLOWER)
        [self DrawCompassFlower4:context at:rect];
    else if(m_ThemeType == GAME_THEME_EASTEREGG)
        [self DrawCompassEasterEgg4:context at:rect];
    else
        [self DrawCompassNumber4:context at:rect];
}

-(void)DrawCompassNumber2:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass2);
}

-(void)DrawCompassAnimal2:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass2Animal);
}

-(void)DrawCompassFood2:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass2Food);
}

-(void)DrawCompassFlower2:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass2Flower);
}

-(void)DrawCompassEasterEgg2:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass2EasterEgg);
}

-(void)DrawCompassKulo2:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass2Kulo);
}

-(void)DrawCompass1Animal2:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass2Animal1);
}

-(void)DrawCompass2Animal2:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Compass2Animal2);
}


-(void)DrawCompass2:(CGContextRef)context at:(CGRect)rect
{
    if(m_ThemeType == GAME_THEME_KULO)
        [self DrawCompassKulo2:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL1)
        [self DrawCompass1Animal2:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL2)
        [self DrawCompass2Animal2:context at:rect];
    else if(m_ThemeType == GAME_THEME_ANIMAL)
        [self DrawCompassAnimal2:context at:rect];
    else if(m_ThemeType == GAME_THEME_FOOD)
        [self DrawCompassFood2:context at:rect];
    else if(m_ThemeType == GAME_THEME_FLOWER)
        [self DrawCompassFlower2:context at:rect];
    else if(m_ThemeType == GAME_THEME_EASTEREGG)
        [self DrawCompassEasterEgg2:context at:rect];
    else
        [self DrawCompassNumber2:context at:rect];
}

-(void)DrawCompass:(CGContextRef)context at:(CGRect)rect
{
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, m_ShadowSize, 8, m_ShadowClrs);
    
    if(m_CompassType == GAME_TYPE_8LUCK)
        [self DrawCompass8:context at:rect];
    else if(m_CompassType == GAME_TYPE_6LUCK)
        [self DrawCompass6:context at:rect];
    else if(m_CompassType == GAME_TYPE_4LUCK)
        [self DrawCompass4:context at:rect];
    else if(m_CompassType == GAME_TYPE_2LUCK)
        [self DrawCompass2:context at:rect];
    
    CGContextRestoreGState(context);
}

-(void)DrawNumberHighlighter:(CGContextRef)context at:(CGRect)rect index:(int)index flag:(int)iflag
{
    if(iflag == 1)
        return;
    
    int nCount = 8;
    if(m_CompassType == GAME_TYPE_6LUCK)
        nCount = 6;
    else if(m_CompassType == GAME_TYPE_4LUCK)
        nCount = 4;
    else if(m_CompassType == GAME_TYPE_2LUCK)
        nCount = 2;
    
    if(index < 0 || nCount <= index)
        return;
    
    CGFloat fStartAngle = M_PI/((CGFloat)nCount);
    CGFloat fAngle = 2.0*M_PI/((CGFloat)nCount);
    
    CGFloat fSize = rect.size.width < rect.size.height ? rect.size.width : rect.size.height;
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*0.25;
    CGFloat sx = rect.origin.x + (fSize-iconSize)*0.5;
    CGFloat sy = rect.origin.y + (rBase-rSign)-iconSize*0.5;
    
    CGRect rt = CGRectMake(sx, sy, iconSize, iconSize);
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 0.7);
    CGContextTranslateCTM(context, (rect.origin.x+rBase), (rect.origin.y+rBase));
    CGContextRotateCTM(context, (fStartAngle + ((CGFloat)index)*fAngle));
    CGContextTranslateCTM(context, -(rect.origin.x+rBase), -(rect.origin.y+rBase));
    if(iflag == 0)
    {
        CGContextSetShadowWithColor(context, m_HLShadowSize, 6, m_ShadowClrs);
        CGContextDrawImage(context, rt, m_LightShadow);
    }
    else if(iflag == 2)
    {
        CGContextSetShadowWithColor(context, m_HLShadowSize, 6, m_ShadowClrs);
        CGContextDrawImage(context, rt, m_DarkShadow);
    }
    CGContextRestoreGState(context);
}

-(void)DrawAnimalHighlighter:(CGContextRef)context at:(CGRect)rect index:(int)index flag:(int)iflag
{
    int nCount = 8;
    if(m_CompassType == GAME_TYPE_6LUCK)
        nCount = 6;
    else if(m_CompassType == GAME_TYPE_4LUCK)
        nCount = 4;
    else if(m_CompassType == GAME_TYPE_2LUCK)
        nCount = 2;
    
    if(index < 0 || nCount <= index)
        return;
    
    CGFloat fStartAngle = M_PI/((CGFloat)nCount);
    CGFloat fAngle = 2.0*M_PI/((CGFloat)nCount);
    
    CGFloat fSize = rect.size.width < rect.size.height ? rect.size.width : rect.size.height;
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*(0.25 + ((CGFloat)iflag)*0.03);
    CGFloat sx = rect.origin.x + (fSize-iconSize)*0.5;
    CGFloat sy = rect.origin.y + (rBase-rSign)-iconSize*0.5;
    
    CGRect rt = CGRectMake(sx, sy, iconSize, iconSize);
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 1.0);
    CGContextTranslateCTM(context, (rect.origin.x+rBase), (rect.origin.y+rBase));
    CGContextRotateCTM(context, (fStartAngle + ((CGFloat)index)*fAngle));
    CGContextTranslateCTM(context, -(rect.origin.x+rBase), -(rect.origin.y+rBase));
    CGContextSetShadowWithColor(context, m_HLShadowSize, 6, m_ShadowClrs);
    [RenderHelper DrawAnimalIcon:context at:rt index:index];
    CGContextRestoreGState(context);
}

-(void) DrawFoodHighlighter:(CGContextRef)context at:(CGRect)rect index:(int)index flag:(int)iflag
{
    int nCount = 8;
    if(m_CompassType == GAME_TYPE_6LUCK)
        nCount = 6;
    else if(m_CompassType == GAME_TYPE_4LUCK)
        nCount = 4;
    else if(m_CompassType == GAME_TYPE_2LUCK)
        nCount = 2;
    
    if(index < 0 || nCount <= index)
        return;
    
    CGFloat fStartAngle = M_PI/((CGFloat)nCount);
    CGFloat fAngle = 2.0*M_PI/((CGFloat)nCount);
    
    CGFloat fSize = rect.size.width < rect.size.height ? rect.size.width : rect.size.height;
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*(0.25 + ((CGFloat)iflag)*0.03);
    CGFloat sx = rect.origin.x + (fSize-iconSize)*0.5;
    CGFloat sy = rect.origin.y + (rBase-rSign)-iconSize*0.5;
    
    CGRect rt = CGRectMake(sx, sy, iconSize, iconSize);
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 1.0);
    CGContextTranslateCTM(context, (rect.origin.x+rBase), (rect.origin.y+rBase));
    CGContextRotateCTM(context, (fStartAngle + ((CGFloat)index)*fAngle));
    CGContextTranslateCTM(context, -(rect.origin.x+rBase), -(rect.origin.y+rBase));
    CGContextSetShadowWithColor(context, m_HLShadowSize, 6, m_ShadowClrs);
    [RenderHelper DrawFoodIcon:context at:rt index:index];
    CGContextRestoreGState(context);
}

-(void) DrawFlowerHighlighter:(CGContextRef)context at:(CGRect)rect index:(int)index flag:(int)iflag
{
    int nCount = 8;
    if(m_CompassType == GAME_TYPE_6LUCK)
        nCount = 6;
    else if(m_CompassType == GAME_TYPE_4LUCK)
        nCount = 4;
    else if(m_CompassType == GAME_TYPE_2LUCK)
        nCount = 2;
    
    if(index < 0 || nCount <= index)
        return;
    
    CGFloat fStartAngle = M_PI/((CGFloat)nCount);
    CGFloat fAngle = 2.0*M_PI/((CGFloat)nCount);
    
    CGFloat fSize = rect.size.width < rect.size.height ? rect.size.width : rect.size.height;
    CGFloat rBase = fSize/2.0;
    CGFloat rSign = rBase*0.65;
    CGFloat iconSize = rBase*(0.25 + ((CGFloat)iflag)*0.03);
    CGFloat sx = rect.origin.x + (fSize-iconSize)*0.5;
    CGFloat sy = rect.origin.y + (rBase-rSign)-iconSize*0.5;
    
    CGRect rt = CGRectMake(sx, sy, iconSize, iconSize);
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 1.0);
    CGContextTranslateCTM(context, (rect.origin.x+rBase), (rect.origin.y+rBase));
    CGContextRotateCTM(context, (fStartAngle + ((CGFloat)index)*fAngle));
    CGContextTranslateCTM(context, -(rect.origin.x+rBase), -(rect.origin.y+rBase));
    CGContextSetShadowWithColor(context, m_HLShadowSize, 6, m_ShadowClrs);
    [RenderHelper DrawFlowerIcon:context at:rt index:index];
    CGContextRestoreGState(context);
}

-(void)DrawHighlighter:(CGContextRef)context at:(CGRect)rect index:(int)index flag:(int)iflag
{
    if(m_ThemeType == GAME_THEME_ANIMAL)
        [self DrawAnimalHighlighter:context at:(CGRect)rect index:index flag:iflag];
    else if(m_ThemeType == GAME_THEME_FOOD)
        [self DrawFoodHighlighter:context at:(CGRect)rect index:index flag:iflag];
    else if(m_ThemeType == GAME_THEME_FLOWER)
        [self DrawFlowerHighlighter:context at:(CGRect)rect index:index flag:iflag];
    else
        [self DrawNumberHighlighter:context at:(CGRect)rect index:index flag:iflag];
}


-(void)DrawGameReadyHighlight:(CGContextRef)context at:(CGRect)rect
{
    [self DrawHighlighter:context at:rect index:m_HighlightIndex flag:m_nFlashIndex];
}

-(void)DrawGameResultHighlight:(CGContextRef)context at:(CGRect)rect index:(int)WinIndex
{
    [self DrawHighlighter:context at:rect index:WinIndex flag:m_nFlashIndex];
}


-(void)SetCurrentGameType:(int)nType theme:(int)themeType
{
    m_CompassType = nType;
    m_ThemeType = themeType;
}

-(void)OnTimerEventReady
{
    if([ApplicationConfigure iPhoneDevice])
    {    
        m_nTimerDelay = (m_nTimerDelay+1)%MAX_COMPASS_DELAY_IPHONE;
        if(m_nTimerDelay != 0)
            return;
    }    
    //else
    //    m_nTimerDelay = (m_nTimerDelay+1)%MAX_COMPASS_DELAY_IPAD;
    
    BOOL bMove = (m_nFlashIndex == 2);
    
    m_nFlashIndex = (m_nFlashIndex+1)%3;
    
    if(!bMove)
        return;
    
    if(m_CompassType == GAME_TYPE_8LUCK)
        m_HighlightIndex = (m_HighlightIndex+1)%8;
    else if(m_CompassType == GAME_TYPE_6LUCK)
        m_HighlightIndex = (m_HighlightIndex+1)%6;
    else if(m_CompassType == GAME_TYPE_4LUCK)
        m_HighlightIndex = (m_HighlightIndex+1)%4;
    else if(m_CompassType == GAME_TYPE_2LUCK)
        m_HighlightIndex = (m_HighlightIndex+1)%2;
}

-(void)OnTimerEventResult
{
    if([ApplicationConfigure iPhoneDevice])
    {    
        m_nTimerDelay = (m_nTimerDelay+1)%MAX_COMPASS_DELAY_IPHONE;
        if(m_nTimerDelay != 0)
            return;
    }    
    //else
    //    m_nTimerDelay = (m_nTimerDelay+1)%MAX_COMPASS_DELAY_IPAD;
    
   
    m_nFlashIndex = (m_nFlashIndex+1)%3;
}

-(void)Reset
{
    m_HighlightIndex = 0;
    m_nFlashIndex = 0;    
    m_nTimerDelay = 0; 
}

@end
