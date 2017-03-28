//
//  NOMTwitterSearchManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-10-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTwitterSearchManager.h"
#import "NOMSocialSearchManager.h"
#import "NOMTwitterSearchTask.h"
#import "NOMSocialTweetHelper.h"
#import "NOMSystemConstants.h"
#import "NOMTimeHelper.h"
#import "NOMAppInfo.h"
#import "NOMNewsMetaDataRecord.h"

@interface NOMTwitterSearchManager ()
{
    NSMutableArray*             m_SearchTaskList;
    NOMSocialSearchManager*     m_Parent;
}

@end

@implementation NOMTwitterSearchManager

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Parent = nil;
        m_SearchTaskList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)SetParent:(NOMSocialSearchManager*)parent
{
    m_Parent = parent;
}

-(void)Search:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate withAccount:(ACAccount*)account fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd
{
    //?????????????????????????????
    //?????????????????????????????
    [self Search:nMainCate withAccount:account fromTime:timeStart toTime:timeEnd];
}


-(void)StartSearchTweetTask:(NSDictionary*)params withMainCategory:(int16_t)nMainCate withSubCategory:(int16_t)nSubCate withThirdCategory:(int16_t)nThirdCate withAccount:(ACAccount*)account
{
    NOMTwitterSearchTask* searchTask = [[NOMTwitterSearchTask alloc] initWith:nMainCate withSubCate:nSubCate withThirdCate:nThirdCate withAccount:account withDelegate:self];
    [searchTask SetSearchParameters:params];
    [m_SearchTaskList addObject:searchTask];
    [searchTask SearchTwitterTweet];
}

-(void)StartSearchTweetTaskByScreenName:(NSDictionary*)params withAccount:(ACAccount*)account beforeTime:(int64_t)timeStart
{
    NOMTwitterSearchTask* searchTask = [[NOMTwitterSearchTask alloc] initWith:NOM_NEWSCATEGORY_LOCALTRAFFIC withSubCate:-1 withThirdCate:-1 withAccount:account withDelegate:self];
    [searchTask SetSearchParameters:params];
    [searchTask setTimeStample:timeStart];
    [m_SearchTaskList addObject:searchTask];
    [searchTask SearchTwitterTweetByScreenName];
}

#define TWITTER_SEARCH_USING_RECOMMEND_ACCOUNTS         1

-(void)Search:(int16_t)nMainCate withAccount:(ACAccount*)account fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd
{
    NSDate* startDate = [NOMTimeHelper ConertIntegerToNSDate:timeStart];
    NSDate* stopDate = [NOMTimeHelper ConertIntegerToNSDate:timeEnd];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM"];
    int nstartMonth = [[dateFormatter stringFromDate:startDate] intValue];
    int nstopMonth = [[dateFormatter stringFromDate:stopDate] intValue];
    
    [dateFormatter setDateFormat:@"dd"];
    int nstartDay = [[dateFormatter stringFromDate:startDate] intValue];
    int nstopDay = [[dateFormatter stringFromDate:stopDate] intValue];
    
    [dateFormatter setDateFormat:@"yyyy"];
    int nstartYear = [[dateFormatter stringFromDate:startDate] intValue];
    int nstopYear = [[dateFormatter stringFromDate:stopDate] intValue];
    
    NSString* szStartTimeStamp = [NSString stringWithFormat:@"since:%i-%i-%i", nstartYear, nstartMonth, nstartDay];
    NSString* szStopTimeStamp = [NSString stringWithFormat:@"%i-%i-%i", nstopYear, nstopMonth, nstopDay];

    double latCenter = [NOMAppInfo GetAppLatitude];
    double lonCenter = [NOMAppInfo GetAppLongitude];
    int dR = (int)[NOMAppInfo GetAppRegionRangeDegree];
    NSString* geoString = [NSString stringWithFormat:@"%f,%f,%imi", latCenter, lonCenter, dR];

#ifdef TWITTER_SEARCH_USING_RECOMMEND_ACCOUNTS
    NSArray* accountList = [NOMSocialTweetHelper GetSearchNewsAccountList:NOM_NEWSCATEGORY_LOCALTRAFFIC];
    if(accountList != nil && 0 < accountList.count)
    {

        for(int i = 0; i < accountList.count; ++i)
        {
            //NSString* query = [NSString stringWithFormat:@"%@ %@", [keywordsList objectAtIndex:i], szStartTimeStamp];
            NSDictionary *params = @{@"screen_name":accountList[i], @"count":@"100"};
            [self StartSearchTweetTaskByScreenName:params withAccount:account beforeTime:timeStart];
        }

/*
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        [params setObject:accountList forKey:@"screen_name"];
        [params setObject:@"500" forKey:@"count"];
        [self StartSearchTweetTaskByScreenName:params withAccount:account beforeTime:timeStart];
*/
    }
    
#else
    NSArray* keywordsList = [NOMSocialTweetHelper GetSearchNewsTagList:NOM_NEWSCATEGORY_LOCALTRAFFIC];
    if(keywordsList != nil && 0 < keywordsList.count)
    {
        for(int i = 0; i < keywordsList.count; ++i)
        {
            NSString* query = [NSString stringWithFormat:@"%@ %@", [keywordsList objectAtIndex:i], szStartTimeStamp];
            NSDictionary *params = @{@"q":query, @"geocode":geoString, @"until":szStopTimeStamp};
            [self StartSearchTweetTask:params withMainCategory:nMainCate withSubCategory:-1 withThirdCategory:-1 withAccount:account];
        }
    }
#endif
}

-(void)LoadSearchResult:(NOMTwitterSearchTask*)pTask
{
    if(pTask != nil)
    {
        NSArray* array = [pTask GetSearchResults];
        if(array != nil && 0 < array.count)
        {
            for(NOMNewsMetaDataRecord* pRecord in array)
            {
                if(pRecord != nil)
                {
                    if(m_Parent != nil)
                    {
                        [m_Parent HandleSearchResult:pRecord];
                    }
                }
            }
            //????????
            if(m_Parent != nil)
            {
                [m_Parent HandleSearchCompletion:array];
            }
            
            [pTask ClearSearchResults];
        }
    }
}

-(void)SearchTaskDone:(id)task result:(BOOL)succed
{
    if(task != nil && [task isKindOfClass:[NOMTwitterSearchTask class]] == YES)
    {
        NOMTwitterSearchTask* pTask = (NOMTwitterSearchTask*)task;
        //??????????????????????
        if(succed == YES)
        {
            [self LoadSearchResult:pTask];
        }
        [m_SearchTaskList removeObject:pTask];
    }
}

@end
