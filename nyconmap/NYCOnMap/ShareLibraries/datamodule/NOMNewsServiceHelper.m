//
//  NOMNewsServiceHelper.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-05.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficSpotRecord.h"
#import "NOMNewsMetaDataRecord.h"
#import "NOMNewsServiceHelper.h"
#import "NOMSystemConstants.h"


@implementation NOMNewsServiceHelper

+(NSData*)ConvertImageToJpegData:(UIImage*)image
{
    if(image)
    {
        NSData* pJpeg = UIImageJPEGRepresentation(image, 1.0);
        return pJpeg;
    }
    return nil;
}

+(NSData*)ConvertStringToData:(NSString*)string
{
    if(string && 0 < [string length])
    {
        NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
        return data;
    }
    return nil;
}


+(NSString*)GetNewsResourceS3Bucket
{
    return NOM_NEWSRESOURCE_STORAGE_ROOT;
}

+(NSString*)GetNewsResourceNewsSubFolder
{
    return NOM_NEWSRESOURCE_STORAGE_NEWS_FOLDER;
}

+(NSString*)GetNewsResourceNewsImageSubFolder
{
    return NOM_NEWSRESOURCE_STORAGE_NEWSIMAGE_FOLDER;
}

+(NSString*)GetNewsResourceNewsKMLSubFolder
{
    return NOM_NEWSRESOURCE_STORAGE_NEWSKML_FOLDER;
}

+(NSString*)GetNewsFilePostFix
{
    return NOM_NEWSRESOURCE_NEWFILE_POSTFIX;
}

+(NSString*)GetNewsImageResourceKey:(NSString*)newsID imageIndex:(int)index
{
    NSString* strRet = [NSString stringWithFormat:@"%@/%@/%@_image_%i",[NOMNewsServiceHelper GetNewsResourceNewsImageSubFolder], newsID, newsID, index];
    return strRet;
}

+(NSString*)GetNewsFileResourceKey:(NSString*)newsID
{
    NSString* strRet = [NSString stringWithFormat:@"%@/%@/%@",[NOMNewsServiceHelper GetNewsResourceNewsSubFolder], newsID, newsID];
    return strRet;
}

+(NSString*)GetNewsKMLResourceKey:(NSString*)newsID
{
    NSString* strRet = [NSString stringWithFormat:@"%@/%@/%@",[NOMNewsServiceHelper GetNewsResourceNewsKMLSubFolder], newsID, newsID];
    return strRet;
}

+(NSString*)GetMainNewsJSONTypeKey:(int16_t)mainCate subCate:(int16_t)subCate thirdCate:(int16_t)thirdCate
{
    NSString* strRet = @"";
    
    if(mainCate == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        strRet = [NSString stringWithFormat:@"%i/%i/%i",mainCate,subCate,thirdCate];
    }
    else
    {
        strRet = [NSString stringWithFormat:@"%i/%i",mainCate,subCate];
    }
    
    return strRet;
}

+(NSString*)GetMainNewsJSONRootKey:(NSString*)appDomain
{
    NSString* szRoot = appDomain;
    if(appDomain == nil || appDomain.length <= 0)
    {
        szRoot = @"OnMap";
    }
    
    return szRoot;
}

+(NSString*)GetMainNewsJSONFileSubFolder:(NSString*)appDomain mainCate:(int16_t)mainCate subCate:(int16_t)subCate thirdCate:(int16_t)thirdCate
{
    NSString* szRoot = [NOMNewsServiceHelper GetMainNewsJSONRootKey:appDomain];
    NSString* szTypeKey = [NOMNewsServiceHelper GetMainNewsJSONTypeKey:mainCate subCate:subCate thirdCate:thirdCate];
    NSString* subFolder = [NSString stringWithFormat:@"%@/%@",szRoot, szTypeKey];
    return subFolder;
}

