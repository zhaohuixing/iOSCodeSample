//
//  AppDelegate.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-13.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import <XZCareCore/XZCareCore.h>
#import "XZCareOneDownDelegate.h"
#import "XZCareAppConstants.h"
#import "XZCareOneDownProfileExtender.h"

static NSString *const kMigrationTaskIdKey              = @"taskId";
static NSString *const kMigrationOffsetByDaysKey        = @"offsetByDays";
static NSString *const kMigrationGracePeriodInDaysKey   = @"gracePeriodInDays";
static NSString *const kMigrationRecurringKindKey       = @"recurringKind";

typedef NS_ENUM(NSUInteger, TCMOneDownMigrationRecurringKinds)
{
    TCMOneDownMigrationRecurringKindWeekly = 0,
    TCMOneDownMigrationRecurringKindMonthly,
    TCMOneDownMigrationRecurringKindQuarterly,
    TCMOneDownMigrationRecurringKindSemiAnnual,
    TCMOneDownMigrationRecurringKindAnnual
};


@interface XZCareOneDownDelegate ()

- (void)ShowStudyOverview;

@property (nonatomic, strong)   XZCareOneDownProfileExtender*   profileExtender;
@property (nonatomic, assign)   NSInteger                       environment;


@end

@implementation XZCareOneDownDelegate

-(NSArray*)getAppMainStoryboardInfo
{
    return @[
             @{@"name": kActivitiesStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]},
             @{@"name": kOneDownDashboardStoryboard, @"bundle" : [NSBundle mainBundle]},
             @{@"name": kLearnStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]},
             @{@"name": kHealthProfileStoryBoardKey, @"bundle" : [NSBundle XZCareCoreBundle]}
             ];
}

- (void) setUpInitializationOptions
{
    NSDictionary *permissionsDescriptions = @{
                                              @(kXZCareSignUpPermissionsTypeLocation) : NSLocalizedString(@"Using your GPS enables the app to accurately determine distances travelled. Your actual location will never be shared.", @""),
                                              @(kXZCareSignUpPermissionsTypeCoremotion) : NSLocalizedString(@"Using the motion co-processor allows the app to determine your activity, helping the study better understand how activity level may influence disease.", @""),
                                              @(kXZCareSignUpPermissionsTypeMicrophone) : NSLocalizedString(@"Access to microphone is required for your Voice Recording Activity.", @""),
                                              @(kXZCareSignUpPermissionsTypeLocalNotifications) : NSLocalizedString(@"Allowing notifications enables the app to show you reminders.", @""),
                                              @(kXZCareSignUpPermissionsTypeHealthKit) : NSLocalizedString(@"On the next screen, you will be prompted to grant GlucoSuccess access to read and write some of your general and health information, such as height, weight and steps taken so you don't have to enter it again.", @""),
                                              };
    
    NSMutableDictionary * dictionary = [super defaultInitializationOptions];
    
    /*????
     #ifdef DEBUG
     self.environment = SBBEnvironmentStaging;
     #else
     self.environment = SBBEnvironmentProd;
     #endif
     */
    
    [dictionary addEntriesFromDictionary:@{
                                           kStudyIdentifierKey                  : kStudyIdentifier,
                                           kAppPrefixKey                        : kAppPrefix,
                                           kBridgeEnvironmentKey                : @(self.environment),
                                           kHKReadPermissionsKey                : @[
                                                   HKQuantityTypeIdentifierBloodPressureSystolic,
                                                   HKQuantityTypeIdentifierBloodPressureDiastolic,
                                                   HKQuantityTypeIdentifierBodyMass,
                                                   HKQuantityTypeIdentifierHeight,
                                                   HKQuantityTypeIdentifierStepCount,
                                                   HKQuantityTypeIdentifierDietaryCarbohydrates,
                                                   HKQuantityTypeIdentifierDietarySugar,
                                                   HKQuantityTypeIdentifierDietaryEnergyConsumed,
                                                   HKQuantityTypeIdentifierBloodGlucose
                                                   ],
                                           kHKWritePermissionsKey                : @[
                                                   HKQuantityTypeIdentifierBloodPressureSystolic,
                                                   HKQuantityTypeIdentifierBloodPressureDiastolic,
                                                   HKQuantityTypeIdentifierBloodGlucose,
                                                   HKQuantityTypeIdentifierBodyMass,
                                                   HKQuantityTypeIdentifierHeight
                                                   ],
                                           kAppServicesListRequiredKey           : @[
                                                   @(kXZCareSignUpPermissionsTypeLocalNotifications),
                                                   @(kXZCareSignUpPermissionsTypeCoremotion)
                                                   ],
                                           kAppServicesDescriptionsKey : permissionsDescriptions,
                                           kAppProfileElementsListKey            : @[
                                                   @(kXZCareUserInfoItemTypeEmail),
                                                   @(kXZCareUserInfoItemTypeBiologicalSex),
                                                   @(kXZCareUserInfoItemTypeHeight),
                                                   @(kXZCareUserInfoItemTypeWeight),
                                                   @(kXZCareUserInfoItemTypeBloodPressureSystolic),
                                                   @(kXZCareUserInfoItemTypeBloodPressureDiastolic),
                                                   /*@(kXZCareUserInfoItemTypeGlucoseLevel)*/
                                                   ]
                                           }];
    self.initializationOptions = dictionary;
    
    self.profileExtender = [[XZCareOneDownProfileExtender alloc] init];
}


