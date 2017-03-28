//
//  XZBaseSurveyInfoScreen.m
//
#import "XZBaseSurveyInfoScreen.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseSurveyInfoScreen

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
        //self.image = [dictionary objectForKey:@"image"];
        NSDictionary* imageJson = [dictionary objectForKey:@"image"];
        if(imageJson == nil)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyInfoScreen initWithDictionaryRepresentation: The representation does not have image data set!");
#endif
        }
        else
        {
            self.image = (XZBaseImage*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:imageJson];
            if(self.image == nil)
            {
#ifdef DEBUG
                NSLog(@"XZBaseSurveyInfoScreen initWithDictionaryRepresentation: falied to create image object from representation data");
#endif
            }
        }
        self.title = [dictionary objectForKey:@"title"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    //self.image = [dictionary objectForKey:@"image"];
    NSDictionary* imageJson = [dictionary objectForKey:@"image"];
    if(imageJson == nil)
    {
#ifdef DEBUG
        NSLog(@"XZBaseSurveyInfoScreen initializeFromDictionaryRepresentation: The representation does not have image data set!");
#endif
    }
    else
    {
        self.image = (XZBaseImage*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:imageJson];
        if(self.image == nil)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyInfoScreen initializeFromDictionaryRepresentation: falied to create image object from representation data");
#endif
        }
    }
    
    self.title = [dictionary objectForKey:@"title"];
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    if(self.image)
    {
        [dict setObjectIfNotNil:[self.image dictionaryRepresentation] forKey:@"image"];
    }
    [dict setObjectIfNotNil:self.title forKey:@"title"];

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
    NSLog(@"XZBaseSurveyInfoScreen DebugLog title:%@\n", self.title);
    if(self.image)
    {
        [self.image DebugLog];
    }
    else
    {
        NSLog(@"XZBaseSurveyInfoScreen DebugLog image is null!\n");
    }
}
#endif

@end
