//
//  PopupMenuItemContentView.m
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-10.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "PopupMenuItem.h"
#import "PopupMenuItemContentView.h"
#import "ImageLoader.h"

@implementation PopupMenuItemContentView

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

-(int)GetMenuItemCount
{
    int nRet = [[self subviews] count];
    return nRet;
}

-(void)AddMenuItem:(PopupMenuItem*)item
{
	//CGRect rect = self.frame;
	float oldHeight = [self GetContentHeight];
	CGRect cellrt = item.frame;
    cellrt.origin.x = 0;//rect.origin.x;
    cellrt.origin.y = oldHeight;
	[item setFrame:cellrt];
    
    [self addSubview:item];
 
	[self UpdateLayoutHeight];
}

-(float)GetContentHeight
{
	float fRet = 0.0;
	
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			PopupMenuItem* pItem = (PopupMenuItem*)[self.subviews objectAtIndex:i];
			if(pItem != nil)
			{
				fRet += pItem.frame.size.height;
			}
		}
	}
	return fRet;
}

-(void)UpdateLayoutHeight
{
	CGRect rect = self.frame;
	float h = [self GetContentHeight];
	rect.size.height = h;
	[self setFrame: rect];
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
