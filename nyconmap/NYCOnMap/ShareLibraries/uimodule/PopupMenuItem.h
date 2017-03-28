//
//  PopupMenuItem.h
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-09.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupMenu;
@class PopupMenuContainerView;

@interface PopupMenuItem : UIView
{
@private
    PopupMenuContainerView*             m_RootContainer;
    PopupMenu*                          m_ChildMenu;

    int                                 m_nMenuID;

    UILabel*                            m_Title;
	BOOL                                m_bSelected;
    
    CGImageRef                          m_Icon;
    BOOL                                m_bCenter;
    
    CGGradientRef                       m_Gradient;
    CGColorSpaceRef                     m_Colorspace;
}

-(void)RegisterControllers:(PopupMenuContainerView*)rootContainer;
-(void)RegisterMenuID:(int)nID;
-(int)GetMenuID;
-(void)SetChildMenu:(PopupMenu*)childMenu;
-(void)OpenChildMenu;
-(void)SetSelectState:(BOOL)bSelected;
-(void)ResetSelectState;
-(void)UpdateForSelectionChange;
-(void)SetLabel:(NSString*)text;
-(void)SetImage:(CGImageRef)imageResource inCenter:(BOOL)bCenter;
-(void)SetLineNumber:(int)nLine;
-(void)SetLabeLFontSize:(float)fSize;


@end
