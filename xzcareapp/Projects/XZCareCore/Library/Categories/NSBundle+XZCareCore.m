//
//  NSBundle(XZCareCore).m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-15.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "NSBundle+XZCareCore.h"
#import "XZCareConstants.h"

@implementation NSBundle (XZCareCore)

+ (NSBundle *) XZCareCoreBundle
{
#ifndef _USE_APP_BUNDLE__
    NSBundle *bundle = [NSBundle bundleWithIdentifier:kXZCareAppCoreBundleID];
    return bundle;
#else
    NSBundle *bundle = [NSBundle mainBundle];
    return bundle;
#endif
}

@end
