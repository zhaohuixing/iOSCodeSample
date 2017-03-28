// 
//  APCSignUpGeneralInfoViewController.m 
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

static NSString *kInternetNotAvailableErrorMessage1 = @"Internet Not Connected";
static NSString *kInternetNotAvailableErrorMessage2 = @"BackendServer Not Reachable";
static NSString * const kInternalMaxParticipantsMessage = @"has reached the limit of allowed participants.";

static CGFloat kHeaderHeight = 157.0f;

@interface XZCareSignUpGeneralInfoViewController () <XZCareTermsAndConditionsViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XZCareFormTextFieldDelegate>

@property (nonatomic, strong) XZCarePermissionsManager *permissionManager;
@property (nonatomic) BOOL permissionGranted;
@property (weak, nonatomic) IBOutlet XZCarePermissionButton *permissionButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@property (nonatomic, strong) UIImage *profileImage;

@end

@implementation XZCareSignUpGeneralInfoViewController

#pragma mark - View Life Cycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavAppearance];
    
    self.items = [self prepareContent];
    
    self.permissionButton.unconfirmedTitle = NSLocalizedString(@"Enter the study and contribute your data", @"");
    self.permissionButton.confirmedTitle = NSLocalizedString(@"Enter the study and contribute your data", @"");
    self.permissionButton.attributed = NO;
    self.permissionButton.alignment = kXZCarePermissionButtonAlignmentLeft;
    
    self.permissionManager = [[XZCarePermissionsManager alloc] init];
    
    __weak typeof(self) weakSelf = self;
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
    
    //Set Default Values
    [self.profileImageButton setImage:[UIImage imageNamed:@"profilePlaceholder"] forState:UIControlStateNormal];
    self.nameTextField.text = [NSString stringWithFormat:@"%@ %@", self.user.consentSignatureFirstName, self.user.consentSignatureLastName]; //self.user.consentSignatureName;
    if (self.nameTextField.text.length > 0)
    {
        self.nameTextField.valid = YES;
#ifndef __NEED_ONLINE_REGISTER__
        self.nameTextField.enabled = NO;
#endif
    }
    
    self.nameTextField.validationDelegate = self;
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.emailTextField.validationDelegate = self;
    [self.emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIEdgeInsets inset = self.tableView.contentInset;
    self.tableView.contentInset = inset;
    
    if (self.headerView && (CGRectGetHeight(self.headerView.frame) != kHeaderHeight))
    {
        CGRect headerRect = self.headerView.frame;
        headerRect.size.height = kHeaderHeight;
        self.headerView.frame = headerRect;
        
        self.tableView.tableHeaderView = self.tableView.tableHeaderView;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self restoreSceneData];
    
    XZCareLogViewControllerAppeared();
}

- (void)setupAppearance
{
    [super setupAppearance];
    
    self.footerLabel.font = [UIFont appRegularFontWithSize:16.0f];
    self.footerLabel.text = NSLocalizedString(@"Sage Bionetworks, a non-profit biomedical research institute, is helping to collect data for this study and distribute it to the study investigators and other researchers. Please provide a unique email address and password to create a secure account.", @"");
    self.footerLabel.textColor = [UIColor appSecondaryColor2];
    
}

- (void)setupNavAppearance
{
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                   target:self
                                                                                   action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    self.nextBarButton.enabled = NO;
}

- (void)saveSceneData
{
    NSDictionary *generalInfoSceneData = @{
                                           @"email": self.emailTextField.text ?:[NSNull null],
                                           @"photo": self.profileImage ?:[NSNull null]
                                           };
    
    [self.onboarding.sceneData setObject:generalInfoSceneData forKey:self.onboarding.currentStep.identifier];
}

- (void)restoreSceneData
{
    // check if there is data for the scene
    NSDictionary *sceneData = [self.onboarding.sceneData valueForKey:self.onboarding.currentStep.identifier];
    
    if (sceneData)
    {
        if (sceneData[@"email"] != [NSNull null])
        {
            self.emailTextField.text = sceneData[@"email"];
        }
        
        if (sceneData[@"photo"] != [NSNull null])
        {
            self.profileImage = sceneData[@"photo"];
            self.profileImageButton.imageView.image = self.profileImage;
        }
    }
}

