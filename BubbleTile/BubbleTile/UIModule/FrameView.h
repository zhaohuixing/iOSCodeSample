//
//  FrameView.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FrameView : UIView 
{
	UIButton*				m_CloseButton;
}

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(void)UpdateViewLayout;
-(float)GetCloseButtonSize;
-(BOOL)IsOpened;
-(void)drawBackground:(CGContextRef)context inRect:(CGRect)rect;

-(void)ShowHideCloseButton:(BOOL)bShow;

@end