-(void)setUpTasksReminder
{
    XZCareTaskReminder *weightSurveyReminder = [[XZCareTaskReminder alloc]initWithTaskID:kWeightCheckSurveyIdentifier reminderBody:NSLocalizedString(@"Complete Weight Measurement", nil)];
   
    XZCareTaskReminder *glucoseSurveyReminder = [[XZCareTaskReminder alloc]initWithTaskID:kGlucoseLogSurveyIdentifier reminderBody:NSLocalizedString(@"Complete Glucose Log", nil)];
    
    XZCareTaskReminder *dailyBloodPressureSurveyReminder = [[XZCareTaskReminder alloc]initWithTaskID:kBloodPressureCheckIdentifier reminderBody:NSLocalizedString(@"Complete Daily Blood Pressure Check", nil)];
    
   XZCareTaskReminder *OneDwonReminder = [[XZCareTaskReminder alloc] initWithTaskID:kXZCareHerbOneDownLogIdentifier reminderBody:NSLocalizedString(@"Complete OneDown Log", nil)];
  
    
    XZCareTaskReminder *OneIRRTeaReminder = [[XZCareTaskReminder alloc]initWithTaskID:kXZCareHerbIRRTeaLogIdentifier reminderBody:NSLocalizedString(@"Complete IRR Tea Log", nil)]; //??????"Complete Medicine Log"
    XZCareTaskReminder *ThreeDownReminder = [[XZCareTaskReminder alloc]initWithTaskID:kXZCareHerbThreeDownLogIdentifier reminderBody:NSLocalizedString(@"Three Down Energry & Calm Log", nil)];
    
    XZCareTaskReminder *EnergryCalmReminder = [[XZCareTaskReminder alloc]initWithTaskID:kXZCareHerbEnergyCalmLogIdentifier reminderBody:NSLocalizedString(@"Energry & Calm Log", nil)];
    
    
    
/*
    NSPredicate *footCheckPredicate = [NSPredicate predicateWithFormat:@"SELF.integerValue == 1"];
    XZCareTaskReminder *footCheckReminder = [[XZCareTaskReminder alloc]initWithTaskID:kDailyFeetCheckSurveyIdentifier resultsSummaryKey:kFeetCheckResultValueKey completedTaskPredicate:footCheckPredicate reminderBody:NSLocalizedString(@"Check Your Feet", nil)];
*/
 
    [self.tasksReminder manageTaskReminder:weightSurveyReminder];
    [self.tasksReminder manageTaskReminder:glucoseSurveyReminder];
//    [self.tasksReminder manageTaskReminder:foodSurveyReminder];
    [self.tasksReminder manageTaskReminder:dailyBloodPressureSurveyReminder];
    
    [self.tasksReminder manageTaskReminder:OneDwonReminder];
    [self.tasksReminder manageTaskReminder:OneIRRTeaReminder];
    [self.tasksReminder manageTaskReminder:ThreeDownReminder];
    [self.tasksReminder manageTaskReminder:EnergryCalmReminder];
    //???
    
    //?????
    //[self.tasksReminder manageTaskReminder:footCheckReminder];
    
    //?????
    [[NSUserDefaults standardUserDefaults]setObject:weightSurveyReminder.reminderBody forKey:weightSurveyReminder.reminderIdentifier];
    
    [[NSUserDefaults standardUserDefaults]setObject:glucoseSurveyReminder.reminderBody forKey:glucoseSurveyReminder.reminderIdentifier];
    
    [[NSUserDefaults standardUserDefaults]setObject:dailyBloodPressureSurveyReminder.reminderBody forKey:dailyBloodPressureSurveyReminder.reminderIdentifier];

    [[NSUserDefaults standardUserDefaults]setObject:OneDwonReminder.reminderBody forKey:OneDwonReminder.reminderIdentifier];

    [[NSUserDefaults standardUserDefaults]setObject:OneIRRTeaReminder.reminderBody forKey:OneIRRTeaReminder.reminderIdentifier];

    [[NSUserDefaults standardUserDefaults]setObject:ThreeDownReminder.reminderBody forKey:ThreeDownReminder.reminderIdentifier];

    [[NSUserDefaults standardUserDefaults]setObject:EnergryCalmReminder.reminderBody forKey:EnergryCalmReminder.reminderIdentifier];
    
}



