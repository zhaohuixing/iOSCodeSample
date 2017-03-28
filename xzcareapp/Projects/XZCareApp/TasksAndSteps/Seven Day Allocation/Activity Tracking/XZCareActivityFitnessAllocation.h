//
//  APHFitnessAllocation.h
//  Diabetes
//
//  Copyright (c) 2014 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XZCareCore/XZCareCore.h>

@interface XZCareActivityFitnessAllocation : NSObject

@property (nonatomic) NSTimeInterval activeSeconds;

- (instancetype)initWithAllocationStartDate:(NSDate *)startDate;
- (NSArray *)todaysAllocation;
- (NSArray *)yesterdaysAllocation;
- (NSArray *)weeksAllocation;
- (void) startDataCollection;

@end
