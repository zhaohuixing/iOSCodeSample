// 
//  Food 
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
#import "XZCareDrugLogTaskViewController.h"
#import "XZCareAppConstants.h"


@interface XZCareDrugLogTaskViewController ()

@property (nonatomic, strong) NSNumber *currentDosageValue;

@end

@implementation XZCareDrugLogTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#ifdef DEBUG
    NSLog(@"XZCareDrugLogTaskViewController viewWillAppear\n");
#endif
}

-(void)stepViewControllerWillAppear:(ORKStepViewController *)viewController
{
    [super stepViewControllerWillAppear:viewController];
   // if(viewController != nil)
   // {
   //     viewController
   // }
}

-(void)LoadOneDownLogResult
{
    for (ORKStepResult *surveyQuestion in self.result.results)
    {
        ORKNumericQuestionResult *questionResult = (ORKNumericQuestionResult*)[surveyQuestion.results firstObject];
        self.currentDosageValue = questionResult.numericAnswer;
#ifdef DEBUG
        NSLog(@"XZCareDrugLogTaskViewController DebugLog query result value:%@", [self.currentDosageValue description]);
#endif
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
#ifdef DEBUG
    NSLog(@"XZCareDrugLogTaskViewController viewWillAppear\n");
#endif
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
#ifdef DEBUG
    NSLog(@"XZCareDrugLogTaskViewController viewDidDisappear\n");
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)createResultSummary
{
    NSError *error = nil;
    
    [self LoadOneDownLogResult];
    
    NSDictionary *oneDownResult = @{kOneDownDosageResultValueKey: self.currentDosageValue};
    
    NSData *dosageEntry = [NSJSONSerialization dataWithJSONObject:oneDownResult options:0 error:&error];
    NSString *contentString = [[NSString alloc] initWithData:dosageEntry encoding:NSUTF8StringEncoding];
    
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

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(nullable NSError *)error
{
    if (reason == ORKTaskViewControllerFinishReasonCompleted)
    {
        for (ORKStepResult *surveyQuestion in self.result.results)
        {
            ORKNumericQuestionResult *questionResult = [surveyQuestion.results firstObject];
            self.currentDosageValue = questionResult.numericAnswer;
        }
        if(self.currentDosageValue == nil)
        {
            [taskViewController dismissViewControllerAnimated:YES completion:nil];
            return;
        }
    }
    
    [super taskViewController:taskViewController didFinishWithReason:reason error:error];
}

@end
