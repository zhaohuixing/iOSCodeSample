//
//  AWSSimpleDBUtilities.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-05-24.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
//#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AWSSimpleDBUtilities.h"
#import "NOMSystemConstants.h"

@implementation AWSSimpleDBUtilities

/*
 * Extracts the value for the given attribute from the list of attributes.
 * Extracted value is returned as a NSString.
 */
+(NSString *)GetStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
/*    for (SimpleDBAttribute *attribute in attributeList)
    {
        if ( [attribute.name isEqualToString:theAttribute])
        {
            return attribute.value;
        }
    }
*/    
    return nil;
}

/*
 * Extracts the value for the given attribute from the list of attributes.
 * Extracted value is returned as an int.
 */
+(int)GetIntValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
/*    for (SimpleDBAttribute *attribute in attributeList)
    {
        if ( [attribute.name isEqualToString:theAttribute])
        {
            return [attribute.value intValue];
        }
    }
*/    
    return -1;
}

+(NSString*)FormatQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd
{
    if(latEnd < 0 && latStart < 0)
    {
        if(fabs(latEnd) < fabs(latStart))
        {
            double temp = latEnd;
            latEnd = latStart;
            latStart = temp;
        }
    }
    if(lonEnd < 0 && lonStart < 0)
    {
        if(fabs(lonEnd) < fabs(lonStart))
        {
            double temp = lonEnd;
            lonEnd = lonStart;
            lonStart = temp;
        }
    }
    
    NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' and %@ >= '%2lld' and %@ <= '%2lld'",
                        domain,
                        NOM_NEWSMETA_NEWSLATITUDE,
                        latStart,
                        NOM_NEWSMETA_NEWSLATITUDE,
                        latEnd,
                        NOM_NEWSMETA_NEWSLONGITUDE,
                        lonStart,
                        NOM_NEWSMETA_NEWSLONGITUDE,
                        lonEnd,
                        NOM_NEWSMETA_NEWSTIME,
                        timeStart,
                        NOM_NEWSMETA_NEWSTIME,
                        timeEnd];
    
    return strRet;
}

+(NSString*)FormatQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd
{
    if(latEnd < 0 && latStart < 0)
    {
        if(fabs(latEnd) < fabs(latStart))
        {
            double temp = latEnd;
            latEnd = latStart;
            latStart = temp;
        }
    }
    if(lonEnd < 0 && lonStart < 0)
    {
        if(fabs(lonEnd) < fabs(lonStart))
        {
            double temp = lonEnd;
            lonEnd = lonStart;
            lonStart = temp;
        }
    }
    
    NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f'",
                        domain,
                        NOM_NEWSMETA_NEWSLATITUDE,
                        latStart,
                        NOM_NEWSMETA_NEWSLATITUDE,
                        latEnd,
                        NOM_NEWSMETA_NEWSLONGITUDE,
                        lonStart,
                        NOM_NEWSMETA_NEWSLONGITUDE,
                        lonEnd];
    return strRet;
}

+(NSString*)FormatTrafficQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd
{
    if(latEnd < 0 && latStart < 0)
    {
        if(fabs(latEnd) < fabs(latStart))
        {
            double temp = latEnd;
            latEnd = latStart;
            latStart = temp;
        }
    }
    if(lonEnd < 0 && lonStart < 0)
    {
        if(fabs(lonEnd) < fabs(lonStart))
        {
            double temp = lonEnd;
            lonEnd = lonStart;
            lonStart = temp;
        }
    }
    NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f'",
                        domain,
                        NOM_TRAFFICSPOT_LATITUDE_KEY,
                        latStart,
                        NOM_TRAFFICSPOT_LATITUDE_KEY,
                        latEnd,
                        NOM_TRAFFICSPOT_LONGITUDE_KEY,
                        lonStart,
                        NOM_TRAFFICSPOT_LONGITUDE_KEY,
                        lonEnd];

/*
    NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' order by %@ desc",
                        domain,
                        NOM_TRAFFICSPOT_LATITUDE_KEY,
                        latStart,
                        NOM_TRAFFICSPOT_LATITUDE_KEY,
                        latEnd,
                        NOM_TRAFFICSPOT_LONGITUDE_KEY,
                        lonStart,
                        NOM_TRAFFICSPOT_LONGITUDE_KEY,
                        lonEnd,
                        NOM_TRAFFICSPOT_LONGITUDE_KEY];
*/

