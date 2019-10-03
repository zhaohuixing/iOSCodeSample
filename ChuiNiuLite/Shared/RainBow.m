//
//  RainBow.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-25.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "RainBow.h"
#import "Configuration.h"
#import "ImageLoader.h"
#import "RenderHelper.h"

@implementation RainBow

- (id)init 
{
    if ((self = [super init])) 
	{
        // Initialization code
		m_Alien = [[[AlienData alloc] init] retain];
		m_Image = [ImageLoader LoadRainBowImage];
		m_nTimerElaspe = [CGameLayout GetRainBowTimerStep];
		m_nTimerStep = 0;
		//float fImgW = CGImageGetWidth(m_Image);
		//float fImgH = CGImageGetHeight(m_Image);
		//float fRealW = getRainBowWidth();
		//float fR = fImgH/fImgW;
		//float fRealH = fR*fRealW;
		
		float w = [CGameLayout GetRainBowWidth];
		float h = w*GAME_SCENCE_WIN_SIGN_CENTER_Y_RATIO;
		[self setSize:CGSizeMake(w, h)];
		
		//[self setSize:CGSizeMake(fRealW, fRealH)];
		[self setToStartPosition];
        m_nBirdStep = 0;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc 
{
	CGImageRelease(m_Image);
	[m_Alien release];
    [super dealloc];
}

-(void)setToStartPosition
{
	CGSize size = [self getSize];
	float fSW = [CGameLayout GetGameSceneWidth];//getGameSceneWidth();
	float fSH = [CGameLayout GetGameSceneHeight];//getGameSceneHeight();
	int nTH = (int)(2.0*[CGameLayout GetDogHeight]);//getTargetHeight());
	int nR = getRandNumber();
	float y = (float)(nR%nTH);
	
	CGPoint pt = CGPointMake((fSW+size.width)/(-2.0), fSH-(y+size.height/2.0));
	[self moveTo:pt];
}

-(void)reset
{
    m_nBirdStep = 0;
	m_nTimerElaspe = [CGameLayout GetRainBowTimerStep];
	m_nTimerStep = 0;
	[m_Alien reset];
	[self setToStartPosition];
}

-(void)startMotion
{
	[self setToStartPosition];
	CGPoint p = CGPointMake([CGameLayout GetRainBowSpeed], 0);
	[self setSpeed:p];
	[m_Alien startMotion];
}

-(void)stopAtWin
{
	[m_Alien blast];
}

-(BOOL)isMotion
{
	BOOL bRet = [m_Alien isMotion];
	
	return bRet;
}

-(BOOL)isWin
{
	BOOL bRet = [m_Alien isBlast];
	
	return bRet;
}	

//GameBaseData handle function
-(void)moveTo:(CGPoint)pt
{
	[m_Alien moveTo:pt];
}

-(CGPoint)getPosition
{
	CGPoint pt = [m_Alien getPosition];
	return pt;
}

-(CGSize)getSize
{
	CGSize size = [m_Alien getSize];
	return size;
}

-(void)setSize:(CGSize)size
{
	[m_Alien setSize:size];
}

-(CGRect)getBound
{
	CGRect rect = [m_Alien getBound];
	return rect;
}

-(void)setSpeed:(CGPoint)pt
{
	[m_Alien setSpeed:pt];
}

-(CGPoint)getSpeed
{
	CGPoint p = [m_Alien getSpeed];
	return p;
}	

//Location and size in screen view coordinate
-(CGSize)getSizeInView
{
	CGSize size = [m_Alien getSizeInView];
	return size;
}	

//Base on game view coordinate system
-(CGRect)getBoundInView
{
	CGRect rect = [m_Alien getBoundInView];
	return rect;
}

-(CGPoint)getPositionInView
{
	CGPoint pt = [m_Alien getPositionInView];
	return pt;
}	


-(BOOL)onTimerEvent
{
	BOOL bRet = NO;
	
	++m_nTimerStep;
	if(m_nTimerElaspe <= m_nTimerStep)
	{
		m_nTimerStep = 0;
		CGPoint speed = [self getSpeed];
		CGPoint pt = [self getPosition];
		pt.x += speed.x;
		[self moveTo:pt];
		bRet = YES;
	}
    m_nBirdStep = (m_nBirdStep+1)%4;

	
	return bRet;
}

#define BIRD_WIDTH_HEIGHT_RATIO         0.6
-(void)drawBird:(CGContextRef)context atRect:(CGRect)rt withIndex:(int)index
{
    if(index == 0)
        [RenderHelper DrawBirdFly1:context atRect:rt];
    else if(index == 1)
        [RenderHelper DrawBirdFly2:context atRect:rt];
    else if(index == 2)
        [RenderHelper DrawBirdShoot1:context atRect:rt];
    else 
        [RenderHelper DrawBirdShoot2:context atRect:rt];
}



-(void)drawNormal:(CGContextRef)context inRect:(CGRect)rect
{
	CGRect rt = [self getBoundInView];
	CGContextDrawImage(context, rt, m_Image);
    float sx = rt.origin.x;
    float w = rt.size.width/4.0;
    float h = w*BIRD_WIDTH_HEIGHT_RATIO;
    float sy = rt.origin.y + (rt.size.height-h)/2.0;
    CGRect rt2 = CGRectMake(sx, sy, w, h);
    [self drawBird:context atRect:rt2 withIndex:m_nBirdStep];
    sx = rt.origin.x+rt.size.width-w;
    rt2 = CGRectMake(sx, sy, w, h);
    [self drawBird:context atRect:rt2 withIndex:(m_nBirdStep+1)%4];
}	

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
	[self drawNormal:context inRect:rect];
}	

-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect
{
	float x = 0.0;
	float y = [CGameLayout GetGameSceneWiningCenterY];//getGameSceneWiningCenterY();
	float w = [CGameLayout GetRainBowWidth];
	float h = w*GAME_SCENCE_WIN_SIGN_CENTER_Y_RATIO;
	
	x = [CGameLayout GameSceneToDeviceX:x];
	y = [CGameLayout GameSceneToDeviceY:y];
	w = [CGameLayout ObjectMeasureToDevice:w];
	h = [CGameLayout ObjectMeasureToDevice:h];
	
	CGRect rt = CGRectMake(x-w*0.5, y-h*0.5, w, h);
	CGContextDrawImage(context, rt, m_Image);

    float sx = rt.origin.x;
    w = rt.size.width/4.0;
    h = w*BIRD_WIDTH_HEIGHT_RATIO;
    float sy = rt.origin.y + (rt.size.height-h)/2.0;
    CGRect rt2 = CGRectMake(sx, sy, w, h);
    [self drawBird:context atRect:rt2 withIndex:3];
    sx = rt.origin.x+rt.size.width-w;
    rt2 = CGRectMake(sx, sy, w, h);
    [self drawBird:context atRect:rt2 withIndex:3];
}

@end
