//
//  XZBaseSurveyResponse.m
//

#import "XZBaseSurveyResponse.h"
#import "NSDate+XZCareBase.h"
#import "XZBaseClassFactory.h"
#import "XZBaseSurveyAnswer.h"

@implementation XZBaseSurveyResponse

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        //???self.answers = [dictionary objectForKey:@"answers"];
        self.completedOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"completedOn"]];
        self.identifier = [dictionary objectForKey:@"identifier"];
        self.startedOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"startedOn"]];
        self.status = [dictionary objectForKey:@"status"];
        //???self.survey = [dictionary objectForKey:@"survey"];
        NSDictionary* surveyJson = [dictionary objectForKey:@"survey"];
        if(surveyJson == nil)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyResponse initWithDictionaryRepresentation: The representation does not have survey data set!");
#endif
        }
        else
        {
            self.survey = (XZBaseSurvey*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:surveyJson];
            if(self.survey == nil)
            {
#ifdef DEBUG
                NSLog(@"XZBaseSurveyResponse initWithDictionaryRepresentation: failed to create survey object from representation data");
#endif
            }
        }
	
        NSArray* answerArrays = [dictionary objectForKey:@"answers"];
        if(answerArrays == nil || answerArrays.count <= 0)
        {
            self.answers = nil;
        }
        else
        {
            NSMutableArray* tempArray = [[NSMutableArray alloc] init];
            [answerArrays enumerateObjectsUsingBlock:^(id answer, NSUInteger __unused idx, BOOL * __unused stop)
             {
                 if(answer != nil && [answer isKindOfClass:[NSDictionary class]] == YES)
                 {
                     XZBaseSurveyAnswer* pAnswer = [[XZBaseSurveyAnswer alloc] initWithDictionaryRepresentation:(NSDictionary *)answer];
                     [tempArray addObject:pAnswer];
                 }
             }];
            self.answers = [NSArray arrayWithArray:tempArray];
        }
    }

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    //self.answers = [dictionary objectForKey:@"answers"];
    self.completedOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"completedOn"]];
    self.identifier = [dictionary objectForKey:@"identifier"];
    self.startedOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"startedOn"]];
    self.status = [dictionary objectForKey:@"status"];
    //self.survey = [dictionary objectForKey:@"survey"];
    NSDictionary* surveyJson = [dictionary objectForKey:@"survey"];
    if(surveyJson == nil)
    {
#ifdef DEBUG
        NSLog(@"XZBaseSurveyResponse initializeFromDictionaryRepresentation: The representation does not have survey data set!");
#endif
    }
    else
    {
        self.survey = (XZBaseSurvey*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:surveyJson];
        if(self.survey == nil)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyResponse initializeFromDictionaryRepresentation: failed to create survey object from representation data");
#endif
        }
    }
    NSArray* answerArrays = [dictionary objectForKey:@"answers"];
    if(answerArrays == nil || answerArrays.count <= 0)
    {
        self.answers = nil;
    }
    else
    {
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        [answerArrays enumerateObjectsUsingBlock:^(id answer, NSUInteger __unused idx, BOOL * __unused stop)
         {
             if(answer != nil && [answer isKindOfClass:[NSDictionary class]] == YES)
             {
                 XZBaseSurveyAnswer* pAnswer = [[XZBaseSurveyAnswer alloc] initWithDictionaryRepresentation:(NSDictionary *)answer];
                 [tempArray addObject:pAnswer];
             }
         }];
        self.answers = [NSArray arrayWithArray:tempArray];
    }
}

-(NSArray*)convertAnswerListToDictionaryList
{
    NSMutableArray* elemArray = nil;
    
    if(self.answers != nil && 0 < self.answers.count)
    {
        elemArray = [[NSMutableArray alloc] init];
        for(XZBaseSurveyAnswer* pAnswer in self.answers)
        {
            if(pAnswer != nil)
            {
                NSDictionary* pRepersentation = [pAnswer dictionaryRepresentation];
                [elemArray addObject:pRepersentation];
            }
        }
    }
    
    return elemArray;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    //[dict setObjectIfNotNil:self.answers forKey:@"answers"];
    [dict setObjectIfNotNil:[self.completedOn ISO8601String] forKey:@"completedOn"];
    [dict setObjectIfNotNil:self.identifier forKey:@"identifier"];
    [dict setObjectIfNotNil:[self.startedOn ISO8601String] forKey:@"startedOn"];
    [dict setObjectIfNotNil:self.status forKey:@"status"];
    //[dict setObjectIfNotNil:self.survey forKey:@"survey"];
    if(self.survey != nil)
    {
        [dict setObjectIfNotNil:[self.survey dictionaryRepresentation] forKey:@"survey"];
    }
    
    NSArray* pAnswers = [self convertAnswerListToDictionaryList];
    if(pAnswers != nil && 0 < pAnswers.count)
        [dict setObjectIfNotNil:pAnswers forKey:@"answers"];
    
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
    NSLog(@"XZBaseSurveyResponse DebugLog identifier:%@\n", self.identifier);
    NSLog(@"XZBaseSurveyResponse DebugLog status:%@\n", self.status);
    NSLog(@"XZBaseSurveyResponse DebugLog completedOn:%@\n", [self.completedOn ISO8601String]);
    NSLog(@"XZBaseSurveyResponse DebugLog startedOn:%@\n", [self.startedOn ISO8601String]);
    if(self.survey)
    {
        [self.survey DebugLog];
    }
    else
    {
        NSLog(@"XZBaseSurveyResponse DebugLog survey not exist\n");
    }
 
    NSLog(@"XZBaseSurveyResponse DebugLog answers *************begin*************\n");
    if(self.answers == nil || self.answers.count <= 0)
    {
        NSLog(@"XZBaseSurveyResponse DebugLog does not have answer\n");
    }
    else
    {
        for(XZBaseSurveyAnswer* pAnswer in self.answers)
        {
            if(pAnswer != nil)
            {
                [pAnswer DebugLog];
            }
        }
    }
    NSLog(@"XZBaseSurveyResponse DebugLog answers **************end**************\n");
}
#endif

@end
