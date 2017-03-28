//
//  XZBaseSurveyElement.m
//

#import "XZBaseSurveyElement.h"

@implementation XZBaseSurveyElement

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
        self.guid = [dictionary objectForKey:@"guid"];
        self.identifier = [dictionary objectForKey:@"identifier"];
        self.prompt = [dictionary objectForKey:@"prompt"];
        self.promptDetail = [dictionary objectForKey:@"promptDetail"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.guid = [dictionary objectForKey:@"guid"];
    self.identifier = [dictionary objectForKey:@"identifier"];
    self.prompt = [dictionary objectForKey:@"prompt"];
    self.promptDetail = [dictionary objectForKey:@"promptDetail"];
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];

    [dict setObjectIfNotNil:self.guid forKey:@"guid"];
    [dict setObjectIfNotNil:self.identifier forKey:@"identifier"];
    [dict setObjectIfNotNil:self.prompt forKey:@"prompt"];
    [dict setObjectIfNotNil:self.promptDetail forKey:@"promptDetail"];

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
    NSLog(@"XZBaseSurveyElement guid:%@\n", self.guid);
    NSLog(@"XZBaseSurveyElement identifier:%@\n", self.identifier);
    NSLog(@"XZBaseSurveyElement prompt:%@\n", self.prompt);
    NSLog(@"XZBaseSurveyElement promptDetail:%@\n", self.promptDetail);
}

#endif

@end
