//
//  PatternView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "PatternView.h"
#import "GameConfiguration.h"
#import "GameLayout.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "CPuzzleGrid.h"

@implementation PatternView

- (void)OnMatrixIconClicked:(id)sender
{
    [m_MatrixIcon SetSelected:YES];
    [m_SnakeIcon SetSelected:NO];
    [m_SpiralIcon SetSelected:NO];

    [GameConfiguration SetGridLayout:PUZZLE_LALOUT_MATRIX];
}

- (void)OnSnakeIconClicked:(id)sender
{
    [m_MatrixIcon SetSelected:NO];
    [m_SnakeIcon SetSelected:YES];
    [m_SpiralIcon SetSelected:NO];
    
    [GameConfiguration SetGridLayout:PUZZLE_LALOUT_SNAKE];
}

- (void)OnSpiralIconClicked:(id)sender
{
    [m_MatrixIcon SetSelected:NO];
    [m_SnakeIcon SetSelected:NO];
    [m_SpiralIcon SetSelected:YES];
    
    [GameConfiguration SetGridLayout:PUZZLE_LALOUT_SPIRAL];
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
    {    
        sy = cy - (fSize+fOffset);
        if(nCol == 0)
            sx = cx - (fSize+fOffset);
        else
            sx = cx + fOffset;
    }    
    else
    {    
        sy = cy + fOffset;
        sx = cx - fSize*0.5;
    }    
    
    
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    
    return rect;   
}

- (void)LoadLayoutImage
{
    int nEdge = 4;
    enBubbleType bubbleType = [GameConfiguration GetBubbleType];
    
    switch(m_ActiveType)
    {
        case PUZZLE_GRID_TRIANDLE:
            nEdge = 4;
            break;
        case PUZZLE_GRID_SQUARE:
            nEdge = 4;
            break;
        case PUZZLE_GRID_DIAMOND:
            nEdge = 3;
            break;
        case PUZZLE_GRID_HEXAGON:
            nEdge = 3;
            break;
    }
    BOOL bEasy = ![GameConfiguration IsGameDifficulty];
    [m_MatrixIcon SetIconImage:[CPuzzleGrid GetDefaultLayoutImage:m_ActiveType withLayout:PUZZLE_LALOUT_MATRIX withSize:nEdge withLevel:bEasy withBubble:bubbleType]];
    [m_SnakeIcon  SetIconImage:[CPuzzleGrid GetDefaultLayoutImage:m_ActiveType withLayout:PUZZLE_LALOUT_SNAKE withSize:nEdge withLevel:bEasy withBubble:bubbleType]];
    [m_SpiralIcon  SetIconImage:[CPuzzleGrid GetDefaultLayoutImage:m_ActiveType withLayout:PUZZLE_LALOUT_SPIRAL withSize:nEdge withLevel:bEasy withBubble:bubbleType]];
    
}

- (void)InitIconviews
{
    CGRect rect = [self GetIconViewRect:0];
    m_MatrixIcon = [[IconView alloc] initWithFrame:rect];
    [m_MatrixIcon RegisterEvent:GUIID_EVENT_MATRIXICONCLICK];
    [m_MatrixIcon SetSelected:(m_ActiveLayout == PUZZLE_LALOUT_MATRIX)];
    [self addSubview:m_MatrixIcon];
    [m_MatrixIcon release];
    if(m_ActiveLayout == PUZZLE_LALOUT_MATRIX)
        
    
    rect = [self GetIconViewRect:1];
    m_SnakeIcon = [[IconView alloc] initWithFrame:rect];
    [m_SnakeIcon RegisterEvent:GUIID_EVENT_SNAKEICONCLICK];
    [m_SnakeIcon SetSelected:(m_ActiveLayout == PUZZLE_LALOUT_SNAKE)];
    [self addSubview:m_SnakeIcon];
    [m_SnakeIcon release];
    
    rect = [self GetIconViewRect:2];
    m_SpiralIcon = [[IconView alloc] initWithFrame:rect];
    [m_SpiralIcon RegisterEvent:GUIID_EVENT_SPIRALICONCLICK];
    [m_SpiralIcon SetSelected:(m_ActiveLayout == PUZZLE_LALOUT_SPIRAL)];
    [self addSubview:m_SpiralIcon];
    [m_SpiralIcon release];
    
	[GUIEventLoop RegisterEvent:GUIID_EVENT_MATRIXICONCLICK eventHandler:@selector(OnMatrixIconClicked:) eventReceiver:self eventSender:m_MatrixIcon];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_SNAKEICONCLICK eventHandler:@selector(OnSnakeIconClicked:) eventReceiver:self eventSender:m_SnakeIcon];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_SPIRALICONCLICK eventHandler:@selector(OnSpiralIconClicked:) eventReceiver:self eventSender:m_SpiralIcon];

    [self LoadLayoutImage];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_ActiveType = [GameConfiguration GetGridType];
        m_ActiveLayout = [GameConfiguration GetGridLayout];
        [self InitIconviews];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)UpdateViewLayout
{
    CGRect rect = [self GetIconViewRect:0];
    [m_MatrixIcon setFrame:rect];
    [m_MatrixIcon setNeedsDisplay];
    
    rect = [self GetIconViewRect:1];
    [m_SnakeIcon setFrame:rect];
    [m_SnakeIcon setNeedsDisplay];
    
    rect = [self GetIconViewRect:2];
    [m_SpiralIcon setFrame:rect];
    [m_SpiralIcon setNeedsDisplay];
}


-(void)OpenView
{
    enGridType enType = [GameConfiguration GetGridType];
    enGridLayout enLayout = [GameConfiguration GetGridLayout];
    
    if(enType != m_ActiveType || [GameConfiguration IsDirty])
    {
        m_ActiveType = enType;
        [self LoadLayoutImage];
    }
    
    m_ActiveLayout = enLayout;
    switch(enLayout)
    {
        case PUZZLE_LALOUT_MATRIX:
            [m_MatrixIcon SetSelected:YES];
            [m_SnakeIcon SetSelected:NO];
            [m_SpiralIcon SetSelected:NO];
            break;
        case PUZZLE_LALOUT_SNAKE:       
            [m_MatrixIcon SetSelected:NO];
            [m_SnakeIcon SetSelected:YES];
            [m_SpiralIcon SetSelected:NO];
            break;
        case PUZZLE_LALOUT_SPIRAL:
            [m_MatrixIcon SetSelected:NO];
            [m_SnakeIcon SetSelected:NO];
            [m_SpiralIcon SetSelected:YES];
            break;
    }
}

@end
