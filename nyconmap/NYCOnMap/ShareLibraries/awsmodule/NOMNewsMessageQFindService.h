//
//  NOMNewsMessageQFindService.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-20.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMAWSMergeModule.h"
#import "AmazonClientManager.h"
#import "NOMAWSServiceProtocols.h"

@interface NOMNewsMessageQFindService : NSObject

-(id)initWithSQSClient:(AmazonSQSClient*)sqsClient withName:(NSString*)queueName;
-(void)RegisterDelegate:(id<INOMNewsMessageQFindDelegate>)delegate;

-(NSString*)GetTrafficMessageQueueURL;
-(void)Start;

@end
