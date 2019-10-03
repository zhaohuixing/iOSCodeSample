//
//  CPointer.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "GameUtiltyObjects.h"
#import "CPointer.h"
#include "drawhelper.h"
#import "ApplicationConfigure.h"

@implementation CPointer

@synthesize 					m_nFastStep;
@synthesize                     m_fFastUnit;
@synthesize 					m_fMediumStep;
@synthesize 					m_nMediumCount;
@synthesize 					m_nSlowCycleStep;
@synthesize 					m_fSlowStep;
@synthesize 					m_nVibrationCount;
@synthesize 					m_nVibrationStep;
@synthesize 					m_nPosition;
@synthesize                     m_nPointerState;

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_Painter = [[CPinRender alloc] init];
        m_nPosition = 0;
    }
    return self;
}

-(void)dealloc
{
}

-(void)DrawAnimationFast:(CGContextRef)context withSize:(CGSize)size
{
    float cx = size.width/2.0;
    float cy = size.height/2.0;
    float w = [CPinRender GetPointerImageWidth];
    float h = [CPinRender GetPointerImageLength];
    float sx = (size.width-w)*0.5;
    float sy = size.height*0.5-h;
    CGRect rt = CGRectMake(sx, sy, w,h);

    //????
    CGContextSetAlpha(context, 0.3);
	
    int nRand = GetRandNumber();
	if(nRand < 0)
		nRand *= -1;
	
	nRand = nRand%360+1;
	float fStep = m_fFastUnit*((float)m_nFastStep);
	int nCount = GAME_POINTER_FAST_ANGLE_MAXCOUNT - ((int)fStep);  
	int angle;		
	nCount /= 3;  
//	if([ApplicationConfigure iPADDevice])
//        nCount /= 2;
    
	for(int i = 0; i < nCount; ++i)
	{	
		CGContextTranslateCTM(context, cx, cy);
        
		angle = nRand+i*360/nCount;
		angle = angle%360;
		if(m_bClockwise == 0)
			angle = 360-angle;
		
		CGContextRotateCTM(context, angle*M_PI/180.0f);
		
		CGContextTranslateCTM(context, -cx, -cy);
        [m_Painter DrawPointer:context at:rt];
	}

}

-(void)DrawAnimationMedium:(CGContextRef)context withSize:(CGSize)size
{
    float cx = size.width/2.0;
    float cy = size.height/2.0;
    float w = [CPinRender GetPointerImageWidth];
    float h = [CPinRender GetPointerImageLength];
    float sx = (size.width-w)*0.5;
    float sy = size.height*0.5-h;
    CGRect rt = CGRectMake(sx, sy, w,h);
	
    float angle = m_fMediumStep;
	if(m_bClockwise == NO)
		angle = 360-angle;
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, angle*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
    [m_Painter DrawPointer:context at:rt];
}

-(void)DrawAnimationSlow:(CGContextRef)context withSize:(CGSize)size
{
    float cx = size.width/2.0;
    float cy = size.height/2.0;
    float w = [CPinRender GetPointerImageWidth];
    float h = [CPinRender GetPointerImageLength];
    float sx = (size.width-w)*0.5;
    float sy = size.height*0.5-h;
    CGRect rt = CGRectMake(sx, sy, w,h);

	float angle = m_fSlowStep;
	if(m_bClockwise == NO)
		angle = 360-angle;
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, angle*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
    [m_Painter DrawPointer:context at:rt];
}

-(void)DrawAnimationVibration:(CGContextRef)context withSize:(CGSize)size
{
    float cx = size.width/2.0;
    float cy = size.height/2.0;
    float w = [CPinRender GetPointerImageWidth];
    float h = [CPinRender GetPointerImageLength];
    float sx = (size.width-w)*0.5;
    float sy = size.height*0.5-h;
    CGRect rt = CGRectMake(sx, sy, w,h);
    
	int nStep;
	nStep = m_nVibrationStep;
	
	int angle = (m_nPosition+nStep)%360;
	
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, angle*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
    [m_Painter DrawPointer:context at:rt];
}

-(void)DrawPointerAnimation:(CGContextRef)context withSize:(CGSize)size
{
	if(m_nPointerState == GAME_POINTER_SPIN_FAST)
	{
		[self DrawAnimationFast:context withSize:size];
	}
	else if(m_nPointerState == GAME_POINTER_SPIN_MEDIUM)
	{
		[self DrawAnimationMedium:context withSize:size];
	}
	else if(m_nPointerState == GAME_POINTER_SPIN_SLOW)
	{	
		[self DrawAnimationSlow:context withSize:size];
	}
	else
	{
		[self DrawAnimationVibration:context withSize:size];
	}
    
}

