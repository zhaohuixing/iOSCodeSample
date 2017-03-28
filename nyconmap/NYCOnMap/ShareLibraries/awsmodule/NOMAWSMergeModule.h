//
//  NOMAWSMergeModule.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-11-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#ifndef __NOMAWSMERGEMODULE_H__
#define __NOMAWSMERGEMODULE_H__

//
//This is the set of classes to merge old AWS v1 APIs into new AWS v2
//

@interface AmazonSimpleDBClient : AWSSimpleDB

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration;
- (instancetype)initWithDefaultConfiguration;

@end

@interface AmazonS3Client : AWSS3

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration;
- (instancetype)initWithDefaultConfiguration;

@end


@interface AmazonSQSClient : AWSSQS

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration;
- (instancetype)initWithDefaultConfiguration;

@end

@interface AmazonSNSClient : AWSSNS

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration;
- (instancetype)initWithDefaultConfiguration;

@end

@interface AmazonSESClient : AWSSES

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration;
- (instancetype)initWithDefaultConfiguration;

@end


#endif
