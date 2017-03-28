//
//  XZBaseClassFactory.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-29.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZCareBase.h"

static NSMutableDictionary*   g_ClassRegisteryMap = nil;

@implementation XZBaseClassFactory

+(void)InitializeBaseClassList
{
    [XZBaseResourceList RegisterClassType];
    [XZBaseSchedule RegisterClassType];
    [XZBaseActivity RegisterClassType];
    [XZBaseIdentifierHolder RegisterClassType];
    [XZBaseImage RegisterClassType];
    [XZBaseGuidCreatedOnVersionHolder RegisterClassType];
    [XZBaseObject RegisterClassType];
    
    [XZBaseBooleanConstraints RegisterClassType];
    [XZBaseDateConstraints RegisterClassType];
    [XZBaseDateTimeConstraints RegisterClassType];
    [XZBaseDecimalConstraints RegisterClassType];
    [XZBaseDurationConstraints RegisterClassType];
    [XZBaseIntegerConstraints RegisterClassType];
    [XZBaseMultiValueConstraints RegisterClassType];
    [XZBaseStringConstraints RegisterClassType];
    [XZBaseTimeConstraints RegisterClassType];
    
    [XZBaseSurvey RegisterClassType];
    [XZBaseSurveyAnswer RegisterClassType];
    [XZBaseSurveyConstraints RegisterClassType];
    [XZBaseSurveyElement RegisterClassType];
    [XZBaseSurveyInfoScreen RegisterClassType];
    [XZBaseSurveyQuestion RegisterClassType];
    [XZBaseSurveyQuestionOption RegisterClassType];
    [XZBaseSurveyResponse RegisterClassType];
    [XZBaseSurveyRule RegisterClassType];
    
    [XZBaseAddress RegisterClassType];
    [XZBaseUserProfile RegisterClassType];

    [XZBaseSurveyBooleanAnswer RegisterClassType];
    [XZBaseSurveyStringAnswer RegisterClassType];
    [XZBaseSurveyDateAnswer RegisterClassType];
    [XZBaseSurveyIntegerAnswer RegisterClassType];
    [XZBaseSurveyFloatAnswer RegisterClassType];
}

+(NSMutableDictionary*)GetClassRegisteryMap
{
    if(g_ClassRegisteryMap == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            g_ClassRegisteryMap = [[NSMutableDictionary alloc] init];
            assert(g_ClassRegisteryMap != nil);
        });
    }
    return g_ClassRegisteryMap;
}

+(void)RegisterBaseClassInformation:(NSString*)szType className:(NSString*)szClassName
{
    NSMutableDictionary* classMap = [XZBaseClassFactory GetClassRegisteryMap];
    [classMap setObject:szClassName forKey:szType];
}

+(void)RegisterBaseClass:(NSString*)szType class:(Class)baseClase
{
    NSMutableDictionary* classMap = [XZBaseClassFactory GetClassRegisteryMap];
    NSString* szClassName = NSStringFromClass(baseClase);
    [classMap setObject:szClassName forKey:szType];
}

+(NSString*)GetBaseClassName:(NSString*)szType
{
    NSMutableDictionary* classMap = [XZBaseClassFactory GetClassRegisteryMap];
    NSString* szClassName = [classMap objectForKey:szType];
    if(szClassName == nil || szClassName.length <= 0)
    {
        szClassName = [NSString stringWithFormat:@"XZBase%@", szType];
        [classMap setObject:szClassName forKey:szType];
    }
    return szClassName;
}

+(Class)GetBaseClass:(NSString*)szType
{
    NSMutableDictionary* classMap = [XZBaseClassFactory GetClassRegisteryMap];
    NSString* szClassName = [classMap objectForKey:szType];
    if(szClassName == nil || szClassName.length <= 0)
    {
        szClassName = [NSString stringWithFormat:@"XZBase%@", szType];
    }
    Class baseClass = Nil;
    baseClass = NSClassFromString(szClassName);
    
    return baseClass;
}

+(instancetype)CreateSimpleBaseClassFromType:(NSString*)szType
{
    id baseObject = nil;
    Class baseClass = [XZBaseClassFactory GetBaseClass:szType];
    if(baseClass != Nil)
    {
        baseObject = [baseClass new];
    }
    else
    {
#ifdef DEBUG
        NSAssert(NO, @"XZBaseClassFactory CreateSimpleBaseClassFromType: The type \'%@\' does not have the register class!", szType);
#endif
    }
    
    return baseObject;
}

+(instancetype)CreateSimpleBaseClassFromRepresentation:(NSDictionary*)presentation
{
    id baseObject = nil;
    NSString* szType = [presentation objectForKey:@"type"];
    if(szType == nil || szType.length <= 0)
    {
#ifdef DEBUG
        NSAssert(NO, @"XZBaseClassFactory CreateSimpleBaseClassFromRepresentation: presentation no type value!");
#endif
        return baseObject;
    }
    Class baseClass = [XZBaseClassFactory GetBaseClass:szType];
    if(baseClass != Nil)
    {
        baseObject = [baseClass new];
        SEL sel = @selector(initializeFromDictionaryRepresentation:);
        NSMethodSignature *msgSignature = [baseClass instanceMethodSignatureForSelector:sel];
        NSInvocation *initiInvocation = [NSInvocation invocationWithMethodSignature:msgSignature];
        [initiInvocation setSelector:sel];
        [initiInvocation setTarget:baseObject];
        // no specific class; just stuff the raw json in there directly
        [initiInvocation setArgument:&presentation atIndex:2];
        [initiInvocation invoke];
    }
    else
    {
#ifdef DEBUG
        NSAssert(NO, @"XZBaseClassFactory CreateSimpleBaseClassFromRepresentation: class type not found!");
#endif
    }
    
    return baseObject;
}

@end
