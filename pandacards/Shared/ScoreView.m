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
#include "GameUtility.h"

@implementation ScoreView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
        //[self IntializeScoreList];
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

-(void)OnViewOpen
{
    [self InitializeScoreList];
    [super OnViewOpen];
}	

-(void)InitializeScore:(ScoreRecord*)score
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	NSString* szTitle = @"";
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    szTitle = [StringFactory GetString_ScoreTitleString:score.m_nPoint withSpeed:score.m_nSpeed];
    [pCell SetTitle:szTitle]; 

    DualTextCell* p1 = [[DualTextCell alloc] initWithFrame:rect];
    [p1 SetTitle:[StringFactory GetString_LastScoreLabel]]; 
    [p1 SetText:[NSString stringWithFormat:@"%i", (int)score.m_nLastScore]]; 
    if([ApplicationConfigure iPADDevice])
        [p1 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [pCell AddCell:p1];
    
    DualTextCell* p2 = [[DualTextCell alloc] initWithFrame:rect];
    [p2 SetTitle:[StringFactory GetString_HighScoreLabel]]; 
    [p2 SetText:[NSString stringWithFormat:@"%i", (int)score.m_nAveHighestScore]]; 
    if([ApplicationConfigure iPADDevice])
        [p2 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [pCell AddCell:p2];
    
    DualTextCell* p3 = [[DualTextCell alloc] initWithFrame:rect];
    [p3 SetTitle:[StringFactory GetString_HighScoreTime]]; 
    [p3 SetText:[NSString stringWithFormat:@"%i-%i-%i", score.m_nYear4Highest, score.m_nMonth4Highest, score.m_nDay4Highest]]; 
    if([ApplicationConfigure iPADDevice])
        [p3 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [pCell AddCell:p3];
    
    DualTextCell* p4 = [[DualTextCell alloc] initWithFrame:rect];
    [p4 SetTitle:[StringFactory GetString_AveScoreLabel]]; 
    [p4 SetText:[NSString stringWithFormat:@"%i", (int)score.m_nAveAveScore]]; 
    if([ApplicationConfigure iPADDevice])
        [p4 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [pCell AddCell:p4];

    DualTextCell* p5 = [[DualTextCell alloc] initWithFrame:rect];
    [p5 SetTitle:[StringFactory GetString_PlaysLabel]]; 
    [p5 SetText:[NSString stringWithFormat:@"%i", score.m_nAvePlayCount]]; 
    if([ApplicationConfigure iPADDevice])
        [p5 SetTextAlignment:enCELLTEXTALIGNMENT_CENTER];
    [pCell AddCell:p5];
    
    
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
    
}

-(void)InitializeScoreList
{
    [self RemoveAllCells];

    GameScore* Scores = [[GameScore alloc] init];
    [Scores LoadScoresFromPreference:NO];
    
 	int nCount = [Scores GetScoreCount];
   
    if(0 < nCount)
    {
        int nActive = [Scores GetActivePointScoreIndex];
        for(int i = 0; i < nCount; ++i)
        {
			ScoreRecord* score = nil;
			if(nActive < 0)
			{	
				score = [Scores GetScoreRecord:i];
			}	
			else 
			{	
				if(i == 0)
				{
					score = [Scores GetScoreRecord:nActive];
				}
				else
				{
					int j = i-1;
					if(0 <= j)
					{
						if(j < nActive)
						{
							score = [Scores GetScoreRecord:j];
						}
						else if(nActive <= j)
						{
							score = [Scores GetScoreRecord:i];
						}
					}	
				}	
			}
            if(score != nil)
            {
                [self InitializeScore:score];
            }
        }
    }
    
    
    [Scores release];
    
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	

}


@end
