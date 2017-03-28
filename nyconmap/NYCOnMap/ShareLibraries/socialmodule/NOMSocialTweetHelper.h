//
//  NOMSocialTweetHelper.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NOMTrafficSpotRecord;

@interface NOMSocialTweetHelper : NSObject

+(NSString*)GetNewsHashTag:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate;
+(NSString*)CreateTwitterTweet:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate withPost:(NSString*)szSrcPost;

+(NSString*)GetSearchNewsHashTag:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate;
+(NSArray*)GetSearchNewsTagList:(int16_t)nMainCate;

+(BOOL)CheckTweetApphashTag:(NSString*)tweet;

+(BOOL)IsSearchingKeyWord:(NSString*)szTestString;

+(NSArray*)GetSearchNewsAccountList:(int16_t)nMainCate;

+(NSString*)CreateTwitterTweet:(NOMTrafficSpotRecord*)pSpot;

+(int16_t)GetPublicTransitTypeFromKeyword:(NSString*)szWord;
+(int16_t)GetDrivingConditionTypeFromKeyword:(NSString*)szWord;

@end