+(NSString*)GetCurrentYearMonthDayKey
{
    NSString* timeKey;
    
    NSDate* todatDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM"];
    int nstopMonth = [[dateFormatter stringFromDate:todatDate] intValue];
    
    [dateFormatter setDateFormat:@"dd"];
    int nstopDay = [[dateFormatter stringFromDate:todatDate] intValue];
    
    [dateFormatter setDateFormat:@"yyyy"];
    int nstopYear = [[dateFormatter stringFromDate:todatDate] intValue];
    
    timeKey = [NSString stringWithFormat:@"%i_%i_%i", nstopYear, nstopMonth, nstopDay];
    
    return timeKey;
}

+(NSString*)GetMainNewsJSONFileTimeStampeResourceKey:(NSString*)appDomain mainCate:(int16_t)mainCate subCate:(int16_t)subCate thirdCate:(int16_t)thirdCate newsID:(NSString*)newsID timeStampe:(NSString*)timeStampe
{
    NSString* subFolder = [NOMNewsServiceHelper GetMainNewsJSONFileSubFolder:appDomain mainCate:mainCate subCate:subCate thirdCate:thirdCate];
    if(timeStampe == nil || timeStampe.length <= 0)
        timeStampe = [NOMNewsServiceHelper GetCurrentYearMonthDayKey];
    NSString* strRet = [NSString stringWithFormat:@"%@/%@/%@",subFolder, timeStampe, newsID];
    return strRet;
}

+(NSString*)GetMainNewsJSONFileCurrentTimeStampeResourceKey:(NSString*)appDomain mainCate:(int16_t)mainCate subCate:(int16_t)subCate thirdCate:(int16_t)thirdCate newsID:(NSString*)newsID
{
    NSString* subFolder = [NOMNewsServiceHelper GetMainNewsJSONFileSubFolder:appDomain mainCate:mainCate subCate:subCate thirdCate:thirdCate];
    NSString* curTimeStamp = [NOMNewsServiceHelper GetCurrentYearMonthDayKey];
    NSString* strRet = [NSString stringWithFormat:@"%@/%@/%@",subFolder, curTimeStamp, newsID];
    return strRet;
}


+(NSString*)GetAppNewsImageResourceKey:(NSString*)newsID imageIndex:(int)index withTimeStampe:(NSString*)timeStampe withAppDomain:(NSString*)appDomain
{
    NSString* szRoot = [NOMNewsServiceHelper GetMainNewsJSONRootKey:appDomain];
    if(timeStampe == nil || timeStampe.length <= 0)
        timeStampe = [NOMNewsServiceHelper GetCurrentYearMonthDayKey];
    
    NSString* strRet = [NSString stringWithFormat:@"%@/%@/%@/%@/%@_image_%i", szRoot, [NOMNewsServiceHelper GetNewsResourceNewsImageSubFolder], timeStampe, newsID, newsID, index];
    return strRet;
}

+(NSString*)GetAppNewsKMLResourceKey:(NSString*)newsID withTimeStampe:(NSString*)timeStampe withAppDomain:(NSString*)appDomain
{
    NSString* szRoot = [NOMNewsServiceHelper GetMainNewsJSONRootKey:appDomain];
    if(timeStampe == nil || timeStampe.length <= 0)
        timeStampe = [NOMNewsServiceHelper GetCurrentYearMonthDayKey];
    
    NSString* strRet = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",szRoot, [NOMNewsServiceHelper GetNewsResourceNewsKMLSubFolder], timeStampe, newsID, newsID];
    return strRet;
}


+(NSString*)GetNewsIDFromFileResourceKey:(NSString*)fileKey
{
    NSString* newsFolderSubString = [NSString stringWithFormat:@"%@/",[NOMNewsServiceHelper GetNewsResourceNewsSubFolder]];
    NSRange range1 = [fileKey rangeOfString:newsFolderSubString];
    NSString* subString1 = [fileKey substringFromIndex:(range1.location + range1.length)];
    NSLog(@"subString1:%@", subString1);
    NSString* bsString = @"/";
    NSRange range2 = [subString1 rangeOfString:bsString];
    NSString* subString2 = [subString1 substringToIndex:range2.location];
    NSLog(@"subString2:%@", subString2);
    return subString2;
}

