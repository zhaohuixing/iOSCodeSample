// 
//  APHDashboardViewController.m 
//  GlucoSuccess 
// 
// Copyright (c) 2015, Massachusetts General Hospital. All rights reserved. 
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2.  Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution. 
// 
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission. No license is granted to the trademarks of 
// the copyright holders even if such marks are included in this software. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
// 
 
/* Controllers */
#import <XZCareCore/XZCareCore.h>
#import "XZCareOneDownDashboardViewController.h"
#import "XZCareOneDownDashboardEditViewController.h"
#import "XZCareOneDownDelegate.h"
#import "XZCareOneDownGlucoseInsightsViewController.h"
#import "XZCareExtendTableViewItem.h"
#import "XZCareOneDownFoodInsightsViewController.h"
#import "XZCareAppConstants.h"

static NSString * const kXZCareDashboardInsightsTableViewCellIdentifier = @"XZCareDashboardInsightsTableViewCell";
static NSString * const kXZCareDashboardInsightTableViewCellIdentifier = @"XZCareDashboardInsightTableViewCell";
static NSString * const kXZCareDashboardFoodInsightHeaderCellIdentifier = @"XZCareDashboardInsightsTableViewCell";
static NSString * const kXZCareDashboardFoodInsightCellIdentifier = @"XZCareDashboardFoodInsightCell";
static NSInteger  const kDataCountLimit                         = 1;

static double kRefershDelayInSeconds = 20; // 3 minutes

static int64_t kDelayCout = 0;

@interface XZCareOneDownDashboardViewController ()<UIViewControllerTransitioningDelegate, XZCareFoodInsightDelegate, XZCarePieGraphViewDatasource>

@property (nonatomic, strong) NSMutableArray *rowItemsOrder;

@property (nonatomic, strong) __block XZCareScoring *stepScoring;
@property (nonatomic, strong) __block XZCareScoring *glucoseScoring;
@property (nonatomic, strong) __block XZCareScoring *weightScoring;
@property (nonatomic, strong) __block XZCareScoring *carbScoring;
@property (nonatomic, strong) __block XZCareScoring *sugarScoring;
//@property (nonatomic, strong) __block XZCareScoring *waistScoring;
@property (nonatomic, strong) __block XZCareScoring *calorieScoring;

@property (nonatomic, strong) __block XZCareScoring *oneDownDailyScoring;
@property (nonatomic, strong) __block XZCareScoring *irrTeaScoring;
@property (nonatomic, strong) __block XZCareScoring *threeDownScoring;
@property (nonatomic, strong) __block XZCareScoring *energyCalmScoring;

@property (nonatomic, strong) __block XZCareScoring *dailySystolicScoring;
@property (nonatomic, strong) __block XZCareScoring *dailyDiastolicScoring;

@property (nonatomic, strong) NSArray *allocationDataset;
@property (nonatomic) NSInteger dataCount;

@property (nonatomic, strong) NSOperationQueue *insightAndScoringQueue;

@property (nonatomic, strong) NSTimer *syncDataTimer;

@property (weak, nonatomic)IBOutlet UIBarButtonItem*   editButton;


- (void)prepareData;

@end

@implementation XZCareOneDownDashboardViewController


#pragma mark - Data

- (void)updatePieChart:(NSNotification *) __unused notification
{
    XZCareOneDownDelegate *appDelegate = (XZCareOneDownDelegate *)[[UIApplication sharedApplication] delegate];
    self.allocationDataset = [appDelegate.sevenDayFitnessAllocationData todaysAllocation];
    [self.tableView reloadData];
}

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _rowItemsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kXZCareDashboardRowItemsOrder]];
        
        if (!_rowItemsOrder.count) {
            _rowItemsOrder = [[NSMutableArray alloc] initWithArray:@[
                                                                     @(kAPHDashboardItemTypeFitness),
                                                                     @(kAPHDashboardItemTypeGlucoseInsights),
                                                                     @(kAPHDashboardItemTypeDietInsights),
                                                                     @(kAPHDashboardItemTypeGlucose),
                                                                     
                                                                     @(kAPHDashboardItemTypeDailySleep),
                                                                     @(kAPHDashboardItemTypeDailyFeet),
        
                                                                     @(kAPHDashboardItemTypeOneDownDaily),
                                                                     @(kAPHDashboardItemTypeIRRTeaDaily),
                                                                     @(kAPHDashboardItemTypeThreeDownDaily),
                                                                     @(kAPHDashboardItemTypeEnergyCalmDaily),

                                                                     @(kAPHDashboardItemTypeSteps),
                                                                     @(kAPHDashboardItemTypeCalories),
                                                                     @(kAPHDashboardItemTypeCarbohydrate),
                                                                     @(kAPHDashboardItemTypeSugar),
                                                                     @(kAPHDashboardItemTypeWaist),
                                                                     
                                                                     @(kAPHDashboardItemTypeSystolic),
                                                                     @(kAPHDashboardItemTypeDiastolic),
                                                                     
                                                                     @(kAPHDashboardItemTypeWeight)
                                                                     ]];
            
            [defaults setObject:[NSArray arrayWithArray:_rowItemsOrder] forKey:kXZCareDashboardRowItemsOrder];
            [defaults synchronize];
            
        }
        
        self.title = NSLocalizedString(@"Dashboard", @"Dashboard");
    
    }
    
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
#ifdef __DASHBOARD_SETTING_UNEDITABLE__
    self.editButton.enabled = NO;
