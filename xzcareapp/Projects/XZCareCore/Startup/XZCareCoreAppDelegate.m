//
//  XZCareCoreAppDelegate.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-14.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZCareCoreAppDelegate.h"
#import <XZCareCore/XZCareCore.h>

@interface XZCareCoreAppDelegate ()  <UITabBarControllerDelegate>

@property (nonatomic) BOOL isPreviousCurrentVersionSame;
@property (nonatomic) BOOL isPasscodeShowing;
@property (nonatomic, strong) UIView *secureView;
@property (nonatomic, strong) NSError *catastrophicStartupError;

@property (nonatomic, strong) NSOperationQueue *healthKitCollectorQueue;
@property (nonatomic, strong) XZCareDemographicUploader  *demographicUploader;


- (void)ShowAppropriateViewController; //showAppropriateVC

//Private methods
- (void)doGeneralInitialization;
- (BOOL)resetFileSecurityPermissionsWithError:(NSError* __autoreleasing *)error;
- (void)showSecureView;
- (void)hideSecureView;
- (void)setUpHKPermissions;
- (BOOL)determineIfPeresistentStoreExists;
- (void)initializeAppleCoreStack;
- (void)performDemographicUploadIfRequired;

@end

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}


@implementation XZCareCoreAppDelegate

-(BOOL)IsMmolUnitForGlucose
{
#ifdef __USE_MMOL_GLUCOSE_UNIT__
    return YES;
#else
    return NO;
#endif
}


/*********************************************************************************/
#pragma mark - Respond to Notifications
/*********************************************************************************/
- (void) registerNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signedUpNotification:) name:(NSString *)XZCareUserSignedUpNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signedInNotification:) name:(NSString *)XZCareUserSignedInNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutNotification:) name:(NSString *)XZCareUserLogOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userConsented:) name:XZCareUserDidConsentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withdrawStudy:) name:XZCareUserWithdrawStudyNotification object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application: (UIApplication *) __unused application willFinishLaunchingWithOptions: (NSDictionary *) __unused launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [XZBaseClassFactory InitializeBaseClassList];
    
    self.isPreviousCurrentVersionSame = YES;
    NSUInteger  previousVersion = [self obtainPreviousVersion];
    if(previousVersion != kTheEntireDataModelOfTheApp)
        self.isPreviousCurrentVersionSame = NO;
    
    [self performMigrationFrom:previousVersion currentVersion:kTheEntireDataModelOfTheApp];
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [self setUpInitializationOptions];
    NSAssert(self.initializationOptions, @"Please set up initialization options");
    
    [self doGeneralInitialization];
    [self initializeCloudServiceConnection];
    [self initializeAppleCoreStack];
    [self loadStaticTasksAndSchedulesIfNecessary];
    [self registerNotifications];
    [self setUpHKPermissions];
    [self setUpAppAppearance];
    [self setUpTasksReminder];
    [self performDemographicUploadIfRequired];
    [self ShowAppropriateViewController];
    
    [self.dataMonitor appFinishedLaunching];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.window endEditing:YES];
    [self showSecureView];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (self.dataSubstrate.currentUser.signedIn && !self.isPasscodeShowing)
    {
        NSDate *currentTime = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:kLastUsedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.dataSubstrate.currentUser.sessionToken = nil;
    [self showSecureView];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self hideSecureView];
    [self showPasscodeIfNecessary];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kAppWillEnterForegroundTimeKey];
    
    
    //#ifndef DEVELOPMENT
    /*    if (self.dataSubstrate.currentUser.signedIn)
     {
     //       [SBBComponent(SBBAuthManager) ensureSignedInWithCompletion: ^(NSURLSessionDataTask * __unused task,
     //																	  id  __unused responseObject,
     //																	  NSError *error) {
     //            APCLogError2 (error);
     //        }];
     }
     */
    //#endif
    [self hideSecureView];
    [self showPasscodeIfNecessary];
    [self.dataMonitor appBecameActive];
}

- (void)application:(UIApplication *) __unused application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if (self.dataSubstrate.currentUser.signedIn && !self.isPasscodeShowing)
    {
        NSDate *currentTime = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:kLastUsedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)application: (UIApplication *) __unused application didRegisterUserNotificationSettings:(UIUserNotificationSettings *) notificationSettings
{
    if (notificationSettings)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:XZCareAppDidRegisterUserNotification object:notificationSettings];
    }
}

/*********************************************************************************/
//
#pragma mark - General initialization
//
/*********************************************************************************/

- (void)ShowPasscode
{
    if ([self.window.rootViewController isKindOfClass:[XZCareCoreBaseTabBarViewController class]])
    {
        XZCareCoreBaseTabBarViewController* tvc = (XZCareCoreBaseTabBarViewController*) self.window.rootViewController;
        tvc.passcodeDelegate = self;
        self.isPasscodeShowing = YES;
        tvc.showPasscodeScreen = YES;
    }
}

