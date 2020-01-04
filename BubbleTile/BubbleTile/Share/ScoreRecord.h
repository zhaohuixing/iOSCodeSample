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
	//Game Type
	int			m_nGameType;
	
    //Grid Type
	int			m_nGridType;
    
	//Grid Layout
	int			m_nGridlayout;
	
	//Grid edge
    int         m_nEdge;
    
    //The record of least step to win the game
	int			m_nLeastRecord;
    
    //Total win count
    int         m_nTotalWinCount; 

	//The date when got least score
	int		m_nYear4Least;
	int		m_nMonth4Least;
	int		m_nDay4Least;
    
    //Difficulty level
    int     m_nLevel;
}

@property int			m_nGameType;
@property int			m_nGridType;
@property int			m_nGridlayout;
@property int           m_nEdge;
@property int           m_nLeastRecord;
@property int			m_nTotalWinCount;
@property int			m_nYear4Least;
@property int			m_nMonth4Least;
@property int			m_nDay4Least;
@property int           m_nLevel;    

-(id)init;
-(id)initRecord:(int)nGridType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType;
-(void)AddScore:(int)nStep;
-(void)SaveScore:(NSUserDefaults*)prefs scoreIndex:(int)index;
-(void)LoadScore:(NSUserDefaults*)prefs scoreIndex:(int)index;
-(BOOL)IsSame:(int)nGridType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType;
@end
