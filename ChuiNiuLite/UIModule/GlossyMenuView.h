//
//  GlossyMenuView.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlossyMenu.h"

@interface GlossyMenuView : UIView<MenuViewTemplate> 
{
	GlossyMenu*			m_Menu;
	BOOL				m_bMenuShow;
}

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

-(void)AddMenuItem:(GlossyMenuItem*)item;
-(void)UpdateMenuLayout;
@end