- (NSArray *)prepareContent
{
    NSDictionary *initialOptions = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).initializationOptions;
    NSArray *profileElementsList = initialOptions[kAppProfileElementsListKey];
    
    NSMutableArray *items = [NSMutableArray new];
    NSMutableArray *rowItems = [NSMutableArray new];

    {
        XZCareTableViewTextFieldItem *field = [XZCareTableViewTextFieldItem new];
        field.caption = NSLocalizedString(@"Password", @"");
        field.placeholder = NSLocalizedString(@"add password", @"");
        field.keyboardType = UIKeyboardTypeASCIICapable;
        field.returnKeyType = UIReturnKeyNext;
        field.identifier = kXZCareTextFieldTableViewCellIdentifier;
        field.style = UITableViewCellStyleValue1;
        
        XZCareTableViewRow *row = [XZCareTableViewRow new];
        row.item = field;
        row.itemType = kXZCareUserInfoItemTypePassword;
        [rowItems addObject:row];
    }
    
    
    for (NSNumber *type in profileElementsList)
    {
        XZCareUserInfoItemType itemType = type.integerValue;
        switch (itemType)
        {
            case kXZCareUserInfoItemTypeDateOfBirth:
            {
                XZCareTableViewDatePickerItem *field = [XZCareTableViewDatePickerItem new];
                field.caption = NSLocalizedString(@"Birthdate", @"");
                field.placeholder = NSLocalizedString(@"add birthdate", @"");
                field.datePickerMode = UIDatePickerModeDate;
                field.style = UITableViewCellStyleValue1;
                field.selectionStyle = UITableViewCellSelectionStyleGray;
                field.identifier = kXZCareDefaultTableViewCellIdentifier;
                
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
                NSDate *currentDate = [[NSDate date] startOfDay];
                NSDateComponents * comps = [[NSDateComponents alloc] init];
                [comps setYear: -18];
                NSDate *maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
                field.maximumDate = maxDate;
                
                if (self.user.birthDate)
                {
                    field.date = self.user.birthDate;
                }
                else
                {
                    [comps setYear:-30];
                    NSDate *defaultDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
                    field.date = defaultDate;
                }
                
                field.detailText = [field.date toStringWithFormat:field.dateFormat];
                XZCareTableViewRow *row = [XZCareTableViewRow new];
                row.item = field;
                row.itemType = kXZCareUserInfoItemTypeDateOfBirth;
                [rowItems addObject:row];
            }
                break;
            case kXZCareUserInfoItemTypeBiologicalSex:
            {
                XZCareTableViewSegmentItem *field = [XZCareTableViewSegmentItem new];
                field.style = UITableViewCellStyleValue1;
                field.segments = [XZCarePatient sexTypesInStringValue];
                field.identifier = kXZCareSegmentedTableViewCellIdentifier;
                
                if (self.permissionGranted && self.user.biologicalSex)
                {
                    field.selectedIndex = [XZCarePatient stringIndexFromSexType:self.user.biologicalSex];
                    field.editable = NO;
                }
                
                XZCareTableViewRow *row = [XZCareTableViewRow new];
                row.item = field;
                row.itemType = kXZCareUserInfoItemTypeBiologicalSex;
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
    
    return [NSArray arrayWithArray:items];
}

- (XZCareOnboarding *)onboarding
{
    return ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).onboarding;
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *) __unused textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertLabel.alpha = 0;
    }];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [super textFieldShouldReturn:textField];
    
    [self.nextBarButton setEnabled:[self isContentValid:nil]];
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertLabel.alpha = 0;
    }];
    
    [self validateFieldForTextField:textField];
    
    [self.nextBarButton setEnabled:[self isContentValid:nil]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.nextBarButton.enabled = [self isContentValid:nil];
    
    [self validateFieldForTextField:textField];
}

