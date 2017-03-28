//
//  PopupMenuContainerView.h
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-06.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupMenu;
@class TwoStateButton;

@protocol PopupMenuDelegate <NSObject>

-(void)CloseMenu:(int)nMenuID;

@end


@interface PopupMenuContainerView : UIView
{
    int                     m_nMenuID;
    
    CGPoint                 m_ArchorPoint;

    TwoStateButton*         m_CloseButton;

    CGGradientRef           m_Gradient;
    CGColorSpaceRef         m_Colorspace;

    id<PopupMenuDelegate>     m_Controller;
    
    PopupMenu*              m_RootMenu;
    PopupMenu*              m_CurrentDisplayMenu;
  
    CGImageRef          m_UpSign;
    CGImageRef          m_DownSign;
}

+(float)GetContainerViewMaxHeight;
+(float)GetContainerViewWidth;
+(float)GetAchorSize;
+(float)GetCornerSize;
+(float)GetMenuItemWidth;
+(float)GetMenuItemHeight;
+(int)GetMaxDisplayMenuItemNumber;
+(int)GetMinDisplayMenuItemNumber;


-(void)Register:(int)nMenu withArchor:(CGPoint)archorPoint withController:(id<PopupMenuDelegate>)controller;
-(void)UpdateLayout;
-(float)GetLayoutWidth;
-(float)GetLayoutHeight;
-(void)CloseButtonClick;
-(int)GetMenuID;

-(void)OpenMenu:(PopupMenu*)menu;
-(void)OpenRootMenu;

-(void)SetRootMenu:(PopupMenu*)rootMenu;
-(PopupMenu*)GetRootMenu;
-(void)SetCurrentMenu:(PopupMenu*)menu;
-(void)AddMenu:(PopupMenu*)menu;

-(void)SetArchor:(CGPoint)archorPoint;
@end
