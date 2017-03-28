/*
 *  AmazonClientManager.h
 *  newsonmap
 *
 *  Created by Zhaohui Xing on 2013-05-23.
 *  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "NOMAWSMergeModule.h"

@interface AmazonClientManager:NSObject
{
}


+(AmazonSimpleDBClient *)CreateSimpleDBClient;
+(AmazonS3Client *)CreateS3Client;
+(AmazonSQSClient *)CreateSQSClient;
+(AmazonSNSClient *)CreateSNSClient;
+(AmazonSESClient *)CreateSESClient;

+(BOOL)isAWSAvaliable;
+(void)setAWSAvaliable:(BOOL)bOK;

+(AmazonClientManager*)GetSharedManager;
-(void)InitializeAccess;
@end
