//
//  XZBaseSurveyDateAnswer.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-30.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZBaseSurveyDateAnswer.h"
#import "NSDate+XZCareBase.h"

@implementation XZBaseSurveyDateAnswer

-(XZBaseSurveyAnswerType)GetAnswerType
{
    return XZBaseSurveyAnswerTypeDate;
}

- (id)init
{
    if((self = [super init]))
    {
    }
    return self;
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.answerDate = [NSDate dateWithISO8601String:[dictionary objectForKey:@"answerDate"]];
    }
    
    return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.answerDate = [NSDate dateWithISO8601String:[dictionary objectForKey:@"answerDate"]];
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:[self.answerDate ISO8601String] forKey:@"answerDate"];
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
    NSLog(@"XZBaseSurveyDateAnswer answerDate:%@\n", [self.answerDate ISO8601String]);
}
#endif


@end
