//
//  RenderHelper.m
//  XXXXXXXXXXXXX
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "ImageLoader.h"
#import "RenderHelper.h"
#import "ApplicationConfigure.h"

static CGPatternRef         m_NightStar1Pattern;
static CGPatternRef         m_NightStar2Pattern;
static CGPatternRef         m_FlyingCowPattern;
static CGColorSpaceRef      m_PatternSpace;
static CGImageRef           m_MoonImage;
static CGColorRef           m_MoonShadowClrs;

static CGPatternRef         m_GroudPattern;
static CGImageRef           m_GrassImage;
static CGImageRef           m_HatImage;


static CGImageRef           m_DogWalkImage1;
static CGImageRef           m_DogWalkImage2;
static CGImageRef           m_DogWalkImage3;
static CGImageRef           m_DogWalkImage4;
static CGImageRef           m_DogStopImage;

static CGImageRef           m_DogShootImage1;
static CGImageRef           m_DogShootImage2;
static CGImageRef           m_DogShootImage3;
static CGImageRef           m_DogStopShootImage;

static CGImageRef           m_DogJumpImage1;
static CGImageRef           m_DogJumpImage2;

static CGImageRef           m_DogJumpShootImage1;
static CGImageRef           m_DogJumpShootImage2;
static CGImageRef           m_DogDeath;

static CGImageRef   g_PlayerBulletImage = NULL;
static CGImageRef   g_TargetBulletImage = NULL;
static CGImageRef   g_RockImage1 = NULL;
static CGImageRef   g_RockImage2 = NULL;
static CGImageRef   g_SnailImage = NULL;

static CGImageRef           m_Cloud1Image;
static CGImageRef           m_Cloud2Image;
static CGImageRef           m_RainCloud1Image;
static CGImageRef           m_RainCloud2Image;
static CGImageRef           m_BlastImage;

static CGImageRef           m_BirdFlyImage1;
static CGImageRef           m_BirdFlyImage2;
static CGImageRef           m_BirdShootImage1;
static CGImageRef           m_BirdShootImage2;
static CGImageRef           m_BirdBubbleImage;

static CGImageRef           m_MouthNormal;
static CGImageRef           m_MouthBreath1;
static CGImageRef           m_MouthBreath2;
static CGImageRef           m_MouthBreath3;


@implementation RenderHelper