- (NSMutableDictionary *)defaultInitializationOptions
{
    //Return Default Dictionary
    return [@{
              kDatabaseNameKey                     : kDatabaseName,
              kTasksAndSchedulesJSONFileNameKey    : kTasksAndSchedulesJSONFileName,
              kConsentSectionFileNameKey           : kConsentSectionFileName,
              kDBStatusVersionKey                  : kDBStatusCurrentVersion
              } mutableCopy];
}

- (UIWindow *)window
{
    static XZCareDefaultWindow *customWindow = nil;
    if (!customWindow)
        customWindow = [[XZCareDefaultWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //????customWindow.enableDebuggerWindow = NO;
    return customWindow;
}

#pragma mark - Misc
- (NSString *)certificateFileName
{
    //#ifndef NOT_USE_BRIDGE
    //    return ([self.initializationOptions[kBridgeEnvironmentKey] integerValue] == SBBEnvironmentStaging) ? [self.initializationOptions[kAppPrefixKey] stringByAppendingString:@"-staging"] :self.initializationOptions[kAppPrefixKey];
    //#else
    return self.initializationOptions[kAppPrefixKey];
    //#endif
}


-(void)ShowAppropriateViewController
{
    //
#ifdef __NEED_RECONSENT_PROCESS__
    if(self.isPreviousCurrentVersionSame == NO)
    {
        [self ShowOnBoarding];
        return;
    }
#endif
    
    if ([self HadCatastrophicStartupError])
    {
        [self ShowCatastrophicStartupError];
    }
    else if ([self IsCurrentUserSignedIn])
    {
        [self ShowTabBar];
    }
    else if ([self IsCurrentUserSignedUp])
    {
        [self ShowNeedsEmailVerification];
    }
    else
    {
        [self ShowOnBoarding];
    }
}

/**************************************************************************/
//
//XZCarePasscodeViewControllerDelegate methods
//
#pragma mark - XZCarePasscodeViewControllerDelegate methods
//
/**************************************************************************/
- (void)passcodeViewControllerDidSucceed:(XZCarePasscodeViewController *) __unused viewController
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastUsedTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.isPasscodeShowing = NO;
}

/**************************************************************************/
//
// XZCareOnboardingDelegate methods
//
#pragma mark - XZCareOnboardingDelegate methods
//
/**************************************************************************/
- (XZCareScene *) inclusionCriteriaSceneForOnboarding: (XZCareOnboarding *) __unused onboarding
{
    NSAssert(FALSE, @"Cannot retun nil. Override this delegate method to return a valid XZCareScene.");
    
    return nil;
}

- (XZCareScene *)customInfoSceneForOnboarding:(XZCareOnboarding *) __unused onboarding
{
    NSAssert(FALSE, @"Cannot retun nil. Override this delegate method to return a valid XZCareScene.");
    
    return nil;
}

/**************************************************************************/
//
// XZCareOnboardingTaskDelegate methods
//
#pragma mark - XZCareOnboardingTaskDelegate methods
//
/**************************************************************************/
- (XZCarePatient *) userForOnboardingTask: (XZCareOnboardingTask *) __unused task
{
    return self.dataSubstrate.currentUser;
}

- (NSInteger) numberOfServicesInPermissionsListForOnboardingTask: (XZCareOnboardingTask *) __unused task
{
    NSDictionary *initialOptions = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).initializationOptions;
    NSArray *servicesArray = initialOptions[kAppServicesListRequiredKey];
    
    return servicesArray.count;
}



////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
-(BOOL)HadCatastrophicStartupError
{
    return self.catastrophicStartupError != nil;
}

-(BOOL)IsCurrentUserSignedIn
{
    return self.dataSubstrate.currentUser.isSignedIn;
}

-(BOOL)IsCurrentUserSignedUp
{
    return self.dataSubstrate.currentUser.isSignedUp;
}

-(void)ShowCatastrophicStartupError
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"CatastrophicError" bundle: [NSBundle XZCareCoreBundle]];
    
    UIViewController *errorViewController = [storyBoard instantiateInitialViewController];
    
    self.window.rootViewController = errorViewController;
    NSError *error = self.catastrophicStartupError;
    
    __block XZCareCoreAppDelegate *blockSafeSelf = self;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        UIAlertController *alert = [UIAlertController simpleAlertWithTitle: error.userInfo [NSLocalizedFailureReasonErrorKey]
                                                                   message: error.userInfo [NSLocalizedRecoverySuggestionErrorKey]];
        
        [blockSafeSelf.window.rootViewController presentViewController: alert animated: YES completion: nil];
    }];
}

-(NSArray*)getAppMainStoryboardInfo
{
    NSAssert(NO, @"XZCareCoreAppDelegate getAppMainStoryboardInfo method should be called subcalss method!");
    
    return @[
      @{@"name": kActivitiesStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]},
      @{@"name": kDashBoardStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]},
      @{@"name": kLearnStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]},
      @{@"name": kHealthProfileStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]}
      ];
}

