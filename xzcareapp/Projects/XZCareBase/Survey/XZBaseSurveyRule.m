//
//  XZBaseSurveyRule.m
//

#import "XZBaseSurveyRule.h"

@implementation XZBaseSurveyRule

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
        self.operator = [dictionary objectForKey:@"operator"];
        self.skipTo = [dictionary objectForKey:@"skipTo"];
        self.value = [dictionary objectForKey:@"value"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.operator = [dictionary objectForKey:@"operator"];
    self.skipTo = [dictionary objectForKey:@"skipTo"];
    self.value = [dictionary objectForKey:@"value"];
}


- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.operator forKey:@"operator"];
    [dict setObjectIfNotNil:self.skipTo forKey:@"skipTo"];
    [dict setObjectIfNotNil:self.value forKey:@"value"];

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
    NSLog(@"XZBaseSurveyRule operator:%@\n", self.operator);
    NSLog(@"XZBaseSurveyRule skipTo:%@\n", self.skipTo);
    NSLog(@"XZBaseSurveyRule value:%@\n", [self.value description]);
}
#endif

@end
