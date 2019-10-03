//
//  GUIEventLoop.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GUIEventLoop.h"


@implementation GUIEventLoop

+(NSString*)TranslateEventID:(int)event
{
	NSString* eventName = [NSString stringWithFormat:@"GUIEVENTID_%i", event];
	return eventName;
}	

+(void)RegisterEvent:(int)event eventHandler:(SEL)handler eventReceiver:(id)observer eventSender:(id)sender
{
	NSString* eventID = [GUIEventLoop TranslateEventID:event];
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:handler name:eventID object:sender];		
}

+(void)SendEvent:(int)event eventSender:(id)sender
{
	NSString* eventID = [GUIEventLoop TranslateEventID:event];
	[[NSNotificationCenter defaultCenter] postNotificationName:eventID object:sender];
}

+(void)PostEvent:(int)event
{
	NSString* eventID = [GUIEventLoop TranslateEventID:event];
	[[NSNotificationCenter defaultCenter] postNotificationName:eventID object:nil];
}

+(void)RemoveEvent:(int)event eventReceiver:(id)observer eventSender:(id)sender
{
	NSString* eventID = [GUIEventLoop TranslateEventID:event];
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:eventID object:sender];	
}

@end