#pragma mark - APCFormTextFieldDelegate methods

- (void)formTextFieldDidTapValidButton:(XZCareFormTextField *)textField
{
    [self validateFieldForTextField:textField];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alertLabel.alpha = 1.0;
    } completion:nil];
}

- (void)validateFieldForTextField:(UITextField *)textField
{
    NSString *errorMessage = @"";
    
    if (textField == self.emailTextField)
    {
        BOOL valid = [self isFieldValid:nil forType:kXZCareUserInfoItemTypeEmail errorMessage:&errorMessage];
        self.emailTextField.valid = valid;
        
    }
    else if (textField == self.nameTextField)
    {
        BOOL valid = [self isFieldValid:nil forType:kXZCareUserInfoItemTypeName errorMessage:&errorMessage];
        self.nameTextField.valid = valid;
    }
    
    self.alertLabel.text = errorMessage;
}

#pragma mark - APCPickerTableViewCellDelegate methods

- (void)pickerTableViewCell:(XZCarePickerTableViewCell *)cell datePickerValueChanged:(NSDate *)date
{
    [super pickerTableViewCell:cell datePickerValueChanged:date];
}

- (void)pickerTableViewCell:(XZCarePickerTableViewCell *)cell pickerViewDidSelectIndices:(NSArray *)selectedIndices
{
    [super pickerTableViewCell:cell pickerViewDidSelectIndices:selectedIndices];
}

#pragma mark - APCTextFieldTableViewCellDelegate methods

- (void)textFieldTableViewCellDidBeginEditing:(XZCareTextFieldTableViewCell *) __unused cell
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertLabel.alpha = 0;
    }];
}

- (void)textFieldTableViewCellDidEndEditing:(XZCareTextFieldTableViewCell *)cell
{
    [super textFieldTableViewCellDidEndEditing:cell];
    
    self.nextBarButton.enabled = [self isContentValid:nil];
    
    [self validateFieldForCell:cell];
}

- (void)textFieldTableViewCellDidChangeText:(XZCareTextFieldTableViewCell *)cell
{
    [super textFieldTableViewCellDidChangeText:cell];
    
    self.nextBarButton.enabled = [self isContentValid:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alertLabel.alpha = 0;
    }];
    
    [self validateFieldForCell:cell];
    
    [self.nextBarButton setEnabled:[self isContentValid:nil]];
}

- (void)textFieldTableViewCellDidReturn:(XZCareTextFieldTableViewCell *)cell
{
    [super textFieldTableViewCellDidReturn:cell];
    
    self.nextBarButton.enabled = [self isContentValid:nil];
}

- (void)textFieldTableViewCellDidTapValidationButton:(XZCareTextFieldTableViewCell *)cell
{
    [self validateFieldForCell:cell];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alertLabel.alpha = 1.0;
    } completion:nil];
}

- (void)validateFieldForCell:(XZCareTextFieldTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    XZCareTableViewTextFieldItem *item = (XZCareTableViewTextFieldItem *)[self itemForIndexPath:indexPath];
    XZCareTableViewItemType itemType = [self itemTypeForIndexPath:indexPath];
    
    NSString *errorMessage = @"";
    
    BOOL valid = [self isFieldValid:item forType:itemType errorMessage:&errorMessage];
    
    if ([cell.textField isKindOfClass:[XZCareFormTextField class]])
    {
        ((XZCareFormTextField *)cell.textField).valid = valid;
    }
    
    self.alertLabel.text = errorMessage;
}

#pragma mark - APCSegmentedTableViewCellDelegate methods

- (void)segmentedTableViewCell:(XZCareSegmentedTableViewCell *)cell didSelectSegmentAtIndex:(NSInteger)index
{
    [super segmentedTableViewCell:cell didSelectSegmentAtIndex:index];
}

#pragma mark - Private Methods

