//
//  XZBaseIntegerConstraints.m
//

#import "XZBaseIntegerConstraints.h"
#import "NSDate+XZCareBase.h"

@implementation XZBaseIntegerConstraints

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

- (int64_t)maxValueValue
{
	return [self.maxValue longLongValue];
}

- (void)setMaxValueValue:(int64_t)value_
{
	self.maxValue = [NSNumber numberWithLongLong:value_];
}

- (int64_t)minValueValue
{
	return [self.minValue longLongValue];
}

- (void)setMinValueValue:(int64_t)value_
{
	self.minValue = [NSNumber numberWithLongLong:value_];
}

- (int64_t)stepValue
{
	return [self.step longLongValue];
}

- (void)setStepValue:(int64_t)value_
{
	self.step = [NSNumber numberWithLongLong:value_];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        self.maxValue = [dictionary objectForKey:@"maxValue"];
        self.minValue = [dictionary objectForKey:@"minValue"];
        self.step = [dictionary objectForKey:@"step"];
        self.unit = [dictionary objectForKey:@"unit"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.maxValue = [dictionary objectForKey:@"maxValue"];
    self.minValue = [dictionary objectForKey:@"minValue"];
    self.step = [dictionary objectForKey:@"step"];
    self.unit = [dictionary objectForKey:@"unit"];
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.maxValue forKey:@"maxValue"];
    [dict setObjectIfNotNil:self.minValue forKey:@"minValue"];
    [dict setObjectIfNotNil:self.step forKey:@"step"];
    [dict setObjectIfNotNil:self.unit forKey:@"unit"];

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
    NSLog(@"XZBaseIntegerConstraints DebugLog maxValue:%@\n", [self.maxValue description]);
    NSLog(@"XZBaseIntegerConstraints DebugLog minValue:%@\n", [self.minValue description]);
    NSLog(@"XZBaseIntegerConstraints DebugLog step:%@\n", [self.step description]);
    NSLog(@"XZBaseIntegerConstraints DebugLog unit:%@\n", self.unit);
}
#endif

@end
