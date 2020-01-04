//
//  RenderHelper.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-22.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "ApplicationConfigure.h"
#import "CGameLayout.h"
#import "GUILayout.h"
#import "RenderHelper.h"
#import "ImageLoader.h"
#include "GameUtility.h"
#include "GameState.h"
#include "drawhelper.h"

static CGImageRef   g_SpadeImage = NULL;
static CGImageRef   g_DiamondImage = NULL;
static CGImageRef   g_ClubImage = NULL;
static CGImageRef   g_HeartImage = NULL;

static CGImageRef   g_DogImage = NULL;
static CGImageRef   g_BirdImage = NULL;
static CGImageRef   g_DragonImage = NULL;
static CGImageRef   g_LizardImage = NULL;

static CGGradientRef	g_HighlightGradient;
static CGColorSpaceRef	g_HighlightColorspace;

static CGImageRef   g_SignsBtnImage = NULL;
static CGImageRef   g_SignImage[4];
static CGImageRef   g_SignHighLightImage[4];
static CGImageRef   g_SignSourceImage = NULL;
static CGImageRef   g_OriginalSignImage[5];

static CGImageRef   g_GhostImage[4];
static CGImageRef   g_GhostNumber = NULL;
//static CGImageRef   g_GhostImage2 = NULL;

static CGImageRef   g_ScoreHeart; 
static CGImageRef   g_ScoreHeart2; 
static CGImageRef   g_ScoreFlame; 

static CGPatternRef        m_BkgndPattern;
static CGPatternRef        m_GreenBkgndPattern;
static CGPatternRef        m_NumericBkgndPattern;
static CGColorSpaceRef     m_PatternSpace;
static CGColorSpaceRef     m_Colorspace;

static CGImageRef          m_AvatarIdle[3];
static CGImageRef          m_AvatarPlay[3];
static CGImageRef          m_AvatarWin[3];
static CGImageRef          m_AvatarCry[3];

static CGImageRef          m_MeIdle[3];
static CGImageRef          m_MePlay[3];
static CGImageRef          m_MeWin[3];
static CGImageRef          m_MeCry[3];

static CGImageRef          m_OnlineGestures[3];
static CGImageRef          m_OnlineHat;

@implementation RenderHelper

////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//The basic card functions
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)drawGhostBackground:(CGContextRef)context inRect:(CGRect)rect
{
/*	CGSize csize = CGSizeMake([CGameLayout GetCardCornerWidth], [CGameLayout GetCardCornerHeight]);
	CGContextSaveGState(context);
	
	[RenderHelper AddRoundRectToPath:context withRect:rect withOval:csize];
	CGContextClip(context);
    CGImageRef image = [ImageLoader LoadResourceImage:@"ghost.png"];
	CGContextDrawImage(context, rect, image);
    CGImageRelease(image);
    
	CGContextRestoreGState(context);*/
}	

+ (void)drawPointInGhostCard:(CGContextRef)context withPoint:(int)nPoint inRect:(CGRect)rect withOrientation:(BOOL)bProtrait;
{
	NSNumber* nsValue = [NSNumber numberWithInt: nPoint];
	NSString* sNumber = [nsValue stringValue];
	const char *sText = [sNumber UTF8String];
	if(sText == NULL)
		return;
	float clrs[4] = {1.0, 0.0, 0.0, 1.0};
	CGImageRef imgNumber = CreateNumericImageWithColor(sText, clrs);
	if(imgNumber == NULL)
		return;
	
	float imgWidth = CGImageGetWidth(imgNumber);
	float imgHeight = CGImageGetHeight(imgNumber);
	
	float maxWidth;
	float maxHeight = [CGameLayout GetCardSignHeight];
	
	if(bProtrait)
	{
		maxWidth = [CGameLayout GetCardWidth]*0.65;
	}	
	else 
	{
		maxWidth = [CGameLayout GetCardWidth]*0.65;
	}

	if([ApplicationConfigure iPADDevice])
	{	
		if(bProtrait)
		{
			maxWidth = [CGameLayout GetCardWidth]*0.40;
		}
		else 
		{
			maxWidth = [CGameLayout GetCardWidth]*0.40;
		}

		maxHeight = [CGameLayout GetCardSignHeight]*0.7;
	}	
	float width, height;
	height = maxHeight;
	width = height*imgWidth/imgHeight;
	
	if(maxWidth < width)
		width = maxWidth;
	
	CGContextSaveGState(context);
	
	float sx = (rect.size.width - width)/2.0;
	float sy = (rect.size.height - height)/2.0;
	
	CGRect imgRect = CGRectMake(sx, sy, width, height);
	
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
	shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	shadowSize = CGSizeMake(2, 2);
	float clrvals[] = {0.1, 0.1, 0.1, 1};
	shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
	CGContextSetShadowWithColor(context, shadowSize, 2.0, shadowClrs);
	
	CGContextDrawImage(context, imgRect, imgNumber);
	
	CGImageRelease(imgNumber);
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
	
	CGContextRestoreGState(context);
}	

+ (void)IntializeGhostImage
{
    g_GhostImage[0] = [ImageLoader LoadResourceImage:@"ghost1.png"];
    g_GhostImage[1] = [ImageLoader LoadResourceImage:@"ghost2.png"];
    g_GhostImage[2] = [ImageLoader LoadResourceImage:@"ghost3.png"];
    g_GhostImage[3] = [ImageLoader LoadResourceImage:@"ghost4.png"];
    g_GhostNumber = NULL;
    [RenderHelper ReloadGhostImage];
}	

+ (void)ReloadGhostImage
{
	if(g_GhostNumber != NULL)
		CGImageRelease(g_GhostNumber);

 	int nPoint = GetGamePoint();
    
	NSNumber* nsValue = [NSNumber numberWithInt: nPoint];
	NSString* sNumber = [nsValue stringValue];
	const char *sText = [sNumber UTF8String];
	if(sText == NULL)
		return;
	float clrs[4] = {1.0, 1.0, 1.0, 1.0};
	g_GhostNumber = CreateNumericImageWithColor(sText, clrs);
}	

+ (void)drawCardHighlight:(CGContextRef)context inRect:(CGRect)rect
{
	CGSize csize = CGSizeMake([CGameLayout GetCardCornerWidth], [CGameLayout GetCardCornerHeight]);
	CGContextSaveGState(context);
	
	[RenderHelper AddRoundRectToPath:context withRect:rect withOval:csize];
	CGContextClip(context);
	CGPoint pt1, pt2;
	pt1.x = rect.origin.x;
	pt1.y = rect.origin.y;
	pt2.x = rect.origin.x;
	pt2.y = rect.origin.y+rect.size.height;
	CGContextDrawLinearGradient (context, g_HighlightGradient, pt1, pt2, 0);
	
	CGContextRestoreGState(context);
}

+ (void)drawBasicCardBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGSize csize = CGSizeMake([CGameLayout GetCardCornerWidth], [CGameLayout GetCardCornerHeight]);
	CGContextSaveGState(context);
	
	[RenderHelper AddRoundRectToPath:context withRect:rect withOval:csize];
	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	CGFloat colors[8] = {1.0, 1.0, 1.0, 1.0, 0.8, 0.8, 0.8, 1.0};
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = rect.origin.x;
	pt1.y = rect.origin.y;
	pt2.x = rect.origin.x;//+rect.size.width;
	pt2.y = rect.origin.y+rect.size.height;
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	CGContextRestoreGState(context);
}	

+ (void)drawAnimatedBasicCardBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGSize csize = CGSizeMake([CGameLayout GetCardCornerWidth], [CGameLayout GetCardCornerHeight]);
	CGContextSaveGState(context);
	
	[RenderHelper AddRoundRectToPath:context withRect:rect withOval:csize];
	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	CGFloat colors[8] = {1.0, 1.0, 1.0, 1.0, 0.55, 0.55, 0.55, 1.0};
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = rect.origin.x;
	pt1.y = rect.origin.y;
	pt2.x = rect.origin.x;//+rect.size.width;
	pt2.y = rect.origin.y+rect.size.height;
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	CGContextRestoreGState(context);
}	

