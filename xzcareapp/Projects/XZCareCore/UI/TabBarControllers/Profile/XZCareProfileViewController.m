// 
//  APCProfileViewController.m 
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

#ifndef XZCARE_HAVE_CONSENT
#define XZCARE_HAVE_CONSENT
#endif

#ifndef XZCARE_HAVE_CONSENT
#import "XZCareExampleLabel.h"
#endif

#import <ResearchKit/ResearchKit.h>

//#ifndef NOT_USE_BRIDGE
//#import <BridgeSDK/BridgeSDK.h>
//#endif

static CGFloat const kSectionHeaderHeight = 40.f;
static CGFloat const kStudyDetailsViewHeightConstant = 48.f;
static CGFloat const kPickerCellHeight = 164.0f;

@interface XZCareProfileViewController () <ORKTaskViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studyDetailsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studyLabelCenterYConstraint;
@property (strong, nonatomic) XZCarePermissionsManager *permissionManager;
@property (weak, nonatomic) IBOutlet UILabel *applicationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *participationLabel;
@property (strong, nonatomic) XZCareDemographicUploader  *demographicUploader;
@property (nonatomic, assign) BOOL                    profileEditsWerePerformed;

@end

@implementation XZCareProfileViewController

- (void)dealloc
{
    _nameTextField.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version: %@ (Build %@)", version, build];
    
    XZCareCoreAppDelegate *appDelegate = (XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate;
    XZCarePatient  *user = appDelegate.dataSubstrate.currentUser;
    self.demographicUploader = [[XZCareDemographicUploader alloc] initWithUser:user];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect headerRect = self.headerView.frame;
    headerRect.size.height = 159.0f;
    self.headerView.frame = headerRect;
    
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
    XZCareLogViewControllerAppeared();
    
    
    [self setupAppearance];
    
    self.nameTextField.delegate = self;
    
    [self.profileImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.items = [self prepareContent];
    [self.tableView reloadData];
    
    self.applicationNameLabel.text = [XZBaseUtilities appName];
    
    self.nameTextField.text = [NSString stringWithFormat:@"%@ %@", self.user.consentSignatureFirstName, self.user.consentSignatureLastName];//self.user.name;
#ifndef __NEED_ONLINE_REGISTER__
    self.nameTextField.enabled = NO;
#endif
    self.emailTextField.text = self.user.email;
    self.emailTextField.enabled = NO;
    
    self.profileImage = [UIImage imageWithData:self.user.profileImage];
    if (self.profileImage)
    {
        [self.profileImageButton setImage:self.profileImage forState:UIControlStateNormal];
    }
    else
    {
        [self.profileImageButton setImage:[UIImage imageNamed:@"profilePlaceholder"] forState:UIControlStateNormal];
    }
    
    self.permissionManager = [[XZCarePermissionsManager alloc] init];
    [self setupDataFromJSONFile:@"StudyOverview"];
    if (XZCareUserConsentSharingScopeNone == self.user.sharingScope)
    {
        self.participationLabel.text = NSLocalizedString(@"Your data is no longer being used for this study.", @"");
        self.leaveStudyButton.hidden = YES;
    }

    /*Currently we always diable leave study !!!!*/
#ifdef DSIABLE_LEAVESTUDY_UI
    self.leaveStudyButton.hidden = YES;
    self.participationLabel.text = @"";
#endif
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.profileEditsWerePerformed != NO)
    {
        self.profileEditsWerePerformed = NO;
        [self.demographicUploader uploadNonIdentifiableDemographicData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = self.items.count;
    
#ifndef DSIABLE_PROFILEEXTENSION_UI
    NSInteger profileExtenderSections = 0;
    
    if ([self.delegate respondsToSelector:@selector(numberOfSectionsInTableView:)] && count != 0)
    {
        profileExtenderSections = [self.delegate numberOfSectionsInTableView:tableView];
    }
    
    if (profileExtenderSections > 0)
    {
        count += profileExtenderSections;
    }
#endif
    
    return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    if ( (NSUInteger)section >= self.items.count )
    {
        if ([self.delegate respondsToSelector:@selector(tableView:numberOfRowsInAdjustedSection:)])
        {
            NSInteger adjustedSectionForExtender = section - self.items.count;
            count = [self.delegate tableView:tableView numberOfRowsInAdjustedSection:adjustedSectionForExtender];
        }
    }
    else
    {
        XZCareTableViewSection *itemsSection = self.items[section];
        count = itemsSection.rows.count;
        if (self.isPickerShowing && self.pickerIndexPath.section == section)
        {
            count ++;
        }
    }
    
    return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ((NSUInteger)indexPath.section >= self.items.count)
    {
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kXZCareDefaultTableViewCellIdentifier forIndexPath:indexPath];
        }
        
        if ([self.delegate respondsToSelector:@selector(decorateCell:atIndexPath:)])
        {
            //the delegate should set fields on the cell as required for any preparedContent
            cell = [self.delegate decorateCell:cell atIndexPath:indexPath];
        }

    }
    else
    {
        if (self.pickerIndexPath && [self.pickerIndexPath isEqual:indexPath])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kXZCarePickerTableViewCellIdentifier];
            
            NSIndexPath *actualIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
            XZCareTableViewItem *field = [self itemForIndexPath:actualIndexPath];
            
            XZCarePickerTableViewCell *pickerCell = (XZCarePickerTableViewCell *)cell;
            
            if ([field isKindOfClass:[XZCareTableViewDatePickerItem class]])
            {
                XZCareTableViewDatePickerItem *datePickerField = (XZCareTableViewDatePickerItem *)field;
                
                pickerCell.type = kXZCarePickerCellTypeDate;
                if (datePickerField.date)
                {
                    pickerCell.datePicker.date = datePickerField.date;
                }
                
                pickerCell.datePicker.datePickerMode = datePickerField.datePickerMode;
                if (datePickerField.minimumDate)
                {
                    pickerCell.datePicker.minimumDate = datePickerField.minimumDate;
                }
                if (datePickerField.maximumDate)
                {
                    pickerCell.datePicker.maximumDate = datePickerField.maximumDate;
                }
                pickerCell.delegate = self;
                
                [self setupPickerCellAppeareance:pickerCell];
            }
            else if ([field isKindOfClass:[XZCareTableViewCustomPickerItem class]])
            {
                XZCareTableViewCustomPickerItem *customPickerField = (XZCareTableViewCustomPickerItem *)field;
                pickerCell.type = kXZCarePickerCellTypeCustom;
                pickerCell.pickerValues = customPickerField.pickerData;
                [pickerCell.pickerView reloadAllComponents];
                pickerCell.delegate = self;
                pickerCell.selectedRowIndices = customPickerField.selectedRowIndices;
                
                [self setupPickerCellAppeareance:pickerCell];
            }
        }
        else
        {
            XZCareTableViewItem *field = [self itemForIndexPath:indexPath];
            if ([field.caption isEqualToString:@"What time do you generally go to sleep?"])
            {
                
            }
            
            if (field)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:field.identifier];
                
                cell.selectionStyle = field.selectionStyle;
                cell.textLabel.text = field.caption;
                
                cell.detailTextLabel.textColor = [UIColor blackColor];
                
                if (field.showChevron)
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
                
                if (!field.editable && self.isEditing)
                {
                    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                }
                
                cell.detailTextLabel.text = field.detailText;
                
                if ([field isKindOfClass:[XZCareTableViewTextFieldItem class]])
                {
                    XZCareTableViewTextFieldItem *textFieldItem = (XZCareTableViewTextFieldItem *)field;
                    XZCareTextFieldTableViewCell *textFieldCell = (XZCareTextFieldTableViewCell *)cell;
                    
                    textFieldCell.textField.placeholder = textFieldItem.placeholder;
                    textFieldCell.textField.text = textFieldItem.value;
                    textFieldCell.textField.secureTextEntry = textFieldItem.isSecure;
                    textFieldCell.textField.keyboardType = textFieldItem.keyboardType;
                    textFieldCell.textField.returnKeyType = textFieldItem.returnKeyType;
                    textFieldCell.textField.clearButtonMode = textFieldItem.clearButtonMode;
                    textFieldCell.textField.text = textFieldItem.value;
                    textFieldCell.textField.enabled = self.isEditing;
                    
                    if (field.textAlignnment == NSTextAlignmentRight)
                    {
                        textFieldCell.type = kXZCareTextFieldCellTypeRight;
                    }
                    else
                    {
                        textFieldCell.type = kXZCareTextFieldCellTypeLeft;
                    }
                    
                    //??textFieldCell.type = kXZCareTextFieldCellTypeRight;
                    textFieldCell.delegate = self;
                    
                    [self setupTextFieldCellAppearance:textFieldCell];
                    
                    if (!field.editable && self.isEditing)
                    {
                        textFieldCell.textField.textColor = [UIColor lightGrayColor];
                        textFieldCell.textField.userInteractionEnabled = NO;
                    
                    }
                    else
                    {
                        textFieldCell.textField.textColor = [UIColor blackColor];
                    }
                    
                    cell = textFieldCell;
                }
                else if ([field isKindOfClass:[XZCareTableViewDatePickerItem class]])
                {
                    XZCareTableViewDatePickerItem *datePickerField = (XZCareTableViewDatePickerItem *)field;
                    XZCareDefaultTableViewCell *defaultCell = (XZCareDefaultTableViewCell *)cell;
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;

                    if (datePickerField.date)
                    {
                        NSString *dateWithFormat = [datePickerField.date toStringWithFormat:datePickerField.dateFormat];
                        defaultCell.detailTextLabel.text = dateWithFormat;
                        defaultCell.detailTextLabel.textColor = [UIColor appSecondaryColor1];
                    }
                    else
                    {
                        defaultCell.detailTextLabel.text = field.placeholder;
                        defaultCell.detailTextLabel.textColor = [UIColor appSecondaryColor3];
                    }
                    
                    [self setupDefaultCellAppearance:defaultCell];
                    
                }
                else if ([field isKindOfClass:[XZCareTableViewCustomPickerItem class]])
                {
                    XZCareTableViewCustomPickerItem *customPickerField = (XZCareTableViewCustomPickerItem *)field;
                    XZCareDefaultTableViewCell *defaultCell = (XZCareDefaultTableViewCell *)cell;
                    
                    defaultCell.detailTextLabel.text = customPickerField.stringValue;

                    [self setupDefaultCellAppearance:defaultCell];
                }
                else if ([field isKindOfClass:[XZCareTableViewSegmentItem class]])
                {
                    XZCareTableViewSegmentItem *segmentPickerField = (XZCareTableViewSegmentItem *)field;
                    XZCareSegmentedTableViewCell *segmentedCell = (XZCareSegmentedTableViewCell *)cell;
                    segmentedCell.delegate = self;
                    segmentedCell.selectedSegmentIndex = segmentPickerField.selectedIndex;
                    segmentedCell.userInteractionEnabled = segmentPickerField.editable;
                }
                else if ([field isKindOfClass:[XZCareTableViewSwitchItem class]])
                {
                    XZCareTableViewSwitchItem *switchField = (XZCareTableViewSwitchItem *)field;
                    XZCareSwitchTableViewCell *switchCell = (XZCareSwitchTableViewCell *)cell;
                    switchCell.textLabel.text = switchField.caption;
                    switchCell.cellSwitch.on = switchField.on;
                    switchCell.delegate = self;
                    
                    [self setupSwitchCellAppearance:switchCell];
                }
                else
                {
                    if (!cell)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:field.style reuseIdentifier:field.identifier];
                        
                        cell.textLabel.frame = CGRectMake(12.0, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height);
                    }
                    [self setupBasicCellAppearance:cell];
                }
            }
        }
    }
    return cell;
}

