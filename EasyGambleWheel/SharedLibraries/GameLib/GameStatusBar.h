//
//  GameStatusBar.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface GameStatusBar : UIView
{
    UILabel*                m_Text;
}

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(void)UpdateViewLayout;
-(void)SetText:(NSString*)text;

@end
