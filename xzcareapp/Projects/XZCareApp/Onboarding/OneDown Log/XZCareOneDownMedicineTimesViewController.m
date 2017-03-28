//
//  TCMCareOneDownTimesViewController.m
//  TACMCareDiabeteCare
//
//
//  Created by Zhaohui Xing on 2015-05-25.
//  Copyright (c) 2015 E-XZCare. All rights reserved.

#import "XZCareOneDownMedicineTimesViewController.h"
//#import "TCMCareGlucoseLevelsDaysViewController.h"
//#import "TCMCareGlucoseLevelsViewController.h"

/*
static NSString *kGlucoseLevelCellIdentifier = @"GlucoseLevelMealTimeCell";

static NSDateFormatter *dateFormatter = nil;

static NSString *kGlucoseCheckTimesKey         = @"glucoseCheckTimeKey";

static NSString *kGlucoseScheduleBeforeKey     = @"scheduleBeforeKey";
static NSString *kGlucoseScheduleAfterKey      = @"scheduleAfterKey";

NSString *const kTimeOfDayBreakfast           = @"Breakfast";
NSString *const kTimeOfDayLunch               = @"Lunch";
NSString *const kTimeOfDayDinner              = @"Dinner";
NSString *const kTimeOfDayBedTime             = @"Bed Time";
NSString *const kTimeOfDayAfter               = @"After";
NSString *const kTimeOfDayBefore              = @"Before";
NSString *const kTimeOfDayMorningFasting      = @"Morning Fasting";
NSString *const kTimeOfDayOther               = @"Other";
NSString *const kTimeOfDayRecurring           = @"Recurring";

NSString *const kGlucoseLevelTimeOfDayKey     = @"timeOfDay";
NSString *const kGlucoseLevelPeriodKey        = @"period";
NSString *const kGlucoseLevelBeforeKey        = @"before";
NSString *const kGlucoseLevelAfterKey         = @"after";
NSString *const kGlucoseLevelOtherKey         = @"other";
NSString *const kGlucoseLevelScheduledHourKey = @"scheduledHour";
NSString *const kGlucoseLevelIndexPath        = @"indexPath";
NSString *const kGlucoseLevelValueKey         = @"value";

NSString *const kRecurringValueNever          = @"Never";
*/

static NSDateFormatter *dateFormatter = nil;

static NSString *kOneDownLogProfileCellIdentifier = @"OneDownTimeCell";


NSString *const kOneDownBreakfastTime = @"Beakfast 2-4 capsules";
NSString *const kOneDownLunchTime = @"Lunch 2-4 capsules";
NSString *const kOneDownSupperTime = @"Supper 2-4 capsules";

NSString *const kOneDownTimeOfDayKey = @"OneDownTimeOfDay";

NSString *const kOneDownTimePeriodKey           = @"onedownperiod";
NSString *const kOneDownTimeBreakfastKey        = @"onedownbreakfast";
NSString *const kOneDownTimeLunchKey            = @"onedownlunch";
NSString *const kOneDownTimeSupperKey           = @"onedownsupper";

@interface XZCareOneDownMedicineTimesViewController ()

@property (strong, nonatomic) NSString *sceneDataIdentifier;

@property (nonatomic, strong) NSMutableArray *glucoseLevels;

@property (nonatomic, strong) NSMutableArray *glucoseCheckTimes;
@property (nonatomic, strong) NSMutableArray *glucoseMealTimeConfiguration;

@property (nonatomic, strong) NSArray *glucoseCheckSchedules;
@property (nonatomic, strong) NSString *selectedRepeatDays;

@property (nonatomic, strong) NSArray *OneDownTimeDatasource;


@end

@implementation XZCareOneDownMedicineTimesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavAppearance];
    
    self.sceneDataIdentifier = [NSString stringWithFormat:@"%@", kOneDownLogProfileCellIdentifier];
   
