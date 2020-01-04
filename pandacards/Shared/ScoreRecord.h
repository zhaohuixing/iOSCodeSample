//
//  ScoreRecord.h
//  MindFire
//
//  Created by Zhaohui Xing on 10-05-04.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScoreRecord : NSObject 
{
	//Play Point
	int			m_nPoint;
    int         m_nSpeed;
	
	//Play speed setting
	int			m_nPlaySpeed;
	
	//Entire histroy record
	double		m_nLastScore;
	double		m_nAveHighestScore;
	double		m_nAveAveScore;
	int			m_nAvePlayCount;
    int         m_nTotalWinScore; 

	//The date when got highest score
	int		m_nYear4Highest;
	int		m_nMonth4Highest;
	int		m_nDay4Highest;
}

@property int			m_nPoint;
@property int			m_nSpeed;
@property double		m_nLastScore;
@property double		m_nAveHighestScore;
@property double		m_nAveAveScore;
@property int			m_nAvePlayCount;
@property int			m_nYear4Highest;
@property int			m_nMonth4Highest;
@property int			m_nDay4Highest;
@property int           m_nTotalWinScore; 

-(id)initRecord:(int)nPoint withSpeed:(int)nSpeed;
-(int)GetPoint; 
-(int)GetSpeed; 
-(void)AddScore:(double)dScore;
-(void)SaveScore:(NSUserDefaults*)prefs scoreIndex:(int)index;
-(void)LoadScore:(NSUserDefaults*)prefs scoreIndex:(int)index;

@end
