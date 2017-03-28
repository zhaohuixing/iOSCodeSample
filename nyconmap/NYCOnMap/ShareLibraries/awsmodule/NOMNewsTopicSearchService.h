//
//  NOMNewsTopicSearchService.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-17.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMAWSMergeModule.h"
#import "NOMAWSServiceProtocols.h"

@interface NOMNewsTopicSearchService : NSObject

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withTopic:(NSString*)topicName;
-(NSString*)GetTopicARN;
-(NSString*)GetTopicName;

-(void)RegisterDelegate:(id<INOMNewsTopicSearchDelegate>)delegate;
-(void)Start;

@end
