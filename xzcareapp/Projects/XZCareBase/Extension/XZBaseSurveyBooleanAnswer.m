//
//  XZBaseSurveyBooleanAnswer.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-30.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZBaseSurveyBooleanAnswer.h"

@implementation XZBaseSurveyBooleanAnswer


#pragma mark Scalar values
- (BOOL)answerBooleanValue
{
    return [self.answerBoolean boolValue];
}

- (void)setAnswerBooleanValue:(BOOL)value_
{
    self.answerBoolean = [NSNumber numberWithBool:value_];
}

-(XZBaseSurveyAnswerType)GetAnswerType
{
    return XZBaseSurveyAnswerTypeBoolean;
}

#pragma mark methods

- (id)init
{
    if((self = [super init]))
    {
        self.answerBoolean = @NO;
    }
    return self;
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.answerBoolean = [dictionary objectForKey:@"answerBoolean"];
    }
    
    return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.answerBoolean = [dictionary objectForKey:@"answerBoolean"];
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.answerBoolean forKey:@"answerBoolean"];
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
    NSLog(@"XZBaseSurveyBooleanAnswer answerBoolean:%@\n", [self.answerBoolean description]);
}
#endif

@end
