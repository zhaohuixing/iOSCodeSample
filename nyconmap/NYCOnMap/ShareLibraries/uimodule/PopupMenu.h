//
//  PopupMenu.h
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-09.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupMenuItemContentView;
@class PopupMenu;
@class PopupMenuContainerView;
@class PopupMenuItem;

@interface PopupMenu : UIScrollView<UIScrollViewDelegate>
{
    PopupMenu*                          m_Parent;
    PopupMenuContainerView*             m_RootContainer;
    
    PopupMenuItemContentView*           m_MenuItemContentView;

    int                                 m_nMenuID;
}

-(void)RegisterParent:(PopupMenu*)pParent withController:(PopupMenuContainerView*)controller;
-(void)RegisterMenuID:(int)nID;
-(int)GetMenuID;

-(int)GetMenuItemCount;

-(float)GetMenuHeight;
-(float)GetMenuWidth;
-(float)GetAllItemHeight;

-(void)GotoParentMenu;

-(BOOL)IsRootMenu;

-(void)AddMenuItem:(PopupMenuItem*)item;

-(void)UpdateLayout;

@end
