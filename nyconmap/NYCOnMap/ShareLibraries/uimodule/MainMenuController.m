//
//  MainMenuController.m
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-10.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "MainMenuController.h"
#import "PopupMenuContainerView.h"

@implementation MainMenuController

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        m_MenuList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)AddMenu:(PopupMenuContainerView *)menu
{
    if(menu != nil && m_MenuList != nil)
    {
        [m_MenuList addObject:menu];
        [self CloseMenu:[menu GetMenuID]];
    }
}

-(void)CloseMenu:(int)menuID
{
    if(m_MenuList != nil && 0 < [m_MenuList count] && 0 <= menuID)
    {
        for(int i = 0; i < [m_MenuList count]; ++i)
        {
            PopupMenuContainerView *menu = [m_MenuList objectAtIndex:i];
            if(menu != nil && [menu GetMenuID] == menuID)
            {
                menu.hidden = YES;
                [menu.superview sendSubviewToBack:menu];
            }
        }
    }
}

-(void)CloseAllMenus
{
    if(m_MenuList != nil && 0 < [m_MenuList count])
    {
        for(int i = 0; i < [m_MenuList count]; ++i)
        {
            PopupMenuContainerView *menu = [m_MenuList objectAtIndex:i];
            if(menu != nil)
            {
                menu.hidden = YES;
                [menu.superview sendSubviewToBack:menu];
            }
        }
    }
}

-(void)OpenMenu:(int)menuID
{
    [self CloseAllMenus];
    if(m_MenuList != nil && 0 < [m_MenuList count] && 0 <= menuID)
    {
        for(int i = 0; i < [m_MenuList count]; ++i)
        {
            PopupMenuContainerView *menu = [m_MenuList objectAtIndex:i];
            if(menu != nil && [menu GetMenuID] == menuID)
            {
                menu.hidden = NO;
                [menu.superview bringSubviewToFront:menu];
                [menu OpenRootMenu];
            }
        }
    }
}

-(PopupMenuContainerView*)GetMenu:(int)menuID
{
    PopupMenuContainerView* pMenu = nil;
    if(m_MenuList != nil && 0 < [m_MenuList count] && 0 <= menuID)
    {
        for(int i = 0; i < [m_MenuList count]; ++i)
        {
            PopupMenuContainerView *menu = [m_MenuList objectAtIndex:i];
            if(menu != nil && [menu GetMenuID] == menuID)
            {
                return menu;
            }
        }
    }
    return pMenu;
}


@end
