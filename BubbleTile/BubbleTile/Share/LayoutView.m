//
//  LayoutView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GameCenterConstant.h"
#import "LayoutView.h"
#import "GameLayout.h"
#import "ImageLoader.h"
#import "CPuzzleGrid.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"
#import "GameConfiguration.h"
#import "ApplicationConfigure.h"
#import "GameScore.h"

@implementation LayoutView

-(void)OnTriIconClicked:(id)sender
{
    [m_TriIcon SetSelected:YES];
    [m_SquareIcon SetSelected:NO];
    [m_DiaIcon SetSelected:NO];
    [m_HexIcon SetSelected:NO];
    [GameConfiguration SetGridType:PUZZLE_GRID_TRIANDLE];
}

-(void)OnSquareIconClicked:(id)sender
{
    [m_TriIcon SetSelected:NO];
    [m_SquareIcon SetSelected:YES];
    [m_DiaIcon SetSelected:NO];
    [m_HexIcon SetSelected:NO];
    [GameConfiguration SetGridType:PUZZLE_GRID_SQUARE];
}

-(void)OnDiaIconClicked:(id)sender
{
    [m_TriIcon SetSelected:NO];
    [m_SquareIcon SetSelected:NO];
    [m_DiaIcon SetSelected:YES];
    [m_HexIcon SetSelected:NO];
    [GameConfiguration SetGridType:PUZZLE_GRID_DIAMOND];
}

    
-(void)OnHexIconClicked:(id)sender
{
    [m_TriIcon SetSelected:NO];
    [m_SquareIcon SetSelected:NO];
    [m_DiaIcon SetSelected:NO];
    [m_HexIcon SetSelected:YES];
    [GameConfiguration SetGridType:PUZZLE_GRID_HEXAGON];
}

- (CGRect)GetIconViewRect:(int)i
{
    float cx = self.frame.size.width/2.0;
    float cy = self.frame.size.height/2.0;
    float fSize = [GameLayout GetIconViewSize];
    float fOffset = [GameLayout GetPlayBoardMargin];
    int nRow = (int)(((float)i)*0.5);
    int nCol = i%2;
    float sx, sy;
    if(nRow == 0)
        sy = cy - (fSize+fOffset);
    else
        sy = cy + fOffset;
    
    if(nCol == 0)
        sx = cx - (fSize+fOffset);
    else
        sx = cx + fOffset;
    
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    
    return rect;   
}

- (void)ReloadImages
{
    enBubbleType bubbleType = [GameConfiguration GetBubbleType];
    [m_TriIcon SetIconImage:[CPuzzleGrid GetDefaultGridImage:PUZZLE_GRID_TRIANDLE withSize:4 withBubble:bubbleType]];
    [m_SquareIcon SetIconImage:[CPuzzleGrid GetDefaultGridImage:PUZZLE_GRID_SQUARE withSize:4 withBubble:bubbleType]];
    [m_DiaIcon SetIconImage:[CPuzzleGrid GetDefaultGridImage:PUZZLE_GRID_DIAMOND withSize:3 withBubble:bubbleType]];
    [m_HexIcon SetIconImage:[CPuzzleGrid GetDefaultGridImage:PUZZLE_GRID_HEXAGON withSize:3 withBubble:bubbleType]];
}

