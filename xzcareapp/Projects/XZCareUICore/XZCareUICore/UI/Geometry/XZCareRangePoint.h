//
//  XZCareRangePoint.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-25.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZCareRangePoint : NSObject

@property (nonatomic) CGFloat maximumValue;
@property (nonatomic) CGFloat minimumValue;

@property (nonatomic, getter=isEmpty) BOOL empty;

- (instancetype)initWithMinimumValue:(CGFloat)minValue maximumValue:(CGFloat)maxValue;
- (BOOL)isRangeZero;

@end
