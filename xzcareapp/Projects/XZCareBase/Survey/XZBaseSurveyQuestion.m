//
//  XZBaseSurveyQuestion.m
//
#import "XZBaseSurveyQuestion.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseSurveyQuestion

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
        //self.constraints = [dictionary objectForKey:@"constraints"];
        NSDictionary* constraintsJson = [dictionary objectForKey:@"constraints"];
        if(constraintsJson == nil)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyQuestion initWithDictionaryRepresentation: The representation does not have constrains data set!");
#endif
        }
        else
        {
            self.constraints = (XZBaseSurveyConstraints*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:constraintsJson];
            if(self.constraints == nil)
            {
#ifdef DEBUG
                NSLog(@"XZBaseSurveyQuestion initWithDictionaryRepresentation: failed to create constrains object from representation data");
#endif
            }
        }
        
        self.uiHint = [dictionary objectForKey:@"uiHint"];
        self.detail = [dictionary objectForKey:@"detail"];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    //self.constraints = [dictionary objectForKey:@"constraints"];
    NSDictionary* constraintsJson = [dictionary objectForKey:@"constraints"];
    if(constraintsJson == nil)
    {
#ifdef DEBUG
        NSLog(@"XZBaseSurveyQuestion initializeFromDictionaryRepresentation: The representation does not have constrains data set!");
#endif
    }
    else
    {
        self.constraints = (XZBaseSurveyConstraints*)[XZBaseClassFactory CreateSimpleBaseClassFromRepresentation:constraintsJson];
        if(self.constraints == nil)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyQuestion initializeFromDictionaryRepresentation: failed to create constrains object from representation data");
#endif
        }
    }
    
    self.uiHint = [dictionary objectForKey:@"uiHint"];
    self.detail = [dictionary objectForKey:@"detail"];
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    //[dict setObjectIfNotNil:self.constraints forKey:@"constraints"];
    [dict setObjectIfNotNil:[self.constraints dictionaryRepresentation] forKey:@"constraints"];
    [dict setObjectIfNotNil:self.uiHint forKey:@"uiHint"];
    [dict setObjectIfNotNil:self.detail forKey:@"detail"];

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
    NSLog(@"XZBaseSurvey DebugLog uiHint:%@\n", self.uiHint);
    NSLog(@"XZBaseSurvey DebugLog detail:%@\n", self.detail);
    if(self.constraints)
    {
        [self.constraints DebugLog];
    }
    else
    {
        NSLog(@"XZBaseSurvey DebugLog constraints is null!\n");
    }
}
#endif

@end
