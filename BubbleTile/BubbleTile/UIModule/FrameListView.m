//
//  FrameListView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FrameListView.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#import "GUILayout.h"

@implementation FrameListView

/*
- (void)RegisterCellEvents
{
	//[GUIEventLoop RegisterEvent:GUIID_LISTCELLEVENTID_SINGLESEL eventHandler:@selector(OnCellSelectedEvent:) eventReceiver:self eventSender:nil];
}*/	

-(id)initBlankUIWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		float size = [self GetCloseButtonSize];
		CGRect rect = frame;
		//rect.origin.y += size*1.5;
		//rect.origin.y = size*1.5;
		rect.origin.y = size*1.1;
		rect.size.height = frame.size.height - [GUILayout GetDefaultAlertUIEdge];
		rect.origin.x = [GUILayout GetDefaultAlertUIEdge]*1.5;
        rect.size.width = rect.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
        m_ListView = [[ScrollListView alloc] initWithFrame:rect];
		[self addSubview:m_ListView];
		
		[m_ListView release];
		[self bringSubviewToFront:m_ListView];
		//[self RegisterCellEvents];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc 
{
    [super dealloc];
}

-(void)ResetContent
{
}

-(void)OnCellSelectedEvent:(id)sender
{
    id<ListCellTemplate> p = (id<ListCellTemplate>)sender;
    if(p)
    {
        [p SetSelectionState:YES];
    }
}

-(void)UpdateViewLayout
{
	[super UpdateViewLayout];
	CGRect rect = m_ListView.frame;
	rect.size.width = self.frame.size.width;
    rect.size.height = self.frame.size.height - rect.origin.y - [GUILayout GetDefaultAlertUIEdge];
    rect.origin.x = [GUILayout GetDefaultAlertUIEdge]*1.5;
    rect.size.width = rect.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
	[m_ListView setFrame:rect];
	[m_ListView OnLayoutChange];
}	

-(void)AddCell:(id<ListCellTemplate>)cell
{
	[m_ListView AddCell:cell];
}

-(void)RemoveCellAt:(int)pos
{
	[m_ListView RemoveCellAt:pos];
}

-(void)RemoveCell:(id<ListCellTemplate>)cell
{
	[m_ListView RemoveCell:cell];
}

-(void)RemoveAllCells
{
	[m_ListView RemoveAllCells];
}

-(void)OnViewOpen
{
    [super OnViewOpen];
    [m_ListView setContentOffset:CGPointZero animated:YES];
}	


@end
