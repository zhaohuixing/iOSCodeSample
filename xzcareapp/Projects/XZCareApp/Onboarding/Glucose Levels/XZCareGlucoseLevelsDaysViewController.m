//
//  TCMCareGlucoseLevelsDaysViewController.m
//  TACMCareDiabeteCare
//
//
//  Created by Zhaohui Xing on 2015-05-25.
//  Copyright (c) 2015 E-XZCare. All rights reserved.

#import "XZCareGlucoseLevelsDaysViewController.h"
#import "XZCareGlucoseLevelsMealTimesViewController.h"
#import "XZCareGlucoseLevelsViewController.h"

static NSString *kGlucoseLevelCellIdentifier = @"GlucoseLevelDayCell";
NSString * const kGlucoseMealTimePickedDays  = @"glucoseMealTimePickedDays";

static NSDateFormatter *dateFormatter = nil;

@interface XZCareGlucoseLevelsDaysViewController ()

@property (strong, nonatomic) NSString *sceneDataIdentifier;

@property (nonatomic, strong) NSString *pickedDays;

@property (nonatomic, strong) NSArray *daysOfWeek;

@property (nonatomic, strong) NSMutableArray *selectedDays;
@property (nonatomic, strong) NSMutableArray *selectedIndices;

@end

@implementation XZCareGlucoseLevelsDaysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavAppearance];
    
    self.sceneDataIdentifier = [NSString stringWithFormat:@"%@", kGlucoseLevelCellIdentifier];
    
    self.selectedDays = [NSMutableArray array];
    self.selectedIndices = [NSMutableArray array];
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    self.daysOfWeek = [dateFormatter weekdaySymbols];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // check if there is data for the scene
    NSString *sceneData = [self.onboarding.sceneData valueForKey:self.sceneDataIdentifier];
    
    if (sceneData)
    {
        self.pickedDays = sceneData;
        
        if (self.pickedDays)
        {
            if ([self.pickedDays isEqualToString:@"Everyday"])
            {
                [[dateFormatter weekdaySymbols] enumerateObjectsUsingBlock:^(id __unused obj, NSUInteger idx, BOOL * __unused stop) {
                    [self.selectedIndices addObject:@(idx)];
                }];
            }
            else if ([self.pickedDays isEqualToString:@"Weekdays"])
            {
                self.selectedDays = [[dateFormatter weekdaySymbols] mutableCopy];
                [self.selectedDays removeObjectAtIndex:0];
                [self.selectedDays removeLastObject];
                
                [self.selectedDays enumerateObjectsUsingBlock:^(id __unused obj, NSUInteger idx, BOOL * __unused stop)
                {
                    [self.selectedIndices addObject:@(idx)];
                }];
            }
            else if ([self.pickedDays isEqualToString:@"Never"])
            {
                // do nothing.
            }
            else
            {
                self.selectedDays = [[self.pickedDays componentsSeparatedByString:@" "] mutableCopy];
                
                if ([self.selectedDays count] == 1)
                {
                    NSNumber *dayIndex = @([self.daysOfWeek indexOfObject:self.pickedDays]);
                    [self.selectedIndices addObject:dayIndex];
                }
                else
                {
                    [self.selectedDays enumerateObjectsUsingBlock:^(NSString *day, NSUInteger __unused idx, BOOL * __unused stop) {
                        NSArray *dayReference = [dateFormatter shortWeekdaySymbols];
                        NSNumber *dayIndex = @([dayReference indexOfObject:day]);
                        [self.selectedIndices addObject:dayIndex];
                    }];
                }
            }
        }
    }
    else
    {
        // Select all day by default
        [[dateFormatter weekdaySymbols] enumerateObjectsUsingBlock:^(id __unused obj, NSUInteger idx, BOOL * __unused stop) {
            [self.selectedIndices addObject:@(idx)];
        }];
    }
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL) __unused animated
{
    [self.onboarding.sceneData setValue:self.pickedDays
                                 forKey:self.sceneDataIdentifier];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id) __unused sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"SegueToMealTimes"]) {
        
        // save the pickedDays to User Defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.pickedDays forKey:kGlucoseMealTimePickedDays];
        [defaults synchronize];
        
        [[segue destinationViewController] setPickedDays:self.pickedDays];
    }
}

- (void)goBackwards
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView
#pragma mark Datastore

- (NSInteger)numberOfSectionsInTableView:(UITableView *) __unused tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *) __unused tableView numberOfRowsInSection:(NSInteger) __unused section
{
    return [self.daysOfWeek count];
}

- (CGFloat)tableView:(UITableView *) __unused tableView heightForRowAtIndexPath:(NSIndexPath *) __unused indexPath
{
    return kGlucoseLevelCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGlucoseLevelCellIdentifier
                                                            forIndexPath:indexPath];
    
    NSString *day = [self.daysOfWeek objectAtIndex:indexPath.row];
    
    cell.textLabel.text = day;
    
    NSNumber *dayIndex = @(indexPath.row);
    
    if ([self.selectedIndices containsObject:dayIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor appPrimaryColor];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSNumber *dayIndex = @(indexPath.row);
    
    if ([self.selectedIndices containsObject:dayIndex]) {
        [self.selectedIndices removeObject:dayIndex];
    } else {
        [self.selectedIndices addObject:dayIndex];
    }
    
    [self prepareDetailLabel];
    
    [tableView reloadData];
}

- (void)prepareDetailLabel
{
    NSArray *dayReference = nil;
    
    if ([self.selectedIndices count] == 1) {
        dayReference = [dateFormatter weekdaySymbols];
    } else {
        dayReference = [dateFormatter shortWeekdaySymbols];
    }
    
    NSMutableArray *days = [NSMutableArray array];
    
    // sort the indices to keep the days in proper order
    NSArray *sortedIndices = [self.selectedIndices sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSNumber *dayIndex in sortedIndices) {
        [days addObject:[dayReference objectAtIndex:[dayIndex integerValue]]];
    }
    
    if ([days count] == 0) {
        self.pickedDays = nil;
    } else if ([days count] == 7) {
        self.pickedDays = NSLocalizedString(@"Everyday", @"Everyday");
    } else {
        self.pickedDays = [days componentsJoinedByString:@" "];
    }
    
}

@end
