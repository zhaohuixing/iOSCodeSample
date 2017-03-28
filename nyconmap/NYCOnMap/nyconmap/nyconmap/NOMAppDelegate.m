//
//  NOMAppDelegate.m
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMAppDelegate.h"
#import "NOMViewController.h"
#import "NOMMainView.h"
#import "NOMGUILayout.h"
#import "NOMAppInfo.h"
#import "NOMPreference.h"
#import "AmazonClientManager.h"
#import "DrawHelper2.h"
#import "NOMDataEncryptionHelper.h"
#import "NOMDocumentController.h"
#import "NOMAppWatchConstants.h"

#ifdef USING_TOMTOMSDK
#import "TTServiceManager.h"
#endif

@interface NOMAppDelegate ()
{
    NOMDocumentController*      m_DocumentController;
    BOOL                        m_bEssentialInitialized;
}

@end


@implementation NOMAppDelegate

@synthesize viewController = _viewController;

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_DocumentController = nil;
        m_bEssentialInitialized = NO;
    }
    return self;
}

-(id)GetDocumentController
{
    return m_DocumentController;
}

- (void)essentialInitialization
{
    if(m_bEssentialInitialized == NO)
    {
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        [NOMAppInfo InitializeSystemConfiguration];
        //Initalize AWS service access
        [[AmazonClientManager GetSharedManager] InitializeAccess];
        
        //Initialize Document Controller
        m_DocumentController = [[NOMDocumentController alloc] init];
        [NOMGUILayout SetGlobalDocumentController:m_DocumentController];
        m_bEssentialInitialized = YES;
        [m_DocumentController SetCloudInitializationPause:NO];
        if([m_DocumentController IsCloudServiceInitialized] == NO)
        {
             [m_DocumentController InitializeCloudService];
        }
    }
}


- (void)intializeViewController
{
#ifdef USING_TOMTOMSDK
    [TTServiceManager RegisterTTService];
#endif
    [NOMDataEncryptionHelper InitializeEncryption];
    [NOMAppInfo InitializeSystemConfiguration];
    [DrawHelper2 InitializeResource];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    if(m_bEssentialInitialized == NO)
    {
        //Initalize AWS service access
        [[AmazonClientManager GetSharedManager] InitializeAccess];

        //Initialize Document Controller
        m_DocumentController = [[NOMDocumentController alloc] init];
        [NOMGUILayout SetGlobalDocumentController:m_DocumentController];
        m_bEssentialInitialized = YES;
    }
   // [m_DocumentController SetCloudInitializationPause:NO];
   // if([m_DocumentController IsCloudServiceInitialized] == NO)
   // {
   //     [m_DocumentController InitializeCloudService];
   // }
    
    /*
    if([NOMAppInfo IsVersion8] == NO)
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // Override point for customization after application launch.
        self.viewController = (NOMViewController*)[[NOMViewController alloc] init] ;
        [NOMViewController RegisterGlobalController:(NOMViewController*)(self.viewController)];
        [NOMGUILayout SetRootViewController:self.viewController];

        [self.window addSubview:_viewController.view];
        self.window.rootViewController = _viewController;
        [self.window makeKeyAndVisible];
    }*/
 
    self.window.backgroundColor = [UIColor clearColor];
//    [NOMGUILayout SetRootViewController:self.viewController];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if(m_DocumentController == nil)
        [self intializeViewController];

 /*
    if(m_DocumentController != nil)
    {
        BOOL bAppActive = ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground);
        if(bAppActive)
            [m_DocumentController SendDebugMessageToAppleWatch:@"Application will activelly finish Launch from Apple Watch"];
        else
            [m_DocumentController SendDebugMessageToAppleWatch:@"Application will inactively finish Launch from Apple Watch"];
    }
    
    NSLog(@"will lauchOptions:%@", [launchOptions description]);
*/
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    BOOL bBackground = ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground);
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    if(m_DocumentController == nil)
    {
        if( bBackground == YES)
        {
            [self essentialInitialization];
        }
        else
        {
            [self intializeViewController];
        }
    }
    if(m_DocumentController != nil)
    {
        [m_DocumentController BroadcastContainerAppRunMode:bBackground];
    }
