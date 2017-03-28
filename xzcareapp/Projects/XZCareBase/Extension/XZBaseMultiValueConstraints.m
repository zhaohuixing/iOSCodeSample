//
//  XZBaseMultiValueConstraints.m
//
#import "XZBaseMultiValueConstraints.h"
#import "XZBaseSurveyQuestionOption.h"
#import "XZBaseClassFactory.h"


@implementation XZBaseMultiValueConstraints

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

- (BOOL)allowMultipleValue
{
	return [self.allowMultiple boolValue];
}

- (void)setAllowMultipleValue:(BOOL)value_
{
	self.allowMultiple = [NSNumber numberWithBool:value_];
}

- (BOOL)allowOtherValue
{
	return [self.allowOther boolValue];
}

- (void)setAllowOtherValue:(BOOL)value_
{
	self.allowOther = [NSNumber numberWithBool:value_];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        self.allowMultiple = [dictionary objectForKey:@"allowMultiple"];
        self.allowOther = [dictionary objectForKey:@"allowOther"];
        //self.enumeration = [dictionary objectForKey:@"enumeration"];
        NSArray* questionArrays = [dictionary objectForKey:@"enumeration"];
        if(questionArrays == nil || questionArrays.count <= 0)
        {
            self.enumeration = nil;
        }
        else
        {
            NSMutableArray* tempArray = [[NSMutableArray alloc] init];
            [questionArrays enumerateObjectsUsingBlock:^(id question, NSUInteger __unused idx, BOOL * __unused stop)
             {
                 if(question != nil && [question isKindOfClass:[NSDictionary class]] == YES)
                 {
                     XZBaseSurveyQuestionOption* pQuestion = [[XZBaseSurveyQuestionOption alloc] initWithDictionaryRepresentation:(NSDictionary *)question];
                     [tempArray addObject:pQuestion];
                 }
             }];
            self.enumeration = [NSArray arrayWithArray:tempArray];
        }
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.allowMultiple = [dictionary objectForKey:@"allowMultiple"];
    self.allowOther = [dictionary objectForKey:@"allowOther"];
    //self.enumeration = [dictionary objectForKey:@"enumeration"];
    NSArray* questionArrays = [dictionary objectForKey:@"enumeration"];
    if(questionArrays == nil || questionArrays.count <= 0)
    {
        self.enumeration = nil;
    }
    else
    {
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        [questionArrays enumerateObjectsUsingBlock:^(id question, NSUInteger __unused idx, BOOL * __unused stop)
         {
             if(question != nil && [question isKindOfClass:[NSDictionary class]] == YES)
             {
                 XZBaseSurveyQuestionOption* pQuestion = [[XZBaseSurveyQuestionOption alloc] initWithDictionaryRepresentation:(NSDictionary *)question];
                 [tempArray addObject:pQuestion];
             }
         }];
        self.enumeration = [NSArray arrayWithArray:tempArray];
    }
}

-(NSArray*)convertQuestionListToDictionaryList
{
    NSMutableArray* elemArray = nil;
    
    if(self.enumeration != nil && 0 < self.enumeration.count)
    {
        elemArray = [[NSMutableArray alloc] init];
        for(XZBaseSurveyQuestionOption* pQuestion in self.enumeration)
        {
            if(pQuestion != nil)
            {
                NSDictionary* pRepersentation = [pQuestion dictionaryRepresentation];
                [elemArray addObject:pRepersentation];
            }
        }
    }
    
    return elemArray;
}


- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.allowMultiple forKey:@"allowMultiple"];
    [dict setObjectIfNotNil:self.allowOther forKey:@"allowOther"];
    //[dict setObjectIfNotNil:self.enumeration forKey:@"enumeration"];
    NSArray* pQuestions = [self convertQuestionListToDictionaryList];
    if(pQuestions != nil && 0 < pQuestions.count)
        [dict setObjectIfNotNil:pQuestions forKey:@"enumeration"];

	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.

	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access

#ifdef DEBUG
- (void)DebugLog
{
    [super DebugLog];
    NSLog(@"XZBaseMultiValueConstraints DebugLog allowOther:%@\n", self.allowOther);
    NSLog(@"XZBaseMultiValueConstraints DebugLog allowMultiple:%@\n", self.allowMultiple);
    
    NSLog(@"XZBaseMultiValueConstraints DebugLog enumeration *************begin*************\n");
    if(self.enumeration == nil || self.enumeration.count <= 0)
    {
        NSLog(@"XZBaseMultiValueConstraints DebugLog does not have answer\n");
    }
    else
    {
        for(XZBaseSurveyQuestionOption* pQuestion in self.enumeration)
        {
            if(pQuestion != nil)
            {
                [pQuestion DebugLog];
            }
        }
    }
    NSLog(@"XZBaseMultiValueConstraints DebugLog enumeration **************end**************\n");
}

#endif

@end
