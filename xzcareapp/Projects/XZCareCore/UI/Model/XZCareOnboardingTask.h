// 
//  APCOnboardingTask.h 
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
 
#import <Foundation/Foundation.h>
#import <ResearchKit/ResearchKit.h>

@class XZCarePatient;

@protocol XZCareOnboardingTaskDelegate;

@interface XZCareOnboardingTask : NSObject <ORKTask>

@property (nonatomic, weak) id <XZCareOnboardingTaskDelegate> delegate;
@property (nonatomic) BOOL eligible;
@property (nonatomic) BOOL customStepIncluded;
@property (nonatomic) XZCarePatient *user;

/**
 *  When the list of Services required in zero, we can skip
 */
@property (nonatomic,readonly) BOOL permissionScreenSkipped;
@property (nonatomic) NSInteger currentStepNumber;
@property (nonatomic) NSInteger numberOfSteps;
@property (nonatomic, strong) ORKStep *inclusionCriteriaStep;
@property (nonatomic, strong) ORKStep *eligibleStep;
@property (nonatomic, strong) ORKStep *ineligibleStep;
@property (nonatomic, strong) ORKStep *permissionsPrimingStep;
@property (nonatomic, strong) ORKStep *medicalInfoStep;
@property (nonatomic, strong) ORKStep *customInfoStep;
@property (nonatomic, strong) ORKStep *passcodeStep;
@property (nonatomic, strong) ORKStep *permissionsStep;
@property (nonatomic, strong) ORKStep *thankyouStep;
@property (nonatomic, strong) ORKStep *signInStep;

#ifdef __NEED_ONLINE_REGISTER__
@property (nonatomic, strong) ORKStep *generalInfoStep;
#endif

@end

@protocol XZCareOnboardingTaskDelegate <NSObject>

- (XZCarePatient *)userForOnboardingTask:(XZCareOnboardingTask *)task;
- (NSInteger)numberOfServicesInPermissionsListForOnboardingTask:(XZCareOnboardingTask *)task;

@end