- (NSArray *)storyboardIdInfo
{
    //NSAssert(NO, @"XZCareCoreAppDelegate storyboardIdInfo getter method should be called subcalss method!");
    
    if (!_storyboardIdInfo)
    {
/*
        _storyboardIdInfo = @[
                              @{@"name": kActivitiesStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]},
                              @{@"name": kDashBoardStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]},
                              @{@"name": kLearnStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]},
                              @{@"name": kHealthProfileStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]}
                              ];
*/
        _storyboardIdInfo = [self getAppMainStoryboardInfo];
    }
    return _storyboardIdInfo;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.tabster = (UITabBarController  *)self.window.rootViewController;
    NSArray  *deselectedImageNames = @[ @"tab_activities",          @"tab_dashboard",           @"tab_learn",           @"tab_profile" ];
    NSArray  *selectedImageNames   = @[ @"tab_activities_selected", @"tab_dashboard_selected",  @"tab_learn_selected",  @"tab_profile_selected" ];
    NSArray  *tabBarTitles         = @[ @"Activities",              @"Dashboard",               @"About",               @"Profile"];
    
    if ([viewController isMemberOfClass: [UIViewController class]])
    {
        NSMutableArray  *controllers = [tabBarController.viewControllers mutableCopy];
        NSUInteger  controllerIndex = [controllers indexOfObject:viewController];
        
        NSString  *name = [self.storyboardIdInfo objectAtIndex:controllerIndex][@"name"];
        UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:name bundle:[self.storyboardIdInfo objectAtIndex:controllerIndex][@"bundle"]];
        UIViewController  *controller = [storyboard instantiateInitialViewController];
        [controllers replaceObjectAtIndex:controllerIndex withObject:controller];
        
        [self.tabster setViewControllers:controllers animated:NO];
        self.tabster.tabBar.tintColor = [UIColor appPrimaryColor];
        UITabBarItem  *item = self.tabster.tabBar.selectedItem;
        item.image = [UIImage imageNamed:deselectedImageNames[controllerIndex]];
        item.selectedImage = [[UIImage imageNamed:selectedImageNames[controllerIndex]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        item.title = tabBarTitles[controllerIndex];
        
        if (controllerIndex == kIndexOfProfileTab)
        {
            
            UINavigationController * profileNavigationController = (UINavigationController *) controller;
            
            if ( [profileNavigationController.childViewControllers[0] isKindOfClass:[XZCareProfileViewController class]])
            {
                
                self.profileViewController = (XZCareProfileViewController *) profileNavigationController.childViewControllers[0];
                
                self.profileViewController.delegate = [self profileExtenderDelegate];
            }
        }
        
        if (controllerIndex == kIndexOfActivitesTab)
        {
#ifdef DEBUG
            NSString* szClass = NSStringFromClass([viewController class]);
            NSLog(@"Activity Constroller is:%@", szClass);
#endif
            NSUInteger allScheduledTasks = self.dataSubstrate.countOfAllScheduledTasksForToday;
            NSUInteger completedScheduledTasks = self.dataSubstrate.countOfCompletedScheduledTasksForToday;
            
            NSNumber *remainingTasks = (completedScheduledTasks < allScheduledTasks) ? @(allScheduledTasks - completedScheduledTasks) : @(0);
            
            if ([remainingTasks integerValue] != 0)
            {
                item.badgeValue = [remainingTasks stringValue];
            }
            else
            {
                item.badgeValue = nil;
            }
        }
    }
}


-(void)ShowTabBar
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kXZCareCoreTabBarStoryboard bundle:[NSBundle XZCareCoreBundle]];
    
    UITabBarController *tabBarController = (UITabBarController *)[storyBoard instantiateInitialViewController];
    self.window.rootViewController = tabBarController;
    tabBarController.delegate = self;

    NSArray       *items = tabBarController.tabBar.items;
    
    NSUInteger     selectedItemIndex = kIndexOfActivitesTab;
    
    NSArray  *deselectedImageNames = @[@"tab_activities", @"tab_dashboard", @"tab_learn", @"tab_profile"];
    NSArray  *selectedImageNames   = @[@"tab_activities_selected", @"tab_dashboard_selected", @"tab_learn_selected",  @"tab_profile_selected"];
    NSArray  *tabBarTitles         = @[@"Activities", @"Dashboard", @"About",  @"Profile"];
    
    for (NSUInteger i=0; i<items.count; i++)
    {
        UITabBarItem  *item = items[i];
        item.image = [UIImage imageNamed:deselectedImageNames[i]];
        item.selectedImage = [[UIImage imageNamed:selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        item.title = tabBarTitles[i];
        item.tag = i;
        if (i == kIndexOfActivitesTab)
        {
            NSUInteger allScheduledTasks = self.dataSubstrate.countOfAllScheduledTasksForToday;
            NSUInteger completedScheduledTasks = self.dataSubstrate.countOfCompletedScheduledTasksForToday;
            
            NSNumber *activitiesBadgeValue = (completedScheduledTasks < allScheduledTasks) ? @(allScheduledTasks - completedScheduledTasks) : @(0);
            
           if ([activitiesBadgeValue integerValue] != 0)
           {
                item.badgeValue = [activitiesBadgeValue stringValue];
           }
           else
           {
                item.badgeValue = nil;
           }
        }
    }
    
    NSArray  *controllers = tabBarController.viewControllers;
    
    //These need to be "Selected" one by one it silly but I remember this from a pass issue.
    //We can hard code this as long as it matches the tab count above
    // Might want to refactor this more hwne we have time
    [tabBarController setSelectedIndex:selectedItemIndex + 1];
    [tabBarController setSelectedIndex:selectedItemIndex + 2];
    [tabBarController setSelectedIndex:selectedItemIndex + 3];
    [tabBarController setSelectedIndex:selectedItemIndex];
    
    [self tabBarController:tabBarController didSelectViewController:controllers[selectedItemIndex]];
}

-(void)ShowNeedsEmailVerification
{
    XZCareEmailVerifyViewController * viewController = (XZCareEmailVerifyViewController*)[[UIStoryboard storyboardWithName:@"XZCareEmailVerify" bundle:[NSBundle XZCareCoreBundle]] instantiateInitialViewController];
    [self SetUpRootViewController:viewController];
}

-(void)ShowOnBoarding
{
    //Need overridding by subclass
}

-(void)SetUpRootViewController:(UIViewController*) viewController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.navigationBar.translucent = NO;
    
    [UIView transitionWithView:self.window
                      duration:0.6
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{
                        self.window.rootViewController = navController;
                    }
                    completion:nil];
}

