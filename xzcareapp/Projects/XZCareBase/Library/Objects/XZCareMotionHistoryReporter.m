// 
//  APCMotionHistoryReporter.m 
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
#import <CoreMotion/CoreMotion.h>

typedef NS_ENUM(NSInteger, MotionActivity)
{
    MotionActivityStationary = 1,
    MotionActivityWalking,
    MotionActivityRunning,
    MotionActivityAutomotive,
    MotionActivityCycling,
    MotionActivityUnknown
};


@interface XZCareMotionHistoryReporter()
{
    CMMotionActivityManager * motionActivityManager;
    CMMotionManager * motionManager;
    NSMutableArray *motionReport;
    BOOL isTheDataReady;
    
}

@end

@implementation XZCareMotionHistoryReporter

static XZCareMotionHistoryReporter __strong *sharedInstance = nil;



+(XZCareMotionHistoryReporter *) sharedInstance
{
    //Thread-Safe version
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [self new];
    });
    
    
    return sharedInstance;
}


- (id)init
{
    self = [super init];
    if(self)
    {
        self->motionActivityManager = [CMMotionActivityManager new];
        self->motionReport = [NSMutableArray new];
        self->isTheDataReady = false;
    }
    
    return self;
}

-(void)startMotionCoProcessorDataFrom:(NSDate *)startDate andEndDate:(NSDate *)endDate andNumberOfDays:(NSInteger)numberOfDays
{
    [motionReport removeAllObjects];
    isTheDataReady = false;
    
    [self getMotionCoProcessorDataFrom:startDate andEndDate:endDate andNumberOfDays:numberOfDays];
}

