//
//  XZBaseImage.m
//

#import "XZBaseImage.h"
#import "XZBaseClassFactory.h"
//#import "NSDate+SBBAdditions.h"

@implementation XZBaseImage

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

- (double)heightValue
{
	return [self.height doubleValue];
}

- (void)setHeightValue:(double)value_
{
	self.height = [NSNumber numberWithDouble:value_];
}

- (double)widthValue
{
	return [self.width doubleValue];
}

- (void)setWidthValue:(double)value_
{
	self.width = [NSNumber numberWithDouble:value_];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        self.height = [dictionary objectForKey:@"height"];
        self.source = [dictionary objectForKey:@"source"];
        self.width = [dictionary objectForKey:@"width"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.height = [dictionary objectForKey:@"height"];
    self.source = [dictionary objectForKey:@"source"];
    self.width = [dictionary objectForKey:@"width"];
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.height forKey:@"height"];
    [dict setObjectIfNotNil:self.source forKey:@"source"];
    [dict setObjectIfNotNil:self.width forKey:@"width"];

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
    NSLog(@"XZBaseImage DebugLog image resource:%@ width:%f height:%f\n", self.source, [self.width doubleValue], [self.height doubleValue]);
}
#endif

@end