/*********************************************************************************/
//
//For User in Subclasses
//
/*********************************************************************************/
- (NSArray *)offsetForTaskSchedules
{
    //TODO: Number of days should be zero based. If I want something to show up on day 2 then the offset is 1
    return nil;
}

- (void) showThankYouPage
{
    UIStoryboard *sbOnboarding = [UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle XZCareCoreBundle]];
    XZCareThankYouViewController *allSetVC = (XZCareThankYouViewController *)[sbOnboarding instantiateViewControllerWithIdentifier:@"XZCareThankYouViewController"];
        
    allSetVC.emailVerified = YES;
    [self SetUpRootViewController:allSetVC];
}

- (void) signedUpNotification: (NSNotification*) __unused notification
{
#ifdef DSIABLE_SHOWCONSENTDOCUMENT_UI
    [self showThankYouPage];
#else
    [self ShowNeedsEmailVerification];
#endif
    
}

- (void) signedInNotification: (NSNotification*) __unused notification
{
    [self.dataMonitor userConsented];
    [self.tasksReminder updateTasksReminder];
    [self ShowTabBar];
}

- (void) userConsented: (NSNotification*) __unused notification
{
    
}

- (void) logOutNotification: (NSNotification*) __unused notification
{
    self.dataSubstrate.currentUser.signedUp = NO;
    self.dataSubstrate.currentUser.signedIn = NO;
    [XZBaseKeychainStore removeValueForKey:kPasswordKey];
    [self.tasksReminder updateTasksReminder];
    [self ShowOnBoarding];
}

- (void) withdrawStudy: (NSNotification *) __unused notification
{
    [self clearNSUserDefaults];
    [XZBaseKeychainStore resetKeyChain];
    [self.dataSubstrate resetCoreData];
    [self.tasksReminder updateTasksReminder];
    [self ShowOnBoarding];
}

- (void)afterOnBoardProcessIsFinished
{
    /* Abstract implementation. Subclass to override
     *
     * Use this as a hook to post-process anything that is needed
     * to be processed right after the 'finishOnboarding' method
     * is invoked.
     */
}

// Review Consent Actions
- (NSArray *)reviewConsentActions
{
    return nil;
}

// The block of text for the All Set
- (NSArray *)allSetTextBlocks
{
    /* Abstract implementaion. Subclass to override.
     *
     * Use this to provide custom text on the All Set
     * screen.
     *
     * Please don't be glutenous, don't use four words
     * when one would suffice.
     */
    
    return nil;
}

- (NSDictionary *)configureTasksForActivities
{
    /* Abstract implementation. Subclass to override.
     *
     * Use this to properly group your tasks into the three groups
     * that are now shown on the Activities tab.
     *
     * 1. Todays tasks
     * 2. Keep Going
     * 3. Yesterday's incomplete tasks
     *
     * Note: This needs to be refactored
     */
    return nil;
}

/*********************************************************************************/
#pragma mark - Catastrophic startup errors
/*********************************************************************************/
- (void) registerCatastrophicStartupError: (NSError *) error
{
    self.catastrophicStartupError = error;
}

