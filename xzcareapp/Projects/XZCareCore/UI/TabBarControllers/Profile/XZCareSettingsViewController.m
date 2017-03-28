// 
//  APCSettingsViewController.m 
//  APCAppCore 
// 
// Copyright (c) 2015, Apple Inc. All rights reserved. 
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
 
#import <XZCareCore/XZCareCore.h>

@interface XZCareSettingsViewController ()
@property (strong, nonatomic) XZCarePermissionsManager *permissionsManager;
@end

@implementation XZCareSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavAppearance];
    
    self.editing = YES;
    
    [self prepareContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    XZCareLogViewControllerAppeared();
}

- (void)prepareContent
{
    NSMutableArray *items = [NSMutableArray new];
    XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate;
    BOOL reminderOnState = appDelegate.tasksReminder.reminderOn;
    
    {
        
        NSMutableArray *rowItems = [NSMutableArray new];
        {
            XZCareTableViewSwitchItem *field = [XZCareTableViewSwitchItem new];
            field.caption = NSLocalizedString(@"Enable Reminders", nil);
            field.identifier = kXZCareSwitchCellIdentifier;
            field.editable = NO;
            
            field.on = reminderOnState;
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareSettingsItemTypeReminderOnOff;
            [rowItems addObject:row];
        }
        

            XZCareTableViewCustomPickerItem *field = [XZCareTableViewCustomPickerItem new];
            field.caption = NSLocalizedString(@"Time", nil);
            field.pickerData = @[[XZCareTasksReminderManager reminderTimesArray]];
            field.textAlignnment = NSTextAlignmentRight;
            field.identifier = kXZCareDefaultTableViewCellIdentifier;
            field.selectedRowIndices = @[@([[XZCareTasksReminderManager reminderTimesArray] indexOfObject:appDelegate.tasksReminder.reminderTime])];

            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareSettingsItemTypeReminderTime;
            [rowItems addObject:row];
        
     
        XZCareTableViewSection *section = [XZCareTableViewSection new];
        section.sectionTitle = NSLocalizedString(@"", nil);
        section.rows = [NSArray arrayWithArray:rowItems];
        [items addObject:section];
    }

//The code below enables per task notifications section and rows.
    if (reminderOnState)
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate;
        
        for (XZCareTaskReminder *reminder in appDelegate.tasksReminder.reminders)
        {
            XZCareTableViewSwitchItem *field = [XZCareTableViewSwitchItem new];
            field.caption = NSLocalizedString(reminder.reminderBody, nil);
            field.identifier = kXZCareSwitchCellIdentifier;
            field.editable = NO;
            
            field.on = [[NSUserDefaults standardUserDefaults]objectForKey:reminder.reminderIdentifier] ? YES : NO;
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareSettingsItemTypeReminderOnOff;
            [rowItems addObject:row];            
        }
        
        XZCareTableViewSection *section = [XZCareTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        [items addObject:section];
        

    }
    
    self.items = items;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), tableView.sectionHeaderHeight)];

    switch (section)
    {
        case 0:
            headerView.textLabel.text = NSLocalizedString(@"Settings", nil) ;
            break;
        case 1:
            headerView.textLabel.text = NSLocalizedString(@"Tasks", nil);
            break;
        default:
            break;
    }
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView;
    
    XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate;
    BOOL hasresultsSummaryKey = NO;
    NSString *subtaskTitle;
    for (XZCareTaskReminder *reminder in appDelegate.tasksReminder.reminders)
    {
        BOOL on = [[NSUserDefaults standardUserDefaults]objectForKey:reminder.reminderIdentifier] ? YES : NO;
        if (on && reminder.resultsSummaryKey)
        {
            hasresultsSummaryKey = YES;
            subtaskTitle = reminder.reminderBody;
        }
    }
    
    if (section == 1 && hasresultsSummaryKey)
    {
        footerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), tableView.sectionHeaderHeight)];
        NSString *footerText = [NSString stringWithFormat:@"%@ reminder will be sent 2 hours later.", subtaskTitle];
        
        CGRect labelFrame = CGRectMake(20, 0, CGRectGetWidth(footerView.frame)-40, 50);
        footerView.textLabel.frame = labelFrame;
        
        UILabel *reminderLabel = [[UILabel alloc]initWithFrame:labelFrame];
        reminderLabel.numberOfLines = 2;
        reminderLabel.text = NSLocalizedString(footerText, nil);
        reminderLabel.textColor = [UIColor grayColor];
        reminderLabel.font = [UIFont appMediumFontWithSize:14.0];
        [footerView.contentView addSubview:reminderLabel];
    }
    
    return footerView == nil ? [UIView new] : footerView;
}

-(CGFloat)tableView:(UITableView *)__unused tableView heightForFooterInSection:(NSInteger)section
{
    return section == 1 ? 50.0 : 0.0;
}

#pragma mark - Setup

