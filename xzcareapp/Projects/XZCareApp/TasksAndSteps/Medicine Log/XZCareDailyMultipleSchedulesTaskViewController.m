//
//  XZCareDailyThreeTimeSchedulesTaskViewController.m
//  Zhaohui Xing
//
//  Created by Zhaohui Xing on 2015-10-03.
//  Copyright © 2015 Zhaohui Xing. All rights reserved.
//
#import <XZCareCore/XZCareCore.h>
#import "XZCareDailyMultipleSchedulesTaskViewController.h"
#import "XZCareAppConstants.h"

@interface XZCareDailyMultipleSchedulesTaskViewController ()

@end

@implementation XZCareDailyMultipleSchedulesTaskViewController

+ (id<ORKTask>)createTask:(XZCareCoreDBScheduledTask*) scheduledTask
{
    ORKOrderedTask * retTask = (ORKOrderedTask *)[scheduledTask.task rkTask];
    return  retTask;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
- (void)taskViewController:(ORKTaskViewController *)taskViewController didChangeResult:(ORKTaskResult *)result
{
    if(result != nil)
    {
        NSString *anIdentifier = [result identifier];
        ORKNumericQuestionResult *questionResult = [result.results firstObject];
        self.valueMaps[anIdentifier] = questionResult.numericAnswer;
    }
}
*/
 
-(NSString *)createResultSummary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];

    __block int nTotoalMount = 0;
    
    if(self.result != nil && self.result.results != nil && 0 < self.result.results.count)
    {
        [self.result.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            if ([obj isKindOfClass:[ORKResult class]] == YES)
            {
                NSString *anIdentifier = [(ORKResult *)obj identifier];
                ORKCollectionResult* pStepResults = (ORKCollectionResult *)obj;
                ORKNumericQuestionResult* firstValue = [pStepResults.results objectAtIndex:0];
                
                dictionary[anIdentifier] = firstValue.numericAnswer;
                nTotoalMount += [firstValue.numericAnswer intValue];
#ifdef DEBUG
                NSLog(@"Result id:%@  value:%i", anIdentifier, [firstValue.numericAnswer intValue]);
#endif

            }
        }];
    }
    
#ifdef DEBUG
    NSLog(@"Result totla value:%i", nTotoalMount);
#endif
    dictionary[kMultipleSurveyStepTaskTotalValueKey] = [NSNumber numberWithInt:nTotoalMount];

    return [dictionary JSONString];

}

- (void) processTaskResult
{
    //Should be implemented in child classes
    NSString * szSummary = [self createResultSummary];
    
    if(self.scheduledTask.results != nil && 0 < self.scheduledTask.results.count)
    {
        NSArray *scheduledTaskResults = [self.scheduledTask.results allObjects];
        for (XZCareCoreDBResult *result in scheduledTaskResults)
        {
            if(result != nil)
            {
                result.resultSummary = szSummary;
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
        self.scheduledTask.results = [NSSet setWithObject:result];
        NSError * error;
        [result saveToPersistentStore:&error];
    }
    self.scheduledTask.completed = @YES;
}

@end