-(void)DrawPointerResult:(CGContextRef)context withSize:(CGSize)size
{
    float cx = size.width/2.0;
    float cy = size.height/2.0;
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, m_nPosition*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
    float w = [CPinRender GetPointerImageWidth];
    float h = [CPinRender GetPointerImageLength];
    float sx = (size.width-w)*0.5;
    float sy = size.height*0.5-h;
    CGRect rt = CGRectMake(sx, sy, w,h);
    [m_Painter DrawPointer:context at:rt];
}

-(void)DrawPointerStatic:(CGContextRef)context withSize:(CGSize)size
{
    float w = [CPinRender GetPointerImageWidth];
    float h = [CPinRender GetPointerImageLength];
    float sx = (size.width-w)*0.5;
    float sy = size.height*0.5-h;
    CGRect rt = CGRectMake(sx, sy, w,h);
    [m_Painter DrawPointer:context at:rt];
}

-(void)DrawPointerInLayer:(CGContextRef)context withSize:(CGSize)size
{
	CGContextSaveGState(context);
	if(m_Delegate)
    {    
        int nState = [m_Delegate GetGameState];
    
        if(nState == GAME_STATE_RUN)
            [self DrawPointerAnimation:context withSize:size];
        else if(nState == GAME_STATE_RESULT)
            [self DrawPointerResult:context withSize:size];
        else
            [self DrawPointerStatic:context withSize:size];
	}
	CGContextRestoreGState(context);
    
}


-(void)DrawPointer:(CGContextRef)context withSize:(CGSize)size
{
    float fSize = 2.0*[CPinRender GetPointerImageLength]*[ApplicationConfigure GetCurrentDisplayScale];
    CGSize drawSize = CGSizeMake(fSize, fSize);
   
	CGContextRef layerDC;
	CGLayerRef   layerObj;
	
    layerObj = CGLayerCreateWithContext(context, drawSize, NULL);
	layerDC = CGLayerGetContext(layerObj);
    
    [self DrawPointerInLayer:layerDC withSize:drawSize];
    
    float sx = (size.width - fSize)/2.0;
    float sy = (size.height - fSize)/2.0;
    CGRect drawRect = CGRectMake(sx, sy, fSize, fSize);
    CGContextDrawLayerInRect(context, drawRect, layerObj);    
	CGLayerRelease(layerObj);
}


- (void)OnFastStateTimerEvent
{
	++m_nFastStep;
	if(m_nFastCycle <= m_nFastStep)
	{
		m_nPointerState = GAME_POINTER_SPIN_MEDIUM;
		m_fMediumStep = 0;
		m_nMediumCount = 0;
	}
}

- (void)OnMediumStateTimerEvent
{
	float fStep = ((float)GAME_POINTER_MEDIUM_ANGLE_UNIT)/((float)m_nMediumCycle);
	float fAngle = (((float)(m_nMediumCycle)) - ((float)(m_nMediumCount)))*fStep;
	
	m_fMediumStep += fAngle;   
	if(360 <= m_fMediumStep)
	{
		++m_nMediumCount;
		m_fMediumStep -= 360;
	}
	
	if(m_nMediumCycle <= m_nMediumCount)
	{
		m_nPointerState = GAME_POINTER_SPIN_SLOW;
		m_nSlowCycleStep = 0;
		m_fSlowStep = m_fMediumStep;
	}	
}

- (void)OnSlowStateTimerEvent
{
	m_fSlowStep += GAME_POINTER_RUN_ANGLE_STEP;
	if((m_nSlowCycle-1) <= m_nSlowCycleStep)
	{
		float fAngle;
		float fAngleThreshold;
		BOOL bFinished = NO;
		if(m_bClockwise == YES)
		{	
			fAngle = m_fSlowStep;
			fAngleThreshold = m_nSlowAngle;
			if(fAngleThreshold <= fAngle)
				bFinished = YES;
		}				
		else
		{				
			fAngle = 360-m_fSlowStep;
			fAngleThreshold = 360-m_nSlowAngle; 
			if(fAngle <= fAngleThreshold)
				bFinished = YES;
		}				
		
		
		if(bFinished == YES)
		{
			m_nPosition = fAngleThreshold; 
			if(0 < m_nVibCycle)
			{	
				m_nPointerState = GAME_POINTER_SPIN_VIBRATION;
				m_nVibrationCount = 0;
				m_nVibrationStep = 0;
				return;
			}
			else
			{
                if(m_Delegate)
                {    
                    [m_Delegate PointerStopAt:m_nPosition];
                    [m_Delegate SetGameState:GAME_STATE_RESULT];
                }    
				return;
			}
		}
	}
	else if(360 <= m_fSlowStep)
	{
		++m_nSlowCycleStep;
		m_fSlowStep -= 360;
	}
    
}

