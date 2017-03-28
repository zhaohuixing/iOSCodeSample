//
//  NOMOperationCompleteDelegate.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-24.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NOMOperationCompleteDelegate <NSObject>

@optional

-(void)OperationDone:(NSOperation *)operation;

@end