- (void) setUpAppAppearance
{
    [XZCareAppearanceInfo setAppearanceDictionary:@{
                                                    kPrimaryAppColorKey : [UIColor colorWithRed:0.20 green:0.249 blue:1.0 alpha:1.000],  //#058cbc Diabetes
                                                    kWeightCheckSurveyIdentifier: [UIColor appTertiaryRedColor],
                                                    kGlucoseLogSurveyIdentifier : [UIColor appTertiaryGreenColor],
                                                    kSevenDayAllocationIdentifier: [UIColor appTertiaryBlueColor],
                                                    kDailySleepCheckSurveyIdentifier: [UIColor appTertiaryBlueColor],
                                                    kDailyFeetCheckSurveyIdentifier: [UIColor appTertiaryBlueColor],
                                                    //kWeeklyCheckSurveyIdentifier: [UIColor lightGrayColor],
                                                    kWaistCheckSurveyIdentifier: [UIColor appTertiaryRedColor],
                                                    kFoodLogSurveyIdentifier: [UIColor appTertiaryYellowColor],
                                                    kBloodPressureCheckIdentifier: [UIColor colorWithRed:0.250 green:0.50 blue:1.0 alpha:1.000],
                                                    //??????
                                                    kXZCareHerbIRRTeaLogIdentifier: [UIColor colorWithRed:0.5f green:0.5f blue:1.0f alpha:1.0f],
                                                    kXZCareHerbIRRTeaLogIdentifier: [UIColor colorWithRed:0.3f green:0.3f blue:1.0f alpha:1.0f],
                                                    kXZCareHerbThreeDownLogIdentifier: [UIColor colorWithRed:0.1f green:0.1f blue:1.0f alpha:1.0f],
                                                    kXZCareHerbEnergyCalmLogIdentifier: [UIColor colorWithRed:0.6f green:0.6f blue:1.0f alpha:1.0f],
                                                    //??????
                                                    kBaselineSurveyIdentifier: [UIColor appTertiaryGrayColor],
                                                    }];
    [[UINavigationBar appearance] setTintColor:[UIColor appPrimaryColor]];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName : [UIColor appSecondaryColor1],
                                                            NSFontAttributeName : [UIFont appNavBarTitleFont]
                                                            }];
    [[UIView appearance] setTintColor: [UIColor appPrimaryColor]];
    
    //  Enable server bypass
    self.dataSubstrate.parameters.bypassServer = YES;
}

- (id <XZCareProfileViewControllerDelegate>) profileExtenderDelegate
{
    return self.profileExtender;
}

-(void)ShowOnBoarding
{
    [super ShowOnBoarding];
    [self ShowStudyOverview];
}

