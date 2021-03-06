// 
//  APCChangePasscodeViewController.m 
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

@interface XZCareChangePasscodeViewController () <XZCarePasscodeViewDelegate>

@property (nonatomic) XZCarePasscodeEntryType entryType;
@property (nonatomic, strong) NSString *passcode;

@end


@implementation XZCareChangePasscodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.passcodeView.delegate = self;
    
    [self setupAppearance];
    self.textLabel.text = NSLocalizedString(@"Enter your old passcode", nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.passcodeView becomeFirstResponder];
    XZCareLogViewControllerAppeared();
}

#pragma mark - Setup

- (void)setupAppearance
{
    [self.textLabel setTextColor:[UIColor appSecondaryColor1]];
    [self.textLabel setFont:[UIFont appLightFontWithSize:19.0f]];
}

#pragma mark - APCPasscodeViewDelegate

- (void)passcodeViewDidFinish:(XZCarePasscodeView *)passcodeView withCode:(NSString *)__unused code {
    
    switch (self.entryType)
    {
        case kXZCarePasscodeEntryTypeOld:
        {
            if ([passcodeView.code isEqualToString:[XZBaseKeychainStore passcode]])
            {
                self.textLabel.text = NSLocalizedString(@"Enter your new passcode", nil);
                [passcodeView reset];
                [passcodeView becomeFirstResponder];
                self.entryType = kXZCarePasscodeEntryTypeNew;
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Wrong Passcode", nil) message:NSLocalizedString(@"Please enter again.", nil) preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okayAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * __unused action) {
                    [passcodeView reset];
                    [passcodeView becomeFirstResponder];
                }];
                [alertController addAction:okayAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
            break;
        case kXZCarePasscodeEntryTypeNew:
        {
            self.textLabel.text = NSLocalizedString(@"Re-enter your new passcode", nil);
            self.passcode = passcodeView.code;
            [passcodeView reset];
            [passcodeView becomeFirstResponder];
            self.entryType = kXZCarePasscodeEntryTypeReEnter;
        }
            break;
        case kXZCarePasscodeEntryTypeReEnter:
        {
            if ([passcodeView.code isEqualToString:self.passcode])
            {
                [self savePasscode];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [passcodeView reset];
                [passcodeView becomeFirstResponder];
                self.entryType = kXZCarePasscodeEntryTypeReEnter;
                
                UIAlertController *alert = [UIAlertController simpleAlertWithTitle:NSLocalizedString(@"Wrong Passcode", nil) message:NSLocalizedString(@"The passcode you entered did not match your new passcode. Please enter again.", nil)];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }
            break;
        default:
            break;
    }
}

- (void)savePasscode
{
    if (self.passcode)
    {
        [XZBaseKeychainStore setPasscode:self.passcode];
    }
    self.passcode = @"";
}

- (IBAction)cancel:(id)__unused sender
{
    self.passcodeView.delegate = nil;
    [self.passcodeView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