- (void)OnVibrationStateTimerEvent
{
	if(m_nVibCycle <= 0)
	{
        if(m_Delegate)
        {    
            [m_Delegate PointerStopAt:m_nPosition];
            [m_Delegate SetGameState:GAME_STATE_RESULT];
        }    
		return;
	}
	
	int dir = m_nVibrationCount%2;
	if(dir == 0)
	{	
		++m_nVibrationStep;
	}			
	else
	{	
		--m_nVibrationStep;
	}			
	if(m_nVibCycle == 0 && m_nVibrationStep == 0)
	{
        if(m_Delegate)
        {    
            [m_Delegate PointerStopAt:m_nPosition];
            [m_Delegate SetGameState:GAME_STATE_RESULT];
        }    
		return;
	}
	
	int nAngle = m_nVibCycle*GAME_POINTER_VIBRATION_ANGLE_UNIT;
	if(nAngle <= abs(m_nVibrationStep))
	{
		++m_nVibrationCount;
	}
	
	
	if(m_nVibrationStep == 0)
	{
		--m_nVibCycle;
	}
}

- (void)OnRunningTimerEvent
{
	if(m_nPointerState == GAME_POINTER_SPIN_FAST)
	{
		[self OnFastStateTimerEvent];
	}
	else if(m_nPointerState == GAME_POINTER_SPIN_MEDIUM)
	{
		[self OnMediumStateTimerEvent];
	}
	else if(m_nPointerState == GAME_POINTER_SPIN_SLOW)
	{	
		[self OnSlowStateTimerEvent];
	}
	else
	{
		[self OnVibrationStateTimerEvent];
	}
}	


-(void)OnTimerEvent
{
    if(m_Delegate && [m_Delegate GetGameState] == GAME_STATE_RUN)
    {
        [self OnRunningTimerEvent];
    }
}

- (void)Reset
{
    m_nFastCycle = 0;
    m_nMediumCycle = 0;
    m_nSlowCycle = 0;
    m_nSlowAngle = 0;
    m_nVibCycle = 0;
    m_bClockwise = NO;
    
    m_nFastStep = 0;
    m_fFastUnit = 0;
    m_fMediumStep = 0;
    m_nMediumCount = 0;
    m_nSlowCycleStep = 0;
    m_fSlowStep = 0;
    m_nVibrationCount = 0;
    m_nVibrationStep = 0;
    m_nPosition = 0;
}

- (void)StartSpin:(CPinActionLevel*)action
{
    m_nFastCycle = action.m_nFastCycle;
    m_nMediumCycle = action.m_nMediumCycle;
    m_nSlowCycle = action.m_nSlowCycle;
    m_nSlowAngle = action.m_nSlowAngle;
    m_nVibCycle = action.m_nVibCycle;
    m_bClockwise = action.m_bClockwise;
    
    m_nFastStep = 0;
    m_fFastUnit = 0;
    m_fMediumStep = 0;
    m_nMediumCount = 0;
    m_nSlowCycleStep = 0;
    m_fSlowStep = 0;
    m_nVibrationCount = 0;
    m_nVibrationStep = 0;
    m_nPosition = 0;
    m_nPointerState = GAME_POINTER_SPIN_FAST;
   
	if(0 < m_nFastCycle)
	{
		m_fFastUnit = GAME_POINTER_FAST_ANGLE_UNIT/((float)m_nFastCycle);
	}
	
	if(m_nFastCycle == 0 && m_nMediumCycle != 0)
	{
		m_nPointerState = GAME_POINTER_SPIN_MEDIUM;
	}
	else if(m_nFastCycle == 0 && m_nMediumCycle == 0 && m_nSlowCycle != 0)
	{
		m_nPointerState = GAME_POINTER_SPIN_SLOW;
	}
	else if(m_nFastCycle == 0 && m_nMediumCycle == 0 && m_nSlowCycle == 0)
	{
		[self Reset];
		return;
	}
    
    if(m_Delegate)
    {    
        [m_Delegate SetGameState:GAME_STATE_RUN];
    }    
}

@end
