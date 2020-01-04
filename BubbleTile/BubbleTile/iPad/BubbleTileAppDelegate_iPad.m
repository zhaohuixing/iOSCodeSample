//
//  BubbleTileAppDelegate_iPad.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BubbleTileAppDelegate_iPad.h"
#import "ApplicationConfigure.h"

@implementation BubbleTileAppDelegate_iPad

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [ApplicationConfigure SetActiveDeviceType:APPLICATION_ACTIVE_DEVICE_TYPE_IPAD];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)dealloc
{
	[super dealloc];
}

@end