- (void)ShowStudyOverview
{
    XZCareStudyOverviewCollectionViewController *studyController = [[UIStoryboard storyboardWithName:kXZCareCoreStudyOverviewStoryboard bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:kXZCareCoreStudyOverviewControlIdentifier];

    [self SetUpRootViewController:studyController];
}


- (BOOL) isVideoShown
{
    return NO;
}

- (NSArray *)reviewConsentActions
{
    return @[kReviewConsentActionPDF, kReviewConsentActionSlides];
}

//- (NSArray *)offsetForTaskSchedules
//{
//    return @[
//             @{
//                 kScheduleOffsetTaskIdKey: @"APHMeasureWaist-8BCC1BB7-4991-4018-B9CA-4DE820B1CC73",
//                 kScheduleOffsetOffsetKey: @(0)
//              },
//             @{
//                 kScheduleOffsetTaskIdKey: @"WeeklyCheck-1E174061-5B02-11E4-8ED6-0800200C9A66",
//                 kScheduleOffsetOffsetKey: @(7)
//              }
//            ];
//}

- (NSDictionary *)migrateTasksAndSchedules:(NSDictionary *)currentTaskAndSchedules
{
    NSMutableDictionary *migratedTaskAndSchedules = nil;
    
    if (currentTaskAndSchedules == nil)
    {
        XZCareLogError(@"Nothing was loaded from the JSON file. Therefore nothing to migrate.");
    }
    else
    {
        migratedTaskAndSchedules = [currentTaskAndSchedules mutableCopy];
        
        NSArray *schedulesToMigrate = @[
/*
                                        @{
                                            kMigrationTaskIdKey: kWeeklyCheckSurveyIdentifier,
                                            kMigrationOffsetByDaysKey: @(5),
                                            kMigrationGracePeriodInDaysKey: @(5),
                                            kMigrationRecurringKindKey: @(TCMOneDownMigrationRecurringKindWeekly)
                                            },
                                        @{
                                            kMigrationTaskIdKey: kSleepSurveyIdentifier,
                                            kMigrationOffsetByDaysKey: @(29),
                                            kMigrationGracePeriodInDaysKey: @(5),
                                            kMigrationRecurringKindKey: @(TCMOneDownMigrationRecurringKindMonthly)
                                            },
                                        @{
                                            kMigrationTaskIdKey: kQualityOfLifeSurveyIdentifier,
                                            kMigrationOffsetByDaysKey: @(34),
                                            kMigrationGracePeriodInDaysKey: @(5),
                                            kMigrationRecurringKindKey: @(TCMOneDownMigrationRecurringKindMonthly)
                                            }
 */
                                        ];
        
        NSArray *schedules = migratedTaskAndSchedules[kJSONSchedulesKey];
        NSMutableArray *migratedSchedules = [NSMutableArray new];
        NSDate *launchDate = [NSDate date];
        
        for (NSDictionary *schedule in schedules)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kMigrationTaskIdKey, schedule[kJSONScheduleTaskIDKey]];
            NSArray *matchedSchedule = [schedulesToMigrate filteredArrayUsingPredicate:predicate];
            
            if (matchedSchedule.count > 0)
            {
                NSDictionary *taskInfo = [matchedSchedule firstObject];
                
                NSMutableDictionary *updatedSchedule = [schedule mutableCopy];
                
                NSDate *offsetDate = [launchDate dateByAddingDays:[taskInfo[kMigrationOffsetByDaysKey] integerValue]];
                
                NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday;
                
                NSDateComponents *componentForGracePeriodStartOn = [[NSCalendar currentCalendar] components:units
                                                                                                   fromDate:offsetDate];
                
                NSString *dayOfMonth = [NSString stringWithFormat:@"%ld", (long)componentForGracePeriodStartOn.day];
                NSString *dayOfWeek = nil;
                
                if ([taskInfo[kMigrationRecurringKindKey] integerValue] == TCMOneDownMigrationRecurringKindWeekly)
                {
                    dayOfWeek = [NSString stringWithFormat:@"%ld", (long)componentForGracePeriodStartOn.weekday];
                    dayOfMonth = @"*";
                }
                else
                {
                    dayOfWeek = @"*";
                }
                
                NSString *months = nil;
                
                switch ([taskInfo[kMigrationRecurringKindKey] integerValue])
                {
                    case TCMOneDownMigrationRecurringKindMonthly:
                        months = @"1/1";
                        break;
                    case TCMOneDownMigrationRecurringKindQuarterly:
                        months = @"1/3";
                        break;
                    default:
                        months = @"*";
                        break;
                }
                
                updatedSchedule[kJSONScheduleStringKey] = [NSString stringWithFormat:@"0 5 %@ %@ %@", dayOfMonth, months, dayOfWeek];
                
                [migratedSchedules addObject:updatedSchedule];
            }
            else
            {
                [migratedSchedules addObject:schedule];
            }
        }
        
        migratedTaskAndSchedules[kJSONSchedulesKey] = migratedSchedules;
    }
    
    return migratedTaskAndSchedules;
}

