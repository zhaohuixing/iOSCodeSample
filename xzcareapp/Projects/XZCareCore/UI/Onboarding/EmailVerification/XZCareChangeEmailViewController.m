// 
//  APCChangeEmailViewController.m 
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

@interface XZCareChangeEmailViewController ()

@end

@implementation XZCareChangeEmailViewController

- (void)dealloc
{
    _emailTextField.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAppearance];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.emailTextField becomeFirstResponder];
    XZCareLogViewControllerAppeared();
}
#pragma mark - Appearance

- (void)setupAppearance
{
    [self.emailTextField setTextColor:[UIColor appSecondaryColor1]];
    [self.emailTextField setFont:[UIFont appRegularFontWithSize:17.0f]];
}

#pragma mark - UITableViewDelegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        [self.emailTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *) __unused textField
{
    [self updateEmailAddress];
    
    return YES;
}

- (BOOL) isContentValid:(NSString **)errorMessage
{
    BOOL isContentValid = NO;
    
    if (self.emailTextField.text.length == 0)
    {
        *errorMessage = NSLocalizedString(@"Please enter your email address.", @"");
        isContentValid = NO;
    }
    else
    {
        isContentValid = YES;
    }
    
    return isContentValid;
}

- (XZCarePatient *) user
{
    return ((XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate).dataSubstrate.currentUser;
}

#pragma mark - Public Methods

- (void)updateEmailAddress
{
    NSString *error;
    
    if ([self isContentValid:&error])
    {
        if ([self.emailTextField.text isValidForRegex:(NSString *)kXZCareGeneralInfoItemEmailRegEx])
        {
            XZCareSpinnerViewController *spinnerController = [[XZCareSpinnerViewController alloc] init];
            [self presentViewController:spinnerController animated:YES completion:nil];
            
            XZCarePatient *user = [self user];
            user.email = self.emailTextField.text;
            
            typeof(self) __weak weakSelf = self;
            
            [user signUpOnCompletion:^(NSError *error) {
                if (error)
                {
                    XZCareLogError2 (error);
                    
                    [spinnerController dismissViewControllerAnimated:NO completion:^{
                        
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", @"Dismiss") style:UIAlertActionStyleCancel handler:^(UIAlertAction * __unused action) {
                            
                        }];
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:error.message preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:cancelAction];
                        
                        [weakSelf.navigationController presentViewController:alertController animated:YES completion:nil];
                    }];
                }
                else
                {
                    [spinnerController dismissViewControllerAnimated:NO completion:^{
                        
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }];
                }
            }];
        }
        else
        {
            UIAlertController *alert = [UIAlertController simpleAlertWithTitle:NSLocalizedString(@"Change Email", @"") message:NSLocalizedString(@"Please enter a valid email address", @"")];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertController *alert = [UIAlertController simpleAlertWithTitle:NSLocalizedString(@"Change Email", @"") message:error];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Selectors / IBActions

- (IBAction) done:(id) __unused sender
{
    [self updateEmailAddress];
}

- (IBAction)cancel:(id) __unused sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
