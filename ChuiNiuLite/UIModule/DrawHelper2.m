//
//  DrawHelper2.m
//  XXXXXXXXXXXXX
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "DrawHelper2.h"
#include "drawhelper.h"
#import "ImageLoader.h"
#import "GUILayout.h"

static CGGradientRef       m_BlueGradient;
static CGGradientRef       m_GreenGradient;
static CGColorSpaceRef     m_BlueColorspace;

static CGGradientRef       m_HighLightGradient;
static CGGradientRef       m_GreenHighLightGradient;
static CGColorSpaceRef     m_HighLightColorspace;

static CGPatternRef        m_AlertUIPattern;
static CGColorSpaceRef     m_AlertUIPatternSpace;
static CGColorSpaceRef     m_AlertUIColorspace;
static CGColorRef          m_AlertDefaultDecorColor; 

static CGPatternRef        m_OptionalAlertUIPattern;
static CGColorRef          m_OptionalAlertUIDecorColor; 

static CGPatternRef        m_FrameViewUIPattern;
static CGColorRef          m_FrameViewUIDecorColor; 

static CGPatternRef        m_RedTexUIPattern;
static CGColorRef          m_GrayUIDecorColor; 

static CGImageRef          m_CowHead;

@implementation DrawHelper2

+(void)InitializeResource
{
    size_t num_locations = 3;
    CGFloat locations[3] = {0.0, 0.5, 1.0};
    CGFloat colors[12] = 
    {
        0.1, 0.1, 0.4, 1.0,
        0.6, 0.6, 1.0, 1.0,
        0.1, 0.1, 0.4, 1.0,
    };

    CGFloat colorsG[12] = 
    {
        0.05, 0.3, 0.05, 1.0,
        0.4, 0.8, 0.4, 1.0,
        0.05, 0.3, 0.05, 1.0,
    };
    
    m_BlueColorspace = CGColorSpaceCreateDeviceRGB();
    m_BlueGradient = CGGradientCreateWithColorComponents (m_BlueColorspace, colors, locations, num_locations);
     m_GreenGradient = CGGradientCreateWithColorComponents (m_BlueColorspace, colorsG, locations, num_locations);
    
    size_t num_locations2 = 2;
    CGFloat locations2[2] = {0.0, 1.0};
    CGFloat colors2[8] = 
    {
        0.8, 0.8, 1.0, 1.0,
        0.6, 0.6, 0.9, 0.5,
    };

    CGFloat colors2G[8] = 
    {
        0.7, 1.0, 0.7, 1.0,
        0.5, 0.9, 0.5, 0.5,
    };
    
    m_HighLightColorspace = CGColorSpaceCreateDeviceRGB();
    m_HighLightGradient = CGGradientCreateWithColorComponents (m_HighLightColorspace, colors2, locations2, num_locations2);
    m_GreenHighLightGradient = CGGradientCreateWithColorComponents (m_HighLightColorspace, colors2G, locations2, num_locations2);
    
	CGAffineTransform transform;
    CGPatternCallbacks callbacks;
	callbacks.version = 0;
	callbacks.drawPattern = &DrawPatternImage;
	callbacks.releaseInfo = &ReleasePatternImage;
	CGImageRef image = [ImageLoader LoadImageWithName:@"browntex.png"];
	
	float width = CGImageGetWidth(image);
	float height = CGImageGetHeight(image);
	
	transform = CGAffineTransformIdentity;
    
    
	m_AlertUIPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    m_AlertUIPatternSpace = CGColorSpaceCreatePattern(NULL);
    m_AlertUIColorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat colorsYellow[4] = 
    {
        //0.99, 0.99, 0.4, 0.4,
        //0.99, 0.99, 0.4, 1.0,
        0.1, 1.0, 0.6, 0.4,
    };
    m_AlertDefaultDecorColor = CGColorCreate(m_AlertUIColorspace, colorsYellow); 

	image = [ImageLoader LoadImageWithName:@"greentex.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);

	m_OptionalAlertUIPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    CGFloat colorsRed[4] = 
    {
        1.0, 0.0, 0.0, 1.0,
    };
    m_OptionalAlertUIDecorColor = CGColorCreate(m_AlertUIColorspace, colorsRed); 
    
	image = [ImageLoader LoadImageWithName:@"lightbrowntex.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
    
	m_FrameViewUIPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    CGFloat colorsBlue[4] = 
    {
        0.2, 0.2, 1.0, 1.0,
    };
    m_FrameViewUIDecorColor = CGColorCreate(m_AlertUIColorspace, colorsBlue); 
    
	image = [ImageLoader LoadImageWithName:@"redtext.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
	m_RedTexUIPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    CGFloat colorsGray[4] = 
    {
        0.85, 0.85, 0.85, 1.0,
    };
    m_GrayUIDecorColor = CGColorCreate(m_AlertUIColorspace, colorsGray);
    
    m_CowHead = [ImageLoader LoadImageWithName:@"roboiconhi.png"];
}

+(void)ReleaseResource
{
    CGColorSpaceRelease(m_BlueColorspace);
    CGGradientRelease(m_BlueGradient);
    
    CGColorSpaceRelease(m_HighLightColorspace);
    CGGradientRelease(m_HighLightGradient);

    CGGradientRelease(m_GreenGradient);
    CGGradientRelease(m_GreenHighLightGradient);
    
    CGPatternRelease(m_AlertUIPattern);
    CGColorSpaceRelease(m_AlertUIPatternSpace);
    CGColorSpaceRelease(m_AlertUIColorspace);
    CGColorRelease(m_AlertDefaultDecorColor);

    CGPatternRelease(m_OptionalAlertUIPattern);
    CGColorRelease(m_OptionalAlertUIDecorColor); 

    CGPatternRelease(m_FrameViewUIPattern);
    CGColorRelease(m_FrameViewUIDecorColor); 
    
    CGPatternRelease(m_RedTexUIPattern);
    CGColorRelease(m_GrayUIDecorColor);
    
    CGImageRelease(m_CowHead);
}

+(void)DrawBlueGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_BlueGradient, pt1, pt2, 0);
}

+(void)DrawBlueHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_HighLightGradient, pt1, pt2, 0);
}

