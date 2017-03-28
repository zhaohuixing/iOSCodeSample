//
//  NOMS3DataUploader.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-09.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "NOMS3DataUploader.h"
#import "AmazonClientManager.h"

/******************************************************************************
*******************************************************************************
*******************************************************************************
*******************************************************************************
*
*
*
*
*   NOMS3DataUploaderAsyn
*
*
*
*
*******************************************************************************
*******************************************************************************
*******************************************************************************
*******************************************************************************/

@interface NOMS3DataUploaderAsyn ()
{
    NSData*                         m_Source;
    NSString*                       m_ContentType;
    NSString*                       m_S3Bucket;
    NSString*                       m_FileKey;
    
    BOOL                            m_bMewsMainFile;
    id<INOMS3DataUploaderDelegate>   m_Delegate;
    AmazonS3Client*                 m_S3Client;
}

@end

@implementation NOMS3DataUploaderAsyn

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_Source = nil;
        m_S3Bucket = nil;
        m_FileKey = nil;
        m_ContentType = nil;
        m_Delegate = nil;
        m_bMewsMainFile = NO;
        m_S3Client = [AmazonClientManager CreateS3Client];
    }
    return self;
}

-(void)AssignDelegate:(id<INOMS3DataUploaderDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)SetSource:(NSData*)data withContentType:(NSString*)type withS3Bucket:(NSString*)bucket withS3Key:(NSString*)fileKey
{
    m_Source = data;
    m_S3Bucket = bucket;
    m_FileKey = fileKey;
    m_ContentType = type;
}

-(NSString*)GetFileKey
{
    return m_FileKey;
}

-(NSString*)GetBucket
{
    return m_S3Bucket;
}

-(NSString*)GetContentType
{
    return m_ContentType;
}

-(BOOL)IsNewsMainFile
{
    return m_bMewsMainFile;
}

-(void)SetAsNewsMainFile:(BOOL)bMainFile
{
    m_bMewsMainFile = bMainFile;
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate NOMS3DataUploadDone:self withResult:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate NOMS3DataUploadDone:self withResult:NO];
    }
}

-(void)start
{
    if(m_FileKey == nil || [m_FileKey length] <= 0 || m_Source == nil || m_S3Bucket == nil || [m_S3Bucket length] <= 0 || m_ContentType == nil || [m_ContentType length] <= 0 || m_S3Client == nil)
    {
        [self ServiceFailed];
        return;
    }

    AWSS3CreateBucketRequest *createBucketRequest = [AWSS3CreateBucketRequest new];
    createBucketRequest.bucket = m_S3Bucket;
    
    [[[m_S3Client createBucket:createBucketRequest] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
#ifdef DEBUG
            NSLog(@"NOMS3DataUploaderAsyn create bucket task error : %@", task.error);
#endif
        }
        return nil;
    }] continueWithExecutor:[BFExecutor immediateExecutor] withBlock:^id(BFTask *task)
    {
        AWSS3PutObjectRequest *putObjectRequest = [AWSS3PutObjectRequest new];
        
        putObjectRequest.key = m_FileKey;
        putObjectRequest.bucket = m_S3Bucket;
        putObjectRequest.body = m_Source;
        putObjectRequest.contentType = m_ContentType;
        putObjectRequest.contentLength = [[NSNumber alloc] initWithUnsignedInteger:m_Source.length];
        
        [[[m_S3Client putObject:putObjectRequest] continueWithBlock:^id(BFTask *task)
        {
            if (task.error)
            {
#ifdef DEBUG
                NSLog(@"NOMS3DataUploaderAsyn put object task error : %@", task.error);
#endif
                [self ServiceFailed];
                return nil;
            }
            if (task.result)
            {
                if([task.result isKindOfClass:[AWSS3PutObjectOutput class]] == YES)
                {
                    AWSS3PutObjectOutput* response = task.result;
#ifdef DEBUG
                    NSLog(@"AWSS3PutObjectOutput ETag:%@  SSECustomerAlgorithm:%@  SSECustomerKeyMD5:%@\n", response.ETag, response.SSECustomerAlgorithm, response.SSECustomerKeyMD5);
#endif
                }
            }
            [self ServiceSucceeded];
            return nil;
        }] waitUntilFinished];
        
        return nil;
    }];
}

-(void)Start
{
    [self start];
}

@end
