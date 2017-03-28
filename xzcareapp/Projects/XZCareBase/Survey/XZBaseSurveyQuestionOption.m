//
//  XZBaseSurveyQuestionOption.m
//
#import "XZBaseSurveyQuestionOption.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseSurveyQuestionOption

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
        self.detail = [dictionary objectForKey:@"detail"];
        //self.image = [dictionary objectForKey:@"image"];
        self.label = [dictionary objectForKey:@"label"];
        self.value = [dictionary objectForKey:@"value"];
        NSDictionary* imageJson = [dictionary objectForKey:@"image"];
        if(imageJson == nil)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyQuestionOption initWithDictionaryRepresentation: The representation does not have image data set!");
#endif
        }
        else
        {
            self.image = (XZBaseImage*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:imageJson];
            if(self.image == nil)
            {
#ifdef DEBUG
                NSLog(@"XZBaseSurveyQuestionOption initWithDictionaryRepresentation: falied to create image object from representation data");
#endif
            }
        }
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.detail = [dictionary objectForKey:@"detail"];
    //self.image = [dictionary objectForKey:@"image"];
    self.label = [dictionary objectForKey:@"label"];
    self.value = [dictionary objectForKey:@"value"];
    NSDictionary* imageJson = [dictionary objectForKey:@"image"];
    if(imageJson == nil)
    {
#ifdef DEBUG
        NSLog(@"XZBaseSurveyQuestionOption initializeFromDictionaryRepresentation: The representation does not have image data set!");
#endif
    }
    else
    {
        self.image = (XZBaseImage*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:imageJson];
        if(self.image == nil)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyQuestionOption initializeFromDictionaryRepresentation: falied to create image object from representation data");
#endif
        }
    }

}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.detail forKey:@"detail"];
    if(self.image)
    {
        [dict setObjectIfNotNil:[self.image dictionaryRepresentation] forKey:@"image"];
    }
    [dict setObjectIfNotNil:self.label forKey:@"label"];
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
    NSLog(@"XZBaseSurveyQuestionOption DebugLog detail:%@\n", self.detail);
    NSLog(@"XZBaseSurveyQuestionOption DebugLog label:%@\n", self.label);
    NSLog(@"XZBaseSurveyQuestionOption DebugLog value:%@\n", self.value);
    if(self.image)
    {
        [self.image DebugLog];
    }
    else
    {
        NSLog(@"XZBaseSurveyQuestionOption DebugLog image is null!\n");
    }
}
#endif

@end