#pragma mark - Prepare Content

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
#ifndef __USING_NOSHARING_OPTION__
                case kXZCareUserInfoItemTypeBiologicalSex:
                {
                    XZCareTableViewItem *field = [XZCareTableViewItem new];
                    field.caption = NSLocalizedString(@"Biological Sex", @"");
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.editable = NO;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.detailText = [XZCarePatient stringValueFromSexType:self.user.biologicalSex];
                    field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeBiologicalSex;
                    [rowItems addObject:row];
                }
                    break;
#endif
                case kXZCareUserInfoItemTypeDateOfBirth:
                {
                    XZCareTableViewItem *field = [XZCareTableViewItem new];
                    field.caption = NSLocalizedString(@"Birthdate", @"");
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.editable = NO;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.detailText = [self.user.birthDate toStringWithFormat:NSDateDefaultDateFormat];
                    field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeDateOfBirth;
                    [rowItems addObject:row];
                }
                    break;
                
                case kXZCareUserInfoItemTypeCustomSurvey:
                {
                    XZCareTableViewTextFieldItem *field = [XZCareTableViewTextFieldItem new];
                    field.textAlignnment = NSTextAlignmentLeft;
                    field.placeholder = NSLocalizedString(@"custom question", @"");
                    field.caption = @"Daily Scale";
                    if (self.user.customSurveyQuestion)
                    {
                        field.value = self.user.customSurveyQuestion;
                    }
                    field.keyboardType = UIKeyboardTypeAlphabet;
                    field.identifier = kXZCareTextFieldTableViewCellIdentifier;
                    field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
                    
                    field.style = UITableViewStylePlain;
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeCustomSurvey;
                    [rowItems addObject:row];
                }
                    break;
                
                case kXZCareUserInfoItemTypeMedicalCondition:
                {
                    XZCareTableViewCustomPickerItem *field = [XZCareTableViewCustomPickerItem new];
                    field.caption = NSLocalizedString(@"Medical Conditions", @"");
                    field.pickerData = @[[XZCarePatient medicalConditions]];
                    field.textAlignnment = NSTextAlignmentRight;
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
                    field.editable = NO;
                    
                    if (self.user.medications)
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
                    field.pickerData = @[[XZCarePatient medications]];
                    field.textAlignnment = NSTextAlignmentRight;
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
                    field.editable = NO;
                    
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
                    field.detailDiscloserStyle = YES;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.pickerData = [XZCarePatient heights];
                    field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
                    field.editable = NO;
                    
                    NSInteger defaultIndexOfMyHeightInFeet = 5;
                    NSInteger defaultIndexOfMyHeightInInches = 0;
                    
                    double usersHeight = [XZCarePatient heightInInches:self.user.height];
                    
                    if (usersHeight)
                    {
                        double heightInInches = round(usersHeight);
                        NSString *feet = [NSString stringWithFormat:@"%i'", (int)heightInInches/12];
                        NSString *inches = [NSString stringWithFormat:@"%i''", (int)heightInInches%12];
                        
                        NSArray *allPossibleHeightsInFeet = field.pickerData [0];
                        NSArray *allPossibleHeightsInInches = field.pickerData [1];
                        
                        NSInteger indexOfMyHeightInFeet = [allPossibleHeightsInFeet indexOfObject: feet];
                        NSInteger indexOfMyHeightInInches = [allPossibleHeightsInInches indexOfObject: inches];
                        
                        if (indexOfMyHeightInFeet == NSNotFound)
                        {
                            indexOfMyHeightInFeet = defaultIndexOfMyHeightInFeet;
                        }
                        
                        if (indexOfMyHeightInInches == NSNotFound)
                        {
                            indexOfMyHeightInInches = defaultIndexOfMyHeightInInches;
                        }
                        
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
                    field.regularExpression = kXZCareMedicalInfoItemWeightRegEx;
                    
                    double userWeight = [XZCarePatient weightInPounds:self.user.weight];
                    
                    if (userWeight)
                    {
                        field.value = [NSString stringWithFormat:@"%.0f", userWeight];
                    }
                    
                    field.keyboardType = UIKeyboardTypeDecimalPad;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.identifier = kXZCareTextFieldTableViewCellIdentifier;
                    field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeWeight;
                    [rowItems addObject:row];
                }
                    break;
                
                case kXZCareUserInfoItemTypeWakeUpTime:
                {
                    XZCareTableViewDatePickerItem *field = [XZCareTableViewDatePickerItem new];
                    field.style = UITableViewCellStyleValue1;
                    field.caption = NSLocalizedString(@"What time do you generally wake up?", @"");
                    field.placeholder = NSLocalizedString(@"7:00 AM", @"");
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.datePickerMode = UIDatePickerModeTime;
                    field.dateFormat = kXZCareMedicalInfoItemSleepTimeFormat;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.detailDiscloserStyle = YES;
                    field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
                    field.editable = NO;
                    
                    if (self.user.wakeUpTime)
                    {
                        field.date = self.user.wakeUpTime;
                        field.detailText = [field.date toStringWithFormat:kXZCareMedicalInfoItemSleepTimeFormat];
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
                    field.style = UITableViewCellStyleValue1;
                    field.caption = NSLocalizedString(@"What time do you generally go to sleep?", @"");
                    field.placeholder = NSLocalizedString(@"9:30 PM", @"");
                    field.identifier = kXZCareDefaultTableViewCellIdentifier;
                    field.datePickerMode = UIDatePickerModeTime;
                    field.dateFormat = kXZCareMedicalInfoItemSleepTimeFormat;
                    field.textAlignnment = NSTextAlignmentRight;
                    field.detailDiscloserStyle = YES;
                    field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
                    field.editable = NO;
                    
                    if (self.user.sleepTime)
                    {
                        field.date = self.user.sleepTime;
                        field.detailText = [field.date toStringWithFormat:kXZCareMedicalInfoItemSleepTimeFormat];
                    }
                    
                    XZCareTableViewRow *row = [XZCareTableViewRow new];
                    row.item = field;
                    row.itemType = kXZCareUserInfoItemTypeSleepTime;
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
    
    /*
     Share is disabled for now.
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        {
            APCTableViewItem *field = [APCTableViewItem new];
            field.caption = NSLocalizedString(@"Share this Study", @"");
            field.identifier = kXZCareDefaultTableViewCellIdentifier;
            field.editable = YES;
            
            APCTableViewRow *row = [APCTableViewRow new];
            row.item = field;
            row.itemType = kXZCareTableViewStudyItemTypeShare;
            [rowItems addObject:row];
        }
        
        APCTableViewSection *section = [APCTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        section.sectionTitle = NSLocalizedString(@"Help us Spread the Word", @"");
        [items addObject:section];
    }
    */
    
#ifdef __SHOW_REMINDER_SETTING_VIEW__
    {
    NSMutableArray *rowItems = [NSMutableArray new];
  
    {
        XZCareTableViewItem *field = [XZCareTableViewItem new];
        field.caption = NSLocalizedString(@"Activity Reminders", @"");
        field.identifier = kXZCareDefaultTableViewCellIdentifier;
        field.editable = NO;
        field.showChevron = YES;
        field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;
        
        XZCareTableViewRow *row = [XZCareTableViewRow new];
        row.item = field;
        row.itemType = kXZCareSettingsItemTypeReminderOnOff;
        [rowItems addObject:row];
    }
    XZCareTableViewSection *section = [XZCareTableViewSection new];

    section.rows = [NSArray arrayWithArray:rowItems];
    [items addObject:section];
    }
#endif

    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        {
            XZCareTableViewCustomPickerItem *field = [XZCareTableViewCustomPickerItem new];
            field.identifier = kXZCareDefaultTableViewCellIdentifier;
            field.selectionStyle = self.isEditing ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
            field.caption = NSLocalizedString(@"Auto-Lock", @"");
            field.detailDiscloserStyle = YES;
            field.textAlignnment = NSTextAlignmentRight;
            field.pickerData = @[[XZCareProfileViewController autoLockOptionStrings]];
            field.editable = YES;
            field.selectionStyle = UITableViewCellSelectionStyleGray;
            
            NSNumber *numberOfMinutes = [[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfMinutesForPasscodeKey];
            
            if ( numberOfMinutes != nil)
            {
                NSInteger index = [[XZCareProfileViewController autoLockValues] indexOfObject:numberOfMinutes];
                field.selectedRowIndices = @[@(index)];
            }

            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareSettingsItemTypeAutoLock;
            [rowItems addObject:row];
        }
        
        {
            XZCareTableViewItem *field = [XZCareTableViewItem new];
            field.caption = NSLocalizedString(@"Change Passcode", @"");
            field.identifier = kXZCareDefaultTableViewCellIdentifier;
            field.textAlignnment = NSTextAlignmentLeft;
            field.editable = NO;
            field.selectionStyle = UITableViewCellSelectionStyleGray;
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareSettingsItemTypePasscode;
            [rowItems addObject:row];
        }
#ifndef __USING_NOSHARING_OPTION__
        if (XZCareUserConsentSharingScopeNone != self.user.sharingScope)
        {
            //  Instead of prevent the row from being added to the table, a better option would be to
            //  disable the row (grey it out and don't respond to taps)
            XZCareTableViewItem *field = [XZCareTableViewItem new];
            field.caption = NSLocalizedString(@"Sharing Options", @"");
            field.identifier = kXZCareDefaultTableViewCellIdentifier;
            field.textAlignnment = NSTextAlignmentLeft;
            field.editable = NO;
            field.selectionStyle = UITableViewCellSelectionStyleGray;
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareSettingsItemTypeSharingOptions;
            [rowItems addObject:row];
        }
#endif
        XZCareTableViewSection *section = [XZCareTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        [items addObject:section];
    }

    {
        NSMutableArray *rowItems = [NSMutableArray new];
        {
            XZCareTableViewItem *field = [XZCareTableViewItem new];
            field.caption = NSLocalizedString(@"Permissions", @"");
            field.identifier = kXZCareDefaultTableViewCellIdentifier;
            field.textAlignnment = NSTextAlignmentRight;
            field.editable = NO;
            field.selectionStyle = UITableViewCellSelectionStyleGray;
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareSettingsItemTypePermissions;
            [rowItems addObject:row];
        }
        
        {
            XZCareTableViewItem *field = [XZCareTableViewItem new];
            //??field.caption = NSLocalizedString(@"Review Consent", @"");
            field.caption = NSLocalizedString(@"Review Terms of Use", @"");
            field.identifier = kXZCareDefaultTableViewCellIdentifier;
            field.textAlignnment = NSTextAlignmentRight;
            field.editable = NO;
            field.selectionStyle = UITableViewCellSelectionStyleGray;
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareUserInfoItemTypeReviewConsent;
            [rowItems addObject:row];
        }
        
        XZCareTableViewSection *section = [XZCareTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        section.sectionTitle = @"";
        [items addObject:section];
    }
    
#ifndef __USING_NOSHARING_OPTION__
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        {
            XZCareTableViewItem *field = [XZCareTableViewItem new];
            field.caption = NSLocalizedString(@"Privacy Policy", @"");
            field.identifier = kXZCareDefaultTableViewCellIdentifier;
            field.textAlignnment = NSTextAlignmentRight;
            field.editable = NO;
            field.selectionStyle = UITableViewCellSelectionStyleGray;
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareSettingsItemTypePrivacyPolicy;
            [rowItems addObject:row];
        }
#ifdef SHOW_LICENSE_VIEW
        {
            XZCareTableViewItem *field = [XZCareTableViewItem new];
            field.caption = NSLocalizedString(@"License Information", @"");
            field.identifier = kXZCareDefaultTableViewCellIdentifier;
            field.textAlignnment = NSTextAlignmentRight;
            field.editable = NO;
            field.showChevron = YES;
            field.selectionStyle = UITableViewCellSelectionStyleGray;
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = field;
            row.itemType = kXZCareSettingsItemTypeLicenseInformation;
            [rowItems addObject:row];
        }
#endif
        XZCareTableViewSection *section = [XZCareTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        section.sectionTitle = @"";
        [items addObject:section];
    }
#endif

    NSArray *newArray = nil;
    if ([self.delegate respondsToSelector:@selector(preparedContent:)])
    {
        newArray = [self.delegate preparedContent:[NSArray arrayWithArray:items]];
    }
    
    return newArray ? newArray : [NSArray arrayWithArray:items];
}

- (void)setupSwitchCellAppearance:(XZCareSwitchTableViewCell *)cell
{
    [cell.textLabel setFont:[UIFont appRegularFontWithSize:14.0f]];
    [cell.textLabel setTextColor:[UIColor appSecondaryColor1]];
}

/*********************************************************************************/
#pragma mark - Switch Cell Delegate
/*********************************************************************************/

- (void)switchTableViewCell:(XZCareSwitchTableViewCell *)cell switchValueChanged:(BOOL)on
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        // TODO: move to NSUserDefaults category, managed by APCTasksReminderManager
        XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate;
        appDelegate.tasksReminder.reminderOn = on;
    }
}

#pragma mark - Getter Methods

- (XZCarePatient *)user
{
    if (!_user)
    {
        _user = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.currentUser;
    }
    return _user;
}

#pragma mark - Appearance

- (void)setupAppearance
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    [self.nameTextField setTextColor:[UIColor blackColor]];
    
    [self.nameTextField setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    
    [self.emailTextField setFont:[UIFont appRegularFontWithSize:16.0f]];
    
    [self.profileImageButton.imageView.layer setCornerRadius:CGRectGetHeight(self.profileImageButton.bounds)/2];
    
    [self.editLabel setTextColor:[UIColor appSecondaryColor1]];
    [self.editLabel setFont:[UIFont appRegularFontWithSize:14.0f]];
    
    [self.footerTitleLabel setTextColor:[UIColor appSecondaryColor1]];
    [self.footerTitleLabel setFont:[UIFont appLightFontWithSize:16.0f]];
    
    [self.editLabel setTextColor:[UIColor appSecondaryColor1]];
    [self.editLabel setFont:[UIFont appRegularFontWithSize:14.0f]];
    
    [self.editLabel setTextColor:[UIColor appSecondaryColor1]];
    [self.editLabel setFont:[UIFont appRegularFontWithSize:14.0f]];
    
    [self.diseaseLabel setTextColor:[UIColor appSecondaryColor1]];
    [self.diseaseLabel setFont:[UIFont appRegularFontWithSize:16.0f]];
    
    [self.signOutButton setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateNormal];
    [self.signOutButton.titleLabel setFont:[UIFont appRegularFontWithSize:16.0]];
    
    [self.leaveStudyButton setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateNormal];
    [self.leaveStudyButton.titleLabel setFont:[UIFont appRegularFontWithSize:16.0]];
}

- (void) setupPickerCellAppeareance: (XZCarePickerTableViewCell *) __unused cell
{
    
}

- (void)setupTextFieldCellAppearance:(XZCareTextFieldTableViewCell *)cell
{
    [cell.textLabel setFont:[UIFont appRegularFontWithSize:17.0f]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    [cell.textField setFont:[UIFont appRegularFontWithSize:17.0f]];
    [cell.textField setTextColor:[UIColor blackColor]];
}


- (void)setupDefaultCellAppearance:(XZCareDefaultTableViewCell *)cell
{
    [cell.textLabel setFont:[UIFont appRegularFontWithSize:17.0f]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    [cell.detailTextLabel setFont:[UIFont appRegularFontWithSize:17.0f]];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = tableView.rowHeight;
    
    if ((NSUInteger)indexPath.section >= self.items.count)
    {
        if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtAdjustedIndexPath:)])
        {
            NSInteger adjustedSectionForExtender = indexPath.section - self.items.count;
            NSIndexPath *newIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:adjustedSectionForExtender];
            height = [self.delegate tableView:tableView heightForRowAtAdjustedIndexPath:newIndex];
        }
    }
    else
    {
        if (self.isPickerShowing && [indexPath isEqual:self.pickerIndexPath])
        {
            height = kPickerCellHeight;
        }
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ((NSUInteger)indexPath.section >= self.items.count)
    {
        if ([self.delegate respondsToSelector:@selector(navigationController:didSelectRowAtIndexPath:)])
        {
            NSInteger adjustedSectionForExtender = indexPath.section - self.items.count;
            NSIndexPath *newIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:adjustedSectionForExtender];
            [self.delegate navigationController:self.navigationController didSelectRowAtIndexPath:newIndex];
        }
    }
    else
    {
        XZCareTableViewItemType type = [self itemTypeForIndexPath:indexPath];
        UIStoryboard *onboarding = [UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle XZCareCoreBundle]];
        XZCareSignUpPermissionsViewController *signUpPermissions = [onboarding instantiateViewControllerWithIdentifier:@"XZCareSignUpPermissionsViewController"];
        signUpPermissions.navigationItem.rightBarButtonItem = nil;
        
        switch (type)
        {
            case kXZCareTableViewStudyItemTypeShare:
            {
                //  Commented out since we do NOT want to share the apps while they're underdevelopment.
                //            APCShareViewController *shareViewController = [[UIStoryboard storyboardWithName:@"APCOnboarding" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"APCShareViewController"];
                //            shareViewController.hidesOkayButton = YES;
                //            [self.navigationController pushViewController:shareViewController animated:YES];
            }
                break;
            
            case kXZCareSettingsItemTypePasscode:
            {
                if (!self.isEditing)
                {
                    XZCareChangePasscodeViewController *changePasscodeViewController = [[UIStoryboard storyboardWithName:@"XZCareProfile" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"ChangePasscodeVC"];
                    [self.navigationController presentViewController:changePasscodeViewController animated:YES completion:nil];
                }
                else
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
                break;
            
            case kXZCareSettingsItemTypePermissions:
            {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                if (!self.isEditing)
                {
                    [self.navigationController pushViewController:signUpPermissions animated:YES];
                }
                
            }
                break;
            
            case kXZCareUserInfoItemTypeReviewConsent:
            {
                if (!self.isEditing)
                {
                    [self reviewConsent];
                }
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
            }
                break;
            
            case kXZCareSettingsItemTypeReminderOnOff:
            {
                if (!self.isEditing)
                {
                    XZCareSettingsViewController *remindersTableViewController = [[UIStoryboard storyboardWithName:@"XZCareProfile" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareSettingsViewController"];
                    
                    [self.navigationController pushViewController:remindersTableViewController animated:YES];
                }
                else
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
                
            }
                break;
            
            case kXZCareSettingsItemTypePrivacyPolicy:
            {
                if (!self.isEditing)
                {
                    [self showPrivacyPolicy];
                }
                else
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
                break;
            
            case kXZCareSettingsItemTypeLicenseInformation:
            {
                if (!self.isEditing)
                {
                    XZCareLicenseInfoViewController *licenseInfoViewController = [[UIStoryboard storyboardWithName:@"XZCareProfile" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareLicenseInfoViewController"];
                    [self.navigationController pushViewController:licenseInfoViewController animated:YES];
                    
                }
                else
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
                break;
#ifndef __USING_NOSHARING_OPTION__
            case kXZCareSettingsItemTypeSharingOptions:
            {
                if (!self.isEditing)
                {
                    XZCareSharingOptionsViewController *sharingOptionsViewController = [[UIStoryboard storyboardWithName:@"XZCareProfile" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareSharingOptionsViewController"];
                    
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:sharingOptionsViewController];
                    [self.navigationController presentViewController:navController animated:YES completion:nil];
                }
                else
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
                break;
#endif
            default:
            {
                [super tableView:tableView didSelectRowAtIndexPath:indexPath];
            }
                break;
        }
    }
}

- (CGFloat)tableView: (UITableView *) __unused tableView heightForHeaderInSection: (NSInteger) section
{
    CGFloat height;
    
    if (section == 0)
    {
        height = 0;
    }
    else
    {
        height = kSectionHeaderHeight;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView;
    
    if ((NSUInteger)section >= self.items.count )
    {
        if ([self.delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
        {
            headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kSectionHeaderHeight)];
            headerView.contentView.backgroundColor = [UIColor appSecondaryColor4];
        }
    }
    else
    {
        XZCareTableViewSection *sectionItem = self.items[section];
        if (sectionItem.sectionTitle.length > 0)
        {
            headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kSectionHeaderHeight)];
            headerView.contentView.backgroundColor = [UIColor appSecondaryColor4];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
            headerLabel.font = [UIFont appLightFontWithSize:16.0f];
            headerLabel.textColor = [UIColor appSecondaryColor4];
            headerLabel.textAlignment = NSTextAlignmentCenter;
            headerLabel.text = sectionItem.sectionTitle;
            [headerView addSubview:headerLabel];
        }
    }
    
    return headerView;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
#ifdef __NEED_ONLINE_REGISTER__
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.nameTextField)
    {
        self.user.name = text;
    }
#endif
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
#ifdef __NEED_ONLINE_REGISTER__
    if (textField == self.nameTextField)
    {
        self.user.name = textField.text;
    }
#endif
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.nameTextField) && self.emailTextField)
    {
        [self nextResponderForIndexPath:nil];
    }
    
    return YES;
}

#pragma mark - APCPickerTableViewCellDelegate methods

- (void)pickerTableViewCell:(XZCarePickerTableViewCell *)cell pickerViewDidSelectIndices:(NSArray *)selectedIndices
{
    [super pickerTableViewCell:cell pickerViewDidSelectIndices:selectedIndices];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //auto lock
    if (indexPath.section == 2 && indexPath.row == 1)
    {
        NSInteger index = ((NSNumber *)selectedIndices[0]).integerValue;
        [[NSUserDefaults standardUserDefaults] setObject:[XZCareProfileViewController autoLockValues][index] forKey:kNumberOfMinutesForPasscodeKey];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image)
    {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    self.profileImage = image;
    [self.profileImageButton setImage:image forState:UIControlStateNormal];
    self.user.profileImage = UIImagePNGRepresentation(image);
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ORKTaskViewControllerDelegate methods

- (void)taskViewController:(ORKTaskViewController *) __unused taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(nullable NSError *)error
{
    if (reason == ORKTaskViewControllerFinishReasonCompleted)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (reason == ORKTaskViewControllerFinishReasonDiscarded)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (reason == ORKTaskViewControllerFinishReasonSaved)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (reason == ORKTaskViewControllerFinishReasonFailed)
    {
        XZCareLogError2(error);
    }
}

#pragma mark - Public methods

- (void)loadProfileValuesInModel
{
#ifdef __NEED_ONLINE_REGISTER__
    self.user.name = self.nameTextField.text;
#endif
    
    if (self.profileImage)
    {
        self.user.profileImage = UIImageJPEGRepresentation(self.profileImage, 1.0);
    }
    
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
                case kXZCareUserInfoItemTypeCustomSurvey:
                {
                    NSLog(@"%@",[(XZCareTableViewTextFieldItem *)item value]);
                    
                    if ([(XZCareTableViewTextFieldItem *)item value] != nil && ![[(XZCareTableViewTextFieldItem *)item value] isEqualToString:@""])
                    {
                        self.user.customSurveyQuestion = [(XZCareTableViewTextFieldItem *)item value];
                    }
                }
                    break;
                
                case kXZCareUserInfoItemTypeMedicalCondition:
                    self.user.medicalConditions = [(XZCareTableViewCustomPickerItem *)item stringValue];
                    break;
                
                case kXZCareUserInfoItemTypeMedication:
                    self.user.medications = [(XZCareTableViewCustomPickerItem *)item stringValue];
                    break;
                
                case kXZCareUserInfoItemTypeHeight:
                {
                    XZCareTableViewCustomPickerItem *heightPicker = (XZCareTableViewCustomPickerItem *)item;
                    double height = [XZCarePatient heightInInchesForSelectedIndices:heightPicker.selectedRowIndices];
                    
                    HKUnit *inchUnit = [HKUnit inchUnit];
                    HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:inchUnit doubleValue:height];
                    
                    self.user.height = heightQuantity;
                }
                    break;
                
                case kXZCareUserInfoItemTypeWeight:
                {
                    double weight = [[(XZCareTableViewTextFieldItem *)item value] floatValue];
                    HKUnit *poundUnit = [HKUnit poundUnit];
                    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:poundUnit doubleValue:weight];
                    
                    self.user.weight = weightQuantity;
                }
                    break;
                
                case kXZCareUserInfoItemTypeSleepTime:
                    self.user.sleepTime = [(XZCareTableViewDatePickerItem *)item date];
                    break;
                
                case kXZCareUserInfoItemTypeWakeUpTime:
                    self.user.wakeUpTime = [(XZCareTableViewDatePickerItem *)item date];
                    break;
                
                case kXZCareSettingsItemTypeAutoLock:
                    break;
                
                case kXZCareSettingsItemTypePasscode:
                    break;
                
                case kXZCareSettingsItemTypeReminderOnOff:
                    break;
                
                case kXZCareSettingsItemTypeReminderTime:
                    break;
                
                case kXZCareSettingsItemTypePermissions:
                    break;
                
                case kXZCareUserInfoItemTypeReviewConsent:
                    break;
                
                case kXZCareSettingsItemTypePrivacyPolicy:
                    break;
#ifndef __USING_NOSHARING_OPTION__
                case kXZCareSettingsItemTypeSharingOptions:
                    break;
#endif
                default:
                    break;
            }
        }
    }
}

- (void)setupDataFromJSONFile:(NSString *)jsonFileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    NSString *JSONString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSError *parseError;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&parseError];
    
    if (!parseError)
    {
        self.diseaseLabel.text = jsonDictionary[@"disease_name"];
        
        self.studyDetailsViewHeightConstraint.constant = kStudyDetailsViewHeightConstant;
        self.studyLabelCenterYConstraint.constant = 0.f;
        [self.tableView layoutIfNeeded];
    }
}