/*    NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ >= %f and %@ <= %f and %@ >= %f and %@ <= %f",
                        domain,
                        NOM_TRAFFICSPOT_LATITUDE_KEY,
                        latStart,
                        NOM_TRAFFICSPOT_LATITUDE_KEY,
                        latEnd,
                        NOM_TRAFFICSPOT_LONGITUDE_KEY,
                        lonStart,
                        NOM_TRAFFICSPOT_LONGITUDE_KEY,
                        lonEnd];*/
    
    return strRet;
}




+(NSString*)FormatTrafficQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withSubType:(int16_t)nSubType
{
    if(latEnd < 0 && latStart < 0)
    {
        if(fabs(latEnd) < fabs(latStart))
        {
            double temp = latEnd;
            latEnd = latStart;
            latStart = temp;
        }
    }
    if(lonEnd < 0 && lonStart < 0)
    {
        if(fabs(lonEnd) < fabs(lonStart))
        {
            double temp = lonEnd;
            lonEnd = lonStart;
            lonStart = temp;
        }
    }
    NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' and %@ = '%i'",
                        domain,
                        NOM_TRAFFICSPOT_LATITUDE_KEY,
                        latStart,
                        NOM_TRAFFICSPOT_LATITUDE_KEY,
                        latEnd,
                        NOM_TRAFFICSPOT_LONGITUDE_KEY,
                        lonStart,
                        NOM_TRAFFICSPOT_LONGITUDE_KEY,
                        lonEnd,
                        NOM_TRAFFICSPOT_SUBTYPE_KEY,
                        nSubType];
    
    return strRet;
}




+(NSString*)FormatQuery:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd withTimeSort:(BOOL)bDescend
{
    if(latEnd < 0 && latStart < 0)
    {
        if(fabs(latEnd) < fabs(latStart))
        {
            double temp = latEnd;
            latEnd = latStart;
            latStart = temp;
        }
    }
    if(lonEnd < 0 && lonStart < 0)
    {
        if(fabs(lonEnd) < fabs(lonStart))
        {
            double temp = lonEnd;
            lonEnd = lonStart;
            lonStart = temp;
        }
    }
    
    if(bDescend)
    {
        NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' and %@ >= '%2lld' and %@ <= '%2lld' order by %@ desc",
                            domain,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latStart,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latEnd,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonStart,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonEnd,
                            NOM_NEWSMETA_NEWSTIME,
                            timeStart,
                            NOM_NEWSMETA_NEWSTIME,
                            timeEnd,
                            NOM_NEWSMETA_NEWSTIME];
        
        return strRet;
    }
    else
    {
        NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' and %@ >= '%2lld' and %@ <= '%2lld' order by %@ asc",
                            domain,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latStart,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latEnd,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonStart,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonEnd,
                            NOM_NEWSMETA_NEWSTIME,
                            timeStart,
                            NOM_NEWSMETA_NEWSTIME,
                            timeEnd,
                            NOM_NEWSMETA_NEWSTIME];
        
        return strRet;
    }
}

+(NSString*)FormatQuery:(NSString*)domain withSubCategory:(int)nSubCategory fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd withTimeSort:(BOOL)bDescend
{
    if(latEnd < 0 && latStart < 0)
    {
        if(fabs(latEnd) < fabs(latStart))
        {
            double temp = latEnd;
            latEnd = latStart;
            latStart = temp;
        }
    }
    if(lonEnd < 0 && lonStart < 0)
    {
        if(fabs(lonEnd) < fabs(lonStart))
        {
            double temp = lonEnd;
            lonEnd = lonStart;
            lonStart = temp;
        }
    }
    
    if(bDescend)
    {
        NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ = '%i' and %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' and %@ >= '%2lld' and %@ <= '%2lld' order by %@ desc",
                            domain,
                            NOM_NEWSMETA_NEWSSUBTYPE,
                            nSubCategory,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latStart,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latEnd,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonStart,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonEnd,
                            NOM_NEWSMETA_NEWSTIME,
                            timeStart,
                            NOM_NEWSMETA_NEWSTIME,
                            timeEnd,
                            NOM_NEWSMETA_NEWSTIME];
        
        return strRet;
    }
    else
    {
        NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ = '%i' and %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' and %@ >= '%2lld' and %@ <= '%2lld' order by %@ asc",
                            domain,
                            NOM_NEWSMETA_NEWSSUBTYPE,
                            nSubCategory,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latStart,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latEnd,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonStart,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonEnd,
                            NOM_NEWSMETA_NEWSTIME,
                            timeStart,
                            NOM_NEWSMETA_NEWSTIME,
                            timeEnd,
                            NOM_NEWSMETA_NEWSTIME];
        
        return strRet;
    }
}

