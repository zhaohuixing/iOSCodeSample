//
//  NOMOperationManager.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-03.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMOperationManager.h"

#define OPERATIONDELAY                          @"operationDelay"
#define ISOPERATIONFINISHED                     @"isFinished"
#define ISOPERATIONEXECUTING                    @"isExecuting"

static NOMOperationManager*    g_NOMOperationManager = nil;

@interface NOMOperationManager ()
{
    NSOperationQueue *                      _m_OperationQueue;
    NSUInteger                              _m_ActiveOperationCount;
    id<NOMOperationCompleteDelegate>        _m_Delegate;
}

@end

@implementation NOMOperationManager

- (id)init
{
    // any thread, but serialised by +sharedManager
    self = [super init];
    if (self != nil)
    {
        _m_OperationQueue = [[NSOperationQueue alloc] init]; //[NSOperationQueue new]; 
        assert(_m_OperationQueue != nil);
        
        _m_Delegate = nil;
        
        _m_ActiveOperationCount = 0;
        
    }
    return self;
}

-(void)SetOperationDelegate:(id<NOMOperationCompleteDelegate>)delegate
{
    _m_Delegate = delegate;
}

- (BOOL)isCompleted
{
    BOOL bRet = YES;
    if(self->_m_OperationQueue != nil)
    {
        bRet = [self->_m_OperationQueue operationCount] == 0;
    }
    return bRet;
}

//- (void)addOperation:(NSOperation *)operation toQueue:(NSOperationQueue *)queue finishedTarget:(id)target action:(SEL)action
// Core code to enqueue an operation on a queue.
- (void)addOperation:(NSOperation *)operation
{
    // any thread
    assert(operation != nil);
    
    [operation addObserver:self forKeyPath:ISOPERATIONFINISHED options:0 context:(void*)_m_OperationQueue];
    
    // Queue the operation.  When the operation completes, -operationDone: is called.
    [_m_OperationQueue addOperation:operation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // any thread
    if ( [keyPath isEqual:ISOPERATIONFINISHED] )
    {
        NSOperation *       operation;
        
        operation = (NSOperation *) object;
        assert([operation isKindOfClass:[NSOperation class]]);
        assert([operation isFinished]);
        
        [operation removeObserver:self forKeyPath:ISOPERATIONFINISHED];
        
        if ( ! [operation isCancelled] )
        {
            [self operationDone:operation];
        }
    }
    else if (NO)
    {   // Disabled because the super class does nothing useful with it.
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)operationDone:(NSOperation *)operation
{
    // any thread
    assert(operation != nil);

    if(_m_Delegate != nil)
    {
        [_m_Delegate OperationDone:operation];
    }
}

- (void)cancelOperation:(NSOperation *)operation
{
    if (operation != nil)
    {
        [operation cancel];
    }
}

- (void)cancelAllOperations
{
    if(_m_OperationQueue != nil)
    {
        [_m_OperationQueue cancelAllOperations];
    }
}
@end
