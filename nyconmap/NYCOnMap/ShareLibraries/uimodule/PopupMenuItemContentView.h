//
//  PopupMenuItemContentView.h
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-10.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupMenuItem;

@interface PopupMenuItemContentView : UIView

-(int)GetMenuItemCount;
-(void)AddMenuItem:(PopupMenuItem*)item;
-(float)GetContentHeight;
-(void)UpdateLayoutHeight;
@end
