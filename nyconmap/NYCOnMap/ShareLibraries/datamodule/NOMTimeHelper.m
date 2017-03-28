//
//  NOMTimeHelper.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMTimeHelper.h"

@implementation NOMTimeHelper

+(int64_t)ConvertNSDateToInteger:(NSDate*)date
{
    int64_t nTime = -1;
    if(date != nil)
    {
        NSTimeInterval curTime = [date timeIntervalSince1970];
        nTime = (int64_t)curTime;
    }
    return nTime;
}

+(NSDate*)ConertIntegerToNSDate:(int64_t)nTime
{
    NSTimeInterval newTime = (double)nTime;
    NSDate *nowday = [NSDate dateWithTimeIntervalSince1970:newTime];
    return nowday;
}

+(int64_t)CurrentTimeInInteger
{
    int64_t nTime = -1;
    NSDate* today = [NSDate date];
    nTime = [NOMTimeHelper ConvertNSDateToInteger:today];
    return nTime;
}

@end