+(void)DrawGreenGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_GreenGradient, pt1, pt2, 0);
}

+(void)DrawGreenHighLightGlossyRectVertical:(CGContextRef)context at:(CGRect)rect
{
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_GreenHighLightGradient, pt1, pt2, 0);
}


+(void)DrawDefaultAlertBackground:(CGContextRef)context at:(CGRect)rect
{
    GLfloat fAlpha = 1.0;
    CGContextSetFillColorSpace(context, m_AlertUIPatternSpace);
    CGContextSetFillPattern(context, m_AlertUIPattern, &fAlpha);
	CGContextFillRect (context, rect);	
}

+(void)DrawDefaultAlertBackgroundDecoration:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor(context, m_AlertDefaultDecorColor);
	CGContextSetLineWidth(context, [GUILayout GetDefaultAlertUIEdge]);
    CGContextDrawPath(context, kCGPathStroke);	
}

+(void)DrawOptionalAlertBackground:(CGContextRef)context at:(CGRect)rect
{
    GLfloat fAlpha = 1.0;
    CGContextSetFillColorSpace(context, m_AlertUIPatternSpace);
    CGContextSetFillPattern(context, m_OptionalAlertUIPattern, &fAlpha);
	CGContextFillRect (context, rect);	
}

+(void)DrawOptionalAlertBackgroundDecoration:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor(context, m_OptionalAlertUIDecorColor);
	CGContextSetLineWidth(context, [GUILayout GetDefaultAlertUIEdge]);
    CGContextDrawPath(context, kCGPathStroke);	
}

+(void)DrawDefaultFrameViewBackground:(CGContextRef)context at:(CGRect)rect
{
    GLfloat fAlpha = 1.0;
    CGContextSetFillColorSpace(context, m_AlertUIPatternSpace);
    CGContextSetFillPattern(context, m_FrameViewUIPattern, &fAlpha);
	CGContextFillRect (context, rect);	
}

+(void)DrawDefaultFrameViewBackgroundDecoration:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor(context, m_FrameViewUIDecorColor);
	CGContextSetLineWidth(context, [GUILayout GetDefaultAlertUIEdge]);
    CGContextDrawPath(context, kCGPathStroke);	
}

+(void)DrawHalfSizeGrayBackgroundDecoration:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor(context, m_GrayUIDecorColor);
	CGContextSetLineWidth(context, [GUILayout GetDefaultAlertUIEdge]*0.5);
    CGContextDrawPath(context, kCGPathStroke);	
}

+(void)DrawRedTextureRect:(CGContextRef)context at:(CGRect)rect
{
    GLfloat fAlpha = 1.0;
    CGContextSetFillColorSpace(context, m_AlertUIPatternSpace);
    CGContextSetFillPattern(context, m_RedTexUIPattern, &fAlpha);
	CGContextFillRect (context, rect);	
}

+(void)DrawCowHead:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CowHead);
}

@end
