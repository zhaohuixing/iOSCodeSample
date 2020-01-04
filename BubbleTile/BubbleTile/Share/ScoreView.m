//
//  ScoreView.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-17.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "ApplicationConfigure.h"
#import "ImageLoader.h"
#import "ScoreView.h"
#import "GameScore.h"
#import "GUILayout.h"
#import "LabelCell.h"
#import "GroupCell.h"
#import "ApplicationResource.h"
#import "ListCellData.h"
#import "DualTextCell.h"
#import "StringFactory.h"
#import "GameConstants.h"
#import "GameConfiguration.h"
#import "GameLayout.h"
#import "CPuzzleGrid.h"
#import "RenderHelper.h"

@implementation ScoreView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
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

/*- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
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

-(void)OnViewOpen
{
    [self InitializeScoreList];
    [super OnViewOpen];
}	

-(void)InitializeScore:(ScoreRecord*)score
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	float lh = [GameLayout GetDefaultScoreLabelHeight];
    
	NSString* szTitle = @"";
	
    CGRect rect = CGRectMake(0, 0, w, h);
    BOOL bEasy = (score.m_nLevel == 0);
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    CGImageRef srcIMage = [CPuzzleGrid GetDefaultLayoutImage:(enGridType)score.m_nGridType withLayout:(enGridLayout)score.m_nGridlayout withSize:3 withLevel:bEasy withBubble:(enBubbleType)[GameConfiguration GetBubbleType]];
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    //??????????????????????????????
    
    GroupCell* pCell = [[GroupCell alloc] initWithLabelImage:srcIMage withFrame:rect withLabelHeight:lh];
    szTitle = [NSString stringWithFormat:@"%i", score.m_nEdge];
    [pCell SetTitle:szTitle]; 

    DualTextCell* p1 = [[DualTextCell alloc] initWithFrame:rect];
    NSString* szTime = [NSString stringWithFormat:@"(%i-%i-%i)", score.m_nYear4Least, score.m_nMonth4Least, score.m_nDay4Least];
    NSString* sTitle = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_LeastStepLabel], szTime];
    [p1 SetTitle:sTitle]; 
    [p1 SetText:[NSString stringWithFormat:@"%i", score.m_nLeastRecord]]; 
    if([ApplicationConfigure iPADDevice])
        [p1 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [pCell AddCell:p1];
    
    DualTextCell* p2 = [[DualTextCell alloc] initWithFrame:rect];
    [p2 SetTitle:[StringFactory GetString_WinCountLabel]]; 
    [p2 SetText:[NSString stringWithFormat:@"%i", score.m_nTotalWinCount]]; 
    if([ApplicationConfigure iPADDevice])
        [p2 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [pCell AddCell:p2];
    
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];

}

-(void)InitializeScoreList
{
    [self RemoveAllCells];

    
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
    
    CGRect rect = CGRectMake(0, 0, w, h);
    int nScore = [GameScore GetEasyGameScore];    
    DualTextCell* p1 = [[DualTextCell alloc] initWithFrame:rect];
    NSString* sTitle = [NSString stringWithFormat:@"%@", [StringFactory GetString_Easy]];
    [p1 SetTitle:sTitle]; 
    [p1 SetText:[NSString stringWithFormat:@"%i", nScore]]; 
    if([ApplicationConfigure iPADDevice])
        [p1 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [self AddCell:p1];
    [p1 release];
    
    nScore = [GameScore GetDifficultGameScore];    
    DualTextCell* p2 = [[DualTextCell alloc] initWithFrame:rect];
    NSString* sTitle2 = [NSString stringWithFormat:@"%@", [StringFactory GetString_Difficult]];
    [p2 SetTitle:sTitle2]; 
    [p2 SetText:[NSString stringWithFormat:@"%i", nScore]]; 
    if([ApplicationConfigure iPADDevice])
        [p2 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [self AddCell:p2];
    [p2 release];
    
    nScore = [GameScore GetTotalGameScore];    
    DualTextCell* p3 = [[DualTextCell alloc] initWithFrame:rect];
    NSString* sTitle3 = [NSString stringWithFormat:@"%@", [StringFactory GetString_Score]];
    [p3 SetTitle:sTitle3]; 
    [p3 SetText:[NSString stringWithFormat:@"%i", nScore]]; 
    if([ApplicationConfigure iPADDevice])
        [p3 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [self AddCell:p3];
    [p3 release];
    
    
    for(int nType = (int)PUZZLE_GRID_TRIANDLE; nType <= (int)PUZZLE_GRID_HEXAGON; ++nType)
    {
        for(int nLayout = (int)PUZZLE_LALOUT_MATRIX; nLayout <= PUZZLE_LALOUT_SPIRAL; ++nLayout)
        {
            int nMin = [GameConfiguration GetMinBubbleUnit:(enGridType)nType];
            int nMax = [GameConfiguration GetMaxBubbleUnit:(enGridType)nType];
            for(int nEdge = nMin; nEdge <= nMax; ++nEdge)
            {
                for (int nLevel = 0; nLevel <= 1; ++nLevel) 
                {
                    for(int nGame = 0; nGame < (int)GAME_TRADITION_SLIDE; ++nGame)
                    {    
                        ScoreRecord* pScore = [GameScore GetScore:nType withLayout:nLayout withEdge:nEdge withLevel:nLevel withGameType:nGame];
                        if(pScore != nil)
                        {
                            [self InitializeScore:pScore];
                        }
                    }    
                }    
            }
        }
    }
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	

}


@end
