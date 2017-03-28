//
//  NOMGEOPlanPanelBar.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-27.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NOMGEOPlanPanelBar : UIView

-(void)UpdateLayout;
-(void)AddChild:(UIView*)child;

-(void)Open;
-(void)Close;

@end
