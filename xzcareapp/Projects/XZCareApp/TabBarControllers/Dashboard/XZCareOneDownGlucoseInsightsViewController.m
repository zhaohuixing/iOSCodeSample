// 
//  APHGlucoseInsightsViewController.m 
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
 
#import "XZCareOneDownGlucoseInsightsViewController.h"
#import "XZCareOneDownDelegate.h"

static NSString *kInsightCellIdentifier = @"XZCareDashboardInsightTableViewCell";
static NSString *kInsightSummaryHeaderCellIdentifier = @"XZCareDashboardInsightSummaryHeaderTableViewCell";
static NSString *kInsightSummaryCellIdentifier = @"XZCareDashboardInsightSummaryTableViewCell";
static NSString *kInsightNoDataIsAvailable = @"Not enough data";

static NSUInteger caloriesPerGramOfCarbsAndSugar = 4;

static NSNumberFormatter *numberFormatter = nil;

typedef NS_ENUM(NSUInteger, XZCareInsightRows)
{
    XZCareInsightRowCalories = 0,
    XZCareInsightRowSteps,
    XZCareInsightRowSugarCalories,
    XZCareInsightRowCarbs,
    XZCareInsightRowCarbsCalories,
    XZCareInsightTotalNumberOfRows
};

typedef NS_ENUM(NSUInteger, XZCareInsightSummaryRows)
{
    XZCareInsightSummaryRowHeader = 0,
    XZCareInsightSummaryRowCalories,
    XZCareInsightSummaryRowSteps,
    XZCareInsightSummaryRowSugar,
    XZCareInsightSummaryRowCarbohydrates,
    XZCareInsightSummaryTotalNumberOfRows
};

typedef NS_ENUM(NSUInteger, XZCareInsightSections)
{
    XZCareInsightSectionInsights = 0,
    XZCareInsightSectionSummary,
    XZCareInsightTotalNumberOfSections
};

@interface XZCareOneDownGlucoseInsightsViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) XZCareOneDownDelegate *appDelegate;

@property (nonatomic, strong) NSArray *sortedDatastoreKeys;
@property (nonatomic, strong) NSMutableArray *summaries;
@property (nonatomic, strong) NSMutableDictionary *insightDatastore;

@end

@implementation XZCareOneDownGlucoseInsightsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (XZCareOneDownDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!numberFormatter)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setMaximumFractionDigits:0];
        [numberFormatter setRoundingMode:NSNumberFormatterRoundDown];
    }
    
    [self configureInsightsDatastore];
    
    // This will trigger self-sizing rows in the tableview
    self.tableView.estimatedRowHeight = 90.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)configureInsightsDatastore
{
    self.insightDatastore = [NSMutableDictionary new];
    self.summaries = [NSMutableArray new];
    
    [self.summaries addObject:@(XZCareInsightSummaryRowHeader)];
    
    self.insightDatastore[[NSString stringWithFormat:@"%lu", (unsigned long)XZCareInsightRowCalories]] = self.caloriesInsight;
    
    if (self.caloriesInsight.valueGood.doubleValue != 0)
    {
        [self.summaries addObject:@(XZCareInsightSummaryRowCalories)];
    }
    
    self.insightDatastore[[NSString stringWithFormat:@"%lu", (unsigned long)XZCareInsightRowSteps]] = self.stepInsight;
    
    if (self.stepInsight.valueGood.doubleValue != 0)
    {
        [self.summaries addObject:@(XZCareInsightSummaryRowSteps)];
    }
    
    if ((self.sugarInsight.valueGood.doubleValue < self.sugarInsight.valueBad.doubleValue) &&
        (self.sugarInsight.valueGood.doubleValue != 0) &&
        (self.caloriesInsight.valueGood.doubleValue != 0))
    {
        self.insightDatastore[[NSString stringWithFormat:@"%lu", (unsigned long)XZCareInsightRowSugarCalories]] = [self calculateSugarCalories];
        [self.summaries addObject:@(XZCareInsightSummaryRowSugar)];
    }
    
    if ((self.carbsInsight.valueGood.doubleValue < self.carbsInsight.valueBad.doubleValue) &&
        (self.carbsInsight.valueGood.doubleValue != 0) &&
        (self.caloriesInsight.valueGood.doubleValue != 0))
    {
        self.insightDatastore[[NSString stringWithFormat:@"%lu", (unsigned long)XZCareInsightRowCarbs]] = self.carbsInsight;
        self.insightDatastore[[NSString stringWithFormat:@"%lu", (unsigned long)XZCareInsightRowCarbsCalories]] = [self calculateCarbCalories];
        [self.summaries addObject:@(XZCareInsightSummaryRowCarbohydrates)];
    }
    
    self.sortedDatastoreKeys = [self.insightDatastore.allKeys sortedArrayUsingSelector:@selector(compare:)];
}