- (void)withdraw
{
    XZCareSpinnerViewController *spinnerController = [[XZCareSpinnerViewController alloc] init];
    [self presentViewController:spinnerController animated:YES completion:nil];
    
    typeof(self) __weak weakSelf = self;
    self.user.sharingScope = XZCareUserConsentSharingScopeNone;
    [self.user withdrawStudyOnCompletion:^(NSError *error)
    {
        if (error)
        {
            XZCareLogError2 (error);
            [spinnerController dismissViewControllerAnimated:NO completion:^{
                UIAlertController *alert = [UIAlertController simpleAlertWithTitle:NSLocalizedString(@"Withdraw", @"") message:error.message];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }];
        }
        else
        {
            [spinnerController dismissViewControllerAnimated:NO completion:^{
                XZCareWithdrawCompleteViewController *viewController = [[UIStoryboard storyboardWithName:@"XZCareProfile" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareWithdrawCompleteViewController"];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
                [weakSelf.navigationController presentViewController:navController animated:YES completion:nil];
            }];
        }
    }];
}

#pragma mark - IBActions/Selectors

- (BOOL)canSignOut
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self respondsToSelector:@selector(logOut)])
    {
        return YES;
    }
#pragma clang diagnostic pop
    return NO;
}

- (IBAction)signOut:(id) __unused sender
{
    if (![self canSignOut])
    {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Sign Out", @"") message:NSLocalizedString(@"Are you sure you want to sign out?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *signOutAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sign Out", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * __unused action)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self performSelector:@selector(logOut)];
#pragma clang diagnostic pop
    }];
    [alertController addAction:signOutAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * __unused action) {
       
    }];
    [alertController addAction:cancelAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)leaveStudy:(id) __unused sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Withdraw", @"") message:NSLocalizedString(@"Are you sure you want to completely withdraw from the study?\nThis action cannot be undone.", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *withdrawAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Withdraw", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * __unused action) {
        [self withdraw];
    }];
    [alertController addAction:withdrawAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * __unused action) {
		
    }];
    [alertController addAction:cancelAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)changeProfileImage:(id) __unused sender
{
    if (self.isEditing)
    {
        __weak typeof(self) weakSelf = self;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * __unused action) {
            
            [self.permissionManager requestForPermissionForType:kXZCareSignUpPermissionsTypeCamera withCompletion:^(BOOL granted, NSError *error) {
                if (granted)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf openCamera];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf presentSettingsAlert:error];
                    });
                }
            }];
        }];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [alertController addAction:cameraAction];
        }
        
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Choose from Library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * __unused action) {
            [self.permissionManager requestForPermissionForType:kXZCareSignUpPermissionsTypePhotoLibrary withCompletion:^(BOOL granted, NSError *error) {
                if (granted)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf openPhotoLibrary];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf presentSettingsAlert:error];
                    });
                }
            }];
        }];
        [alertController addAction:libraryAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * __unused action) {
            
        }];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)openCamera
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.editing = YES;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)openPhotoLibrary
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.editing = YES;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)presentSettingsAlert:(NSError *)error
{
    UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Permissions Denied", @"") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * __unused action) {
        
    }];
    [alertContorller addAction:dismiss];
    UIAlertAction *settings = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * __unused action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertContorller addAction:settings];
    
    [self.navigationController presentViewController:alertContorller animated:YES completion:nil];
}

