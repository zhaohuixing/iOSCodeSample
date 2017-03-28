//
//  MainMenuController.h
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-10.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopupMenuContainerView.h"

@interface MainMenuController : NSObject <PopupMenuDelegate>
{
    NSMutableArray*     m_MenuList;
}

-(void)AddMenu:(PopupMenuContainerView *)menu;
-(void)CloseMenu:(int)menuID;
-(void)CloseAllMenus;
-(void)OpenMenu:(int)menuID;
-(PopupMenuContainerView*)GetMenu:(int)menuID;

@end