+(void)InitializeResource
{
    CGAffineTransform transform;
    CGPatternCallbacks callbacks;
	callbacks.version = 0;
	callbacks.drawPattern = &DrawPatternImage;
	callbacks.releaseInfo = &ReleasePatternImage;
	CGImageRef image = [ImageLoader LoadImageWithName:@"star.png"];
	
	float width = CGImageGetWidth(image);
	float height = CGImageGetHeight(image);
	
	transform = CGAffineTransformIdentity;
    
    
	m_NightStar1Pattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);

    
	image = [ImageLoader LoadImageWithName:@"star2.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
	m_NightStar2Pattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    float size = 80;
    if([ApplicationConfigure iPADDevice])
        size = 120;
	m_FlyingCowPattern = [ImageLoader CreateImageFillPattern:@"iTunesArtwork.png" withWidth:size withHeight:size isFlipped:YES];

    
	image = [ImageLoader LoadImageWithName:@"mudtex.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
	m_GroudPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    m_PatternSpace = CGColorSpaceCreatePattern(NULL);
    m_MoonImage = [ImageLoader LoadImageWithName:@"moon.png"]; 

	float clrvals[] = {0.9, 0.9, 0.9, 1.0f};
	m_MoonShadowClrs = CGColorCreate(m_PatternSpace, clrvals);
    
    m_GrassImage = [ImageLoader LoadImageWithName:@"grasstex.png"];
    m_HatImage = [ImageLoader LoadImageWithName:@"hat.png"];
    
    m_DogStopImage = [ImageLoader LoadImageWithName:@"dogwalk0.png"];
    m_DogWalkImage1 = [ImageLoader LoadImageWithName:@"dogwalk1.png"];
    m_DogWalkImage2 = [ImageLoader LoadImageWithName:@"dogwalk2.png"];
    m_DogWalkImage3 = [ImageLoader LoadImageWithName:@"dogwalk3.png"];
    m_DogWalkImage4 = [ImageLoader LoadImageWithName:@"dogwalk4.png"];    
    
    m_DogShootImage1 = [ImageLoader LoadImageWithName:@"dogshoot2.png"];
    m_DogShootImage2 = [ImageLoader LoadImageWithName:@"dogshoot3.png"];
    m_DogShootImage3 = [ImageLoader LoadImageWithName:@"dogshoot4.png"];
    m_DogStopShootImage = [ImageLoader LoadImageWithName:@"dogshoot1.png"];
    
    m_DogJumpImage1 = [ImageLoader LoadImageWithName:@"dogjum1.png"];
    m_DogJumpImage2 = [ImageLoader LoadImageWithName:@"dogjum2.png"];
    m_DogJumpShootImage1 = [ImageLoader LoadImageWithName:@"dogjumpshoot1.png"];
    m_DogJumpShootImage2 = [ImageLoader LoadImageWithName:@"dogjumpshoot2.png"];
    
    m_DogDeath = [ImageLoader LoadImageWithName:@"dogdeath"];
    
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"air.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	g_PlayerBulletImage  = CGImageRetain(orgImagge.CGImage);
	
	NSString *imagePath2 = [[NSBundle mainBundle] pathForResource:@"pooop.png" ofType:nil];
	UIImage* orgImagge2 = [UIImage imageWithContentsOfFile:imagePath2];
	g_TargetBulletImage  = CGImageRetain(orgImagge2.CGImage);
    
	NSString *imagePath5 = [[NSBundle mainBundle] pathForResource:@"rock1.png" ofType:nil];
	UIImage* orgImagge5 = [UIImage imageWithContentsOfFile:imagePath5];
	g_RockImage1  = CGImageRetain(orgImagge5.CGImage);
    
	NSString *imagePath6 = [[NSBundle mainBundle] pathForResource:@"rock2.png" ofType:nil];
	UIImage* orgImagge6 = [UIImage imageWithContentsOfFile:imagePath6];
	g_RockImage2  = CGImageRetain(orgImagge6.CGImage);
	
	NSString *imagePath7 = [[NSBundle mainBundle] pathForResource:@"snail.png" ofType:nil];
	UIImage* orgImagge7 = [UIImage imageWithContentsOfFile:imagePath7];
	g_SnailImage  = CGImageRetain(orgImagge7.CGImage);
    
    
    m_Cloud1Image = [ImageLoader LoadCloudImage1];
    m_Cloud2Image = [ImageLoader LoadCloudImage2];
    m_RainCloud1Image = [ImageLoader LoadRainImage1];
    m_RainCloud2Image = [ImageLoader LoadRainImage2];
    m_BlastImage = [ImageLoader LoadImageWithName:@"blast.png"];

    m_BirdFlyImage1 = [ImageLoader LoadImageWithName:@"birdfly1.png"];
    m_BirdFlyImage2 = [ImageLoader LoadImageWithName:@"birdfly2.png"];
    m_BirdShootImage1 = [ImageLoader LoadImageWithName:@"birdshoot1.png"];
    m_BirdShootImage2 = [ImageLoader LoadImageWithName:@"birdshoot2.png"];
    m_BirdBubbleImage = [ImageLoader LoadImageWithName:@"birdbubble.png"];
    
    m_MouthNormal = [ImageLoader LoadImageWithName:@"mouth1.png"];
    m_MouthBreath1 = [ImageLoader LoadImageWithName:@"mouth2.png"];
    m_MouthBreath2 = [ImageLoader LoadImageWithName:@"mouth3.png"];
    m_MouthBreath3 = [ImageLoader LoadImageWithName:@"mouth4.png"];    
}

+(void)ReleaseResource
{
    CGPatternRelease(m_GroudPattern);
    CGPatternRelease(m_NightStar1Pattern);
    CGPatternRelease(m_NightStar2Pattern);
    CGPatternRelease(m_FlyingCowPattern);
    CGColorSpaceRelease(m_PatternSpace);
    CGImageRelease(m_MoonImage);
	CGColorRelease(m_MoonShadowClrs);
    CGImageRelease(m_GrassImage);
    CGImageRelease(m_HatImage);

    CGImageRelease(m_DogStopImage);
    CGImageRelease(m_DogWalkImage1);
    CGImageRelease(m_DogWalkImage2);
    CGImageRelease(m_DogWalkImage3);
    CGImageRelease(m_DogWalkImage4);   
    
    CGImageRelease(m_DogShootImage1); 
    CGImageRelease(m_DogShootImage2); 
    CGImageRelease(m_DogShootImage3); 
    CGImageRelease(m_DogStopShootImage);     
    
    CGImageRelease(m_DogJumpImage1);
    CGImageRelease(m_DogJumpImage2);
    CGImageRelease(m_DogJumpShootImage1);
    CGImageRelease(m_DogJumpShootImage2);
    CGImageRelease(m_DogDeath);
    
	if(g_PlayerBulletImage != NULL)
		CGImageRelease(g_PlayerBulletImage);
	
	if(g_TargetBulletImage != NULL)
		CGImageRelease(g_TargetBulletImage);
	
	if(g_RockImage1 != NULL)
		CGImageRelease(g_RockImage1);
	
	if(g_RockImage2 != NULL)
		CGImageRelease(g_RockImage2);
    
	if(g_SnailImage != NULL)
		CGImageRelease(g_SnailImage);
    
    CGImageRelease(m_Cloud1Image);
    CGImageRelease(m_Cloud2Image);
    CGImageRelease(m_RainCloud1Image);
    CGImageRelease(m_RainCloud2Image);
    CGImageRelease(m_BlastImage);
    
    CGImageRelease(m_BirdFlyImage1);
    CGImageRelease(m_BirdFlyImage2);
    CGImageRelease(m_BirdShootImage1);
    CGImageRelease(m_BirdShootImage2);
    CGImageRelease(m_BirdBubbleImage);
    
    CGImageRelease(m_MouthNormal);
    CGImageRelease(m_MouthBreath1);
    CGImageRelease(m_MouthBreath2);
    CGImageRelease(m_MouthBreath3);    
}

+(void)DrawStartPattern1Fill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, m_PatternSpace);
    CGContextSetFillPattern(context, m_NightStar1Pattern, &fAlpha);
	CGContextFillRect (context, rect);	
	CGContextRestoreGState(context);
}

