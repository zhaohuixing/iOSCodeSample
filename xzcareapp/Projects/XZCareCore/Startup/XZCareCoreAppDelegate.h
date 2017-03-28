//
//  XZCareCoreAppDelegate.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-14.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ResearchKit/ResearchKit.h>

#import "XZCareDataSubstrate.h"
#import "XZCareOnboarding.h"
#import "XZCareProfileViewController.h"
#import "XZCareConsentTask.h"
#import <XZCareUICore/XZCarePasscodeViewController.h>
#import "XZCareCoreModel.h"


@class XZCareDataSubstrate, XZCareDataMonitor, XZCareScheduler, XZCareOnboarding, XZCarePasscodeViewController, XZCareTasksReminderManager, XZCarePassiveDataCollector, XZCareFitnessAllocation;


@interface XZCareCoreAppDelegate : UIResponder <UIApplicationDelegate, XZCarePasscodeViewControllerDelegate, XZCareOnboardingDelegate, XZCareOnboardingTaskDelegate>

@property (nonatomic, strong) XZCareFitnessAllocation       *sevenDayFitnessAllocationData;
@property (strong, nonatomic) UITabBarController            *tabster;

@property (strong, nonatomic) XZCareDataSubstrate*          dataSubstrate;
@property (strong, nonatomic) XZCareDataMonitor*            dataMonitor;

@property (strong, nonatomic) XZCareScheduler*              scheduler;
@property (strong, nonatomic) XZCareTasksReminderManager*   tasksReminder;
@property (strong, nonatomic) XZCarePassiveDataCollector*   passiveDataCollector;
@property (strong, nonatomic) XZCareProfileViewController*  profileViewController;
@property (nonatomic) BOOL                                  disableSignatureInConsent;

//Initialization Methods
@property (nonatomic, getter=doesPersisteStoreExist) BOOL   persistentStoreExistence;
@property (nonatomic, strong) NSDictionary*                 initializationOptions;
@property (strong, nonatomic) XZCareOnboarding*             onboarding;
@property (nonatomic, strong) NSArray*                      storyboardIdInfo;

-(NSArray*)getAppMainStoryboardInfo;

- (NSMutableDictionary*) defaultInitializationOptions;


- (UIWindow *)window;
- (NSString*)certificateFileName;


-(BOOL)HadCatastrophicStartupError;
-(BOOL)IsCurrentUserSignedIn;
-(BOOL)IsCurrentUserSignedUp;

-(void)ShowCatastrophicStartupError;
-(void)ShowTabBar;
-(void)ShowNeedsEmailVerification;
-(void)ShowOnBoarding;
-(void)SetUpRootViewController:(UIViewController*) viewController;

-(BOOL)IsMmolUnitForGlucose;

//
//For User in Subclasses
//
- (void) signedInNotification:(NSNotification *)notification;
- (void) signedUpNotification: (NSNotification*) notification;
- (void) logOutNotification:(NSNotification *)notification;

- (NSArray *)offsetForTaskSchedules;

- (void)afterOnBoardProcessIsFinished;
- (NSArray *)reviewConsentActions;
- (NSArray *)allSetTextBlocks;
- (NSDictionary *)configureTasksForActivities;

//SetupMethods
- (void) setUpInitializationOptions;
- (void) setUpAppAppearance;
- (void) registerCatastrophicStartupError: (NSError *) error;
- (void) initializeCloudServiceConnection;

//
//To be called from Datasubstrate
//
- (void) setUpCollectors;
- (id <XZCareProfileViewControllerDelegate>) profileExtenderDelegate;
- (void)showPasscodeIfNecessary;

- (ORKTaskViewController *)consentViewController;
- (NSMutableArray*)consentSectionsAndHtmlContent:(NSString**)htmlContent;
- (void)instantiateOnboardingForType:(XZCareOnboardingTaskType)type;
- (NSDate*)applicationBecameActiveDate;

//
//Task and operation update
//
- (void)loadStaticTasksAndSchedulesIfNecessary;  //For resetting app
- (void) updateDBVersionStatus;
- (void) clearNSUserDefaults; //For resetting app
- (void) setUpTasksReminder;
- (NSDictionary *) tasksAndSchedulesWillBeLoaded;
- (void)performMigrationFrom:(NSInteger)previousVersion currentVersion:(NSInteger)currentVersion;
- (void)performMigrationAfterDataSubstrateFrom:(NSInteger)previousVersion currentVersion:(NSInteger)currentVersion;
- (NSString *) applicationDocumentsDirectory;
- (NSUInteger)obtainPreviousVersion;


@end
