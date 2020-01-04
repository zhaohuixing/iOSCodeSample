//
//  GameCenterPostView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "GameCenterPostView.h"
#import "GUIEventLoop.h"
#import "ImageLoader.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "TextCheckboxCell.h"
#import "LabelCell.h"
#import "GroupCell.h"
#import "SwitchCell.h"
#import "SwitchIconCell.h"
#import "ApplicationResource.h"
#import "StringFactory.h"
#import "ListCellData.h"
#import "DualTextCell.h"
#import "ScoreRecord.h"
#import "ButtonCell.h"
#import "GameCenterConstant.h"
#import "GameCenterManager.h"
#import "ScoreRecord.h"
#import "GameScore.h"
#include "GameUtility.h"

@implementation GameCenterPostView


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
		float size = 80;
		if([ApplicationConfigure iPADDevice])
			size = 120;
        
        float roundsize = [GUILayout GetDefaultAlertUIEdge];
        CGRect rect = CGRectMake(roundsize*2.0, roundsize, 250, 30);
		m_Label2012 = [[UILabel alloc] initWithFrame:rect];
		m_Label2012.backgroundColor = [UIColor clearColor];
		[m_Label2012 setTextColor:[UIColor whiteColor]];
		m_Label2012.font = [UIFont fontWithName:@"Georgia" size:16];
        [m_Label2012 setTextAlignment:UITextAlignmentLeft];
        m_Label2012.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label2012.adjustsFontSizeToFitWidth = YES;
		[m_Label2012 setText:[GameCenterManager getCurrentLocalPlayerAlias]];
		[self addSubview:m_Label2012];
		[m_Label2012 release];
        m_bPostSucceded = NO;
        [self IntializeScoreList];
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

-(void)UpdateViewLayout
{
	[super UpdateViewLayout];
	[self setNeedsDisplay];
}	

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(int)GetScoreByPoint:(int)nPoint
{
    int nScore = 0;
    
    GameScore* Scores = [[GameScore alloc] init];
    [Scores LoadScoresFromPreference:NO];
    
 	int nCount = [Scores GetScoreCount];
    if(0 < nCount)
    {
        if(nPoint == 27 || nPoint == 24 || nPoint == 21 || nPoint == 18)
        {
            ScoreRecord* score = [Scores GetScoreRecordByPoint:nPoint];
            if(score != nil)
            {
                return (int)(score.m_nAveHighestScore);
            }
        }
        
        
        int point = 0;
        for(int i = 0; i < nCount; ++i)
        {
			ScoreRecord* score = nil;
			score = [Scores GetScoreRecord:i];
            point = [score GetPoint];
            if(score != nil && (point == 27 || point == 24 || point == 21 || point == 18))
            {
                nScore += score.m_nTotalWinScore;
            }
        }
    }
    
    
    return nScore;
}


-(void)OnCellSelectedEvent:(id)sender
{
    [super OnCellSelectedEvent:sender];
    id<ListCellTemplate> p = sender;
    if(p)
    {
        id<ListCellDataTemplate> data = [p GetCellData];
        if(data)
        {
            if([data GetDataType] == enLISTCELLTYPE_OBJECT)
            {
                ScoreRecord* pScore = [(ListCellDataObject*)data GetData]; 
                if(pScore)
                {    
                    int nPoint = [pScore GetPoint];
                    int nSpeed = [pScore GetSpeed];
                    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
                    if(pGKDelegate)
                    {
                        int nScore = [self GetScoreByPoint:nPoint];
                        [pGKDelegate PostGameCenterScoreByPoint:nScore withPoint:nPoint withSpeed:nSpeed]; //???????????????????????????
                    }
                }    
            }
        }
    }
    
}

-(void)InitializeScore:(ScoreRecord*)score
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
    NSString* szTitle = [StringFactory GetString_ScoreTitleString:score.m_nPoint withSpeed:score.m_nSpeed];
    
    CGRect rect = CGRectMake(0, 0, w, h);
    
    TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
    NSString* szLable = [NSString stringWithFormat:@"%@ (%i)", szTitle, (int)score.m_nAveHighestScore];
    
    [p SetTitle:szLable]; 
    [p SetSelectable:YES];
    ListCellDataObject* pData = [[ListCellDataObject alloc] init];
    pData.m_objData = [score retain];
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];     
}

/*-(void)InitializeAllScoreBoard
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
    
    CGRect rect = CGRectMake(0, 0, w, h);
    
    TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
    NSString* szLable = [StringFactory GetString_N_PointTitle];
    [p SetTitle:szLable]; 
    [p SetSelectable:YES];
    ListCellDataInt* pData = [[ListCellDataInt alloc] init];
    pData.m_nData = -1;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];     
}*/


-(void)IntializeScoreList
{
    GameScore* Scores = [[GameScore alloc] init];
    [Scores LoadScoresFromPreference:NO];
    
 	int nCount = [Scores GetScoreCount];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
			ScoreRecord* score = nil;
            int nPoint = 0;
            int nSpeed = 0;
			score = [Scores GetScoreRecord:i];
            nPoint = [score GetPoint];
            nSpeed = [score GetSpeed];
            if(score != nil && ((nPoint == 27 || nPoint == 24 || nPoint == 21 || nPoint == 18) && (nSpeed == 1 || nSpeed == 2)))
            {
                [self InitializeScore:score];
            }
        }
    }
    
    [Scores release];
    //if(bHasNPoint == YES)
    //    [self InitializeAllScoreBoard]; 
    
    
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)LoadScore
{
    [self RemoveAllCells];
    [self IntializeScoreList];
}

-(void)OnViewClose
{
    [super OnViewClose];
    if(m_bPostSucceded == NO)
        return;
    
    if([self.superview respondsToSelector:@selector(OnGameCenterPostSucceed)])
    {
        [self.superview performSelector:@selector(OnGameCenterPostSucceed)];
    }
}

-(void)OnViewOpen
{
    m_bPostSucceded = NO;
    [m_Label2012 setText:[GameCenterManager getCurrentLocalPlayerAlias]];
	[super OnViewOpen];
    [self LoadScore];
}	

-(void)SetPostResult:(BOOL)bPostSucceeded
{
    m_bPostSucceded = bPostSucceeded;
}

@end