- (void) initializeCloudServiceConnection
{
    /*Abstract Implementation*/
}

#pragma mark - Other Abstract Implmentations
- (void) setUpInitializationOptions
{
    /*Abstract Implementation*/
}

- (void) setUpAppAppearance
{
    /*Abstract Implementation*/
}

- (void) setUpCollectors
{
    /*Abstract Implementation*/
}

- (id <XZCareProfileViewControllerDelegate>) profileExtenderDelegate
{
    return nil;
}

- (void)showPasscodeIfNecessary
{
    if (self.dataSubstrate.currentUser.isSignedIn && !self.isPasscodeShowing)
    {
        NSDate *lastUsedTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUsedTimeKey];
        
        if (lastUsedTime)
        {
            NSTimeInterval timeDifference = [lastUsedTime timeIntervalSinceNow];
            NSInteger numberOfMinutes = [self.dataSubstrate.parameters integerForKey:kNumberOfMinutesForPasscodeKey];
            
            if (timeDifference * -1 > numberOfMinutes * 60)
            {
                
                [self ShowPasscode];
            }
        }
    }
}

- (ORKTaskViewController *)consentViewController
{
    NSAssert(FALSE, @"Override this method to return a valid Consent Task View Controller.");
    return nil;
}

- (NSMutableArray*)consentSectionsAndHtmlContent:(NSString**)htmlContent
{
    ORKConsentSectionType(^toSectionType)(NSString*) = ^(NSString* sectionTypeName)
    {
        ORKConsentSectionType   sectionType = ORKConsentSectionTypeCustom;
        
        if ([sectionTypeName isEqualToString:@"overview"])
        {
            sectionType = ORKConsentSectionTypeOverview;
        }
        else if ([sectionTypeName isEqualToString:@"privacy"])
        {
            sectionType = ORKConsentSectionTypePrivacy;
        }
        else if ([sectionTypeName isEqualToString:@"dataGathering"])
        {
            sectionType = ORKConsentSectionTypeDataGathering;
        }
        else if ([sectionTypeName isEqualToString:@"dataUse"])
        {
            sectionType = ORKConsentSectionTypeDataUse;
        }
        else if ([sectionTypeName isEqualToString:@"timeCommitment"])
        {
            sectionType = ORKConsentSectionTypeTimeCommitment;
        }
        else if ([sectionTypeName isEqualToString:@"studySurvey"])
        {
            sectionType = ORKConsentSectionTypeStudySurvey;
        }
        else if ([sectionTypeName isEqualToString:@"studyTasks"])
        {
            sectionType = ORKConsentSectionTypeStudyTasks;
        }
        else if ([sectionTypeName isEqualToString:@"withdrawing"])
        {
            sectionType = ORKConsentSectionTypeWithdrawing;
        }
        else if ([sectionTypeName isEqualToString:@"custom"])
        {
            sectionType = ORKConsentSectionTypeCustom;
        }
        else if ([sectionTypeName isEqualToString:@"onlyInDocument"])
        {
            sectionType = ORKConsentSectionTypeOnlyInDocument;
        }
        
        return sectionType;
    };
    NSString*   kDocumentHtml           = @"htmlDocument";
    NSString*   kConsentSections        = @"sections";
    NSString*   kSectionType            = @"sectionType";
    NSString*   kSectionTitle           = @"sectionTitle";
    NSString*   kSectionFormalTitle     = @"sectionFormalTitle";
    NSString*   kSectionSummary         = @"sectionSummary";
    NSString*   kSectionContent         = @"sectionContent";
    NSString*   kSectionHtmlContent     = @"sectionHtmlContent";
    NSString*   kSectionImage           = @"sectionImage";
    NSString*   kSectionAnimationUrl    = @"sectionAnimationUrl";
    
    NSString*       resource = [[NSBundle mainBundle] pathForResource:self.initializationOptions[kConsentSectionFileNameKey] ofType:@"json"];
    NSAssert(resource != nil, @"Unable to location file with Consent Section in main bundle");
    
    NSData*         consentSectionData = [NSData dataWithContentsOfFile:resource];
    NSAssert(consentSectionData != nil, @"Unable to create NSData with Consent Section data");
    
    NSError*        error             = nil;
    NSDictionary*   consentParameters = [NSJSONSerialization JSONObjectWithData:consentSectionData options:NSJSONReadingMutableContainers error:&error];
    NSAssert(consentParameters != nil, @"badly formed Consent Section data - error", error);
    
    NSString*       documentHtmlContent = [consentParameters objectForKey:kDocumentHtml];
    NSAssert(documentHtmlContent == nil || documentHtmlContent != nil && [documentHtmlContent isKindOfClass:[NSString class]], @"Improper Document HTML Content type");
    
    if (documentHtmlContent != nil && htmlContent != nil)
    {
        NSString*   path    = [[NSBundle mainBundle] pathForResource:documentHtmlContent ofType:@"html" inDirectory:@"HTMLContent"];
        NSAssert(path != nil, @"Unable to locate HTML file: %@", documentHtmlContent);
        
        NSError*    error   = nil;
        NSString*   content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        
        NSAssert(content != nil, @"Unable to load content of file \"%@\": %@", path, error);
        
        *htmlContent = content;
    }
    
    NSArray*        parametersConsentSections = [consentParameters objectForKey:kConsentSections];
    NSAssert(parametersConsentSections != nil && [parametersConsentSections isKindOfClass:[NSArray class]], @"Badly formed Consent Section data");
    
    NSMutableArray* consentSections = [NSMutableArray arrayWithCapacity:parametersConsentSections.count];
    
    for (NSDictionary* section in parametersConsentSections)
    {
        //  Custom typesdo not have predefiend title, summary, content, or animation
        NSAssert([section isKindOfClass:[NSDictionary class]], @"Improper section type");
        
        NSString*   typeName     = [section objectForKey:kSectionType];
        NSAssert(typeName != nil && [typeName isKindOfClass:[NSString class]],    @"Missing Section Type or improper type");
        
        ORKConsentSectionType   sectionType = toSectionType(typeName);
        
        NSString*   title        = [section objectForKey:kSectionTitle];
        NSString*   formalTitle  = [section objectForKey:kSectionFormalTitle];
        NSString*   summary      = [section objectForKey:kSectionSummary];
        NSString*   content      = [section objectForKey:kSectionContent];
        NSString*   htmlContent  = [section objectForKey:kSectionHtmlContent];
        NSString*   image        = [section objectForKey:kSectionImage];
        NSString*   animationUrl = [section objectForKey:kSectionAnimationUrl];
        
        NSAssert(title        == nil || title         != nil && [title isKindOfClass:[NSString class]],        @"Missing Section Title or improper type");
        NSAssert(formalTitle  == nil || formalTitle   != nil && [formalTitle isKindOfClass:[NSString class]],  @"Missing Section Formal title or improper type");
        NSAssert(summary      == nil || summary       != nil && [summary isKindOfClass:[NSString class]],      @"Missing Section Summary or improper type");
        NSAssert(content      == nil || content       != nil && [content isKindOfClass:[NSString class]],      @"Missing Section Content or improper type");
        NSAssert(htmlContent  == nil || htmlContent   != nil && [htmlContent isKindOfClass:[NSString class]],  @"Missing Section HTML Content or improper type");
        NSAssert(image        == nil || image         != nil && [image isKindOfClass:[NSString class]],        @"Missing Section Image or improper typte");
        NSAssert(animationUrl == nil || animationUrl  != nil && [animationUrl isKindOfClass:[NSString class]], @"Missing Animation URL or improper type");
        
        
        ORKConsentSection*  section = [[ORKConsentSection alloc] initWithType:sectionType];
        
        if (title != nil)
        {
            section.title = title;
        }
        
        if (formalTitle != nil)
        {
            section.formalTitle = formalTitle;
        }
        
        if (summary != nil)
        {
            section.summary = summary;
        }
        
        if (content != nil)
        {
            section.content = content;
        }
        
        if (htmlContent != nil)
        {
            NSString*   path    = [[NSBundle mainBundle] pathForResource:htmlContent ofType:@"html" inDirectory:@"HTMLContent"];
            NSAssert(path != nil, @"Unable to locate HTML file: %@", htmlContent);
            
            NSError*    error   = nil;
            NSString*   content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            
            NSAssert(content != nil, @"Unable to load content of file \"%@\": %@", path, error);
            
            section.htmlContent = content;
        }
        
        if (image != nil)
        {
            section.customImage = [UIImage imageNamed:image];
            NSAssert(section.customImage != nil, @"Unable to load image: %@", image);
        }
        
        if (animationUrl != nil)
        {
            NSString * nameWithScaleFactor = animationUrl;
            if ([[UIScreen mainScreen] scale] >= 3) {
                nameWithScaleFactor = [nameWithScaleFactor stringByAppendingString:@"@3x"];
            } else {
                nameWithScaleFactor = [nameWithScaleFactor stringByAppendingString:@"@2x"];
            }
            NSURL*      url   = [[NSBundle mainBundle] URLForResource:nameWithScaleFactor withExtension:@"m4v"];
            NSError*    error = nil;
            
            NSAssert([url checkResourceIsReachableAndReturnError:&error], @"Animation file--%@--not reachable: %@", animationUrl, error);
            section.customAnimationURL = url;
        }
        
        [consentSections addObject:section];
    }
    
    return consentSections;
}

