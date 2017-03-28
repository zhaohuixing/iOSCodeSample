//
//  MenuFactory.h
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-11.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainMenuController.h"

@interface MenuFactory : NSObject

+(void)CreateSearchMenu:(UIView *)parentView withController:(MainMenuController *)controller inArchor:(CGPoint)pt withPoistion:(float)ratio;
+(void)CreatePostMenu:(UIView *)parentView withController:(MainMenuController *)controller inArchor:(CGPoint)pt withPoistion:(float)ratio;
+(void)CreateSettingMenu:(UIView *)parentView withController:(MainMenuController *)controller inArchor:(CGPoint)pt withPoistion:(float)ratio;


@end
