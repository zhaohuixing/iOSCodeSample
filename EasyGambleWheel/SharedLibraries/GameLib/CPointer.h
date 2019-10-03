//
//  CPointer.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPinRender.h"
#import "GameBaseObject.h"

@class CPinActionLevel;

@interface CPointer : GameBaseObject
{
@private
    CPinRender*         m_Painter;

    int                 m_nFastCycle;
    int                 m_nMediumCycle;
    int                 m_nSlowCycle;
    int                 m_nSlowAngle;
    int                 m_nVibCycle;
    BOOL                m_bClockwise;

@public    
    //Annimation timing parameters
	//Fast speed
    int					m_nFastStep;
	float				m_fFastUnit;
	
    //Medium speed
	float				m_fMediumStep;
	int					m_nMediumCount;
	
    //Slow speed
	int                 m_nSlowCycleStep;
	float				m_fSlowStep;
	
    //Vibration
	int					m_nVibrationCount;
	int					m_nVibrationStep;
	
    //Result position
	int					m_nPosition;
    

    int                 m_nPointerState;
}

@property (nonatomic)int					m_nFastStep;
@property (nonatomic)float                  m_fFastUnit;
@property (nonatomic)float					m_fMediumStep;
@property (nonatomic)int					m_nMediumCount;
@property (nonatomic)int					m_nSlowCycleStep;
@property (nonatomic)float					m_fSlowStep;
@property (nonatomic)int					m_nVibrationCount;
@property (nonatomic)int					m_nVibrationStep;
@property (nonatomic)int					m_nPosition;
@property (nonatomic)int					m_nPointerState;

- (void)OnTimerEvent;
- (void)DrawPointer:(CGContextRef)context withSize:(CGSize)size;
- (void)StartSpin:(CPinActionLevel*)action;
- (void)Reset;
@end
