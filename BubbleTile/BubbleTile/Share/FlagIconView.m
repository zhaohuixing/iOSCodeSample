//
//  FlagIconView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-06-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "FlagIconView.h"
#import "GameConfiguration.h"
#import "CPuzzleGrid.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"

@implementation FlagIconView

- (void)UpdateIconImage
{
	enGridType enType = [GameConfiguration GetGridType];
	enGridLayout enLayout = [GameConfiguration GetGridLayout];
    BOOL bEasy = ![GameConfiguration IsGameDifficulty];
    enBubbleType bubbleType = [GameConfiguration GetBubbleType];
	m_IconImage = [CPuzzleGrid GetDefaultLayoutImage:enType withLayout:enLayout withSize:3 withLevel:bEasy withBubble:bubbleType]; 
	[self setNeedsDisplay];
}	

-(void)OnPuzzleChange:(id)sender
{
    [self UpdateIconImage];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
        self.backgroundColor = [UIColor clearColor];
        
		enGridType enType = [GameConfiguration GetGridType];
		enGridLayout enLayout = [GameConfiguration GetGridLayout];
        BOOL bEasy = ![GameConfiguration IsGameDifficulty];
        enBubbleType bubbleType = [GameConfiguration GetBubbleType];
		m_IconImage = [CPuzzleGrid GetDefaultLayoutImage:enType withLayout:enLayout withSize:3 withLevel:bEasy withBubble:bubbleType]; 
        [GUIEventLoop RegisterEvent:GUIID_EVENT_CONFIGURECHANGE eventHandler:@selector(OnPuzzleChange:) eventReceiver:self eventSender:nil]; 
	}
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
	if(m_IconImage)
	{ 
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSaveGState(context);
		CGContextDrawImage(context, rect, m_IconImage);
		CGContextRestoreGState(context);
	}	
}


- (void)dealloc 
{
	if(m_IconImage)
		CGImageRelease(m_IconImage);
    [super dealloc];
}


@end
