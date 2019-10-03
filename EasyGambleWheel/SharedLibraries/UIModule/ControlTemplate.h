/*
 *  ControlTemplate.h
 *  xxxxxxxx
 *
 *  Created by Zhaohui Xing on 11-02-28.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
@import UIKit;

@protocol MenuItemTemplate <NSObject>

-(void)AssignMenuID:(int)nID;
-(int)GetMenuID;
-(void)OnMenuUpdate;
-(void)Show;
-(void)Hide;
-(void)SetSize:(float)w withHeight:(float)h;
-(float)GetWidth;
-(float)GetHeight;
-(void)Selected;
-(void)UnSelected;
-(void)Enable:(BOOL)bEnable;
-(BOOL)IsEnable;
-(void)Checkable:(BOOL)bCheckable;
-(BOOL)IsCheckable;
-(void)SetChecked:(BOOL)bChecked;
-(BOOL)IsChecked;

@end

//The menu item container interface
@protocol MenuHolderTemplate <NSObject>

-(void)AssignControlID:(int)nID;
-(int)GetControlID;
-(void)Show;
-(void)Hide;
-(void)GetMenuItemCount;
-(id<MenuItemTemplate>)GetMenuItemAt:(int)index;
-(id<MenuItemTemplate>)GetMenuItem:(int)nControlID;
-(void)SetPopupPosition:(float)x withY:(float)y;
-(void)UnSelectedAllMenuItems;
-(void)OnMenuEvent:(int)menuID;
-(void)SetVerticalDirection;
-(void)SetHorizontalDirection;
-(void)OnMenuItemShow:(int)menuID;
-(void)OnMenuItemHide:(int)menuID;

@end

@protocol MenuControlTemplate <NSObject>

-(void)AssignControlID:(int)nID;
-(int)GetControlID;
-(void)Show;
-(void)Hide;
-(void)SetVerticalDirection;
-(void)SetHorizontalDirection;

@end

@protocol TitleBarTemplate <NSObject>

-(void)AssignControlID:(int)nID;
-(int)GetControlID;
-(void)OnOrientationChange;

@end

@protocol MenuViewTemplate <NSObject>

-(void)AssignControlID:(int)nID;
-(int)GetControlID;

//The handler for close button event
-(void)OnCloseEvent:(id)sender;
-(void)OnMenuEvent:(int)menuID;
-(void)OnOrientationChange;
-(CGPoint)GetViewCenter;
-(CGSize)GetViewSize;;
-(void)OnMenuHide;
-(void)OnMenuShow;


@end



