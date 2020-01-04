//
//  BubbleTileAppDelegate.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "ApplicationConfigure.h"
#import "ApplicationController.h"
#import "Mobclix.h"
#import "BubbleTileAppDelegate.h"

@implementation BubbleTileAppDelegate


@synthesize window=_window;

- (void)RemoveAllCachedData
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) 
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }    
    
    NSString* tempPath = NSTemporaryDirectory();
    NSArray*  tempContents = [[NSFileManager defaultManager] subpathsAtPath:tempPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(tempContents) 
    {	
        for (int i = 0; i < [tempContents count]; ++i) 
        {
            NSString *tempFile = [NSString stringWithFormat:@"%@%@", tempPath, [tempContents objectAtIndex:i]];
            [fileManager removeItemAtPath:tempFile error:nil];
        }    
    }    
}

- (void)ClearDownloadFolder
{
    [BTFileManager ClearInboxFolder];
}

-(NSURL*)HandleLaunchFileFromOtherToBTFileSystem:(NSURL *)url saveToCache:(BOOL)bCopyToCache
{
    NSURL* localFile = [BTFileManager CopyLaunchFileToBTFileSystem:url saveToCache:bCopyToCache];
    
    return localFile;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    m_bLoadOpenFileURL = NO;
    /*NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if(url == nil || ![url isFileURL])
    {    
        m_bLoadOpenFileURL = NO;
	}
    else 
    {
        m_bLoadOpenFileURL = YES;
        //[self HandleLaunchFileFromOtherToBTFileSystem:url saveToCache:YES];
    }*/
    
    ApplicationController* controller = [[ApplicationController alloc] init];
    viewController = (UIViewController *)controller;
	[self.window addSubview:controller.view];
    
    [self.window makeKeyAndVisible];
	[Mobclix startWithApplicationId:[ApplicationConfigure GetMobClixPublishKey]];
    [self InitializeFacebookInstance];
    [self RemoveAllCachedData];
    
    m_bUpdateOrientation = NO;
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString* sScheme = [url scheme];
    if([sScheme rangeOfString:@"fb"].location != NSNotFound || [sScheme rangeOfString:@"fbauth"].location != NSNotFound || [sScheme isEqualToString:@"fbauth2"])
        return [super handleOpenURL:url];
    
    NSURL* newFile = [self HandleLaunchFileFromOtherToBTFileSystem:url saveToCache:NO];
    if(newFile)
    {
        ApplicationController* controller = (ApplicationController*)viewController;
        if(controller)
        {
            [controller StartGameFromFile:newFile]; 
        }
    }
    [self ClearDownloadFolder];
    m_bLoadOpenFileURL = NO;
    return YES;
}    

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    NSString* sScheme = [url scheme];
    if([sScheme rangeOfString:@"fb"].location != NSNotFound || [sScheme rangeOfString:@"fbauth"].location != NSNotFound || [sScheme isEqualToString:@"fbauth2"])
        return [super handleOpenURL:url];
    
    NSURL* newFile = [self HandleLaunchFileFromOtherToBTFileSystem:url saveToCache:NO];
    if(newFile)
    {
        ApplicationController* controller = (ApplicationController*)viewController;
        if(controller)
        {
            [controller StartGameFromFile:newFile]; 
        }
    }
    [self ClearDownloadFolder];
    m_bLoadOpenFileURL = NO;
    return YES;
}

- (UIViewController *)MainViewController
{
    return viewController;
}

- (id<AdRequestHandlerDelegate>)GetAdRequestHandler
{
    return (id<AdRequestHandlerDelegate>)viewController;
}

- (Facebook*)GetFacebookInstance
{
    return m_Facebook;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    ApplicationController* controller = (ApplicationController*)viewController;
    if(controller)
    {
        [controller SaveUnfinishedGameToCacheFile]; 
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    ApplicationController* controller = (ApplicationController*)viewController;
    [controller RecheckShutdownConfigure];
    if([ApplicationConfigure ShouldShutdownGame] == YES)
    {    
        [controller.view removeFromSuperview];
        [controller release];
        viewController = nil;
    }    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    if(viewController == nil)
    {    
        ApplicationController* controller = [[ApplicationController alloc] init];
        viewController = (UIViewController *)controller;
        [self.window addSubview:controller.view];
        [self.window makeKeyAndVisible];
        m_bUpdateOrientation = YES;
    }
    else
    {
        m_bUpdateOrientation = NO;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if(m_bUpdateOrientation == YES)
    {    
        ApplicationController* controller = (ApplicationController*)viewController;
        if([controller.view respondsToSelector:@selector(OnOrientationChange)])
        {
            [controller.view performSelector:@selector(OnOrientationChange)]; 
            [controller.view performSelector:@selector(UpdateSubViewsOrientation)];
        }
        m_bUpdateOrientation = NO;
    }    
    [self RemoveAllCachedData];
    [self ClearDownloadFolder];
    m_bLoadOpenFileURL = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self RemoveAllCachedData];
}

- (void)dealloc
{
    [viewController release];     
    [_window release];
    //if(m_Facebook != nil)
    //    [m_Facebook release];
    [super dealloc];
}

@end
