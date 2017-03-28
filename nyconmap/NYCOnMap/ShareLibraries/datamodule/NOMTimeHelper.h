//
//  NOMTimeHelper.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMTimeHelper : NSObject

+(int64_t)ConvertNSDateToInteger:(NSDate*)date;
+(NSDate*)ConertIntegerToNSDate:(int64_t)nTime;
+(int64_t)CurrentTimeInInteger;

@end
