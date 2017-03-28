//
//  NOMNewsMobileEndPointARNCreateService.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-22.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMAWSMergeModule.h"
#import "NOMAWSServiceProtocols.h"

@interface NOMNewsMobileEndPointARNCreateService : NSObject

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withDeviceToken:(NSString*)deviceToken;
-(NSString*)GetEndPointARN;
-(void)RegisterDelegate:(id<INOMMobileEndPointARNCreationDelegate>)delegate;
-(void)Start;

@end
