//
//  XZBaseStringConstraints.m
//

#import "XZBaseStringConstraints.h"
#import "NSDate+XZCareBase.h"

@implementation XZBaseStringConstraints

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

- (int64_t)maxLengthValue
{
	return [self.maxLength longLongValue];
}

- (void)setMaxLengthValue:(int64_t)value_
{
	self.maxLength = [NSNumber numberWithLongLong:value_];
}

- (int64_t)minLengthValue
{
	return [self.minLength longLongValue];
}

- (void)setMinLengthValue:(int64_t)value_
{
	self.minLength = [NSNumber numberWithLongLong:value_];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        self.maxLength = [dictionary objectForKey:@"maxLength"];
        self.minLength = [dictionary objectForKey:@"minLength"];
        self.pattern = [dictionary objectForKey:@"pattern"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.maxLength = [dictionary objectForKey:@"maxLength"];
    self.minLength = [dictionary objectForKey:@"minLength"];
    self.pattern = [dictionary objectForKey:@"pattern"];
}


- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.maxLength forKey:@"maxLength"];
    [dict setObjectIfNotNil:self.minLength forKey:@"minLength"];
    [dict setObjectIfNotNil:self.pattern forKey:@"pattern"];

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
    NSLog(@"XZBaseStringConstraints DebugLog maxLength:%@\n", [self.maxLength description]);
    NSLog(@"XZBaseStringConstraints DebugLog minLength:%@\n", [self.minLength description]);
    NSLog(@"XZBaseStringConstraints DebugLog pattern:%@\n", self.pattern);
}

#endif

@end
