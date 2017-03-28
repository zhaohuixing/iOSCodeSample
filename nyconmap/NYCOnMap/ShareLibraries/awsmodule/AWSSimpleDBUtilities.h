//
//  AWSSimpleDBUtilities.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-05-24.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWSSimpleDBUtilities : NSObject

+(NSString *)GetStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList;
+(int)GetIntValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList;

+(NSString*)FormatQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd;

+(NSString*)FormatQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd;

+(NSString*)FormatQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd withTimeSort:(BOOL)bDescend;

+(NSString*)FormatQuery:(NSString*)domain withSubCategory:(int)nSubCategory fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd withTimeSort:(BOOL)bDescend;

+(NSString*)FormatQuery:(NSString*)domain withSubCategory:(int)nSubCategory fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withTimeSort:(BOOL)bDescend;

+(NSString*)FormatQuery:(NSString*)domain withSubCategory:(int)nSubCategory withThirdCategory:(int)nThirdCategory fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd withTimeSort:(BOOL)bDescend;

+(NSString*)FormatTrafficQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd;

+(NSString*)FormatTrafficQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withSubType:(int16_t)nSubType;
@end
