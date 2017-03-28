//
//  NOMTimingService.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-11-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "INOMTimingServiceRecipient.h"

@interface NOMTimingService : NSObject

-(void)Initialize;
-(void)Release;
-(void)RegisterServiceRecipient:(id<INOMTimingServiceRecipient>)recipient;

@end
