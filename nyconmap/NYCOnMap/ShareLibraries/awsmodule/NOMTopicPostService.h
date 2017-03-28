//
//  NOMTopicPostService.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-27.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMAWSMergeModule.h"
#import "NOMAWSServiceProtocols.h"

@interface NOMTopicPostService : NSObject

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withTopicARN:(NSString*)topicARN withMessage:(NSString*)message;
-(void)StartPost;
-(void)RegisterDelegate:(id<INOMTopicPostServiceDelegate>)delegate;

-(NSString*)GetTopicARN;

@end
