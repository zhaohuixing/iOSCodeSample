//
//  XZBaseSurveyStringAnswer.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-30.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZBaseSurveyStringAnswer.h"

@implementation XZBaseSurveyStringAnswer

-(XZBaseSurveyAnswerType)GetAnswerType
{
    return XZBaseSurveyAnswerTypeString;
}

- (id)init
{
    if((self = [super init]))
    {
        self.answerString = nil;
    }
    return self;
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.answerString = [dictionary objectForKey:@"answerString"];
    }
    
    return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.answerString = [dictionary objectForKey:@"answerString"];
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.answerString forKey:@"answerString"];
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
    NSLog(@"XZBaseSurveyStringAnswer answerString:%@\n", self.answerString);
}
#endif


@end