- (IBAction)editFields:(UIBarButtonItem *)sender
{
    if (self.isEditing)
    {
        if (self.isPickerShowing)
        {
            [self hidePickerCell];
        }
        
        sender.title = NSLocalizedString(@"Edit", @"Edit");
        sender.style = UIBarButtonItemStylePlain;
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
        [self loadProfileValuesInModel];
        [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger  __unused idx, BOOL * __unused stop) {
            XZCareTableViewSection *section = (XZCareTableViewSection *)obj;
            [section.rows enumerateObjectsUsingBlock:^(id obj, NSUInteger  __unused idx, BOOL * __unused stop) {
                XZCareTableViewRow * row = (XZCareTableViewRow *)obj;
                row.item.selectionStyle = UITableViewCellSelectionStyleNone;
            }];
        }];
    }
    else
    {
        sender.title = NSLocalizedString(@"Done", @"Done");
        sender.style = UIBarButtonItemStyleDone;
        self.profileEditsWerePerformed = YES;
        
        self.navigationItem.leftBarButtonItem.enabled = NO;
        [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger  __unused idx, BOOL * __unused stop) {
            XZCareTableViewSection *section = (XZCareTableViewSection *)obj;
            [section.rows enumerateObjectsUsingBlock:^(id obj, NSUInteger __unused idx, BOOL * __unused stop) {
                XZCareTableViewRow * row = (XZCareTableViewRow *)obj;
                row.item.selectionStyle = UITableViewCellSelectionStyleGray;
            }];
        }];
    }
    
    self.editing = !self.editing;
    
    if (self.isEditing)
    {
        if ([self.delegate respondsToSelector:@selector(hasStartedEditing)])
        {
            [self.delegate hasStartedEditing];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(hasFinishedEditing)])
        {
            [self.delegate hasFinishedEditing];
        }
    }

    