+(NSString*)FormatQuery:(NSString*)domain withSubCategory:(int)nSubCategory fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withTimeSort:(BOOL)bDescend
{
    if(latEnd < 0 && latStart < 0)
    {
        if(fabs(latEnd) < fabs(latStart))
        {
            double temp = latEnd;
            latEnd = latStart;
            latStart = temp;
        }
    }
    if(lonEnd < 0 && lonStart < 0)
    {
        if(fabs(lonEnd) < fabs(lonStart))
        {
            double temp = lonEnd;
            lonEnd = lonStart;
            lonStart = temp;
        }
    }
    
    if(bDescend)
    {
        NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ = '%i' and %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' order by %@ desc",
                            domain,
                            NOM_NEWSMETA_NEWSSUBTYPE,
                            nSubCategory,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latStart,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latEnd,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonStart,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonEnd,
                            NOM_NEWSMETA_NEWSTIME];
        
        return strRet;
    }
    else
    {
        NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ = '%i' and %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' order by %@ asc",
                            domain,
                            NOM_NEWSMETA_NEWSSUBTYPE,
                            nSubCategory,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latStart,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latEnd,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonStart,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonEnd,
                            NOM_NEWSMETA_NEWSTIME];
        
        return strRet;
    }
}


+(NSString*)FormatQuery:(NSString*)domain withSubCategory:(int)nSubCategory withThirdCategory:(int)nThirdCategory fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd withTimeSort:(BOOL)bDescend
{
    if(latEnd < 0 && latStart < 0)
    {
        if(fabs(latEnd) < fabs(latStart))
        {
            double temp = latEnd;
            latEnd = latStart;
            latStart = temp;
        }
    }
    if(lonEnd < 0 && lonStart < 0)
    {
        if(fabs(lonEnd) < fabs(lonStart))
        {
            double temp = lonEnd;
            lonEnd = lonStart;
            lonStart = temp;
        }
    }
    
    if(bDescend)
    {
        NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ = '%i' and %@ = '%i' and %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' and %@ >= '%2lld' and %@ <= '%2lld' order by %@ desc",
                            domain,
                            NOM_NEWSMETA_NEWSSUBTYPE,
                            nSubCategory,
                            NOM_NEWSMETA_NEWSTHIRDTYPE,
                            nThirdCategory,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latStart,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latEnd,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonStart,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonEnd,
                            NOM_NEWSMETA_NEWSTIME,
                            timeStart,
                            NOM_NEWSMETA_NEWSTIME,
                            timeEnd,
                            NOM_NEWSMETA_NEWSTIME];
        
        return strRet;
    }
    else
    {
        NSString* strRet = [NSString stringWithFormat:@"select * from %@ where %@ = '%i' and %@ = '%i' and %@ >= '%f' and %@ <= '%f' and %@ >= '%f' and %@ <= '%f' and %@ >= '%2lld' and %@ <= '%2lld' order by %@ asc",
                            domain,
                            NOM_NEWSMETA_NEWSSUBTYPE,
                            nSubCategory,
                            NOM_NEWSMETA_NEWSTHIRDTYPE,
                            nThirdCategory,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latStart,
                            NOM_NEWSMETA_NEWSLATITUDE,
                            latEnd,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonStart,
                            NOM_NEWSMETA_NEWSLONGITUDE,
                            lonEnd,
                            NOM_NEWSMETA_NEWSTIME,
                            timeStart,
                            NOM_NEWSMETA_NEWSTIME,
                            timeEnd,
                            NOM_NEWSMETA_NEWSTIME];
        
        return strRet;
    }
}

@end
