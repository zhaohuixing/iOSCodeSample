//
//  NOMNewsServiceHelper.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-05.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NOMTrafficSpotRecord;
@class NOMNewsMetaDataRecord;

@interface NOMNewsServiceHelper : NSObject

+(NSData*)ConvertImageToJpegData:(UIImage*)image;
+(NSData*)ConvertStringToData:(NSString*)string;

+(NSString*)GetNewsResourceS3Bucket;
+(NSString*)GetNewsResourceNewsSubFolder;
+(NSString*)GetNewsResourceNewsImageSubFolder;
+(NSString*)GetNewsResourceNewsKMLSubFolder;
+(NSString*)GetNewsFilePostFix;
+(NSString*)GetNewsImageResourceKey:(NSString*)newID imageIndex:(int)index;
+(NSString*)GetNewsFileResourceKey:(NSString*)newID;
+(NSString*)GetNewsKMLResourceKey:(NSString*)newID;
+(NSString*)GetNewsIDFromFileResourceKey:(NSString*)fileKey;
+(NSString*)GetNewsIDFromImageFileKey:(NSString*)fileKey;
+(NSString*)GetNewsIDFromKMLFileKey:(NSString*)fileKey;

+(NSString*)GetNewsFileResourceFolderString:(NSString*)newID;
+(NSString*)GetNewsImageResourceFolderString:(NSString*)newsID;
+(NSString*)GetNewsKMLResourceFolderString:(NSString*)newID;

+(NSString*)GetCurrentYearMonthDayKey;
+(NSString*)GetMainNewsJSONFileTimeStampeResourceKey:(NSString*)appDomain mainCate:(int16_t)mainCate subCate:(int16_t)subCate thirdCate:(int16_t)thirdCate newsID:(NSString*)newsID timeStampe:(NSString*)timeStampe;
+(NSString*)GetAppNewsImageResourceKey:(NSString*)newsID imageIndex:(int)index withTimeStampe:(NSString*)timeStampe withAppDomain:(NSString*)appDomain;
+(NSString*)GetAppNewsKMLResourceKey:(NSString*)newsID withTimeStampe:(NSString*)timeStampe withAppDomain:(NSString*)appDomain;


+(NSString*)GetMainNewsJSONFileCurrentTimeStampeResourceKey:(NSString*)appDomain mainCate:(int16_t)mainCate subCate:(int16_t)subCate thirdCate:(int16_t)thirdCate newsID:(NSString*)newsID;


+(BOOL)IsContenTypeTextPlain:(NSString*)contentType;
+(BOOL)IsContenTypeImageJpeg:(NSString*)contentType;
+(BOOL)IsContenTypeTextKML:(NSString*)contentType;

+(BOOL)MeetCanPostAnywhereCriteria:(int)nCategory withSubCategory:(int)nSubCategory withType:(int)nType;

+(void)SetCachedCommunityEventTime:(int64_t)time;
+(int64_t)GetCachedCommunityEventTime;

+(void)SetCachedCommunityYardSaleTime:(int64_t)time;
+(int64_t)GetCachedCommunityYardSaleTime;

+(BOOL)InMainlandChinaRestrictedArea;
+(void)SetInMainlandChinaRestrictedArea:(BOOL)InChina;

////////////////////////////////////////////////////////////////////////////////////////////
//
//The conversion functions between new data record and spot record
//
// Begin
//
////////////////////////////////////////////////////////////////////////////////////////////
+(int16_t)GetNoneNewsCategoryBaseID;
+(int16_t)ConvertToNewsCategoryIDFromSpotTypeID:(int16_t)spotType;
+(int16_t)ConvertToSpotTypeIDFromNewsCategoryID:(int16_t)newsMainCateType;
+(BOOL)IsValidSpotType:(int16_t)nSpotType;
+(BOOL)IsValidNewsMetaDataMainCategory:(int16_t)nMainCate;

+(void)ConvertSpotRecord:(NOMTrafficSpotRecord*)spotRecordSrc toNewsRecord:(NOMNewsMetaDataRecord*)newRecordDest;
+(BOOL)ConvertNewsRecord:(NOMNewsMetaDataRecord*)newRecordSrc toSpotRecord:(NOMTrafficSpotRecord*)spotRecordDest;
+(NOMTrafficSpotRecord*)GenerateSpotDatafromNewsRecord:(NOMNewsMetaDataRecord*)newRecordSrc;
////////////////////////////////////////////////////////////////////////////////////////////
// End
////////////////////////////////////////////////////////////////////////////////////////////

@end
