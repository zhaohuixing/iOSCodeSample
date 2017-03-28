//
//  NOMOperationManager.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-03.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMOperationCompleteDelegate.h"

@interface NOMOperationManager : NSObject

- (void)addOperation:(NSOperation *)operation;
- (void)cancelOperation:(NSOperation *)operation;
- (void)cancelAllOperations;
- (BOOL)isCompleted;

-(void)SetOperationDelegate:(id<NOMOperationCompleteDelegate>)delegate;


@end
