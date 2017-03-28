//
//  XZBaseActivity.m
//
#import "XZBaseActivity.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseActivity

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
        self.activityType = [dictionary objectForKey:@"activityType"];
        self.label = [dictionary objectForKey:@"label"];
        self.ref = [dictionary objectForKey:@"ref"];
        NSDictionary* surveyJson = [dictionary objectForKey:@"survey"];
        if(surveyJson == nil)
        {
#ifdef DEBUG
            NSAssert(NO, @"XZBaseActivity initWithDictionaryRepresentation: The representation does not have survey data set!");
#endif
        }
        else
        {
            self.survey = (XZBaseGuidCreatedOnVersionHolder*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:surveyJson];
            if(self.survey == nil)
            {
#ifdef DEBUG
                NSAssert(NO, @"XZBaseActivity initWithDictionaryRepresentation: failed to create survey object from representation data");
#endif
            }
        }
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.activityType = [dictionary objectForKey:@"activityType"];
    self.label = [dictionary objectForKey:@"label"];
    self.ref = [dictionary objectForKey:@"ref"];
    NSDictionary* surveyJson = [dictionary objectForKey:@"survey"];
    if(surveyJson == nil)
    {
#ifdef DEBUG
        NSAssert(NO, @"XZBaseActivity initializeFromDictionaryRepresentation: The representation does not have survey data set!");
#endif
    }
    else
    {
        self.survey = (XZBaseGuidCreatedOnVersionHolder*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:surveyJson];
        if(self.survey == nil)
        {
#ifdef DEBUG
            NSAssert(NO, @"XZBaseActivity initializeFromDictionaryRepresentation: falied to create survey object from representation data");
#endif
        }
    }
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.activityType forKey:@"activityType"];
    [dict setObjectIfNotNil:self.label forKey:@"label"];
    [dict setObjectIfNotNil:self.ref forKey:@"ref"];
    [dict setObjectIfNotNil:[self.survey dictionaryRepresentation] forKey:@"survey"];

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
    NSLog(@"XZBaseActivity DebugLog activityType:%@\n", self.activityType);
    NSLog(@"XZBaseActivity DebugLog label:%@\n", self.label);
    NSLog(@"XZBaseActivity DebugLog ref:%@\n", self.ref);
    NSLog(@"XZBaseActivity DebugLog survey *************begin*************\n");
    if(self.survey)
    {
        [self.survey DebugLog];
    }
    else
    {
        NSLog(@"XZBaseActivity DebugLog survey object is null\n");
    }
    NSLog(@"XZBaseActivity DebugLog survey **************end**************\n");
}
#endif

@end
