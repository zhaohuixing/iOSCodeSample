//
//  CustomStatusBar.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-30.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomStatusBar : UIView

-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(void)UpdateLayout;
-(void)SetText:(NSString*)text;

-(void)StartAutoDisplay:(int)showSecond;

@end
