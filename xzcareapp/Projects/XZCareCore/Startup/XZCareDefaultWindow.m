//
//  XZCareDefaultWindow.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-15.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <XZCareCore/XZCareCore.h>

@interface XZCareDefaultWindow ()

@property (strong, nonatomic) XZCareParametersDashboardTableViewController *controller;

@end

@implementation XZCareDefaultWindow

- (void)motionEnded:(UIEventSubtype) __unused motion withEvent:(UIEvent *)event
{
    if (self.enableDebuggerWindow)
    {
        if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceShaken" object:self];
            
            [self presentModalViewController];
        }
    }
}

- (void)presentModalViewController
{
    if (!self.toggleDebugWindow)
    {
        self.controller = [[UIStoryboard storyboardWithName:kXZCareCoreParametersStoryboard bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:kXZCareCoreParametersControlIdentifier];
        self.controller.view.frame = [[UIScreen mainScreen] bounds];
        
        [self addSubview:self.controller.view];
        self.toggleDebugWindow = YES;
    }
    else
    {
        [self.controller.view removeFromSuperview];
        [self.controller removeFromParentViewController];
        self.toggleDebugWindow = NO;
    }
}

@end