#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *) __unused tableView
{
    return XZCareInsightTotalNumberOfSections;
}


- (NSInteger)tableView:(UITableView *) __unused tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (section == XZCareInsightSectionInsights)
    {
        rows = self.insightDatastore.count;
    }
    else
    {
        rows = self.summaries.count;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *) __unused tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == XZCareInsightSectionInsights)
    {
        cell = [self configureInsightCellAtIndexPath:indexPath];
    }
    else
    {
        cell = [self configureInsightSummaryCellAtIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark Cell Configuation

- (XZCareDashboardInsightTableViewCell *)configureInsightCellAtIndexPath:(NSIndexPath *)indexPath
{
    XZCareDashboardInsightTableViewCell *insightCell = [self.tableView dequeueReusableCellWithIdentifier:kInsightCellIdentifier
                                                                                         forIndexPath:indexPath];
    
    insightCell.tintColor = [UIColor whiteColor];
    
    NSUInteger insightEnumRawValue = [[self.sortedDatastoreKeys objectAtIndex:indexPath.row] integerValue];
    
    switch (insightEnumRawValue)
    {
        case XZCareInsightRowCalories:
        {
            if ([self.caloriesInsight.valueGood doubleValue] != 0)
            {
                insightCell.goodInsightCaption = self.caloriesInsight.captionGood;
                insightCell.goodInsightBar = self.caloriesInsight.valueGood;
            }
            else
            {
                insightCell.goodInsightCaption = NSLocalizedString(kInsightNoDataIsAvailable, @"Not enough data");
                insightCell.goodInsightBar = @(0);
            }
            
            if ([self.caloriesInsight.valueBad doubleValue] != 0)
            {
                insightCell.badInsightBar = self.caloriesInsight.valueBad;
                insightCell.badInsightCaption = self.caloriesInsight.captionBad;
            }
            else
            {
                insightCell.badInsightCaption = NSLocalizedString(kInsightNoDataIsAvailable, @"Not enough data");
                insightCell.badInsightBar = @(0);
            }
            
            insightCell.insightImage = [UIImage imageNamed:@"glucose_insights_calories"];
            
        }
            break;
        case XZCareInsightRowCarbsCalories:
        {
            NSDictionary *calsFromCarbs = [self calculateCarbCalories];

            insightCell.goodInsightCaption = calsFromCarbs[@"goodInsightCaption"];
            insightCell.goodInsightBar = calsFromCarbs[@"goodInsightBar"];
            insightCell.badInsightCaption = calsFromCarbs[@"badInsightCaption"];
            insightCell.badInsightBar = calsFromCarbs[@"badInsightBar"];
            
            insightCell.insightImage = [UIImage imageNamed:@"food_insights_carbs_sugars"];
        }
            break;
        case XZCareInsightRowCarbs:
        {
            insightCell.goodInsightCaption = self.carbsInsight.captionGood;
            insightCell.badInsightCaption = self.carbsInsight.captionBad;
            insightCell.goodInsightBar = self.carbsInsight.valueGood;
            insightCell.badInsightBar = self.carbsInsight.valueBad;
            insightCell.insightImage = [UIImage imageNamed:@"food_insights_carbs"];
        }
            break;
        case XZCareInsightRowSteps:
        {
            insightCell.goodInsightCaption = self.stepInsight.captionGood;
            insightCell.badInsightCaption = self.stepInsight.captionBad;
            insightCell.goodInsightBar = self.stepInsight.valueGood;
            insightCell.badInsightBar = self.stepInsight.valueBad;
            insightCell.insightImage = [UIImage imageNamed:@"glucose_insights_steps"];
        }
            break;
        case XZCareInsightRowSugarCalories:
        {
            NSDictionary *calsFromSugar = [self calculateSugarCalories];
            
            insightCell.goodInsightCaption = calsFromSugar[@"goodInsightCaption"];
            insightCell.goodInsightBar = calsFromSugar[@"goodInsightBar"];
            insightCell.badInsightCaption = calsFromSugar[@"badInsightCaption"];
            insightCell.badInsightBar = calsFromSugar[@"badInsightBar"];
            
            insightCell.insightImage = [UIImage imageNamed:@"food_insights_sugars"];
        }
            break;
            
        default:
        {
            insightCell.goodInsightCaption = @"--";
            insightCell.badInsightCaption = @"--";
            insightCell.goodInsightBar = @(0);
            insightCell.badInsightBar = @(0);
        }
            break;
    }
    
    return insightCell;
}

- (XZCareDashboardInsightSummaryTableViewCell *)configureInsightSummaryCellAtIndexPath:(NSIndexPath *)indexPath
{
    XZCareDashboardInsightSummaryTableViewCell *summaryCell = nil;
    
    NSUInteger summaryEnumRawValue = [[self.summaries objectAtIndex:indexPath.row] integerValue];
    
    if (summaryEnumRawValue == XZCareInsightSummaryRowHeader)
    {
        summaryCell = [self.tableView dequeueReusableCellWithIdentifier:kInsightSummaryHeaderCellIdentifier
                                                           forIndexPath:indexPath];
        summaryCell.sidebarColor = [UIColor appTertiaryRedColor];
        summaryCell.summaryCaption = NSLocalizedString(@"Glucose Insights Summary", @"Glucose Insights Summary");
        summaryCell.showTopSeparator = YES;
    }
    else
    {
        summaryCell = [self.tableView dequeueReusableCellWithIdentifier:kInsightSummaryCellIdentifier
                                                           forIndexPath:indexPath];
        summaryCell.sidebarColor = [UIColor whiteColor];
        
        NSString *summary = nil;
        
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        switch (summaryEnumRawValue)
        {
            case XZCareInsightSummaryRowCalories:
            {
                summary = [NSString stringWithFormat:@"On average, you consumed %@ calories 24-hours prior to a good glucose reading.",
                           [numberFormatter stringFromNumber:self.caloriesInsight.valueGood]];
                summaryCell.summaryCaption = NSLocalizedString(summary, summary);
            }
                break;
            case XZCareInsightSummaryRowSugar:
            {
                summary = [NSString stringWithFormat:@"24 hours prior to a good glucose reading, you consumed %@ g of sugar on average.",
                           [numberFormatter stringFromNumber:self.sugarInsight.valueGood]];
                summaryCell.summaryCaption = NSLocalizedString(summary, summary);
            }
                break;
            case XZCareInsightSummaryRowSteps:
            {
                summary = [NSString stringWithFormat:@"On average, you took %@ steps 24-hours prior to a good glucose reading.",
                           [numberFormatter stringFromNumber:self.stepInsight.valueGood]];
                summaryCell.summaryCaption = NSLocalizedString(summary, summary);
            }
                break;
            default: // defaulting to carbs
            {
                summary = [NSString stringWithFormat:@"24 hours prior to a good glucose reading, you consumed %@ g of carbohydrates on average.",
                           [numberFormatter stringFromNumber:self.carbsInsight.valueGood]];
                summaryCell.summaryCaption = NSLocalizedString(summary, summary);
            }
                break;
        }
    }
    
    return summaryCell;
}

- (NSDictionary *)calculateCarbCalories
{
    NSMutableDictionary *carbCaloriesData = [NSMutableDictionary new];
    NSString *caloriesCaption = nil;
    double carbCalsGood = 0;
    double carbCalsBad = 0;
    
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    if ([self.carbsInsight.valueGood doubleValue] != 0)
    {
        NSNumber *gramsOfCarbsConsumed = self.carbsInsight.valueGood;
        NSNumber *totalNumberOfCaloriesConsumed = self.caloriesInsight.valueGood;
        double carbsCaloriesConsumed = [gramsOfCarbsConsumed doubleValue] * caloriesPerGramOfCarbsAndSugar;
        double percentOfCarbsCalories = carbsCaloriesConsumed / [totalNumberOfCaloriesConsumed doubleValue];
        
        carbCalsGood = (percentOfCarbsCalories < 1) ? percentOfCarbsCalories : 1;
        
        caloriesCaption = [NSString stringWithFormat:@"%@ Calories from Carbs",
                           [numberFormatter stringFromNumber:@(carbCalsGood)]];
        
        carbCaloriesData[@"goodInsightCaption"] = NSLocalizedString(caloriesCaption, caloriesCaption);
        carbCaloriesData[@"goodInsightBar"] = @(carbCalsGood);
    }
    else
    {
        carbCaloriesData[@"goodInsightCaption"] = NSLocalizedString(kInsightNoDataIsAvailable, @"Not enough data");
        carbCaloriesData[@"goodInsightBar"] = @(0);
    }
    
    if ([self.carbsInsight.valueBad doubleValue] != 0)
    {
        NSNumber *gramsOfCarbsConsumedBad = self.carbsInsight.valueBad;
        NSNumber *totalNumberOfCaloriesConsumedBad = self.caloriesInsight.valueBad;
        double carbsCaloriesConsumedBad = [gramsOfCarbsConsumedBad doubleValue] * caloriesPerGramOfCarbsAndSugar;
        double badPercentOfCarbsCalories = carbsCaloriesConsumedBad / [totalNumberOfCaloriesConsumedBad doubleValue];
        
        carbCalsBad = (badPercentOfCarbsCalories < 1) ? badPercentOfCarbsCalories : 1;
        
        caloriesCaption = [NSString stringWithFormat:@"%@ Calories from Carbs",
                           [numberFormatter stringFromNumber:@(carbCalsBad)]];
        
        carbCaloriesData[@"badInsightCaption"] = NSLocalizedString(caloriesCaption, caloriesCaption);
        carbCaloriesData[@"badInsightBar"] = @(carbCalsBad);
    }
    else
    {
        carbCaloriesData[@"badInsightCaption"] = NSLocalizedString(kInsightNoDataIsAvailable, @"Not enough data");
        carbCaloriesData[@"badInsightBar"] = @(0);
    }
    
    carbCaloriesData[@"insightImage"] = [UIImage imageNamed:@"food_insights_carbs_sugars"];
    
    return carbCaloriesData;
}

- (NSDictionary *)calculateSugarCalories
{
    NSMutableDictionary *sugarCaloriesData = [NSMutableDictionary new];
    NSString *sugarCaloriesCaption = nil;
    double sugarCalsGood = 0;
    double sugarCalsBad = 0;
    
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    if (([self.caloriesInsight.valueGood doubleValue] != 0) &&
        ([self.caloriesInsight.valueGood doubleValue] != NSNotFound) &&
        ([self.sugarInsight.valueGood doubleValue] != 0))
    {
        NSNumber *gramsOfSugarConsumed = self.sugarInsight.valueGood;
        NSNumber *totalNumberOfCaloriesConsumed = self.caloriesInsight.valueGood;
        double sugarCaloriesConsumed = [gramsOfSugarConsumed doubleValue] * caloriesPerGramOfCarbsAndSugar;
        double percentOfSugarCalories = sugarCaloriesConsumed / [totalNumberOfCaloriesConsumed doubleValue];
        
        sugarCalsGood = (percentOfSugarCalories < 1) ? percentOfSugarCalories : 1;
        
        sugarCaloriesCaption = [NSString stringWithFormat:@"%@ Calories from Sugar",
                                [numberFormatter stringFromNumber:@(sugarCalsGood)]];
        
        sugarCaloriesData[@"goodInsightCaption"] = NSLocalizedString(sugarCaloriesCaption, sugarCaloriesCaption);
        sugarCaloriesData[@"goodInsightBar"] = @(sugarCalsGood);
    }
    else
    {
        sugarCaloriesData[@"goodInsightCaption"] = NSLocalizedString(kInsightNoDataIsAvailable, @"Not enough data");
        sugarCaloriesData[@"goodInsightBar"] = @(0);
    }
    
    if ([self.caloriesInsight.valueBad doubleValue] != 0 &&
        ([self.caloriesInsight.valueBad doubleValue] != NSNotFound) &&
        ([self.sugarInsight.valueBad doubleValue] != 0))
    {
        NSNumber *gramsOfSugarConsumedBad = self.sugarInsight.valueBad;
        NSNumber *totalNumberOfCaloriesConsumedBad = self.caloriesInsight.valueBad;
        double sugarCaloriesConsumedBad = [gramsOfSugarConsumedBad doubleValue] * caloriesPerGramOfCarbsAndSugar;
        double badPercentOfSugarCalories = sugarCaloriesConsumedBad / [totalNumberOfCaloriesConsumedBad doubleValue];
        
        sugarCalsBad = (badPercentOfSugarCalories < 1) ? badPercentOfSugarCalories : 1;
        
        sugarCaloriesCaption = [NSString stringWithFormat:@"%@ Calories from Sugar",
                                [numberFormatter stringFromNumber:@(sugarCalsBad)]];
        
        sugarCaloriesData[@"badInsightCaption"] = NSLocalizedString(sugarCaloriesCaption, sugarCaloriesCaption);
        sugarCaloriesData[@"badInsightBar"] = @(sugarCalsBad);
    }
    else
    {
        sugarCaloriesData[@"badInsightCaption"] = NSLocalizedString(kInsightNoDataIsAvailable, @"Not enough data");
        sugarCaloriesData[@"badInsightBar"] = @(0);
    }
    
    sugarCaloriesData[@"insightImage"] = [UIImage imageNamed:@"food_insights_sugars"];
    
    return sugarCaloriesData;
}

@end
