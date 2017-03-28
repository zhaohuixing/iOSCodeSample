//
//  XZBaseSurveyFloatAnswer.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-30.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZBaseSurveyFloatAnswer.h"

@implementation XZBaseSurveyFloatAnswer

#pragma mark Scalar values
- (double)answerFloatValue
{
    return [self.answerFloat doubleValue];
}

- (void)setAnswerFloatValue:(double)value_
{
    self.answerFloat = [NSNumber numberWithDouble:value_];
}

-(XZBaseSurveyAnswerType)GetAnswerType
{
    return XZBaseSurveyAnswerTypeFloat;
}

#pragma mark methods

- (id)init
{
    if((self = [super init]))
    {
        self.answerFloat = @0.0f;
    }
    return self;
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.answerFloat = [dictionary objectForKey:@"answerFloat"];
    }
    
    return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.answerFloat = [dictionary objectForKey:@"answerFloat"];
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.answerFloat forKey:@"answerFloat"];
    return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
    if(self.sourceDictionaryRepresentation == nil)
        return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
    
    [super awakeFromDictionaryRepresentationInit];
}

#ifdef DEBUG
- (void)DebugLog
{
    [super DebugLog];
    NSLog(@"XZBaseSurveyFloatAnswer answerFloat:%f\n", [self.answerFloat doubleValue]);
}
#endif

@end
