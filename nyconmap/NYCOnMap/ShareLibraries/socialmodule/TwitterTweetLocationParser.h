//
//  TwitterTweetLocationParser.h
//  newsonmap
//
//  Created by Zhaohui Xing on 1/30/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "IPlainTextLocationParser.h"

@interface TwitterTweetLocationParser : NSObject<IPlainTextLocationParser>

-(void)ParseLocationFromTweet:(NSString*)tweet;
-(void)ParseLocationFromText:(NSString*)text;
-(NSArray*)GetLocationList;

@end