- (void)instantiateOnboardingForType:(XZCareOnboardingTaskType)type
{
    if (self.onboarding)
    {
        self.onboarding = nil;
        self.onboarding.delegate = nil;
    }
    
    self.onboarding = [[XZCareOnboarding alloc] initWithDelegate:self taskType:type];
}

- (NSDate*)applicationBecameActiveDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAppWillEnterForegroundTimeKey];
}


- (void)loadStaticTasksAndSchedulesIfNecessary
{
    
    if (![XZCareCoreDBStatus isSeedLoadedWithContext:self.dataSubstrate.persistentContext])
    {
        [XZCareCoreDBStatus setSeedLoaded:self.initializationOptions[kDBStatusVersionKey] WithContext:self.dataSubstrate.persistentContext];
        NSString *resource = [[NSBundle mainBundle] pathForResource:self.initializationOptions[kTasksAndSchedulesJSONFileNameKey] ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:resource];
        NSError * error;
        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
#ifdef DEBUG
        NSLog(@"loadStaticTasksAndSchedulesIfNecessary json file:%@\n", resource);
        if(error)
        {
            NSLog(@"loadStaticTasksAndSchedulesIfNecessary error:\n%@\n", error.description);
            NSLog(@"loadStaticTasksAndSchedulesIfNecessary error debug description:\n%@\n", error.debugDescription);
        }
#endif
        XZCareLogError2 (error);
        
        NSDictionary *manipulatedDictionary = [(XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate tasksAndSchedulesWillBeLoaded];
        
        if (manipulatedDictionary != nil)
        {
            dictionary = manipulatedDictionary;
        }
        
        [self.dataSubstrate loadStaticTasksAndSchedules:dictionary];
        [XZBaseKeychainStore resetKeyChain];
    }
    else
    {
        NSString* dbVersionStr = [XZCareCoreDBStatus dbStatusVersionwithContext:self.dataSubstrate.persistentContext];
        NSString* curAppVersion = self.initializationOptions[kDBStatusVersionKey];
#ifdef DEBUG
        NSLog(@"dbVersionStr is %@ and curAppVersion is: %@\n", dbVersionStr, curAppVersion);
#endif
        if (![dbVersionStr isEqualToString:curAppVersion] == YES)
        {
            [self updateDBVersionStatus];
        }
    }
    
}

//This method is overridable from each app
- (void) updateDBVersionStatus
{
    NSString *resource = [[NSBundle mainBundle] pathForResource:self.initializationOptions[kTasksAndSchedulesJSONFileNameKey] ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:resource];
    NSError * error;
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    XZCareLogError2 (error);
    
    //Deeper investigation needed for enabling tasksAndSchedulesWillBeLoaded
    NSDictionary *manipulatedDictionary = [(XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate tasksAndSchedulesWillBeLoaded];
    
    if (manipulatedDictionary != nil)
    {
        dictionary = manipulatedDictionary;
    }
    
    //Enabling refreshing of tasks JSON only. Schedules might be tricky as Apps could manipulate schedules after creation.
    //More investigation needed
    [XZCareCoreDBTask updateTasksFromJSON:dictionary[@"tasks"] inContext:self.dataSubstrate.persistentContext];
    //[APCSchedule updateSchedulesFromJSON:dictionary[@"schedules"] inContext:self.dataSubstrate.persistentContext];
    [XZCareCoreDBStatus updateSeedLoaded:self.initializationOptions[kDBStatusVersionKey] WithContext:self.dataSubstrate.persistentContext];
    
}

- (void) clearNSUserDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void) setUpTasksReminder
{
    /*Abstract Implementation*/
}

- (NSDictionary *) tasksAndSchedulesWillBeLoaded
{
    /*Abstract Implementation*/
    return nil;
}

- (NSUInteger)obtainPreviousVersion
{
    NSUserDefaults* defaults        = [NSUserDefaults standardUserDefaults];
    return (NSUInteger) [defaults integerForKey:kXZCarePreviousVersionKey];
}

- (void)performMigrationFrom:(NSInteger) __unused previousVersion currentVersion:(NSInteger)__unused currentVersion
{
    /* abstract implementation */
}

- (void)performMigrationAfterDataSubstrateFrom:(NSInteger) __unused previousVersion currentVersion:(NSInteger) __unused currentVersion
{
    /* abstract implementation */
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

/*********************************************************************************/
//
#pragma mark - private general initialization
//
/*********************************************************************************/
- (void) doGeneralInitialization
{
    NSError*    error = nil;
    BOOL        fileSecurityPermissionsResetSuccessful = [self resetFileSecurityPermissionsWithError:&error];
    
    if (fileSecurityPermissionsResetSuccessful == NO)
    {
        XZCareLogDebug(@"Incomplete reset of file system security permissions");
        XZCareLogError2(error);
    }
    
    self.catastrophicStartupError = nil;
    
    //initialize tasksReminder
    self.tasksReminder = [XZCareTasksReminderManager new];
}

- (BOOL)resetFileSecurityPermissionsWithError:(NSError* __autoreleasing *)error
{
    NSArray*                paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*               documentsDirectory  = [paths objectAtIndex:0];
    NSFileManager*          fileManager         = [NSFileManager defaultManager];
    NSDirectoryEnumerator*  directoryEnumerator = [fileManager enumeratorAtPath:documentsDirectory];
    
    BOOL                    isSuccessful     = NO;
    
    for (NSString* relativeFilePath in directoryEnumerator)
    {
        NSDictionary*   attributes = directoryEnumerator.fileAttributes;
        
        if ([[attributes objectForKey:NSFileProtectionKey] isEqual:NSFileProtectionComplete])
        {
            NSString*   absoluteFilePath = [documentsDirectory stringByAppendingPathComponent:relativeFilePath];
            
            attributes   = @{ NSFileProtectionKey : NSFileProtectionCompleteUntilFirstUserAuthentication };
            isSuccessful = [fileManager setAttributes:attributes ofItemAtPath:absoluteFilePath error:error];
            if (isSuccessful == NO && error != nil)
            {
                XZCareLogError2(*error);
            }
        }
    }
    
    return isSuccessful;
}

- (void)showSecureView
{
    UIView *viewForSnapshot = self.window;
    if (self.secureView == nil)
    {
        self.secureView = [[UIView alloc] initWithFrame:self.window.rootViewController.view.bounds];
        
        UIImage *blurredImage = [viewForSnapshot blurredSnapshot];
        UIImage *appIcon = [UIImage imageNamed:@"logo_disease_large" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
        UIImageView *blurredImageView = [[UIImageView alloc] initWithImage:blurredImage];
        UIImageView *appIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 180, 180)];
        
        appIconImageView.image = appIcon;
        appIconImageView.center = blurredImageView.center;
        appIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.secureView addSubview:blurredImageView];
        [self.secureView addSubview:appIconImageView];
        
        [viewForSnapshot insertSubview:self.secureView atIndex:NSIntegerMax];
        
    }
}

