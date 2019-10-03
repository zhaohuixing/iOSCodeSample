//
//  GameMessage.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GameMessage.h"


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
    _m_GameMessage = nil;
    NSData* pJSON = nil;
    if(m_MessageStream != nil && [NSJSONSerialization isValidJSONObject:m_MessageStream] == YES)
    {
        NSLog(@"Proper JSON Object");
        NSError* error = nil;
        pJSON = [NSJSONSerialization dataWithJSONObject:m_MessageStream options:NSJSONWritingPrettyPrinted error:&error];
        if(error != nil)
        {
            pJSON = nil;
            NSLog(@"Failed to generate JSON object:%@", error);
        }
        _m_GameMessage = [[NSString alloc] initWithData:pJSON encoding:NSUTF8StringEncoding];
        NSLog(@"JSON string:%@", _m_GameMessage);
    }
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
    m_MessageStream = nil;
}

@end