#endif
    
    self.insightAndScoringQueue = [NSOperationQueue sequentialOperationQueueWithName:@"Insights and Scoring"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.stepInsight = [[XZCareInsights alloc] initWithFactor:XZCareInsightFactorSteps
                                          numberOfReadings:@(kNumberOfDaysToDisplay)
                                             insightPeriod:@(-1)
                                              baselineHigh:@(130)
                                             baselineOther:@(180)];
    
    self.carbsInsight = [[XZCareInsights alloc] initWithFactor:XZCareInsightFactorCarbohydrateConsumption
                                           numberOfReadings:@(kNumberOfDaysToDisplay)
                                              insightPeriod:@(-1)
                                               baselineHigh:@(130)
                                              baselineOther:@(180)];
    
    self.caloriesInsight = [[XZCareInsights alloc] initWithFactor:XZCareInsightFactorCalories
                                              numberOfReadings:@(kNumberOfDaysToDisplay)
                                                 insightPeriod:@(-1)
                                                  baselineHigh:@(130)
                                                 baselineOther:@(180)];
    
    self.sugarInsight = [[XZCareInsights alloc] initWithFactor:XZCareInsightFactorSugarConsumption
                                           numberOfReadings:@(kNumberOfDaysToDisplay)
                                              insightPeriod:@(-1)
                                               baselineHigh:@(130)
                                              baselineOther:@(180)];
    
    HKSampleType *carbSampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates];
    HKSampleType *sugarSampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietarySugar];
    
    self.carbFoodInsight = [[XZCareFoodInsight alloc] initFoodInsightForSampleType:carbSampleType
                                                                           unit:[HKUnit gramUnit]];
    self.carbFoodInsight.delegate = self;
    
    self.sugarFoodInsight = [[XZCareFoodInsight alloc] initFoodInsightForSampleType:sugarSampleType
                                                                            unit:[HKUnit gramUnit]];
    self.sugarFoodInsight.delegate = self;
    
    //[self preparingScoringObjects];
    //[self prepareData];
    [self syncAllDatasources];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:XZCareSevenDayAllocationDataIsReadyNotification
                                                  object:nil];
    [self removeTimer];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    kDelayCout = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePieChart:)
                                                 name:XZCareSevenDayAllocationDataIsReadyNotification
                                               object:nil];
    self.dataCount = 0;
    
    XZCareOneDownDelegate *appDelegate = (XZCareOneDownDelegate *)[[UIApplication sharedApplication] delegate];
    self.allocationDataset = [appDelegate.sevenDayFitnessAllocationData todaysAllocation];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rowItemsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kXZCareDashboardRowItemsOrder]];
    
    //[self syncAllDatasources];
    
    if (self.syncDataTimer == nil)
    {
        self.syncDataTimer = [NSTimer scheduledTimerWithTimeInterval:kRefershDelayInSeconds
                                                              target:self
                                                            selector:@selector(syncAllDatasources)
                                                            userInfo:nil
                                                             repeats:YES];
    }
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeTimer];
}

- (void)removeTimer
{
    [self.syncDataTimer invalidate];
    self.syncDataTimer = nil;
}

-(void)internalUpdateAll
{
    [self prepareInsights];
    [self preparingScoringObjects];
    [self prepareData];
    ++kDelayCout;
}

- (void)syncAllDatasources
{
    if(kDelayCout <= 3)
    {
        [self internalUpdateAll];
    }
    else
    {
        if(kDelayCout%12 == 0)
        {
            [self internalUpdateAll];
        }
        else
        {
            ++kDelayCout;
        }
    }
}

#ifndef FAST_PREPAREDATA
#define FAST_PREPAREDATA
#endif

- (void)updateVisibleRowsInTableView:(NSNotification *) __unused notification
{
    self.dataCount++;
   
#ifdef FAST_PREPAREDATA
    [self prepareData];
#else
    __weak XZCareOneDownDashboardViewController *weakSelf = self;
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        [weakSelf prepareData];
    }];

#endif

}

#pragma mark - Data

- (void)prepareInsights
{
    __weak XZCareInsights *weakStepInsight = self.stepInsight;
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        [weakStepInsight factorInsight];
    }];
    
    __weak XZCareInsights *weakCarbsInsight = self.carbsInsight;
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        [weakCarbsInsight factorInsight];
    }];
    
    __weak XZCareInsights *weakCaloriesInsight = self.caloriesInsight;
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        [weakCaloriesInsight factorInsight];
    }];
    
    __weak XZCareInsights *weakSugarInsight = self.sugarInsight;
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        [weakSugarInsight factorInsight];
    }];
    
    __weak XZCareFoodInsight *weakCarbFoodInsight = self.carbFoodInsight;
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        [weakCarbFoodInsight insight];
    }];
    
    __weak XZCareFoodInsight *weakSugarFoodInsight = self.sugarFoodInsight;
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        [weakSugarFoodInsight insight];
    }];
}

- (void)preparingScoringObjects
{
    __weak XZCareOneDownDashboardViewController *weakSelf = self;
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        HKQuantityType *hkQuantity = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        weakSelf.stepScoring = [[XZCareScoring alloc] initWithHealthKitQuantityType:hkQuantity
                                                                        unit:[HKUnit countUnit]
                                                                numberOfDays:-kNumberOfDaysToDisplay];
    }];
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.glucoseScoring = [[XZCareScoring alloc] initWithTask:kGlucoseLogSurveyIdentifier
                                                  numberOfDays:-kNumberOfDaysToDisplay
                                                      valueKey:@"value"
                                                       dataKey:nil
                                                       sortKey:nil
                                                       groupBy:XZCareTimelineGroupDay];
    }];

/*
    [self.insightAndScoringQueue addOperationWithBlock:^{
        HKQuantityType *hkQuantity = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
        weakSelf.weightScoring = [[XZCareScoring alloc] initWithHealthKitQuantityType:hkQuantity
                                                                          unit:[HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitPound]
                                                                  numberOfDays:-kNumberOfDaysToDisplay];
#ifdef DEBUG
//        [weakSelf.weightScoring DebugLog];
#endif
    }];
*/
    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.weightScoring = [[XZCareScoring alloc] initWithTask:kWeightCheckSurveyIdentifier
                                                        numberOfDays:-kNumberOfDaysToDisplay
                                                            valueKey:kWeightResultValueKey
                                                             dataKey:nil
                                                             sortKey:nil
                                                             groupBy:XZCareTimelineGroupDay];
    }];

    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        HKQuantityType *hkQuantity = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates];
        weakSelf.carbScoring = [[XZCareScoring alloc] initWithHealthKitQuantityType:hkQuantity
                                                                        unit:[HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitGram]
                                                                numberOfDays:-kNumberOfDaysToDisplay];
    }];
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        HKQuantityType *hkQuantity = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietarySugar];
        weakSelf.sugarScoring = [[XZCareScoring alloc] initWithHealthKitQuantityType:hkQuantity
                                                                         unit:[HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitGram]
                                                                 numberOfDays:-kNumberOfDaysToDisplay];
    }];
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        HKQuantityType *hkQuantity = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
        weakSelf.calorieScoring = [[XZCareScoring alloc] initWithHealthKitQuantityType:hkQuantity
                                                                           unit:[HKUnit unitFromEnergyFormatterUnit:NSEnergyFormatterUnitKilocalorie]
                                                                   numberOfDays:-kNumberOfDaysToDisplay];
    }];