/*
    self.glucoseLevels = [NSMutableArray array];
    self.glucoseCheckTimes = [NSMutableArray array];
*/
    self.OneDownTimeDatasource = @[
                                @{
                                    kOneDownTimeOfDayKey: NSLocalizedString(kOneDownBreakfastTime, kOneDownBreakfastTime),
                                    kOneDownTimePeriodKey: kOneDownTimeBreakfastKey
                                },
                                @{
                                    kOneDownTimeOfDayKey: NSLocalizedString(kOneDownLunchTime, kOneDownLunchTime),
                                    kOneDownTimePeriodKey: kOneDownTimeLunchKey
                                },
                                @{
                                    kOneDownTimeOfDayKey: NSLocalizedString(kOneDownSupperTime, kOneDownSupperTime),
                                    kOneDownTimePeriodKey: kOneDownTimeSupperKey
                                }
                            ];
    
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
/*
    NSLog(@"Configuration Mode: %@", (self.isConfigureMode) ? @"YES" : @"NO");
    
    if (self.isConfigureMode)
    {
        [self prepareForConfigurationMode];
    } else
    {
        // check if there is data for the scene
        NSArray *sceneData = [self.onboarding.sceneData valueForKey:self.sceneDataIdentifier];
        
        if (sceneData) {
            [self.glucoseCheckTimes removeAllObjects];
            [self.glucoseCheckTimes addObjectsFromArray:sceneData];
            
            self.navigationItem.rightBarButtonItem.enabled = (self.glucoseCheckTimes.count != 0);
        }
    }
*/
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
/*    if (self.isConfigureMode == NO)
    {
        [self.onboarding.sceneData setValue:[self.glucoseCheckTimes copy]
                                     forKey:self.sceneDataIdentifier];
    } else
    {
        // save data, if needed to data store.
    }
*/
    [super viewWillDisappear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (XZCareOnboarding *)onboarding
{
    return ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).onboarding;
}

- (void)setupNavAppearance
{
    UIBarButtonItem *backBarButton = [XZCareCustomBackButton customBackBarButtonItemWithTarget:self
                                                                                     action:@selector(goBackwards)
                                                                                  tintColor:[UIColor appPrimaryColor]];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
}

- (void)prepareForConfigurationMode
{

//????????????
 //????????????
 //????????????
 //????????????
 
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(saveOneTimeConfiguration)];
    
    self.navigationItem.rightBarButtonItem = btnDone;

/*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.pickedDays = [defaults objectForKey:kGlucoseMealTimePickedDays];
    
    self.glucoseMealTimeConfiguration = [NSMutableArray new];
    self.glucoseMealTimeConfiguration = [self retireveGlucoseLevels];
 
*/
}

- (void)saveOneTimeConfiguration
{
/*
    if ([self.glucoseCheckTimes count] != 0)
    {
        [self setupSchedules];
    }
*/
    [self goBackwards];

}

