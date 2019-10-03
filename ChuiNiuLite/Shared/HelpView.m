//
//  HelpView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 2011-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "HelpView.h"
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
#import "ScoreRecord.h"
#import "GameCenterConstant.h"
#import "RenderHelper.h"
#import "Configuration.h"

//#include "GameUtil.h"


@implementation HelpView

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

-(void)InitializePlayThresholdList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_PlayingScore]]; 
    
    for(int nLevel = GAME_PLAY_LEVEL_ONE; nLevel <= GAME_PLAY_LEVEL_FOUR; ++nLevel)
    {    
        for(int nSkill = GAME_SKILL_LEVEL_ONE; nSkill <= GAME_SKILL_LEVEL_THREE; ++nSkill)
        { 
            NSString* szSkill = [StringFactory GetString_SkillString:nSkill withDefault:NO];
            NSString* szLevel = [StringFactory GetString_LevelString:nLevel withDefault:NO];
            NSString* szLabel = [NSString stringWithFormat:@"%@/%@", szLevel, szSkill];
            
            int nScore = [Configuration getGamePLayThesholdScore:nSkill inLevel:nLevel];
            NSString* szScore = [NSString stringWithFormat:@"%i", nScore];
            DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
            [p SetTitle:szLabel]; 
            [p SetText:szScore]; 
            
            [pCell AddCell:p];
        }    
    }
    
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeWinScoreList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_WinningScore]]; 
    
    for(int nLevel = GAME_PLAY_LEVEL_ONE; nLevel <= GAME_PLAY_LEVEL_FOUR; ++nLevel)
    {    
        for(int nSkill = GAME_SKILL_LEVEL_ONE; nSkill <= GAME_SKILL_LEVEL_THREE; ++nSkill)
        { 
            NSString* szSkill = [StringFactory GetString_SkillString:nSkill withDefault:NO];
            NSString* szLevel = [StringFactory GetString_LevelString:nLevel withDefault:NO];
            NSString* szLabel = [NSString stringWithFormat:@"%@/%@", szLevel, szSkill];
            
            int nScore = [Configuration getGameWinScore:nSkill inLevel:nLevel];
            NSString* szScore = [NSString stringWithFormat:@"%i", nScore];
            DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
            [p SetTitle:szLabel]; 
            [p SetText:szScore]; 
            
            [pCell AddCell:p];
        }    
    }
    
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeLostScoreList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_LostScore]]; 
    
    for(int nLevel = GAME_PLAY_LEVEL_ONE; nLevel <= GAME_PLAY_LEVEL_FOUR; ++nLevel)
    {    
        for(int nSkill = GAME_SKILL_LEVEL_ONE; nSkill <= GAME_SKILL_LEVEL_THREE; ++nSkill)
        { 
            NSString* szSkill = [StringFactory GetString_SkillString:nSkill withDefault:NO];
            NSString* szLevel = [StringFactory GetString_LevelString:nLevel withDefault:NO];
            NSString* szLabel = [NSString stringWithFormat:@"%@/%@", szLevel, szSkill];
            
            int nScore = [Configuration getGameLostPenalityScore:nSkill inLevel:nLevel];
            NSString* szScore = [NSString stringWithFormat:@"%i", nScore];
            DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
            [p SetTitle:szLabel]; 
            [p SetText:szScore]; 
            
            [pCell AddCell:p];
        }    
    }
    
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
}

-(void)IntializeAllLists
{
    [self InitializePlayThresholdList];
    [self InitializeWinScoreList];
    [self InitializeLostScoreList];
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)LoadInformation
{
    [self IntializeAllLists];
}
-(void)OnViewOpen
{
	[super OnViewOpen];
}	

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
        [self LoadInformation];
    }
    return self;
}


@end
