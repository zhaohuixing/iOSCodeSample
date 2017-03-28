//
//  MainToolbarView.h
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-04.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ToolbarButton.h"

@interface MainToolbarView : UIView
{
	UIButton*                   m_SearchButton;
	UIButton*                   m_PostButton;
    UIButton*                   m_SettingButton;
    
    
    float               m_ButtonWidth;
}

-(CGPoint)GetSearchButtonArchorPoint;
-(CGPoint)GetPostButtonArchorPoint;
-(CGPoint)GetCalenderButtonArchorPoint;
-(CGPoint)GetFavoriteButtonArchorPoint;
-(CGPoint)GetSettingButtonArchorPoint;

- (void)UpdateLayout;

@end
