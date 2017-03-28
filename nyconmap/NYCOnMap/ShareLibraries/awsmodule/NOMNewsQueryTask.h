//
//  NOMNewsQueryTask.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-07-20.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AmazonClientManager.h"
#import "NOMAWSServiceProtocols.h"


@interface NOMNewsQueryTask : NSObject

-(id)initWithSQSClient:(AmazonSQSClient*)sqsClient withQueueURL:(NSString*)queueURL;
-(void)SetQueryTimeThreshold:(int64_t)nTimeStep;
-(void)StartQuery;
-(void)RegisterDelegate:(id<INOMNewsQueryTaskDelegate>)delegate;
-(NSArray*)GetQueryMessages;


@end
