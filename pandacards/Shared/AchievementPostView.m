//
//  AchievementPostView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-04-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "AchievementPostView.h"
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
#import "GameAchievementHelper.h"
#import "ScoreRecord.h"
#import "GameScore.h"
#include "GameUtility.h"

@implementation AchievementPostView


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
        
        CGRect rect = CGRectMake(0, 0, 250, 30);
		m_Label2012 = [[UILabel alloc] initWithFrame:rect];
		m_Label2012.backgroundColor = [UIColor clearColor];
		[m_Label2012 setTextColor:[UIColor redColor]];
		m_Label2012.font = [UIFont fontWithName:@"Georgia" size:16];
        [m_Label2012 setTextAlignment:UITextAlignmentLeft];
        m_Label2012.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label2012.adjustsFontSizeToFitWidth = YES;
		[m_Label2012 setText:[GameCenterManager getCurrentLocalPlayerAlias]];
		[self addSubview:m_Label2012];
		[m_Label2012 release];
        
		m_Pattern = [ImageLoader CreateImageFillPattern:@"iTunesArtwork.png" withWidth:size withHeight:size isFlipped:YES];
        
        
        [self IntializeScoreList];
    }
    return self;
}

- (void)dealloc 
{
	CGPatternRelease(m_Pattern);
    [super dealloc];
}

-(void)UpdateViewLayout
{
	[super UpdateViewLayout];
	[self setNeedsDisplay];
}	

- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreatePattern(NULL);
	CGContextSetFillColorSpace(context, colorSpace);
    CGColorSpaceRelease(colorSpace);
    
	CGFloat fAlpha = [ImageLoader GetDefaultViewFillAlpha];
    CGContextSetFillPattern(context, m_Pattern, &fAlpha);
	CGContextFillRect (context, rect);	
	
	CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(float)GetAchievementByPoint:(int)nPoint
{
    float fRet = 0;
    
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
                fRet = [GameAchievementHelper GetPointAchievementPercent:nPoint withScore:score.m_nTotalWinScore];
                return fRet;
            }
        }
        
        int nScore = 0;
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
        fRet = [GameAchievementHelper GetPointAchievementPercent:-1 withScore:nScore];
    }
    
    
    return fRet;
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
            if([data GetDataType] == enLISTCELLDATA_INT)
            {
                int nPoint = [(ListCellDataInt*)data GetData];
                id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
                if(pGKDelegate)
                {
                    float fRet = [self GetAchievementByPoint:nPoint];
                    [pGKDelegate PostAchievementByPoint:fRet withPoint:nPoint];
                }
            }
        }
    }
}

-(void)InitializeScore:(ScoreRecord*)score
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	NSString* szTitle = [StringFactory GetString_PointTitle:score.m_nPoint];
    
    CGRect rect = CGRectMake(0, 0, w, h);
    
    TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
    NSString* szLable = [NSString stringWithFormat:@"%@ (%i)", szTitle, (int)score.m_nTotalWinScore];
    [p SetTitle:szLable]; 
    [p SetSelectable:YES];
    ListCellDataInt* pData = [[ListCellDataInt alloc] init];
    pData.m_nData = score.m_nPoint;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];     
}

-(void)InitializeAllScoreBoard
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
}

-(void)IntializeScoreList
{
    GameScore* Scores = [[GameScore alloc] init];
    [Scores LoadScoresFromPreference:NO];
    
 	int nCount = [Scores GetScoreCount];
    BOOL bHasNPoint = NO;
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
			ScoreRecord* score = nil;
            int nPoint = 0;
			score = [Scores GetScoreRecord:i];
            nPoint = [score GetPoint];
            if(score != nil && (nPoint == 27 || nPoint == 24 || nPoint == 21 || nPoint == 18))
            {
                [self InitializeScore:score];
            }
            else if(score != nil)
            {
                bHasNPoint = YES;
            }
        }
    }
    
    [Scores release];
    if(bHasNPoint == YES)
        [self InitializeAllScoreBoard]; 
    
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)LoadScore
{
    [self RemoveAllCells];
    [self IntializeScoreList];
}
-(void)OnViewOpen
{
    [m_Label2012 setText:[GameCenterManager getCurrentLocalPlayerAlias]];
	[super OnViewOpen];
    [self LoadScore];
}	

@end
