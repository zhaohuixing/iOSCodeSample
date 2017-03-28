//
//  CDropdownListDisplayView.m
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "CDropdownListDisplayView.h"
#import "NOMGUILayout.h"

@implementation CDropdownListDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        float h = [NOMGUILayout GetDefaultTextEditorButtonHeight];
        CGRect rect = CGRectMake(0, 0, frame.size.width, h);
        m_ListItemView = [[CDropdownListItemView alloc] initWithFrame:rect];
        [self addSubview:m_ListItemView];
    }
    return self;
}

-(int)GetItemsCount
{
    int nCount = 0;
    
    if(m_ListItemView != nil)
    {
        nCount = [m_ListItemView GetItemCount];
    }
    
    return nCount;
}

-(float)GetItemsWidth
{
    float w = 0.0;
    if(m_ListItemView != nil)
    {
        w = m_ListItemView.frame.size.width;
    }
    return w;
}

-(float)GetItemsHeight
{
    float h = 0.0;
    if(m_ListItemView != nil)
    {
        h = [m_ListItemView GetContentHeight];
    }
    return h;
}

-(void)AddItem:(CDropdownListItem*)item
{
    if(m_ListItemView != nil)
    {
        [m_ListItemView AddItem:item];
    }
}

-(void)SetSelectedItem:(int)nItemID
{
    if(m_ListItemView != nil)
    {
        [m_ListItemView SetSelectedItem:nItemID];
    }
}

-(void)UpdateLayout
{
    if(m_ListItemView != nil)
    {
        float height = [m_ListItemView GetContentHeight];
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, height);
        [m_ListItemView setFrame:rect];
        [m_ListItemView UpdateLayout];
        [self setContentSize:CGSizeMake(self.frame.size.width, height)];
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
