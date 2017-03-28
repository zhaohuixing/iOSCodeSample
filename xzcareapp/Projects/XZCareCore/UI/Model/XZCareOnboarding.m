// 
//  APCOnboarding.m 
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


@interface XZCareOnboarding ()

@property (nonatomic, readwrite) XZCareOnboardingTask *onboardingTask;
@property (nonatomic, readwrite) XZCareOnboardingTaskType taskType;;

@end

@implementation XZCareOnboarding

- (instancetype)initWithDelegate:(id)object  taskType:(XZCareOnboardingTaskType)taskType
{
    self = [super init];
    if (self)
    {
        _taskType = taskType;
        
        if (taskType == kXZCareOnboardingTaskTypeSignIn)
        {
            _onboardingTask = [XZCareSignInTask new];
        }
        else
        {
            _onboardingTask = [XZCareSignUpTask new];
        }
        
        _sceneData = [NSMutableDictionary new];
        _delegate = object;
        _onboardingTask.delegate = object;
        
        _scenes = [self prepareScenes];
    }
    
    return self;
}

- (NSMutableDictionary *)prepareScenes
{
    NSMutableDictionary *scenes = [NSMutableDictionary new];
    
    
    {
        if ([self.delegate respondsToSelector:@selector(inclusionCriteriaSceneForOnboarding:)])
        {
            XZCareScene *scene = [self.delegate inclusionCriteriaSceneForOnboarding:self];
            [scenes setObject:scene forKey:kXZCareSignUpInclusionCriteriaStepIdentifier];
        }
    }
    {
        XZCareScene *scene = [XZCareScene new];
        scene.name = NSStringFromClass([XZCareEligibleViewController class]);
        scene.classType = NSStringFromClass([XZCareEligibleViewController class]);//???

        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle XZCareCoreBundle];
        
        [scenes setObject:scene forKey:kXZCareSignUpEligibleStepIdentifier];
    }
    {
        XZCareScene *scene = [XZCareScene new];
        scene.name = NSStringFromClass([XZCareInEligibleViewController class]);
        scene.classType = NSStringFromClass([XZCareInEligibleViewController class]);//???
        
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle XZCareCoreBundle];
        
        [scenes setObject:scene forKey:kXZCareSignUpIneligibleStepIdentifier];
    }
    {
        XZCareScene *scene = [XZCareScene new];
        scene.name = NSStringFromClass([XZCarePermissionPrimingViewController class]);
        scene.classType = NSStringFromClass([XZCarePermissionPrimingViewController class]);//???
        
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle XZCareCoreBundle];
        
        [scenes setObject:scene forKey:kXZCareSignUpPermissionsPrimingStepIdentifier];
    }
#ifdef __NEED_ONLINE_REGISTER__
    {
        XZCareScene *scene = [XZCareScene new];
        scene.name = NSStringFromClass([XZCareSignUpGeneralInfoViewController class]);
        scene.classType = NSStringFromClass([XZCareSignUpGeneralInfoViewController class]);//???
        
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle XZCareCoreBundle];
        
        [scenes setObject:scene forKey:kXZCareSignUpGeneralInfoStepIdentifier];
    }
#endif
    {
        XZCareScene *scene = [XZCareScene new];
        scene.name = NSStringFromClass([XZCareSignUpMedicalInfoViewController class]);
        scene.classType = NSStringFromClass([XZCareSignUpMedicalInfoViewController class]);//???

        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle XZCareCoreBundle];
        
        [scenes setObject:scene forKey:kXZCareSignUpMedicalInfoStepIdentifier];
    }
    {
        if ([self.delegate respondsToSelector:@selector(customInfoSceneForOnboarding:)])
        {
            XZCareScene *scene = [self.delegate customInfoSceneForOnboarding:self];
            [scenes setObject:scene forKey:kXZCareSignUpCustomInfoStepIdentifier];
            self.onboardingTask.customStepIncluded = YES;
        }
    }
    {
        XZCareScene *scene = [XZCareScene new];
        scene.name = NSStringFromClass([XZCareSignupPasscodeViewController class]);
        scene.classType = NSStringFromClass([XZCareSignupPasscodeViewController class]);//???
        
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle XZCareCoreBundle];
        
        [scenes setObject:scene forKey:kXZCareSignUpPasscodeStepIdentifier];
    }
    {
        XZCareScene *scene = [XZCareScene new];
        scene.name = NSStringFromClass([XZCareSignUpPermissionsViewController class]);
        scene.classType = NSStringFromClass([XZCareSignUpPermissionsViewController class]);//???
        
        
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle XZCareCoreBundle];
        
        [scenes setObject:scene forKey:kXZCareSignUpPermissionsStepIdentifier];
    }
    {
        XZCareScene *scene = [XZCareScene new];
        scene.name = NSStringFromClass([XZCareThankYouViewController class]);
        scene.classType = NSStringFromClass([XZCareThankYouViewController class]);//???
        
        
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle XZCareCoreBundle];
        
        [scenes setObject:scene forKey:kXZCareSignUpThankYouStepIdentifier];
    }
    {
        XZCareScene *scene = [XZCareScene new];
        scene.name = NSStringFromClass([XZCareSignInViewController class]);
        scene.classType = NSStringFromClass([XZCareSignInViewController class]);//???
        
        
        scene.storyboardName = kOnboardingStoryboardName;
        scene.bundle = [NSBundle XZCareCoreBundle];
        
        [scenes setObject:scene forKey:kXZCareSignInStepIdentifier];
    }
    
    return scenes;
}

- (UIViewController *)nextScene
{
    ORKTaskResult* result = nil;
    self.currentStep = [self.onboardingTask stepAfterStep:self.currentStep withResult:result];
    
    UIViewController *nextViewController = [self viewControllerForSceneIdentifier:self.currentStep.identifier];
    
    return nextViewController;
}

- (void)popScene
{
    ORKTaskResult* result = nil;
    if (![self.currentStep.identifier isEqualToString:kXZCareSignUpMedicalInfoStepIdentifier])
    {
        self.currentStep = [self.onboardingTask stepBeforeStep:self.currentStep withResult:result];
    }
}

- (UIViewController *)viewControllerForSceneIdentifier:(NSString *)identifier
{
    XZCareScene *scene = self.scenes[identifier];
    
    UIViewController *viewController = [[UIStoryboard storyboardWithName:scene.storyboardName bundle:scene.bundle] instantiateViewControllerWithIdentifier:scene.name];
    return viewController;
}

- (void)setScene:(XZCareScene *)scene forIdentifier:(NSString *)identifier
{
    [self.scenes setObject:scene forKey:identifier];
}

@end


@implementation XZCareScene

@end
