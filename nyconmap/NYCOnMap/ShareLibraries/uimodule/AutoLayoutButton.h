//
//  AutoLayoutButton.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-27.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface AutoLayoutButton : UIButton

-(void)UpdateLayout:(BOOL)bProtrait;
-(void)SetProtraitLayout:(CGRect)rect;
-(void)SetLandScapeLayout:(CGRect)rect;


@end
