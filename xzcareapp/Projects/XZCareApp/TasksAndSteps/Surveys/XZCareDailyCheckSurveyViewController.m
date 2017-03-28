// 
//  APHDailyCheckSurveyViewController.m 
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
#import "XZCareDailyCheckSurveyViewController.h"
#import "XZCareAppConstants.h"

@interface XZCareDailyCheckSurveyViewController ()

@end

@implementation XZCareDailyCheckSurveyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
- (ORKResult *) answerForSurveyStepIdentifier: (NSString*) identifier
{
    NSArray * stepResults = [(ORKStepResult*)[self.result resultForIdentifier:identifier] results];
    ORKStepResult *answer = (ORKStepResult *)[stepResults firstObject];
    return answer;
}
*/

-(NSString *)createResultSummary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    ORKChoiceQuestionResult *result = nil;
    
    result = (ORKChoiceQuestionResult*)[self answerForSurveyStepIdentifier:kFeetCheckStepIdentifier];
    
    if(result != nil)
    {
        NSArray *choiceAnswers = result.choiceAnswers;
        if (choiceAnswers.count > 0)
        {
            NSString *retresult = choiceAnswers[0];
        
            if (retresult)
            {
                dictionary[kFeetCheckResultValueKey] = [NSNumber numberWithInteger:retresult.integerValue];
            }
        }
    }
    else
    {
        ORKTimeIntervalQuestionResult* pTimeResult = (ORKTimeIntervalQuestionResult*)[self answerForSurveyStepIdentifier:kSleepCheckStepIdentifier];
        if(pTimeResult != nil)
        {
            dictionary[kSleepCheckResultValueKey] = [NSNumber numberWithDouble:(pTimeResult.intervalAnswer.doubleValue/3600)];
        }
    }
    return [dictionary JSONString];
}

- (void) processTaskResult
{
    //Should be implemented in child classes
#ifdef DEBUG
    NSLog(@"XZCareDailyCheckSurveyViewController processTaskResult need real implementation in sub classes");
#endif
    NSString * szSummary = [self createResultSummary];

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
        //result.startDate = self.scheduledTask.startOn;
        //result.endDate = self.scheduledTask.endOn;
        self.scheduledTask.results = [NSSet setWithObject:result];
        NSError * error;
        [result saveToPersistentStore:&error];
    }
    self.scheduledTask.completed = @YES;

}

@end