- (void)hideSecureView
{
    if (self.secureView)
    {
        [self.secureView removeFromSuperview];
        self.secureView = nil;
    }
}

- (void) setUpHKPermissions
{
    [XZCarePermissionsManager setHealthKitTypesToRead:self.initializationOptions[kHKReadPermissionsKey]];
    [XZCarePermissionsManager setHealthKitTypesToWrite:self.initializationOptions[kHKWritePermissionsKey]];
}

- (BOOL) determineIfPeresistentStoreExists
{
    BOOL persistenStoreExists = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:self.initializationOptions[kDatabaseNameKey]]])
    {
        persistenStoreExists = YES;
    }
    
    return persistenStoreExists;
}

- (void) initializeAppleCoreStack
{
    //Check if persistent store (db.sqlite file) exists
    self.persistentStoreExistence = [self determineIfPeresistentStoreExists];
    
    self.dataSubstrate = [[XZCareDataSubstrate alloc] initWithPersistentStorePath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:self.initializationOptions[kDatabaseNameKey]] additionalModels: nil studyIdentifier:self.initializationOptions[kStudyIdentifierKey]];
    
    [self performMigrationAfterDataSubstrateFrom:[self obtainPreviousVersion] currentVersion:kTheEntireDataModelOfTheApp];
    
    self.scheduler = [[XZCareScheduler alloc] initWithDataSubstrate:self.dataSubstrate];
    self.dataMonitor = [[XZCareDataMonitor alloc] initWithDataSubstrate:self.dataSubstrate scheduler:self.scheduler];
    
    /*?????
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
     self.passiveDataCollector = [[XZCarePassiveDataCollector alloc] init];
     });
     ?????*/
    
    //Setup AuthDelegate for SageSDK
    //?????    SBBAuthManager * manager = (SBBAuthManager*) SBBComponent(SBBAuthManager);
    //?????    manager.authDelegate = self.dataSubstrate.currentUser;
    
}

- (void)performDemographicUploadIfRequired
{
    //???? NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];

    
    /*
     //
     //    the Boolean will be NO if:
     //        the user defaults value was never set
     //        the actual value is NO (which should never happen)
     //    in which case, we upload the (non-identifiable) Demographic data
     //    Age, Sex, Height, Weight, Sleep Time, Wake Time, et al
     //
     //    otherwise, the value should have been set to YES, to
     //    indicate that the Demographic data was previously uploaded
     //
     
     //
     //    we run this code iff the user has previously consented,
     //    indicating that this is an update to a previously installed version of the application
     //
     XZCareUser  *user = self.dataSubstrate.currentUser;
     if (user.isConsented)
     {
     BOOL  demographicDataWasUploaded = [defaults boolForKey:kDemographicDataWasUploadedKey];
     if (demographicDataWasUploaded == NO)
     {
     self.demographicUploader = [[APCDemographicUploader alloc] initWithUser:user];
     [defaults setBool:YES forKey:kDemographicDataWasUploadedKey];
     [defaults synchronize];
     [self.demographicUploader uploadNonIdentifiableDemographicData];
     }
     }
     */
}

@end
