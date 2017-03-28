// 
//  APHDashboardEditViewController.m 
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

#import "XZCareOneDownDashboardEditViewController.h"
#import "XZCareAppConstants.h"

@implementation XZCareOneDownDashboardEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareData];
}

- (void)prepareData
{
    [self.items removeAllObjects];
    
    {
        for (NSNumber *typeNumber in self.rowItemsOrder)
        {
            XZCareDashboardItemType rowType = typeNumber.integerValue;
            
            switch (rowType)
            {
                case kAPHDashboardItemTypeSteps:
                {
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Steps", @"");
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    [self.items addObject:item];
                    
                }
                    break;
                    
                case kAPHDashboardItemTypeGlucose:
                {
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Glucose", @"");
                    item.taskId = kGlucoseLogSurveyIdentifier;
                    item.tintColor = [UIColor colorForTaskId:item.taskId];
                    
                    [self.items addObject:item];
                    
                }
                    break;
                case kAPHDashboardItemTypeWeight:{
                    
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.taskId = kWeightCheckSurveyIdentifier;
                    item.caption = NSLocalizedString(@"Weight", @"");
                    item.tintColor = [UIColor colorForTaskId:item.taskId];
                    
                    [self.items addObject:item];
                }
                    break;
                case kAPHDashboardItemTypeCarbohydrate:
                {
                    
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Carbohydrates", @"");
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    [self.items addObject:item];
                }
                    break;
                
                case kAPHDashboardItemTypeSugar:
                {
                    
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Sugar", @"");
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    
                    [self.items addObject:item];
                }
                    break;
                
                case kAPHDashboardItemTypeCalories:
                {
                    
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Calories", @"");
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    [self.items addObject:item];
                }
                    break;

                case kAPHDashboardItemTypeFitness:
                {
                    if ([XZBaseDeviceHardware isiPhone5SOrNewer])
                    {
                        XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                        item.caption = NSLocalizedString(@"Activity Tracker", @"");
                        item.tintColor = [UIColor appTertiaryBlueColor];
                        
                        [self.items addObject:item];
                    }
                }
                    break;
                
                case kAPHDashboardItemTypeGlucoseInsights:
                {
                    NSString *glucoseLevels = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.currentUser.glucoseLevels;
                    
                    if (glucoseLevels)
                    {
                        XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                        item.caption = NSLocalizedString(@"Glucose Insights", @"");
                        item.tintColor = [UIColor appTertiaryBlueColor];
                        
                        [self.items addObject:item];
                    }
                }
                    break;
                
                    
                case kAPHDashboardItemTypeDietInsights:
                {
                    
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Diet Insights", @"");
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    [self.items addObject:item];
                }
                    break;
          
                /*
                case kAPHDashboardItemTypeOneDown:
                {
                    
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"OneDown", @"");
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    
                    [self.items addObject:item];
                }
                break;
                */
                case kAPHDashboardItemTypeOneDownMorning:
                {
                    
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"OneDown Morning", @"");
                    item.tintColor = [UIColor colorWithRed:0.5f green:0.5f blue:1.0f alpha:1.0f];
                    [self.items addObject:item];
                }
                    break;
                    
                case kAPHDashboardItemTypeOneDownNoon:
                {
                    
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"OneDown Morning", @"");
                    item.tintColor = [UIColor colorWithRed:0.3f green:0.3f blue:1.0f alpha:1.0f];
                    [self.items addObject:item];
                }
                    break;
                    
                case kAPHDashboardItemTypeOneDownEvening:
                {
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"OneDown Morning", @"");
                    item.tintColor = [UIColor colorWithRed:0.1f green:0.1f blue:1.0f alpha:1.0f];
                    [self.items addObject:item];
                }
                    break;

                case kAPHDashboardItemTypeDailySleep:
                {
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Daily Sleep Tracking", @"");
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    [self.items addObject:item];
                }
                    break;
                
                case kAPHDashboardItemTypeDailyFeet:
                {
                    XZCareTableViewDashboardItem *item = [XZCareTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Daily Feet Checking", @"");
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    [self.items addObject:item];
                }
                    break;
                default:
                    break;
            }
        }
        
    }
}

@end
