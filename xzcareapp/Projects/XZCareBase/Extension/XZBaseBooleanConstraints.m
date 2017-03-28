//
//  XZBaseBooleanConstraints.m
//

#import "XZBaseBooleanConstraints.h"
#import "NSDate+XZCareBase.h"

@interface XZBaseBooleanConstraints()

@end

@implementation XZBaseBooleanConstraints

/*
- (BOOL)boolValueValue
{
    return [self.boolValue boolValue];
}

- (void)setBoolValueValue:(BOOL)value_
{
    self.boolValue = [NSNumber numberWithBool:value_];
}
*/

- (id)init
{
	if((self = [super init]))
	{
//        self.boolValue = @NO;
	}

	return self;
}

#pragma mark Scalar values

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
//        self.boolValue = [dictionary objectForKey:@"boolValue"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
//    self.boolValue = [dictionary objectForKey:@"boolValue"];
}


- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
//    [dict setObjectIfNotNil:self.boolValue forKey:@"boolValue"];
    
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
//    NSLog(@"XZBaseBooleanConstraints DebugLog boolValue:%@\n", [self.boolValue description]);
}
#endif


@end
