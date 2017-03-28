//
//  NOMAWSMergeModule.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-11-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMAWSMergeModule.h"

@implementation AmazonSimpleDBClient

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration
{
    self = [super initWithConfiguration:configuration];
    
    return self;
}

- (instancetype)initWithDefaultConfiguration
{
    self = [super initWithConfiguration:[AWSServiceManager defaultServiceManager].defaultServiceConfiguration];
    
    return self;
}

@end


@implementation AmazonS3Client

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration
{
    self = [super initWithConfiguration:configuration];
    
    return self;
}

- (instancetype)initWithDefaultConfiguration
{
    self = [super initWithConfiguration:[AWSServiceManager defaultServiceManager].defaultServiceConfiguration];
    
    return self;
}

@end


@implementation AmazonSQSClient

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration
{
    self = [super initWithConfiguration:configuration];
    
    return self;
}

- (instancetype)initWithDefaultConfiguration
{
    self = [super initWithConfiguration:[AWSServiceManager defaultServiceManager].defaultServiceConfiguration];
    
    return self;
}

@end

@implementation AmazonSNSClient

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration
{
    self = [super initWithConfiguration:configuration];
    
    return self;
}

- (instancetype)initWithDefaultConfiguration
{
    self = [super initWithConfiguration:[AWSServiceManager defaultServiceManager].defaultServiceConfiguration];
    
    return self;
}

@end

@implementation AmazonSESClient

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration
{
    self = [super initWithConfiguration:configuration];
    
    return self;
}

- (instancetype)initWithDefaultConfiguration
{
    self = [super initWithConfiguration:[AWSServiceManager defaultServiceManager].defaultServiceConfiguration];
    
    return self;
}

@end

