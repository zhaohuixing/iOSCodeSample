//
//  NOMNewsMessageQCreateService.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-19.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AmazonClientManager.h"
#import "NOMAWSServiceProtocols.h"

@interface NOMNewsMessageQCreateService : NSObject

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withSQSClient:(AmazonSQSClient*)sqsClient withTopic:(NSString*)topicARN withName:(NSString*)queueName withRetentionTime:(int)nRetentionTimeInSecond;
-(void)RegisterDelegate:(id<INOMNewsMessageQCreationDelegate>)delegate;
-(NSString*)GetTrafficMessageQueueURL;
-(void)Start;

@end