+ (void)drawBasicCardSymbol:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect
{
	BOOL bProtrait = YES;
	if(rect.size.height < rect.size.width)
		bProtrait = NO;
	
	float signheight = [CGameLayout GetCardSignHeight]; 
	float signwidth = signheight*CARD_SIGN_XY_RATIO;
	float signstartx;
	float signstarty;
	
	signstartx = rect.origin.x + (rect.size.width - signwidth)*0.5;
	signstarty = rect.origin.y + (rect.size.height - signheight)*0.5;

	CGRect imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
	int type  = GetCardType(nCard);
	if(type == CARD_INVALID)
		return;
	
	CGContextSaveGState(context);
	
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
	float				shadowstep = 3;
	
	shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	shadowSize = CGSizeMake(5, 0);
	
	switch(type)
	{
		case CARD_SPADE:
		{	
			float clrvals[] = {0.1, 0.1, 0.1, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			CGContextSetShadowWithColor(context, shadowSize, shadowstep*3, shadowClrs);
			CGContextDrawImage(context, imgRect, g_SpadeImage);
			break;
		}	
		case CARD_DIAMOND:
		{	
			float clrvals[] = {1.0, 0.1, 0.1, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			CGContextSetShadowWithColor(context, shadowSize, shadowstep, shadowClrs);
			CGContextDrawImage(context, imgRect, g_DiamondImage);
			break;
		}	
		case CARD_CLUB:
		{	
			float clrvals[] = {0.1, 0.1, 1.0, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			CGContextSetShadowWithColor(context, shadowSize, shadowstep*3, shadowClrs);
			CGContextDrawImage(context, imgRect, g_ClubImage);
			break;
		}	
		case CARD_HEART:
		{	
			float clrvals[] = {1.0, 0.1, 1.0, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			CGContextSetShadowWithColor(context, shadowSize, shadowstep, shadowClrs);
			CGContextDrawImage(context, imgRect, g_HeartImage);
			break;
		}	
	}
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
	CGContextRestoreGState(context);
	
}	

+ (void)drawBasicCardAnimalSymbol:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect
{
	float signheight = [CGameLayout GetCardAnimalSignHeight]; 
	float signwidth = signheight;//*CARD_SIGN_XY_RATIO;
	float signstartx;
	float signstarty;
	
	
	CGRect imgRect;// = CGRectMake(signstartx, signstarty, signwidth, signheight);
	int type  = GetCardType(nCard);
	if(type == CARD_INVALID)
		return;
	
	CGContextSaveGState(context);
	
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
	float				shadowstep = 2;
	
	shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	shadowSize = CGSizeMake(3, 0);
	
	switch(type)
	{
		case CARD_SPADE: //Dog 0.83
		{	
			float clrvals[] = {0.1, 0.1, 0.1, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			
			signheight = signwidth*0.75; 
			signstartx = rect.origin.x + (rect.size.width - signwidth)*0.5;
			signstarty = rect.origin.y + (rect.size.height - signheight)*0.5;
			imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
			if([ApplicationConfigure iPADDevice])
                CGContextSetShadowWithColor(context, shadowSize, shadowstep*3, shadowClrs);
            else 
                CGContextSetShadowWithColor(context, shadowSize, shadowstep, shadowClrs);
            
			CGContextDrawImage(context, imgRect, g_DogImage);
            
            CGColorRelease(shadowClrs);
			break;
		}	
		case CARD_DIAMOND: //Bird:0.62
		{	
			float clrvals[] = {1.0, 0.1, 0.1, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			
			signheight = signwidth*0.78; 
			signstartx = rect.origin.x + (rect.size.width - signwidth)*0.5;
			signstarty = rect.origin.y + (rect.size.height - signheight)*0.5;
			imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
			if([ApplicationConfigure iPADDevice])
                CGContextSetShadowWithColor(context, shadowSize, shadowstep*3, shadowClrs);
            else 
                CGContextSetShadowWithColor(context, shadowSize, shadowstep, shadowClrs);
			CGContextDrawImage(context, imgRect, g_BirdImage);
            
            CGColorRelease(shadowClrs);
			break;
		}	
		case CARD_CLUB: //Lizard:0.72
		{	
			float clrvals[] = {0.1, 0.1, 1.0, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			signheight = signwidth*0.675; 
			signstartx = rect.origin.x + (rect.size.width - signwidth)*0.5;
			signstarty = rect.origin.y + (rect.size.height - signheight)*0.5;
			signstartx = rect.origin.x + (rect.size.width - signwidth)*0.5;
			signstarty = rect.origin.y + (rect.size.height - signheight)*0.5;
			imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
			if([ApplicationConfigure iPADDevice])
                CGContextSetShadowWithColor(context, shadowSize, shadowstep*3, shadowClrs);
            else 
                CGContextSetShadowWithColor(context, shadowSize, shadowstep, shadowClrs);
			CGContextDrawImage(context, imgRect, g_LizardImage);
			
            CGColorRelease(shadowClrs);
			break;
		}	
		case CARD_HEART: //Dragon:0.4
		{	
			float clrvals[] = {0.4, 0.4, 0.0, 1.0};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			signheight = signwidth*0.685; 
			signstartx = rect.origin.x + (rect.size.width - signwidth)*0.5;
			signstarty = rect.origin.y + (rect.size.height - signheight)*0.5;
			imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
			if([ApplicationConfigure iPADDevice])
                CGContextSetShadowWithColor(context, shadowSize, shadowstep*3, shadowClrs);
            else 
                CGContextSetShadowWithColor(context, shadowSize, shadowstep, shadowClrs);
			CGContextDrawImage(context, imgRect, g_DragonImage);
			
            CGColorRelease(shadowClrs);
			break;
		}	
	}
	CGColorSpaceRelease(shadowClrSpace);
	CGContextRestoreGState(context);
	
}	

+ (void)drawBasicCardNumber:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect
{
	BOOL bProtrait = YES;
	if(rect.size.height < rect.size.width)
		bProtrait = NO;
	
	
	float signstartx = rect.origin.x + [CGameLayout GetCardInnerMargin];
	float signstarty = rect.origin.y + [CGameLayout GetCardInnerMargin];
	
	int value  = GetCardValue(nCard)-1;
	int type = GetCardType(nCard);
	if(type == CARD_INVALID)
		return;
	
	CGContextSaveGState(context);
	
	const char *pText[13]= {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"};
	float fCharspce = 0;
	float fFontSize = 32;
    if([ApplicationConfigure iPhoneDevice])
        fFontSize = 24;
    
	CGContextSelectFont(context, "Georgia",  fFontSize, kCGEncodingMacRoman);
	if(value < 9 && value != 0)
		CGContextSetCharacterSpacing(context, fCharspce+8);
    else 
		CGContextSetCharacterSpacing(context, fCharspce);
 
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
	
	shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	shadowSize = CGSizeMake(5, 0);
	
	switch(type)
	{
		case CARD_SPADE:
		{	
			CGContextSetRGBFillColor(context, 0, 0, 0, 1);
			CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
			float clrvals[] = {0.1, 0.1, 0.1, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			break;
		}	
		case CARD_DIAMOND:
		{	
			CGContextSetRGBFillColor(context, 1, 0, 0, 1);
			CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
			float clrvals[] = {1.0, 0.1, 0.1, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			break;
		}	
		case CARD_CLUB:
		{	
			CGContextSetRGBFillColor(context, 0, 0, 1, 1);
			CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
			float clrvals[] = {0.1, 0.1, 1.0, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			break;
		}	
		case CARD_HEART:
		{	
			CGContextSetRGBFillColor(context, 1, 0, 0, 1);
			CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
			float clrvals[] = {1.0, 0.1, 1.0, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			break;
		}	
	}
	CGContextSetShadowWithColor(context, shadowSize, 4.5, shadowClrs);
	
	float fOffsetY;
	if(value < 9 && value != 0 && value != 5 && value != 7 && value != 1)
		fOffsetY = fFontSize/1.8;
	else if(value == 5 || value == 7 || value == 1)
		fOffsetY = fFontSize/1.35;
    else if(value != 9) 
		fOffsetY = fFontSize/1.5;
    else
		fOffsetY = fFontSize/1.35;
    

	signstarty = [CGameLayout GetCardInnerMargin] + fOffsetY;
	
	CGContextSetTextDrawingMode(context, kCGTextFillStroke);
	
	CGAffineTransform xform;
	CGContextSaveGState(context);
	if(value == 1)
		xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.4, 0.0, 0.0);
	else if(value < 9 && value != 0)
		xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.1, 0.0, 0.0);
	else if(value == 9)
		xform = CGAffineTransformMake(0.8, 0.0, 0.0, -1.4, 0.0, 0.0);
    else 
		xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
	CGContextSetTextMatrix(context, xform);
	CGContextShowTextAtPoint(context, signstartx, signstarty, pText[value], strlen(pText[value]));
	CGContextRestoreGState(context);
	if(value != 0 && value != 1 && value != 5 && value != 7 && value != 9 && value != 10 && value != 12)
		signstarty = rect.origin.y + rect.size.height - [CGameLayout GetCardInnerMargin]*1.4;
	else 
		signstarty = rect.origin.y + rect.size.height - [CGameLayout GetCardInnerMargin];
		
	if(value == 0)
		fOffsetY = fFontSize/1.35;
		//else if(value == 10)
		//	fOffsetY = fFontSize/1.8;
	else if(value == 12 || value == 11 || value == 9)
		fOffsetY = fFontSize/1.2;
	else 
		fOffsetY = fFontSize/1.8;
	signstartx = rect.origin.x + rect.size.width - [CGameLayout GetCardInnerMargin] - fOffsetY;
	CGContextShowTextAtPoint(context, signstartx, signstarty, pText[value], strlen(pText[value]));
	
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
	
	CGContextRestoreGState(context);
}	

+ (void)drawBasicCardNumber2:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect
{
	BOOL bProtrait = YES;
	if(rect.size.height < rect.size.width)
		bProtrait = NO;
	
	
	float signstartx = [CGameLayout GetCardInnerMargin];
	float signstarty = [CGameLayout GetCardInnerMargin];
	
	int value  = GetCardValue(nCard)-1;
	int type = GetCardType(nCard);
	if(type == CARD_INVALID)
		return;
	
	CGContextSaveGState(context);
	
	const char *pText[13]= {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"};
	float fCharspce = 0;
	float fFontSize = 32;
    if([ApplicationConfigure iPhoneDevice])
        fFontSize = 24;
    
	CGContextSelectFont(context, "Times New Roman",  fFontSize, kCGEncodingMacRoman);
	if(value < 9 && value != 0)
		CGContextSetCharacterSpacing(context, fCharspce+8);
    else 
		CGContextSetCharacterSpacing(context, fCharspce);
    
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
	
	shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	shadowSize = CGSizeMake(5, 0);
	
	switch(type)
	{
		case CARD_SPADE:
		{	
			CGContextSetRGBFillColor(context, 0, 0, 0, 1);
			CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
			float clrvals[] = {0.1, 0.1, 0.1, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			break;
		}	
		case CARD_DIAMOND:
		{	
			CGContextSetRGBFillColor(context, 1, 0, 0, 1);
			CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
			float clrvals[] = {1.0, 0.1, 0.1, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			break;
		}	
		case CARD_CLUB:
		{	
			CGContextSetRGBFillColor(context, 0, 0, 1, 1);
			CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
			float clrvals[] = {0.1, 0.1, 1.0, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			break;
		}	
		case CARD_HEART:
		{	
			CGContextSetRGBFillColor(context, 1, 0, 0, 1);
			CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
			float clrvals[] = {1.0, 0.1, 1.0, 1};
			shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
			break;
		}	
	}
	CGContextSetShadowWithColor(context, shadowSize, 4.5, shadowClrs);
	
	float fOffsetY = 0;
/*	if(value < 9 && value != 0 && value != 5 && value != 7 && value != 1)
		fOffsetY = fFontSize/1.8;
	else if(value == 5 || value == 7 || value == 1)
		fOffsetY = fFontSize/1.35;
    else if(value != 9) 
		fOffsetY = fFontSize/1.5;
    else
		fOffsetY = fFontSize/1.35;
*/    
    
	signstarty = [CGameLayout GetCardInnerMargin] + fOffsetY;
	
	CGContextSetTextDrawingMode(context, kCGTextFillStroke);
	
	CGAffineTransform xform;
	CGContextSaveGState(context);
//	if(value == 1)
//		xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.4, 0.0, 0.0);
//	else if(value < 9 && value != 0)
//		xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.1, 0.0, 0.0);
//	else if(value == 9)
//		xform = CGAffineTransformMake(0.8, 0.0, 0.0, -1.4, 0.0, 0.0);
  //  else 
		xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
	CGContextSetTextMatrix(context, xform);
	CGContextShowTextAtPoint(context, signstartx, signstarty, pText[value], strlen(pText[value]));
	CGContextRestoreGState(context);
	if(value != 0 && value != 1 && value != 5 && value != 7 && value != 9 && value != 10 && value != 12)
		signstarty = rect.size.height - [CGameLayout GetCardInnerMargin]*1.4;
	else 
		signstarty = rect.size.height - [CGameLayout GetCardInnerMargin];
    
/*	if(value == 0)
		fOffsetY = fFontSize/1.35;
    //else if(value == 10)
    //	fOffsetY = fFontSize/1.8;
	else if(value == 12 || value == 11 || value == 9)
		fOffsetY = fFontSize/1.2;
	else 
		fOffsetY = fFontSize/1.8;*/
	signstartx = rect.size.width - [CGameLayout GetCardInnerMargin] - fOffsetY;
	CGContextShowTextAtPoint(context, signstartx, signstarty, pText[value], strlen(pText[value]));
	
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
	
	CGContextRestoreGState(context);
}	

+ (void)drawBasicCardDecorate:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect
{
	int type = GetCardType(nCard);
	if(type == CARD_INVALID)
		return;
	
	CGContextSaveGState(context);
	
	CGContextSetLineWidth(context, 1);
	float fAlpha = 0.5;
	switch(type)
	{
		case CARD_SPADE:
		{	
			CGContextSetRGBStrokeColor(context, 0, 0, 0, fAlpha);
			break;
		}	
		case CARD_DIAMOND:
		{	
			CGContextSetRGBStrokeColor(context, 1, 0, 0, fAlpha);
			break;
		}	
		case CARD_CLUB:
		{	
			CGContextSetRGBStrokeColor(context, 0, 0, 1, fAlpha);
			break;
		}	
		case CARD_HEART:
		{	
			CGContextSetRGBStrokeColor(context, 1, 0, 0, fAlpha);
			break;
		}	
	}
	float fmargin = [CGameLayout GetCardInnerMargin]*3.5/10;
	float startx = rect.origin.x + [CGameLayout GetCardInnerMargin];
	float starty = rect.origin.y + fmargin;
	float endx = rect.origin.x + rect.size.width - [CGameLayout GetCardInnerMargin];
	float endy = starty;
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx; 
	starty = rect.origin.y + fmargin;
	endx = rect.origin.x + rect.size.width - fmargin;
	endy = rect.origin.y + [CGameLayout GetCardInnerMargin];
	DrawLine2(context, startx, starty, endx, endy);
	
	
	startx = endx;
	starty = endy;
	endx = startx;
	endy = rect.origin.y + rect.size.height-[CGameLayout GetCardInnerMargin];
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = rect.origin.x + rect.size.width - [CGameLayout GetCardInnerMargin];
	endy = rect.origin.y + rect.size.height - fmargin;
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = rect.origin.x + [CGameLayout GetCardInnerMargin];
	endy = rect.origin.y + starty;
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = rect.origin.x + fmargin;
	endy = rect.origin.y + rect.size.height - [CGameLayout GetCardInnerMargin];
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = startx;
	endy = rect.origin.y + [CGameLayout GetCardInnerMargin];
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = rect.origin.x + [CGameLayout GetCardInnerMargin];
	endy = rect.origin.y + fmargin;
	DrawLine2(context, startx, starty, endx, endy);
	
	CGContextRestoreGState(context);
	
}

////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//The temperary card functions
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)drawTempCardBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGSize csize = CGSizeMake([CGameLayout GetCardCornerWidth], [CGameLayout GetCardCornerHeight]);
	CGContextSaveGState(context);
	
	[RenderHelper AddRoundRectToPath:context withRect:rect withOval:csize];
	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	//CGFloat colors[12] = {1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.6, 0.6, 1.0, 1.0};
	//CGFloat colors[12] = {1.0, 1.0, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0, 0.6, 0.6, 0.0, 1.0};
	CGFloat colors[8] = {1.0, 1.0, 1.0, 1.0, 0.6, 0.3, 0.3, 1.0};
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = rect.origin.x;
	pt1.y = rect.origin.y;
	pt2.x = rect.origin.x;//+rect.size.width;
	pt2.y = rect.origin.y+rect.size.height;
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	CGContextRestoreGState(context);
}	

+ (void)drawTempCardDecorate:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
	
	CGContextSetLineWidth(context, 1);
	float fAlpha = 0.5;
	CGContextSetRGBStrokeColor(context, 0, 1, 0, fAlpha);
	float fmargin = [CGameLayout GetCardInnerMargin]*3.5/10;
	float startx = [CGameLayout GetCardInnerMargin];
	float starty = fmargin;
	float endx = rect.size.width - [CGameLayout GetCardInnerMargin];
	float endy = starty;
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx; 
	starty = fmargin;
	endx = rect.size.width - fmargin;
	endy = [CGameLayout GetCardInnerMargin];
	DrawLine2(context, startx, starty, endx, endy);
	
	
	startx = endx;
	starty = endy;
	endx = startx;
	endy = rect.size.height-[CGameLayout GetCardInnerMargin];
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = rect.size.width - [CGameLayout GetCardInnerMargin];
	endy = rect.size.height - fmargin;
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = [CGameLayout GetCardInnerMargin];
	endy = starty;
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = fmargin;
	endy = rect.size.height - [CGameLayout GetCardInnerMargin];
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = startx;
	endy = [CGameLayout GetCardInnerMargin];
	DrawLine2(context, startx, starty, endx, endy);
	
	startx = endx;
	starty = endy;
	endx = [CGameLayout GetCardInnerMargin];
	endy = fmargin;
	DrawLine2(context, startx, starty, endx, endy);
	
	CGContextRestoreGState(context);
	
}

+ (void)drawTempCardSymbol:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
	float signheight;
	if([ApplicationConfigure iPhoneDevice])
    {    
		signheight = [CGameLayout GetCardSignHeight]*0.6;
    }    
	else
    {    
        if(IsClassicTheme() == 1)
            signheight = [CGameLayout GetCardSignHeight]*0.4;
        else 
            signheight = [CGameLayout GetCardAnimalSignHeight]*0.4;
    }
    if([ApplicationConfigure iPhoneDevice] || IsClassicTheme() == 1)
    {    
        CGColorSpaceRef		shadowClrSpace;
        CGColorRef			shadowClrs;
        CGSize				shadowSize;
        shadowClrSpace = CGColorSpaceCreateDeviceRGB();
        shadowSize = CGSizeMake(5, 0);
        float clrvals[] = {0.0, 1.1, 0.1, 1};
        shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
        CGContextSetShadowWithColor(context, shadowSize, 4.0, shadowClrs);
	
    
        float signwidth = signheight*CARD_SIGN_XY_RATIO;
        float signstartx = [CGameLayout GetCardInnerMargin]/2;
        float signstarty = [CGameLayout GetCardInnerMargin]/2;
	
        CGRect imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
        CGContextDrawImage(context, imgRect, g_SpadeImage);
	
        signstartx = rect.size.width - [CGameLayout GetCardInnerMargin]/2 - signwidth;
        imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
        CGContextDrawImage(context, imgRect, g_DiamondImage);
	
        signstarty = rect.size.height - [CGameLayout GetCardInnerMargin]/2 - signheight;
        imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
        CGContextDrawImage(context, imgRect, g_ClubImage);
	
        signstartx = [CGameLayout GetCardInnerMargin]/2;
        imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
	
        CGContextDrawImage(context, imgRect, g_HeartImage);
	
        CGColorSpaceRelease(shadowClrSpace);
        CGColorRelease(shadowClrs);
    
        CGContextRestoreGState(context);
	}
    else 
    {
        CGColorSpaceRef		shadowClrSpace;
        CGColorRef			shadowClrs;
        CGSize				shadowSize;
        shadowClrSpace = CGColorSpaceCreateDeviceRGB();
        shadowSize = CGSizeMake(1, 0);
        float clrvals[] = {0.0, 1.1, 0.1, 1};
        shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
        CGContextSetShadowWithColor(context, shadowSize, 4.0, shadowClrs);
        
        
        float signwidth = signheight*CARD_SIGN_XY_RATIO;
        signheight = signwidth*0.75;
        float signstartx = [CGameLayout GetCardInnerMargin]/2;
        float signstarty = [CGameLayout GetCardInnerMargin]/2;
        
        CGRect imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
        CGContextDrawImage(context, imgRect, g_DogImage);
        
        signheight = signwidth*0.78;
        signstartx = rect.size.width - [CGameLayout GetCardInnerMargin]/2 - signwidth-3.0;
        imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
        CGContextDrawImage(context, imgRect, g_BirdImage);
        
        signheight = signwidth*0.675;
        signstarty = rect.size.height - [CGameLayout GetCardInnerMargin]/2 - signheight-3.0;
        imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
        CGContextDrawImage(context, imgRect, g_LizardImage);
        
        signheight = signwidth*0.685;
        signstartx = [CGameLayout GetCardInnerMargin]/2;
        imgRect = CGRectMake(signstartx, signstarty, signwidth, signheight);
        
        CGContextDrawImage(context, imgRect, g_DragonImage);
        
        CGColorSpaceRelease(shadowClrSpace);
        CGColorRelease(shadowClrs);
        
        CGContextRestoreGState(context);
    }
}	


+ (void)drawTempCardNumber:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect
{
	int value  = GetCardValue(nCard);
	NSNumber* nsValue = [NSNumber numberWithInt: value];
	NSString* sNumber = [nsValue stringValue];
	const char *sText = [sNumber UTF8String];
	if(sText == NULL)
		return;
	
    float clrs[4] = {0.1, 0.5, 0.1, 1.0};
	CGImageRef imgNumber = CreateNumericImageWithColor(sText, clrs);
	if(imgNumber == NULL)
		return;
	
	float imgWidth = CGImageGetWidth(imgNumber);
	float imgHeight = CGImageGetHeight(imgNumber);
	float maxWidth = [CGameLayout GetCardWidth]*0.65;
	float maxHeight = [CGameLayout GetCardSignHeight];
	if([ApplicationConfigure iPADDevice])
	{	
		maxWidth = [CGameLayout GetCardWidth]*0.40;
		maxHeight = [CGameLayout GetCardSignHeight]*0.7;
	}	
	float width, height;
	height = maxHeight;
	width = height*imgWidth/imgHeight;
	
	if(maxWidth < width)
		width = maxWidth;

	CGContextSaveGState(context);
	
	float sx = (rect.size.width - width)/2.0;
	float sy = (rect.size.height - height)/2.0;
	
	CGRect imgRect = CGRectMake(sx, sy, width, height);
	
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
	shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	shadowSize = CGSizeMake(5, 0);
	float clrvals[] = {0.0, 1.0, 0.1, 1};
	shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
	CGContextSetShadowWithColor(context, shadowSize, 4.0, shadowClrs);
	
	CGContextDrawImage(context, imgRect, imgNumber);
	
	CGImageRelease(imgNumber);
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
	
	CGContextRestoreGState(context);
}	

+ (CGImageRef)CreateTempCard:(int)nCard
{
	CGImageRef image = NULL;
	
	float cardWidth = [CGameLayout GetCardWidth]; 
	float cardHeight = [CGameLayout GetCardHeight];
	
	CGRect rect = CGRectMake(0.0, 0.0, cardWidth, cardHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef cardBitmapContext = CGBitmapContextCreate(nil, cardWidth, cardHeight, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	[RenderHelper drawTempCardBackground:cardBitmapContext inRect:rect];	
	[RenderHelper drawTempCardDecorate:cardBitmapContext inRect:rect];	
	[RenderHelper drawTempCardSymbol:cardBitmapContext inRect:rect];
	[RenderHelper drawTempCardNumber:cardBitmapContext withCard:nCard inRect:rect];
	
	image = CGBitmapContextCreateImage(cardBitmapContext);
	CGContextRelease(cardBitmapContext);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}

////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//The signs(operators) button functions
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
+ (void) drawSignsBackground:(CGContextRef)context inRect:(CGRect)rect	
{
	CGContextSaveGState(context);
	
	[RenderHelper CreateFourFlowerPath:context withRect:rect];
	CGContextClip(context);

	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	CGFloat colors[12] = {1.0, 0.4, 0.35, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 0.42, 1.0};
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = rect.origin.x;
	pt1.y = rect.origin.y;
	pt2.x = rect.origin.x;
	pt2.y = rect.origin.y+rect.size.height;
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	
	CGContextRestoreGState(context);
}	

+ (void) drawSignsInnerBackground:(CGContextRef)context inRect:(CGRect)rect	
{
	CGContextSaveGState(context);
	
	[RenderHelper CreateFourFlowerPath:context withRect:rect];
	CGContextClip(context);
	
	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	CGFloat colors[12] = {1.0, 0.6, 0.65, 1.0, 0.85, 0.85, 0.85, 1.0, 1.0, 0.3, 0.25, 1.0};
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = rect.origin.x;
	pt1.y = rect.origin.y;
	pt2.x = rect.origin.x;
	pt2.y = rect.origin.y+rect.size.height;
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	CGContextRestoreGState(context);
}	


+ (void) drawSignImages:(CGContextRef)context inRect:(CGRect)rect	
{
	float imgWidth = CGImageGetWidth(g_SignSourceImage)/8.0;
	float imgHeight = CGImageGetHeight(g_SignSourceImage)/2.0;
	float sx = rect.origin.x;
	float sy = rect.origin.y;
	float sw = rect.size.width/2.0;
	float sh = rect.size.height/2.0;
	float cx, cy;
	CGImageRef signImage = NULL;
	CGRect imgrt;
	CGRect drawrt;
	
	imgrt.origin.y = 0.0;
	imgrt.size.width = imgWidth-2.0;
	imgrt.size.height = imgHeight;
	drawrt.size.width = imgWidth*0.8;
	drawrt.size.height = imgWidth*0.8;

	CGContextSetAlpha(context, 0.25);
	
	for (int i = 0; i < 4; ++i) 
	{
		imgrt.origin.x = (i+1.0)*imgWidth;
		signImage = CGImageCreateWithImageInRect(g_SignSourceImage, imgrt);
		if(i < 2)
			cx = sx + sw/2.0 + ((double)(i%2))*sw;
		else
			cx = sx + sw/2.0 + ((double)((i+1)%2))*sw;

		cy = sy + sh/2.0 + (1 < i? 1.0:0.0)*sh;
		drawrt.origin.x = cx - drawrt.size.width/2.0;
		drawrt.origin.y = cy - drawrt.size.height/2.0;
		CGContextDrawImage(context, drawrt, signImage);
		CGImageRelease(signImage);
	}
}	

+ (CGImageRef)CreateSignsButtomImage
{
	CGImageRef image = NULL;
	
	float signSize = [CGameLayout GetGameSignOutterSize];
	float signinnerSize = [CGameLayout GetGameSignInnerSize];
	float signMarginSize = (signSize - signinnerSize)/2.0;
	
	CGRect rect = CGRectMake(0.0, 0.0, signSize, signSize);
	CGRect rectInner = CGRectMake(signMarginSize, signMarginSize, signinnerSize, signinnerSize);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef signBitmapContext = CGBitmapContextCreate(nil, signSize, signSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	[RenderHelper drawSignsBackground:signBitmapContext inRect:rect];	
	[RenderHelper drawSignsInnerBackground:signBitmapContext inRect:rectInner];	
	[RenderHelper drawSignImages:signBitmapContext inRect:rectInner];	
	
	image = CGBitmapContextCreateImage(signBitmapContext);
	CGContextRelease(signBitmapContext);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}

+ (void)drawSignsQuarter:(CGContextRef)context inRect:(CGRect)rect at:(int)i
{
	CGContextSaveGState(context);
	
	[RenderHelper CreateQuarterFlowerPath:context withRect:rect withIndex:i];
	CGContextClip(context);
	
	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	CGFloat colors[8] = {1.0, 0.8, 0.8, 1.0, 1.0, 0.6, 0.6, 1.0};
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	
	if(i == 0)
	{	
		pt2.x = rect.origin.x;
		pt2.y = rect.origin.y;
		pt1.x = rect.origin.x+rect.size.width;
		pt1.y = rect.origin.y+rect.size.height;
	}
	else if(i == 1)
	{
		pt2.x = rect.origin.x+rect.size.width;
		pt2.y = rect.origin.y;
		pt1.x = rect.origin.x;
		pt1.y = rect.origin.y+rect.size.height;
	}	
	else if(i == 2)
	{
		pt1.x = rect.origin.x;
		pt1.y = rect.origin.y;
		pt2.x = rect.origin.x+rect.size.width;;
		pt2.y = rect.origin.y+rect.size.height;
	}
	else 
	{
		pt1.x = rect.origin.x+rect.size.width;
		pt1.y = rect.origin.y;
		pt2.x = rect.origin.x;
		pt2.y = rect.origin.y+rect.size.height;
	}

	
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	
	CGContextRestoreGState(context);
}	


+ (void)drawSignsInnerQuarter:(CGContextRef)context inRect:(CGRect)rect at:(int)i
{
	CGContextSaveGState(context);
	
	[RenderHelper CreateQuarterFlowerPath:context withRect:rect withIndex:i];
	CGContextClip(context);
	
	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	CGFloat colors[8] = {1.0, 0.75, 0.75, 1.0, 0.4, 0.0, 0.0, 1.0};
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	
	if(i == 0)
	{	
		pt2.x = rect.origin.x;
		pt2.y = rect.origin.y;
		pt1.x = rect.origin.x+rect.size.width;
		pt1.y = rect.origin.y+rect.size.height;
	}
	else if(i == 1)
	{
		pt2.x = rect.origin.x+rect.size.width;
		pt2.y = rect.origin.y;
		pt1.x = rect.origin.x;
		pt1.y = rect.origin.y+rect.size.height;
	}	
	else if(i == 2)
	{
		pt1.x = rect.origin.x;
		pt1.y = rect.origin.y;
		pt2.x = rect.origin.x+rect.size.width;;
		pt2.y = rect.origin.y+rect.size.height;
	}
	else 
	{
		pt1.x = rect.origin.x+rect.size.width;
		pt1.y = rect.origin.y;
		pt2.x = rect.origin.x;
		pt2.y = rect.origin.y+rect.size.height;
	}
	
	
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	
	CGContextRestoreGState(context);
}	

+ (CGImageRef)CreateSignHighlighImage:(int)i
{
	CGImageRef image = NULL;
	
	float signSize = [CGameLayout GetGameSignOutterSize];
	float signinnerSize = [CGameLayout GetGameSignInnerSize];
	float signMarginSize = (signSize - signinnerSize)/2.0;
	
	CGRect rect = CGRectMake(0.0, 0.0, signSize*0.5, signSize*0.5);
	CGRect rectInner;
	if(i == 0)
	{
		rectInner = CGRectMake(signMarginSize, signMarginSize, signinnerSize*0.5, signinnerSize*0.5);
	}	
	else if(i == 1)
	{
		rectInner = CGRectMake(0, signMarginSize, signinnerSize*0.5, signinnerSize*0.5);
	}	
	else if(i == 2)
	{
		rectInner = CGRectMake(0, 0, signinnerSize*0.5, signinnerSize*0.5);
	}
	else 
	{
		rectInner = CGRectMake(signMarginSize, 0, signinnerSize*0.5, signinnerSize*0.5);
	}
	
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef signBitmapContext = CGBitmapContextCreate(nil, signSize*0.5, signSize*0.5, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	[RenderHelper drawSignsQuarter:signBitmapContext inRect:rect at:i];	
	[RenderHelper drawSignsInnerQuarter:signBitmapContext inRect:rectInner at:i];	
	
	image = CGBitmapContextCreateImage(signBitmapContext);
	CGContextRelease(signBitmapContext);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}	

+ (CGImageRef) CreateSignImage:(int)i	
{
	float imgWidth = CGImageGetWidth(g_SignSourceImage)/8.0;
	float imgHeight = CGImageGetHeight(g_SignSourceImage)/2.0;
	
	CGImageRef signImage = NULL;
	CGRect imgrt;
	CGRect drawrt;
	
	imgrt.origin.y = imgHeight;
	imgrt.size.width = imgWidth-2.0;
	imgrt.size.height = imgHeight;
	
	drawrt.size.width = imgWidth*0.8;
	drawrt.size.height = imgWidth*0.8;
	drawrt.origin.x = 0.0;
	drawrt.origin.y = 0.0;
	
	imgrt.origin.x = (i+1.0)*imgWidth;
	signImage = CGImageCreateWithImageInRect(g_SignSourceImage, imgrt);

	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef signBitmapContext = CGBitmapContextCreate(nil, drawrt.size.width, drawrt.size.height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
	CGContextDrawImage(signBitmapContext, drawrt, signImage);
	CGImageRelease(signImage);
	
	CGImageRef image = CGBitmapContextCreateImage(signBitmapContext);
	CGContextRelease(signBitmapContext);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}	

+ (CGImageRef) CreateOriginalSignImage:(int)i
{
	float imgWidth = CGImageGetWidth(g_SignSourceImage)/8.0;
	float imgHeight = CGImageGetHeight(g_SignSourceImage)/2.0;
	
	CGImageRef signImage = NULL;
	CGRect imgrt;
	CGRect drawrt;
	
	imgrt.origin.y = 0;//imgHeight;
	imgrt.size.width = imgWidth-2.0;
	imgrt.size.height = imgHeight;
	
	drawrt.size.width = imgWidth;
	drawrt.size.height = imgWidth;
	drawrt.origin.x = 0.0;
	drawrt.origin.y = 0.0;
	
	imgrt.origin.x = (i+1.0)*imgWidth;
	signImage = CGImageCreateWithImageInRect(g_SignSourceImage, imgrt);
	
	return signImage; 
}	

+ (void)drawSignHighlight:(CGContextRef)context inRect:(CGRect)rect at:(int)i
{
	if(i < 0 || 4 <= i)
		return;
	
	CGContextSaveGState(context);
	
	float sw = rect.size.width*0.5;
	float sh = rect.size.height*0.5;
	
	CGRect drawrt;
	
	drawrt.size.width = sw;
	drawrt.size.height = sh;
	
	if(i < 2)
		drawrt.origin.x = rect.origin.x + ((double)(i%2))*sw;
	else
		drawrt.origin.x = rect.origin.x + ((double)((i+1)%2))*sw;
	
	drawrt.origin.y = rect.origin.y + (1 < i? 1.0:0.0)*sh;
	CGContextDrawImage(context, drawrt, g_SignHighLightImage[i]);
	
	CGContextRestoreGState(context);
}	
 
+ (void)drawSignAt:(CGContextRef)context inRect:(CGRect)rect at:(int)i
{
	if(i < 0 || 4 <= i)
		return;
	
	CGContextSaveGState(context);
	
	float signSize = [CGameLayout GetGameSignOutterSize];
	float signinnerSize = [CGameLayout GetGameSignInnerSize];
	float signMarginSize = (signSize - signinnerSize)/2.0;
	
	float sw = rect.size.width*0.5-signMarginSize;
	float sh = rect.size.height*0.5-signMarginSize;
	
	float sx = rect.origin.x+signMarginSize*0.5;
	float sy = rect.origin.y+signMarginSize*0.5;
	float cx, cy;
	
	CGRect drawrt;
	
	if([ApplicationConfigure iPhoneDevice])
	{	
		drawrt.size.width = sw*0.8;
		drawrt.size.height = sh*0.8;
	}
	else 
	{
		drawrt.size.width = sw*0.45;
		drawrt.size.height = sh*0.45;
	}	
	
	if(i < 2)
		cx = sx + sw/2.0 + ((double)(i%2))*sw;
	else
		cx = sx + sw/2.0 + ((double)((i+1)%2))*sw;
	
	cy = sy + sh/2.0 + (1 < i? 1.0:0.0)*sh;
	drawrt.origin.x = cx - drawrt.size.width/2.0;
	drawrt.origin.y = cy - drawrt.size.height/2.0;
	
	CGContextDrawImage(context, drawrt, g_SignImage[i]);
	
	CGContextRestoreGState(context);
}	
	
////////////////////////////////////////////////////////////////////////////////////////////////
//
//
// Global card rendering functions
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)DrawTempCard:(CGContextRef)context withImage:(CGImageRef)cardImg inRect:(CGRect)rect witHit:(BOOL)bHighlight
{
	CGContextDrawImage(context, rect, cardImg);
	if(bHighlight == YES)
	{
		[RenderHelper drawCardHighlight:context inRect:rect];
	}	
}	

+ (void)DrawBasicCardAnimation:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect witHit:(BOOL)bHighlight
{
	[RenderHelper drawAnimatedBasicCardBackground:context inRect:rect];	
	[RenderHelper drawBasicCardDecorate:context withCard: nCard inRect:rect];
	if(IsClassicTheme() == 1)
        [RenderHelper drawBasicCardSymbol:context withCard: nCard inRect:rect];
	else
        [RenderHelper drawBasicCardAnimalSymbol:context withCard: nCard inRect:rect];
	
    [RenderHelper drawBasicCardNumber:context withCard: nCard inRect:rect];
    if(bHighlight == YES)
    {	
        [RenderHelper drawCardHighlight:context inRect:rect];
    }
}

+ (void)AddRoundRectToPath:(CGContextRef)context withRect:(CGRect)rect withOval:(CGSize)oval
{
	float fw, fh, fr;
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
		fr = [CGameLayout GetCardCornerRadium];
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, fr);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, fr);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, fr);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, fr);
		CGContextRestoreGState(context);
		CGContextClosePath(context);
	}
}	

+ (void)CreateFourFlowerPath:(CGContextRef)context withRect:(CGRect)rect
{
	float fw, fh, fr;
	CGContextBeginPath(context);
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	fw = CGRectGetWidth(rect);
	fh = CGRectGetHeight(rect);
	fr = (fw < fh ? fw:fh);
	fr *= 0.25;
	
	//First flower, right-top one
	CGContextMoveToPoint(context, fw*0.75, fh*0.5);
	CGContextAddArcToPoint(context, fw, fh*0.5, fw, fh*0.25, fr);
	CGContextAddArcToPoint(context, fw, 0.0, fw*.75, 0.0, fr);
	CGContextAddArcToPoint(context, fw*0.5, 0.0, fw*0.5, fw*0.25, fr);
	
	//2nd flower, left-top one
	CGContextAddArcToPoint(context, fw*0.5, 0.0, fw*0.25, 0.0, fr);
	CGContextAddArcToPoint(context, 0.0, 0.0, 0.0, fh*0.25, fr);
	CGContextAddArcToPoint(context, 0.0, fh*0.5, fw*0.25, fh*0.5, fr);
	
	//3rd flower, left-bottom one
	CGContextAddArcToPoint(context, 0.0, fh*0.5, 0.0, fh*0.75, fr);
	CGContextAddArcToPoint(context, 0.0, fh, fw*0.25, fh, fr);
	CGContextAddArcToPoint(context, fw*0.5, fh, fw*0.5, fh*0.75, fr);

	//4th flower, right-bottom one
	CGContextAddArcToPoint(context, fw*0.5, fh, fw*0.75, fh, fr);
	CGContextAddArcToPoint(context, fw, fh, fw, fh*0.75, fr);
	CGContextAddArcToPoint(context, fw, fh*0.5, fw*0.75, fh*0.5, fr);
	
	CGContextRestoreGState(context);
	CGContextClosePath(context);
}	

+ (void)CreateQuarterFlowerPath:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)i
{
	float fw, fh, fr;
	CGContextBeginPath(context);
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	fw = CGRectGetWidth(rect);
	fh = CGRectGetHeight(rect);
	fr = (fw < fh ? fw:fh);
	fr *= 0.5;
	
	
	if(i == 0)
	{	
		CGContextMoveToPoint(context, fw*0.5, fh);
		CGContextAddArcToPoint(context, 0.0, fh, 0.0, fh*0.5, fr);
		CGContextAddArcToPoint(context, 0.0, 0.0, fw*0.5, 0.0, fr);
		CGContextAddArcToPoint(context, fw, 0.0, fw, fw*0.5, fr);
		CGContextAddLineToPoint(context,fw, fh);
		CGContextAddLineToPoint(context, fw*0.5, fh);
	}
	else if(i == 1)
	{
		CGContextMoveToPoint(context, fw*0.5, fh);
		CGContextAddArcToPoint(context, fw, fh, fw, fh*0.5, fr);
		CGContextAddArcToPoint(context, fw, 0.0, fw*0.5, 0.0, fr);
		CGContextAddArcToPoint(context, 0.0, 0.0, 0.0, fh*0.5, fr);
		CGContextAddLineToPoint(context,0.0, fh);
		CGContextAddLineToPoint(context, fw*0.5, fh);
	}
	else if(i == 2)
	{
		CGContextMoveToPoint(context, 0.0, fh*0.5);
		CGContextAddArcToPoint(context, 0.0, fh, fw*0.5, fh, fr);
		CGContextAddArcToPoint(context, fw, fh, fw, fh*0.5, fr);
		CGContextAddArcToPoint(context, fw, 0.0, fw*0.5, 0.0, fr);
		CGContextAddLineToPoint(context,0.0, 0.0);
		CGContextAddLineToPoint(context, 0.0, fh*0.5);
	}
	else 
	{	
		CGContextMoveToPoint(context, fw*0.5, 0.0);
		CGContextAddArcToPoint(context, 0.0, 0.0, 0.0, fh*0.5, fr);
		CGContextAddArcToPoint(context, 0.0, fh, fw*0.5, fh, fr);
		CGContextAddArcToPoint(context, fw, fh, fw, fh*0.5, fr);
		CGContextAddLineToPoint(context,fw, 0.0);
		CGContextAddLineToPoint(context, fw*0.5, 0.0);
	}		
	CGContextRestoreGState(context);
	CGContextClosePath(context);
}	

+ (void)InitializeCardSuitImages
{
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"card.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	CGImageRef srcImage = CGImageRetain(orgImagge.CGImage);
	float imgWidth = CGImageGetWidth(srcImage)/4.0;
	float imgHeight = CGImageGetHeight(srcImage);
	CGRect rt = CGRectMake(imgWidth*2, 0, imgWidth, imgHeight);
	g_SpadeImage = CGImageCreateWithImageInRect(srcImage, rt);
	rt = CGRectMake(0, 0, imgWidth, imgHeight);
	g_DiamondImage = CGImageCreateWithImageInRect(srcImage, rt); 
	rt = CGRectMake(imgWidth*3, 0, imgWidth, imgHeight);
	g_ClubImage = CGImageCreateWithImageInRect(srcImage, rt); 
	rt = CGRectMake(imgWidth, 0, imgWidth, imgHeight);
	g_HeartImage = CGImageCreateWithImageInRect(srcImage, rt); 
	CGImageRelease(srcImage);

    imagePath = [[NSBundle mainBundle] pathForResource:@"g1.png" ofType:nil];
	orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	g_DogImage = CGImageRetain(orgImagge.CGImage);

	imagePath = [[NSBundle mainBundle] pathForResource:@"b1.png" ofType:nil];
	orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	g_BirdImage = CGImageRetain(orgImagge.CGImage);
		
	imagePath = [[NSBundle mainBundle] pathForResource:@"d1.png" ofType:nil];
	orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	g_DragonImage = CGImageRetain(orgImagge.CGImage);
		
	imagePath = [[NSBundle mainBundle] pathForResource:@"l1.png" ofType:nil];
	orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	g_LizardImage = CGImageRetain(orgImagge.CGImage);
}	

+ (void)InitializeSignImages
{
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"signs.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	g_SignSourceImage = CGImageRetain(orgImagge.CGImage);
	
	
	g_SignsBtnImage = [RenderHelper CreateSignsButtomImage];
	for(int i = 0; i < 4; ++i)
	{
		g_SignHighLightImage[i] = [RenderHelper CreateSignHighlighImage:i];
		g_SignImage[i] = [RenderHelper CreateSignImage:i];
	}	
	for(int i = 0; i < 5; ++i)
	{	
		g_OriginalSignImage[i] = [RenderHelper CreateOriginalSignImage:i];
	}	
	
	CGImageRelease(g_SignSourceImage);
	g_SignSourceImage = NULL;
}


+ (void)IntializeScoreImages
{
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"star1.png" ofType:nil];
    UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
    g_ScoreFlame  = CGImageRetain(orgImagge.CGImage);

	imagePath = [[NSBundle mainBundle] pathForResource:@"heart1.png" ofType:nil];
    orgImagge = [UIImage imageWithContentsOfFile:imagePath];
    g_ScoreHeart  = CGImageRetain(orgImagge.CGImage);

	imagePath = [[NSBundle mainBundle] pathForResource:@"heart2.png" ofType:nil];
    orgImagge = [UIImage imageWithContentsOfFile:imagePath];
    g_ScoreHeart2  = CGImageRetain(orgImagge.CGImage);
    
}	

+ (void)Intialize
{
	[RenderHelper InitializeCardSuitImages];
	CGFloat colors[8] = {1.0, 1.0, 0.4, 0.6, 1.0, 0.0, 0.0, 0.85};
	g_HighlightColorspace = CGColorSpaceCreateDeviceRGB();
	g_HighlightGradient = CGGradientCreateWithColorComponents(g_HighlightColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));

	[RenderHelper InitializeSignImages];
	[RenderHelper IntializeGhostImage];
	[RenderHelper IntializeScoreImages];
    
    CGAffineTransform transform;
    CGPatternCallbacks callbacks;
	callbacks.version = 0;
	callbacks.drawPattern = &DrawPatternImage;
	callbacks.releaseInfo = &ReleasePatternImage;
    
	CGImageRef image = [ImageLoader LoadImageWithName:@"bktex.png"];
	
	float width = CGImageGetWidth(image);
	float height = CGImageGetHeight(image);
	
	transform = CGAffineTransformIdentity;
    
    
	m_BkgndPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    
	image = [ImageLoader LoadImageWithName:@"greentex2.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
	m_GreenBkgndPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
	image = [ImageLoader LoadImageWithName:@"bkpattern.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
	m_NumericBkgndPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    
    m_PatternSpace = CGColorSpaceCreatePattern(NULL);
    m_Colorspace = CGColorSpaceCreateDeviceRGB();
    
    
    m_MeIdle[1] = [ImageLoader LoadImageWithName:@"meidleicon1.png"];
    m_MeIdle[0] = [ImageLoader LoadImageWithName:@"meidleicon2.png"];
    m_MeIdle[2] = [ImageLoader LoadImageWithName:@"meidleicon3.png"];
    
    m_MePlay[1] = [ImageLoader LoadImageWithName:@"meplayicon1.png"];
    m_MePlay[0] = [ImageLoader LoadImageWithName:@"meplayicon2.png"];
    m_MePlay[2] = [ImageLoader LoadImageWithName:@"meplayicon3.png"];
    
    m_MeWin[0] = [ImageLoader LoadImageWithName:@"mewinicon1.png"];
    m_MeWin[1] = [ImageLoader LoadImageWithName:@"mewinicon2.png"];
    m_MeWin[2] = [ImageLoader LoadImageWithName:@"mewinicon3.png"];
    
    m_MeCry[1] = [ImageLoader LoadImageWithName:@"mecryicon1.png"];
    m_MeCry[0] = [ImageLoader LoadImageWithName:@"mecryicon2.png"];
    m_MeCry[2] = [ImageLoader LoadImageWithName:@"mecryicon3.png"];
    
    
    
    m_AvatarIdle[1] = [ImageLoader LoadImageWithName:@"ropaidleicon1.png"];
    m_AvatarIdle[0] = [ImageLoader LoadImageWithName:@"ropaidleicon2.png"];
    m_AvatarIdle[2] = [ImageLoader LoadImageWithName:@"ropaidleicon3.png"];
    
    m_AvatarPlay[1] = [ImageLoader LoadImageWithName:@"ropaplayicon1.png"];
    m_AvatarPlay[0] = [ImageLoader LoadImageWithName:@"ropaplayicon2.png"];
    m_AvatarPlay[2] = [ImageLoader LoadImageWithName:@"ropaplayicon3.png"];
    
    m_AvatarWin[0] = [ImageLoader LoadImageWithName:@"ropawinicon1.png"];
    m_AvatarWin[1] = [ImageLoader LoadImageWithName:@"ropawinicon2.png"];
    m_AvatarWin[2] = [ImageLoader LoadImageWithName:@"ropawinicon3.png"];
    
    m_AvatarCry[1] = [ImageLoader LoadImageWithName:@"ropacryicon1.png"];
    m_AvatarCry[0] = [ImageLoader LoadImageWithName:@"ropacryicon2.png"];
    m_AvatarCry[2] = [ImageLoader LoadImageWithName:@"ropacryicon3.png"];
    
    m_OnlineGestures[0] = [ImageLoader LoadImageWithName:@"opicon1.png"];
    m_OnlineGestures[1] = [ImageLoader LoadImageWithName:@"opicon2.png"];
    m_OnlineGestures[2] = [ImageLoader LoadImageWithName:@"opicon3.png"];
    m_OnlineHat = [ImageLoader LoadImageWithName:@"ophat.png"];
}

+ (void)Release
{
	if(g_SpadeImage != NULL)
		CGImageRelease(g_SpadeImage);
	
	if(g_DiamondImage != NULL)
		CGImageRelease(g_DiamondImage);
	
	if(g_ClubImage != NULL)
		CGImageRelease(g_ClubImage);
	
	if(g_HeartImage != NULL)
		CGImageRelease(g_HeartImage);

	if(g_DogImage != NULL)
		CGImageRelease(g_DogImage);
		
	if(g_BirdImage != NULL)
		CGImageRelease(g_BirdImage);
		
	if(g_DragonImage != NULL)
		CGImageRelease(g_DragonImage);
		
	if(g_LizardImage != NULL)
		CGImageRelease(g_LizardImage);
	
	CGColorSpaceRelease(g_HighlightColorspace);
	CFRelease(g_HighlightGradient);
	
	if(g_SignsBtnImage != NULL)
		CGImageRelease(g_SignsBtnImage);
	
	for(int i = 0; i < 4; ++i)
	{
		CGImageRelease(g_SignHighLightImage[i]);
		CGImageRelease(g_SignImage[i]);
	}
	
	for(int i = 0; i < 5; ++i)
	{	
		CGImageRelease(g_OriginalSignImage[i]);
	}	
	
	if(g_SignSourceImage != NULL)
	{	
		CGImageRelease(g_SignSourceImage);
	}	
	
	for(int i = 0; i < 4; ++i)
	{	
        CGImageRelease(g_GhostImage[i]);
	}	
	CGImageRelease(g_GhostNumber);
	
	CGImageRelease(g_ScoreFlame);
	CGImageRelease(g_ScoreHeart);
	CGImageRelease(g_ScoreHeart2);
    
    CGPatternRelease(m_BkgndPattern);
    CGPatternRelease(m_GreenBkgndPattern);
    CGPatternRelease(m_NumericBkgndPattern);
    CGColorSpaceRelease(m_PatternSpace);
    CGColorSpaceRelease(m_Colorspace);

    for(int i = 0; i < 3; ++i)
    {
        if(m_MeIdle[i])
            CGImageRelease(m_MeIdle[i]);
        
        if(m_MePlay[i])
            CGImageRelease(m_MePlay[i]);
        
        if(m_MeWin[i])
            CGImageRelease(m_MeWin[i]);
        
        if(m_MeCry[i])
            CGImageRelease(m_MeCry[i]);
        
        
        if(m_AvatarIdle[i])
            CGImageRelease(m_AvatarIdle[i]);
        
        if(m_AvatarPlay[i])
            CGImageRelease(m_AvatarPlay[i]);
        
        if(m_AvatarWin[i])
            CGImageRelease(m_AvatarWin[i]);
        
        if(m_AvatarCry[i])
            CGImageRelease(m_AvatarCry[i]);
        
        if(m_OnlineGestures[i])
            CGImageRelease(m_OnlineGestures[i]);
    }

    CGImageRelease(m_OnlineHat);
}	

+ (CGImageRef)GetTempCardImage_p:(int)nCard
{
	CGImageRef image = [RenderHelper CreateTempCard:nCard];
	
	return image;
}

+ (void)DrawSigns:(CGContextRef)context withSign:(int)nOperator witHit:(BOOL)bHighlight inRect:(CGRect)rect
{
	if(g_SignsBtnImage != NULL)
	{	
		CGContextDrawImage(context, rect, g_SignsBtnImage);
		if(GAME_CALCULATION_NONE < nOperator && bHighlight == YES)
		{
			[RenderHelper drawSignHighlight:context inRect:rect at:nOperator];
		}	
		if(GAME_CALCULATION_NONE < nOperator)
		{
			[RenderHelper drawSignAt:context inRect:rect at:nOperator];
		}	
	}	
}	

+ (void)DrawSingleSign:(CGContextRef)context withSign:(int)nOperator witHit:(BOOL)bHighlight inRect:(CGRect)rect
{
	if(GAME_CALCULATION_NONE < nOperator)
	{
		CGContextDrawImage(context, rect, g_OriginalSignImage[nOperator]);
	}
}

+ (void)DrawGhost:(CGContextRef)context inRect:(CGRect)rect withIndex:(int)aniIndex
{
	CGContextSaveGState(context);
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
	shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	shadowSize = CGSizeMake(2, 2);
	float clrvals[] = {0.1, 0.1, 0.1, 1};
	shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
	CGContextSetShadowWithColor(context, shadowSize, 2.0, shadowClrs);
   
    
    //int nBkgnd = GetGameBackground();
    //if(nBkgnd == GAME_BACKGROUND_CHECKER || nBkgnd == GAME_BACKGROUND_WOOD)
    //    CGContextSetAlpha(context, 1.0);
    //else        
    //    CGContextSetAlpha(context, 0.5);
	
    int index = aniIndex;
    if(index < 0 || 4 <= index)
        index = 0;
    
    float imgw = CGImageGetWidth(g_GhostImage[index]);
    float imgh = CGImageGetHeight(g_GhostImage[index]);
    float h = rect.size.width*imgh/imgw;
    CGRect rt = CGRectMake(rect.origin.x, rect.origin.y+(rect.size.height-h), rect.size.width, h);
    CGContextDrawImage(context, rt, g_GhostImage[index]);
	
    
 	float imgWidth = CGImageGetWidth(g_GhostNumber);
	float imgHeight = CGImageGetHeight(g_GhostNumber);
	
	float maxWidth;
	float maxHeight = (rect.size.height - h)*0.8; //[CGameLayout GetCardSignHeight];
	
    maxWidth = [CGameLayout GetCardWidth]*0.65;
	if([ApplicationConfigure iPADDevice])
	{	
		maxWidth = [CGameLayout GetCardWidth]*0.40;
	}	
	float width, height;
	height = maxHeight;
	width = height*imgWidth/imgHeight;
	
	if(maxWidth < width)
		width = maxWidth;
	
	float sx = rect.origin.x + (rect.size.width - width)/2.0;
	float sy = rect.origin.y + (rect.size.height - height - h)/2.0;
	
	CGRect imgRect = CGRectMake(sx, sy, width, height);
	
	CGContextDrawImage(context, imgRect, g_GhostNumber);
	
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
	
    CGContextRestoreGState(context);
}

/*
+ (void)DrawGhostHorizontalFlip:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
    int nBkgnd = GetGameBackground();
    if(nBkgnd == GAME_BACKGROUND_CHECKER || nBkgnd == GAME_BACKGROUND_WOOD)
        CGContextSetAlpha(context, 1.0);
    else        
        CGContextSetAlpha(context, 0.5);
    
	CGContextDrawImage(context, rect, g_GhostImage2);
	CGContextRestoreGState(context);
}
*/

+ (void)DrawBulletinSign:(CGContextRef)context withSign:(int)nCount inRect:(CGRect)rect withType:(BOOL)bWinSign
{
    if(bWinSign)
    {    
		CGContextDrawImage(context, rect, g_ScoreFlame);
    }
    else
    {
		CGContextDrawImage(context, rect, g_ScoreHeart);
    }
    
    if(0 < nCount)
    {    
        NSNumber* nsValue = [NSNumber numberWithInt: nCount];
        NSString* sNumber = [nsValue stringValue];
        const char *sText = [sNumber UTF8String];
        if(sText == NULL)
            return;
        CGImageRef imgNumber = NULL;
        if(bWinSign)
        {    
            float clrs[4] = {1.0, 0.0, 0.0, 1.0};
            imgNumber = CreateNumericImageWithColor(sText, clrs);
            if(imgNumber == NULL)
                return;
        }
        else
        {
            float clrs[4] = {1.0, 1.0, 1.0, 1.0};
            imgNumber = CreateNumericImageWithColor(sText, clrs);
            if(imgNumber == NULL)
                return;
        }
        
        float cx = rect.origin.x + rect.size.width*0.5;
        float cy = rect.origin.y + rect.size.height*0.5;
        float w = rect.size.width*0.5;
        CGRect rt = CGRectMake(cx-w*0.5, cy-w*0.5, w, w);
		CGContextDrawImage(context, rt, imgNumber);
        CGImageRelease(imgNumber);
    }
}

+ (void)DrawRotateBulletinSign:(CGContextRef)context withSign:(int)nCount inRect:(CGRect)rect withAngle:(float)fRotateAngle
{
    CGContextSaveGState(context);
    float cx = rect.origin.x + rect.size.width/2.0;
    float cy = rect.origin.y + rect.size.height/2.0;
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, fRotateAngle*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
    
    CGContextDrawImage(context, rect, g_ScoreHeart);
    CGContextRestoreGState(context);

    if(0 < nCount)
    {    
        NSNumber* nsValue = [NSNumber numberWithInt: nCount];
        NSString* sNumber = [nsValue stringValue];
        const char *sText = [sNumber UTF8String];
        if(sText == NULL)
            return;
        CGImageRef imgNumber = NULL;
        float clrs[4] = {1.0, 1.0, 1.0, 1.0};
        imgNumber = CreateNumericImageWithColor(sText, clrs);
        if(imgNumber == NULL)
            return;
    
        float cx = rect.origin.x + rect.size.width*0.5;
        float cy = rect.origin.y + rect.size.height*0.5;
        float w = rect.size.width*0.5;
        CGRect rt = CGRectMake(cx-w*0.5, cy-w*0.5, w, w);
        CGContextDrawImage(context, rt, imgNumber);
        CGImageRelease(imgNumber);
    }
}


+ (void)DrawBulletinSign2:(CGContextRef)context withSign:(int)nCount inRect:(CGRect)rect withType:(BOOL)bWinSign
{
    if(bWinSign)
    {    
		CGContextDrawImage(context, rect, g_ScoreFlame);
    }
    else
    {
		CGContextDrawImage(context, rect, g_ScoreHeart2);
    }
    
    if(0 < nCount)
    {    
        NSNumber* nsValue = [NSNumber numberWithInt: nCount];
        NSString* sNumber = [nsValue stringValue];
        const char *sText = [sNumber UTF8String];
        if(sText == NULL)
            return;
        CGImageRef imgNumber = NULL;
        if(bWinSign)
        {    
            float clrs[4] = {1.0, 0.0, 0.0, 1.0};
            imgNumber = CreateNumericImageWithColor(sText, clrs);
            if(imgNumber == NULL)
                return;
        }
        else
        {
            float clrs[4] = {1.0, 1.0, 1.0, 1.0};
            imgNumber = CreateNumericImageWithColor(sText, clrs);
            if(imgNumber == NULL)
                return;
        }
        
        float cx = rect.origin.x + rect.size.width*0.5;
        float cy = rect.origin.y + rect.size.height*0.5;
        float w = rect.size.width*0.5;
        CGRect rt = CGRectMake(cx-w*0.5, cy-w*0.5, w, w);
		CGContextDrawImage(context, rt, imgNumber);
        CGImageRelease(imgNumber);
    }
}

+ (void)DrawSimpleCardNumber:(CGContextRef)context withCard:(int)index inRect:(CGRect)rect
{
    int nType = GetCardType(index);
    if(nType == CARD_INVALID)
        return;
    [RenderHelper drawSimpleCardNumber:context withCard:index inRect:rect];
}	

+ (void)drawSimpleCardNumber:(CGContextRef)context withCard:(int)nCard inRect:(CGRect)rect
{
	int value  = GetCardValue(nCard);
	int type = GetCardType(nCard);
	if(type == CARD_INVALID)
		return;
	NSNumber* nsValue = [NSNumber numberWithInt: value];
	NSString* sNumber = [nsValue stringValue];
	const char *sText = [sNumber UTF8String];
	if(sText == NULL)
		return;
	
    float clrstemp[4] = {0.1, 0.5, 0.1, 1.0};
    float clrsspade[4] = {0.0, 0.0, 0.0, 1.0};
    float clrsdiamond[4] = {1.0, 0.0, 0.0, 1.0};
    float clrsclub[4] = {0.0, 0.0, 1.0, 1.0};
    float clrsheart[4] = {1.0, 0.0, 0.0, 1.0};

	CGImageRef imgNumber = NULL;
   
	switch(type)
	{
		case CARD_SPADE:
		{	
            imgNumber = CreateNumericImageWithColor(sText, clrsspade);
			break;
		}	
		case CARD_DIAMOND:
		{	
            imgNumber = CreateNumericImageWithColor(sText, clrsdiamond);
			break;
		}	
		case CARD_CLUB:
		{	
            imgNumber = CreateNumericImageWithColor(sText, clrsclub);
			break;
		}	
		case CARD_HEART:
		{	
            imgNumber = CreateNumericImageWithColor(sText, clrsheart);
			break;
		}
        default:
        {
            imgNumber = CreateNumericImageWithColor(sText, clrstemp);
			break;
        }
	}
	if(imgNumber == NULL)
		return;
	
	float imgWidth = CGImageGetWidth(imgNumber);
	float imgHeight = CGImageGetHeight(imgNumber);
	float maxWidth = rect.size.width;
	float maxHeight = rect.size.height;
	float width, height;
	height = maxHeight;
	width = height*imgWidth/imgHeight;
	
	if(maxWidth < width)
		width = maxWidth;
    
	CGContextSaveGState(context);
	
	float sx = rect.origin.x + (rect.size.width - width)/2.0;
	float sy = rect.origin.y + (rect.size.height - height)/2.0;
	
	CGRect imgRect = CGRectMake(sx, sy, width, height);
	CGContextDrawImage(context, imgRect, imgNumber);
	
	CGImageRelease(imgNumber);
	
	CGContextRestoreGState(context);
}	


+(void)DefaultPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, m_PatternSpace);
    CGContextSetFillPattern(context, m_BkgndPattern, &fAlpha);
	CGContextFillRect (context, rect);	
	CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float colors[4] = {1, 0.6, 0.6, 0.4};
    CGContextSetFillColorSpace(context, m_Colorspace);
	CGContextSetFillColor(context, colors);
	CGContextFillRect(context, rect);
	CGContextRestoreGState(context);
}

+(void)DrawGreenPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, m_PatternSpace);
    CGContextSetFillPattern(context, m_GreenBkgndPattern, &fAlpha);
	CGContextFillRect (context, rect);	
	CGContextRestoreGState(context);
}

+(void)DrawNumericPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, m_PatternSpace);
    CGContextSetFillPattern(context, m_NumericBkgndPattern, &fAlpha);
	CGContextFillRect (context, rect);	
	CGContextRestoreGState(context);
}

+(void)DrawAvatarIdle:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withFlag:(BOOL)isMe
{
    CGImageRef image;
    if(isMe)
        image = m_MeIdle[index];
    else    
        image = m_AvatarIdle[index];
    
    float w = CGImageGetWidth(image);
    float h = CGImageGetHeight(image);
    float fratio1 = rect.size.width/w;
    float fratio2 = rect.size.height/h;
    
    float fratio = fratio1 < fratio2 ? fratio1 : fratio2; 
    
    w = w*fratio;
    h = h*fratio;
    
    
    float sx = rect.origin.x + (rect.size.width - w)/2.0;
    float sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect drawRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, drawRect, image);
}

+(void)DrawAvatarPlay:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withFlag:(BOOL)isMe
{
    CGImageRef image;
    if(isMe)
        image = m_MePlay[index];
    else    
        image = m_AvatarPlay[index];
    
    float w = CGImageGetWidth(image);
    float h = CGImageGetHeight(image);
    float fratio1 = rect.size.width/w;
    float fratio2 = rect.size.height/h;
    
    float fratio = fratio1 < fratio2 ? fratio1 : fratio2; 
    
    w = w*fratio;
    h = h*fratio;
    
    
    float sx = rect.origin.x + (rect.size.width - w)/2.0;
    float sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect drawRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, drawRect, image);
}

