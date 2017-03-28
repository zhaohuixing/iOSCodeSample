//
//  XZBaseObject.m
//
//
#import <XZCareBase/XZBaseObject.h>
#import "XZBaseClassFactory.h"

@implementation XZBaseObject

+(void)RegisterClassType
{
    NSString *className = NSStringFromClass([self class]);
#ifdef DEBUG
    NSLog(@"%@ RegisterClassType is called\n", className);
#endif
    if ([className hasPrefix:@"XZBase"])
    {
        // set default type string (the property is read-only so we have to use the back door)
        NSString* szType = [className substringFromIndex:6];
        [XZBaseClassFactory RegisterBaseClassInformation:szType className:className];
    }
}

- (id)init
{
	if((self = [super init]))
	{
        NSString *className = NSStringFromClass([self class]);
        if ([className hasPrefix:@"XZBase"])
        {
            // set default type string (the property is read-only so we have to use the back door)
            _type = [className substringFromIndex:6];
        }
	}
	return self;
}

#pragma mark Scalar values

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        NSString* szType = [dictionary objectForKey:@"type"];
        if(szType == nil || szType.length <= 0)
        {
            NSString *className = NSStringFromClass([self class]);
            if ([className hasPrefix:@"XZBase"])
            {
                // set default type string (the property is read-only so we have to use the back door)
                _type = [className substringFromIndex:6];
            }
#ifdef DEBUG
            else
            {
                NSAssert(NO, @"XZBaseObject initWithDictionaryRepresentation error for non-XZBase class name");
                return self;
            }
#endif
        }
        else
        {
            NSString* szClassNameValue = [NSString stringWithFormat:@"XZBase%@", szType];
            NSString* className = NSStringFromClass([self class]);
            if([className isEqualToString:szClassNameValue] == YES)
            {
                _type = szType;
            }
#ifdef DEBUG
            else
            {
                NSAssert(NO, @"XZBaseObject initWithDictionaryRepresentation error for the type value not-matching class name");
                return self;
            }
#endif
        }
    }
    
    return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    NSString* szType = [dictionary objectForKey:@"type"];
    if(szType == nil || szType.length <= 0)
    {
        NSString *className = NSStringFromClass([self class]);
        if ([className hasPrefix:@"XZBase"])
        {
            // set default type string (the property is read-only so we have to use the back door)
            _type = [className substringFromIndex:6];
        }
#ifdef DEBUG
        else
        {
            NSAssert(NO, @"XZBaseObject initializeFromDictionaryRepresentation error for non-XZBase class name");
            return;
        }
#endif
    }
    else
    {
        NSString* szClassNameValue = [NSString stringWithFormat:@"XZBase%@", szType];
        NSString* className = NSStringFromClass([self class]);
        if([className isEqualToString:szClassNameValue] == YES)
        {
            _type = szType;
        }
#ifdef DEBUG
        else
        {
            NSAssert(NO, @"XZBaseObject initializeFromDictionaryRepresentation error for the type value not-matching class name");
            return;
        }
#endif
    }
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    
    [dict setObjectIfNotNil:self.type forKey:@"type"];
    
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
    NSLog(@"XZBaseObject DebugLog type:%@", self.type);
}
#endif


@end
