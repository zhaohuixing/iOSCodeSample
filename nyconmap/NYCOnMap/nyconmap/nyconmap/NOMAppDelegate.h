//
//  NOMAppDelegate.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController*  viewController;

-(id)GetDocumentController;

@end