#ifdef __NEED_ONLINE_REGISTER__
    self.nameTextField.enabled = self.isEditing;
#endif
    [self.tableView reloadData];

}

#pragma mark - Privacy Policy

- (void)showPrivacyPolicy
{
    //XZCareWebViewController *webViewController = [[UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareWebViewController"];
    
    XZCareConsentWebViewController *webViewController = [XZCareConsentWebViewController CreateInstance];
    NSString *filePath = [[NSBundle mainBundle] pathForResource: @"PrivacyPolicy" ofType:@"html" inDirectory:@"HTMLContent"];
    NSURL *targetURL = [NSURL URLWithString:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    webViewController.title = NSLocalizedString(@"Privacy Policy", @"");
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:webViewController];
    [self.navigationController presentViewController:navController animated:YES completion:^{
        [webViewController.webview loadRequest:request];
    }];
}



#pragma mark - Review Consent helper methods

- (void)reviewConsent
{
    __weak typeof(self) weakSelf = self;
    
    XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate;
    NSArray *consentReviewActions = [appDelegate reviewConsentActions];
    
    if (!consentReviewActions)
    {
        consentReviewActions = @[kReviewConsentActionPDF, kReviewConsentActionVideo, kReviewConsentActionSlides];
    }
    
//??    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Review Consent" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Review Terms of Use" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([consentReviewActions containsObject:kReviewConsentActionPDF])
    {
        UIAlertAction *pdfAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"View PDF", @"View PDF") style:UIAlertActionStyleDefault handler:^(UIAlertAction * __unused action) {
            
            //XZCareWebViewController *webViewController = [[UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareWebViewController"];
            XZCareConsentWebViewController *webViewController = [XZCareConsentWebViewController CreateInstance];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"consent" ofType:@"pdf"];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            [webViewController.webview setDataDetectorTypes:UIDataDetectorTypeAll];
            //webViewController.title = NSLocalizedString(@"Consent", @"Consent");
            webViewController.title = NSLocalizedString(@"Terms of Use", @"Terms of Use");
            
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:webViewController];
            [weakSelf.navigationController presentViewController:navController animated:YES completion:^{
                [webViewController.webview loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
            }];
            
        }];
        [alertController addAction:pdfAction];
    }
    
    if ([consentReviewActions containsObject:kReviewConsentActionVideo])
    {
        UIAlertAction *videoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Watch Video", @"Watch Video") style:UIAlertActionStyleDefault handler:^(UIAlertAction * __unused action) {
            
            NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Intro" ofType:@"mp4"]];
            XZCareIntroVideoViewController *introVideoViewController = [[XZCareIntroVideoViewController alloc] initWithContentURL:fileURL];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:introVideoViewController];
            navController.navigationBarHidden = YES;
            [weakSelf presentViewController:navController animated:YES completion:nil];
        }];
        [alertController addAction:videoAction];
    }
    
    if ([consentReviewActions containsObject:kReviewConsentActionSlides])
    {
        UIAlertAction *slidesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"View Slides", @"View Slides") style:UIAlertActionStyleDefault handler:^(UIAlertAction * __unused action) {
            [weakSelf showConsentSlides];
        }];
        [alertController addAction:slidesAction];
    }
    
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * __unused action) {
            
        }];
        [alertController addAction:cancelAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showConsentSlides
{
    XZCareCoreAppDelegate * appDelegate = (XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate;
    
    NSArray*                sections  = [appDelegate consentSectionsAndHtmlContent:nil];
    ORKConsentDocument*     consent   = [[ORKConsentDocument alloc] init];
    ORKConsentSignature*    signature = [ORKConsentSignature signatureForPersonWithTitle:NSLocalizedString(@"Participant", nil)
                                                                        dateFormatString:nil
                                                                              identifier:@"participant"];
    
    consent.title                = NSLocalizedString(@"Consent", nil);
    consent.signaturePageTitle   = NSLocalizedString(@"Consent", nil);
    consent.signaturePageContent = NSLocalizedString(@"I agree to participate in this research Study.", nil);
    consent.sections             = sections;
    
    [consent addSignature:signature];
    
    ORKVisualConsentStep*   step         = [[ORKVisualConsentStep alloc] initWithIdentifier:@"visual" document:consent];
    ORKOrderedTask* task = [[ORKOrderedTask alloc] initWithIdentifier:@"consent" steps:@[step]];
    ORKTaskViewController*  consentVC = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:[NSUUID UUID]];
    
    consentVC.navigationBar.topItem.title = NSLocalizedString(@"Consent", nil);
	consentVC.delegate = self;
    
#ifndef XZCARE_HAVE_CONSENT
#warning Adding watermark label until you define "APC_HAVE_CONSENT" to indicate that you have a real consenting document
    UILabel *watermarkLabel = [XZCareExampleLabel watermarkInRect:consentVC.view.bounds
                                                    withCenter:consentVC.view.center];
    [consentVC.view insertSubview:watermarkLabel atIndex:NSUIntegerMax];
#endif
    
    [self presentViewController:consentVC animated:YES completion:nil];
}

#pragma mark Auto-Lock helper methods

+ (NSArray *)autoLockValues
{
    return @[@5, @10, @15, @30, @45];
}

+ (NSArray *)autoLockOptionStrings
{
    NSArray *values = [XZCareProfileViewController autoLockValues];
    NSMutableArray *options = [NSMutableArray new];
    
    for (NSNumber *val in values)
    {
        NSString *optionString = [NSString stringWithFormat:@"%ld %@", (long)val.integerValue, NSLocalizedString(@"minutes", nil)];
        [options addObject:optionString];
    }
    
    return [NSArray arrayWithArray:options];
}

@end