- (void)InitIconViews
{
    CGRect rect = [self GetIconViewRect:0];
    enBubbleType bubbleType = [GameConfiguration GetBubbleType];
    m_TriIcon = [[IconView alloc] initWithFrame:rect];
    [m_TriIcon SetIconImage:[CPuzzleGrid GetDefaultGridImage:PUZZLE_GRID_TRIANDLE withSize:4 withBubble:bubbleType]];
    [m_TriIcon RegisterEvent:GUIID_EVENT_TRIANGLEICONCLICK];
    [self addSubview:m_TriIcon];
    [m_TriIcon release];
    
    rect = [self GetIconViewRect:1];
    m_SquareIcon = [[IconView alloc] initWithFrame:rect];
    [m_SquareIcon SetIconImage:[CPuzzleGrid GetDefaultGridImage:PUZZLE_GRID_SQUARE withSize:4 withBubble:bubbleType]];
    [m_SquareIcon RegisterEvent:GUIID_EVENT_SQUAREICONCLICK];
    [self addSubview:m_SquareIcon];
    [m_SquareIcon release];
    
    rect = [self GetIconViewRect:2];
    m_DiaIcon = [[IconView alloc] initWithFrame:rect];
    [m_DiaIcon SetIconImage:[CPuzzleGrid GetDefaultGridImage:PUZZLE_GRID_DIAMOND withSize:3 withBubble:bubbleType]];
    [m_DiaIcon RegisterEvent:GUIID_EVENT_DIAMONDICONCLICK];
    [self addSubview:m_DiaIcon];
    [m_DiaIcon release];
    
    rect = [self GetIconViewRect:3];
    m_HexIcon = [[IconView alloc] initWithFrame:rect];
    [m_HexIcon SetIconImage:[CPuzzleGrid GetDefaultGridImage:PUZZLE_GRID_HEXAGON withSize:3 withBubble:bubbleType]];
    [m_HexIcon RegisterEvent:GUIID_EVENT_HEXGONICONCLICK];
    [self addSubview:m_HexIcon];
    [m_HexIcon release];

    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        [m_SquareIcon SetEnable:NO];
        [m_DiaIcon SetEnable:NO];
        [m_HexIcon  SetEnable:NO];
    }
    
	[GUIEventLoop RegisterEvent:GUIID_EVENT_TRIANGLEICONCLICK eventHandler:@selector(OnTriIconClicked:) eventReceiver:self eventSender:m_TriIcon];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_SQUAREICONCLICK eventHandler:@selector(OnSquareIconClicked:) eventReceiver:self eventSender:m_SquareIcon];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_DIAMONDICONCLICK eventHandler:@selector(OnDiaIconClicked:) eventReceiver:self eventSender:m_DiaIcon];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_HEXGONICONCLICK eventHandler:@selector(OnHexIconClicked:) eventReceiver:self eventSender:m_HexIcon];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self InitIconViews];    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

-(void)UpdateViewLayout
{
    CGRect rect = [self GetIconViewRect:0];
    [m_TriIcon setFrame:rect];
    [m_TriIcon setNeedsDisplay];
    
    rect = [self GetIconViewRect:1];
    [m_SquareIcon setFrame:rect];
    [m_SquareIcon setNeedsDisplay];
    
    rect = [self GetIconViewRect:2];
    [m_DiaIcon setFrame:rect];
    [m_DiaIcon setNeedsDisplay];
    
    rect = [self GetIconViewRect:3];
    [m_HexIcon setFrame:rect];
    [m_HexIcon setNeedsDisplay];
}

-(void)OpenView
{
    enGridType enType = [GameConfiguration GetGridType];
    if([GameConfiguration IsDirty])
        [self ReloadImages];
    
    switch(enType)
    {
        case PUZZLE_GRID_TRIANDLE:
            [m_TriIcon SetSelected:YES];
            [m_SquareIcon SetSelected:NO];
            [m_DiaIcon SetSelected:NO];
            [m_HexIcon SetSelected:NO];
            break;
        case PUZZLE_GRID_SQUARE:
            [m_TriIcon SetSelected:NO];
            [m_SquareIcon SetSelected:YES];
            [m_DiaIcon SetSelected:NO];
            [m_HexIcon SetSelected:NO];
            break;
        case PUZZLE_GRID_DIAMOND:
            [m_TriIcon SetSelected:NO];
            [m_SquareIcon SetSelected:NO];
            [m_DiaIcon SetSelected:YES];
            [m_HexIcon SetSelected:NO];
            break;
        case PUZZLE_GRID_HEXAGON:
            [m_TriIcon SetSelected:NO];
            [m_SquareIcon SetSelected:NO];
            [m_DiaIcon SetSelected:NO];
            [m_HexIcon SetSelected:YES];
            break;
    }
    if([GameScore CheckPaymentState] == YES || [ApplicationConfigure CanTemporaryAccessPaidFeature])
    {
        [m_SquareIcon SetEnable:YES];
        [m_DiaIcon SetEnable:YES];
        [m_HexIcon  SetEnable:YES];
    }
    else 
    {
        if([GameScore CheckSquarePaymentState] == YES)
            [m_SquareIcon SetEnable:YES];
        else 
            [m_SquareIcon SetEnable:NO];
        
        if([GameScore CheckDiamondPaymentState] == YES)
            [m_DiaIcon SetEnable:YES];
        else
            [m_DiaIcon SetEnable:NO];
            
        if([GameScore CheckHexagonPaymentState] == YES)
            [m_HexIcon  SetEnable:YES];
        else
            [m_HexIcon  SetEnable:NO];
    }
}

@end