/*
    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.dailySleepScoring = [[XZCareScoring alloc] initWithTask:kDailySleepCheckSurveyIdentifier
                                                                numberOfDays:-kNumberOfDaysToDisplay
                                                                    valueKey:kSleepCheckResultValueKey
                                                                     dataKey:nil
                                                                     sortKey:nil
                                                                 groupBy:XZCareTimelineGroupDay];
    }];
*/
/*
    [self.insightAndScoringQueue addOperationWithBlock:^{
            weakSelf.dailyFeetScoring = [[XZCareScoring alloc] initWithTask:kDailyFeetCheckSurveyIdentifier
                                                                numberOfDays:-kNumberOfDaysToDisplay
                                                                    valueKey:kFeetCheckResultValueKey
                                                                     dataKey:nil
                                                                     sortKey:nil
                                                                     groupBy:XZCareTimelineGroupDay];
    }];
*/
   

    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.oneDownDailyScoring = [[XZCareScoring alloc] initWithTask:kXZCareHerbOneDownLogIdentifier
                                                         numberOfDays:-kNumberOfDaysToDisplay
                                                             valueKey:kMultipleSurveyStepTaskTotalValueKey
                                                              dataKey:nil
                                                              sortKey:nil
                                                              groupBy:XZCareTimelineGroupDay];
#ifdef DEBUG
        [weakSelf.oneDownDailyScoring DebugLog];
#endif
    }];



    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.irrTeaScoring = [[XZCareScoring alloc] initWithTask:kXZCareHerbIRRTeaLogIdentifier
                                                                    numberOfDays:-kNumberOfDaysToDisplay
                                                                        valueKey:kMultipleSurveyStepTaskTotalValueKey
                                                                         dataKey:nil
                                                                         sortKey:nil
                                                                         groupBy:XZCareTimelineGroupDay];
    }];

    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.threeDownScoring = [[XZCareScoring alloc] initWithTask:kXZCareHerbThreeDownLogIdentifier
                                                                 numberOfDays:-kNumberOfDaysToDisplay
                                                                     valueKey:kMultipleSurveyStepTaskTotalValueKey
                                                                      dataKey:nil
                                                                      sortKey:nil
                                                                      groupBy:XZCareTimelineGroupDay];
    }];

    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.energyCalmScoring = [[XZCareScoring alloc] initWithTask:kXZCareHerbEnergyCalmLogIdentifier
                                                           numberOfDays:-kNumberOfDaysToDisplay
                                                               valueKey:kMultipleSurveyStepTaskTotalValueKey
                                                                dataKey:nil
                                                                sortKey:nil
                                                                groupBy:XZCareTimelineGroupDay];
    }];
    

/*
    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.waistScoring = [[XZCareScoring alloc] initWithTask:kWaistCheckSurveyIdentifier
                                                                numberOfDays:-kNumberOfDaysToDisplay
                                                                    valueKey:kWaistResultValueKey
                                                                     dataKey:nil
                                                                     sortKey:nil
                                                                     groupBy:XZCareTimelineGroupDay];
    }];
*/
    
    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.dailySystolicScoring = [[XZCareScoring alloc] initWithTask:kBloodPressureCheckIdentifier
                                                       numberOfDays:-kNumberOfDaysToDisplay
                                                           valueKey:kSystolicResultValueKey
                                                            dataKey:nil
                                                            sortKey:nil
                                                            groupBy:XZCareTimelineGroupDay];
    }];

    [self.insightAndScoringQueue addOperationWithBlock:^{
        weakSelf.dailyDiastolicScoring = [[XZCareScoring alloc] initWithTask:kBloodPressureCheckIdentifier
                                                               numberOfDays:-kNumberOfDaysToDisplay
                                                                   valueKey:kDiastolicResultValueKey
                                                                    dataKey:nil
                                                                    sortKey:nil
                                                                    groupBy:XZCareTimelineGroupDay];
    }];
    
}

