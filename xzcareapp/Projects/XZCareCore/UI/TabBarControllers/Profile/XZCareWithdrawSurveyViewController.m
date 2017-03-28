// 
//  APCWithdrawSurveyViewController.m 
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

@interface XZCareWithdrawSurveyViewController ()<XZCareWithdrawDescriptionViewControllerDelegate>

@property (nonatomic, strong) NSString *descriptionText;

@end

@implementation XZCareWithdrawSurveyViewController

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self setupAppearance];
    
    self.items = [self prepareContent];
    self.descriptionText = @"";
    
    self.submitButton.enabled = NO;
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    XZCareLogViewControllerAppeared();
}

- (NSArray *)prepareContent
{
     return [self surveyFromJSONFile:@"WithdrawStudy"];
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupAppearance
{
    [self.headerLabel setTextColor:[UIColor appSecondaryColor2]];
    [self.headerLabel setFont:[UIFont appLightFontWithSize:14.0f]];
    [self.selectAllLabel setTextColor:[UIColor appSecondaryColor2]];
    [self.selectAllLabel setFont:[UIFont appLightFontWithSize:14.0f]];
}

- (XZCarePatient *) user
{
    return ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.currentUser;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger) numberOfSectionsInTableView: (UITableView *) __unused tableView
{
    return self.items.count;
}

- (NSInteger) tableView: (UITableView *) __unused tableView
  numberOfRowsInSection: (NSInteger) section
{
    XZCareTableViewSection *sectionItem = self.items[section];
    return sectionItem.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewSwitchItem *optionItem = [self itemForIndexPath:indexPath];
    
    XZCareCheckTableViewCell *cell = (XZCareCheckTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kXZCareCheckTableViewCellIdentifier];
    
    cell.textLabel.text = optionItem.caption;
    cell.confirmationView.completed = optionItem.on;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewSection *sectionItem = self.items[indexPath.section];
    if ((NSUInteger)indexPath.row == (sectionItem.rows.count - 1))
    {
        XZCareWithdrawDescriptionViewController *viewController = [[UIStoryboard storyboardWithName:@"XZCareProfile" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareWithdrawDescriptionViewController"];
        viewController.delegate = self;
        viewController.descriptionText = self.descriptionText;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self.navigationController presentViewController:navController animated:YES completion:nil];
        
    }
    else
    {
        XZCareTableViewSwitchItem *optionItem = [self itemForIndexPath:indexPath];
        optionItem.on = !optionItem.on;
        [tableView reloadData];
    }
    
    self.submitButton.enabled = [self isContentValid];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - APCWithdrawDescriptionViewControllerDelegate methods

- (void)withdrawViewControllerDidCancel:(XZCareWithdrawDescriptionViewController *) __unused viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) withdrawViewController: (XZCareWithdrawDescriptionViewController *) __unused viewController
       didFinishWithDescription: (NSString *) text
{
    self.descriptionText = text;
    
    [self dismissViewControllerAnimated:YES completion:^{
        XZCareTableViewSection *sectionItem = self.items[0];
        XZCareTableViewSwitchItem *optionItem = [self itemForIndexPath:[NSIndexPath indexPathForRow:(sectionItem.rows.count - 1) inSection:0]];
        optionItem.on = YES;
        [self.tableView reloadData];
        
        self.submitButton.enabled = [self isContentValid];
    }];
}

#pragma mark - Public methods

- (NSArray *)surveyFromJSONFile:(NSString *)jsonFileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    NSString *JSONString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSError *parseError;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&parseError];
    
    NSMutableArray *items = [NSMutableArray new];
    
    if (!parseError)
    {
        NSArray *options = jsonDictionary[@"options"];
        NSMutableArray *rowItems = [NSMutableArray new];
        
        for (NSDictionary *optionDict in options)
        {
            XZCareTableViewSwitchItem *option = [XZCareTableViewSwitchItem new];
            option.caption = optionDict[@"option"];
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = option;
            [rowItems addObject:row];
        }
        
        XZCareTableViewSection *section = [XZCareTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        [items addObject:section];
    }
    
    return [NSArray arrayWithArray:items];
}

- (XZCareTableViewSwitchItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewSection *sectionItem = self.items[indexPath.section];
    XZCareTableViewRow *rowItem = sectionItem.rows[indexPath.row];
    XZCareTableViewSwitchItem *studyDetailsItem = (XZCareTableViewSwitchItem *)rowItem.item;
    return studyDetailsItem;
}

- (BOOL)isContentValid
{
    BOOL valid = NO;
    
    XZCareTableViewSection *sectionItem = self.items[0];
    
    for (XZCareTableViewRow *row in sectionItem.rows)
    {
        XZCareTableViewSwitchItem *option = (XZCareTableViewSwitchItem *)[row item];
        if (option.on)
        {
            valid = YES;
            break;
        }
    }
    
    return valid;
}

#pragma mark - IBActions

- (IBAction) submit: (id) __unused sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