+(void)DrawStartPattern2Fill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, m_PatternSpace);
    CGContextSetFillPattern(context, m_NightStar2Pattern, &fAlpha);
	CGContextFillRect (context, rect);	
	CGContextRestoreGState(context);
}

+(void)DrawMoon:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextSaveGState(context);
	CGSize shadowSize = CGSizeMake(3, 0);
	CGContextSetShadowWithColor(context, shadowSize, 3, m_MoonShadowClrs);
	CGContextDrawImage(context, rect, m_MoonImage);
	CGContextRestoreGState(context);
}

+(void)DrawGroundMud:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, m_PatternSpace);
    float fAlpha = 1.0;
    CGContextSetFillPattern(context, m_GroudPattern, &fAlpha);
	CGContextFillRect (context, rect);	
	CGContextRestoreGState(context);
}

+(void)DrawGrassUnit:(CGContextRef)context atRect:(CGRect)rect
{
	CGContextDrawImage(context, rect, m_GrassImage);
}

+(void)DrawHat:(CGContextRef)context atRect:(CGRect)rect
{
	CGContextDrawImage(context, rect, m_HatImage);
}

+(void)DrawDogStand:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogStopImage);
}

+(void)DrawDogWalk1:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogWalkImage1);
}
+(void)DrawDogWalk2:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogWalkImage2);
}

