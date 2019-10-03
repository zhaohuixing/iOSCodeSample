//
//  ScrollListView.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ListConstants.h"
#import "ListContentView.h"

@interface ScrollListView : UIScrollView<UIScrollViewDelegate, ListContainerTemplate> 
{
	ListContentView*		m_ContentView;
}

-(void)UpdateContentSizeByContentView;
-(void)ResetContent;
-(CGSize)GetContainerSize;
-(void)OnLayoutChange;
-(void)AddCell:(id<ListCellTemplate>)cell;
-(void)RemoveCellAt:(int)pos;
-(void)RemoveCell:(id<ListCellTemplate>)cell;
-(void)RemoveAllCells;
-(int)GetCellCount;
-(id<ListCellTemplate>)GetCell:(int)index;

-(void)OnCellSelectedEvent:(id)sender;

@end