+(void)DrawAvatarResult:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withResult:(BOOL)bWinResult withFlag:(BOOL)isMe
{
    CGImageRef image;
    if(isMe)
    {
        if(bWinResult)
            image = m_MeWin[index];
        else
            image = m_MeCry[index];
    }
    else    
    {    
        if(bWinResult)
            image = m_AvatarWin[index];
        else
            image = m_AvatarCry[index];
    }
    
    float w = CGImageGetWidth(image);
    float h = CGImageGetHeight(image);
     
    float fratio1 = rect.size.width/w;
    float fratio2 = rect.size.height/h;
     
    float fratio = fratio1 < fratio2 ? fratio1 : fratio2; 
     
    w = w*fratio;
    h = h*fratio;
    
    float sx = rect.origin.x + (rect.size.width - w)/2.0;
    float sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect drawRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, drawRect, image);
}

+(void)DrawOnlinePlayerGesture:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index
{
    CGImageRef image = m_OnlineGestures[index];
    float w = CGImageGetWidth(image)/2.0;
    float h = CGImageGetHeight(image)/2.0;
    
    float sx = rect.origin.x + (rect.size.width - w)/2.0;
    float sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect drawRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, drawRect, image);
}

+(void)DrawOnlinePlayeHat:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_OnlineHat);
}


@end
