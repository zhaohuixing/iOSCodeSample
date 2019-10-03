//
//  FrameListView.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"
#import "ScrollListView.h"

@interface FrameListView : FrameView
{
	ScrollListView*		m_ListView;
}

//Override ListContainer methods.
-(void)UpdateViewLayout;
-(void)AddCell:(id<ListCellTemplate>)cell;
-(void)RemoveCellAt:(int)pos;
-(void)RemoveCell:(id<ListCellTemplate>)cell;
-(void)RemoveAllCells;
-(void)OnCellSelectedEvent:(id)sender;

@end
