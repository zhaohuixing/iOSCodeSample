//
//  APCScoring.m
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
//#import <XZXZCareGraph.h"

static NSInteger const kNumberOfDaysInWeek    = 7;
static NSInteger const kNumberOfDaysInMonth   = 30;
static NSInteger const kNumberOfDaysIn3Months = 90;
//??static NSInteger const kNumberOfDaysIn6Months = 180;
static NSInteger const kNumberOfDaysInYear    = 365;

@interface XZCareScoring()

@property (nonatomic, strong) XZCareScoring *correlatedScoring;
@property (nonatomic, weak) XZCareScoring *weakParentScoring;
@property (nonatomic, strong) NSMutableArray *dataPoints;
@property (nonatomic, strong) NSMutableArray *updatedDataPoints;

@property (nonatomic, strong) NSArray *timeline;

@property (nonatomic) XZCareTimelineGroups groupBy;
@property (nonatomic) NSUInteger current;
@property (nonatomic) NSUInteger correlatedCurrent;
@property (nonatomic) NSInteger numberOfDays;
@property (nonatomic) BOOL usesHealthKitData;
@property (nonatomic) BOOL latestOnly;

@property (nonatomic, strong) NSString *dataKey;
@property (nonatomic, strong) NSString *sortKey;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation XZCareScoring

/*
 * @usage  APHScoring.h should be imported.
 *
 *   There are two ways to get data, Core Data and HealthKit. Each source can
 *
 *   For Core Data:
 *      APHScoring *scoring = [APHScoring alloc] initWithTaskId:taskId numberOfDays:-5 valueKey:@"value";
 *
 *   For HealthKit:
 *      APHScoring *scoring = [APHScoring alloc] initWithHealthKitQuantityType:[HKQuantityType ...] numberOfDays:-5
 *
 *   NSLog(@"Score Min: %f", [[scoring minimumDataPoint] doubleValue]);
 *   NSLog(@"Score Max: %f", [[scoring maximumDataPoint] doubleValue]);
 *   NSLog(@"Score Avg: %f", [[scoring averageDataPoint] doubleValue]);
 *
 *   NSDictionary *score = nil;
 *   while (score = [scoring nextObject]) {
 *       NSLog(@"Score: %f", [[score valueForKey:@"value"] doubleValue]);
 *   }
 */

- (NSMutableArray *)dataPointsArrayForDays:(NSInteger)days groupBy:(NSUInteger)groupBy
{
    _timeline = [self configureTimelineForDays:days groupBy:groupBy];
    
    _numberOfDays = days;
    NSMutableArray *dataPoints = [NSMutableArray new];
    
    for (NSDate *day in self.timeline)
    {
        NSDate *timelineDay = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                       minute:0
                                                                       second:0
                                                                       ofDate:day
                                                                      options:0];
        
        
        [dataPoints addObject:[self generateDataPointForDate:timelineDay
                                                   withValue:@(NSNotFound)
                                                 noDataValue:YES]];
    }
    
    return dataPoints;
}


