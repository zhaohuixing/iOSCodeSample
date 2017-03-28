//
//  AmazonServiceConfiguration.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-05-24.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmazonServiceConfiguration : NSObject

+(void)SetNOMDBSystemType:(int)nDBType;
+(int)GetNOMDBSystemType;
+(BOOL)IsNOMUsingSimpleDB;
+(BOOL)IsNOMDBSystemInvalid;

@end
