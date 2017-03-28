//
//  XZbaseGuidCreatedOnVersionHolder.m
//

#import "XZBaseGuidCreatedOnVersionHolder.h"
#import "NSDate+XZCareBase.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseGuidCreatedOnVersionHolder

- (id)init
{
	if((self = [super init]))
	{

	}

	return self;
}

#pragma mark Scalar values

- (int64_t)versionValue
{
	return [self.version longLongValue];
}

- (void)setVersionValue:(int64_t)value_
{
	self.version = [NSNumber numberWithLongLong:value_];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        self.createdOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"createdOn"]];
        self.guid = [dictionary objectForKey:@"guid"];
        self.version = [dictionary objectForKey:@"version"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.createdOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"createdOn"]];
    self.guid = [dictionary objectForKey:@"guid"];
    self.version = [dictionary objectForKey:@"version"];
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:[self.createdOn ISO8601String] forKey:@"createdOn"];
    [dict setObjectIfNotNil:self.guid forKey:@"guid"];
    [dict setObjectIfNotNil:self.version forKey:@"version"];

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
    NSLog(@"XZBaseGuidCreatedOnVersionHolder DebugLog guid:%@\n", self.guid);
    NSLog(@"XZBaseGuidCreatedOnVersionHolder DebugLog version:%lli\n", [self.version longLongValue]);
    NSLog(@"XZBaseGuidCreatedOnVersionHolder DebugLog createdOn:%@\n", [self.createdOn ISO8601String]);
}
#endif

@end
