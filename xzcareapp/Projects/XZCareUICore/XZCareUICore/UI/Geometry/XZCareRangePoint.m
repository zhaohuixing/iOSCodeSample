//
//  XZCareRangePoint.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-25.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZCareRangePoint.h"

@implementation XZCareRangePoint

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _minimumValue = NSNotFound;
        _maximumValue = NSNotFound;
    }
    return self;
}

- (instancetype)initWithMinimumValue:(CGFloat)minValue maximumValue:(CGFloat)maxValue
{
    self = [super init];
    if (self)
    {
        _minimumValue = minValue;
        _maximumValue = maxValue;
    }
    return self;
}

- (BOOL)isEmpty
{
    _empty = NO;
    
    if (self.minimumValue == NSNotFound && self.maximumValue == NSNotFound)
    {
        _empty = YES;
    }
    
    return _empty;
}

- (BOOL)isRangeZero
{
    return (self.minimumValue == self.maximumValue);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Min:%0.0f,Max:%0.0f", self.minimumValue, self.maximumValue];
}

@end