- (HKHealthStore *)healthStore
{
    return ((XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate).dataSubstrate.healthStore;
}

/**
 * @brief   Returns an instance of APHScoring.
 *
 * @param   taskId          The ID of the task whose data needs to be displayed
 *
 * @param   numberOfDays    Number of days that the data is needed. Negative will produce data
 *                          from past and positive will yeild future days.
 *
 * @param   valueKey        The key that is used for storing data
 *
 */

- (instancetype)initWithTask:(NSString *)taskId numberOfDays:(NSInteger)numberOfDays valueKey:(NSString *)valueKey latestOnly:(BOOL)latestOnly
{
    self = [self initWithTask:taskId
                 numberOfDays:numberOfDays
                     valueKey:valueKey
                      dataKey:nil
                      sortKey:nil
                   latestOnly:latestOnly
                      groupBy:XZCareTimelineGroupDay];
    return self;
}

- (instancetype)initWithTask:(NSString *)taskId numberOfDays:(NSInteger)numberOfDays valueKey:(NSString *)valueKey
{
    self = [self initWithTask:taskId numberOfDays:numberOfDays valueKey:valueKey dataKey:nil sortKey:nil groupBy:XZCareTimelineGroupDay];
    
    return self;
}

- (instancetype)initWithTask:(NSString *)taskId numberOfDays:(NSInteger)numberOfDays valueKey:(NSString *)valueKey dataKey:(NSString *)dataKey
{
    self = [self initWithTask:taskId numberOfDays:numberOfDays valueKey:valueKey dataKey:dataKey sortKey:nil groupBy:XZCareTimelineGroupDay];
    
    return self;
}

- (instancetype)initWithTask:(NSString *)taskId
                numberOfDays:(NSInteger)numberOfDays
                    valueKey:(NSString *)valueKey
                     dataKey:(NSString *)dataKey
                     sortKey:(NSString *)sortKey
{
    self = [self initWithTask:taskId
                 numberOfDays:numberOfDays
                     valueKey:valueKey
                      dataKey:dataKey
                      sortKey:sortKey
                   latestOnly:YES
                      groupBy:XZCareTimelineGroupDay];
    
    return self;
}

- (instancetype)initWithTask:(NSString *)taskId
                numberOfDays:(NSInteger)numberOfDays
                    valueKey:(NSString *)valueKey
                     dataKey:(NSString *)dataKey
                     sortKey:(NSString *)sortKey
                     groupBy:(XZCareTimelineGroups)groupBy
{
    self = [self initWithTask:taskId
                 numberOfDays:numberOfDays
                     valueKey:valueKey
                      dataKey:dataKey
                      sortKey:sortKey
                   latestOnly:YES
                      groupBy:groupBy];
    return self;
}

/**
 @brief Designated Initializer for Task data source
 */
- (instancetype)initWithTask:(NSString *)taskId
                numberOfDays:(NSInteger)numberOfDays
                    valueKey:(NSString *)valueKey
                     dataKey:(NSString *)dataKey
                     sortKey:(NSString *)sortKey
                  latestOnly:(BOOL)latestOnly
                     groupBy:(XZCareTimelineGroups)groupBy
{
    self = [super init];
    
    if (self)
    {
        _dataPoints = [NSMutableArray array];
        _updatedDataPoints = [NSMutableArray array];
        _numberOfDays = numberOfDays;
        _groupBy = groupBy;
        _usesHealthKitData = NO;
        _quantityType = nil;
        _unit = nil;
        self.customMaximumPoint = CGFLOAT_MAX;
        self.customMinimumPoint = CGFLOAT_MIN;
        _latestOnly = latestOnly;
        
        self.taskId = taskId;
        self.valueKey = valueKey;
        _dataKey = dataKey;
        _sortKey = sortKey;
        
        if (!self.dateFormatter)
        {
            self.dateFormatter = [[NSDateFormatter alloc] init];
            [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        }
        
        self.dataPoints = [self dataPointsArrayForDays:_numberOfDays groupBy:_groupBy];
        
        [self queryTaskId:taskId
                  forDays:numberOfDays
                 valueKey:valueKey
                  dataKey:dataKey
                  sortKey:sortKey
               latestOnly:latestOnly
                  groupBy:groupBy
               completion:nil];
    }
    
    return self;
}

/**
 * @brief   Returns an instance of APHScoring.
 *
 * @param   quantityType    The HealthKit quantity type.
 *
 * @param   unit            The unit that is compatible with the the quantity type that is provided.
 *
 * @param   numberOfDays    Number of days that the data is needed. Negative will produce data
 *                          from past and positive will yeild future days.
 *
 */
- (instancetype)initWithHealthKitQuantityType:(HKQuantityType *)quantityType
                                         unit:(HKUnit *)unit
                                 numberOfDays:(NSInteger)numberOfDays
{
    self = [self initWithHealthKitQuantityType:quantityType
                                          unit:unit
                                  numberOfDays:numberOfDays
                                       groupBy:XZCareTimelineGroupDay];
    return self;
}

/**
 @brief Designated Initializer for Health Kit data source
 */
- (instancetype)initWithHealthKitQuantityType:(HKQuantityType *)quantityType
                                         unit:(HKUnit *)unit
                                 numberOfDays:(NSInteger)numberOfDays
                                      groupBy:(XZCareTimelineGroups) groupBy
{
    self = [super init];
    
    if (self)
    {
        _dataPoints = [NSMutableArray array];
        _updatedDataPoints = [NSMutableArray array];
        _numberOfDays = numberOfDays;
        _groupBy = groupBy;
        _usesHealthKitData = YES;
        _quantityType = nil;
        _unit = nil;
        self.customMaximumPoint = CGFLOAT_MAX;
        self.customMinimumPoint = CGFLOAT_MIN;
        
        if (!self.dateFormatter)
        {
            self.dateFormatter = [[NSDateFormatter alloc] init];
            [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        }
        
        self.dataPoints = [self dataPointsArrayForDays:_numberOfDays groupBy:_groupBy];
        
        // The very first thing that we need to make sure is that the unit and quantity types are compatible
        if ([quantityType isCompatibleWithUnit:unit])
        {
            _quantityType = quantityType;
            _unit = unit;
            [self statsCollectionQueryForQuantityType:quantityType unit:unit forDays:numberOfDays];
        }
        else
        {
            NSAssert([quantityType isCompatibleWithUnit:unit], @"The quantity and the unit must be compatible");
        }
    }
    
    return self;
}

- (void)updatePeriodForDays:(NSInteger)numberOfDays
                    groupBy:(XZCareTimelineGroups)groupBy
{
    _groupBy = groupBy;
    _numberOfDays = numberOfDays;
    
    __weak typeof(self) weakSelf = self;
    
    // Update the generated dataset to be inline with the timeline.
    self.dataPoints = [self dataPointsArrayForDays:_numberOfDays groupBy:_groupBy];
    
    if (self.usesHealthKitData)
    {
        if ([self.quantityType isCompatibleWithUnit:self.unit])
        {
            [self updateStatsCollectionForQuantityType:self.quantityType
                                                  unit:self.unit
                                               forDays:numberOfDays
                                               groupBy:groupBy
                                            completion:^{
                                                [weakSelf updateCharts];
                                            }];
        }
        else
        {
            NSAssert([self.quantityType isCompatibleWithUnit:self.unit], @"The quantity and the unit must be compatible");
        }
    }
    else
    {
        
        [self queryTaskId:self.taskId
                  forDays:numberOfDays
                 valueKey:self.valueKey
                  dataKey:self.dataKey
                  sortKey:self.sortKey
               latestOnly:self.latestOnly
                  groupBy:groupBy
               completion:^{
                   [weakSelf updateCharts];
               }];
    }
    
    //update the correlatedScoring object
    if (self.correlatedScoring)
    {
        [self.correlatedScoring updatePeriodForDays:numberOfDays groupBy:groupBy];
    }
    
}

//should only be called by parent self of correlated data source
- (void)correlateDataSources
{
    //move dataPoints into correlateDataPoints
    [self discardIncongruentArrayElements];
    
    //index the arrays
    [self indexDataSeries:self.dataPoints];
    [self indexDataSeries:self.correlatedScoring.dataPoints];
}

//Called when user selects a new date range
- (void)updateCharts
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.correlatedScoring)
        {
            [self correlateDataSources];
        }
        else if (self.weakParentScoring)
        {
            [self.weakParentScoring correlateDataSources];
        }
        
        //tell the APCGraphViewController to update its chart
        if ([self.scoringDelegate respondsToSelector:@selector(graphViewControllerShouldUpdateChartWithScoring:)])
        {
            [self.scoringDelegate graphViewControllerShouldUpdateChartWithScoring:self];
        }
    });
}

#pragma mark - Correlations

/**
 @brief Add a series to correlate with an initialized APCScoring object's TaskId data series
 */
- (void)correlateWithScoringObject:(XZCareScoring *)scoring
{
    self.correlatedScoring = scoring;
    self.correlatedScoring.weakParentScoring = self;
    [self correlateDataSources];
}