- (BOOL) isContentValid:(NSString **)errorMessage
{
    
    BOOL isContentValid = [super isContentValid:errorMessage];
    
    if (isContentValid) {
        
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
                    case kXZCareUserInfoItemTypeEmail:
                    {
                        isContentValid = [[(XZCareTableViewTextFieldItem *)item value] isValidForRegex:kXZCareGeneralInfoItemEmailRegEx];
                        
                        if (errorMessage)
                        {
                            *errorMessage = NSLocalizedString(@"Please enter a valid email address.", @"");
                        }
                    }
                        break;
                        
                    case kXZCareUserInfoItemTypePassword:
                    {
                        if ([[(XZCareTableViewTextFieldItem *)item value] length] == 0)
                        {
                            isContentValid = NO;
                            if (errorMessage)
                            {
                                *errorMessage = NSLocalizedString(@"Please enter a Password.", @"");
                            }
                        }
                        else if ([[(XZCareTableViewTextFieldItem *)item value] length] < kXZCarePasswordMinimumLength)
                        {
                            isContentValid = NO;
                            if (errorMessage)
                            {
                                *errorMessage = [NSString stringWithFormat:NSLocalizedString(@"Password should be at least %d characters", ), kXZCarePasswordMinimumLength];
                            }
                        }
                    }
                        break;
                        
                    default:
                        NSAssert(itemType <= kXZCareUserInfoItemTypeWakeUpTime, @"ASSER_MESSAGE");
                        break;
                }
                
                // If any of the content is not valid the break the for loop
                // We doing this 'break' here because we cannot break a for loop inside switch-statements (switch already have break statement)
                if (!isContentValid)
                {
                    break;
                }
            }
        }
        
    }
    
    //Commented as Terms & Conditions is disabled for now.
    
//    if (isContentValid) {
//        isContentValid = self.permissionButton.isSelected;
//    }
    
    return isContentValid;
}

- (BOOL)isFieldValid:(XZCareTableViewTextFieldItem *)item forType:(XZCareTableViewItemType)type errorMessage:(NSString **)errorMessage
{
    BOOL fieldValid = NO;
    
    if (type == kXZCareUserInfoItemTypeEmail)
    {
        if (self.emailTextField.text.length > 0)
        {
            fieldValid = [self.emailTextField.text isValidForRegex:kXZCareGeneralInfoItemEmailRegEx];
            
            if (errorMessage && !fieldValid)
            {
                *errorMessage = NSLocalizedString(@"Please enter a valid email address.", @"");
            }
        }
        else
        {
            if (errorMessage && !fieldValid)
            {
                *errorMessage = NSLocalizedString(@"Email address cannot be left empty.", @"");
            }
        }
        
    }
    else if (type == kXZCareUserInfoItemTypeName)
    {
        
        if (self.nameTextField.text.length == 0)
        {
            if (errorMessage && !fieldValid)
            {
                *errorMessage = NSLocalizedString(@"Name cannot be left empty.", @"");
            }
        }
        else
        {
            fieldValid = YES;
        }
    }
    else
    {
        switch (type)
        {
            case kXZCareUserInfoItemTypePassword:
                if ([[item value] length] == 0)
                {
                    
                    if (errorMessage)
                    {
                        *errorMessage = NSLocalizedString(@"Please enter a Password.", @"");
                    }
                }
                else if ([[item value] length] < kXZCarePasswordMinimumLength)
                {
                    if (errorMessage)
                    {
                        *errorMessage = [NSString stringWithFormat:NSLocalizedString(@"Password should be at least %d characters", ), kXZCarePasswordMinimumLength];
                    }
                }
                else
                {
                    fieldValid = YES;
                }
                break;
                
            default:
                break;
        }
    }
    
    return fieldValid;
}

