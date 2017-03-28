//
//  NOMNewsMobileDeviceSubscribeService.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-22.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMAWSMergeModule.h"
#import "NOMAWSServiceProtocols.h"


@interface NOMNewsMobileDeviceSubscribeService : NSObject

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withTopic:(NSString*)topicARN withEndPoint:(NSString*)endpointARN;

-(void)RegisterDelegate:(id<INOMMobileDeviceSubscribeDelegate>)delegate;
-(void)Start;

-(NSString*)GetTopicARN;

@end
