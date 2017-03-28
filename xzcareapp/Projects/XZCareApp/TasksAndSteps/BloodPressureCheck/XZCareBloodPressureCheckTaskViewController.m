//
//  XZCareBloodPressureCheckTaskViewController.m
//  Zhaohui Xing
//
//  Created by Zhaohui Xing on 2015-09-18.
//  Copyright © 2015 Zhaohui Xing. All rights reserved.
//
#import <XZCareCore/XZCareCore.h>
#import "XZCareAppConstants.h"
#import "XZCareBloodPressureCheckTaskViewController.h"


@interface XZCareBloodPressureCheckTaskViewController ()

@end

@implementation XZCareBloodPressureCheckTaskViewController

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

+ (id<ORKTask>)createTask:(XZCareCoreDBScheduledTask*) scheduledTask
{
    return  [scheduledTask.task rkTask];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSString *)createResultSummary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    ORKNumericQuestionResult * systolicResult = nil;
    
    systolicResult = (ORKNumericQuestionResult*)[self answerForSurveyStepIdentifier:kSystolicResultValueKey];
    
    if(systolicResult != nil)
    {
        dictionary[kSystolicResultValueKey] = systolicResult.numericAnswer;
        
        //
        //Saving back Health Kit storage
        //
        XZCareCoreAppDelegate *apcDelegate = (XZCareCoreAppDelegate*)[[UIApplication sharedApplication] delegate];
        //
        HKQuantity *systolicQuantity = [HKQuantity quantityWithUnit:[HKUnit millimeterOfMercuryUnit]
                                                      doubleValue:[systolicResult.numericAnswer doubleValue]];
        
        apcDelegate.dataSubstrate.currentUser.systolicBloodPressure = systolicQuantity;
        
    }
    
    ORKNumericQuestionResult * diastolicResult = nil;
    
    diastolicResult = (ORKNumericQuestionResult*)[self answerForSurveyStepIdentifier:kDiastolicResultValueKey];
    
    if(diastolicResult != nil)
    {
        dictionary[kDiastolicResultValueKey] = diastolicResult.numericAnswer;

        //
        //Saving back Health Kit storage
        //
        XZCareCoreAppDelegate *apcDelegate = (XZCareCoreAppDelegate*)[[UIApplication sharedApplication] delegate];
        //
        HKQuantity *diastolicQuantity = [HKQuantity quantityWithUnit:[HKUnit millimeterOfMercuryUnit]
                                                        doubleValue:[diastolicResult.numericAnswer doubleValue]];
        
        apcDelegate.dataSubstrate.currentUser.diastolicBloodPressure = diastolicQuantity;
    
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
