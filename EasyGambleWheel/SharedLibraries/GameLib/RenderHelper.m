//
//  RenderHelper.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "RenderHelper.h"
#import "ImageLoader.h"
#include "drawhelper.h"

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


static CGImageRef          m_LuckSignBackgroundImage;
static CGImageRef          m_LuckSignBackgroundImage2;
static CGImageRef          m_BetSignBackgroundImage;
static CGImageRef          m_RedStarImage; 
static CGImageRef          m_CashImage; 
static CGImageRef          m_CrossImage; 
static CGImageRef          m_CashOctagonImage;
static CGImageRef          m_CashEarnIconMe;
static CGImageRef          m_CashEarnIconOther;
static CGImageRef          m_DisableCashEarnIconMe;
static CGImageRef          m_DisableCashEarnIconOther;


static CGPatternRef        m_BkgndPattern;

static CGImageRef          m_OnLineGroupIcon;
static CGImageRef          m_EnableSignIcon;
static CGImageRef          m_DisableSignIcon;
static CGImageRef          m_GreenQmark;
static CGImageRef          m_YellowQmark;


static CGGradientRef       m_BlueGradient;
static CGColorSpaceRef     m_BlueColorspace;

static CGGradientRef       m_HighLightGradient;
static CGColorSpaceRef     m_HighLightColorspace;


static CGImageRef          m_FooodIcon[8];
static CGImageRef          m_FlowerIcon[8];
static CGImageRef          m_AnimalIcon[8];
static CGImageRef          m_EasterEggIcon[8];

static CGImageRef          m_Animal1Icon[8];
static CGImageRef          m_Animal2Icon[8];
static CGImageRef          m_KuloIcon[8];


static CGImageRef           m_Spiral;


@implementation RenderHelper

+(void)InitializeAnimal1IconsResource
{
    m_Animal1Icon[0] = [ImageLoader LoadImageWithName:@"ab1.png"];
    m_Animal1Icon[1] = [ImageLoader LoadImageWithName:@"ab2.png"];
    m_Animal1Icon[2] = [ImageLoader LoadImageWithName:@"ab3.png"];
    m_Animal1Icon[3] = [ImageLoader LoadImageWithName:@"ab4.png"];
    m_Animal1Icon[4] = [ImageLoader LoadImageWithName:@"ab5.png"];
    m_Animal1Icon[5] = [ImageLoader LoadImageWithName:@"ab6.png"];
    m_Animal1Icon[6] = [ImageLoader LoadImageWithName:@"ab7.png"];
    m_Animal1Icon[7] = [ImageLoader LoadImageWithName:@"ab8.png"];
}


+(void)InitializeAnimal2IconsResource
{
    m_Animal2Icon[0] = [ImageLoader LoadImageWithName:@"ac1.png"];
    m_Animal2Icon[1] = [ImageLoader LoadImageWithName:@"ac2.png"];
    m_Animal2Icon[2] = [ImageLoader LoadImageWithName:@"ac3.png"];
    m_Animal2Icon[3] = [ImageLoader LoadImageWithName:@"ac4.png"];
    m_Animal2Icon[4] = [ImageLoader LoadImageWithName:@"ac5.png"];
    m_Animal2Icon[5] = [ImageLoader LoadImageWithName:@"ac6.png"];
    m_Animal2Icon[6] = [ImageLoader LoadImageWithName:@"ac7.png"];
    m_Animal2Icon[7] = [ImageLoader LoadImageWithName:@"ac8.png"];
}

+(void)InitializeKuloIconsResource
{
    m_KuloIcon[0] = [ImageLoader LoadImageWithName:@"kl1.png"];
    m_KuloIcon[1] = [ImageLoader LoadImageWithName:@"kl2.png"];
    m_KuloIcon[2] = [ImageLoader LoadImageWithName:@"kl3.png"];
    m_KuloIcon[3] = [ImageLoader LoadImageWithName:@"kl4.png"];
    m_KuloIcon[4] = [ImageLoader LoadImageWithName:@"kl5.png"];
    m_KuloIcon[5] = [ImageLoader LoadImageWithName:@"kl6.png"];
    m_KuloIcon[6] = [ImageLoader LoadImageWithName:@"kl7.png"];
    m_KuloIcon[7] = [ImageLoader LoadImageWithName:@"kl8.png"];
}



