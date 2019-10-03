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
#import "RenderHelper.h"

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
        
//		m_Pattern = [ImageLoader CreateImageFillPattern:@"iTunesArtwork.png" withWidth:size withHeight:size isFlipped:YES];
        
        
        [self IntializeScoreList];
    }
    return self;
}

- (void)dealloc 
{
//	CGPatternRelease(m_Pattern);
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
                float fScore = 0;
                switch(nIndex)
                {
                    case 0:
                        fScore = [GameAchievementHelper GetCurrentLevelOnePercent];
                        break;
                    case 1:
                        fScore = [GameAchievementHelper GetCurrentLevelTwoPercent];
                        break;
                    case 2:
                        fScore = [GameAchievementHelper GetCurrentLevelThreePercent];
                        break;
                    case 3:
                        fScore = [GameAchievementHelper GetCurrentLevelFourPercent];
                        break;
                        
                }
                id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
                if(pGKDelegate)
                {
                    [pGKDelegate PostAchievement:fScore withBoard:nIndex];
                }
            }
        }
    }
}

-(void)IntializeScoreList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
    CGRect rect = CGRectMake(0, 0, w, h);
    NSString* szLable = [StringFactory GetString_AchievementOneTitle];
    TextCheckboxCell* p1 = [[TextCheckboxCell alloc] initWithFrame:rect];
    float fScore = [GameAchievementHelper GetCurrentLevelOnePercent];
    szLable = [NSString stringWithFormat:@"%@(%f)",szLable, fScore];
    [p1 SetTitle:szLable]; 
    [p1 SetSelectable:YES];
    ListCellDataInt* pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 0;
    p1.m_Data = pData;
    [pData release];
    [self AddCell:p1];
    [p1 release];
    
    szLable = [StringFactory GetString_AchievementTwoTitle];
    TextCheckboxCell* p2 = [[TextCheckboxCell alloc] initWithFrame:rect];
    fScore = [GameAchievementHelper GetCurrentLevelTwoPercent];
    szLable = [NSString stringWithFormat:@"%@(%f)",szLable, fScore];
    [p2 SetTitle:szLable]; 
    [p2 SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 1;
    p2.m_Data = pData;
    [pData release];
    [self AddCell:p2];
    [p2 release];
    
    szLable = [StringFactory GetString_AchievementThreeTitle];
    TextCheckboxCell* p3 = [[TextCheckboxCell alloc] initWithFrame:rect];
    fScore = [GameAchievementHelper GetCurrentLevelThreePercent];
    szLable = [NSString stringWithFormat:@"%@(%f)",szLable, fScore];
    [p3 SetTitle:szLable]; 
    [p3 SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 2;
    p3.m_Data = pData;
    [pData release];
    [self AddCell:p3];
    [p3 release];
    
    szLable = [StringFactory GetString_AchievementThreeTitle];
    TextCheckboxCell* p4 = [[TextCheckboxCell alloc] initWithFrame:rect];
    fScore = [GameAchievementHelper GetCurrentLevelFourPercent];
    szLable = [NSString stringWithFormat:@"%@(%f)",szLable, fScore];
    [p4 SetTitle:szLable]; 
    [p4 SetSelectable:YES];
    pData = [[ListCellDataInt alloc] init];
    pData.m_nData = 3;
    p4.m_Data = pData;
    [pData release];
    [self AddCell:p4];
    [p4 release];
    
    
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