- (NSMutableArray *)retireveGlucoseLevels
{
    XZCareCoreAppDelegate *apcDelegate = (XZCareCoreAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *normalizedLevels = nil;
    // retrieve glucose levels from the datastore
    NSString *levels = [apcDelegate.dataSubstrate.currentUser glucoseLevels];
    
    if (levels)
    {
        NSData *levelsData = [levels dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        
        normalizedLevels = [NSJSONSerialization JSONObjectWithData:levelsData options:NSJSONReadingAllowFragments error:&error];
    }
    
    return [normalizedLevels mutableCopy];
}

#pragma mark - Navigation

- (IBAction)goForward
{
/*??
    if ([self.glucoseCheckTimes count] != 0 && ![self.selectedRepeatDays isEqualToString:kRecurringValueNever])
    {
        [self.onboarding.sceneData setObject:[self.glucoseCheckTimes copy] forKey:self.onboarding.currentStep.identifier];
        [self setupSchedules];
    }


    UIViewController *viewController = [[self onboarding] nextScene];
    [self.navigationController pushViewController:viewController animated:YES];
??*/ 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBackwards
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Glucose Levels

- (void)setupSchedules
{

/*
 
????
    APCAppDelegate *appDelegate = (APCAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDate *userSleepTime = appDelegate.dataSubstrate.currentUser.sleepTime;
    NSDate *userWakeTime = appDelegate.dataSubstrate.currentUser.wakeUpTime;
    NSDate *scheduleTime = nil;
    
    if (!userWakeTime)
    {
        userWakeTime = [[NSCalendar currentCalendar] dateBySettingHour:06
                                                                minute:00
                                                                second:00
                                                                ofDate:[NSDate date]
                                                               options:0];
    }
    
    if (!userSleepTime) {
        userSleepTime = [[NSCalendar currentCalendar] dateBySettingHour:21
                                                                 minute:00
                                                                 second:00
                                                                 ofDate:[NSDate date]
                                                                options:0];
    }
    
    NSMutableArray *scheduleTimes = [NSMutableArray array];
    
    for (NSDictionary *checkTime in self.glucoseCheckTimes) {
        NSString *timeOfDay = checkTime[kGlucoseLevelTimeOfDayKey];
        NSString *period = checkTime[kGlucoseLevelPeriodKey];
        
        if (!scheduleTime) {
            if ([timeOfDay isEqualToString:kTimeOfDayBedTime]) {
                scheduleTime = userSleepTime;
            } else {
                scheduleTime = userWakeTime;
            }
        }
        
        if ([timeOfDay isEqualToString:kTimeOfDayBedTime]) {
            if ([period isEqualToString:kGlucoseLevelBeforeKey]) {
                scheduleTime = [self offsetByDate:userSleepTime byHour:-1];
            }
        } else if ([timeOfDay isEqualToString:kTimeOfDayDinner]) {
            if ([period isEqualToString:kGlucoseLevelBeforeKey]) {
                scheduleTime = [self offsetByDate:userSleepTime byHour:-4];
            } else {
                scheduleTime = [self offsetByDate:userSleepTime byHour:-2];
            }
        } else if ([timeOfDay isEqualToString:kTimeOfDayMorningFasting]){
            if ([period isEqualToString:kGlucoseLevelBeforeKey]) {
                scheduleTime = [self offsetByDate:userWakeTime byHour:1];
            } else {
                scheduleTime = [self offsetByDate:userWakeTime byHour:3];
            }
        } else if ([timeOfDay isEqualToString:kTimeOfDayOther]){
            scheduleTime = [self offsetByDate:userSleepTime byHour:2];
        } else {
            if ([period isEqualToString:kGlucoseLevelBeforeKey]) {
                scheduleTime = [self offsetByDate:scheduleTime byHour:4];
            } else {
                scheduleTime = [self offsetByDate:scheduleTime byHour:6];
            }
        }
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:scheduleTime];
        
        for (NSNumber *hour in scheduleTimes) {
            if ([hour isEqual:@(components.hour)]) {
                APCLogDebug(@"Duplicate hour: %@", hour);
                components.hour = [hour integerValue] + 1;
            }
        }
        
        [scheduleTimes addObject:[NSNumber numberWithInteger:components.hour]];
    }
    
    // To avoid duplicate schedules we will check to see if we already have
    // a schedule in place.
    NSFetchRequest *request = [APCSchedule request];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(taskID == %@)", kGlucoseLogSurveyIdentifier];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *entries = [appDelegate.dataSubstrate.mainContext executeFetchRequest:request
                                                                            error:&error];
    
    APCSchedule *glucoseSchedule = nil;
    
    if (self.isConfigureMode == YES) {
        // We need to get the scheduled hours from the stored levels, if any
        // with the newly selected meal times.
        NSArray *existingScheduledHours = [self.glucoseMealTimeConfiguration valueForKey:kGlucoseLevelScheduledHourKey];
        
        [scheduleTimes addObjectsFromArray:existingScheduledHours];
        
        NSArray *uniqueScheduleTimes = [self makeHoursUniqueForMealTimes:scheduleTimes];
        
        [scheduleTimes removeAllObjects];
        [scheduleTimes addObjectsFromArray:uniqueScheduleTimes];
        
        // Merge the newly selected meal times with the ones that are retieved
        // from the datastore.
        [self.glucoseCheckTimes addObjectsFromArray:self.glucoseMealTimeConfiguration];
    }
    
    NSArray *sortedScheduleTimes = [scheduleTimes sortedArrayUsingSelector:@selector(compare:)];
    NSString *repeatDays = [self convertDayNames:self.pickedDays];
    NSString *scheduleString = [NSString stringWithFormat:@"0 %@ * * %@", [sortedScheduleTimes componentsJoinedByString:@","], repeatDays];
    
    if ([entries count] == 0) {
        glucoseSchedule = [APCSchedule newObjectForContext:appDelegate.dataSubstrate.mainContext];
        
        APCLogDebug(@"Sleep/Wake: %@/%@", userSleepTime, userWakeTime);
        APCLogDebug(@"Glucose schedule: %@", scheduleString);
        
        glucoseSchedule.scheduleString = scheduleString;
        glucoseSchedule.taskID = kGlucoseLogSurveyIdentifier;
        glucoseSchedule.scheduleType = @"recurring";
        
        NSError *glucoseScheduleError = nil;
        BOOL saveSuccess = [glucoseSchedule saveToPersistentStore:&glucoseScheduleError];
        
        if (!saveSuccess) {
            APCLogError2(glucoseScheduleError);
        }
        
        // Send the schedule notification
        [[NSNotificationCenter defaultCenter] postNotificationName:APCScheduleUpdatedNotification
                                                            object:nil];
    } else {
        glucoseSchedule = [entries firstObject];
        glucoseSchedule.scheduleString = scheduleString;
        
        NSError *glucoseScheduleError = nil;
        BOOL saveSuccess = [glucoseSchedule saveToPersistentStore:&glucoseScheduleError];
        
        if (!saveSuccess) {
            APCLogError2(glucoseScheduleError);
        } else {
            [self createSchedulesForMealTimes:sortedScheduleTimes forSchedule:glucoseSchedule];
        }
    }
    
    [self saveGlucoseSetup:sortedScheduleTimes];

*/
    
}

- (NSArray *)makeHoursUniqueForMealTimes:(NSArray *)mealTimeHours
{
    NSMutableArray *uniqueHours = [NSMutableArray new];
    NSCountedSet *countedHours = [[NSCountedSet alloc] initWithArray:mealTimeHours];
    
    for (id duplicateHour in countedHours) {
        NSUInteger occurrence = [countedHours countForObject:duplicateHour];
        
        if ( occurrence > 1) {
            // Add the first occurrence to uniqueHours, since we are starting with
            // the second occurrence.
            [uniqueHours addObject:(NSNumber *)duplicateHour];
            
            // Loop through the occurrences, starting with the second one. Since that
            // is the one that we need to updated.
            for (NSUInteger idx = 1; idx < occurrence; idx++) {
                NSUInteger uniqueHour = [(NSNumber *)duplicateHour integerValue] + idx;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELf = %@", @(uniqueHour)];
                NSArray *matchedHour = [mealTimeHours filteredArrayUsingPredicate:predicate];
                
                if (matchedHour.count == 0) {
                    [uniqueHours addObject:@(uniqueHour)];
                }
            }
        } else {
            [uniqueHours addObject:(NSNumber *)duplicateHour];
        }
    }
    
    return uniqueHours;
}

- (void)createSchedulesForMealTimes:(NSArray *)hours forSchedule:(XZCareCoreDBSchedule *)schedule
{
    
/*
???
    APCAppDelegate *appDelegate = (APCAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    NSManagedObjectContext * localContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//    localContext.parentContext = appDelegate.dataSubstrate.persistentContext;
    NSManagedObjectContext *localContext = appDelegate.dataSubstrate.mainContext;
    
    APCSchedule *glucoseSchedule = (APCSchedule *)[localContext objectWithID:schedule.objectID];
    APCTask *glucoseLogTask = [APCTask taskWithTaskID:kGlucoseLogSurveyIdentifier
                                            inContext:localContext];
    
    NSArray *listOfScheduledTasks = [schedule.scheduledTasks allObjects];
    NSArray *scheduledStartTimes = [[listOfScheduledTasks valueForKey:@"startOn"] sortedArrayUsingSelector:@selector(compare:)];
    
    // Get the dates from the scheduled task's start time.
    NSMutableArray *entryStartDates = [NSMutableArray new];
    
    for (NSDate *entryDate in scheduledStartTimes) {
        NSDate *entryDateAtMidnight = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                               minute:0
                                                                               second:0
                                                                               ofDate:entryDate
                                                                              options:0];
        [entryStartDates addObject:entryDateAtMidnight];
    }
    
    NSSet *entryDates = [NSSet setWithArray:entryStartDates];
    
    // remove items that are in self.glucoseMealTimeConfiguration from the hours array
    NSArray *existingHours = [self.glucoseMealTimeConfiguration valueForKey:kGlucoseLevelScheduledHourKey];
    NSMutableArray *newlyAddedHours = [hours mutableCopy];
    
    for (NSNumber *existingHour in existingHours) {
        [newlyAddedHours removeObjectIdenticalTo:existingHour];
    }
    
    // Loop through all newly added meal times and create a schedule
    // for the hours in newlyAddedHours array.
    for (NSDate *taskStartDate in [entryDates allObjects]) {
        
        for (NSNumber *hour in newlyAddedHours) {
            NSDate *entryDateStart = [[NSCalendar currentCalendar] dateBySettingHour:[hour integerValue]
                                                                              minute:0
                                                                              second:0
                                                                              ofDate:taskStartDate
                                                                             options:0];
            
            NSDate *entryDateEnd = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                            minute:59
                                                                            second:59
                                                                            ofDate:taskStartDate
                                                                           options:0];
            
            // Let's create the scheduled task for the provided date
            APCScheduledTask *scheduledTaskForNewEntry = [APCScheduledTask newObjectForContext:appDelegate.dataSubstrate.mainContext];
            scheduledTaskForNewEntry.startOn = entryDateStart;
            scheduledTaskForNewEntry.endOn = entryDateEnd;
            scheduledTaskForNewEntry.completed = @(NO);
            scheduledTaskForNewEntry.task = glucoseLogTask;
            scheduledTaskForNewEntry.generatedSchedule = glucoseSchedule;
            
            NSError *newEntryError = nil;
            BOOL saveSuccess = [scheduledTaskForNewEntry saveToPersistentStore:&newEntryError];
            
            if (!saveSuccess) {
                APCLogError2(newEntryError);
            } else {
                //DEBUG
                APCLogDebug(@"Scheduled Task UID: %@ (Start: %@ | End: %@)",
                            scheduledTaskForNewEntry.uid, scheduledTaskForNewEntry.startOn, scheduledTaskForNewEntry.endOn);
            }
        }
    }
 
*/
 
}

- (NSString *)convertDayNames:(NSString *)selectedDays
{
    NSString *converted = nil;
    
    if (!selectedDays || [selectedDays isEqualToString:@"Everyday"]) {
        converted = @"*";
    } else {
        NSArray *days = [selectedDays componentsSeparatedByString:@" "];
        NSArray *refenceDayNames = nil;
        NSMutableArray *repeatDays = [NSMutableArray array];
        
        if ([days count] == 1) {
            refenceDayNames = [dateFormatter weekdaySymbols];
        } else {
            refenceDayNames = [dateFormatter shortWeekdaySymbols];
        }
        
        for (NSString *day in days) {
            
            if ([refenceDayNames containsObject:day]) {
                NSUInteger dayIndex = [refenceDayNames indexOfObject:day];
                [repeatDays addObject:@(dayIndex)];
            }
        }
        
        converted = [repeatDays componentsJoinedByString:@","];
    }
    
    return converted;
}

- (void)saveGlucoseSetup:(NSArray *)scheduleHours
{

/*
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"indexPath" ascending:YES selector:@selector(compare:)];
    [self.glucoseCheckTimes sortUsingDescriptors:@[sortDescriptor]];
    
    for (NSUInteger idx = 0; idx < self.glucoseCheckTimes.count; idx++) {
        NSMutableDictionary *timeForChecking = [[self.glucoseCheckTimes objectAtIndex:idx] mutableCopy];
        
        timeForChecking[kGlucoseLevelScheduledHourKey] = [scheduleHours objectAtIndex:idx];
        
        [self.glucoseCheckTimes replaceObjectAtIndex:idx withObject:timeForChecking];
    }
    
    APCLogDebug(@"Glucose meal times: %@", self.glucoseCheckTimes);
    
    APCAppDelegate *apcDelegate = (APCAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    NSData *glucoseLevelData = [NSJSONSerialization dataWithJSONObject:self.glucoseCheckTimes options:0 error:&error];
    NSString *levels = [[NSString alloc] initWithData:glucoseLevelData encoding:NSUTF8StringEncoding];
    
    // persist glucose levels to the datastore
    [apcDelegate.dataSubstrate.currentUser setGlucoseLevels:levels];
 
*/
    
}

- (NSDate *)offsetByDate:(NSDate *)date byHour:(NSUInteger)hour
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hour];
    
    NSDate *spanDate = [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                                     toDate:date
                                                                    options:0];
    return spanDate;
}

- (void)updateGlucoseLevelsWithTimeOfDay:(NSString *)timeOfDay
                                 checkAt:(NSString *)checkAt
                              checkValue:(BOOL) __unused value
                             atIndexPath:(NSIndexPath *)indexPath
{
    
/*
 
    NSNumber *timeIndexPath = @(indexPath.row);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", kGlucoseLevelIndexPath, timeIndexPath];
    NSArray *filteredTimes = [self.glucoseCheckTimes filteredArrayUsingPredicate:predicate];
    
    if ([filteredTimes count]) {
        NSUInteger existingTimeIndex = [self.glucoseCheckTimes indexOfObject:[filteredTimes firstObject]];
        [self.glucoseCheckTimes removeObjectAtIndex:existingTimeIndex];
    } else {
        [self.glucoseCheckTimes addObject:@{
                                            kGlucoseLevelTimeOfDayKey: timeOfDay,
                                            kGlucoseLevelPeriodKey: checkAt,
                                            kGlucoseLevelScheduledHourKey: @(0),
                                            @"indexPath": timeIndexPath
                                            }];
    }
 
*/
    
}

- (BOOL)fixedGlucoseMealTimeAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isFixedMealTime = NO;
    
/*
 
    if (self.glucoseMealTimeConfiguration.count > 0) {
        NSArray *mealTimeIndices = [self.glucoseMealTimeConfiguration valueForKey:kGlucoseLevelIndexPath];
        
        isFixedMealTime = [mealTimeIndices containsObject:@(indexPath.row)];
    }
*/
    
    return isFixedMealTime;
}

