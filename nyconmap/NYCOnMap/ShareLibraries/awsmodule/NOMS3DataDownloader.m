//
//  NOMS3DataDownloader.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-11.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMS3DataDownloader.h"
#import "AmazonClientManager.h"
/******************************************************************************
*******************************************************************************
*******************************************************************************
*******************************************************************************
*
*
*
*
*   NOMS3DataDownloader
*
*
*
*
*******************************************************************************
*******************************************************************************
*******************************************************************************
*******************************************************************************/

@interface NOMS3DataDownloader ()
{
@private
    NSData*             m_Source;               //output
    NSString*           m_ContentType;          //input
    NSString*           m_S3Bucket;             //input
    NSString*           m_FileKey;              //input
    NSURL*              m_DestinationFile;
    
    
    AmazonS3Client*     m_S3Client;
    
    id<INOMS3DataDownloaderDelegate>     m_Delegate;
}
@end

@implementation NOMS3DataDownloader

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_Source = nil;
        m_S3Bucket = nil;
        m_FileKey = nil;
        m_ContentType = nil;
        m_DestinationFile = nil;
        
        m_S3Client = nil; //[AmazonClientManager CreateS3Client];
        m_Delegate = nil;
    }
    return self;
}

-(void)Finish
{
}

-(void)AssignDelegate:(id<INOMS3DataDownloaderDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)SetSource:(NSString*)contentType withS3Bucket:(NSString*)bucket withS3Key:(NSString*)fileKey withDestination:(NSURL*)destFile
{
    m_Source = nil;
    m_S3Bucket = bucket;
    m_FileKey = fileKey;
    m_ContentType = contentType;
    m_DestinationFile = destFile;
}

-(void)initialize
{
    m_Source = nil;
}

-(void)ServiceSucceeded
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(ServiceSucceeded) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(m_Delegate != nil)
    {
        [m_Delegate NOMS3DataDownloadDone:self withResult:YES];
    }
}

-(void)ServiceFailed
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(ServiceFailed) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(m_Delegate != nil)
    {
        [m_Delegate NOMS3DataDownloadDone:self withResult:NO];
    }
}

-(void)DownloadByS3TransferManager
{
    AWSS3TransferManagerDownloadRequest* downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    downloadRequest.bucket = m_S3Bucket;
    downloadRequest.key = m_FileKey;
    downloadRequest.downloadingFileURL = m_DestinationFile;
    downloadRequest.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite)
    {
        return;
    };

    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    [[[transferManager download:downloadRequest] continueWithBlock:^id(BFTask *task)
    {
        if (task.error != nil)
        {
            [self ServiceFailed];
        }
        else
        {
            [self ServiceSucceeded];
        }
        return nil;
    }] waitUntilFinished];
}

-(void)start
{
    if(m_FileKey == nil || [m_FileKey length] <= 0 || m_S3Bucket == nil || [m_S3Bucket length] <= 0 || m_ContentType == nil || [m_ContentType length] <= 0 || m_S3Client == nil || m_DestinationFile == nil)
    {
        if(m_Delegate != nil)
        {
            [m_Delegate NOMS3DataDownloadDone:self withResult:NO];
        }
        return;
    }
    
    [self initialize];
    
//    [self DownloadByS3TransferManager];
/*
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void)
    {
        @try
        {
            // Puts the file as an object in the bucket.
            S3GetObjectRequest *getObjectRequest = [[S3GetObjectRequest alloc] initWithKey:m_FileKey withBucket:m_S3Bucket];
            getObjectRequest.delegate = nil;
        
            S3GetObjectResponse* response = [m_S3Client getObject:getObjectRequest];
            if(response != nil && response.error == nil)
            {
                m_bSuccess = YES;
                [self Finish];
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
                    if(m_Delegate != nil)
                    {
                        [m_Delegate NOMS3DataDownloadDone:self withResult:YES];
                    }
                });
            }
            else
            {
                m_bSuccess = NO;
                [self Finish];
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
                    if(m_Delegate != nil)
                    {
                        [m_Delegate NOMS3DataDownloadDone:self withResult:NO];
                    }
                });
            }
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"NOMS3DataDownloader Exception : [%@]", exception);
            m_bSuccess = NO;
            [self Finish];
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                if(m_Delegate != nil)
                {
                    [m_Delegate NOMS3DataDownloadDone:self withResult:NO];
                }
            });
        }
    });
*/ 
}

-(NSString*)GetFileKey
{
    return m_FileKey;
}

-(NSString*)GetContentType
{
    return m_ContentType;
}

-(NSString*)GetBucket
{
    return m_S3Bucket;
}

-(NSData*)GetData
{
    return m_Source;
}

-(void)Start
{
    if(m_FileKey == nil || [m_FileKey length] <= 0 || m_S3Bucket == nil || [m_S3Bucket length] <= 0 || m_ContentType == nil || [m_ContentType length] <= 0 || m_DestinationFile == nil)
    {
        if(m_Delegate != nil)
        {
            [m_Delegate NOMS3DataDownloadDone:self withResult:NO];
        }
        return;
    }
    
    [self initialize];
    
    [self DownloadByS3TransferManager];
}

@end