//iOS is collecting activity data in the background whether you ask for it or not, so this feature will give you activity data even if your application as only been installed very recently.
-(void)getMotionCoProcessorDataFrom:(NSDate *)startDate andEndDate:(NSDate *)endDate andNumberOfDays:(NSInteger)numberOfDays
{
    
    NSInteger               numberOfDaysBack = numberOfDays * -1;
    NSDateComponents        *components = [[NSDateComponents alloc] init];
    
    [components setDay:numberOfDaysBack];
    NSDate                  *newStartDate = [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                                                          toDate:startDate
                                                                                         options:0];
    
    NSInteger               numberOfDaysBackForEndDate = numberOfDays * -1;
    
    NSDateComponents        *endDateComponent = [[NSDateComponents alloc] init];
    [endDateComponent setDay:numberOfDaysBackForEndDate];
    
    NSDate                  *newEndDate = [[NSCalendar currentCalendar] dateByAddingComponents:endDateComponent
                                                                                        toDate:endDate
                                                                                       options:0];
  
    
    [motionActivityManager queryActivityStartingFromDate:newStartDate
                                                       toDate:newEndDate
                                                      toQueue:[NSOperationQueue new]
                                                  withHandler:^(NSArray *activities, NSError * __unused error) {
                                                     
                                                      if (numberOfDays > 0)
                                                      {
                                                          NSDate *lastActivity_started;

                                                          NSTimeInterval totalUnknownTime = 0.0;
                                                          
                                                          NSTimeInterval totalRunningTime = 0.0;
                                                          NSTimeInterval totalSleepTime = 0.0;
                                                          NSTimeInterval totalLightActivityTime = 0.0;
                                                          NSTimeInterval totalSedentaryTime = 0.0;
                                                          NSTimeInterval totalModerateTime = 0.0;
                                                          
                                                          
                                                          NSTimeInterval totalModerateActivityTime = 0.0;
                                                          NSTimeInterval totalVigorousActivityTime = 0.0;
                                                           
                                                          //CMMotionActivity is generated every time the state of motion changes. Assuming this, given two CMMMotionActivity objects you can calculate the duration between the two events thereby determining how long the activity of stationary/walking/running/driving/uknowning was.
                                                          
                                                          //Setting lastMotionActivityType to 0 from this point on we will use the emum.
                                                          NSInteger lastMotionActivityType = 0;
                                                          
                                                           NSMutableArray *motionDayValues = [NSMutableArray new];
                                                          
                                                          for(CMMotionActivity *activity in activities)
                                                          {
                                                              
                                                              NSTimeInterval activityLengthTime = 0.0;
                                                              activityLengthTime = fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                              
                                                              NSDate *midnight = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                                                                   minute:0
                                                                                                                   second:0
                                                                                                                   ofDate:newEndDate
                                                                                                                  options:0];

                                                              NSTimeInterval removeThis = 0;
                                                              
                                                              if (![[midnight laterDate:activity.startDate] isEqualToDate:midnight]|| [midnight isEqualToDate:activity.startDate])
                                                              {
                                                                  if (![[lastActivity_started laterDate: midnight] isEqualToDate:lastActivity_started] && ![midnight isEqualToDate:lastActivity_started])
                                                                  {
                                                                      //Get time interval of the potentially overlapping date
                                                                      removeThis = [midnight timeIntervalSinceDate:lastActivity_started];
                                                                      
                                                                      activityLengthTime = activityLengthTime - removeThis;
                                                                  }
                                                                  
                                                                  //Look for walking moderate and high confidence
                                                                  //Cycling any confidence
                                                                  //Running any confidence
                                                                  
                                                                  if((lastMotionActivityType == MotionActivityWalking && activity.confidence == CMMotionActivityConfidenceHigh) || (lastMotionActivityType == MotionActivityWalking && activity.confidence == CMMotionActivityConfidenceMedium))
                                                                  {

                                                                      if(activity.confidence == CMMotionActivityConfidenceMedium || activity.confidence == CMMotionActivityConfidenceHigh)
                                                                      {
                                                                          totalModerateActivityTime += activityLengthTime;
                                                                      }
                                                                      
                                                                  }
                                                                  else if (lastMotionActivityType == MotionActivityRunning || lastMotionActivityType == MotionActivityCycling)
                                                                  {
                                                                      totalVigorousActivityTime += activityLengthTime;
                                                                  }
                                                              }
                                                                  
                                                              //this will skip the first activity as the lastMotionActivityType will be zero which is not in the enum
                                                              if((lastMotionActivityType == MotionActivityWalking && activity.confidence == CMMotionActivityConfidenceHigh) || (lastMotionActivityType == MotionActivityWalking && activity.confidence == CMMotionActivityConfidenceMedium))
                                                              {
                                                                  //now we need to figure out if its sleep time
                                                                  // anything over 3 hours will be sleep time
                                                                  NSTimeInterval activityLength = 0.0;
                                                                  
                                                                  activityLength = fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                                  
                                                                  if(activity.confidence == CMMotionActivityConfidenceMedium || activity.confidence == CMMotionActivityConfidenceHigh) // 45 seconds
                                                                  {
                                                                      totalModerateTime += fabs(activityLength);
                                                                  }
                                                                
                                                              }
                                                              else if(lastMotionActivityType == MotionActivityWalking && activity.confidence == CMMotionActivityConfidenceLow)
                                                              {
                                                                  totalLightActivityTime += fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                              }
                                                              else if(lastMotionActivityType == MotionActivityRunning)
                                                              {
                                                                  totalRunningTime += fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                              }
                                                              else if(lastMotionActivityType == MotionActivityAutomotive)
                                                              {
                                                                  totalSedentaryTime += fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                              }
                                                              else if(lastMotionActivityType == MotionActivityCycling)
                                                              {
                                                                  totalRunningTime += fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                                 
                                                              }
                                                              else if(lastMotionActivityType == MotionActivityStationary)
                                                              {
                                                                  //now we need to figure out if its sleep time
                                                                  // anything over 3 hours will be sleep time
                                                                  NSTimeInterval activityLength = 0.0;
                                                                  
                                                                  activityLength = fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                                
                                                                  
                                                                  if(activityLength >= 10800) // 3 hours in seconds
                                                                  {
                                                                      totalSleepTime += fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                                      
                                                                  }
                                                                  else
                                                                  {
                                                                      totalSedentaryTime += fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                                     
                                                                  }
                                                                  
                                                              }
                                                              else if(lastMotionActivityType == MotionActivityUnknown)
                                                              {
																  NSTimeInterval lastActivityDuration = fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
																  
                                                                  if (activity.stationary)
                                                                  {
                                                                      totalSedentaryTime += lastActivityDuration;
                                                                      lastActivity_started = activity.startDate;
                                                                  }
                                                                  else if (activity.walking && activity.confidence == CMMotionActivityConfidenceLow)
                                                                  {
                                                                      totalLightActivityTime += lastActivityDuration;
                                                                      lastActivity_started = activity.startDate;
                                                                  }
                                                                  else if (activity.walking)
                                                                  {
																	  totalModerateTime += lastActivityDuration;
                                                                      lastActivity_started = activity.startDate;
                                                                  }
                                                                  else if (activity.running)
                                                                  {
																	  totalRunningTime += lastActivityDuration;
                                                                      lastActivity_started = activity.startDate;
                                                                  }
                                                                  
                                                                  else if (activity.cycling)
                                                                  {
																	  totalRunningTime += lastActivityDuration;
                                                                      lastActivity_started = activity.startDate;
                                                                  }
                                                                  else if (activity.automotive)
                                                                  {
																	  totalSedentaryTime += lastActivityDuration;
                                                                      lastActivity_started = activity.startDate;
                                                                  }
                                                                  
                                                                  totalUnknownTime += fabs([lastActivity_started timeIntervalSinceDate:activity.startDate]);
                                                                  
                                                              }
                                                              
                                                              
                                                              if (activity.stationary)
                                                              {
                                                                  lastMotionActivityType = MotionActivityStationary;
                                                                  lastActivity_started = activity.startDate;
                                                              }
                                                              else if (activity.walking)
                                                              {
                                                                  lastMotionActivityType = MotionActivityWalking;
                                                                  lastActivity_started = activity.startDate;
                                                                  
                                                              }
                                                              else if (activity.running)
                                                              {
                                                                  
                                                                  lastMotionActivityType = MotionActivityRunning;
                                                                  lastActivity_started = activity.startDate;
                                                                  
                                                              }
                                                              else if (activity.automotive)
                                                              {
                                                                  
                                                                  lastMotionActivityType = MotionActivityAutomotive;
                                                                  lastActivity_started = activity.startDate;
                                                              }
                                                              else if (activity.cycling)
                                                              {
                                                                  lastMotionActivityType = MotionActivityCycling;
                                                                  lastActivity_started = activity.startDate;
                                                              }
                                                              else
                                                              {
                                                                  lastMotionActivityType = MotionActivityUnknown;
                                                                  lastActivity_started = activity.startDate;
                                                              }
                                                          }

                                                          
                                                          XZCareMotionHistoryData * motionHistoryVigorous = [XZCareMotionHistoryData new];
                                                          motionHistoryVigorous.activityType = XZCarePatientActivityTypeRunning;
                                                          motionHistoryVigorous.timeInterval = totalRunningTime;
                                                          [motionDayValues addObject:motionHistoryVigorous];
                                                          
                                                          
                                                          
                                                          XZCareMotionHistoryData * motionHistoryDataRunning = [XZCareMotionHistoryData new];
                                                          motionHistoryDataRunning.activityType = XZCarePatientActivityTypeLight;
                                                          motionHistoryDataRunning.timeInterval = totalLightActivityTime;
                                                          [motionDayValues addObject:motionHistoryDataRunning];
                                                          
                                                          XZCareMotionHistoryData * motionHistoryDataSedentary = [XZCareMotionHistoryData new];
                                                          motionHistoryDataSedentary.activityType = XZCarePatientActivityTypeSedentary;
                                                          motionHistoryDataSedentary.timeInterval = totalSedentaryTime;
                                                          [motionDayValues addObject:motionHistoryDataSedentary];
                                                          
                                                          XZCareMotionHistoryData * motionHistoryDataModerate = [XZCareMotionHistoryData new];
                                                          motionHistoryDataModerate.activityType = XZCarePatientActivityTypeModerate;
                                                          motionHistoryDataModerate.timeInterval = totalModerateTime;
                                                          [motionDayValues addObject:motionHistoryDataModerate];
                                                          
                                                          XZCareMotionHistoryData * motionHistoryDataUnknown = [XZCareMotionHistoryData new];
                                                          motionHistoryDataUnknown.activityType = XZCarePatientActivityTypeUnknown;
                                                          motionHistoryDataUnknown.timeInterval = totalUnknownTime;
                                                          [motionDayValues addObject:motionHistoryDataUnknown];
                                                          
                                                          XZCareMotionHistoryData * motionHistoryDataSleeping = [XZCareMotionHistoryData new];
                                                          motionHistoryDataSleeping.activityType = XZCarePatientActivityTypeSleeping;
                                                          motionHistoryDataSleeping.timeInterval = totalSleepTime;
                                                          [motionDayValues addObject:motionHistoryDataSleeping];
                                                          
                                                          XZCareMotionHistoryData * motionHistoryActiveMinutesVigorous = [XZCareMotionHistoryData new];
                                                          motionHistoryActiveMinutesVigorous.activityType = XZCarePatientActivityTypeAutomotive;
                                                          motionHistoryActiveMinutesVigorous.timeInterval = totalVigorousActivityTime;
                                                          [motionDayValues addObject:motionHistoryActiveMinutesVigorous];
                                                          
                                                          XZCareMotionHistoryData * motionHistoryActiveMinutesModerate = [XZCareMotionHistoryData new];
                                                          motionHistoryActiveMinutesModerate.activityType = XZCarePatientActivityTypeCycling;
                                                          motionHistoryActiveMinutesModerate.timeInterval = totalModerateActivityTime;
                                                          [motionDayValues addObject:motionHistoryActiveMinutesModerate];
                                                          
                                                          [motionReport addObject:motionDayValues];
                                                          
                                                          //Different start date and end date
                                                          NSDateComponents *numberOfDaysFromStartDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                                                                                        fromDate:startDate
                                                                                                                                          toDate:[NSDate date]
                                                                                                                                         options:NSCalendarWrapComponents];
                                                          
                                                          //numberOfDaysFromStartDate provides the difference of days from now to start of task and therefore if there is no difference we are only getting data for one day.
                                                          numberOfDaysFromStartDate.day += 1;
                                                          
                                                          NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
                                                          [dateComponent setDay:-1];
                                                          NSDate *newStartDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponent
                                                                                                                               toDate:endDate
                                                                                                                              options:0];
                                                          
                                                         
                                                          [self getMotionCoProcessorDataFrom:newStartDate
                                                                                  andEndDate:endDate
                                                                             andNumberOfDays:numberOfDays - 1];
                                                          
                                        
                                                          
                                                      }
                                                      
                                                      if(numberOfDays == 0)
                                                      {
                                                          isTheDataReady = true;
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:XZCareMotionHistoryReporterDoneNotification object:nil];
                                                      }
    }];
}



-(NSArray*) retrieveMotionReport
{
    //Return the NSMutableArray as an immutable array
    return [motionReport copy];
}

-(BOOL)isDataReady
{
    return isTheDataReady;
}

@end
