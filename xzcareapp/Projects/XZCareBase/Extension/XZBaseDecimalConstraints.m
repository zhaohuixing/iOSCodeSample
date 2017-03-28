//
//  XZBaseDecimalConstraints.m
//

#import "XZBaseDecimalConstraints.h"
#import "NSDate+XZCareBase.h"

@implementation XZBaseDecimalConstraints

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

- (double)maxValueValue
{
	return [self.maxValue doubleValue];
}

- (void)setMaxValueValue:(double)value_
{
	self.maxValue = [NSNumber numberWithDouble:value_];
}

- (double)minValueValue
{
	return [self.minValue doubleValue];
}

- (void)setMinValueValue:(double)value_
{
	self.minValue = [NSNumber numberWithDouble:value_];
}

- (double)stepValue
{
	return [self.step doubleValue];
}

- (void)setStepValue:(double)value_
{
	self.step = [NSNumber numberWithDouble:value_];
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
    NSLog(@"XZBaseDecimalConstraints DebugLog maxValue:%@\n", [self.maxValue description]);
    NSLog(@"XZBaseDecimalConstraints DebugLog minValue:%@\n", [self.minValue description]);
    NSLog(@"XZBaseDecimalConstraints DebugLog step:%@\n", [self.step description]);
    NSLog(@"XZBaseDecimalConstraints DebugLog unit:%@\n", self.unit);
}
#endif

@end
