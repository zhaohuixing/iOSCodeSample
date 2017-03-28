//
//  NOMTwitterSearchTask.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-10-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "INOMSocialServiceInterface.h"

@interface NOMTwitterSearchTask : NSObject

-(NSArray*)GetSearchResults;
-(id)initWith:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate withAccount:(ACAccount*)account withDelegate:(id<INOMTwitterSearchTaskDelegate>)delegate;

-(void)SetSearchParameters:(NSDictionary*)params;
-(void)SearchTwitterTweet;
-(void)SearchTwitterTweetByScreenName;
-(void)setTimeStample:(int64_t)timeStart;
-(void)ClearSearchResults;
@end
