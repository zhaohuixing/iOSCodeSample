//
//  AppDelegate_iPhone.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright xgadget 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StdAdPostAppDelegate.h"

@interface AppDelegate_iPhone : StdAdPostAppDelegate 
{
    UIViewController *viewController;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (UIViewController *)MainViewController;
- (id<AdRequestHandlerDelegate>)GetAdRequestHandler;
- (Facebook*)GetFacebookInstance;

@end

