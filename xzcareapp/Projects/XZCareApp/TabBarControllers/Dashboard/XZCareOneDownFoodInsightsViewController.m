// 
//  APHFoodInsightsViewController.m 
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
 
#import "XZCareOneDownFoodInsightsViewController.h"

static NSString *kFoodInsightHeaderCellIdentifier = @"APHFoodInsightHeaderCell";
static NSString *kFoodInsightCellIdentifier = @"APHFoodInsightCell";

typedef NS_ENUM(NSUInteger, XZCareFoodInsightSections)
{
    XZCareFoodInsightSectionCarbs = 0,
    XZCareFoodInsightSectionSugars,
    XZCareFoodInsightTotalNumberOfSections
};

@interface XZCareOneDownFoodInsightsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@end

@implementation XZCareOneDownFoodInsightsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setMaximumFractionDigits:0];
    [self.numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    // This will trigger self-sizing rows in the tableview
    self.tableView.estimatedRowHeight = 65.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView
#pragma mark Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *) __unused tableView
{
    return XZCareFoodInsightTotalNumberOfSections;
}

- (NSInteger)tableView:(UITableView *) __unused tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    if (section == XZCareFoodInsightSectionCarbs)
    {
        rows += [self.carbFoodInsights count];
    }
    else
    {
        rows += [self.sugarFoodInsights count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *) __unused tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0)
    {
        cell = [self configureInsightSummaryCellAtIndexPath:indexPath];
    }
    else
    {
        cell = [self configureFoodInsightCellAtIndexPath:indexPath];
    }
    
    return cell;
}

- (XZCareDashboardFoodInsightTableViewCell *)configureFoodInsightCellAtIndexPath:(NSIndexPath *)indexPath
{
    XZCareDashboardFoodInsightTableViewCell *insightCell = [self.tableView dequeueReusableCellWithIdentifier:kFoodInsightCellIdentifier];
    NSDictionary *insight = nil;
    NSInteger insightIndex = indexPath.row - 1;
    
    if (indexPath.section == XZCareFoodInsightSectionCarbs)
    {
        insight = [self.carbFoodInsights objectAtIndex:insightIndex];
        NSNumber *carbCalPercentage = insight[kFoodInsightCaloriesValueKey];
        
        insightCell.foodSubtitle = [NSString stringWithFormat:@"%@ calories from carbs",
                                    [self.numberFormatter stringFromNumber:carbCalPercentage]];
        insightCell.insightImage = [UIImage imageNamed:@"food_insights_carbs"];
    }
    else
    {
        insight = [self.sugarFoodInsights objectAtIndex:insightIndex];
        NSNumber *sugarCalPercentage = insight[kFoodInsightCaloriesValueKey];
        
        insightCell.foodSubtitle = [NSString stringWithFormat:@"%@ calories from sugars",
                                    [self.numberFormatter stringFromNumber:sugarCalPercentage]];
        insightCell.insightImage = [UIImage imageNamed:@"food_insights_sugars"];
    }
    
    insightCell.foodName = insight[kFoodInsightFoodNameKey];
    insightCell.foodFrequency = insight[kFoodInsightFrequencyKey];
    insightCell.tintColor = [UIColor whiteColor];
    
    return insightCell;
}

- (XZCareDashboardInsightSummaryTableViewCell *)configureInsightSummaryCellAtIndexPath:(NSIndexPath *)indexPath
{
    XZCareDashboardInsightSummaryTableViewCell *summaryCell = [self.tableView dequeueReusableCellWithIdentifier:kFoodInsightHeaderCellIdentifier
                                                                                                forIndexPath:indexPath];
    if (indexPath.section == XZCareFoodInsightSectionCarbs)
    {
        summaryCell.summaryCaption = NSLocalizedString(@"Foods high in Carbohydrates", @"Foods high in Carbohydrates");
        summaryCell.showTopSeparator = NO;
    }
    else
    {
        summaryCell.summaryCaption = NSLocalizedString(@"Foods high in Sugars", @"Foods high in Sugars");
        summaryCell.showTopSeparator = YES;
    }
    
    summaryCell.sidebarColor = [UIColor appTertiaryYellowColor];
    
    return summaryCell;
}

@end