- (void)discardIncongruentArrayElements
{
    //arrays are NOT guaranteed to be the same length if queried with the same date range when one or more series is data from HealthKit
    
    //find the shortest array and difference in their counts
    NSMutableArray *shortestArray = self.dataPoints.count <= self.correlatedScoring.dataPoints.count ? self.dataPoints : self.correlatedScoring.dataPoints;
    NSMutableArray *longestArray = self.dataPoints.count >= self.correlatedScoring.dataPoints.count ? self.dataPoints : self.correlatedScoring.dataPoints;
    
    //add this number of dictionaries to the front of the shortest array
    NSUInteger elementsVariance = longestArray.count - shortestArray.count;
    
    for (NSUInteger i = 0; i < elementsVariance; i++)
    {
        NSDictionary *dataPoint = [longestArray objectAtIndex:i];
        NSDate *pointDate = [dataPoint objectForKey:kDatasetDateKey];
        NSDictionary *dataPointsDictionary = [self generateDataPointForDate:pointDate
                                                                  withValue:@(NSNotFound)
                                                                noDataValue:YES];
        
        [shortestArray insertObject:dataPointsDictionary atIndex:i];
    }
    
    //check they are now even
    NSAssert(self.dataPoints.count == self.correlatedScoring.dataPoints.count, @"Arrays are not of equal length. dataPoints.count = %li, correlatedScoring.dataPoints.count = %li", (unsigned long)self.dataPoints.count, (unsigned long)self.correlatedScoring.dataPoints.count);
    
    //Arrays are not guaranteed to have non-NSNotFound data beginning at the same index
    NSUInteger dataPointsIndex = [self.dataPoints indexOfObjectPassingTest:^BOOL(id obj, NSUInteger __unused idx, BOOL *stop) {
        
        if (![[(NSDictionary *)obj objectForKey:kDatasetValueKey] isEqualToNumber: @(NSNotFound)])
        {
            *stop = YES;
            return YES;
        }
        else
        {
            return NO;
        }
    }];
    
    NSUInteger correlatedDataPointsIndex = [self.correlatedScoring.dataPoints indexOfObjectPassingTest:^BOOL(id obj, NSUInteger __unused idx, BOOL *stop) {
        if (![[(NSDictionary *)obj objectForKey:kDatasetValueKey] isEqualToNumber: @(NSNotFound)])
        {
            *stop = YES;
            return YES;
        }
        else
        {
            return NO;
        }
    }];
    
    NSUInteger highestIndex = 0;
    if (dataPointsIndex >= correlatedDataPointsIndex)
    {
        highestIndex = dataPointsIndex;
    }
    else if(correlatedDataPointsIndex > dataPointsIndex)
    {
        highestIndex = correlatedDataPointsIndex;
    }
    
    if (correlatedDataPointsIndex != NSNotFound && dataPointsIndex != NSNotFound && self.dataPoints.count == self.correlatedScoring.dataPoints.count)
    {
        for (NSUInteger i = 0; i < highestIndex; i++)
        {
            NSMutableDictionary *dataPointDictionary = [[self.dataPoints objectAtIndex:i] mutableCopy];
            [dataPointDictionary setObject:@(NSNotFound) forKey:kDatasetValueKey];
            [self.dataPoints replaceObjectAtIndex:i withObject:dataPointDictionary];
            
            NSMutableDictionary *correlatedDataPointDictionary =[[self.correlatedScoring.dataPoints objectAtIndex:i] mutableCopy];
            [correlatedDataPointDictionary setObject:@(NSNotFound) forKey:kDatasetValueKey];
            [self.correlatedScoring.dataPoints replaceObjectAtIndex:i withObject:correlatedDataPointDictionary];
        }
    }
}

- (void)indexDataSeries:(NSMutableArray *)series
{
    
    NSDictionary *basePointObject;
    NSNumber *basePointValue = @0;
    
    //find the earliest base point value
    for (int i = (int)series.count -1; i >= 0; i--)
    {
        basePointObject = series[i];
        NSNumber *checkBasePointValue = [basePointObject valueForKey:kDatasetValueKey];
        if (![checkBasePointValue  isEqual: @(NSNotFound)])
        {
            basePointValue = checkBasePointValue;
        }
    }
    
    //loop over all elements calculating the point index
    NSNumber *index;
    for (NSUInteger i = 0; i < series.count; i++)
    {
        NSNumber *dataPoint = [(NSDictionary *)[series objectAtIndex:i] valueForKey:kDatasetValueKey];
        float ind = dataPoint.floatValue / basePointValue.floatValue * 100;
        index = [NSNumber numberWithFloat:ind];
        
        if (![dataPoint isEqual: @(NSNotFound)])
        {
            NSMutableDictionary *dictionary = [[series objectAtIndex:i] mutableCopy];
            [dictionary setValue:index forKey:kDatasetValueKey];
            XZCareRangePoint *point = [[XZCareRangePoint alloc]initWithMinimumValue:ind maximumValue:ind];
            [dictionary setValue:point forKey:kDatasetRangeValueKey];
            [series replaceObjectAtIndex:i withObject:dictionary];
        }
    }
}

//Notification added in correlateWithScoringObject()
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Helpers

- (NSArray *)configureTimelineForDays:(NSInteger)days
{
    NSMutableArray *timeline = [NSMutableArray array];
    
    for (NSInteger day = days; day <= 0; day++)
    {
        NSDate *timelineDate = [[self dateForSpan:day] startOfDay];
        [timeline addObject:timelineDate];
    }
    
    return timeline;
}

- (NSArray *)configureTimelineForDays:(NSInteger)days groupBy:(NSUInteger)groupBy
{
    NSMutableArray *timeline = [NSMutableArray array];
    
    if (groupBy == XZCareTimelineGroupDay)
    {
        for (NSInteger day = days; day <= 0; day++)
        {
            NSDate *timelineDate = [[self dateForSpan:day] startOfDay];
            [timeline addObject:timelineDate];
        }
    }
    else if (groupBy == XZCareTimelineGroupWeek)
    {
        for (NSInteger day = days; day <= 0; day += kNumberOfDaysInWeek)
        {
            NSDate *timelineDate = [[self dateForSpan:day] startOfDay];
            [timeline addObject:timelineDate];
        }
    }
    else if (groupBy == XZCareTimelineGroupMonth) {
        for (NSInteger day = days; day <= 0; day += kNumberOfDaysInMonth)
        {
            NSDate *timelineDate = [[self dateForSpan:day] startOfDay];
            [timeline addObject:timelineDate];
        }
    }
    else
    {
        for (NSInteger day = days; day <= 0; day += kNumberOfDaysInYear)
        {
            NSDate *timelineDate = [[self dateForSpan:day] startOfDay];
            [timeline addObject:timelineDate];
        }
    }
    
    return timeline;
}

- (NSDictionary *)generateDataPointForDate:(NSDate *)pointDate
                                 withValue:(NSNumber *)pointValue
                               noDataValue:(BOOL)noDataValue
{
    NSInteger weekNumber  = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:pointDate] weekOfYear];
    NSInteger monthNumber = [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:pointDate] month];
    NSInteger yearNumber  = [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:pointDate] year];
    
    return @{
             kDatasetDateKey: pointDate,
             kDatasetValueKey: pointValue,
             kDatasetValueNoDataKey: @(noDataValue),
             kDatasetGroupByDay: pointDate,
             kDatasetGroupByWeek: @(weekNumber),
             kDatasetGroupByMonth: @(monthNumber),
             kDatasetGroupByYear: @(yearNumber)
             };
}