+(void)DrawDogWalk3:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogWalkImage3);
}

+(void)DrawDogWalk4:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogWalkImage4);
}

+(void)DrawDogWalk:(CGContextRef)context withIndex:(int)nAniStep atRect:(CGRect)rect
{
    switch(nAniStep)
    {
        case 1:
            [RenderHelper DrawDogWalk1:context atRect:rect];
            break;
        case 2:
            [RenderHelper DrawDogWalk2:context atRect:rect];
            break;
        case 3:
            [RenderHelper DrawDogWalk3:context atRect:rect];
            break;
        case 4:
            [RenderHelper DrawDogWalk4:context atRect:rect];
            break;
        default:
            [RenderHelper DrawDogStand:context atRect:rect];
            break;
    }
}

+(void)DrawDogStopShoot:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogStopShootImage);
}

+(void)DrawDogShoot1:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogShootImage1);
}

+(void)DrawDogShoot2:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogShootImage2);
}

+(void)DrawDogShoot3:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogShootImage3);
}

+(void)DrawDogShoot:(CGContextRef)context withIndex:(int)nAniStep atRect:(CGRect)rect
{
    switch(nAniStep)
    {
        case 1:
            [RenderHelper DrawDogShoot1:context atRect:rect];
            break;
        case 2:
            [RenderHelper DrawDogShoot2:context atRect:rect];
            break;
        case 3:
            [RenderHelper DrawDogShoot3:context atRect:rect];
            break;
        default:
            [RenderHelper DrawDogStopShoot:context atRect:rect];
            break;
    }
}


+(void)DrawDogJump1:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogJumpImage1);
}

+(void)DrawDogJump2:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogJumpImage2);
}

+(void)DrawDogJump:(CGContextRef)context withIndex:(int)nAniStep atRect:(CGRect)rect
{
    switch(nAniStep)
    {
        case 0:
        case 1:
            [RenderHelper DrawDogJump1:context atRect:rect];
            break;
        case 2:
        case 3:
        case 4:
            [RenderHelper DrawDogJump2:context atRect:rect];
            break;
        default:
            [RenderHelper DrawDogStand:context atRect:rect];
            break;
    }
}

+(void)DrawDogJumpShoot1:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogJumpShootImage1);
}

+(void)DrawDogJumpShoot2:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogJumpShootImage2);
}

+(void)DrawDogJumpShoot:(CGContextRef)context withIndex:(int)nAniStep atRect:(CGRect)rect
{
    switch(nAniStep)
    {
        case 0:
        case 1:
            [RenderHelper DrawDogJumpShoot1:context atRect:rect];
            break;
        case 2:
        case 3:
        case 4:
            [RenderHelper DrawDogJumpShoot2:context atRect:rect];
            break;
        default:
            [RenderHelper DrawDogStand:context atRect:rect];
            break;
    }
}

+(void)DrawDogDeath:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_DogDeath);
}

+ (void)DrawAirBubble:(CGContextRef)context atRect:(CGRect)rect
{
	CGContextDrawImage(context, rect, g_PlayerBulletImage);
}

+ (void)DrawPoop:(CGContextRef)context atRect:(CGRect)rect
{
	CGContextDrawImage(context, rect, g_TargetBulletImage);
}

+(void)DrawRock1:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, g_RockImage1);
}

+(void)DrawSnail:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, g_SnailImage);
}

+(void)DrawRock2:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, g_RockImage2);
}

