//
//  GlossyMenu.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControlTemplate.h"
#import "GlossyMenuItem.h"

@interface GlossyMenu : NSObject<MenuHolderTemplate> 
{
	int								m_nMenuID;
	NSMutableArray*					m_MenuItems;
	id<MenuViewTemplate>			m_Parent;
    BOOL							m_bShow;
	int								m_nFrameIndex;
}

-(id)initByParent:(id<MenuViewTemplate>)pView;
-(void)AddMenuItem:(GlossyMenuItem*)item;
-(void)AssignControlID:(int)nID;
-(int)GetControlID;
-(void)Show;
-(void)Hide;
-(int)GetMenuItemCount;
-(id<MenuItemTemplate>)GetMenuItemAt:(int)index;
-(id<MenuItemTemplate>)GetMenuItem:(int)nControlID;
-(void)SetPopupPosition:(float)x withY:(float)y;
-(void)UnSelectedAllMenuItems;
-(void)OnMenuEvent:(int)menuID;
-(void)SetVerticalDirection;
-(void)SetHorizontalDirection;
-(void)OnMenuItemShow:(int)menuID;
-(void)OnMenuItemHide:(int)menuID;

-(void)FadeIn;
-(void)FadeOut;
-(void)Reset;
-(void)SetMenuItem:(int)index atCenter:(CGPoint)pt;
-(void)SetMenuItemGroundZero:(int)index atPoint:(CGPoint)pt;

-(void)RemoveMenuItem:(int)nMenuID;
@end