+(NSString*)GetNewsIDFromImageFileKey:(NSString*)fileKey
{
    NSString* newsFolderSubString = [NSString stringWithFormat:@"%@/",[NOMNewsServiceHelper GetNewsResourceNewsImageSubFolder]];
    NSRange range1 = [fileKey rangeOfString:newsFolderSubString];
    NSString* subString1 = [fileKey substringFromIndex:(range1.location + range1.length)];
    NSLog(@"subString1:%@", subString1);
    NSString* bsString = @"/";
    NSRange range2 = [subString1 rangeOfString:bsString];
    NSString* subString2 = [subString1 substringToIndex:range2.location];
    NSLog(@"subString2:%@", subString2);
    return subString2;
}

+(NSString*)GetNewsIDFromKMLFileKey:(NSString*)fileKey
{
    NSString* newsFolderSubString = [NSString stringWithFormat:@"%@/",[NOMNewsServiceHelper GetNewsResourceNewsKMLSubFolder]];
    NSRange range1 = [fileKey rangeOfString:newsFolderSubString];
    NSString* subString1 = [fileKey substringFromIndex:(range1.location + range1.length)];
    NSLog(@"subString1:%@", subString1);
    NSString* bsString = @"/";
    NSRange range2 = [subString1 rangeOfString:bsString];
    NSString* subString2 = [subString1 substringToIndex:range2.location];
    NSLog(@"subString2:%@", subString2);
    return subString2;
}

+(NSString*)GetNewsFileResourceFolderString:(NSString*)newsID
{
    NSString* strRet = [NSString stringWithFormat:@"%@/%@",[NOMNewsServiceHelper GetNewsResourceNewsSubFolder], newsID];
    return strRet;
}

+(NSString*)GetNewsImageResourceFolderString:(NSString*)newsID
{
    NSString* strRet = [NSString stringWithFormat:@"%@/%@",[NOMNewsServiceHelper GetNewsResourceNewsImageSubFolder], newsID];
    return strRet;
}

+(NSString*)GetNewsKMLResourceFolderString:(NSString*)newsID
{
    NSString* strRet = [NSString stringWithFormat:@"%@/%@",[NOMNewsServiceHelper GetNewsResourceNewsKMLSubFolder], newsID];
    return strRet;
}

+(BOOL)IsContenTypeTextPlain:(NSString*)contentType
{
    BOOL bRet = NO;

    if(contentType != nil && 0 < [contentType length])
    {
        bRet = [contentType isEqualToString:NOM_NEWSJSON_CONTENTTYPE];
    }
    
    return bRet;
}

+(BOOL)IsContenTypeImageJpeg:(NSString*)contentType
{
    BOOL bRet = NO;
    
    if(contentType != nil && 0 < [contentType length])
    {
        bRet = [contentType isEqualToString:NOM_NEWSIMAGE_CONTENTTYPE];
    }
    
    return bRet;
}

+(BOOL)IsContenTypeTextKML:(NSString*)contentType
{
    BOOL bRet = NO;
    
    if(contentType != nil && 0 < [contentType length])
    {
        bRet = [contentType isEqualToString:NOM_NEWSKML_CONTENTTYPE];
    }
    
    return bRet;
}

