//
//  XZBaseSurveyIntegerAnswer.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-30.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import "XZBaseSurveyIntegerAnswer.h"

@implementation XZBaseSurveyIntegerAnswer

#pragma mark Scalar values
- (int64_t)answerIntegerValue
{
    return [self.answerInteger longLongValue];
}

- (void)setAnswerIntegerValue:(int64_t)value_
{
    self.answerInteger = [NSNumber numberWithLongLong:value_];
}

-(XZBaseSurveyAnswerType)GetAnswerType
{
    return XZBaseSurveyAnswerTypeInteger;
}

#pragma mark methods

- (id)init
{
    if((self = [super init]))
    {
        self.answerInteger = @0;
    }
    return self;
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.answerInteger = [dictionary objectForKey:@"answerInteger"];
    }
    
    return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.answerInteger = [dictionary objectForKey:@"answerInteger"];
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.answerInteger forKey:@"answerInteger"];
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
    NSLog(@"XZBaseSurveyIntegerAnswer answerInteger:%lli\n", [self.answerInteger longLongValue]);
}

#endif


@end
