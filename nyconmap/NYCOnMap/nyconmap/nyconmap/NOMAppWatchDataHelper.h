//
//  NOMAppWatchDataHelper.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-03-31.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMAppWatchDataHelper : NSObject

+(BOOL)IsSimpleSearchMode;
+(void)SetSimpleSearchMode:(BOOL)bSimpleMode;


+(NSString*)GetWatchTrafficChoiceTitle:(int16_t)nWKTrafficID;
+(NSString*)GetWatchSpotChoiceTitle:(int16_t)nWKSpotID;
+(NSString*)GetWatchTaxiChoiceTitle:(int16_t)nWKTaxiID;

+(double)GetDefaultWatchMapViewMaxSpan;
+(void)SetDefaultWatchMapViewMaxSpan:(double)dSpan;

+(int16_t)GetPostUserModeTypeFromWatchActionChoice:(int16_t)nWKChoice;
+(int16_t)GetSearchUserModeTypeFromWatchActionChoice:(int16_t)nWKChoice;

+(void)QueryUserModeDetailFromWatchActionChoice:(int16_t)nWKChoice actionOption:(int16_t)nOption toMainCate:(int16_t*)pMainCate toSubCate:(int16_t*)pSubCate toThirdCate:(int16_t*)pThirdCate;

+(int16_t)GetWatchAnnotationTypeFromMetaData:(int16_t)nMainCate subCate:(int16_t)nSubCate thirdCate:(int16_t)nThirdCate;
+(int16_t)GetWatchAnnotationTypeFromSpotData:(int16_t)nType subCate:(int16_t)nSubType;


@end
