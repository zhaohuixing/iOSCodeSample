//
//  NSJSONSerialization+GameHelper.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 2015-11-07.
//  Copyright © 2015 Zhaohui Xing. All rights reserved.
//

#import "NSJSONSerialization+GameHelper.h"

@implementation NSJSONSerialization (GameHelper)

+(NSString*)FormatJSONString:(NSDictionary*)dataSet
{
    NSString* szJSON = nil;
    NSData* pJSON = nil;
    if(dataSet != nil && [NSJSONSerialization isValidJSONObject:dataSet] == YES)
    {
        NSLog(@"Proper JSON Object");
        NSError* error = nil;
        pJSON = [NSJSONSerialization dataWithJSONObject:dataSet options:NSJSONWritingPrettyPrinted error:&error];
        if(error != nil)
        {
            pJSON = nil;
            NSLog(@"Failed to generate JSON object:%@", error);
        }
        szJSON = [[NSString alloc] initWithData:pJSON encoding:NSUTF8StringEncoding];
        NSLog(@"JSON string:%@", szJSON);
    }
    return szJSON;
}

@end
