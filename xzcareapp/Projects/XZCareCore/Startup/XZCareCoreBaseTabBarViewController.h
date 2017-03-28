//
//  XZCareCoreBaseTabBarViewController.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-14.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZCareUICore/XZCarePasscodeViewController.h>

@interface XZCareCoreBaseTabBarViewController : UITabBarController

@property (nonatomic) BOOL showPasscodeScreen;
@property (nonatomic, weak) id<XZCarePasscodeViewControllerDelegate> passcodeDelegate;

@end
