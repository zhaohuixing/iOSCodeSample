//
//  ListContentView.h
//  testscollview
//
//  Created by Zhaohui Xing on 10-12-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ListConstants.h"

@interface ListContentView : UIView<ListContentViewTemplate> 
{
	id<ListContainerTemplate>       m_Container;
}

-(id)initWithParent:(id<ListContainerTemplate>)parent;
-(void)OnUnCheckAllCells:(id)sender;
-(void)OnUnSelectAllCells:(id)sender;
-(void)OnCellSelectedEvent:(id)sender;

-(void)AddCell:(id<ListCellTemplate>)cell;
-(void)OnLayoutChange;
-(void)RemoveCellAt:(int)pos;
-(void)RemoveCell:(id<ListCellTemplate>)cell;
-(void)RemoveAllCells;
-(void)UpdateLayoutHeight;
-(int)GetCellCount;
-(id<ListCellTemplate>)GetCell:(int)index;

//Testcode
-(void)TestAddCell;
@end
