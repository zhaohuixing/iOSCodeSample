// 
//  APCOnboardingTask.m 
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

#import "XZCarePatient+XZCareCore.h"
#import "XZCareOnboardingTask.h"
#import "XZCareConstants.h"


@implementation XZCareOnboardingTask

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _currentStepNumber = 0;
    }
    
    return self;
}

#pragma mark - ORKTask methods

- (ORKStep *)stepAfterStep:(ORKStep *) __unused step withResult:(ORKTaskResult *) __unused result
{
    ORKStep *nextStep;
    
    NSAssert(FALSE, @"Override this delegate method by using either APCSignUpTask or APCSignInTask");
    
    return nextStep;
}

- (ORKStep *)stepBeforeStep:(ORKStep *) __unused step withResult:(ORKTaskResult *) __unused result
{
    ORKStep *prevStep;
    
    NSAssert(FALSE, @"Override this delegate method by using either APCSignUpTask or APCSignInTask");
    
    return prevStep;
}

- (NSString *)identifier
{
    return @"OnboaringTask";
}

#pragma mark - Getter methods

- (BOOL)permissionScreenSkipped
{
    BOOL skip = NO;
    
    if ([self.delegate respondsToSelector:@selector(numberOfServicesInPermissionsListForOnboardingTask:)])
    {
        NSInteger count = [self.delegate numberOfServicesInPermissionsListForOnboardingTask:self];
        skip = (count == 0);
    }
    
    return skip;
}

- (XZCarePatient *)user
{
    if ([self.delegate respondsToSelector:@selector(userForOnboardingTask:)])
    {
        _user = [self.delegate userForOnboardingTask:self];
    }
    
    return _user;
}

#pragma mark Steps

- (ORKStep *)inclusionCriteriaStep
{
    if (!_inclusionCriteriaStep)
    {
        _inclusionCriteriaStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpInclusionCriteriaStepIdentifier];
    }
    
    return _inclusionCriteriaStep;
}

- (ORKStep *)eligibleStep
{
    if (!_eligibleStep)
    {
        _eligibleStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpEligibleStepIdentifier];
    }
    
    return _eligibleStep;
}

- (ORKStep *)ineligibleStep
{
    if (!_ineligibleStep)
    {
        _ineligibleStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpIneligibleStepIdentifier];
    }
    
    return _ineligibleStep;
}

- (ORKStep *)permissionsPrimingStep
{
    if (!_permissionsPrimingStep)
    {
        _permissionsPrimingStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpPermissionsPrimingStepIdentifier];
    }
    
    return _permissionsPrimingStep;
}

#ifdef __NEED_ONLINE_REGISTER__
- (ORKStep *)generalInfoStep
{
    if (!_generalInfoStep)
    {
        _generalInfoStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpGeneralInfoStepIdentifier];
    }
    
    return _generalInfoStep;
}
#endif

- (ORKStep *)medicalInfoStep
{
    if (!_medicalInfoStep)
    {
        _medicalInfoStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpMedicalInfoStepIdentifier];
    }
    
    return _medicalInfoStep;
}

- (ORKStep *)customInfoStep
{
    if (!_customInfoStep)
    {
        _customInfoStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpCustomInfoStepIdentifier];
    }
    
    return _customInfoStep;
}

- (ORKStep *)passcodeStep
{
    if (!_passcodeStep)
    {
        _passcodeStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpPasscodeStepIdentifier];
    }
    
    return _passcodeStep;
}

- (ORKStep *)permissionsStep
{
    if (!_permissionsStep)
    {
        _permissionsStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpPermissionsStepIdentifier];
    }
    
    return _permissionsStep;
}

- (ORKStep *)thankyouStep
{
    if (!_thankyouStep)
    {
        _thankyouStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignUpThankYouStepIdentifier];
    }
    
    return _thankyouStep;
}

- (ORKStep *)signInStep
{
    if (!_signInStep)
    {
        _signInStep = [[ORKStep alloc] initWithIdentifier:kXZCareSignInStepIdentifier];
    }
    
    return _signInStep;
}


@end