- (void)addDataPointToTimeline:(NSDictionary *)dataPoint
{
    if ([dataPoint[kDatasetValueKey] integerValue] != 0) {
        NSDate *pointDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                     minute:0
                                                                     second:0
                                                                     ofDate:[dataPoint valueForKey:kDatasetDateKey]
                                                                    options:0];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", kDatasetDateKey, pointDate];
        NSArray *matches = [self.dataPoints filteredArrayUsingPredicate:predicate];
        
        if ([matches count] > 0)
        {
            NSUInteger pointIndex = [self.dataPoints indexOfObject:[matches firstObject]];
            NSMutableDictionary *point = [[self.dataPoints objectAtIndex:pointIndex] mutableCopy];
            
            point[kDatasetValueKey] = dataPoint[kDatasetValueKey];
            point[kDatasetValueNoDataKey] = dataPoint[kDatasetValueNoDataKey];
            
            if (dataPoint[kDatasetRangeValueKey])
            {
                point[kDatasetRangeValueKey] = dataPoint[kDatasetRangeValueKey];
            }
            
            [self.dataPoints replaceObjectAtIndex:pointIndex withObject:point];
        }
    }
}

#pragma mark - Queries
#pragma mark Core Data

- (void)queryTaskId:(NSString *)taskId
            forDays:(NSInteger)days
           valueKey:(NSString *)valueKey
            dataKey:(NSString *)dataKey
            sortKey:(NSString *)sortKey
         latestOnly:(BOOL)latestOnly
            groupBy:(XZCareTimelineGroups)groupBy
         completion:(void (^)(void))completion
{
    XZCareCoreAppDelegate *appDelegate = (XZCareCoreAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startOn"
                                                                   ascending:YES];
    
    NSFetchRequest *request = [XZCareCoreDBScheduledTask request];
    
    NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                 minute:0
                                                                 second:0
                                                                 ofDate:[self dateForSpan:days]
                                                                options:0];
    
    NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                               minute:59
                                                               second:59
                                                               ofDate:[NSDate date]
                                                              options:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(task.taskID == %@) AND (startOn >= %@) AND (startOn <= %@)",
                              taskId, startDate, endDate];
    
    request.predicate = predicate;
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    
    NSManagedObjectContext * localContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    localContext.parentContext = appDelegate.dataSubstrate.persistentContext;
    
    NSArray *tasks = [localContext executeFetchRequest:request error:&error];
    
    for (XZCareCoreDBScheduledTask *task in tasks)
    {
        if ([task.completed boolValue])
        {
            NSArray *taskResults = [self retrieveResultSummaryFromResults:task.results latestOnly:latestOnly];
            
            for (NSDictionary *taskResult in taskResults)
            {
                if (taskResult)
                {
                    NSDate *pointDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                                 minute:0
                                                                                 second:0
                                                                                 ofDate:task.startOn
                                                                                options:0];
                    
                    id taskResultValue = [taskResult valueForKey:valueKey];
                    NSNumber *taskValue = nil;
                    
                    if ([taskResultValue isKindOfClass:[NSNull class]] || !taskResultValue)
                    {
                        taskValue = @(NSNotFound);
                    }
                    else
                    {
                        taskValue = (NSNumber *)taskResultValue;
                    }
                    
                    NSMutableDictionary *dataPoint = nil;
                    
                    if (groupBy == XZCareTimelineGroupForInsights)
                    {
                        dataPoint = [[self generateDataPointForDate:task.createdAt
                                                          withValue:taskValue
                                                        noDataValue:YES] mutableCopy];
                        dataPoint[kDatasetRawDataKey] = taskResult;
                    }
                    else
                    {
                        if (!dataKey)
                        {
                            dataPoint = [[self generateDataPointForDate:pointDate
                                                              withValue:taskValue
                                                            noDataValue:YES] mutableCopy];
                            dataPoint[kDatasetSortKey] = (sortKey) ? [taskResult valueForKey:sortKey] : [NSNull null];
                            
                        }
                        else
                        {
                            NSDictionary *nestedData = [taskResult valueForKey:dataKey];
                            
                            if (nestedData)
                            {
                                dataPoint = [[self generateDataPointForDate:pointDate
                                                                  withValue:taskValue
                                                                noDataValue:YES] mutableCopy];
                                dataPoint[kDatasetSortKey] = (sortKey) ? [taskResult valueForKey:sortKey] : [NSNull null];
                            }
                        }
                    }
                    [self.dataPoints addObject:dataPoint];
                }
            }
        }
    }
    
    if ([self.dataPoints count] != 0)
    {
        if (sortKey) {
            NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:kDatasetSortKey ascending:YES];
            NSArray *sortedDataPoints = [self.dataPoints sortedArrayUsingDescriptors:@[sortBy]];
            
            self.dataPoints = [sortedDataPoints mutableCopy];
        }
        
        [self groupByPeriod:groupBy];
    }
    
    if (completion)
    {
        completion();
    }
}

- (NSArray *)retrieveResultSummaryFromResults:(NSSet *)results latestOnly:(BOOL)latestOnly
{
    NSArray *scheduledTaskResults = [results allObjects];
    
    // sort the results in a decsending order,
    // in case there are more than one result for a meal time.
    NSSortDescriptor *sortByCreateAtDescending = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                                             ascending:NO];
    
    NSArray *sortedScheduleTaskresults = [scheduledTaskResults sortedArrayUsingDescriptors:@[sortByCreateAtDescending]];
    
    // We are iterating throught the results because:
    // a.) There could be more than one result
    // b.) In case the last result is nil, we will pick the next result that has a value.
    NSMutableArray *allResultSummaries = [NSMutableArray new];
    
    for (XZCareCoreDBResult *pResult in sortedScheduleTaskresults)
    {
        NSString *resultSummary = [pResult resultSummary];

#ifdef DEBUG
        NSLog(@"XZCareScoring retrieveResultSummaryFromResults query result\n");
        [pResult DebugLog];
#endif
        if (resultSummary)
        {
            NSData *resultData = [resultSummary dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:resultData
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&error];
            
            [allResultSummaries addObject:result];
#ifdef DEBUG
            NSLog(@"XZCareScoring retrieveResultSummaryFromResults query dictionalry:\n%@\n", [result description]);
#endif
            if (latestOnly)
            {
                break;
            }
        }
    }
    
    return allResultSummaries;
}

