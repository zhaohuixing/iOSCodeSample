//
//  NOMNewsMessageQSubscribeService.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-12-12.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AmazonClientManager.h"
#import "NOMAWSServiceProtocols.h"

@interface NOMNewsMessageQSubscribeService : NSObject

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withSQSClient:(AmazonSQSClient*)sqsClient withTopic:(NSString*)topicARN withQueueURL:(NSString*)queueURL;
-(void)RegisterDelegate:(id<INOMNewsMessageQSubscribeDelegate>)delegate;
-(void)Start;

@end