- (NSDictionary *) tasksAndSchedulesWillBeLoaded
{
    NSError *jsonError = nil;
    NSString *resource = [[NSBundle mainBundle] pathForResource:kTasksAndSchedulesJSONFileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:resource];
    NSDictionary *tasksAndScheduledFromJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    NSDictionary *migratedSchedules = [self migrateTasksAndSchedules:tasksAndScheduledFromJSON];
    
    return migratedSchedules;
}

- (void)performMigrationAfterDataSubstrateFrom:(NSInteger) __unused previousVersion currentVersion:(NSInteger) __unused currentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSError *migrationError = nil;
    
    if (self.doesPersisteStoreExist == NO)
    {
        XZCareLogEvent(@"This application is being launched for the first time. We know this because there is no persistent store.");
    }
    else if ( [defaults objectForKey:kXZCarePreviousVersionKey] == nil)
    {
        XZCareLogEvent(@"The entire data model version %d", kTheEntireDataModelOfTheApp);
        
        // Add the newly added surveys
        [self addNewSurveys];
        
        NSError *jsonError = nil;
        NSString *resource = [[NSBundle mainBundle] pathForResource:kTasksAndSchedulesJSONFileName ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:resource];
        NSDictionary *tasksAndScheduledFromJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
        
        NSDictionary *migratedSchedules = [self migrateTasksAndSchedules:tasksAndScheduledFromJSON];
        
        [XZCareCoreDBSchedule updateSchedulesFromJSON:migratedSchedules[kJSONSchedulesKey] inContext:self.dataSubstrate.persistentContext];
    }
    
    [defaults setObject:majorVersion forKey:@"shortVersionString"];
    [defaults setObject:minorVersion forKey:@"version"];
    
    if (!migrationError)
    {
        [defaults setObject:@(currentVersion) forKey:kXZCarePreviousVersionKey];
    }
    
}

- (void)addNewSurveys
{
#define __NO_NEED_SLEEP_SURVEY__
#ifdef __NO_NEED_SLEEP_SURVEY__
    return;
#else
    NSDictionary * staticScheduleAndTask = @{ @"tasks":
                                                  @[
                                                      @{
                                                          @"taskTitle" : @"Sleep Survey",
                                                          @"taskID": kSleepSurveyIdentifier,
                                                          @"taskFileName" : @"DiabetesSleepSurvey",
                                                          @"taskClassName" : @"XZCareGenericSurveyTaskViewController",
                                                          @"taskCompletionTimeString" : @"25 Questions"
                                                          },
                                                      @{
                                                          @"taskTitle" : @"Quality of Life Survery",
                                                          @"taskID": kQualityOfLifeSurveyIdentifier,
                                                          @"taskFileName" : @"DiabetesQoLSurvey",
                                                          @"taskClassName" : @"XZCareGenericSurveyTaskViewController",
                                                          @"taskCompletionTimeString" : @"15 Questions"
                                                          }
                                                      ],
                                              
                                              @"schedules":
                                                  @[
                                                      
                                                      @{
                                                          @"scheduleType": @"recurring",
                                                          @"scheduleString": @"0 5 30 * *",
                                                          @"taskID": kSleepSurveyIdentifier
                                                          },
                                                      @{
                                                          @"scheduleType": @"recurring",
                                                          @"scheduleString": @"0 5 30 * *",
                                                          @"taskID": kQualityOfLifeSurveyIdentifier
                                                          }
                                                      ]
                                              };
    
    // Update schedules based on launch date
    NSDictionary *updatedSchedulesAndTask = [self migrateTasksAndSchedules:staticScheduleAndTask];
    
    [XZCareCoreDBTask updateTasksFromJSON:updatedSchedulesAndTask[@"tasks"]
                          inContext:self.dataSubstrate.persistentContext];
    
    [XZCareCoreDBSchedule createSchedulesFromJSON:updatedSchedulesAndTask[@"schedules"]
                                  inContext:self.dataSubstrate.persistentContext];
    
    XZCareScheduler *scheduler = [[XZCareScheduler alloc] initWithDataSubstrate:self.dataSubstrate];
    [scheduler updateScheduledTasksIfNotUpdating:YES];
#endif
}

