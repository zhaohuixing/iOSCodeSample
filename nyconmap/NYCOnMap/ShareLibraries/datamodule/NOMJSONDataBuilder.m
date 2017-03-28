//
//  NOMJSONDataBuilder.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-07.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "NOMJSONDataBuilder.h"

@implementation NOMJSONDataBuilder

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_DataSet = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)Add:(NSString*)szKey withObject:(id)object
{
    [m_DataSet setObject:object forKey:szKey];
}


-(NSData*)CreateJSONData
{
    NSData* pJSON = nil;
    if(m_DataSet != nil && [NSJSONSerialization isValidJSONObject:m_DataSet] == YES)
    {
        NSLog(@"Proper JSON Object");
        NSError* error = nil;
        pJSON = [NSJSONSerialization dataWithJSONObject:m_DataSet options:NSJSONWritingPrettyPrinted error:&error];
        if(error != nil)
        {
            pJSON = nil;
            NSLog(@"Failed to generate JSON object:%@", error);
        }
        NSString *string = [[NSString alloc] initWithData:pJSON encoding:NSUTF8StringEncoding];
        NSLog(@"JSON string:%@", string);
        
    }

    return pJSON;
}

-(NSString*)GetJSONString
{
    NSString *string = nil;
    NSData* pJSON = nil;
    if(m_DataSet != nil && [NSJSONSerialization isValidJSONObject:m_DataSet] == YES)
    {
        NSLog(@"Proper JSON Object");
        NSError* error = nil;
        pJSON = [NSJSONSerialization dataWithJSONObject:m_DataSet options:NSJSONWritingPrettyPrinted error:&error];
        if(error != nil)
        {
            pJSON = nil;
            NSLog(@"Failed to generate JSON object:%@", error);
        }
        string = [[NSString alloc] initWithData:pJSON encoding:NSUTF8StringEncoding];
        NSLog(@"JSON string:%@", string);
        
    }
    
    return string;
}


@end