+(void)InitializeFoodIconsResource
{
    m_FooodIcon[0] = [ImageLoader LoadImageWithName:@"fd1.png"];
    m_FooodIcon[1] = [ImageLoader LoadImageWithName:@"fd2.png"];
    m_FooodIcon[2] = [ImageLoader LoadImageWithName:@"fd3.png"];
    m_FooodIcon[3] = [ImageLoader LoadImageWithName:@"fd4.png"];
    m_FooodIcon[4] = [ImageLoader LoadImageWithName:@"fd5.png"];
    m_FooodIcon[5] = [ImageLoader LoadImageWithName:@"fd6.png"];
    m_FooodIcon[6] = [ImageLoader LoadImageWithName:@"fd7.png"];
    m_FooodIcon[7] = [ImageLoader LoadImageWithName:@"fd8.png"];
}

+(void)InitializeFlowerIconsResource
{
    m_FlowerIcon[0] = [ImageLoader LoadImageWithName:@"fl1.png"];
    m_FlowerIcon[1] = [ImageLoader LoadImageWithName:@"fl2.png"];
    m_FlowerIcon[2] = [ImageLoader LoadImageWithName:@"fl3.png"];
    m_FlowerIcon[3] = [ImageLoader LoadImageWithName:@"fl4.png"];
    m_FlowerIcon[4] = [ImageLoader LoadImageWithName:@"fl5.png"];
    m_FlowerIcon[5] = [ImageLoader LoadImageWithName:@"fl6.png"];
    m_FlowerIcon[6] = [ImageLoader LoadImageWithName:@"fl7.png"];
    m_FlowerIcon[7] = [ImageLoader LoadImageWithName:@"fl8.png"];
}

+(void)InitializeAnimalIconsResource
{
    m_AnimalIcon[0] = [ImageLoader LoadImageWithName:@"al1.png"];
    m_AnimalIcon[1] = [ImageLoader LoadImageWithName:@"al2.png"];
    m_AnimalIcon[2] = [ImageLoader LoadImageWithName:@"al3.png"];
    m_AnimalIcon[3] = [ImageLoader LoadImageWithName:@"al4.png"];
    m_AnimalIcon[4] = [ImageLoader LoadImageWithName:@"al5.png"];
    m_AnimalIcon[5] = [ImageLoader LoadImageWithName:@"al6.png"];
    m_AnimalIcon[6] = [ImageLoader LoadImageWithName:@"al7.png"];
    m_AnimalIcon[7] = [ImageLoader LoadImageWithName:@"al8.png"];
}

+(void)InitializeEasterEggIconsResource
{
    m_EasterEggIcon[0] = [ImageLoader LoadImageWithName:@"eb1.png"];
    m_EasterEggIcon[1] = [ImageLoader LoadImageWithName:@"eb2.png"];
    m_EasterEggIcon[2] = [ImageLoader LoadImageWithName:@"eb3.png"];
    m_EasterEggIcon[3] = [ImageLoader LoadImageWithName:@"eb4.png"];
    m_EasterEggIcon[4] = [ImageLoader LoadImageWithName:@"eb5.png"];
    m_EasterEggIcon[5] = [ImageLoader LoadImageWithName:@"eb6.png"];
    m_EasterEggIcon[6] = [ImageLoader LoadImageWithName:@"eb7.png"];
    m_EasterEggIcon[7] = [ImageLoader LoadImageWithName:@"eb8.png"];
}

+(void)ReleaseFoodIconsResource
{
    for(int i = 0; i < 8; ++i)
    {
        if(m_FooodIcon[i])
            CGImageRelease(m_FooodIcon[i]);
    }
}

+(void)ReleaseFlowerIconsResource
{
    for(int i = 0; i < 8; ++i)
    {
        if(m_FlowerIcon[i])
            CGImageRelease(m_FlowerIcon[i]);
    }
}

+(void)ReleaseAnimalIconsResource
{
    for(int i = 0; i < 8; ++i)
    {
        if(m_AnimalIcon[i])
            CGImageRelease(m_AnimalIcon[i]);
    }
}

