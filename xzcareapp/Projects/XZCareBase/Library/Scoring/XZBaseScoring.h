//
//  XZBaseScoring.h
//  XZCareBase
//
//  Created by Zhaohui Xing on 2015-10-22.
//  Copyright © 2015 xz-care. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XZCareTimelineGroups)
{
    XZCareTimelineGroupDay = 0,
    XZCareTimelineGroupWeek,
    XZCareTimelineGroupMonth,
    XZCareTimelineGroupYear,
    XZCareTimelineGroupForInsights
};

@class XZBaseScoring;

//
// XZCareScoring delegate
//
@protocol XZCareScoringDelegate <NSObject>

-(void)graphViewControllerShouldUpdateChartWithScoring: (XZBaseScoring *)scoring;
//-(void)graphViewControllerShouldUpdateChartWithScoring: (id)scoring;  //id: must be XZCareScoring object

@end


@interface XZBaseScoring : NSEnumerator

@property (nonatomic) double customMaximumPoint;
@property (nonatomic) double customMinimumPoint;

//APCScoring Delegate
@property (weak, nonatomic) id<XZCareScoringDelegate> scoringDelegate;

//Exposed for APCCorrelationsSelectorViewController
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *series1Name;
@property (nonatomic, strong) NSString *series2Name;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *valueKey;

- (void)updatePeriodForDays:(NSInteger)numberOfDays groupBy:(XZCareTimelineGroups)groupBy;

@end