#define CLOUD1_XY_RATIO         0.66
+(void)DrawCloud1:(CGContextRef)context atRect:(CGRect)rect
{
    float w, h;
    float rs = rect.size.height/rect.size.width;
    if(CLOUD1_XY_RATIO < rs)
    {
        w = rect.size.width;
        h = w * CLOUD1_XY_RATIO;
    }
    else 
    {
        h = rect.size.height;
        w = h/CLOUD1_XY_RATIO;
    }
    float sx = rect.origin.x + (rect.size.width - w)/2.0;
    float sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect rt = CGRectMake(sx, sy, w, h); 
    
    CGContextDrawImage(context, rt, m_Cloud1Image);
}

#define CLOUD2_XY_RATIO         0.7

+(void)DrawCloud2:(CGContextRef)context atRect:(CGRect)rect
{
    float w, h;
    float rs = rect.size.height/rect.size.width;
    if(CLOUD2_XY_RATIO < rs)
    {
        w = rect.size.width;
        h = w * CLOUD2_XY_RATIO;
    }
    else 
    {
        h = rect.size.height;
        w = h/CLOUD2_XY_RATIO;
    }
    float sx = rect.origin.x + (rect.size.width - w)/2.0;
    float sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect rt = CGRectMake(sx, sy, w, h); 
    
    CGContextDrawImage(context, rt, m_Cloud2Image);
}

+(void)DrawRainCloud1:(CGContextRef)context atRect:(CGRect)rect
{
/*    float w, h;
    w = rect.size.width <= rect.size.height ? rect.size.width : rect.size.height;
    h = w;
    float sx = rect.origin.x + (rect.size.width - w)/2.0;
    float sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect rt = CGRectMake(sx, sy, w, h); 
    CGContextDrawImage(context, rt, m_RainCloud1Image);*/
    CGContextDrawImage(context, rect, m_RainCloud1Image);
}

+(void)DrawRainCloud2:(CGContextRef)context atRect:(CGRect)rect
{
    /*float w, h;
    w = rect.size.width <= rect.size.height ? rect.size.width : rect.size.height;
    h = w;
    float sx = rect.origin.x + (rect.size.width - w)/2.0;
    float sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect rt = CGRectMake(sx, sy, w, h); 
    CGContextDrawImage(context, rt, m_RainCloud2Image);*/
    CGContextDrawImage(context, rect, m_RainCloud2Image);
}

#define BLAST_YX_RATIO         0.75
+(void)DrawBlast:(CGContextRef)context atRect:(CGRect)rect
{
    float w, h;
    float rs = rect.size.height/rect.size.width;
    if(BLAST_YX_RATIO < rs)
    {
        w = rect.size.width;
        h = w * BLAST_YX_RATIO;
    }
    else 
    {
        h = rect.size.height;
        w = h/BLAST_YX_RATIO;
    }
    float sx = rect.origin.x + (rect.size.width - w)/2.0;
    float sy = rect.origin.y + (rect.size.height - h)/2.0;
    CGRect rt = CGRectMake(sx, sy, w, h); 
    
    CGContextDrawImage(context, rt, m_BlastImage);
}

+(void)DrawBirdFly1:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BirdFlyImage1);
}

+(void)DrawBirdFly2:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BirdFlyImage2);    
}

+(void)DrawBirdShoot1:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BirdShootImage1);
}

+(void)DrawBirdShoot2:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BirdShootImage2);
}

+(void)DrawBirdBubble:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BirdBubbleImage);
}

+(void)DrawFlyingCowIconPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, m_PatternSpace);
    CGContextSetFillPattern(context, m_FlyingCowPattern, &fAlpha);
	CGContextFillRect (context, rect);	
	CGContextRestoreGState(context);
}

+(void)DrawMouthNormal:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_MouthNormal);
}

+(void)DrawMouthBeath1:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_MouthBreath1);
}

+(void)DrawMouthBeath2:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_MouthBreath2);
}

+(void)DrawMouthBeath3:(CGContextRef)context atRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_MouthBreath3);
}


@end