+(void)ReleaseEasterEggIconsResource
{
    for(int i = 0; i < 8; ++i)
    {
        if(m_EasterEggIcon[i])
            CGImageRelease(m_EasterEggIcon[i]);
    }
}

+(void)ReleaseAnimal1IconsResource
{
    for(int i = 0; i < 8; ++i)
    {
        if(m_Animal1Icon[i])
            CGImageRelease(m_Animal1Icon[i]);
    }
}

+(void)ReleaseAnimal2IconsResource
{
    for(int i = 0; i < 8; ++i)
    {
        if(m_Animal2Icon[i])
            CGImageRelease(m_Animal2Icon[i]);
    }
}

+(void)ReleaseKuloIconsResource
{
    for(int i = 0; i < 8; ++i)
    {
        if(m_KuloIcon[i])
            CGImageRelease(m_KuloIcon[i]);
    }
}


+(void)DrawFoodIcon:(CGContextRef)context at:(CGRect)rect index:(int)i
{
    if(0 <= i && i < 8)
    {
        CGContextDrawImage(context, rect, m_FooodIcon[i]);
    }
}

+(void)DrawFlowerIcon:(CGContextRef)context at:(CGRect)rect index:(int)i
{
    if(0 <= i && i < 8)
    {
        CGContextDrawImage(context, rect, m_FlowerIcon[i]);
    }
}


+(void)DrawAnimalIcon:(CGContextRef)context at:(CGRect)rect index:(int)i
{
    if(0 <= i && i < 8)
    {
        CGContextDrawImage(context, rect, m_AnimalIcon[i]);
    }
}

+(void)DrawEasterEggIcon:(CGContextRef)context at:(CGRect)rect index:(int)i
{
    if(0 <= i && i < 8)
    {
        CGContextDrawImage(context, rect, m_EasterEggIcon[i]);
    }
}

+(void)DrawAnimal1Icon:(CGContextRef)context at:(CGRect)rect index:(int)i
{
    if(0 <= i && i < 8)
    {
        CGContextDrawImage(context, rect, m_Animal1Icon[i]);
    }
}

+(void)DrawAnimal2Icon:(CGContextRef)context at:(CGRect)rect index:(int)i
{
    if(0 <= i && i < 8)
    {
        CGContextDrawImage(context, rect, m_Animal2Icon[i]);
    }
}

+(void)DrawKuloIcon:(CGContextRef)context at:(CGRect)rect index:(int)i
{
    if(0 <= i && i < 8)
    {
        CGContextDrawImage(context, rect, m_KuloIcon[i]);
    }
}


