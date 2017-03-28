//
//  XZBaseClassFactory.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-29.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZBaseClassFactory : NSObject

+(void)InitializeBaseClassList;
+(void)RegisterBaseClassInformation:(NSString*)szType className:(NSString*)szClassName;
+(void)RegisterBaseClass:(NSString*)szType class:(Class)baseClase;
+(NSString*)GetBaseClassName:(NSString*)szType;
+(Class)GetBaseClass:(NSString*)szType;
+(instancetype)CreateSimpleBaseClassFromType:(NSString*)szType;
+(instancetype)CreateSimpleBaseClassFromRepresentation:(NSDictionary*)presentation;

@end
