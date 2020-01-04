//
//  MenuItemBase.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ControlTemplate.h"

@interface MenuItemBase : UIView <MenuItemTemplate> 
{
	int								m_nMenuID;
	BOOL							m_bEnable;
	BOOL							m_bSelected;
	BOOL							m_bCheckable;
	BOOL							m_bChecked;
	id<MenuHolderTemplate>			m_Container;
}

-(id)initWithMeueID:(int)nID withFrame:(CGRect)frame withContainer:(id<MenuHolderTemplate>)p; 
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