#pragma mark - TableView
#pragma mark Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *) __unused tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *) __unused tableView numberOfRowsInSection:(NSInteger) __unused section
{
    return [self.OneDownTimeDatasource count];
}

- (CGFloat)tableView:(UITableView *) __unused tableView heightForRowAtIndexPath:(NSIndexPath *) __unused indexPath
{
    return 65.0;//kGlucoseLevelCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOneDownLogProfileCellIdentifier
                                                            forIndexPath:indexPath];
    
//??    NSDictionary *OneDownTime = [self.OneDownTimeDatasource objectAtIndex:indexPath.row];

 
    if (indexPath.row == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", kOneDownBreakfastTime];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", kOneDownLunchTime];
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", kOneDownSupperTime];
    }

/*
    else
    {
        
        NSString *beforeOrAfter = mealTime[kGlucoseLevelPeriodKey];
        NSString *timeOfDayPeriod = nil;
        
        if ([beforeOrAfter isEqualToString:kGlucoseLevelBeforeKey]) {
            timeOfDayPeriod = kTimeOfDayBefore;
        } else if ([beforeOrAfter isEqualToString:kGlucoseLevelAfterKey] && ![mealTime[kGlucoseLevelTimeOfDayKey] isEqualToString:kTimeOfDayOther]) {
            timeOfDayPeriod = kTimeOfDayAfter;
        } else {
            timeOfDayPeriod = @"";
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", timeOfDayPeriod, mealTime[kGlucoseLevelTimeOfDayKey]];
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %lu", kGlucoseLevelIndexPath, indexPath.row];
    NSArray *selectedMealTimes = [self.glucoseCheckTimes filteredArrayUsingPredicate:predicate];
    NSDictionary *selectedMealTime = [selectedMealTimes firstObject];
    NSNumber *selectedMealTimeIndex = selectedMealTime[kGlucoseLevelIndexPath];
    
    if (selectedMealTimeIndex && ([selectedMealTimeIndex integerValue] == indexPath.row)) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor appPrimaryColor];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    BOOL alreadySelectedMealTime = [self fixedGlucoseMealTimeAtIndexPath:indexPath];
    if (self.isConfigureMode && alreadySelectedMealTime) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
*/
    return cell;
}

#pragma mark Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isFixedMealTime = [self fixedGlucoseMealTimeAtIndexPath:indexPath];
    
    if (isFixedMealTime == NO) {
    
        NSDictionary *mealTime = [self.mealTimeDatasource objectAtIndex:indexPath.row];
        
        NSString *mealTimeName = mealTime[kGlucoseLevelTimeOfDayKey];
        NSString *period = mealTime[kGlucoseLevelPeriodKey];

        [self updateGlucoseLevelsWithTimeOfDay:mealTimeName
                                       checkAt:period
                                    checkValue:YES
                                   atIndexPath:indexPath];
        
        self.navigationItem.rightBarButtonItem.enabled = (self.glucoseCheckTimes.count != 0);
        
        [tableView reloadData];
    }
*/ 
}
@end
