//
//  NOMTwitterPostTask.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "INOMSocialServiceInterface.h"

@interface NOMTwitterPostTask : NSObject

-(void)RegisterDelegate:(id<INOMTwitterPostTaskDelegate>)delegate;
-(void)SetAccount:(ACAccount*)account;
-(void)SetLocation:(double)dLatitude withLongitude:(double)dLongitude;
-(void)SetTweet:(NSString*)tweet;
-(void)SetPhoto:(UIImage*)image;
-(void)PostTwitterTweet;
-(void)TweetPostDone:(BOOL)nSucceed;

@end