/*
    if(m_DocumentController != nil)
    {
        BOOL bAppActive = ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground);
        if(bAppActive)
            [m_DocumentController SendDebugMessageToAppleWatch:@"Application did actively finish Launch from Apple Watch"];
        else
            [m_DocumentController SendDebugMessageToAppleWatch:@"Application did finish Launch from Apple Watch in background"];
    }

    NSLog(@"did finish lauchOptions:%@", launchOptions);
*/
    application.applicationIconBadgeNumber = 0;
    
    if([NOMAppInfo IsVersion8] == YES)
    {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        else
        {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
        }
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NOMViewController* pViewController = (NOMViewController*)[NOMGUILayout GetRootViewController];
    if(pViewController != nil)
    {
        [pViewController ApplicationBecomeInActive];
    }
    if(m_DocumentController != nil)
    {
        [m_DocumentController BroadcastContainerAppRunMode:YES];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NOMViewController* pViewController = (NOMViewController*)[NOMGUILayout GetRootViewController];
    if(pViewController != nil)
    {
        [pViewController ApplicationBecomeActive];
    }
    if(m_DocumentController != nil)
    {
        [m_DocumentController BroadcastContainerAppRunMode:NO];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if(m_DocumentController != nil)
    {
        [m_DocumentController BroadcastContainerAppRunMode:YES];
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    //Convert deviceToken to String Type
    const char* data = [deviceToken bytes];
    NSMutableString* tokenString = [NSMutableString string];
    for (int i = 0; i < [deviceToken length]; i++)
    {
        [tokenString appendFormat:@"%02.2hhX", data[i]];
    }
    NSLog(@"deviceToken String: %@", tokenString);
    
    //[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"myDeviceToken"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    [[NOMPreference GetSharedPreference] SetAWSDeviceToken:(NSString*)tokenString];
   // [((NOMViewController*)_viewController) InitializeMobilePushEndPointARN];
}

// This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
//    [((NOMViewController*)self.viewController) InitializeMobilePushEndPointARN];
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to register with error : %@", error);
    if([NOMAppInfo IsOnSimulator] == YES)
    {
        [[NOMPreference GetSharedPreference] SetAWSDeviceToken:[NOMAppInfo GetSimulatorFakeToken]];
        //[((NOMViewController*)_viewController) InitializeMobilePushEndPointARN];
        NOMViewController* pViewController = (NOMViewController*)[NOMGUILayout GetRootViewController];
        if(pViewController != nil)
        {
            [pViewController InitializeMobilePushEndPointARN];
        }
    }
}

- (BOOL)HandleRemoteNotificationData:(NSDictionary *)userInfo
{
    BOOL bRet = NO;

    //NOMViewController* pViewController = (NOMViewController*)[NOMGUILayout GetRootViewController];
    //if(pViewController != nil)
    //{
    //    bRet = [pViewController HandleRemoteNotificationData:userInfo];
    //}
    if(m_DocumentController == nil)
        [self essentialInitialization];
    
    if(m_DocumentController != nil)
    {
        bRet = [m_DocumentController HandleRemoteNotificationData:userInfo];
    }
    
    return bRet;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    application.applicationIconBadgeNumber = 0;
//    NSString *msg = [NSString stringWithFormat:@"%@", userInfo];
//    NSLog(@"%@",msg);
//    [[Constants universalAlertsWithTitle:@"Push Notification Received" andMessage:msg] show];
    [self HandleRemoteNotificationData:userInfo];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [self HandleRemoteNotificationData:userInfo];
    completionHandler();
}

/*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
 
 This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    if([self HandleRemoteNotificationData:userInfo] == YES)
        completionHandler(UIBackgroundFetchResultNewData);
    else
        completionHandler(UIBackgroundFetchResultNoData);
}

//
//Apple Watch opening event
//
-(void)HandleAppleWatchOpenRequest:(NSMutableDictionary*)appData
{
/*
    NOMViewController* pViewController = (NOMViewController*)[NOMGUILayout GetRootViewController];
    if(pViewController != nil)
    {
        [pViewController HandleAppleWatchOpenRequest:appData];
    }
*/
    if(m_DocumentController == nil)
        [self essentialInitialization];

    if(m_DocumentController != nil)
    {
        [m_DocumentController HandleAppleWatchOpenRequest:appData];
    }
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply
{
    // Receives text input result from the WatchKit app extension.
#ifdef DEBUG
    NSLog(@"User Info: %@", userInfo);
#endif
    if(m_DocumentController == nil)
    {
        [self essentialInitialization];
    }
    
#ifdef DEBUG
    if(m_DocumentController != nil)
    {
        NSString* szMsg = [NSString stringWithFormat:@"Get Open Container APP request! User Info: %@", userInfo];
        [m_DocumentController SendDebugMessageToAppleWatch:szMsg];
    }
#endif

    //BOOL bAppActive = ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground);
    
    NSString* szAppOpenType = [userInfo objectForKey:EMSG_KEY_OPENCONTAINERAPP_ID];
    if(szAppOpenType != nil && [szAppOpenType isEqualToString:EMSG_MSG_INITIALIZE_OPEN_MAINAPP] == YES)
    {
#ifdef DEBUG
        [m_DocumentController SendDebugMessageToAppleWatch:@"Process Apple Watch Initialized Open Main App request"];
#endif
        NSMutableDictionary* appCurrentData = [[NSMutableDictionary alloc] init];
        [self HandleAppleWatchOpenRequest:appCurrentData];
        reply(appCurrentData);
    }
    else if(szAppOpenType != nil && [szAppOpenType isEqualToString:EMSG_ID_WATCH_ACTIONEVENT] == YES)
    {
#ifdef DEBUG
        [m_DocumentController SendDebugMessageToAppleWatch:@"Process Apple Watch Open Main App For action event request"];
#endif
        NSDictionary *messageObject = [userInfo objectForKey:EMSG_KEY_OPENCONTAINERAPP_MSG_ID];
        if(messageObject != nil && 0 < messageObject.count)
        {
            // The number is identified with the buttonNumber key in the message object
            NSNumber* pAction = [messageObject objectForKey:EMSG_KEY_ACTION];
            NSNumber* pChoice = [messageObject objectForKey:EMSG_KEY_ACTIONCHOICE];
            NSNumber* pOption = [messageObject objectForKey:EMSG_KEY_ACTIONOPTION];
            
            int16_t   nAction = (int16_t)[pAction intValue];
            int16_t   nChoice = (int16_t)[pChoice intValue];
            int16_t   nOption = (int16_t)[pOption intValue];
            
            if(nAction == NOM_WATCH_ACTION_SEARCH)
            {
                NSMutableDictionary* appCurrentData = [[NSMutableDictionary alloc] init];
                [appCurrentData setObject:pAction forKey:EMSG_KEY_ACTION];
#ifdef DEBUG
                [m_DocumentController SendDebugMessageToAppleWatch:@"Process Apple Watch Open Main App For nAction = NOM_WATCH_ACTION_SEARCH"];
#endif
                if(m_DocumentController != nil)
                {
                    [m_DocumentController HandleAppleWatchOpenRequestForSearch:appCurrentData withChoice:nChoice whithOption:nOption];
                }
                reply(appCurrentData);
                return;
            }
            else if(nAction == NOM_WATCH_ACTION_CHOICE_SPOT)
            {
                NSMutableDictionary* appCurrentData = [[NSMutableDictionary alloc] init];
                [appCurrentData setObject:pAction forKey:EMSG_KEY_ACTION];
#ifdef DEBUG
                [m_DocumentController SendDebugMessageToAppleWatch:@"Process Apple Watch Open Main App For nAction = NOM_WATCH_ACTION_CHOICE_SPOT"];
#endif
                NSNumber* pLatitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLATITUDE];
                NSNumber* pLongitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
                double   dLatiude = (double)[pLatitude doubleValue];
                double   dLongitude = (double)[pLongitude doubleValue];
                if(m_DocumentController != nil)
                {
                    [m_DocumentController HandleAppleWatchOpenRequestForPost:appCurrentData withChoice:nChoice whithOption:nOption atLatitude:dLatiude atLongitude:dLongitude];
                }
                
                
                /*
                if(m_pDocumentController != nil)
                {
                    NSNumber* pLatitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLATITUDE];
                    NSNumber* pLongitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
                    
                    double   dLatiude = (double)[pLatitude doubleValue];
                    double   dLongitude = (double)[pLongitude doubleValue];
                    [m_pDocumentController ProcessWatchPostRequest:nChoice option:nOption latitude:dLatiude longitude:dLongitude];
                }
                */
            }
        }
    }
    else if(szAppOpenType != nil && [szAppOpenType isEqualToString:EMSG_ID_WATCH_LOCATIONREQUEST] == YES)
    {
#ifdef DEBUG
        [m_DocumentController SendDebugMessageToAppleWatch:@"Process Apple Watch Open Main App For current location request"];
#endif
        NSNumber* pAction = [[NSNumber alloc] initWithInt:NOM_WATCH_ACTION_CURRENTLOCATION];
        NSMutableDictionary* appCurrentData = [[NSMutableDictionary alloc] init];
        [appCurrentData setObject:pAction forKey:EMSG_KEY_ACTION];
        if(m_DocumentController != nil)
        {
            [m_DocumentController HandleAppleWatchOpenRequestForCurrentLocation:appCurrentData];
        }
        reply(appCurrentData);
        return;
    }
    else if(szAppOpenType != nil && [szAppOpenType isEqualToString:EMSG_ID_WATCH_GENERALSEARCHREQUEST] == YES)
    {
#ifdef DEBUG
        [m_DocumentController SendDebugMessageToAppleWatch:@"Process Apple Watch Open Main App For general search request"];
#endif
        if(m_DocumentController != nil)
        {
            [m_DocumentController HandleAppleWatchOpenRequestForGeneralSearch];
        }
        NSNumber* pAction = [[NSNumber alloc] initWithInt:NOM_WATCH_ACTION_INVALID];
        NSMutableDictionary* appCurrentData = [[NSMutableDictionary alloc] init];
        [appCurrentData setObject:pAction forKey:EMSG_KEY_ACTION];
        reply(appCurrentData);
        return;
    }

}


@end