- (void)groupByPeriod:(XZCareTimelineGroups)period
{
    NSString *periodKeyPath = nil;
    
    switch (period)
    {
        case XZCareTimelineGroupWeek:
            periodKeyPath = kDatasetGroupByWeek;
            break;
        case XZCareTimelineGroupMonth:
            periodKeyPath = kDatasetGroupByMonth;
            break;
        case XZCareTimelineGroupYear:
            periodKeyPath = kDatasetGroupByYear;
            break;
        default:
            periodKeyPath = kDatasetGroupByDay;
            break;
    }
    
    // Group the dataset based on the provided period.
    NSDictionary *groupedDataset = [self groupByKeyPath:periodKeyPath dataset:self.dataPoints];
    
    // Summarize data for each group.
    NSDictionary *summarizedDataset = [self summarizeDataset:groupedDataset period:period];
    NSArray *sortedSummaryKeys = [summarizedDataset.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *sortedSummarizedDataset = [NSMutableArray new];
    
    for (id key in sortedSummaryKeys)
    {
        [sortedSummarizedDataset addObjectsFromArray:summarizedDataset[key]];
    }
    
    [self.dataPoints removeAllObjects];
    [self.dataPoints addObjectsFromArray:sortedSummarizedDataset];
}

- (NSDictionary *)summarizeDataset:(NSDictionary *)dataset period:(XZCareTimelineGroups)period
{
    NSMutableDictionary *summarizedDataset = [NSMutableDictionary new];
    NSArray *keys = [dataset allKeys];
    
    for (id key in keys)
    {
        NSArray *elements = dataset[key];
        NSDictionary *rawData = nil;
        
        if (period == XZCareTimelineGroupForInsights)
        {
            // The elements array is sorted in ansending order,
            // therefore the last object will be the latest data point.
            NSDictionary *latestElement = [elements lastObject];
            rawData = latestElement[kDatasetRawDataKey];
        }
        
        // Exclude data points with NSNotFound
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K <> %@)", kDatasetValueKey, @(NSNotFound)];
        NSArray *filteredDataPoints = [elements filteredArrayUsingPredicate:predicate];
        
        double itemSum = 0;
        double dayAverage = 0;
        
        for (NSDictionary *dataPoint in filteredDataPoints)
        {
            NSNumber *value = [dataPoint valueForKey:kDatasetValueKey];
            
            if ([value integerValue] != NSNotFound)
            {
                itemSum += [value doubleValue];
            }
        }
        
        if (filteredDataPoints.count != 0)
        {
            dayAverage = itemSum / filteredDataPoints.count;
        }
        
        if (dayAverage == 0)
        {
            dayAverage = NSNotFound;
        }
        
        XZCareRangePoint *rangePoint = [XZCareRangePoint new];
        
        if (dayAverage != NSNotFound)
        {
            NSNumber *minValue = [filteredDataPoints valueForKeyPath:@"@min.datasetValueKey"];
            NSNumber *maxValue = [filteredDataPoints valueForKeyPath:@"@max.datasetValueKey"];
            
            rangePoint.minimumValue = [minValue floatValue];
            rangePoint.maximumValue = [maxValue floatValue];
        }
        
        NSMutableDictionary *entry = [[self generateDataPointForDate:key withValue:@(dayAverage) noDataValue:YES] mutableCopy];
        entry[kDatasetRangeValueKey] = rangePoint;
        
        if (rawData)
        {
            entry[kDatasetRawDataKey] = rawData;
        }
        
        summarizedDataset[key] = @[entry];
    }
    
    return summarizedDataset;
}

- (NSDictionary *)groupByKeyPath:(NSString *)key dataset:(NSArray *)dataset
{
    NSMutableDictionary *groups = [NSMutableDictionary new];
    //I'm not quite sure I follow why we're using integer values for specific keypaths for this, when we could much more easily use the timestamp on the object (which I hope exists) directly. Was this an attempt at a performance fix?
    
    for (id object in dataset)
    {
        id value = [object valueForKeyPath:key];
        NSInteger yearNumber = [object[kDatasetGroupByYear] integerValue];
        NSDateComponents *components = nil;
        
        if ([key isEqualToString:kDatasetGroupByMonth])
        {
            components = [[NSDateComponents alloc] init];
            components.weekday = 1;
            components.month = [value integerValue];
            components.year = yearNumber;
        }
        else if ([key isEqualToString:kDatasetGroupByYear])
        {
            components = [[NSDateComponents alloc] init];
            components.weekday = 1;
            components.year = [value integerValue];
        }
        else if ([key isEqualToString:kDatasetGroupByWeek])
        {
            components = [[NSDateComponents alloc] init];
            components.weekday = 1;
            components.weekOfYear = [value integerValue];
            components.year = yearNumber;
        }
        else
        {
            // Group by day
            components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear)
                                                         fromDate:(NSDate *)value];
        }
        
        NSDate *pointDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        if (groups[pointDate] == nil)
        {
            groups[pointDate] = [NSMutableArray new];
        }
        
        [(NSMutableArray *)groups[pointDate] addObject:object];
        
    }
    
    return groups;
}


#pragma mark HealthKit

- (void)statsCollectionQueryForQuantityType:(HKQuantityType *)quantityType
                                       unit:(HKUnit *)unit
                                    forDays:(NSInteger)days
{
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    
    NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                 minute:0
                                                                 second:0
                                                                 ofDate:[self dateForSpan:days]
                                                                options:0];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:[NSDate date] options:HKQueryOptionStrictEndDate];
    
    BOOL isDecreteQuantity = ([quantityType aggregationStyle] == HKQuantityAggregationStyleDiscrete);
    
    HKStatisticsOptions queryOptions;
    
    if (isDecreteQuantity)
    {
        queryOptions = HKStatisticsOptionDiscreteAverage | HKStatisticsOptionDiscreteMax | HKStatisticsOptionDiscreteMin;
    }
    else
    {
        queryOptions = HKStatisticsOptionCumulativeSum;
    }
    
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                           quantitySamplePredicate:predicate
                                                                                           options:queryOptions
                                                                                        anchorDate:startDate
                                                                                intervalComponents:interval];
    
    // set the results handler
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery * __unused query,
                                    HKStatisticsCollection *results,
                                    NSError *error) {
        if (!error)
        {
            NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                       minute:59
                                                                       second:59
                                                                       ofDate:[NSDate date]
                                                                      options:0];
            NSDate *beginDate = startDate;
            
            [results enumerateStatisticsFromDate:beginDate
                                          toDate:endDate
                                       withBlock:^(HKStatistics *result, BOOL * __unused stop) {
                                           HKQuantity *quantity;
                                           NSMutableDictionary *dataPoint = [NSMutableDictionary new];
                                           XZCareRangePoint *rangePoint = [XZCareRangePoint new];
                                           
                                           if (isDecreteQuantity)
                                           {
                                               quantity = result.averageQuantity;
                                               
                                               if (result.minimumQuantity)
                                               {
                                                   rangePoint.minimumValue = [result.minimumQuantity doubleValueForUnit:unit];
                                               }
                                               
                                               if (result.maximumQuantity)
                                               {
                                                   rangePoint.maximumValue = [result.maximumQuantity doubleValueForUnit:unit];
                                               }
                                               
                                               dataPoint[kDatasetRangeValueKey] = rangePoint;
                                           }
                                           else
                                           {
                                               quantity = result.sumQuantity;
                                           }
                                           
                                           NSDate *date = result.startDate;
                                           double value = [quantity doubleValueForUnit:unit];
                                           
                                           dataPoint[kDatasetDateKey] = date;
                                           dataPoint[kDatasetValueKey] = (!quantity) ? @(NSNotFound) : @(value);
                                           dataPoint[kDatasetValueNoDataKey] = (isDecreteQuantity) ? @(YES) : @(NO);
                                           
                                           [self addDataPointToTimeline:dataPoint];
                                       }];
            
            [self dataIsAvailableFromHealthKit];
        }
    };
    
    [self.healthStore executeQuery:query];
}

