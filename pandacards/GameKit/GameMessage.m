//
//  GameMessage.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GameMessage.h"
#import <AVFoundation/AVFoundation.h>
#import "NSObject+SBJSON.h"
#import "SBJSON.h"
#include "GameMsgConstant.h"


@implementation GameMessage

@synthesize m_GameMessage = _m_GameMessage;

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        _m_GameMessage = @"";
        m_MessageStream = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)Reset
{
    //int n = [m_MessageStream removeAllObjects];
    [m_MessageStream removeAllObjects];
}

-(void)FormatMessage
{
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	_m_GameMessage = [jsonWriter stringWithObject:m_MessageStream];
}

-(void)AddMessage:(NSString*)szKey withString:(NSString*)szText
{
    [m_MessageStream setObject:szText forKey:szKey];
}

-(void)AddMessage:(NSString*)szKey withNumber:(NSNumber*)number
{
    [m_MessageStream setObject:number forKey:szKey];
}

-(void)AddMessage:(NSString*)szKey withArray:(NSArray*)Array
{
    [m_MessageStream setObject:Array forKey:szKey];
}

-(void)AddMessage:(NSString*)szKey withDictionary:(NSDictionary*)dict
{
    [m_MessageStream setObject:dict forKey:szKey];
}

-(void)dealloc
{
    [m_MessageStream release];
    [super dealloc];
}

@end
