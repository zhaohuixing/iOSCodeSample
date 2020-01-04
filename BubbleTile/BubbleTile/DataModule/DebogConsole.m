//
//  DebogConsole.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "DebogConsole.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "MainUIController.h"

@implementation DebogConsole

+(BOOL)IsEnabled
{
#ifdef DEBUG
    return YES;
#endif
    return NO;
}

+(void)ShowDebugMsg:(NSString*)msg
{
#ifdef DEBUG
    [(MainUIController*)[GUILayout GetMainViewController] ShowDebugMessage:msg];
#endif
}

@end
