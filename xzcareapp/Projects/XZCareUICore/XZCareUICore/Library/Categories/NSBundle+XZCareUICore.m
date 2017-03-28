//
//  NSBundle(XZCareUICore).m
//  XZCareUICore
//
//  Created by Zhaohui Xing on 2015-07-15.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "NSBundle+XZCareUICore.h"

@implementation NSBundle (XZCareUICore)

#define kXZCareUICoreBundleID                                  @"com.xz-care.XZCareUICore"

+ (NSBundle *) XZCareUICoreBundle
{
    NSBundle *bundle = [NSBundle bundleWithIdentifier:kXZCareUICoreBundleID];
    return bundle;
}

@end
