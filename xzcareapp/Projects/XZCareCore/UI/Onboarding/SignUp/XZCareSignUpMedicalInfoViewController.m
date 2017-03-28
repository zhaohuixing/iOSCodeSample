// 
//  APCSignUpMedicalInfoViewController.m 
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

@interface XZCareSignUpMedicalInfoViewController ()

@property (nonatomic, strong) XZCarePermissionsManager *permissionManager;
@property (nonatomic) BOOL permissionGranted;

@end

@implementation XZCareSignUpMedicalInfoViewController

#pragma mark - View Life Cycle

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    //NSAssert(cell != nil, @"XZCareSignUpMedicalInfoViewController cell is nil");
    if(cell == nil)
    {
        NSLog(@"XZCareSignUpMedicalInfoViewController cell is nil");
    }
    
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = nil;
    
    self.items = [self prepareContent];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.permissionManager = [[XZCarePermissionsManager alloc] init];
    
    self.permissionGranted = [self.permissionManager isPermissionsGrantedForType:kXZCareSignUpPermissionsTypeHealthKit];
    
    __weak typeof(self) weakSelf = self;
    if (!self.permissionGranted)
    {
        [self.permissionManager requestForPermissionForType:kXZCareSignUpPermissionsTypeHealthKit withCompletion:^(BOOL granted, NSError * __unused error) {
            if (granted)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.permissionGranted = YES;
                    weakSelf.items = [self prepareContent];
                    [weakSelf.tableView reloadData];
                });
            }
        }];
    }
    
    self.title = NSLocalizedString(@"Additional Information", @"Additional Information");
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.stepProgressBar setCompletedSteps:([self onboarding].onboardingTask.currentStepNumber - 1) animation:YES];
    XZCareLogViewControllerAppeared();
}