+(void)InitializeResource
{
    [RenderHelper InitializeAnimal1IconsResource];
    [RenderHelper InitializeAnimal2IconsResource];
    [RenderHelper InitializeKuloIconsResource];
    [RenderHelper InitializeFoodIconsResource];
    [RenderHelper InitializeFlowerIconsResource];
    [RenderHelper InitializeAnimalIconsResource];
    [RenderHelper InitializeEasterEggIconsResource];

    
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
    
    
    m_Spiral = [ImageLoader LoadImageWithName:@"spiralani.png"];
    
    m_LuckSignBackgroundImage = [ImageLoader LoadImageWithName:@"luckicon.png"];
    m_LuckSignBackgroundImage2 = [ImageLoader LoadImageWithName:@"luckicon2.png"];
    m_BetSignBackgroundImage = [ImageLoader LoadImageWithName:@"chipicon.png"];
    m_RedStarImage = [ImageLoader LoadImageWithName:@"redstar.png"];
    //m_RedStarImage = [ImageLoader LoadImageWithName:@"star.png"];
    m_CashImage = [ImageLoader LoadImageWithName:@"cashicon.png"];
    m_CrossImage = [ImageLoader LoadImageWithName:@"cross.png"];
    m_CashOctagonImage = [ImageLoader LoadImageWithName:@"cashocticon.png"]; 
    
    m_CashEarnIconMe = [ImageLoader LoadImageWithName:@"redeem1icon.png"];
    m_CashEarnIconOther = [ImageLoader LoadImageWithName:@"redeem2icon.png"];

    m_DisableCashEarnIconMe = [ImageLoader LoadImageWithName:@"redeem1disableicon.png"];
    m_DisableCashEarnIconOther = [ImageLoader LoadImageWithName:@"redeem2disableicon.png"];
    
    m_OnLineGroupIcon = [ImageLoader LoadImageWithName:@"onlinesign.png"];

    m_EnableSignIcon = [ImageLoader LoadImageWithName:@"gled.png"];
    m_DisableSignIcon = [ImageLoader LoadImageWithName:@"stopsign.png"];
    
    m_GreenQmark = [ImageLoader LoadImageWithName:@"qmarkg.png"];
    m_YellowQmark = [ImageLoader LoadImageWithName:@"qmarky.png"];
    
    
	CGAffineTransform transform;
    CGPatternCallbacks callbacks;
	callbacks.version = 0;
	callbacks.drawPattern = &DrawPatternImage;
	callbacks.releaseInfo = &ReleasePatternImage;
    
	CGImageRef image = [ImageLoader LoadImageWithName:@"redtext.png"];//CreateRedNoiseImage(60);
	
	CGFloat width = CGImageGetWidth(image);
	CGFloat height = CGImageGetHeight(image);
	
	transform = CGAffineTransformIdentity;
    
    
	m_BkgndPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);

    
    size_t num_locations = 3;
    CGFloat locations[3] = {0.0, 0.5, 1.0};
    CGFloat colors[12] = 
    {
        0.1, 0.1, 0.4, 1.0,
        0.8, 0.0, 1.0, 1.0,
        0.1, 0.1, 0.4, 1.0,
    };
    
    m_BlueColorspace = CGColorSpaceCreateDeviceRGB();
    m_BlueGradient = CGGradientCreateWithColorComponents (m_BlueColorspace, colors, locations, num_locations);
    
    size_t num_locations2 = 2;
    CGFloat locations2[2] = {0.0, 1.0};
    CGFloat colors2[8] = 
    {
        0.8, 0.8, 1.0, 1.0,
        0.6, 0.6, 0.9, 0.5,
    };
    
    m_HighLightColorspace = CGColorSpaceCreateDeviceRGB();
    m_HighLightGradient = CGGradientCreateWithColorComponents (m_HighLightColorspace, colors2, locations2, num_locations2);
 
}

+(void)ReleaseResource
{
    [RenderHelper ReleaseFoodIconsResource];
    [RenderHelper ReleaseFlowerIconsResource];
    [RenderHelper ReleaseAnimalIconsResource];
    [RenderHelper ReleaseEasterEggIconsResource];
    [RenderHelper ReleaseAnimal1IconsResource];
    [RenderHelper ReleaseAnimal2IconsResource];
    [RenderHelper ReleaseKuloIconsResource];
    
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
    
    CGImageRelease(m_LuckSignBackgroundImage);
    CGImageRelease(m_LuckSignBackgroundImage2);
    CGImageRelease(m_BetSignBackgroundImage);
    CGImageRelease(m_RedStarImage);
    CGImageRelease(m_CashImage);
    CGImageRelease(m_CrossImage);
    CGImageRelease(m_CashEarnIconMe);
    CGImageRelease(m_CashEarnIconOther);
    
    CGImageRelease(m_DisableCashEarnIconMe);
    CGImageRelease(m_DisableCashEarnIconOther);
    
    CGPatternRelease(m_BkgndPattern);
    
    CGImageRelease(m_OnLineGroupIcon);
    
    CGImageRelease(m_EnableSignIcon);
    CGImageRelease(m_DisableSignIcon);
    
    CGImageRelease(m_GreenQmark);
    CGImageRelease(m_YellowQmark);

    CGImageRelease(m_Spiral);
    
    CGColorSpaceRelease(m_BlueColorspace);
    CGGradientRelease(m_BlueGradient);
    
    CGColorSpaceRelease(m_HighLightColorspace);
    CGGradientRelease(m_HighLightGradient);
  
}

