//
//  ChoiceDisplay.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-20.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ChoiceDisplay.h"
#import "ApplicationConfigure.h"
#import "ImageLoader.h"
#import "GameConstants.h"
#import "RenderHelper.h"
#import "Configuration.h"
#include "drawhelper.h"


@implementation ChoiceDisplay

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_ImageNumber = NULL;
		CGFloat clrvals[] = {0.1, 0.1, 0.05, 1.0};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_ShadowSize = CGSizeMake(3, 3);
        m_nSeatID = -1;
        m_bShowChoice = YES;
        m_LuckyNumber = 0;
    }
    return self;    
}

-(void)dealloc
{
    if(m_ImageNumber != NULL)
        CGImageRelease(m_ImageNumber);
    
	CGColorSpaceRelease(m_ShadowClrSpace);
	CGColorRelease(m_ShadowClrs);
    
    
}

-(void)DrawBackground:(CGContextRef)context at:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, m_ShadowSize, 3, m_ShadowClrs);
    if([Configuration getCurrentGameTheme] == GAME_THEME_NUMBER)
        [RenderHelper DrawLuckSignBackground:context at:rect];
    else
        [RenderHelper DrawLuckSignBackground2:context at:rect];
    CGContextRestoreGState(context);
}

-(void)DrawNumeric:(CGContextRef)context at:(CGRect)rect
{
    float fSize = rect.size.width*0.5;
    float fImageWidth = CGImageGetWidth(m_ImageNumber);
    float fImageHeight = CGImageGetHeight(m_ImageNumber);
    float fRatio = fImageWidth/fImageHeight;
    float w, h;
    if(1.0 < fRatio)
    {
        w = 0.8*fSize;
        h = w/fRatio;
    }
    else
    {
        h = 0.8*fSize;
        w = h*fRatio;
    }
    float sx = rect.origin.x + (rect.size.width-w)/2.0;
    float sy = rect.origin.y + (rect.size.height-h)/2.0;
    CGRect rt = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, rt, m_ImageNumber);
}

-(void)DrawThemeSign:(CGContextRef)context at:(CGRect)rect
{
    float w = rect.size.width*0.6;
    float h = w;
    float sx = rect.origin.x + (rect.size.width-w)/2.0;
    float sy = rect.origin.y + (rect.size.height-h)/2.0;
    CGRect rt = CGRectMake(sx, sy, w, h);
    
    int nTheme = [Configuration getCurrentGameTheme];
    
    if(nTheme == GAME_THEME_KULO)
        [RenderHelper DrawKuloIcon:context at:rt index:m_LuckyNumber];
    else if(nTheme == GAME_THEME_ANIMAL1)
        [RenderHelper DrawAnimal1Icon:context at:rt index:m_LuckyNumber];
    else if(nTheme == GAME_THEME_ANIMAL2)
        [RenderHelper DrawAnimal2Icon:context at:rt index:m_LuckyNumber];
    else if(nTheme == GAME_THEME_FOOD)
        [RenderHelper DrawFoodIcon:context at:rt index:m_LuckyNumber];
    else if(nTheme == GAME_THEME_FLOWER)
        [RenderHelper DrawFlowerIcon:context at:rt index:m_LuckyNumber];
    else if(nTheme == GAME_THEME_EASTEREGG)
        [RenderHelper DrawEasterEggIcon:context at:rt index:m_LuckyNumber];
    else
        [RenderHelper DrawAnimalIcon:context at:rt index:m_LuckyNumber];
}

-(void)DrawNumber:(CGContextRef)context at:(CGRect)rect
{
    if([Configuration getCurrentGameTheme] == GAME_THEME_NUMBER)
        [self DrawNumeric:context at:rect];
    else
        [self DrawThemeSign:context at:rect];
}

-(void)DrawQMark:(CGContextRef)context at:(CGRect)rect
{
    float fSize = rect.size.width*0.3;
    if([Configuration getCurrentGameTheme] != GAME_THEME_NUMBER)
        fSize = rect.size.width*0.5;
    float sx = rect.origin.x + (rect.size.width-fSize)/2.0;
    float sy = rect.origin.y + (rect.size.height-fSize)/2.0;
    CGRect rt = CGRectMake(sx, sy, fSize, fSize);
    [RenderHelper DrawGreenQmark:context at:rt]; 
}


-(void)DrawChoice:(CGContextRef)context at:(CGRect)rect
{
    [self DrawBackground:context at:rect];
    if(m_ImageNumber != NULL)
    {
        if(m_bShowChoice == YES)
            [self DrawNumber:context at:rect];
        else
            [self DrawQMark:context at:rect];
    }
}

-(void)SetChoice:(int)nLuckNumber
{
    CGFloat clr[4] = {0.0, 1.0, 0.2, 1.0};
    NSString* str = [NSString stringWithFormat:@"%i", nLuckNumber];
    char* snum = (char*)[str UTF8String];
    m_ImageNumber = CreateNumericImageWithColor(snum, clr);
    m_LuckyNumber = nLuckNumber - 1;
}

-(void)ClearChoice
{
    if(m_ImageNumber != NULL)
    {    
        CGImageRelease(m_ImageNumber);
        m_ImageNumber = NULL;
    }    
    m_LuckyNumber = 0;
}


-(void)SetSeatID:(int)nID
{
    m_nSeatID = nID;
}

-(int)GetSeatID
{
    return m_nSeatID;
}

-(void)HideChoice
{
    m_bShowChoice = NO;
}

-(void)ShowChoice
{
    m_bShowChoice = YES;
}

@end
