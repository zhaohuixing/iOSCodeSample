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
#import "GameScore.h"
#include "GameUtility.h"
#include "GameState.h"

@implementation LeaderBoardSelectView


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		//self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
		float size = 80;
		if([ApplicationConfigure iPADDevice])
			size = 120;
	
        float roundsize = [GUILayout GetDefaultAlertUIEdge];
        
        CGRect rect = CGRectMake(roundsize*2, roundsize, 250, 30);
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
                int nindex = [(ListCellDataInt*)data GetData];
                id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
                if(pGKDelegate)
                {
                    [pGKDelegate OpenLeaderBoardView:nindex];
                }
            }
        }
    }
}

-(void)IntializeScoreList
{
    float w = self.frame.size.width;
    float h = [GUILayout GetDefaultListCellHeight];
    NSString* szTitle = [StringFactory GetString_ScoreTitleString:24 withSpeed:GAME_SPEED_SLOW];
     
    CGRect rect = CGRectMake(0, 0, w, h);
     
    TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p SetTitle:szTitle]; 
    [p SetSelectable:YES];
    ListCellDataInt* pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 0;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];   

    szTitle = [StringFactory GetString_ScoreTitleString:24 withSpeed:GAME_SPEED_FAST];
    p = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p SetTitle:szTitle]; 
    [p SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 1;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];   

    szTitle = [StringFactory GetString_ScoreTitleString:21 withSpeed:GAME_SPEED_SLOW];
    p = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p SetTitle:szTitle]; 
    [p SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 2;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];   
   
    szTitle = [StringFactory GetString_ScoreTitleString:21 withSpeed:GAME_SPEED_FAST];
    p = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p SetTitle:szTitle]; 
    [p SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 3;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];   
    
    szTitle = [StringFactory GetString_ScoreTitleString:18 withSpeed:GAME_SPEED_SLOW];
    p = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p SetTitle:szTitle]; 
    [p SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 4;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];   
    
    szTitle = [StringFactory GetString_ScoreTitleString:18 withSpeed:GAME_SPEED_FAST];
    p = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p SetTitle:szTitle]; 
    [p SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 5;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];   
    
    szTitle = [StringFactory GetString_ScoreTitleString:27 withSpeed:GAME_SPEED_SLOW];
    p = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p SetTitle:szTitle]; 
    [p SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 6;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];   
    
    szTitle = [StringFactory GetString_ScoreTitleString:27 withSpeed:GAME_SPEED_FAST];
    p = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p SetTitle:szTitle]; 
    [p SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 7;
    p.m_Data = pData;
    [pData release];
    [self AddCell:p];
    [p release];   
    
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)OnViewOpen
{
    [m_Label2012 setText:[GameCenterManager getCurrentLocalPlayerAlias]];
	[super OnViewOpen];
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}	

@end
