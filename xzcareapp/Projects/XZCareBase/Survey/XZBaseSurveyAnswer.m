//
//  XZCareSurveyAnswer.m
//

#import "XZBaseSurveyAnswer.h"
#import "NSDate+XZCareBase.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseSurveyAnswer

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

- (BOOL)declinedValue
{
	return [self.declined boolValue];
}

- (void)setDeclinedValue:(BOOL)value_
{
	self.declined = [NSNumber numberWithBool:value_];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        self.answeredOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"answeredOn"]];
//        self.answers = [dictionary objectForKey:@"answers"];
        NSDictionary* answerJson = [dictionary objectForKey:@"answer"];
        if(answerJson == nil)
        {
#ifdef DEBUG
            NSAssert(NO, @"XZBaseSurveyAnswer initWithDictionaryRepresentation: The representation does not have answer data set!");
#endif
        }
        else
        {
            self.answer = (id<XZBaseSurveyAnswerBase>)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:answerJson];
            if(self.answer == nil)
            {
#ifdef DEBUG
                NSAssert(NO, @"XZBaseSurveyAnswer initWithDictionaryRepresentation: failed to create answer object from representation data");
#endif
            }
        }
        
        self.client = [dictionary objectForKey:@"client"];
        self.declined = [dictionary objectForKey:@"declined"];
        self.questionGuid = [dictionary objectForKey:@"questionGuid"];
	}

	return self;
}


- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.answeredOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"answeredOn"]];
//    self.answers = [dictionary objectForKey:@"answers"];
    NSDictionary* answerJson = [dictionary objectForKey:@"answer"];
    if(answerJson == nil)
    {
#ifdef DEBUG
        NSAssert(NO, @"XZBaseSurveyAnswer initializeFromDictionaryRepresentation: The representation does not have answer data set!");
#endif
    }
    else
    {
        self.answer = (id<XZBaseSurveyAnswerBase>)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:answerJson];
        if(self.answer == nil)
        {
#ifdef DEBUG
            NSAssert(NO, @"XZBaseSurveyAnswer initializeFromDictionaryRepresentation: failed to create answer object from representation data");
#endif
        }
    }
    
    self.client = [dictionary objectForKey:@"client"];
    self.declined = [dictionary objectForKey:@"declined"];
    self.questionGuid = [dictionary objectForKey:@"questionGuid"];
}


- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];

    [dict setObjectIfNotNil:[self.answeredOn ISO8601String] forKey:@"answeredOn"];
//    [dict setObjectIfNotNil:self.answers forKey:@"answers"];
    if(self.answer)
    {
        [dict setObjectIfNotNil:[self.answer dictionaryRepresentation] forKey:@"answer"];
    }
    
    [dict setObjectIfNotNil:self.client forKey:@"client"];
    [dict setObjectIfNotNil:self.declined forKey:@"declined"];
    [dict setObjectIfNotNil:self.questionGuid forKey:@"questionGuid"];

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
-(void)DebugLog
{
    [super DebugLog];
    NSLog(@"XZBaseSurveyAnswer DebugLog answeredOn:%@\n", self.answeredOn);
    NSLog(@"XZBaseSurveyAnswer DebugLog client:%@\n", self.client);
    NSLog(@"XZBaseSurveyAnswer DebugLog declined:%@\n", [self.declined description]);
    NSLog(@"XZBaseSurveyAnswer DebugLog questionGuid:%@\n", self.questionGuid);
    if(self.answer)
    {
        [self.answer DebugLog];
    }
    else
    {
        NSLog(@"XZBaseSurveyAnswer DebugLog answer not exist\n");
    }
}
#endif

@end
