// 
//  TCMCareProfileExtender.m 
//  TCMCareDemo
//
//  Created by Zhaohui Xing on 2015-05-11.
//  Copyright (c) 2015 E-XZCare. All rights reserved.
#import <XZCareCore/XZCareCore.h>
#import "XZCareOneDownProfileExtender.h"
#import "XZCareGlucoseLevelsMealTimesViewController.h"
#import <XZCareCore/XZCareMedicationTrackerSetupViewController.h>

static  NSInteger  kDefaultNumberOfExtraSections = 3;

@implementation XZCareOneDownProfileExtender

- (instancetype) init
{
    self = [super init];

    if (self)
    {
        /*
        _testProperty = @"This is test property";
        NSLog(@"testProperty:%@", self.testProperty);
        */ 
    }
    
    return self;
}

- (BOOL)willDisplayCell:(NSIndexPath *) __unused indexPath
{
    return YES;
}

//This is all the content (rows, sections) that is prepared at the appCore level
/*
- (NSArray *)preparedContent:(NSArray *)array {
    return array;
}
*/

/**
  * @returns kDefaultNumberOfExtraSections extra sections for a nicer layout in profile
  *
  * @note    To turn off the feature in the profile View Controller, return  0.
  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *) __unused tableView
{
    return  kDefaultNumberOfExtraSections;
}

//
//    Add to the number of rows
//
- (NSInteger) tableView:(UITableView *) __unused tableView numberOfRowsInAdjustedSection:(NSInteger)section
{
    NSInteger count = 0;
    
    if (section == 0)
    {
        count = 1;
    }
    else if (section == 1)
    {
        count = 1;
    }
    
    
    return count;
}

/**
  * @returns  A default style Table View Cell unless you have special requirements
  */
- (UITableViewCell *)cellForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GlucoseLogSetup"];
        cell.textLabel.text = NSLocalizedString(@"Glucose Log", @"Glucose Log");
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 1)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OneDownLogSetup"];
        cell.textLabel.text = NSLocalizedString(@"OneDown Log", @"OneDown Log");
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = tableView.rowHeight;
    
    if (indexPath.section == 0)
    {
        height = 65.0;
    }
    else if (indexPath.section == 1)
    {
        height = 65.0;
    }
    
    return height;
}

/**
  * @brief
  *
  * @note   Provide a sub-class of UIViewController to do the work.
  *         You can either push the controller or present it, depending on your preferences.
  */
- (void)navigationController:(UINavigationController *)navigationController didSelectRowAtIndexPath:(NSIndexPath *) __unused indexPath
{
/*
    if (indexPath.section == 0)
    {
        UIStoryboard *sbGlucoseLog = [UIStoryboard storyboardWithName:@"XZCareOneDownOnboarding" bundle:[NSBundle mainBundle]];
        XZCareGlucoseLevelsMealTimesViewController *controller = [sbGlucoseLog instantiateViewControllerWithIdentifier:@"XZCareGlucoseLevelsMealTimesViewController"];
    
        controller.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Glucose Log", @"");
        controller.hidesBottomBarWhenPushed = YES;
        controller.isConfigureMode = YES;
    
        [navigationController pushViewController:controller animated:YES];
    }
    else if(indexPath.section == 1)
    {
        XZCareMedicationTrackerSetupViewController  *controller = [[XZCareMedicationTrackerSetupViewController alloc] initWithNibName:nil bundle:[NSBundle XZCareCoreBundle]];
        
        controller.navigationController.navigationBar.topItem.title = NSLocalizedString(@"OneDown Log", @"OneDown Log");
        controller.hidesBottomBarWhenPushed = YES;
        
        [navigationController pushViewController:controller animated:YES];


        UIStoryboard *sbGlucoseLog = [UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle mainBundle]];
        XZCareOneDownTimesViewController *controller = [sbGlucoseLog instantiateViewControllerWithIdentifier:@"TCMCareOneDownLogTimes"];
        
        controller.navigationController.navigationBar.topItem.title = NSLocalizedString(@"OneDown Log", @"");
        controller.hidesBottomBarWhenPushed = YES;
        controller.isConfigureMode = YES;
        
        [navigationController pushViewController:controller animated:YES];

    }
*/
    return;
}

@end
