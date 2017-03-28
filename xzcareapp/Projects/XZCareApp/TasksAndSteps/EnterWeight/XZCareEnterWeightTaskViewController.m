// 
//  APHEnterWeightTaskViewController.m 
//  GlucoSuccess 
// 
// Copyright (c) 2015, Massachusetts General Hospital. All rights reserved. 
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
#import "XZCareAppConstants.h"
#import "XZCareEnterWeightTaskViewController.h"


static NSString * kEnterWeightStepIntroKey = @"EnterWeight_Step_Intro";
static NSString * kEnterWeightStep101Key = @"EnterWeight_Step_101";
static NSString * kEnterWeightStep102Key = @"EnterWeight_Step_102";

@interface XZCareEnterWeightTaskViewController ()

@property (nonatomic, strong) NSNumber *currentWeightValue;

@end

@implementation XZCareEnterWeightTaskViewController

+ (ORKOrderedTask *)createTask:(XZCareCoreDBScheduledTask*) __unused scheduledTask
{
    
    NSMutableArray *steps = [NSMutableArray array];
    {
        ORKStep* step = [[ORKStep alloc] initWithIdentifier:kEnterWeightStepIntroKey];
        [steps addObject:step];
    }
    {
        ORKHealthKitQuantityTypeAnswerFormat * format = [ORKHealthKitQuantityTypeAnswerFormat answerFormatWithQuantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]
                                                                                                                        unit:[HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitPound]
                                                                                                                       style:ORKNumericAnswerStyleDecimal];
        ORKQuestionStep* step = [ORKQuestionStep questionStepWithIdentifier:kEnterWeightStep101Key
                                                                     title:@"How much do you weigh?"
                                                                       answer:format];
        step.optional = NO;
        [steps addObject:step];
    }
    {
        ORKStep* step = [[ORKStep alloc] initWithIdentifier:kEnterWeightStep102Key];
        [steps addObject:step];
    }
    
    ORKOrderedTask  *task = [[ORKOrderedTask alloc] initWithIdentifier:@"WeightMeasurement" steps:steps];
    
    return  task;
}

- (BOOL)taskViewController:(ORKTaskViewController *)taskViewController shouldPresentStep:(ORKStep *)step
{
    BOOL shouldShowStep = YES;
    
    if ([step.identifier isEqualToString:kEnterWeightStep102Key])
    {
        NSArray *stepResults = self.result.results;
        
        for (ORKStepResult *result in stepResults)
        {
            for (ORKNumericQuestionResult *stepResult in result.results)
            {
                NSNumber *stepAnswer = stepResult.numericAnswer;
                
                if ([stepAnswer integerValue] < 25 || stepResult.numericAnswer == (NSNumber *)[NSNull null])
                {
                    shouldShowStep = NO;
                    break;
                }
            }
            
            if (!shouldShowStep)
            {
                UIAlertController* alerVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid Weight",
                                                                                                          @"Invalid Weight")
                                                                                message:NSLocalizedString(@"Please enter a valid value for your weight.",
                                                                                                          @"Please enter a valid value for your weight.")
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * __unused action) {
                                         [alerVC dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                
                
                [alerVC addAction:ok];
                
                [taskViewController presentViewController:alerVC animated:NO completion:nil];
                break;
            }
        }
    }
    
    return shouldShowStep;
}

- (ORKStepViewController *)taskViewController:(ORKTaskViewController *)taskViewController viewControllerForStep:(ORKStep *)step
{
    XZCareStepViewController  *controller = nil;
    if ([step.identifier isEqualToString:kEnterWeightStepIntroKey])
    {
        controller = (XZCareInstructionStepViewController*) [[UIStoryboard storyboardWithName:@"XZCareInstructionStep" bundle:[NSBundle XZCareCoreBundle]] instantiateInitialViewController];
        XZCareInstructionStepViewController * instController = (XZCareInstructionStepViewController*) controller;
        instController.imagesArray = @[@"weightmeasurement-Icon1", @"weightmeasurement-Icon2", @"weightmeasurement-Icon3"];
        instController.headingsArray = @[@"Consistent Time of Day", @"Consistent Clothing", @"Use the Same Scale"];
        instController.messagesArray = @[@"It is best to weigh yourself at a regular hour, every time. A good time can be early in the morning before eating.",
                                         @"For an increased level of accuracy, wear a similar outfit when weighing yourself each time.",
                                         @"Using the same scale every time you weigh yourself will produce the most accurate readings."];
        controller.delegate = self;
        controller.step = step;
    }
    else if ([step.identifier isEqualToString:kEnterWeightStep102Key])
    {
        for (ORKStepResult *surveyQuestion in taskViewController.result.results)
        {
            if ([surveyQuestion.identifier isEqualToString:kEnterWeightStep101Key])
            {
                ORKNumericQuestionResult *questionResult = [surveyQuestion.results firstObject];
                
                NSNumber *weightValue = questionResult.numericAnswer;
                
                // Write results to HealthKit
                XZCareCoreAppDelegate *apcDelegate = (XZCareCoreAppDelegate*)[[UIApplication sharedApplication] delegate];
                //
                HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:[HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitPound]
                                                              doubleValue:[weightValue doubleValue]];
                
                apcDelegate.dataSubstrate.currentUser.weight = weightQuantity;
                
                self.currentWeightValue = weightValue;
            }
        }
        
        
        controller = [[XZCareSimpleTaskSummaryViewController alloc] initWithNibName:nil bundle:[NSBundle XZCareCoreBundle]];
        controller.delegate = self;
        controller.step = step;
    }
    
    return controller;
}

- (NSString *)createResultSummary
{
    NSError *error = nil;
    
    NSDictionary *weightResult = @{kWeightResultValueKey: self.currentWeightValue};
    
    NSData *weightEntry = [NSJSONSerialization dataWithJSONObject:weightResult options:0 error:&error];
    NSString *contentString = [[NSString alloc] initWithData:weightEntry encoding:NSUTF8StringEncoding];
    
    return contentString;
}

-(void)processTaskResult
{
    NSString* szSummary = [self createResultSummary];
#ifdef DEBUG
    NSLog(@"XZCareDrugLogTaskViewController processTaskResult szSummary:%@\n", szSummary);
    [self.scheduledTask DebugLog];
#endif
    
    if(self.scheduledTask.results != nil && 0 < self.scheduledTask.results.count)
    {
        NSArray *scheduledTaskResults = [self.scheduledTask.results allObjects];
        for (XZCareCoreDBResult *result in scheduledTaskResults)
        {
            if(result != nil)
            {
                result.resultSummary = szSummary;
                //result.startDate = [NSDate date];
                NSError * error;
                [result saveToPersistentStore:&error];
            }
        }
    }
    else
    {
        NSManagedObjectContext * context = [self.scheduledTask managedObjectContext];//((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.mainContext;
        NSManagedObjectID * objectID = [XZCareCoreDBResult storeTaskResult:self.result inContext:context];
        XZCareCoreDBResult * result = (XZCareCoreDBResult*)[context objectWithID:objectID];
        result.archiveFilename = @"";
        result.resultSummary = szSummary;
        result.scheduledTask = self.scheduledTask;
        result.startDate = self.scheduledTask.startOn;
        result.endDate = self.scheduledTask.endOn;
        self.scheduledTask.results = [NSSet setWithObject:result];
        NSError * error;
        [result saveToPersistentStore:&error];
    }
    self.scheduledTask.completed = @YES;
}

@end
