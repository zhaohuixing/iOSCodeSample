//
//  LeaderBoardSelectView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 2011-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "LeaderBoardSelectView.h"
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
#import "TextCheckboxCell.h"
#import "GameCenterConstant.h"
#import "ScoreRecord.h"
#import "GameCenterManager.h"
#import "RenderHelper.h"

@implementation LeaderBoardSelectView


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

- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGFloat fAlpha = [ImageLoader GetDefaultViewFillAlpha];
    [RenderHelper DrawFlyingCowIconPatternFill:context withAlpha:fAlpha atRect:rect];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
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
                    [pGKDelegate OpenLeaderBoardView:nIndex];
                }
            }
        }
    }
}


-(void)InitializeSkillOne
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_SkillOne:NO]]; 
    
    for(int i = GAME_PLAY_LEVEL_ONE; i <= GAME_PLAY_LEVEL_FOUR; ++i)
    {    
		NSString* szLable = [StringFactory GetString_LevelString:i withDefault:NO];
		int nScore = [ScoreRecord getScore:GAME_SKILL_LEVEL_ONE atLevel:i];
		szLable = [NSString stringWithFormat:@"%@ (%i)",szLable, nScore];
        
        TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
        [p SetTitle:szLable]; 
        [p SetSelectable:YES];
        ListCellDataInt* pData = [[ListCellDataInt alloc] init];
        pData.m_nData = i;
        p.m_Data = pData;
        [pData release];
        
        [pCell AddCell:p];
    }
    [pCell SetSelectable:YES];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeSkillTwo
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_SkillTwo:NO]]; 
    
    for(int i = GAME_PLAY_LEVEL_ONE; i <= GAME_PLAY_LEVEL_FOUR; ++i)
    {    
		NSString* szLable = [StringFactory GetString_LevelString:i withDefault:NO];
		int nScore = [ScoreRecord getScore:GAME_SKILL_LEVEL_TWO atLevel:i];
		szLable = [NSString stringWithFormat:@"%@ (%i)",szLable, nScore];
        
        TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
        [p SetTitle:szLable]; 
        [p SetSelectable:YES];
        ListCellDataInt* pData = [[ListCellDataInt alloc] init];
        pData.m_nData = i+4;
        p.m_Data = pData;
        [pData release];
        
        [pCell AddCell:p];
    }
    [pCell SetSelectable:YES];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeSkillThree
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_SkillThree:NO]]; 
    
    for(int i = GAME_PLAY_LEVEL_ONE; i <= GAME_PLAY_LEVEL_FOUR; ++i)
    {    
		NSString* szLable = [StringFactory GetString_LevelString:i withDefault:NO];
		int nScore = [ScoreRecord getScore:GAME_SKILL_LEVEL_THREE atLevel:i];
		szLable = [NSString stringWithFormat:@"%@ (%i)",szLable, nScore];
        
        TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
        [p SetTitle:szLable]; 
        [p SetSelectable:YES];
        ListCellDataInt* pData = [[ListCellDataInt alloc] init];
        pData.m_nData = i+8;
        p.m_Data = pData;
        [pData release];
        
        [pCell AddCell:p];
    }
    [pCell SetSelectable:YES];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeAll
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_TotalPlay]]; 
    
    for(int i = GAME_PLAY_LEVEL_ONE; i <= GAME_PLAY_LEVEL_FOUR; ++i)
    {    
		NSString* szLable = [StringFactory GetString_LevelString:i withDefault:NO];
		szLable = [NSString stringWithFormat:@"%@",szLable];
        
        TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
        [p SetTitle:szLable]; 
        [p SetSelectable:YES];
        ListCellDataInt* pData = [[ListCellDataInt alloc] init];
        pData.m_nData = i+12;
        p.m_Data = pData;
        [pData release];
        
        [pCell AddCell:p];
    }
    [pCell SetSelectable:YES];
    [self AddCell:pCell];
    [pCell release];
    
}

-(void)InitializeTotalScore
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_GameTotalScoreTitle]]; 
    
		NSString* szLable = [StringFactory GetString_GameTotalScoreTitle];
        
        TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
        [p SetTitle:szLable]; 
        [p SetSelectable:YES];
        ListCellDataInt* pData = [[ListCellDataInt alloc] init];
        pData.m_nData = 16;
        p.m_Data = pData;
        [pData release];
        
        [pCell AddCell:p];
    [pCell SetSelectable:YES];
    [self AddCell:pCell];
    [pCell release];
}

-(void)IntializeScoreList
{
    [self InitializeTotalScore];
    [self InitializeSkillOne];
    [self InitializeSkillTwo];
    [self InitializeSkillThree];
    [self InitializeAll];
    
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
    //[m_Label2012 setText:[GameCenterManager getCurrentLocalPlayerAlias]];
	[super OnViewOpen];
    [self LoadScore];
}	

@end
