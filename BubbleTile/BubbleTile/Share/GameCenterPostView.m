//
//  GameCenterPostView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
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
#import "GameCenterPostDelegate.h"
#import "ScoreRecord.h"
#import "GameScore.h"
#import "GameConstants.h"
#import "GameConfiguration.h"
#import "GameLayout.h"
#import "CPuzzleGrid.h"
#import "RenderHelper.h"

@implementation GameCenterPostView


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
        
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

/*
- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
    float fAlpha = 1.0;
    [RenderHelper DefaultPatternFill:context withAlpha:fAlpha atRect:rect];
	CGContextRestoreGState(context);
}*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(int)GetAllScoreInGridType:(enGridType)nType
{
    int nRet = 0;
    for(int nLayout = (int)PUZZLE_LALOUT_MATRIX; nLayout <= PUZZLE_LALOUT_SPIRAL; ++nLayout)
    {
        int nMin = [GameConfiguration GetMinBubbleUnit:(enGridType)nType];
        int nMax = [GameConfiguration GetMaxBubbleUnit:(enGridType)nType];
        for(int nEdge = nMin; nEdge <= nMax; ++nEdge)
        {
            ScoreRecord* pScore = [GameScore GetScore:nType withLayout:nLayout withEdge:nEdge withLevel:1 withGameType:GAME_BUBBLE_TILE];
            if(pScore != nil)
            {
                nRet += pScore.m_nTotalWinCount;
            }
        }
    }
    return nRet;
}

-(int)GetAllScoreIn3SquareDifficulty
{
    int nRet = 0;
    for(int nLayout = (int)PUZZLE_LALOUT_MATRIX; nLayout <= PUZZLE_LALOUT_SPIRAL; ++nLayout)
    {
        int nMin = [GameConfiguration GetMinBubbleUnit:PUZZLE_GRID_SQUARE];
        int nMax = [GameConfiguration GetMaxBubbleUnit:PUZZLE_GRID_SQUARE];
        for(int nEdge = nMin; nEdge <= nMax; ++nEdge)
        {
            ScoreRecord* pScore = [GameScore GetScore:PUZZLE_GRID_SQUARE withLayout:nLayout withEdge:nEdge withLevel:1 withGameType:GAME_BUBBLE_TILE];
            if(pScore != nil)
            {
                nRet += pScore.m_nTotalWinCount;
            }
        }
    }    
    return nRet;
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
                int nIndex = [(ListCellDataInt*)data GetData];
                id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
                if(pGKDelegate)
                {
                    int nScore = 0;
                    int nBoardIndex = _SQUARE3_DIFFICULT_GAME_INDEX_;
                    if(nIndex == PUZZLE_GRID_SQUARE)
                    {
                        nScore = [self GetAllScoreIn3SquareDifficulty];
                        [pGKDelegate PostGameCenterScore:nScore withBoard:nBoardIndex];    
                    }  
                    else if(nIndex == PUZZLE_GRID_SQUARE+1)
                    {
                        nScore = [GameScore GetEasyGameScore];
                        nBoardIndex =_TOTAL_EASY_GAMESCORE_INDEX_;
                        [pGKDelegate PostGameCenterScore:nScore withBoard:nBoardIndex];    
                    }
                    else if(nIndex == PUZZLE_GRID_SQUARE+2)
                    {
                        nScore = [GameScore GetDifficultGameScore];
                        nBoardIndex = _TOTAL_DIFFICULT_GAMESCORE_INDEX_;
                        [pGKDelegate PostGameCenterScore:nScore withBoard:nBoardIndex];    
                    }
                    else if(nIndex == PUZZLE_GRID_SQUARE+3)
                    {
                        nScore = [GameScore GetTotalGameScore];
                        nBoardIndex = _TOTAL_GAMESCORE_INDEX_;
                        [pGKDelegate PostGameCenterScore:nScore withBoard:nBoardIndex];    
                    }
                }
            }
        }
    }
    
}

-(void)InitializeGridScore:(enGridType)nType
{
    int nWinCount = [self GetAllScoreInGridType:nType];
    
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	float lh = [GameLayout GetDefaultScoreLabelHeight];
    
    CGRect rect = CGRectMake(0, 0, w, h);
    int nMin = [GameConfiguration GetMinBubbleUnit:(enGridType)nType];
    enBubbleType bubbleType = [GameConfiguration GetBubbleType]; 
    if(nType == PUZZLE_GRID_DIAMOND)
        nMin = 2;
    CGImageRef srcIMage = [CPuzzleGrid GetDefaultGridImage:nType withSize:nMin withBubble:bubbleType];
    GroupCell* pCell = [[GroupCell alloc] initWithLabelImage:srcIMage withFrame:rect withLabelHeight:lh];
    [pCell SetTitle:@""];//[StringFactory GetString_GridTypeString:nType]];
    
    TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
    NSString* szLable = [NSString stringWithFormat:@"%i", nWinCount];
    [p SetTitle:szLable]; 
    [p SetSelectable:YES];
    ListCellDataInt* pData = [[ListCellDataInt alloc] init];
    pData.m_nData = (int)nType;
    p.m_Data = pData;
    [pData release];
    [pCell AddCell:p];
    
    [pCell SetSelectable:YES];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeSquare3GridScore
{
    int nWinCount = [self GetAllScoreIn3SquareDifficulty];
    
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	float lh = [GameLayout GetDefaultScoreLabelHeight];
    
    CGRect rect = CGRectMake(0, 0, w, h);
    enBubbleType bubbleType = [GameConfiguration GetBubbleType]; 
    CGImageRef srcIMage = [CPuzzleGrid GetDefaultGridImage:PUZZLE_GRID_SQUARE withSize:3 withBubble:bubbleType];
    GroupCell* pCell = [[GroupCell alloc] initWithLabelImage:srcIMage withFrame:rect withLabelHeight:lh];
    [pCell SetTitle:[StringFactory GetString_Difficult]];//[StringFactory GetString_GridTypeString:nType]];
    
    TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
    NSString* szLable = [NSString stringWithFormat:@"%i", nWinCount];
    [p SetTitle:szLable]; 
    [p SetSelectable:YES];
    ListCellDataInt* pData = [[ListCellDataInt alloc] init];
    pData.m_nData = (int)PUZZLE_GRID_SQUARE;
    p.m_Data = pData;
    [pData release];
    [pCell AddCell:p];
    
    [pCell SetSelectable:YES];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeTotalScores
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
    
    CGRect rect = CGRectMake(0, 0, w, h);
    int nScore = [GameScore GetEasyGameScore];    
    TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
    NSString* szLable = [NSString stringWithFormat:@"%@: %i", [StringFactory GetString_Easy], nScore];
    [p SetTitle:szLable]; 
    [p SetSelectable:YES];
    ListCellDataInt* pData = [[ListCellDataInt alloc] init];
    pData.m_nData = (int)PUZZLE_GRID_SQUARE+1;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];

    nScore = [GameScore GetDifficultGameScore];    
    TextCheckboxCell* p2 = [[TextCheckboxCell alloc] initWithFrame:rect];
    NSString* szLable2 = [NSString stringWithFormat:@"%@: %i", [StringFactory GetString_Difficult], nScore];
    [p2 SetTitle:szLable2]; 
    [p2 SetSelectable:YES];
    ListCellDataInt* pData2 = [[ListCellDataInt alloc] init];
    pData2.m_nData = (int)PUZZLE_GRID_SQUARE+2;
    p2.m_Data = pData2;
    [pData2 release];
    [self AddCell:p2];
    [p2 release];

    nScore = [GameScore GetTotalGameScore];    
    TextCheckboxCell* p3 = [[TextCheckboxCell alloc] initWithFrame:rect];
    NSString* szLable3 = [NSString stringWithFormat:@"%@: %i", [StringFactory GetString_Score], nScore];
    [p3 SetTitle:szLable3]; 
    [p3 SetSelectable:YES];
    ListCellDataInt* pData3 = [[ListCellDataInt alloc] init];
    pData3.m_nData = (int)PUZZLE_GRID_SQUARE+3;
    p3.m_Data = pData3;
    [pData3 release];
    [self AddCell:p3];
    [p3 release];
    
}

-(void)IntializeScoreList
{
    //??????
    //for(int nType = (int)PUZZLE_GRID_TRIANDLE; nType <= (int)PUZZLE_GRID_HEXAGON; ++nType)
    //{
    //    [self InitializeGridScore:nType];
    //}
    //[self InitializeGridScore:PUZZLE_GRID_SQUARE];
    [self InitializeTotalScores];
    [self InitializeSquare3GridScore];
    
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
	[super OnViewOpen];
    [self LoadScore];
}	

@end