- (void)updateStatsCollectionForQuantityType:(HKQuantityType *)quantityType
                                        unit:(HKUnit *)unit
                                     forDays:(NSInteger)days
                                     groupBy:(XZCareTimelineGroups)groupBy
                                  completion:(void (^)(void)) completion
{
    [self.updatedDataPoints removeAllObjects];
    
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    
    // 5D, 1W, 1M, 3M, 6M, 1Y
    if (groupBy == XZCareTimelineGroupDay)
    {
        interval.day = 1;
    }
    else if (groupBy == XZCareTimelineGroupWeek)
    {
        interval.day = 7;
    } else if (groupBy == XZCareTimelineGroupMonth)
    {
        interval.month = 1;
    }
    else
    {
        interval.year = 1;
    }
    
    NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                 minute:0
                                                                 second:0
                                                                 ofDate:[self dateForSpan:days]
                                                                options:0];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:[NSDate date] options:HKQueryOptionStrictEndDate];
    
    BOOL isDecreteQuantity = ([quantityType aggregationStyle] == HKQuantityAggregationStyleDiscrete);
    
    HKStatisticsOptions queryOptions;
    
    if (isDecreteQuantity)
    {
        queryOptions = HKStatisticsOptionDiscreteAverage;
    }
    else
    {
        queryOptions = HKStatisticsOptionCumulativeSum;
    }
    
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                           quantitySamplePredicate:predicate
                                                                                           options:queryOptions
                                                                                        anchorDate:startDate
                                                                                intervalComponents:interval];
    
    // set the results handler
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery * __unused query, HKStatisticsCollection *results, NSError *error) {
        if (!error)
        {
            NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                       minute:59
                                                                       second:59
                                                                       ofDate:[NSDate date]
                                                                      options:0];
            NSDate *beginDate = startDate;
            
            [results enumerateStatisticsFromDate:beginDate
                                          toDate:endDate
                                       withBlock:^(HKStatistics *result, BOOL * __unused stop) {
                                           HKQuantity *quantity;
                                           
                                           if (isDecreteQuantity)
                                           {
                                               quantity = result.averageQuantity;
                                           }
                                           else
                                           {
                                               quantity = result.sumQuantity;
                                           }
                                           
                                           NSDate *date = result.startDate;
                                           double value = [quantity doubleValueForUnit:unit];
                                           
                                           NSDictionary *dataPoint = @{
                                                                       kDatasetDateKey: date,
                                                                       kDatasetValueKey: (!quantity) ? @(NSNotFound) : @(value),
                                                                       kDatasetValueNoDataKey: (isDecreteQuantity) ? @(YES) : @(NO)
                                                                       };
                                           
                                           [self.updatedDataPoints addObject:dataPoint];
                                       }];
            
            [self.dataPoints removeAllObjects];
            
            // Redo the timeline
            NSMutableArray *updatedTimeline = [NSMutableArray new];
            
            for (NSDictionary *point in self.updatedDataPoints)
            {
                [updatedTimeline addObject:[point valueForKey:kDatasetDateKey]];
            }
            
            self.timeline = updatedTimeline;
            [self.dataPoints addObjectsFromArray:self.updatedDataPoints];
            
            [self dataIsAvailableFromHealthKit];
            
            if (completion)
            {
                completion();
            }
        }
    };
    
    [self.healthStore executeQuery:query];
}

- (void)dataIsAvailableFromHealthKit
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:XZCareScoringHealthKitDataIsAvailableNotification
                                                            object:nil];
    });
}

/**
 * @brief   Returns an NSDate that is past/future by the value of daySpan.
 *
 * @param   daySpan Number of days relative to current date.
 *                  If negative, date will be number of days in the past;
 *                  otherwise the date will be number of days in the future.
 *
 * @return  Returns the date as NSDate.
 */
- (NSDate *)dateForSpan:(NSInteger)daySpan
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:daySpan];
    
    NSDate *spanDate = [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                                     toDate:[NSDate date]
                                                                    options:0];
    return spanDate;
}

#pragma mark - Min/Max/Avg

- (NSNumber *)minimumDataPointInSeries:(NSArray *)series
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K <> %@", kDatasetValueKey, @(NSNotFound)];
    NSArray *filteredArray = [series filteredArrayUsingPredicate:predicate];
    
    NSArray *rangeArray = [filteredArray valueForKey:kDatasetRangeValueKey];
    NSPredicate *rangePredicate = [NSPredicate predicateWithFormat:@"SELF <> %@", [NSNull null]];
    
    NSArray *rangePoints = [rangeArray filteredArrayUsingPredicate:rangePredicate];
    
    NSNumber *minValue = nil;
    
    if (rangePoints.count != 0)
    {
        minValue = [rangeArray valueForKeyPath:@"@min.minimumValue"];
    }
    else
    {
        minValue = [filteredArray valueForKeyPath:@"@min.datasetValueKey"];
    }
    
    return minValue ? minValue : @0;
}