- (NSDictionary *)configureTasksForActivities
{
    // Tasks to only show in the Keep Going section.
    // This needs to be re-factored in order to be more flexible.
    return @{
             kActivitiesSectionKeepGoing: @[
                     kSevenDayAllocationIdentifier,
                     kGlucoseLogSurveyIdentifier
                     ],
             kActivitiesRequiresMotionSensor: @[kSevenDayAllocationIdentifier]
             };
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [super applicationDidBecomeActive:application];
    [self startActivityTrackerTask];
}

- (void)afterOnBoardProcessIsFinished
{
    [self startActivityTrackerTask];
}

- (NSDate *)checkSevenDayFitnessStartDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *fitnessStartDate = [defaults objectForKey:kSevenDayFitnessStartDateKey];
    
    if (!fitnessStartDate)
    {
        fitnessStartDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                    minute:0
                                                                    second:0
                                                                    ofDate:[NSDate date]
                                                                   options:0];
        
        [defaults setObject:fitnessStartDate forKey:kSevenDayFitnessStartDateKey];
        [defaults synchronize];
        
    }
    
    return fitnessStartDate;
}

- (NSInteger)fitnessDaysShowing:(XZCareFitnessDaysShows)showKind
{
    NSInteger numberOfDays = 7;
    
    NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                 minute:0
                                                                 second:0
                                                                 ofDate:[self checkSevenDayFitnessStartDate]
                                                                options:0];
    
    NSDate *today = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                             minute:0
                                                             second:0
                                                             ofDate:[NSDate date]
                                                            options:0];
    
    NSDateComponents *numberOfDaysFromStartDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                                  fromDate:startDate
                                                                                    toDate:today
                                                                                   options:NSCalendarWrapComponents];
    
    NSInteger lapsedDays = numberOfDaysFromStartDate.day;
    
    if (showKind == XZCareFitnessDaysShowsRemaining)
    {
        // Compute the remaing days
        if (lapsedDays < 7)
        {
            numberOfDays = 7 - lapsedDays;
        }
    }
    else
    {
        // Compute days lapsed
        if (lapsedDays < 7)
        {
            numberOfDays = (lapsedDays == 0) ? 1 : lapsedDays;
        }
    }
    
    return numberOfDays;
}

- (void)startActivityTrackerTask
{
    BOOL isUserSignedIn = self.dataSubstrate.currentUser.signedIn;
    if (isUserSignedIn && [XZBaseDeviceHardware isiPhone5SOrNewer])
    {
        NSDate *fitnessStartDate = [self checkSevenDayFitnessStartDate];
        if (fitnessStartDate)
        {
            self.sevenDayFitnessAllocationData = [[XZCareFitnessAllocation alloc] initWithAllocationStartDate:fitnessStartDate];
            [self.sevenDayFitnessAllocationData startDataCollection];
        }
    }
}

/*********************************************************************************/
#pragma mark - Datasubstrate Delegate Methods
/*********************************************************************************/
-(void)setUpCollectors
{
    
}

/*********************************************************************************/
#pragma mark - APCOnboardingDelegate Methods
/*********************************************************************************/

- (XZCareScene *)inclusionCriteriaSceneForOnboarding:(XZCareOnboarding *) __unused onboarding
{
    XZCareScene *scene = [XZCareScene new];
    scene.name = @"XZCareOneDownInclusionCriteriaViewController";
    scene.storyboardName = @"XZCareOneDownOnboarding";
    scene.bundle = [NSBundle mainBundle];
    
    return scene;
}

- (XZCareScene *)customInfoSceneForOnboarding:(XZCareOnboarding *) __unused onboarding
{
    XZCareScene *scene = [XZCareScene new];
    scene.name = @"XZCareGlucoseLevels";
    scene.storyboardName = @"XZCareOneDownOnboarding";
    scene.bundle = [NSBundle mainBundle];
    
    return scene;
}

/*********************************************************************************/
#pragma mark - Consent
/*********************************************************************************/

- (ORKTaskViewController *)consentViewController
{
    XZCareConsentTask*         task = [[XZCareConsentTask alloc] initWithIdentifier:@"Consent" propertiesFileName:kConsentPropertiesFileName];
    ORKTaskViewController*  consentVC = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:[NSUUID UUID]];
    
    return consentVC;
}


@end
