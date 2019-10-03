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
#import "ScoreRecord.h"
#import "GameScore.h"
#import "GameConstants.h"
#import "Configuration.h"
#import "RenderHelper.h"

@implementation GameCenterPostView


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
/*
- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
    CGColorSpaceRef colorSpace;
    colorSpace = CGColorSpaceCreatePattern(NULL);
	CGContextSetFillColorSpace(context, colorSpace);
    
	float fAlpha = 0.65;
	[RenderHelper DefaultPatternFill:context withAlpha:fAlpha atRect:rect];
    CGColorSpaceRelease(colorSpace);
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

-(int)GetPostScoreByBoardIndex:(int)index
{
    int nScore = [ScoreRecord GetMyMostWinChips];
    return nScore;
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
                
                id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetGameViewController];
                if(pGKDelegate)
                {
                    int nScore = [self GetPostScoreByBoardIndex:nIndex];
                    [pGKDelegate PostGameCenterScore:nScore withBoard:nIndex];
                }
            }
        }
    }
    
}

-(void)IntializeScoreList
{
	CGFloat w = self.frame.size.width;
	CGFloat h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    int nScore = [ScoreRecord GetMyMostWinChips];
    TextCheckboxCell* p1 = [[TextCheckboxCell alloc] initWithResource:@"meidleiconrev.png" withFrame:rect];
    [p1 SetTitle:[NSString stringWithFormat:@"%@ (%i)",[StringFactory GetString_BiggestWin], nScore]]; 
    [p1 SetSelectable:YES];
    ListCellDataInt* pData1 = [[ListCellDataInt alloc] init];
    pData1.m_nData = 0;
    p1.m_Data = pData1;
    [self AddCell:p1];
    
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
