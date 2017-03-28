//
//  AppDelegate.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-13.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <XZCareCore/XZCareCore.h>

@interface XZCareOneDownDelegate : XZCareCoreAppDelegate

//@property (strong, nonatomic) UIWindow *window;

-(NSArray*)getAppMainStoryboardInfo;

-(void)ShowOnBoarding;

- (void)startActivityTrackerTask;
- (NSInteger)fitnessDaysShowing:(XZCareFitnessDaysShows)showKind;


@end

