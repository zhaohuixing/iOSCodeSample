//
//  XZCareInterfaces.h
//  XZCareCore
//
//  Created by Zhaohui Xing on 2015-07-25.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#ifndef __XZCAREINTERFAES_H__
#define __XZCAREINTERFAES_H__
#import <UIKit/UIKit.h>
#import <ResearchKit/ResearchKit.h>
#import "XZCareConstants.h"

/*
//
//XZCareBaseGraphView delegate
//
@protocol XZCareBaseGraphViewDelegate <NSObject>

@optional
- (void)graphViewTouchesBegan:(id)graphView;
- (void)graphView:(id)graphView touchesMovedToXPosition:(CGFloat)xPosition;
- (void)graphViewTouchesEnded:(id)graphView;
@end

*/

/*
//
//XZCareLineGraphView delegate
//
@protocol XZCareLineGraphViewDataSource <NSObject>

@required

- (NSInteger)lineGraph:(id)graphView numberOfPointsInPlot:(NSInteger)plotIndex;
- (CGFloat)lineGraph:(id)graphView plot:(NSInteger)plotIndex valueForPointAtIndex:(NSInteger)pointIndex;

@optional

- (NSInteger)numberOfPlotsInLineGraph:(id)graphView;
- (NSInteger)numberOfDivisionsInXAxisForGraph:(id)graphView;
- (CGFloat)maximumValueForLineGraph:(id)graphView;
- (CGFloat)minimumValueForLineGraph:(id)graphView;
- (NSString *)lineGraph:(id)graphView titleForXAxisAtIndex:(NSInteger)pointIndex;

@end

*/
/*
 
//
//XZCareDiscreteGraphView delegate
//
@protocol XZCareDiscreteGraphViewDataSource <NSObject>

@required

- (NSInteger)discreteGraph:(id)graphView numberOfPointsInPlot:(NSInteger)plotIndex;
//- (XZCareRangePoint *)discreteGraph:(id)graphView plot:(NSInteger)plotIndex valueForPointAtIndex:(NSInteger)pointIndex;
- (id)discreteGraph:(id)graphView plot:(NSInteger)plotIndex valueForPointAtIndex:(NSInteger)pointIndex;

@optional

- (NSInteger)numberOfPlotsInDiscreteGraph:(id)graphView;
- (NSInteger)numberOfDivisionsInXAxisForGraph:(id)graphView;
- (CGFloat)maximumValueForDiscreteGraph:(id)graphView;
- (CGFloat)minimumValueForDiscreteGraph:(id)graphView;
- (NSString *)discreteGraph:(id)graphView titleForXAxisAtIndex:(NSInteger)pointIndex;

@end

*/

/*
//
// XZCareScoring delegate
//
@protocol XZCareScoringDelegate <NSObject>

//-(void)graphViewControllerShouldUpdateChartWithScoring: (XZCareScoring *)scoring;
-(void)graphViewControllerShouldUpdateChartWithScoring: (id)scoring;  //id: must be XZCareScoring object

@end

*/ 
/*
//
// XZCareSegmentedButton delegate
//
@protocol XZCareSegmentedButtonDelegate <NSObject>

@required
- (void) segmentedButtonPressed:(UIButton*) button selectedIndex: (NSInteger) selectedIndex;

@end
*/
 
@protocol XZCareInsightsDelegate <NSObject>

- (void)didCompleteInsightForFactor:(XZCareInsightFactors)factor withInsight:(NSDictionary *)insight;

@end


@protocol XZCareFoodInsightDelegate <NSObject>

- (void)didCompleteFoodInsightForSampleType:(HKSampleType *)sampleType insight:(NSArray *)foodInsight;

@end


#endif