+(BOOL)MeetCanPostAnywhereCriteria:(int)nCategory withSubCategory:(int)nSubCategory withType:(int)nType
{
    if(nCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
        return NO;
    
    if(nCategory == NOM_NEWSCATEGORY_COMMUNITY && nSubCategory == NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYWIKI)
        return YES;
    
    if(nCategory == NOM_NEWSCATEGORY_LOCALNEWS)
    {
        if(nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_BUSINESS ||
           nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_MONEY ||
           nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_HEALTH ||
           nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_SPORTS ||
           nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ARTANDENTERTAINMENT ||
           nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_EDUCATION ||
           nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TECHNOLOGYANDSCIENCE ||
           nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_FOODANDDRINK ||
           nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TRAVELANDTOURISM ||
           nSubCategory == NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_LIFESTYLE)
            return YES;
    }
    
    return NO;
}

static int64_t g_CommunityEventTime = 0;

+(void)SetCachedCommunityEventTime:(int64_t)time
{
    g_CommunityEventTime = time;
}

+(int64_t)GetCachedCommunityEventTime
{
    return g_CommunityEventTime;
}

static int64_t g_CommunityYardSaleTime = 0;

+(void)SetCachedCommunityYardSaleTime:(int64_t)time
{
    g_CommunityYardSaleTime = time;
}

+(int64_t)GetCachedCommunityYardSaleTime
{
    return g_CommunityYardSaleTime;
}

static BOOL g_bInChina = NO;
+(BOOL)InMainlandChinaRestrictedArea
{
    return g_bInChina;
}

+(void)SetInMainlandChinaRestrictedArea:(BOOL)InChina
{
    g_bInChina = InChina;
}

////////////////////////////////////////////////////////////////////////////////////////////
//
//The conversion functions between new data record and spot record
//
// Begin
//
////////////////////////////////////////////////////////////////////////////////////////////
+(int16_t)GetNoneNewsCategoryBaseID
{
    return NOM_NEWSCATEGORY_NONENEWS_BASE_ID;
}

+(int16_t)ConvertToNewsCategoryIDFromSpotTypeID:(int16_t)spotType
{
    int16_t nRet = [NOMNewsServiceHelper GetNoneNewsCategoryBaseID] + spotType;
    return nRet;
}

+(int16_t)ConvertToSpotTypeIDFromNewsCategoryID:(int16_t)newsMainCateType;
{
    int16_t nRet = newsMainCateType - [NOMNewsServiceHelper GetNoneNewsCategoryBaseID];
    return nRet;
}

+(BOOL)IsValidSpotType:(int16_t)nSpotType
{
    BOOL bRet = NO;
    
    if(NOM_TRAFFICSPOT_TYPEFIRSTONE <= nSpotType && nSpotType <= NOM_TRAFFICSPOT_TYPELASTONE)
    {
        bRet = YES;
    }
    else
    {
        bRet = NO;
    }
    
    return bRet;
}

+(BOOL)IsValidNewsMetaDataMainCategory:(int16_t)nMainCate
{
    BOOL bRet = NO;
  
    if(NOM_NEWSCATEGORY_FIRSTID <= nMainCate && nMainCate <= NOM_NEWSCATEGORY_LASTID)
    {
        bRet = YES;
    }
    else
    {
        bRet = NO;
    }
    
    return bRet;
}

+(void)ConvertSpotRecord:(NOMTrafficSpotRecord*)spotRecordSrc toNewsRecord:(NOMNewsMetaDataRecord*)newRecordDest
{
    if(newRecordDest == nil || spotRecordSrc == nil)
        return;
    
    //
    //Main Type conversion
    //
    newRecordDest.m_NewsMainCategory = [NOMNewsServiceHelper ConvertToNewsCategoryIDFromSpotTypeID:spotRecordSrc.m_Type];
    
    //
    //Sub types conversion
    //
    newRecordDest.m_NewsSubCategory = spotRecordSrc.m_SubType;
    newRecordDest.m_NewsThirdCategory = spotRecordSrc.m_ThirdType;
    newRecordDest.m_DisplayStateByComplain = spotRecordSrc.m_FourType;
    
    //
    //Latitude and Longutitude conversion
    //
    newRecordDest.m_NewsLatitude = spotRecordSrc.m_SpotLatitude;
    newRecordDest.m_NewsLongitude = spotRecordSrc.m_SpotLongitude;

    //
    //ID conversion
    //
    newRecordDest.m_NewsID = spotRecordSrc.m_SpotID;
    
    //
    //Address conversion
    //
    newRecordDest.m_NewsPosterEmail = spotRecordSrc.m_SpotName;
    newRecordDest.m_NewsPosterDisplayName = spotRecordSrc.m_SpotAddress;
    
    //
    // Price related items
    //
    if(0.0 < spotRecordSrc.m_Price)
    {
        newRecordDest.m_NewsResourceURL = [[NSNumber alloc] initWithDouble:spotRecordSrc.m_Price].stringValue;
        newRecordDest.m_nNewsTime = spotRecordSrc.m_PriceTime;
        newRecordDest.m_DisplayForWearable = spotRecordSrc.m_PriceUnit;
    }
}

+(BOOL)ConvertNewsRecord:(NOMNewsMetaDataRecord*)newRecordSrc toSpotRecord:(NOMTrafficSpotRecord*)spotRecordDest
{
    if(newRecordSrc == nil || spotRecordDest == nil)
        return NO;
    
    //
    //Main Type conversion
    //
    int16_t nSpotType = [NOMNewsServiceHelper ConvertToSpotTypeIDFromNewsCategoryID:newRecordSrc.m_NewsMainCategory];
    if([NOMNewsServiceHelper IsValidSpotType:nSpotType] == NO)
        return NO;
    spotRecordDest.m_Type = nSpotType;
    
    //
    //Sub types conversion
    //
    spotRecordDest.m_SubType = newRecordSrc.m_NewsSubCategory;
    spotRecordDest.m_ThirdType = newRecordSrc.m_NewsThirdCategory;
    spotRecordDest.m_FourType = newRecordSrc.m_DisplayStateByComplain;
    
    //
    //Latitude and Longutitude conversion
    //
    spotRecordDest.m_SpotLatitude = newRecordSrc.m_NewsLatitude;
    spotRecordDest.m_SpotLongitude = newRecordSrc.m_NewsLongitude;
    
    //
    //ID conversion
    //
    spotRecordDest.m_SpotID = newRecordSrc.m_NewsID;
    
    //
    //Address conversion
    //
    spotRecordDest.m_SpotName = newRecordSrc.m_NewsPosterEmail;
    spotRecordDest.m_SpotAddress = newRecordSrc.m_NewsPosterDisplayName;
    
    //
    // Price related items
    //
    if(newRecordSrc.m_NewsResourceURL != nil && 0 < (int)newRecordSrc.m_NewsResourceURL.length)
    {
        spotRecordDest.m_Price = newRecordSrc.m_NewsResourceURL.doubleValue;
        spotRecordDest.m_PriceTime = newRecordSrc.m_nNewsTime;
        spotRecordDest.m_PriceUnit = newRecordSrc.m_DisplayForWearable;
    }
    
    return YES;
}

+(NOMTrafficSpotRecord*)GenerateSpotDatafromNewsRecord:(NOMNewsMetaDataRecord*)newRecordSrc
{
    NOMTrafficSpotRecord* pRecord = nil;
    
    int16_t nSpotType = [NOMNewsServiceHelper ConvertToSpotTypeIDFromNewsCategoryID:newRecordSrc.m_NewsMainCategory];
    if([NOMNewsServiceHelper IsValidSpotType:nSpotType] == NO)
        return pRecord;
    
    pRecord = [[NOMTrafficSpotRecord alloc] init];
    
    BOOL bRet = [NOMNewsServiceHelper ConvertNewsRecord:newRecordSrc toSpotRecord:pRecord];
    if(bRet == NO)
        return nil;
    
    return pRecord;
}

////////////////////////////////////////////////////////////////////////////////////////////
// End
////////////////////////////////////////////////////////////////////////////////////////////

@end
