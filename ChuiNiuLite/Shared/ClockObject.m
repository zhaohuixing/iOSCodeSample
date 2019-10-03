//
//  ClockObject.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-23.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "ClockObject.h"
#import "ImageLoader.h"
#import "Configuration.h"
#import "StringFactory.h"
#import "DrawHelper2.h"
#import "ScoreRecord.h"

@implementation ClockObject

-(id)init
{
	if(self = [super init])
	{	
		m_fRadius = [CGameLayout GetClockRadius];//getClockRadius();
		//m_Image = [ImageLoader CreatClockBackGround:2*m_fRadius];
		m_nTimerStep = 0;
		m_nGameTimeLength = [Configuration getGameTime];
		[self loadLabel];
	}
	
	return self;
}

-(void)loadLabel
{
	if(m_Label != NULL)
	{
		CGImageRelease(m_Label);
	}	
	int nSkill = [Configuration getGameSkill];
	int nLevel = [Configuration getGameLevel];
	NSString* szSkill = [StringFactory GetString_SkillStringAbv:nSkill];
	NSString* szLevel = [StringFactory GetString_LevelStringAbv:nLevel];
	m_szLabel =  [NSString stringWithFormat:@"%@, %@", szSkill, szLevel];
	//m_Label = [ImageLoader CreateTextImage:m_szLabel];
}	

-(void)reset
{
	[self loadLabel];
	m_nTimerStep = 0;
	m_nGameTimeLength = [Configuration getGameTime];
}

-(BOOL)onTimerEvent
{
	BOOL bRet = NO;
	
	if(isGamePlayPlaying() == 1)
	{
		++m_nTimerStep;
		if(m_nTimerStep%GAME_TIMER_DEFAULT_CLOCK_UPDATE == 0)
		{
			bRet = YES;
		}	
	}	
	
	return bRet;
}

-(void)dealloc
{
	//CGImageRelease(m_Image);
	[super dealloc];
}	


-(void)drawClock:(CGContextRef)context inRect:(CGRect)rect
{
	float fRealR = [CGameLayout ObjectMeasureToDevice:m_fRadius]*2.0; //getSceneSizeinView(m_fRadius)*2;
	CGRect rt = CGRectMake(rect.origin.x+[CGameLayout GetGameClientDeviceWidth]-fRealR-2, rect.origin.y+2, fRealR, fRealR);
	//CGRect rt = CGRectMake(rect.origin.x+2, rect.origin.y+2, fRealR, fRealR);
	//CGContextDrawImage(context, rt, m_Image);

	if(0 <= m_nTimerStep)
	{	
		float mx = rt.origin.x+rt.size.width/2.0f;
		float my = rt.origin.y+rt.size.height/2.0f;
		//CGPoint center = CGPointMake(mx, my);
		//float r = 0.385f*fRealR;
	    float fAngle = ((float)m_nTimerStep)/((float)m_nGameTimeLength);
	
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, mx, my);
        CGContextRotateCTM(context, fAngle*M_PI*2.0);
        CGContextTranslateCTM(context, -mx, -my);
        //rt = CGRectMake(mx-r, my-r, 2*r, 2*r);
        [DrawHelper2 DrawCowHead:context at:rt];
        CGContextRestoreGState(context);
        
/*		float clrStart[3] = {1.0, 1.0, 1.0};
		float clrEnd[3] = {1.0, 0.0, 0.0};
		CGFunctionRef colorFunction = CreateSadingFunctionWithColors(clrStart, clrEnd);
		CGColorSpaceRef clrSpace = CGColorSpaceCreateDeviceRGB();
		CGShadingRef shading = CGShadingCreateRadial(clrSpace, center, r/4.0, center, r, colorFunction, TRUE, TRUE);
		CGFunctionRelease(colorFunction);
	    float fAngle = 360.0*((float)m_nTimerStep)/((float)m_nGameTimeLength);
	
		CGContextSaveGState(context);
		
		CGContextTranslateCTM(context, center.x, center.y);
		CGContextMoveToPoint(context, 0, 0);
		CGContextAddArc(context, 0, 0, r, (-90.0f)*M_PI/180.0f, (fAngle-90.0f)*M_PI/180.0f, 0); 
		CGContextClip(context);
		CGContextDrawShading(context,shading);
		CGShadingRelease(shading);
		CGContextClosePath(context);
		CGContextRestoreGState(context);*/
	}
	int nSkill = [Configuration getGameSkill];
	int nLevel = [Configuration getGameLevel];
	NSString* szSkill = [StringFactory GetString_SkillStringAbv:nSkill];
	NSString* szLevel = [StringFactory GetString_LevelStringAbv:nLevel];
	NSString* szLabel =  [NSString stringWithFormat:@"%@, %@", szSkill, szLevel];
	if(szLabel)
	{
		float fFontSize = [CGameLayout ObjectMeasureToDevice:28];
		float fCharspce = 0;
		const char *pText = [szLabel UTF8String];
		int nLength = strlen(pText);
		CGContextSaveGState(context);
		CGContextSetRGBStrokeColor(context, 1, 0.2, 0.1, 1);
		CGContextSetRGBFillColor(context, 1, 0, 0, 1);
		CGContextSelectFont(context, "Arial",  fFontSize, kCGEncodingMacRoman);
		//CGContextSelectFont(context, "Zapfino",  fFontSize, kCGEncodingMacRoman);
		CGContextSetCharacterSpacing(context, fCharspce);
		CGContextSetTextDrawingMode(context, kCGTextFillStroke);
		CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
		CGContextSetTextMatrix(context, xform);
		CGContextShowTextAtPoint(context, rt.origin.x, rt.origin.y+rt.size.height+fFontSize, pText, nLength);
        int nScore = [ScoreRecord getTotalWinScore];
        szLabel =  [NSString stringWithFormat:@"%i", nScore];
		pText = [szLabel UTF8String];
		nLength = strlen(pText);
		CGContextSetRGBStrokeColor(context, 0.3, 1, 0.3, 1);
		CGContextSetRGBFillColor(context, 0, 1, 0, 1);
		CGContextShowTextAtPoint(context, rt.origin.x, rt.origin.y+rt.size.height+2.0*fFontSize, pText, nLength);
        
		CGContextRestoreGState(context);	
	}	

}	

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
	[self drawClock:context inRect:rect];
}	

@end