- (NSNumber *)minimumDataPoint
{
    NSNumber *minDataPoint = [self minimumDataPointInSeries:self.dataPoints];
    NSNumber *minCorrelatedDataPoint = [self minimumDataPointInSeries:self.correlatedScoring.dataPoints];
    NSNumber *min;
    
    if (!self.correlatedScoring ||
        [minDataPoint compare:minCorrelatedDataPoint] == NSOrderedAscending ||
        [minDataPoint compare:minCorrelatedDataPoint] == NSOrderedSame)
    {
        min = minDataPoint;
    }
    else
    {
        min = minCorrelatedDataPoint;
    }
    
    return min;
}

- (NSNumber *)maximumDataPointInSeries:(NSArray *)series
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K <> %@", kDatasetValueKey, @(NSNotFound)];
    
    NSArray *filteredArray = [series filteredArrayUsingPredicate:predicate];
    NSArray *rangeArray = [filteredArray valueForKey:kDatasetRangeValueKey];
    NSPredicate *rangePredicate = [NSPredicate predicateWithFormat:@"SELF <> %@", [NSNull null]];
    
    NSArray *rangePoints = [rangeArray filteredArrayUsingPredicate:rangePredicate];
    
    NSNumber *maxValue = @0;
    
    if (rangePoints.count != 0)
    {
        maxValue = [rangeArray valueForKeyPath:@"@max.maximumValue"];
    }
    else
    {
        maxValue = [filteredArray valueForKeyPath:@"@max.datasetValueKey"];
    }
    
    return maxValue ? maxValue : @0;;
}

- (NSNumber *)maximumDataPoint
{
    NSNumber *maxDataPoint = [self maximumDataPointInSeries:self.dataPoints];
    NSNumber *maxCorrelatedDataPoint = [self maximumDataPointInSeries:self.correlatedScoring.dataPoints];
    NSNumber *max = [NSNumber new];
    
    if ([maxDataPoint compare:maxCorrelatedDataPoint] == NSOrderedAscending || [maxDataPoint compare:maxCorrelatedDataPoint] == NSOrderedSame)
    {
        max = maxCorrelatedDataPoint;
    }
    else
    {
        max = maxDataPoint;
    }
    
    return max;
}

- (NSNumber *)averageDataPoint
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K <> %@", kDatasetValueKey, @(NSNotFound)];
    NSArray *filteredArray = [self.dataPoints filteredArrayUsingPredicate:predicate];
    
    NSNumber *avgValue = [filteredArray valueForKeyPath:@"@avg.datasetValueKey"];
    
    return avgValue;
}

#pragma mark - Object related methods

- (id)nextObject
{
    id nextPoint = nil;
    
    if (self.current < [self.dataPoints count])
    {
        nextPoint = [self.dataPoints objectAtIndex:self.current++];
    }
    else
    {
        self.current = 0;
        nextPoint = [self.dataPoints objectAtIndex:self.current++];
    }
    
    return nextPoint;
}

- (NSArray *)allObjects
{
    return self.dataPoints;
}

- (NSNumber *)numberOfDataPoints
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K <> %@", kDatasetValueKey, @(NSNotFound)];
    NSArray *filteredArray = [self.dataPoints filteredArrayUsingPredicate:predicate];
    
    NSNumber *numberOfPoints = @(filteredArray.count);
    
    return numberOfPoints;
}

/*********************************************************************************/
#pragma mark - Common Graph Datasource
/*********************************************************************************/

- (NSInteger)numberOfPointsInPlot:(NSInteger)plotIndex
{
    NSInteger numberOfPoints = 0;
    
    if (plotIndex == 0)
    {
        numberOfPoints = self.dataPoints.count;
    }
    else
    {
        numberOfPoints = self.correlatedScoring.dataPoints.count;
    }
    
    return numberOfPoints;
}

- (NSInteger)numberOfDivisionsInXAxis
{
    NSInteger numberOfDivs = [self.dataPoints count];
    
    if (self.numberOfDays == -(kNumberOfDaysIn3Months - 1))
    {
        numberOfDivs = 4;
    }
    else if (self.numberOfDays == -(kNumberOfDaysInYear - 1))
    {
        numberOfDivs = 6;
    }
    
    return numberOfDivs;
}

- (NSInteger)numberOfPlotsInGraph
{
    NSUInteger numberOfPlots = 1;
    
    if (self.correlatedScoring.dataPoints.count > 0)
    {
        numberOfPlots = 2;
    }
    return numberOfPlots;
}

- (NSString *)graph:(XZCareBaseGraphView *) graphView titleForXAxisAtIndex:(NSInteger)pointIndex
{
    
    NSDate *titleDate = nil;
    NSInteger numOfTitles = 0;
    if ([graphView isKindOfClass:[XZCareLineGraphView class]])
    {
        numOfTitles = [self numberOfDivisionsInXAxisForLineGraph:(XZCareLineGraphView *)graphView];
    }
    else if ([graphView isKindOfClass:[XZCareDiscreteGraphView class]])
    {
        numOfTitles = [self numberOfDivisionsInXAxisForDiscreteGraph:(XZCareDiscreteGraphView *)graphView];
    }

    NSInteger actualIndex = ((self.dataPoints.count - 1)/numOfTitles + 1) * pointIndex;
    
    titleDate = [[self.dataPoints objectAtIndex:actualIndex] valueForKey:kDatasetDateKey];
    
    switch (self.groupBy)
    {
        case XZCareTimelineGroupMonth:
        case XZCareTimelineGroupYear:
            [self.dateFormatter setDateFormat:@"MMM"];
            break;
            
        case XZCareTimelineGroupWeek:
        case XZCareTimelineGroupDay:
        default:
            if (actualIndex == 0)
            {
                [self.dateFormatter setDateFormat:@"MMM d"];
            }
            else
            {
                [self.dateFormatter setDateFormat:@"d"];
            }
            break;
    }
    
    NSString *xAxisTitle = [self.dateFormatter stringFromDate:titleDate] ? [self.dateFormatter stringFromDate:titleDate] : @"";
    
    return xAxisTitle;
}

/*********************************************************************************/
#pragma mark  XZCareLineGraphViewDataSource
/*********************************************************************************/

- (NSInteger)lineGraph:(XZCareLineGraphView *) __unused graphView numberOfPointsInPlot:(NSInteger)plotIndex
{
    return [self numberOfPointsInPlot:plotIndex];
}

- (NSInteger)numberOfPlotsInLineGraph:(XZCareLineGraphView *) __unused graphView
{

    
    
    
    return [self numberOfPlotsInGraph];
}

