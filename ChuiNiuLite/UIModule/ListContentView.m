//
//  ListContentView.m
//  testscollview
//
//  Created by Zhaohui Xing on 10-12-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "ListContentView.h"
#import "GUILayout.h"
#import "ListCellBasic.h"
#import "ListCellData.h"
#import "GUIBasicConstant.h"
#import "GUIEventLoop.h"
#import "TextCheckboxCell.h"

@implementation ListContentView

//Test code
-(void)TestAddCell
{
	float x = 0;
	float y = 0;
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
	[self setFrame:CGRectMake(x, y, w, h*20.0)];
	for(int i = 0; i < 20; ++i)
	{
		y = ((float)i)*h;
		CGRect rect = CGRectMake(x, y, w, h);
		ListCellBasic* pCell = [[ListCellBasic alloc] initWithFrame:rect];
		pCell.m_szTitle = [NSString stringWithFormat:@"Cell %i", i]; 
		
		if(i% 2 == 0)
		{	
			ListCellDataInt* pData = [[ListCellDataInt alloc] init];
			pData.m_nData = i;
			pCell.m_DataStorage = pData;
			[pData release];
		}
		else 
		{
			ListCellDataString* pData = [[ListCellDataString alloc] init];
			pData.m_sData = [NSString stringWithFormat:@"Cell %i with String Data", i];
			pCell.m_DataStorage = pData;
			[pData release];
		}

		[self addSubview:pCell];
		[pCell setNeedsDisplay];
		[pCell release];
	}	
    [m_Container UpdateContentSizeByContentView];	
}	

-(id)initWithParent:(id<ListContainerTemplate>)parent;
{
    CGSize size = [parent GetContainerSize];
	CGRect frame = CGRectMake(0.0, 0.0, size.width, [GUILayout GetDefaultListCellHeight]);
    self = [super initWithFrame:frame];
    if (self) 
	{
		m_Container = parent;
		//[GUIEventLoop RegisterEvent:GUIID_LISTCELLEVENTID_UNSELECTCELL_ALL 
		//			  eventHandler:@selector(OnUnselectAllCells:) eventReceiver:self eventSender:nil];
		
		[self setNeedsDisplay];
    }
    return self;
}

-(void)OnUnCheckAllCells:(id)sender
{
    int nCount = [self.subviews count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            id<ListCellTemplate> pCell = [self.subviews objectAtIndex:i];
            if(pCell != nil)
                [pCell SetCheckBoxState:NO];
        }
    }
}

-(void)OnUnSelectAllCells:(id)sender
{
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			id<ListCellTemplate> pCell = (id<ListCellTemplate>)[self.subviews objectAtIndex:i];
			if(pCell)
			{	
				[pCell SetSelectionState:NO];
			}	
		}	
	}	
}

-(void)OnCellSelectedEvent:(id)sender
{
    if([self.superview respondsToSelector:@selector(OnCellSelectedEvent:)])
    {
        [self.superview OnCellSelectedEvent:sender]; 
    }
}

-(float)GetListHeight
{
	float fRet = 0.0;
	
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			id<ListCellTemplate> pCell = (id<ListCellTemplate>)[self.subviews objectAtIndex:i];
			if(pCell)
			{	
				fRet += [pCell GetCellHeight];
			}	
		}	
	}	
	return fRet;
}	

-(void)UpdateLayoutHeight
{
	CGRect rect = self.frame;
	float h = [self GetListHeight];
	rect.size.height = h;
	[self setFrame: rect];
}	

-(void)AddCell:(id<ListCellTemplate>)cell
{
	CGRect rect = self.frame;
	float oldHeight = [self GetListHeight];
	CGRect cellrt = [cell GetFrame];
    cellrt.origin.x = rect.origin.x;
    cellrt.origin.y = oldHeight;
	[cell SetFrame:cellrt];
	[self addSubview:(UIView*)cell];
	[self UpdateLayoutHeight];
}

-(void)OnLayoutChange
{
	float newWidth = self.frame.size.width;
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			id<ListCellTemplate> pCell = (id<ListCellTemplate>)[self.subviews objectAtIndex:i];
			if(pCell)
			{
				CGRect rect = ((UIView*)pCell).frame;
				rect.size.width = newWidth;
				//[((UIView*)pCell) setFrame:rect];
				[pCell SetFrame:rect];
			}	
		}
	}	
}

-(void)ShiftCells:(float)fYOffset fromIndex:(int)index
{
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			if(index <= i)
			{	
				id<ListCellTemplate> pCell = (id<ListCellTemplate>)[self.subviews objectAtIndex:i];
				if(pCell)
				{	
					[pCell OffsetYCell:fYOffset];
				}
			}	
		}
	}	
}	

-(void)RemoveCellAt:(int)pos
{
	int nCount = self.subviews.count;
	if(0 < nCount && pos < nCount)
	{
		UIView* subView = [self.subviews objectAtIndex:pos];
		float YOffset = -1.0*subView.frame.size.height;
		[subView removeFromSuperview];
		//[subView release];
		[self ShiftCells:YOffset fromIndex:pos];
		[self UpdateLayoutHeight];
	}	
}

-(void)RemoveCell:(id<ListCellTemplate>)cell
{
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			id<ListCellTemplate> pCell = (id<ListCellTemplate>)[self.subviews objectAtIndex:i];
			if(pCell == cell)
			{	
				[self RemoveCellAt:i];
				return;
			}
		}	
	}	
}	

-(void)RemoveAllCells
{
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = nCount-1; 0 <= i; --i)
		{	
			UIView* subView = [self.subviews objectAtIndex:i];
			[subView removeFromSuperview];
			//[subView release];
		}	
		[self UpdateLayoutHeight];
	}	
}	

-(int)GetCellCount
{
	int nCount = self.subviews.count;
    return nCount;    
}

-(id<ListCellTemplate>)GetCell:(int)index
{
    id<ListCellTemplate> pCell = nil;
	int nCount = self.subviews.count;
	if(0 < nCount && 0 <= index && index < nCount)
	{
		pCell = (id<ListCellTemplate>)[self.subviews objectAtIndex:index];
	}	
    return pCell;
}

- (void)dealloc 
{
    [super dealloc];
}

@end
