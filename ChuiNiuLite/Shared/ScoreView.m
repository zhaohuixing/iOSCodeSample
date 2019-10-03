//
//  ScoreView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "ScoreView.h"
#import "GUIEventLoop.h"
#import "ImageLoader.h"
#import "ApplicationConfigure.h"
#import "Configuration.h"
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
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
		float size = 80;
		if([ApplicationConfigure iPADDevice])
			size = 120;
		
		//m_Pattern = [ImageLoader CreateImageFillPattern:@"iTunesArtwork.png" withWidth:size withHeight:size isFlipped:YES];
        [self IntializeScoreList];
    }
    return self;
}

- (void)dealloc 
{
	//CGPatternRelease(m_Pattern);
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
		int nPoint = [ScoreRecord getPoint:GAME_SKILL_LEVEL_ONE atLevel:i];
		int nScore = [ScoreRecord getScore:GAME_SKILL_LEVEL_ONE atLevel:i];
		if(0 < nPoint)
			szLable = [NSString stringWithFormat:@"%@ (%i)",szLable, nPoint];
		NSString* szScore = [NSString stringWithFormat:@"%i", nScore]; 
        
        DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
        [p SetTitle:szLable]; 
        [p SetText:szScore]; 
        
        [pCell AddCell:p];
    }
    [pCell SetSelectable:NO];
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
		int nPoint = [ScoreRecord getPoint:GAME_SKILL_LEVEL_TWO atLevel:i];
		int nScore = [ScoreRecord getScore:GAME_SKILL_LEVEL_TWO atLevel:i];
		if(0 < nPoint)
			szLable = [NSString stringWithFormat:@"%@ (%i)",szLable, nPoint];
		NSString* szScore = [NSString stringWithFormat:@"%i", nScore]; 
        
        DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
        [p SetTitle:szLable]; 
        [p SetText:szScore]; 
        
        [pCell AddCell:p];
    }
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeLevelThree
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_SkillThree:NO]]; 
    
    for(int i = GAME_PLAY_LEVEL_ONE; i <= GAME_PLAY_LEVEL_FOUR; ++i)
    {    
		NSString* szLable = [StringFactory GetString_LevelString:i withDefault:NO];
		int nPoint = [ScoreRecord getPoint:GAME_SKILL_LEVEL_THREE atLevel:i];
		int nScore = [ScoreRecord getScore:GAME_SKILL_LEVEL_THREE atLevel:i];
		if(0 < nPoint)
			szLable = [NSString stringWithFormat:@"%@ (%i)",szLable, nPoint];
		NSString* szScore = [NSString stringWithFormat:@"%i", nScore]; 
        
        DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
        [p SetTitle:szLable]; 
        [p SetText:szScore]; 
        
        [pCell AddCell:p];
    }
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
}

-(void)IntializeScoreList
{
    [self InitializeSkillOne];
    [self InitializeSkillTwo];
    [self InitializeLevelThree];
    
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)LoadScore
{
    for (int i = GAME_SKILL_LEVEL_ONE; i <= GAME_SKILL_LEVEL_THREE; ++i) 
    {
        id<ListCellTemplate> pCell = [m_ListView GetCell:i];
        if(pCell && [pCell GetListCellType] == enLISTCELLTYPE_GROUP)
        {
            GroupCell* pGroupCell = (GroupCell*)pCell;
            if(pGroupCell)
            {
                for (int j = GAME_PLAY_LEVEL_ONE; j <= GAME_PLAY_LEVEL_FOUR; ++j)
                {
                    NSString* szLable = [StringFactory GetString_LevelString:j withDefault:NO];
                    int nPoint = [ScoreRecord getPoint:i atLevel:j];
                    int nScore = [ScoreRecord getScore:i atLevel:j];
                    if(0 < nPoint)
                        szLable = [NSString stringWithFormat:@"%@ (%i)",szLable, nPoint];
                    NSString* szScore = [NSString stringWithFormat:@"%i", nScore]; 
                    
                    DualTextCell* p = (DualTextCell*)[pGroupCell GetCellAt:j+1];
                    if(p)
                    {    
                        [p SetTitle:szLable]; 
                        [p SetText:szScore]; 
                    }
                }
            }
        }       
    } 
}
-(void)OnViewOpen
{
	[super OnViewOpen];
    [self LoadScore];
}	

@end