- (void)prepareData
{
    [self.items removeAllObjects];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:0];
    
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        NSUInteger allScheduledTasks = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfAllScheduledTasksForToday;
        NSUInteger completedScheduledTasks = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfCompletedScheduledTasksForToday;
        
        {
            XZCareTableViewDashboardProgressItem *item = [XZCareTableViewDashboardProgressItem new];
            item.identifier = kXZCareDashboardProgressTableViewCellIdentifier;
            item.editable = NO;
            item.progress = (CGFloat)completedScheduledTasks/allScheduledTasks;
            item.caption = NSLocalizedString(@"Activity Completion", @"Activity Completion");
            item.info = NSLocalizedString(@"This is the percentage of today’s TCMCareDemo activities that you have completed. You can see what today’s items are at the Activities Menu.", @"");
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = item;
            row.itemType = kXZCareTableViewDashboardItemTypeProgress;
            [rowItems addObject:row];
        }
        
        for (NSNumber *typeNumber in self.rowItemsOrder)
        {
            XZCareDashboardItemType rowType = typeNumber.integerValue;
            
            switch (rowType)
            {
                case kAPHDashboardItemTypeSteps:
               {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Steps", @"");
                    item.graphData = self.stepScoring;
                    
                    NSNumber *numberOfDataPoints = [self.stepScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1)
                    {
                        double avgSteps = [[self.stepScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f",
                                                                                       @"Average: {avg. value}"), avgSteps];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    item.info = NSLocalizedString(@"This plots your number of steps per day. It can be helpful to set a specific step goal each day. Remember to keep your iPhone on your person (e.g., in your pants pocket or clipped to your waist) to most accurately capture your physical activity.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeGlucose:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Glucose", @"Glucose");
                    item.taskId = kGlucoseLogSurveyIdentifier;
                    item.graphData = self.glucoseScoring;
                    
                    NSNumber *numberOfDataPoints = [self.glucoseScoring numberOfDataPoints];
                    if ([numberOfDataPoints integerValue] > 1)
                    {
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Min: %0.0f   Max: %0.0f", @"Min: {value} Max: {value}"),
                                           [[self.glucoseScoring minimumDataPoint] doubleValue], [[self.glucoseScoring maximumDataPoint] doubleValue]];
                    }
                    
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeDiscrete;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryGreenColor];
                    if([((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate) IsMmolUnitForGlucose] == YES)
                    {
                        item.caption = NSLocalizedString(@"Glucose (mmol/L)", @"Glucose (mmol/L)");
                        item.info = NSLocalizedString(@"This plots the blood glucose values you logged every day, as well as the daily minimum and maximum. Ask your physician for your specific targets. General target ranges are: before a meal (fasting or pre-prandial): 3.89 – 7.22 mmol/L; after a meal (post-prandial): less than 10 mmol/L.", @"");
                    }
                    else
                    {
                        item.caption = NSLocalizedString(@"Glucose (mg/dL)", @"Glucose (mg/dL)");
                        item.info = NSLocalizedString(@"This plots the blood glucose values you logged every day, as well as the daily minimum and maximum. Ask your physician for your specific targets. General target ranges are: before a meal (fasting or pre-prandial): 70 – 130 mg/dL; after a meal (post-prandial): less than 180 mg/dL.", @"");
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                    
                }
                    break;
/*
                case kAPHDashboardItemTypeWaist:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Waist", @"Waist");
                    item.graphData = self.waistScoring;
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f in", @"Average: {value} in"),
                                       [[self.waistScoring averageDataPoint] doubleValue]];
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryRedColor];

                //    #warning Replace Placeholder Values - APPLE-1576
                    item.info = @"Daily Waist Measurements";
                    
                    //NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                   
                }
                    break;
*/
                case kAPHDashboardItemTypeSystolic:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Systolic Blood Pressure", @"Systolic Blood Pressure");
                    item.graphData = self.dailySystolicScoring;
                    item.taskId = kBloodPressureCheckIdentifier;
                    
                    NSNumber *numberOfDataPoints = [self.dailySystolicScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1)
                    {
                        int avgSystolic = [[self.dailySystolicScoring averageDataPoint] intValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %i mmHg", @""), avgSystolic];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = YES;
                    item.tintColor = [UIColor colorWithRed:0.90 green:0.30 blue:0.6 alpha:1.000];
                    
                    //    #warning Replace Placeholder Values - APPLE-1576
                    item.info = NSLocalizedString(@"Daily Systolic Measurement", @"Daily Systolic Measurement");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                    
                }
                    break;
                
                case kAPHDashboardItemTypeDiastolic:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Diastolic Blood Pressure", @"Diastolic Blood Pressure");
                    item.graphData = self.dailyDiastolicScoring;
                    item.taskId = kBloodPressureCheckIdentifier;
                    
                    NSNumber *numberOfDataPoints = [self.dailyDiastolicScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1)
                    {
                        int avgSystolic = [[self.dailyDiastolicScoring averageDataPoint] intValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %i mmHg", @""), avgSystolic];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = YES;
                    item.tintColor = [UIColor colorWithRed:0.20 green:0.50 blue:1.00 alpha:1.000];
                    
                    //    #warning Replace Placeholder Values - APPLE-1576
                    item.info = NSLocalizedString(@"Daily Diastolic Measurement", @"Daily Diastolic Measurement");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                    
                }
                break;
                
                case kAPHDashboardItemTypeWeight:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Weight", @"");
                    item.taskId = kWeightCheckSurveyIdentifier;
                    item.graphData = self.weightScoring;
                    
                    NSNumber *numberOfDataPoints = [self.weightScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1)
                    {
                        double avgWeight = [[self.weightScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f lbs", @""), avgWeight];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryRedColor];
                    item.info = NSLocalizedString(@"This plots the weights you entered. Losing even a few pounds can improve your glucose control and overall health. The key is finding a weight that is achievable and sustainable. This is best achieved through small steps and gradual progress in your diet and physical activity.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeCarbohydrate:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Carbohydrates", @"Carbohydrates");
                    item.graphData = self.carbScoring;
                    
                    NSNumber *numberOfDataPoints = [self.carbScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1)
                    {
                        double avgCarbs = [[self.carbScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f g", @"Average: {value}"), avgCarbs];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    item.info = NSLocalizedString(@"This plots the total amount of carbohydrates you consumed each day (in grams). Because carbs are broken down into glucose, they can have a big impact on your glucose values. Your goals will depend on your individual situation, level of physical activity and medicines. A rule of thumb might be about 45-60 grams of carbs per meal, but check with your doctor or nutritionist for recommendations. Complex carbs (whole grains, beans, nuts, vegetables) are preferred over simple carbs (e.g., sugar), but the total amount of carbs you eat per day is important.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                    
                }
                    break;
                    
                case kAPHDashboardItemTypeSugar:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Sugar", @"Sugar");
                    item.graphData = self.sugarScoring;
                    
                    NSNumber *numberOfDataPoints = [self.sugarScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1)
                    {
                        double avgSugar = [[self.sugarScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f g", @"Average: {value}"), avgSugar];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    item.info = NSLocalizedString(@"This plots the amount of sugar you consumed each day (in grams). Added sugar increases glucose values and adds calories, so the goal is to try to decrease added sugar as much as possible (e.g.,  desserts or sugar-sweetened beverages such as soft drinks). A rule of thumb is to avoid foods where sugar, fructose or high-fructose corn syrup are one of the first few ingredients listed.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                    
                }
                    break;
                    
                case kAPHDashboardItemTypeCalories:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Calories", @"Calories");
                    item.graphData = self.calorieScoring;
                    
                    NSNumber *numberOfDataPoints = [self.calorieScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1) {
                        double avgCalories = [[self.calorieScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f Cal", @"Average: {value} Cal"),
                                           avgCalories];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    item.info = NSLocalizedString(@"This plots your daily calories. Controlling the size of your portions (which will help you limit the total calories you eat) is just as important as what kinds of food you eat. Try to set specific strategies and habits to make steady, sustainable progress.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];

                }
                    break;

                case kAPHDashboardItemTypeOneDownDaily:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"OneDown Daily Dosage", @"OneDown Morning Log");
                    item.graphData = self.oneDownDailyScoring;
                    
                    NSNumber *numberOfDataPoints = [self.oneDownDailyScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1)
                    {
                        double avgTimes = [[self.oneDownDailyScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f Dosage", @"Average: {value} Dosage"),
                                           avgTimes];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = NO;
                    item.tintColor = [UIColor colorWithRed:0.5f green:0.5f blue:1.0f alpha:1.0f];
                    item.info = NSLocalizedString(@"This plots your daily OneDown daily dosage.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;

                case kAPHDashboardItemTypeIRRTeaDaily:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"IRR Tea Daily Dosage", @"IRR Tea Daily Dosage Log");
                    item.graphData = self.irrTeaScoring;
                    
                    NSNumber *numberOfDataPoints = [self.irrTeaScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1) {
                        double avgTimes = [[self.irrTeaScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f Dosage", @"Average: {value} Dosage"),
                                           avgTimes];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = YES;
                    item.tintColor = [UIColor colorWithRed:0.3f green:0.3f blue:1.0f alpha:1.0f];
                    item.info = NSLocalizedString(@"This plots your IRR Tea daily dosage.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
/*
                case kAPHDashboardItemTypeDailySleep:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Daily Sleep Tracking", @"Daily Sleep Log");
                    item.graphData = self.dailySleepScoring;
                    
                    NSNumber *numberOfDataPoints = [self.dailySleepScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1) {
                        double avgTimes = [[self.dailySleepScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f Sleeping Hours", @"Average: {value} Sleeping Hours"),
                                           avgTimes];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    item.info = NSLocalizedString(@"This plots your daily sleeping hours.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;

                case kAPHDashboardItemTypeDailyFeet:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Daily Feet Checking", @"Daily Feet Log");
                    item.graphData = self.dailyFeetScoring;
                    
                    //NSNumber *numberOfDataPoints = [self.dailyFeetScoring numberOfDataPoints];
                    
                    item.detailText = @"";
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    item.info = NSLocalizedString(@"This plots your daily feet checking records.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
*/

                case kAPHDashboardItemTypeThreeDownDaily:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"ThreeDown Daily Log", @"Three Down Energry & Calm Daily Log");
                    item.graphData = self.threeDownScoring;
                    
                    NSNumber *numberOfDataPoints = [self.threeDownScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1) {
                        double avgTimes = [[self.threeDownScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f Dosage", @"Average: {value} Dosage"),
                                           avgTimes];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = YES;
                    item.tintColor = [UIColor colorWithRed:0.1f green:0.1f blue:1.0f alpha:1.0f];
                    item.info = NSLocalizedString(@"This plots your ThreeDown daily dosage.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                } 
                    break;
                    
                case kAPHDashboardItemTypeEnergyCalmDaily:
                {
                    XZCareTableViewDashboardGraphItem *item = [XZCareTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Energy & Calm Daily Log", @"Three Down Energry & Calm Daily Log");
                    item.graphData = self.energyCalmScoring;
                    
                    NSNumber *numberOfDataPoints = [self.energyCalmScoring numberOfDataPoints];
                    
                    if ([numberOfDataPoints integerValue] > 1) {
                        double avgTimes = [[self.energyCalmScoring averageDataPoint] doubleValue];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f Dosage", @"Average: {value} Dosage"),
                                           avgTimes];
                    }
                    
                    item.identifier = kXZCareDashboardGraphTableViewCellIdentifier;
                    item.graphType = kXZCareDashboardGraphTypeLine;
                    item.editable = YES;
                    item.tintColor = [UIColor colorWithRed:0.1f green:0.1f blue:1.0f alpha:1.0f];
                    item.info = NSLocalizedString(@"This plots your Energy & Calm daily dosage.", @"");
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    
                    break;
                    
                case kAPHDashboardItemTypeFitness:
                {
                    if ([XZBaseDeviceHardware isMotionActivityAvailable])
                    {
                        XZCareTableViewDashboardFitnessControlItem *item = [XZCareTableViewDashboardFitnessControlItem new];
                        item.caption = NSLocalizedString(@"Activity Tracker", @"");
                        
                        XZCareOneDownDelegate *appDelegate = (XZCareOneDownDelegate *)[[UIApplication sharedApplication] delegate];
                        NSString *sevenDayDistanceStr = nil;
                        
                        NSInteger activeMinutes = roundf(appDelegate.sevenDayFitnessAllocationData.activeSeconds/60);
                        
                        if (activeMinutes != 0)
                        {
                            NSInteger lapsedDays = [appDelegate fitnessDaysShowing:XZCareFitnessDaysShowsLapsed];
                            
                            NSString *wordDay = [NSString stringWithFormat:@"%@", (lapsedDays == 1) ? @"day" : @"days"];
                            NSString *wordMintue = [NSString stringWithFormat:@"%@", (activeMinutes == 1) ? @"minute": @"minutes"];
                            if (lapsedDays >= 3)
                            {
                                sevenDayDistanceStr = [NSString stringWithFormat:@"In the last %ld %@ you have been active for %ld %@ total",
                                                       (long)lapsedDays, wordDay, (long)activeMinutes, wordMintue];
                                
                                item.distanceTraveledString = sevenDayDistanceStr;
                            }
                        }
                        
                        item.identifier = kXZCareDashboardPieGraphTableViewCellIdentifier;
                        item.tintColor = [UIColor appTertiaryBlueColor];
                        item.editable = YES;
                        item.info = NSLocalizedString(@"The circle depicts the percentage of time you spent in various levels of activity over the past 7 days. The recommendation in type 2 diabetes is for at least 150 min of moderate activity per week. The daily activity graphic and assessment are courtesy of the Stanford MyHeart Counts study team.", @"");
                        
                        XZCareTableViewRow *row = [XZCareTableViewRow new];
                        row.item = item;
                        row.itemType = rowType;
                        [rowItems addObject:row];
                    }

                }
                    break;
                
                case kAPHDashboardItemTypeGlucoseInsights:
                {
                    NSString *glucoseLevels = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.currentUser.glucoseLevels;
                    
                    if (glucoseLevels)
                    {
                        {
                            XZCareTableViewDashboardInsightsItem *item = [XZCareTableViewDashboardInsightsItem new];
                            item.editable = NO;
                            item.identifier = kXZCareDashboardInsightsTableViewCellIdentifier;
                            item.caption = NSLocalizedString(@"Glucose Insights", @"Glucose Insights");
                            item.detailText = NSLocalizedString(@"Your behavior on good and bad glucose days", @"Your behavior on good and bad glucose days");
                            item.tintColor = [UIColor appTertiaryBlueColor];
                            item.showTopSeparator = NO;
                            item.info = NSLocalizedString(@"This looks at your recent blood glucoses, and identifies healthy diet or physical activity behaviors associated with your best glucose levels. For instance, this view will show if your best glucose levels are associated with fewer calories consumed, fewer calories from sugar, or more physical activity. Over time, this may help you gain insights into health behaviors that are most effective at controlling blood glucose in you.", @"");
                            
                            XZCareTableViewRow *row = [XZCareTableViewRow new];
                            row.item = item;
                            row.itemType = kAPHDashboardItemTypeInsights;
                            [rowItems addObject:row];
                        }
                        
                        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                        
                        // Calories
                        {
                            XZCareTableViewDashboardInsightItem *item = [XZCareTableViewDashboardInsightItem new];
                            item.editable = NO;
                            item.identifier = kXZCareDashboardInsightTableViewCellIdentifier;
                            item.tintColor = [UIColor appTertiaryBlueColor];
                            
                            if (([self.caloriesInsight.valueGood doubleValue] != NSNotFound) && ([self.caloriesInsight.valueGood doubleValue] != 0))
                            {
                                item.goodBar = ([self.caloriesInsight.valueGood doubleValue] != NSNotFound) ? self.caloriesInsight.valueGood : @(0);
                            }
                            else
                            {
                                item.goodBar = @(0);
                            }
                            
                            if (([self.caloriesInsight.valueBad doubleValue] != NSNotFound) && ([self.caloriesInsight.valueBad doubleValue] != 0))
                            {
                                item.badBar = ([self.caloriesInsight.valueBad doubleValue] != NSNotFound) ? self.caloriesInsight.valueBad : @(0);
                            }
                            else
                            {
                                item.badBar = @(0);
                            }
                            
                            item.goodCaption = self.caloriesInsight.captionGood;
                            item.badCaption = self.caloriesInsight.captionBad;
                            item.insightImage = [UIImage imageNamed:@"glucose_insights_calories"];
                            
                            XZCareTableViewRow *row = [XZCareTableViewRow new];
                            row.item = item;
                            row.itemType = kAPHDashboardItemTypeInsights;
                            [rowItems addObject:row];
                        }
                        
                        // Steps
                        {
                            XZCareTableViewDashboardInsightItem *item = [XZCareTableViewDashboardInsightItem new];
                            item.editable = NO;
                            item.identifier = kXZCareDashboardInsightTableViewCellIdentifier;
                            item.tintColor = [UIColor appTertiaryBlueColor];
                            
                            if (([self.stepInsight.valueGood doubleValue] != NSNotFound))
                            {
                                item.goodBar = ([self.stepInsight.valueGood doubleValue] != NSNotFound) ? self.stepInsight.valueGood : @(0);
                            }
                            else
                            {
                                item.goodBar = @(0);
                            }
                            
                            if (([self.stepInsight.valueBad doubleValue] != NSNotFound))
                            {
                                item.badBar = ([self.stepInsight.valueBad doubleValue] != NSNotFound) ? self.stepInsight.valueBad : @(0);
                            }
                            else
                            {
                                item.badBar = @(0);
                            }
                            
                            item.goodCaption = self.stepInsight.captionGood;
                            item.badCaption = self.stepInsight.captionBad;
                            item.insightImage = [UIImage imageNamed:@"glucose_insights_steps"];
                            
                            XZCareTableViewRow *row = [XZCareTableViewRow new];
                            row.item = item;
                            row.itemType = kAPHDashboardItemTypeInsights;
                            [rowItems addObject:row];
                        }
                        
                        // Sugar Calories
                        {
                            XZCareTableViewDashboardInsightItem *item = [XZCareTableViewDashboardInsightItem new];
                            
                            item.editable = NO;
                            item.identifier = kXZCareDashboardInsightTableViewCellIdentifier;
                            item.tintColor = [UIColor appTertiaryBlueColor];
                            
                            NSUInteger caloriesPerGramOfSugar = 4;
                            
                            [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
                            
                            if (([self.caloriesInsight.valueGood doubleValue] != 0) &&
                                ([self.caloriesInsight.valueGood doubleValue] != NSNotFound) &&
                                ([self.sugarInsight.valueGood doubleValue] != 0))
                            {
                                NSNumber *gramsOfSugarConsumed = self.sugarInsight.valueGood;
                                NSNumber *totalNumberOfCaloriesConsumed = self.caloriesInsight.valueGood;
                                double sugarCaloriesConsumed = [gramsOfSugarConsumed doubleValue] * caloriesPerGramOfSugar;
                                double percentOfSugarCalories = sugarCaloriesConsumed / [totalNumberOfCaloriesConsumed doubleValue];
                                
                                double sugarCals = (percentOfSugarCalories < 1) ? percentOfSugarCalories : 1;
                                
                                item.goodCaption = [NSString stringWithFormat:@"%@ Cals as sugar",
                                                    [numberFormatter stringFromNumber:@(sugarCals)]];
                                item.goodBar = @(sugarCals);
                            }
                            else
                            {
                                item.goodCaption = NSLocalizedString(@"Not enough data", @"Not enough data");
                                item.goodBar = @(0);
                            }
                            
                            if ([self.caloriesInsight.valueBad doubleValue] != 0 &&
                                ([self.caloriesInsight.valueBad doubleValue] != NSNotFound) &&
                                ([self.sugarInsight.valueBad doubleValue] != 0))
                            {
                                NSNumber *gramsOfSugarConsumedBad = self.sugarInsight.valueBad;
                                NSNumber *totalNumberOfCaloriesConsumedBad = self.caloriesInsight.valueBad;
                                double sugarCaloriesConsumedBad = [gramsOfSugarConsumedBad doubleValue] * caloriesPerGramOfSugar;
                                double badPercentOfSugarCalories = sugarCaloriesConsumedBad / [totalNumberOfCaloriesConsumedBad doubleValue];
                                
                                double sugarCals = (badPercentOfSugarCalories < 1) ? badPercentOfSugarCalories : 1;
                                
                                item.badCaption = [NSString stringWithFormat:@"%@ Cals as sugar",
                                                   [numberFormatter stringFromNumber:@(sugarCals)]];
                                
                                item.badBar = @(sugarCals);
                            }
                            else
                            {
                                item.badCaption = NSLocalizedString(@"Not enough data", @"Not enough data");
                                item.badBar = @(0);
                            }
                            
                            item.insightImage = [UIImage imageNamed:@"food_insights_sugars"];
                            
                            if ((item.goodBar.doubleValue < item.badBar.doubleValue) && (item.goodBar.doubleValue != 0))
                            {
                                XZCareTableViewRow *row = [XZCareTableViewRow new];
                                row.item = item;
                                row.itemType = kAPHDashboardItemTypeInsights;
                                [rowItems addObject:row];
                            }
                        }
                    }
                }
                    break;
                case kAPHDashboardItemTypeDietInsights:
                {
                    // Food Insights
                    {
                        XZCareTableViewDashboardInsightsItem *item = [XZCareTableViewDashboardInsightsItem new];
                        item.editable = NO;
                        item.identifier = kXZCareDashboardFoodInsightHeaderCellIdentifier;
                        item.caption = NSLocalizedString(@"Diet Insights", @"Diet Insights");
                        
                        if (self.carbFoodInsight.foodHistory.count > 0 && self.sugarFoodInsight.foodHistory.count > 0) {
                            item.detailText = NSLocalizedString(@"Your foods that are high in carbs or sugar", nil);
                        }
                        else
                        {
                            item.detailText = NSLocalizedString(@"Log your meals using the “Log Food” activity to learn about your diet habits",
                                                                @"Log your meals using the \"Log Food\" activity to learn about your diet habits");
                        }
                        
                        item.tintColor = [UIColor appTertiaryYellowColor];
                        item.showTopSeparator = NO;
                        item.info = NSLocalizedString(@"This lists foods high in carbohydrates or sugar, especially those that you have eaten more than once recently. These foods can drive higher blood glucoses, and might be good candidates to cut back on. Remember that fresh fruit is a good source of natural sugar; the focus is on decreasing added sugar (such as sugar-sweetened beverages). ", @"");
                        
                        XZCareTableViewRow *row = [XZCareTableViewRow new];
                        row.item = item;
                        row.itemType = kAPHDashboardItemTypeInsights;
                        [rowItems addObject:row];
                    }
                    
                    if (self.carbFoodInsight.foodHistory)
                    {
                        NSUInteger maxFoodItems = (self.carbFoodInsight.foodHistory.count < 3) ? self.carbFoodInsight.foodHistory.count : 3;
                        for (NSUInteger idx = 0; idx < maxFoodItems; idx++)
                        {
                            NSDictionary *insight = [self.carbFoodInsight.foodHistory objectAtIndex:idx];
                            NSNumber *carbsCals = insight[kFoodInsightCaloriesValueKey];
                            
                            XZCareTableViewDashboardFoodInsightItem *item = [XZCareTableViewDashboardFoodInsightItem new];
                            item.editable = NO;
                            item.identifier = kXZCareDashboardFoodInsightCellIdentifier;
                            item.tintColor = [UIColor appTertiaryYellowColor];
                            item.titleCaption = insight[kFoodInsightFoodNameKey];
                            
                            NSString *subtitle = [NSString stringWithFormat:@"%@ Cals from carbs",
                                                  [numberFormatter stringFromNumber:carbsCals]];
                            
                            item.subtitleCaption = NSLocalizedString(subtitle, @"");
                            item.frequency = insight[kFoodInsightFrequencyKey];
                            item.foodInsightImage = [UIImage imageNamed:@"food_insights_carbs"];
                            
                            XZCareTableViewRow *row = [XZCareTableViewRow new];
                            row.item = item;
                            row.itemType = kAPHDashboardItemTypeInsights;
                            [rowItems addObject:row];
                        }
                    }
                    
                    if (self.sugarFoodInsight.foodHistory)
                    {
                        NSUInteger maxFoodItems = (self.sugarFoodInsight.foodHistory.count < 3) ? self.sugarFoodInsight.foodHistory.count : 3;
                        for (NSUInteger idx = 0; idx < maxFoodItems; idx++)
                        {
                            NSDictionary *insight = [self.sugarFoodInsight.foodHistory objectAtIndex:idx];
                            NSNumber *sugarCals = insight[kFoodInsightCaloriesValueKey];
                            
                            XZCareTableViewDashboardFoodInsightItem *item = [XZCareTableViewDashboardFoodInsightItem new];
                            item.editable = NO;
                            item.identifier = kXZCareDashboardFoodInsightCellIdentifier;
                            item.tintColor = [UIColor appTertiaryYellowColor];
                            item.titleCaption = insight[kFoodInsightFoodNameKey];
                            
                            NSString *subtitle = [NSString stringWithFormat:@"%@ Cals from sugar",
                                                  [numberFormatter stringFromNumber:sugarCals]];
                            
                            item.subtitleCaption = NSLocalizedString(subtitle, @"");
                            item.frequency = insight[kFoodInsightFrequencyKey];
                            item.foodInsightImage = [UIImage imageNamed:@"food_insights_sugars"];
                            
                            XZCareTableViewRow *row = [XZCareTableViewRow new];
                            row.item = item;
                            row.itemType = kAPHDashboardItemTypeInsights;
                            [rowItems addObject:row];
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        XZCareTableViewSection *section = [XZCareTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        section.sectionTitle = NSLocalizedString(@"Recent Activity", @"Recent Activity");
        [self.items addObject:section];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDatasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef DEBUG
    if(self.items == nil)
    {
        NSLog(@"XZCareDashboardViewController items non-existed!\n");
        NSAssert(NO, @"crashed by XZCareDashboardViewController items nil at XZCareOneDownDashboardViewController tableView: cellForRowAtIndexPath:");
        return nil;
    }
    int nItemCount = (int)self.items.count;
    NSLog(@"XZCareDashboardViewController items count: %i at XZCareOneDownDashboardViewController tableView: cellForRowAtIndexPath:", nItemCount);
    if(nItemCount <= 0)
    {
        NSLog(@"XZCareDashboardViewController items no element at XZCareOneDownDashboardViewController tableView: cellForRowAtIndexPath:");
        return nil;
    }
    
    int indexFromPath = (int)indexPath.section;
    NSLog(@"XZCareDashboardViewController indexPath.section: %i at XZCareOneDownDashboardViewController tableView: cellForRowAtIndexPath:", indexFromPath);
    if(nItemCount < indexFromPath)
    {
        NSAssert(NO, @"crashed by nItemCount < indexFromPath at XZCareOneDownDashboardViewController tableView: cellForRowAtIndexPath:");
        return nil;
    }
    
    
//    XZCareTableViewSection *sectionItem = self.items[indexPath.section];
//    XZCareTableViewRow *rowItem = sectionItem.rows[indexPath.row];
    
    
    
#endif
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    XZCareTableViewDashboardItem *dashboardItem = (XZCareTableViewDashboardItem *)[self itemForIndexPath:indexPath];
    
    if ([dashboardItem isKindOfClass:[XZCareTableViewDashboardFitnessControlItem class]])
    {
        XZCareTableViewDashboardFitnessControlItem *fitnessItem = (XZCareTableViewDashboardFitnessControlItem *)dashboardItem;
        
        XZCareDashboardPieGraphTableViewCell *pieGraphCell = (XZCareDashboardPieGraphTableViewCell *)cell;
        
        pieGraphCell.subTitleLabel.text = fitnessItem.numberOfDaysString;
        pieGraphCell.subTitleLabel2.text = fitnessItem.distanceTraveledString;
        
        pieGraphCell.pieGraphView.datasource = self;
        pieGraphCell.textLabel.text = @"";
        pieGraphCell.title = fitnessItem.caption;
        pieGraphCell.tintColor = fitnessItem.tintColor;
        pieGraphCell.pieGraphView.shouldAnimateLegend = NO;

        if (self.dataCount < kDataCountLimit)
        {
            [pieGraphCell.pieGraphView setNeedsLayout];
            //[pieGraphCell.pieGraphView re]
        }
 
        pieGraphCell.delegate = self;
    }
    else if([dashboardItem isKindOfClass:[XZCareTableViewDashboardGraphItem class]])
    {
        XZCareDashboardGraphTableViewCell *graphCell = (XZCareDashboardGraphTableViewCell *)cell;
        if(graphCell && graphCell.lineGraphView)
        {
            [graphCell.lineGraphView refreshGraph];
        }
        if(graphCell && graphCell.discreteGraphView)
        {
            [graphCell.discreteGraphView refreshGraph];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    XZCareTableViewItem *dashboardItem = [self itemForIndexPath:indexPath];
    
    if ([dashboardItem isKindOfClass:[XZCareTableViewDashboardFitnessControlItem class]])
    {
        height = 288.0f;
    }
    
    return height;
}

#pragma mark - Insights Cell Delegate

- (void)dashboardInsightDidExpandForCell:(XZCareDashboardInsightsTableViewCell *)cell
{
    UIViewController *insightVC = nil;
    UIStoryboard *sbDashboard = [UIStoryboard storyboardWithName:@"XZCareOneDownDashboard" bundle:nil];
    
    if ([cell.reuseIdentifier isEqualToString:kXZCareDashboardInsightsTableViewCellIdentifier])
    {
        XZCareOneDownGlucoseInsightsViewController *glucoseInsightVC = (XZCareOneDownGlucoseInsightsViewController *)[sbDashboard instantiateViewControllerWithIdentifier:@"XZCareGlucoseInsights"];
        
        glucoseInsightVC.stepInsight = self.stepInsight;
        glucoseInsightVC.carbsInsight = self.carbsInsight;
        glucoseInsightVC.caloriesInsight = self.caloriesInsight;
        glucoseInsightVC.sugarInsight = self.sugarInsight;
        
        insightVC = glucoseInsightVC;
    }
    else if ([cell.reuseIdentifier isEqualToString:kXZCareDashboardFoodInsightHeaderCellIdentifier])
    {
        XZCareOneDownFoodInsightsViewController *foodInsightVC = (XZCareOneDownFoodInsightsViewController *)[sbDashboard instantiateViewControllerWithIdentifier:@"APHFoodInsights"];
        
        foodInsightVC.carbFoodInsights = self.carbFoodInsight.foodHistory;
        foodInsightVC.sugarFoodInsights = self.sugarFoodInsight.foodHistory;
        
        insightVC = foodInsightVC;
    }
    
    [self.navigationController presentViewController:insightVC animated:YES completion:nil];
    
}

- (void)dashboardInsightDidAskForMoreInfoForCell:(XZCareDashboardInsightsTableViewCell *)cell
{
    [self dashboardTableViewCellDidTapMoreInfo:(XZCareDashboardTableViewCell *)cell];
}

- (void)didCompleteFoodInsightForSampleType:(HKSampleType *) __unused sampleType insight:(NSArray *) __unused foodInsight
{
    if (self.carbFoodInsight.foodHistory && self.sugarFoodInsight.foodHistory)
    {
        [self prepareData];
    }
}

#pragma mark - Unwind segue
- (IBAction)unwindFromGlucoseInsights:(UIStoryboardSegue *) __unused segue
{
    
}

#pragma mark - Pie Graph View delegates

-(NSInteger)numberOfSegmentsInPieGraphView
{
    return [self.allocationDataset count];
}

- (UIColor *)pieGraphView:(XZCarePieGraphView *) __unused pieGraphView colorForSegmentAtIndex:(NSInteger)index
{
    return [[self.allocationDataset valueForKey:kDatasetSegmentColorKey] objectAtIndex:index];
}

- (NSString *)pieGraphView:(XZCarePieGraphView *) __unused pieGraphView titleForSegmentAtIndex:(NSInteger)index
{
    return [[self.allocationDataset valueForKey:kDatasetSegmentKey] objectAtIndex:index];
}

- (CGFloat)pieGraphView:(XZCarePieGraphView *) __unused pieGraphView valueForSegmentAtIndex:(NSInteger)index
{
    return [[[self.allocationDataset valueForKey:kSegmentSumKey] objectAtIndex:index] floatValue];
}

@end