- (NSArray *)prepareContent
{
    NSDictionary *initialOptions = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).initializationOptions;
    NSArray *profileElementsList = initialOptions[kAppProfileElementsListKey];
    
    NSMutableArray *items = [NSMutableArray new];
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        for (NSNumber *type in profileElementsList)
        {
            XZCareUserInfoItemType itemType = type.integerValue;
            
            switch (itemType)
            {
                case kXZCareUserInfoItemTypeBloodType:
                {
                    XZCareTableViewCustomPickerItem *field = [XZCareTableViewCustomPickerItem new];
                    field.caption = NSLocalizedString(@"Blood Type", @"");
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.selectionStyle = UITableViewCellSelectionStyleGray;
                    field.detailDiscloserStyle = YES;
                    
                    if (self.user.bloodType)
                    {
                        field.selectedRowIndices = @[ @(self.user.bloodType) ];
                        field.editable = NO;
                    }
                    
                    field.textAlignnment = NSTextAlignmentRight;
                    field.pickerData = @[ [XZCarePatient bloodTypeInStringValues] ];
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeBloodType;
                    [rowItems addObject:row];
                    
                }
                    break;
                    
                case kXZCareUserInfoItemTypeMedicalCondition:
                {
                    XZCareTableViewCustomPickerItem *field = [XZCareTableViewCustomPickerItem new];
                    field.caption = NSLocalizedString(@"Medical Conditions", @"");
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.selectionStyle = UITableViewCellSelectionStyleGray;
                    field.detailDiscloserStyle = YES;
                    field.pickerData = @[ [XZCarePatient medicalConditions] ];
                    field.textAlignnment = NSTextAlignmentRight;
                    if (self.user.medicalConditions)
                    {
                        field.selectedRowIndices = @[ @([field.pickerData[0] indexOfObject:self.user.medicalConditions]) ];
                    }
                    else
                    {
                        field.selectedRowIndices = @[ @(0) ];
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeMedicalCondition;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kXZCareUserInfoItemTypeMedication:
                {
                    XZCareTableViewCustomPickerItem *field = [XZCareTableViewCustomPickerItem new];
                    field.caption = NSLocalizedString(@"Medications", @"");
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.selectionStyle = UITableViewCellSelectionStyleGray;
                    field.detailDiscloserStyle = YES;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.pickerData = @[ [XZCarePatient medications] ];
                    
                    if (self.user.medications)
                    {
                        field.selectedRowIndices = @[ @([field.pickerData[0] indexOfObject:self.user.medications]) ];
                    }
                    else
                    {
                        field.selectedRowIndices = @[ @(0) ];
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeMedication;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kXZCareUserInfoItemTypeHeight:
                {
                    XZCareTableViewCustomPickerItem *field = [XZCareTableViewCustomPickerItem new];
                    field.caption = NSLocalizedString(@"Height", @"");
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.selectionStyle = UITableViewCellSelectionStyleGray;
                    field.detailDiscloserStyle = YES;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.pickerData = [XZCarePatient heights];

					NSInteger indexOfMyHeightInFeet = 0;
                    NSInteger indexOfMyHeightInInches = 0;

                    if (self.user.height)
                    {
                        double heightInInches = round([XZCarePatient heightInInches:self.user.height]);
                        
                        NSString *feet = [NSString stringWithFormat:@"%d'", (int)heightInInches/12];
                        NSString *inches = [NSString stringWithFormat:@"%d''", (int)heightInInches%12];

						NSArray *allPossibleHeightsInFeet = field.pickerData [0];
						NSArray *allPossibleHeightsInInches = field.pickerData [1];

                        //107 inches i.e. 8'11" is the max. height.
                        if (heightInInches <= 107)
                        {
                            indexOfMyHeightInFeet = [allPossibleHeightsInFeet indexOfObject: feet];
                            indexOfMyHeightInInches = [allPossibleHeightsInInches indexOfObject: inches];
                        }
                        else
                        {
                            indexOfMyHeightInFeet = allPossibleHeightsInFeet.count-1;
                            indexOfMyHeightInInches = allPossibleHeightsInInches.count-1;
                        }
						
                    }

                    if (indexOfMyHeightInFeet && indexOfMyHeightInInches)
                    {
                        field.selectedRowIndices = @[ @(indexOfMyHeightInFeet), @(indexOfMyHeightInInches) ];
                    }

                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeHeight;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kXZCareUserInfoItemTypeWeight:
                {
                    XZCareTableViewTextFieldItem *field = [XZCareTableViewTextFieldItem new];
                    field.caption = NSLocalizedString(@"Weight", @"");
                    field.placeholder = NSLocalizedString(@"add weight (lb)", @"");
                    field.style = UITableViewCellStyleValue1;
                    field.identifier = kXZCareTextFieldTableViewCellIdentifier;
                    field.regularExpression = kXZCareMedicalInfoItemWeightRegEx;
                    field.keyboardType = UIKeyboardTypeDecimalPad;
                    field.textAlignnment = NSTextAlignmentRight;
                    
                    if (self.user.weight)
                    {
                        field.value = [NSString stringWithFormat:@"%.0f", [XZCarePatient weightInPounds:self.user.weight]];
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeWeight;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kXZCareUserInfoItemTypeWakeUpTime:
                {
                    XZCareTableViewDatePickerItem *field = [XZCareTableViewDatePickerItem new];
                    field.caption = NSLocalizedString(@"What time do you generally wake up?", @"");
                    field.placeholder = @"07:00 AM";
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.selectionStyle = UITableViewCellSelectionStyleGray;
                    field.datePickerMode = UIDatePickerModeTime;
                    field.dateFormat = kXZCareMedicalInfoItemSleepTimeFormat;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.detailDiscloserStyle = YES;
                    
                    if (self.user.sleepTime)
                    {
                        field.date = self.user.sleepTime;
                    }
                    else
                    {
                        field.date = [[NSCalendar currentCalendar] dateBySettingHour:7
                                                                              minute:0
                                                                              second:0
                                                                              ofDate:[NSDate date]
                                                                             options:0];
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeWakeUpTime;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kXZCareUserInfoItemTypeSleepTime:
                {
                    XZCareTableViewDatePickerItem *field = [XZCareTableViewDatePickerItem new];
                    field.caption = NSLocalizedString(@"What time do you generally go to sleep?", @"");
                    field.placeholder = @"09:30 PM";
                    field.style = UITableViewCellStyleValue1;
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.selectionStyle = UITableViewCellSelectionStyleGray;
                    field.datePickerMode = UIDatePickerModeTime;
                    field.dateFormat = kXZCareMedicalInfoItemSleepTimeFormat;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.detailDiscloserStyle = YES;
                    
                    if (self.user.wakeUpTime)
                    {
                        field.date = self.user.wakeUpTime;
                    }
                    else
                    {
                        field.date = [[NSCalendar currentCalendar] dateBySettingHour:21
                                                                              minute:30
                                                                              second:0
                                                                              ofDate:[NSDate date]
                                                                             options:0];
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeSleepTime;
                    [rowItems addObject:row];;
                }
                    break;
                case kXZCareUserInfoItemTypeGlucoseLevel:
                {
                    XZCareTableViewTextFieldItem *field = [XZCareTableViewTextFieldItem new];
                    field.caption = NSLocalizedString(@"Glucose Level", @"");
                    if([((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate) IsMmolUnitForGlucose] == YES)
                    {
                        field.placeholder = NSLocalizedString(@"add glucose level(5.00-27.78) (mmol/L)", @"");
                    }
                    else
                    {
                        field.placeholder = NSLocalizedString(@"add glucose level(90-500) (mg/dL)", @"");
                    }
                    field.style = UITableViewCellStyleValue1;
                    field.identifier = kXZCareTextFieldTableViewCellIdentifier;
                    field.regularExpression = kXZCareMedicalInfoItemNumericRegEx;
                    field.keyboardType = UIKeyboardTypeDecimalPad;
                    field.textAlignnment = NSTextAlignmentRight;
                    
                    if (self.user.glucoseLevel)
                    {
                        field.value = [NSString stringWithFormat:@"%.0f", [XZCarePatient weightInPounds:self.user.glucoseLevel]];
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeGlucoseLevel;
                    [rowItems addObject:row];
                }
                    break;
                case kXZCareUserInfoItemTypeBloodPressureSystolic:
                {
                    XZCareTableViewTextFieldItem *field = [XZCareTableViewTextFieldItem new];
                    field.caption = NSLocalizedString(@"Systolic Value", @"");
                    field.placeholder = NSLocalizedString(@"systolic blood pressure(70-190) (mmHg)", @"");
                    field.style = UITableViewCellStyleValue1;
                    field.identifier = kXZCareTextFieldTableViewCellIdentifier;
                    field.regularExpression = kXZCareMedicalInfoItemNumericRegEx;
                    field.keyboardType = UIKeyboardTypeDecimalPad;
                    field.textAlignnment = NSTextAlignmentRight;
                    
                    if (self.user.systolicBloodPressure)
                    {
                        field.value = [NSString stringWithFormat:@"%.0f", [XZCarePatient weightInPounds:self.user.systolicBloodPressure]];
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeBloodPressureSystolic;
                    [rowItems addObject:row];
                }
                    break;
                case kXZCareUserInfoItemTypeBloodPressureDiastolic:
                {
                    XZCareTableViewTextFieldItem *field = [XZCareTableViewTextFieldItem new];
                    field.caption = NSLocalizedString(@"Diastolic Value", @"");
                    field.placeholder = NSLocalizedString(@"diastolic blood pressure(40-100) (mmHg)", @"");
                    field.style = UITableViewCellStyleValue1;
                    field.identifier = kXZCareTextFieldTableViewCellIdentifier;
                    field.regularExpression = kXZCareMedicalInfoItemNumericRegEx;
                    field.keyboardType = UIKeyboardTypeDecimalPad;
                    field.textAlignnment = NSTextAlignmentRight;
                    
                    if (self.user.diastolicBloodPressure)
                    {
                        field.value = [NSString stringWithFormat:@"%.0f", [XZCarePatient weightInPounds:self.user.diastolicBloodPressure]];
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeBloodPressureDiastolic;
                    [rowItems addObject:row];
                }
                    break;
                default:
                    break;
            }
        }
        
        XZCareTableViewSection *section = [XZCareTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        [items addObject:section];
        
    }
    
    return [NSArray arrayWithArray:items];
}

- (XZCareOnboarding *)onboarding
{
    return ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).onboarding;
}

#pragma mark - UIMethods

- (void) setupProgressBar
{
    [self.stepProgressBar setCompletedSteps:([self onboarding].onboardingTask.currentStepNumber - 2) animation:NO];
}


#pragma mark - Private Methods

- (BOOL) loadProfileValuesInModel
{
    BOOL bCanGoNext = YES;
    for (NSUInteger j=0; j<self.items.count; j++)
    {
        XZCareTableViewSection *section = self.items[j];
        
        for (NSUInteger i = 0; i < section.rows.count; i++)
        {
            XZCareTableViewRow *row = section.rows[i];
            XZCareTableViewItem *item = row.item;
            XZCareTableViewItemType itemType = row.itemType;
            
            switch (itemType)
            {
                case kXZCareUserInfoItemTypeMedicalCondition:
                    self.user.medicalConditions = [(XZCareTableViewCustomPickerItem *)item stringValue];
                    break;
                    
                case kXZCareUserInfoItemTypeMedication:
                    self.user.medications = [(XZCareTableViewCustomPickerItem *)item stringValue];
                    break;
                    
                case kXZCareUserInfoItemTypeHeight:
                {
                    double height = [XZCarePatient heightInInchesForSelectedIndices:[(XZCareTableViewCustomPickerItem *)item selectedRowIndices]];
                    
                    if (height > 0)
                    {
                        HKUnit *inchUnit = [HKUnit inchUnit];
                        HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:inchUnit doubleValue:height];
                        
                        self.user.height = heightQuantity;
                    }
                }
                    
                    break;
                    
                case kXZCareUserInfoItemTypeWeight:
                {
                    double weight = [[(XZCareTableViewTextFieldItem *)item value] floatValue];
                    
                    if (weight > 0)
                    {
                        HKUnit *poundUnit = [HKUnit poundUnit];
                        HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:poundUnit doubleValue:weight];
                        
                        self.user.weight = weightQuantity;
                    }
                }
                    break;
                case kXZCareUserInfoItemTypeGlucoseLevel:
                {
                    double glucoseLevel = [[(XZCareTableViewTextFieldItem *)item value] floatValue];
                    
                    if(0 < glucoseLevel)
                    {
                        if(glucoseLevel < kXZCareGlucoseLevelMinValue || kXZCareGlucoseLevelMaxValue < glucoseLevel)
                        {
                            NSString* szWarning = [NSString stringWithFormat:@"Please input valid value between %i and %i", kXZCareGlucoseLevelMinValue, kXZCareGlucoseLevelMaxValue];
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:ORKLocalizedString(@"RANGE_ALERT_TITLE", nil)
                                                                                           message:szWarning
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                            
                            [alert addAction:[UIAlertAction actionWithTitle:ORKLocalizedString(@"BUTTON_CANCEL", nil)
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:nil]];
                            
                            [self presentViewController:alert animated:YES completion:nil];
                            return NO;
                        }
                        HKUnit *mgPerdL;
                        if([((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate) IsMmolUnitForGlucose] == YES)
                        {
                            mgPerdL = [HKUnit unitFromString:@"mmol/L"];
                        }
                        else
                        {
                            mgPerdL = [HKUnit unitFromString:@"mg/dL"];
                        }
                        HKQuantity *glucoseQuantity = [HKQuantity quantityWithUnit:mgPerdL doubleValue:glucoseLevel];
                        self.user.glucoseLevel = glucoseQuantity;
                    }
                }
                    break;
                case kXZCareUserInfoItemTypeBloodPressureSystolic:
                {
                    double systolicValue = [[(XZCareTableViewTextFieldItem *)item value] doubleValue];

                    if(0 < systolicValue)
                    {
                        if(systolicValue < kXZCareSystolicValueMinValue || kXZCareSystolicValueMaxValue < systolicValue)
                        {
                            NSString* szWarning = [NSString stringWithFormat:@"Please input valid systolic blood pressure value between %i and %i", kXZCareSystolicValueMinValue, kXZCareSystolicValueMaxValue];
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:ORKLocalizedString(@"RANGE_ALERT_TITLE", nil)
                                                                                           message:szWarning
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                            
                            [alert addAction:[UIAlertAction actionWithTitle:ORKLocalizedString(@"BUTTON_CANCEL", nil)
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:nil]];
                            
                            [self presentViewController:alert animated:YES completion:nil];
                            return NO;
                        }
                        
                        HKUnit *mmHgUnit = [HKUnit millimeterOfMercuryUnit];
                        HKQuantity *systolicQuantity = [HKQuantity quantityWithUnit:mmHgUnit doubleValue:systolicValue];
                        self.user.systolicBloodPressure = systolicQuantity;
                    }
                }
                    break;
                case kXZCareUserInfoItemTypeBloodPressureDiastolic:
                {
                    double diastolicValue = [[(XZCareTableViewTextFieldItem *)item value] doubleValue];
                    
                    if(0 < diastolicValue)
                    {
                        if(diastolicValue < kXZCareDiastolicValueMinValue || kXZCareDiastolicValueMaxValue < diastolicValue)
                        {
                            NSString* szWarning = [NSString stringWithFormat:@"Please input valid diastolic blood pressure value between %i and %i", kXZCareDiastolicValueMinValue, kXZCareDiastolicValueMaxValue];
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:ORKLocalizedString(@"RANGE_ALERT_TITLE", nil)
                                                                                           message:szWarning
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                            
                            [alert addAction:[UIAlertAction actionWithTitle:ORKLocalizedString(@"BUTTON_CANCEL", nil)
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:nil]];
                            
                            [self presentViewController:alert animated:YES completion:nil];
                            return NO;
                        }
                        
                        HKUnit *mmHgUnit = [HKUnit millimeterOfMercuryUnit];
                        HKQuantity *diastolicQuantity = [HKQuantity quantityWithUnit:mmHgUnit doubleValue:diastolicValue];
                        self.user.diastolicBloodPressure = diastolicQuantity;
                    }
                }
                    break;
                case kXZCareUserInfoItemTypeSleepTime:
                    self.user.sleepTime = [(XZCareTableViewDatePickerItem *)item date];
                    break;
                    
                case kXZCareUserInfoItemTypeWakeUpTime:
                    self.user.wakeUpTime = [(XZCareTableViewDatePickerItem *)item date];
                    break;
                    
                default:
                    //#warning ASSERT_MESSAGE Require
                    NSAssert(itemType <= kXZCareUserInfoItemTypeWakeUpTime, @"ASSER_MESSAGE");
                    break;
            }
        }
    }
    
    return bCanGoNext;
}

- (IBAction) next
{
    BOOL bCanGoNext = [self loadProfileValuesInModel];
    
    if(bCanGoNext == NO)
        return;
    
    UIViewController *viewController = [[self onboarding] nextScene];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
