//
//  AppDelegate_iPhone.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright xgadget 2010. All rights reserved.
//
//#include "libinc.h"
//#import "MainUIController.h"
#import "AppDelegate_iPhone.h"
#import "ApplicationController.h"
#import "AdConfiguration.h"
#import "Mobclix.h"
#import "ApplicationConfigure.h"

@implementation AppDelegate_iPhone

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.
    [ApplicationConfigure SetActiveDeviceType:APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE];
    ApplicationController* controller = [[ApplicationController alloc] init];
    viewController = (UIViewController *)controller;
	[window addSubview:controller.view];
	//[controller.view release];
	
    
	[window makeKeyAndVisible];
	[Mobclix startWithApplicationId:[AdConfiguration GetMobClixPublishKey]];
    [self InitializeFacebookInstance];
	return YES;
}

- (UIViewController *)MainViewController
{
    return viewController;
}

- (void)RemoveAllCachedData
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) 
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }    
}

- (id<AdRequestHandlerDelegate>)GetAdRequestHandler
{
    return (id<AdRequestHandlerDelegate>)viewController;
}

- (Facebook*)GetFacebookInstance
{
    return m_Facebook;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [super handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    return [super handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    /*ApplicationController* controller = (ApplicationController*)viewController;
    if(controller && [controller canPerformAction:@selector(ShutdownLobby) withSender:nil] == YES)
    {
        [controller ShutdownLobby];
    }*/
}


- (void)applicationDidEnterBackground:(UIApplication *)application 
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    ApplicationController* controller = (ApplicationController*)viewController;
    if(controller && [controller canPerformAction:@selector(ShutdownLobby) withSender:nil] == YES)
    {
        [controller ShutdownLobby];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application 
{
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    ApplicationController* controller = (ApplicationController*)viewController;
    if(controller && [controller canPerformAction:@selector(ShutdownLobby) withSender:nil] == YES)
    {
        [controller ShutdownLobby];
    }
    if(controller)
    {
        [controller.view setNeedsDisplay];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application 
{
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    ApplicationController* controller = (ApplicationController*)viewController;
    if(controller)
    {
        [controller.view setNeedsDisplay];
    }
    [self RemoveAllCachedData];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
    [window release];
    [viewController release];
    [super dealloc];
}


@end
