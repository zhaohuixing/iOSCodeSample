//
//  CDropdownListItemView.m
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "CDropdownListItemView.h"

@implementation CDropdownListItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)RemoveAllItems
{
	int nCount = (int)self.subviews.count;
	if(0 < nCount)
	{
		for(int i = nCount-1; 0 <= i; --i)
		{
			UIView* subView = [self.subviews objectAtIndex:i];
			[subView removeFromSuperview];
		}
        [self UpdateLayout];
	}
}

-(void)UnselectedAllItems
{
	int nCount = (int)self.subviews.count;
	if(0 < nCount)
	{
		for(int i = nCount-1; 0 <= i; --i)
		{
			UIView* subView = [self.subviews objectAtIndex:i];
			if([subView isKindOfClass:[CDropdownListItem class]] == YES)
            {
                [((CDropdownListItem*)subView) SetSelectState:NO];
            }
		}
	}
}

-(int)GetItemCount
{
	int nCount = (int)self.subviews.count;
    
    return nCount;
}

-(void)AddItem:(CDropdownListItem*)item
{
	float oldHeight = [self GetContentHeight];
	CGRect cellrt = item.frame;
    cellrt.origin.x = 0;//rect.origin.x;
    cellrt.origin.y = oldHeight;
	[item setFrame:cellrt];
    
    [self addSubview:item];
    
    [self UpdateLayout];
	int nCount = (int)self.subviews.count;
	if(0 < nCount)
	{
		for(int i = nCount-1; 0 <= i; --i)
		{
			UIView* subView = [self.subviews objectAtIndex:i];
			if([subView isKindOfClass:[CDropdownListItem class]] == YES)
            {
                [((CDropdownListItem*)subView) setNeedsDisplay];
            }
		}
	}
}

-(void)UpdateLayout
{
	CGRect rect = self.frame;
	float h = [self GetContentHeight];
	rect.size.height = h;
	[self setFrame: rect];
}

-(float)GetContentHeight
{
	float fRet = 0.0;
	
	int nCount = (int)self.subviews.count;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			CDropdownListItem* pItem = (CDropdownListItem*)[self.subviews objectAtIndex:i];
			if(pItem != nil)
			{
				fRet += pItem.frame.size.height;
			}
		}
	}
	return fRet;
}

-(void)SetSelectedItem:(int)nItemID
{
	int nCount = (int)self.subviews.count;
	if(0 < nCount)
	{
		for(int i = nCount-1; 0 <= i; --i)
		{
			UIView* subView = [self.subviews objectAtIndex:i];
			if([subView isKindOfClass:[CDropdownListItem class]] == YES)
            {
                if([((CDropdownListItem*)subView) GetItemID] == nItemID)
                {
                    [((CDropdownListItem*)subView) SetSelectState:YES];
                }
                else
                {
                    [((CDropdownListItem*)subView) SetSelectState:NO];
                }
            }
		}
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