- (void)setupNavAppearance
{
    UIBarButtonItem  *backster = [XZCareCustomBackButton customBackBarButtonItemWithTarget:self action:@selector(back) tintColor:[UIColor appPrimaryColor]];
    [self.navigationItem setLeftBarButtonItem:backster];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewItemType itemType = [self itemTypeForIndexPath:indexPath];
    
    switch (itemType)
    {
        case kXZCareSettingsItemTypePasscode:
        {
            XZCareChangePasscodeViewController *changePasscodeViewController = [[UIStoryboard storyboardWithName:@"XZCareProfile" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"ChangePasscodeVC"];
            [self.navigationController presentViewController:changePasscodeViewController animated:YES completion:nil];
        }
            break;
        case kXZCareSettingsItemTypePermissions:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
            break;
        default:
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - APCPickerTableViewCellDelegate methods

- (void)pickerTableViewCell:(XZCarePickerTableViewCell *)cell pickerViewDidSelectIndices:(NSArray *)selectedIndices
{
    [super pickerTableViewCell:cell pickerViewDidSelectIndices:selectedIndices];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate;
        NSInteger index = ((NSNumber *)selectedIndices[0]).integerValue;
        appDelegate.tasksReminder.reminderTime = [XZCareTasksReminderManager reminderTimesArray][index];
    }
}


- (void)setupDefaultCellAppearance:(XZCareDefaultTableViewCell *)cell
{
    [cell.textLabel setFont:[UIFont appRegularFontWithSize:17.0f]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    [cell.detailTextLabel setFont:[UIFont appRegularFontWithSize:17.0f]];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];

}

- (void)setupSwitchCellAppearance:(XZCareSwitchTableViewCell *)cell
{
    [cell.textLabel setFont:[UIFont appRegularFontWithSize:17.0f]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
}

/*********************************************************************************/
#pragma mark - Switch Cell Delegate
/*********************************************************************************/

- (void)switchTableViewCell:(XZCareSwitchTableViewCell *)cell switchValueChanged:(BOOL)on
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BOOL allReminders = indexPath.section == 0 && indexPath.row == 0;
    if (allReminders)
    {
        __block XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate;
        __weak XZCareSettingsViewController *weakSelf = self;
        //if on == TRUE && notification permission denied, request notification permission
        if (on && [[UIApplication sharedApplication] currentUserNotificationSettings].types == 0)
        {
            self.permissionsManager = [[XZCarePermissionsManager alloc]init];
            [self.permissionsManager requestForPermissionForType:kXZCareSignUpPermissionsTypeLocalNotifications withCompletion:^(BOOL granted, NSError *error) {
                if (!granted)
                {
                    [weakSelf presentSettingsAlert:error];
                }
                else
                {
                    [appDelegate.tasksReminder setReminderOn:NO];
                    [weakSelf prepareContent];
                    [weakSelf.tableView reloadData];
                }
            }];
            
        }
        else
        {
            appDelegate.tasksReminder.reminderOn = on;
        }
        
        //turn off each reminder if all reminders off
        NSArray *reminders = appDelegate.tasksReminder.reminders;
        if (on == NO)
        {
            for (XZCareTaskReminder *reminder in reminders)
            {
                if ([[NSUserDefaults standardUserDefaults]objectForKey:reminder.reminderIdentifier])
                {
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:reminder.reminderIdentifier];
                }
            }
        }
        else
        {
            for (XZCareTaskReminder *reminder in reminders)
            {
                [[NSUserDefaults standardUserDefaults]setObject:reminder.reminderBody forKey:reminder.reminderIdentifier];
            }
        }
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if (self.pickerShowing)
        {
            [self hidePickerCell];
        }
    }
    else
    {
        //manage individual task reminders
        
        //add or remove the reminder.taskID to/from NSUserDefaults and set to on/off
        XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate;
        XZCareTaskReminder *reminder = [appDelegate.tasksReminder.reminders objectAtIndex:indexPath.row];
        
        if (on)
        {
            //turn the reminder on by adding to NSUserDefaults
            [[NSUserDefaults standardUserDefaults]setObject:reminder.reminderBody forKey:reminder.reminderIdentifier];
        }
        else
        {
            //turn the reminder off by removing from NSUserDefaults
            if ([[NSUserDefaults standardUserDefaults]objectForKey:reminder.reminderIdentifier])
            {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:reminder.reminderIdentifier];
            }
            
            //if all reminders are turned off, switch Enable Reminders switch to off
            BOOL remindersOn = NO;
            for (XZCareTaskReminder *reminder in appDelegate.tasksReminder.reminders)
            {
                if ([[NSUserDefaults standardUserDefaults]objectForKey:reminder.reminderIdentifier])
                {
                    remindersOn = YES;
                }
            }
            
            if (!remindersOn)
            {
                appDelegate.tasksReminder.reminderOn = NO;
                [self prepareContent];
                [self.tableView reloadData];
            }
            
            
        }
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    [self prepareContent];
    [self.tableView reloadData];
    //reschedule based on the new on/off state
    [[NSNotificationCenter defaultCenter]postNotificationName:XZCareUpdateTasksReminderNotification object:nil];
}

- (void)presentSettingsAlert:(NSError *)error
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Permissions Denied", @"") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *__unused action) {
    }];
    [alertController addAction:dismiss];
    UIAlertAction *settings = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * __unused action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:settings];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Getter

- (XZBaseParameters *)parameters
{
    _parameters = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.parameters;
    return _parameters;
}

#pragma mark - Selectors / IBActions

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
