//
//  PopupMenu.m
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-09.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "PopupMenu.h"
#import "PopupMenuItemContentView.h"
#import "PopupMenuContainerView.h"
#import "PopupMenuItem.h"

@implementation PopupMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_MenuItemContentView = [[PopupMenuItemContentView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:m_MenuItemContentView];
        m_nMenuID = -1;
        m_Parent = nil;
        m_RootContainer = nil;
    }
    return self;
}

-(void)RegisterParent:(PopupMenu*)pParent withController:(PopupMenuContainerView*)controller
{
    m_Parent = pParent;
    m_RootContainer = controller;
}

-(void)RegisterMenuID:(int)nID
{
    m_nMenuID = nID;
}

-(int)GetMenuID
{
    return m_nMenuID;
}

-(int)GetMenuItemCount
{
    return [m_MenuItemContentView GetMenuItemCount];
}

-(float)GetMenuHeight
{
    int nCount = [self GetMenuItemCount];
    if(nCount < [PopupMenuContainerView GetMinDisplayMenuItemNumber])
        nCount = [PopupMenuContainerView GetMinDisplayMenuItemNumber];

    if([PopupMenuContainerView GetMaxDisplayMenuItemNumber] < nCount)
        nCount = [PopupMenuContainerView GetMaxDisplayMenuItemNumber];
    
    float h = nCount*[PopupMenuContainerView GetMenuItemHeight];
    
    return h;
}

-(float)GetAllItemHeight
{
    int nCount = [self GetMenuItemCount];
    float h = nCount*[PopupMenuContainerView GetMenuItemHeight];
    return h;
}

-(float)GetMenuWidth
{
    float w = [PopupMenuContainerView GetMenuItemWidth];
    
    return w;
}

-(void)GotoParentMenu
{
    if(m_Parent != nil && m_RootContainer != nil)
    {
        [m_RootContainer OpenMenu:m_Parent];
    }
}

-(BOOL)IsRootMenu
{
    if(m_Parent == nil)
        return YES;
    
    return NO;
}

-(void)AddMenuItem:(PopupMenuItem*)item
{
    if(m_MenuItemContentView != nil)
    {
        [item RegisterControllers:m_RootContainer];
        [m_MenuItemContentView AddMenuItem:item];
    }
}

-(void)UpdateLayout
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// A UIScrollView delegate callback, called when the user starts zooming.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return m_MenuItemContentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGPoint	p = scrollView.contentOffset;
	NSLog(@"x = %f, y = %f", p.x, p.y);
	[self setNeedsDisplay];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	return NO;
}


@end
