//
//  CustomMapViewPinItemListView.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-17.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "CustomMapViewPinItemListView.h"

@implementation CustomMapViewPinItemListView

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
	int nCount = self.subviews.count;
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
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = nCount-1; 0 <= i; --i)
		{
			UIView* subView = [self.subviews objectAtIndex:i];
			if([subView isKindOfClass:[CustomMapViewPinItem class]] == YES)
            {
                [((CustomMapViewPinItem*)subView) SetSelectState:NO];
            }
		}
	}
}

-(int)GetItemCount
{
	int nCount = self.subviews.count;

    return nCount;
}

-(void)AddItem:(CustomMapViewPinItem*)item
{
	float oldHeight = [self GetContentHeight];
	CGRect cellrt = item.frame;
    cellrt.origin.x = 0;//rect.origin.x;
    cellrt.origin.y = oldHeight;
	[item setFrame:cellrt];
    
    [self addSubview:item];
    
    [self UpdateLayout];
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
	
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			CustomMapViewPinItem* pItem = (CustomMapViewPinItem*)[self.subviews objectAtIndex:i];
			if(pItem != nil)
			{
				fRet += pItem.frame.size.height;
			}
		}
	}
	return fRet;
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
