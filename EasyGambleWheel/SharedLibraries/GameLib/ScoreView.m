//
//  ScoreView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "ScoreView.h"
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
#import "RenderHelper.h"

@implementation ScoreView


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
        self.backgroundColor = [UIColor redColor];
        [self IntializeScoreList];
    }
    return self;
}

- (void)dealloc 
{
    
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

-(void)InitializeMe
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    NSString* szLabel = [StringFactory GetString_OfflineMySelfID];
    [pCell SetTitle:szLabel]; 
    DualTextCell* p1 = [[DualTextCell alloc] initWithResource:@"meidleicon1.png" withFrame:rect];
    [p1 SetTitle:[StringFactory GetString_Chips]];
    int nChip = [ScoreRecord GetMyChipBalance];
    [p1 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p1];

    DualTextCell* p2 = [[DualTextCell alloc] initWithResource:@"meidleicon1.png" withFrame:rect];
    int nYear = [ScoreRecord GetMyMostWinYear];
    int nMonth = [ScoreRecord GetMyMostWinMonth];
    int nDay = [ScoreRecord GetMyMostWinDay];
    NSString* szMostWinLabel = [NSString stringWithFormat:@"%@ (%i-%i-%i)", [StringFactory GetString_BiggestWin], nYear, nMonth, nDay];
    [p2 SetTitle:szMostWinLabel];
    nChip = [ScoreRecord GetMyMostWinChips];
    [p2 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p2 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p2];

    DualTextCell* p3 = [[DualTextCell alloc] initWithResource:@"meidleicon1.png" withFrame:rect];
    [p3 SetTitle:[StringFactory GetString_LatestPlay]];
    nChip = [ScoreRecord GetMyLastPlayResult];
    [p3 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p3 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p3];
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
}

-(void)InitializePlayer1
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    NSString* szLabel = [StringFactory GetString_OfflinePlayer1ID];
    [pCell SetTitle:szLabel]; 
    DualTextCell* p1 = [[DualTextCell alloc] initWithResource:@"ropaidleicon1.png" withFrame:rect];
    [p1 SetTitle:[StringFactory GetString_Chips]];
    int nChip = [ScoreRecord GetPlayer1ChipBalance];
    [p1 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p1];
    
    DualTextCell* p2 = [[DualTextCell alloc] initWithResource:@"ropaidleicon1.png" withFrame:rect];
    int nYear = [ScoreRecord GetPlayer1MostWinYear];
    int nMonth = [ScoreRecord GetPlayer1MostWinMonth];
    int nDay = [ScoreRecord GetPlayer1MostWinDay];
    NSString* szMostWinLabel = [NSString stringWithFormat:@"%@ (%i-%i-%i)", [StringFactory GetString_BiggestWin], nYear, nMonth, nDay];
    [p2 SetTitle:szMostWinLabel];
    nChip = [ScoreRecord GetPlayer1MostWinChips];
    [p2 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p2 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p2];
    
    DualTextCell* p3 = [[DualTextCell alloc] initWithResource:@"ropaidleicon1.png" withFrame:rect];
    [p3 SetTitle:[StringFactory GetString_LatestPlay]];
    nChip = [ScoreRecord GetPlayer1LastPlayResult];
    [p3 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p3 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p3];
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
}

-(void)InitializePlayer2
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    NSString* szLabel = [StringFactory GetString_OfflinePlayer2ID];
    [pCell SetTitle:szLabel]; 
    DualTextCell* p1 = [[DualTextCell alloc] initWithResource:@"ropaidleicon1.png" withFrame:rect];
    [p1 SetTitle:[StringFactory GetString_Chips]];
    int nChip = [ScoreRecord GetPlayer2ChipBalance];
    [p1 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p1];
    
    DualTextCell* p2 = [[DualTextCell alloc] initWithResource:@"ropaidleicon1.png" withFrame:rect];
    int nYear = [ScoreRecord GetPlayer2MostWinYear];
    int nMonth = [ScoreRecord GetPlayer2MostWinMonth];
    int nDay = [ScoreRecord GetPlayer2MostWinDay];
    NSString* szMostWinLabel = [NSString stringWithFormat:@"%@ (%i-%i-%i)", [StringFactory GetString_BiggestWin], nYear, nMonth, nDay];
    [p2 SetTitle:szMostWinLabel];
    nChip = [ScoreRecord GetPlayer2MostWinChips];
    [p2 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p2 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p2];
    
    DualTextCell* p3 = [[DualTextCell alloc] initWithResource:@"ropaidleicon1.png" withFrame:rect];
    [p3 SetTitle:[StringFactory GetString_LatestPlay]];
    nChip = [ScoreRecord GetPlayer2LastPlayResult];
    [p3 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p3 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p3];
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
}

-(void)InitializePlayer3
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    NSString* szLabel = [StringFactory GetString_OfflinePlayer3ID];
    [pCell SetTitle:szLabel]; 
    DualTextCell* p1 = [[DualTextCell alloc] initWithResource:@"ropaidleicon1.png" withFrame:rect];
    [p1 SetTitle:[StringFactory GetString_Chips]];
    int nChip = [ScoreRecord GetPlayer3ChipBalance];
    [p1 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p1];
    
    DualTextCell* p2 = [[DualTextCell alloc] initWithResource:@"ropaidleicon1.png" withFrame:rect];
    int nYear = [ScoreRecord GetPlayer3MostWinYear];
    int nMonth = [ScoreRecord GetPlayer3MostWinMonth];
    int nDay = [ScoreRecord GetPlayer3MostWinDay];
    NSString* szMostWinLabel = [NSString stringWithFormat:@"%@ (%i-%i-%i)", [StringFactory GetString_BiggestWin], nYear, nMonth, nDay];
    [p2 SetTitle:szMostWinLabel];
    nChip = [ScoreRecord GetPlayer3MostWinChips];
    [p2 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p2 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p2];
    
    DualTextCell* p3 = [[DualTextCell alloc] initWithResource:@"ropaidleicon1.png" withFrame:rect];
    [p3 SetTitle:[StringFactory GetString_LatestPlay]];
    nChip = [ScoreRecord GetPlayer3LastPlayResult];
    [p3 SetText:[NSString stringWithFormat:@"%i", nChip]]; 
    [p3 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
    [pCell AddCell:p3];
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
}

-(void)IntializeScoreList
{
    [self InitializeMe];
    [self InitializePlayer1];
    [self InitializePlayer2];
    [self InitializePlayer3];
    
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)LoadScore
{
    [self RemoveAllCells];
    [self IntializeScoreList];
    [m_ListView setContentOffset:CGPointZero animated:YES];
}
-(void)OnViewOpen
{
	[super OnViewOpen];
    [self LoadScore];
}	

@end