+(void)DrawAvatarIdle:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index withFlag:(BOOL)isMe
{
    CGImageRef image;
    if(isMe)
        image = m_MeIdle[index];
    else    
        image = m_AvatarIdle[index];
    
    CGFloat w = CGImageGetWidth(image)/2.0;
    CGFloat h = CGImageGetHeight(image)/2.0;
    
    CGFloat sx = rect.origin.x + (rect.size.width - w)/2.0;
    CGFloat sy = rect.origin.y + (rect.size.height - h)/2.0;
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
    
    CGFloat w = CGImageGetWidth(image)/2.0;
    CGFloat h = CGImageGetHeight(image)/2.0;
    
    CGFloat sx = rect.origin.x + (rect.size.width - w)/2.0;
    CGFloat sy = rect.origin.y + (rect.size.height - h)/2.0;
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
    
    CGFloat w = CGImageGetWidth(image)/2.0;
    CGFloat h = CGImageGetHeight(image)/2.0;
    
    CGFloat sx = rect.origin.x + (rect.size.width - w)/2.0;
    CGFloat sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect drawRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, drawRect, image);
    
}

+(void)DrawLuckSignBackground:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_LuckSignBackgroundImage);
}

+(void)DrawLuckSignBackground2:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_LuckSignBackgroundImage2);
}


+(void)DrawBetSignBackground:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BetSignBackgroundImage); 
}

+(void)DrawRedStar:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_RedStarImage); 
}

+(void)DrawCashPaper:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CashImage); 
}

+(void)DrawCrossSign:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CrossImage); 
}

+(void)DrawCashOctagon:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CashOctagonImage); 
}

+(void)DrawCashEarnIconMe:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CashEarnIconMe); 
}

+(void)DrawCashEarnIconOther:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_CashEarnIconOther); 
}

+(void)DrawDisableCashEarnIconMe:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DisableCashEarnIconMe); 
    
}

+(void)DrawDisableCashEarnIconOther:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DisableCashEarnIconOther); 
}

+(void)DefaultPatternFill:(CGContextRef)context withAlpha:(CGFloat)fAlpha atRect:(CGRect)rect
{
    CGContextSetFillPattern(context, m_BkgndPattern, &fAlpha);
	CGContextFillRect (context, rect);	
}

+(void)DrawOnLineGroupIcon:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_OnLineGroupIcon);
}

+(void)DrawEnableDisableSign:(CGContextRef)context at:(CGRect)rect sign:(BOOL)bEnable
{
    if(bEnable)
        CGContextDrawImage(context, rect, m_EnableSignIcon);
    else
        CGContextDrawImage(context, rect, m_DisableSignIcon);
}

+(void)DrawGreenQmark:(CGContextRef)context at:(CGRect)rect
{
    CGFloat w = CGImageGetWidth(m_GreenQmark);
    CGFloat h = CGImageGetHeight(m_GreenQmark);
    CGFloat r = w/h;
    CGFloat r2 = rect.size.width/rect.size.height;
    CGRect rt;
    if(r <= r2)
    {
        w = r*rect.size.height;
        rt = CGRectMake(rect.origin.x + (rect.size.width-w)/2.0, rect.origin.y, w, rect.size.height);
    }
    else
    {
        h = rect.size.width/r;
        rt = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height-h)/2.0, rect.size.width, h);
    }
    CGContextDrawImage(context, rt, m_GreenQmark);
}

+(void)DrawYellowQmark:(CGContextRef)context at:(CGRect)rect
{
    CGFloat w = CGImageGetWidth(m_YellowQmark);
    CGFloat h = CGImageGetHeight(m_YellowQmark);
    CGFloat r = w/h;
    CGFloat r2 = rect.size.width/rect.size.height;
    CGRect rt;
    if(r <= r2)
    {
        w = r*rect.size.height;
        rt = CGRectMake(rect.origin.x + (rect.size.width-w)/2.0, rect.origin.y, w, rect.size.height);
    }
    else
    {
        h = rect.size.width/r;
        rt = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height-h)/2.0, rect.size.width, h);
    }
    CGContextDrawImage(context, rt, m_YellowQmark);
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

+(void)DrawOnlinePlayerGesture:(CGContextRef)context withRect:(CGRect)rect withIndex:(int)index
{
    CGImageRef image = m_OnlineGestures[index];
    CGFloat w = CGImageGetWidth(image)/2.0;
    CGFloat h = CGImageGetHeight(image)/2.0;
    
    CGFloat sx = rect.origin.x + (rect.size.width - w)/2.0;
    CGFloat sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect drawRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, drawRect, image);
}

+(void)DrawOnlinePlayeHat:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_OnlineHat);
}

+(void)DrawSpiral:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_Spiral);
}

@end