- (CGFloat)minimumValueForLineGraph:(XZCareLineGraphView *) __unused graphView
{
    CGFloat factor = 0.2;
    CGFloat maxDataPoint = (self.customMaximumPoint == CGFLOAT_MAX) ? [[self maximumDataPoint] doubleValue] : self.customMaximumPoint;
    CGFloat minDataPoint = (self.customMinimumPoint == CGFLOAT_MIN) ? [[self minimumDataPoint] doubleValue] : self.customMinimumPoint;
    
    CGFloat minValue = (minDataPoint - factor*maxDataPoint)/(1-factor);
    
    return minValue;
}

- (CGFloat)maximumValueForLineGraph:(XZCareLineGraphView *) __unused graphView
{
    return (self.customMaximumPoint == CGFLOAT_MAX) ? [[self maximumDataPoint] doubleValue] : self.customMaximumPoint;
}

- (CGFloat)lineGraph:(XZCareLineGraphView *) __unused graphView plot:(NSInteger)plotIndex valueForPointAtIndex:(NSInteger) pointIndex
{
    
    CGFloat value;
    
    //if plotIndex == 0, we may or may not have a correlated chart, we could return the value if we have one, but we shouldn't if we don't have a corresponding point for the other plotIndex.
    //if plotIndex == 1, we DO have a correlated chart, but we shouldn't return a value for plotIndex 0 if we don't have a plotIndex 1 value
    //So we need to know if this is going to be a correlated chart before returning a value for either plotIndex
    
    //check if we have a data point for both plotIndexes before returning either value
    CGFloat plotIndex0Value = [[[self.dataPoints objectAtIndex:pointIndex]valueForKey:kDatasetValueKey] doubleValue];
    CGFloat plotIndex1Value = [[[self.correlatedScoring.dataPoints objectAtIndex:pointIndex]valueForKey:kDatasetValueKey] doubleValue];
    
    if ((self.correlatedScoring) && (plotIndex0Value == NSNotFound || plotIndex1Value == NSNotFound))
    {
        value = NSNotFound;
    }
    else if (plotIndex == 0)
    {
        value = plotIndex0Value;
    }
    else if (plotIndex == 1)
    {
        value = plotIndex1Value;
    }
    else
    {
        value = NSNotFound;
    }
    
    return value;
}

- (NSString *)lineGraph:(XZCareLineGraphView *) graphView titleForXAxisAtIndex:(NSInteger)pointIndex
{
    
    return [self graph:graphView titleForXAxisAtIndex:pointIndex];
    
}

- (NSInteger)numberOfDivisionsInXAxisForLineGraph:(XZCareLineGraphView *)__unused graphView
{
    return [self numberOfDivisionsInXAxis];
}

/*********************************************************************************/
#pragma mark  XZCareDiscreteGraphViewDataSource
/*********************************************************************************/

- (NSInteger)numberOfPlotsInDiscreteGraph:(XZCareDiscreteGraphView *)__unused graphView
{
    return [self numberOfPlotsInGraph];
}

- (NSInteger)discreteGraph:(XZCareDiscreteGraphView *) __unused graphView numberOfPointsInPlot:(NSInteger) plotIndex
{
    return [self numberOfPointsInPlot:plotIndex];
}

- (XZCareRangePoint *)discreteGraph:(XZCareDiscreteGraphView *) __unused graphView plot:(NSInteger) plotIndex valueForPointAtIndex:(NSInteger) __unused pointIndex
{
    
    XZCareRangePoint *value;
    NSDictionary *point = [NSDictionary new];
    
    if (plotIndex == 0)
    {
        point = [self.dataPoints objectAtIndex:pointIndex];
        value = [point valueForKey:kDatasetRangeValueKey];
    }
    else
    {
        point = [self.correlatedScoring.dataPoints objectAtIndex:pointIndex];
        value = [point valueForKey:kDatasetRangeValueKey];
    }
    
    return value;
}

- (NSString *)discreteGraph:(XZCareDiscreteGraphView *) graphView titleForXAxisAtIndex:(NSInteger) pointIndex
{
    
    return [self graph:graphView titleForXAxisAtIndex:pointIndex];
    
}

- (NSInteger)numberOfDivisionsInXAxisForDiscreteGraph:(XZCareDiscreteGraphView *)__unused graphView
{
    return [self numberOfDivisionsInXAxis];
}

- (CGFloat)minimumValueForDiscreteGraph:(XZCareDiscreteGraphView *) __unused graphView
{
    CGFloat factor = 0.2;
    CGFloat maxDataPoint = (self.customMaximumPoint == CGFLOAT_MAX) ? [[self maximumDataPoint] doubleValue] : self.customMaximumPoint;
    CGFloat minDataPoint = (self.customMinimumPoint == CGFLOAT_MIN) ? [[self minimumDataPoint] doubleValue] : self.customMinimumPoint;
    
    CGFloat minValue = (minDataPoint - factor*maxDataPoint)/(1-factor);
    
    return minValue;
}

- (CGFloat)maximumValueForDiscreteGraph:(XZCareDiscreteGraphView *) __unused graphView
{
    return (self.customMaximumPoint == CGFLOAT_MAX) ? [[self maximumDataPoint] doubleValue] : self.customMaximumPoint;
}

#ifdef DEBUG
-(void)DebugLog
{
    NSLog(@"XZCareScoring DebugLog begin\n");
    
    NSLog(@"XZCareScoring DebugLog customMaximumPoint:%f\n", self.customMaximumPoint);
    NSLog(@"XZCareScoring DebugLog customMinimumPoint:%f\n", self.customMinimumPoint);
    
    NSLog(@"XZCareScoring DebugLog caption:%@\n", self.caption);
    NSLog(@"XZCareScoring DebugLog series1Name:%@\n", self.series1Name);
    NSLog(@"XZCareScoring DebugLog series2Name:%@\n", self.series2Name);
    NSLog(@"XZCareScoring DebugLog taskId:%@\n", self.taskId);
    NSLog(@"XZCareScoring DebugLog valueKey:%@\n", self.valueKey);
    NSLog(@"XZCareScoring DebugLog quantityType:%@\n", [self.quantityType description]);
    NSLog(@"XZCareScoring DebugLog unit:%@\n", self.unit.unitString);
    
    NSLog(@"XZCareScoring DebugLog dataPoints:%@\n", [self.dataPoints description]);
    NSLog(@"XZCareScoring DebugLog updatedDataPoints:%@\n", [self.updatedDataPoints description]);
    
    NSLog(@"XZCareScoring DebugLog timeline:%@\n", [self.timeline description]);
    
    NSLog(@"XZCareScoring DebugLog numberOfDays:%i\n", (int)self.numberOfDays);
    
    NSLog(@"XZCareScoring DebugLog end\n");
}
#endif

@end