- (void) loadProfileValuesInModel
{
    if (self.tableView.tableHeaderView)
    {
#ifdef __NEED_ONLINE_REGISTER__
        self.user.name = self.nameTextField.text;
#endif
        self.user.email = self.emailTextField.text;
        
        if (self.profileImage)
        {
            self.user.profileImage = UIImageJPEGRepresentation(self.profileImage, 1.0);
        }
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
                case kXZCareUserInfoItemTypePassword:
                    self.user.password = [(XZCareTableViewTextFieldItem *)item value];
                    break;
                    
                case kXZCareUserInfoItemTypeBiologicalSex:
                {
                    self.user.biologicalSex = [XZCarePatient sexTypeForIndex:((XZCareTableViewSegmentItem *)item).selectedIndex];
                }
                    break;
                case kXZCareUserInfoItemTypeDateOfBirth:
                    self.user.birthDate = [(XZCareTableViewDatePickerItem *)item date];
                default:
                {
                    //Do nothing for some types as they are readonly attributes
                }
                    break;
            }
        }
    }
    
}

- (void) validateContent
{
    [self.tableView endEditing:YES];
    
    NSString *message;
    if ([self isContentValid:&message])
    {
        [self loadProfileValuesInModel];
        [self next];
    }
    else
    {
        UIAlertController *alert = [UIAlertController simpleAlertWithTitle:NSLocalizedString(@"General Information", @"") message:message];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - APCTermsAndConditionsViewControllerDelegate methods

- (void)termsAndConditionsViewControllerDidAgree
{
    [self.permissionButton setSelected:YES];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.nextBarButton setEnabled:[self isContentValid:nil]];
    }];
}

- (void)termsAndConditionsViewControllerDidCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction) termsAndConditions: (UIButton *) __unused sender
{
    XZCareTermsAndConditionsViewController *termsViewController =  [[UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareTermsAndConditionsViewController"];
    termsViewController.delegate = self;
    [self.navigationController presentViewController:termsViewController animated:YES completion:nil];
}

- (void) secretButton
{
    // Disable the secret button to do nothing.
    return;
}

- (IBAction)next
{
    NSString *errorMessage = @"";
    if ([self isContentValid:&errorMessage])
    {
        [self saveSceneData];
        [self loadProfileValuesInModel];
        
        XZCareSpinnerViewController *spinnerController = [[XZCareSpinnerViewController alloc] init];
        [self presentViewController:spinnerController animated:YES completion:nil];
        
        typeof(self) __weak weakSelf = self;
   
        self.user.biologicalSex = HKBiologicalSexNotSet;
        
        [self.user signUpOnCompletion:^(NSError *error)
        {
            if (error)
            {
                XZCareLogError2 (error);

                //if (error.code == kSBBInternetNotConnected || error.code == kSBBServerNotReachable || error.code == kSBBServerUnderMaintenance)
                if (error.code == -1000 || error.code == -1001 || error.code == -1002)
                {
                    [spinnerController dismissViewControllerAnimated:NO completion:^{
                    
                        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Sign Up", @"")
                                                                                            message:error.localizedDescription
                                                                                     preferredStyle:UIAlertControllerStyleAlert];

                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * __unused action) {}];
                        
                        [alertView addAction:defaultAction];
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                }
                else
                {
                    [spinnerController dismissViewControllerAnimated:NO completion:^{
                        
                        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Sign Up", @"")
                                                                                           message:error.message
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Change Details", @"") style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * __unused action) {}];
                        
                        UIAlertAction* changeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Send Again", nil) style:UIAlertActionStyleDefault
                                                                             handler:^(UIAlertAction * __unused action) {[self next];}];
                        
                        
                        [alertView addAction:okAction];
                        [alertView addAction:changeAction];
                        [self presentViewController:alertView animated:YES completion:nil];
                        
                    }];
                }
            }
            else
            {
               [spinnerController dismissViewControllerAnimated:NO completion:^{

                    UIViewController *viewController = [[self onboarding] nextScene];
                    [weakSelf.navigationController pushViewController:viewController animated:YES];
                }];

            }
        }];
    }
}

- (IBAction)cancel:(id) __unused sender
{
    
}

- (IBAction)changeProfileImage:(id) __unused sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertLabel.alpha = 0;
    }];
    
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

- (void)back
{
    [self saveSceneData];
    [self.navigationController popViewControllerAnimated:YES];
    [[self onboarding] popScene];
}

@end
