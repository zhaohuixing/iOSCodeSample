//
//  NOMTwitterSearchTask.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-10-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTwitterSearchTask.h"
#import "SocialAPIConstants.h"
#import "NOMSocialTweetHelper.h"
#import "NOMNewsMetaDataRecord.h"
#import "NOMTimeHelper.h"
#import "NOMSystemConstants.h"
#import "AmazonClientManager.h"


@interface NOMTwitterSearchTask ()
{
    NSDictionary*       m_SearchParameters;
    ACAccount*          m_Account;
    
    NSMutableArray*     m_RecordList;
    
    int                 m_NewsMainCategory;
    int                 m_NewsSubCategory;
    int                 m_NewsThirdCategory;
    
    NSMutableDictionary*       m_SearchResult;
    
    id<INOMTwitterSearchTaskDelegate>           m_Delegate;
    
    int64_t             m_TimeStart;
}

-(void)SearchTaskDone:(BOOL)bSucceded;

@end

@implementation NOMTwitterSearchTask

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_SearchParameters = nil;
        m_Account = nil;
        
        m_RecordList = [[NSMutableArray alloc] init];
        
        m_NewsMainCategory = -1;
        m_NewsSubCategory = -1;
        m_NewsThirdCategory = -1;
        m_Delegate = nil;
        
        m_SearchResult = nil;
        m_TimeStart = -1;
    }
    return self;
}

-(id)initWith:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate withAccount:(ACAccount*)account withDelegate:(id<INOMTwitterSearchTaskDelegate>)delegate
{
    self = [super init];
    if(self != nil)
    {
        m_SearchParameters = nil;
        m_Account = account;
        
        m_RecordList = [[NSMutableArray alloc] init];
        
        m_NewsMainCategory = nMainCate;
        m_NewsSubCategory = nSubCate;
        m_NewsThirdCategory = nThirdCate;
        m_Delegate = delegate;
        
        m_SearchResult = nil;
        
        m_TimeStart = -1;
    }
    return self;
}

-(void)setTimeStample:(int64_t)timeStart
{
    m_TimeStart = timeStart;
}

-(NSArray*)GetSearchResults
{
    return m_RecordList;
}

-(void)SearchTaskSucceed
{
    if(m_Delegate != nil)
    {
        [m_Delegate SearchTaskDone:self result:YES];
    }
}

-(void)SearchTaskFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate SearchTaskDone:self result:NO];
    }
}

-(void)SearchTaskDone:(BOOL)bSucceded
{
    if (![NSThread isMainThread])
    {
        if(bSucceded)
            [self performSelectorOnMainThread:@selector(SearchTaskSucceed) withObject:nil waitUntilDone:NO];
        else
            [self performSelectorOnMainThread:@selector(SearchTaskFailed) withObject:nil waitUntilDone:NO];
        return;
    }
    else
    {
        if(m_Delegate != nil)
        {
            [m_Delegate SearchTaskDone:self result:bSucceded];
        }
    }
}

-(void)SetSearchParameters:(NSDictionary*)params
{
    m_SearchParameters = params;
}

-(void)ParseLinkURLInsideTweet:(NOMNewsMetaDataRecord*)pRecord from:(NSString*)tweet
{
    if(tweet != nil && 0 < tweet.length)
    {
        __block NSString* szURL = nil;
        __block BOOL bHaveURL = NO;
        
        NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc]
                                      initWithTagSchemes:[NSArray arrayWithObject:NSLinguisticTagSchemeLexicalClass]
                                      options:NSLinguisticTaggerOmitWhitespace];
        
        [tagger setString:tweet];
        [tagger enumerateTagsInRange:NSMakeRange(0, [tweet length])
                              scheme:NSLinguisticTagSchemeLexicalClass
                             options:NSLinguisticTaggerOmitWhitespace
                          usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop)
         {
             NSString* word = [tweet substringWithRange:tokenRange];
             if(word != nil )
             {
                 if ([word rangeOfString:@"http"].location != NSNotFound || [word rangeOfString:@"https"].location != NSNotFound)
                 {
                     szURL = word;
                     bHaveURL = YES;
                 }
                 else
                 {
                     if([word rangeOfString:@"#"].location != NSNotFound || [word rangeOfString:@"\""].location != NSNotFound
                        || [word rangeOfString:@"'"].location != NSNotFound || [word rangeOfString:@";"].location != NSNotFound
                        || [word rangeOfString:@","].location != NSNotFound || [word rangeOfString:@"*"].location != NSNotFound
                        || [word rangeOfString:@"!"].location != NSNotFound)
                     {
                         bHaveURL = NO;
                     }
                     else if(bHaveURL == YES)
                     {
                         szURL = [NSString stringWithFormat:@"%@%@", szURL, word];
                     }
                 }
#ifdef DEBUG
                 NSLog(@"Tweet text element: %@ (%@)\n", word, tag);
#endif
             }
         }];
        
        if(szURL != nil && 0 < szURL.length)
        {
#ifdef DEBUG
            NSLog(@"Tweet link: %@\n", szURL);
#endif
            pRecord.m_TwitterTweetLinkURL = szURL;
        }
    }
}

-(void)ParseTrafficTypesInsideTweet:(NOMNewsMetaDataRecord*)pRecord from:(NSString*)tweet
{
    int16_t nThirdType = [NOMSocialTweetHelper GetPublicTransitTypeFromKeyword:tweet];
    
    if(0 <= nThirdType)
    {
        pRecord.m_NewsMainCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC;
        pRecord.m_NewsSubCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT;
        pRecord.m_NewsThirdCategory = nThirdType;
        return;
    }
    
    nThirdType = [NOMSocialTweetHelper GetDrivingConditionTypeFromKeyword:tweet];
    if(0 <= nThirdType)
    {
        pRecord.m_NewsMainCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC;
        pRecord.m_NewsSubCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION;
        pRecord.m_NewsThirdCategory = nThirdType;
        return;
    }
    
    //???????????????????
    pRecord.m_NewsMainCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC;
    pRecord.m_NewsSubCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION;
    pRecord.m_NewsThirdCategory = 0; //??????//nThirdType;

}

-(BOOL)LoadTweetText:(NOMNewsMetaDataRecord*)pRecord from:(NSDictionary*)tweetData
{
    if(tweetData != nil)
    {
        NSString* text = [tweetData objectForKey:@"text"];
        if(text != nil && 0 < text.length)
        {
            if([NOMSocialTweetHelper CheckTweetApphashTag:text] == YES)
                return YES;
            
            pRecord.m_TweetText = text;
            
            /*
            if(pRecord.m_NewsLatitude == 0.0 && pRecord.m_NewsLongitude == 0.0 && m_NewsMainCategory != NOM_NEWSCATEGORY_LOCALTRAFFIC)
            {
                TwitterTweetLocationParser* streetParser = [[TwitterTweetLocationParser alloc] init];
                [streetParser ParseLocationFromTweet:pRecord.m_TweetText];
                NSArray* streetList = [streetParser GetLocationList];
                
                [m_DelayReleaseList addObject:streetParser];
                
                if(streetList != nil && 0 < streetList.count)
                {
                    NSString* streetAddress;
                    if(streetList.count == 1)
                    {
                        streetAddress = [NSString stringWithFormat:@"%@", [streetList objectAtIndex:0]];
                    }
                    else
                    {
                        streetAddress = [NSString stringWithFormat:@"%@ and %@", [streetList objectAtIndex:0], [streetList objectAtIndex:1]];
                    }
                    
                    
                    NSDictionary *locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        //[NOMGEOConfigration GetCurrentCity], kABPersonAddressCityKey,
                                                        [NOMGEOConfigration GetCurrentState], kABPersonAddressStateKey,
                                                        [NOMGEOConfigration GetCurrentCounty], kABPersonAddressCountryKey,
                                                        [NOMGEOConfigration GetCurrentCountryCode], kABPersonAddressCountryCodeKey,
                                                        streetAddress, kABPersonAddressStreetKey,
                                                        nil];
                    
                    
                    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                    [m_DelayReleaseList addObject:geocoder];
                    
                    [geocoder geocodeAddressDictionary:locationDictionary completionHandler:^(NSArray *placemarks, NSError *error)
                     {
                         if(placemarks != nil && 0 < [placemarks count] && error == nil)
                         {
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             CLLocation *location = placemark.location;
                             pRecord.m_NewsLongitude = location.coordinate.longitude;
                             pRecord.m_NewsLatitude = location.coordinate.latitude;
                             [pRecord HandleLocationChanged];
#ifdef DEBUG
                             NSLog(@"Parse location data succeed inside tweet. Lat:%f, Long:%f, Name:%@\n", pRecord.m_NewsLatitude, pRecord.m_NewsLongitude, placemark.name);
#endif
                         }
#ifdef DEBUG
                         else
                         {
                             NSLog(@"Parse location data failed inside tweet.\n");
                         }
#endif
                     }];
                }
            }
            */
            [self ParseLinkURLInsideTweet:pRecord from:pRecord.m_TweetText];
            [self ParseTrafficTypesInsideTweet:pRecord from:pRecord.m_TweetText];
        }
        
        return NO;
    }
    
    return YES;
}


-(void)LoadTweetLocation:(NOMNewsMetaDataRecord*)pRecord from:(NSDictionary*)tweetData
{
    pRecord.m_NewsLatitude = 0.0;
    pRecord.m_NewsLongitude = 0.0;
    
    NSDictionary* geoData = nil;
    id testData = [tweetData objectForKey:TTSEARCH_KEY_GEO];
    if([testData isKindOfClass:[NSDictionary class]] == YES)
    {
        geoData = (NSDictionary*)testData;
    }
    if(geoData != nil&& [geoData allKeys] != nil && 0 < [geoData allKeys].count)
    {
        NSString* type = [geoData objectForKey:TTSEARCH_KEY_TYPE];
        if(type != nil && [type isEqualToString:TTSEARCH_KEY_POINT] == YES)
        {
            NSArray* coordinates = [geoData objectForKey:TTSEARCH_KEY_COORDINATES];
            if(coordinates != nil && 2 <= coordinates.count)
            {
                NSNumber* latValue = [coordinates objectAtIndex:0];
                if(latValue != nil)
                {
                    pRecord.m_NewsLatitude = [latValue doubleValue];
                }
                NSNumber* lonValue = [coordinates objectAtIndex:1];
                if(lonValue != nil)
                {
                    pRecord.m_NewsLongitude = [lonValue doubleValue];
                }
            }
        }
    }
    else
    {
        testData = [tweetData objectForKey:TTSEARCH_KEY_COORDINATES];
        if([testData isKindOfClass:[NSDictionary class]] == YES)
        {
            geoData = (NSDictionary*)testData;
        }
        
        if(geoData != nil && 0 < geoData.count)
        {
            NSString* type = [geoData objectForKey:TTSEARCH_KEY_TYPE];
            if(type != nil && [type isEqualToString:TTSEARCH_KEY_POINT] == YES)
            {
                NSArray* coordinates = [geoData objectForKey:TTSEARCH_KEY_COORDINATES];
                if(coordinates != nil && 2 <= coordinates.count)
                {
                    NSNumber* latValue = [coordinates objectAtIndex:0];
                    if(latValue != nil)
                    {
                        pRecord.m_NewsLatitude = [latValue doubleValue];
                    }
                    NSNumber* lonValue = [coordinates objectAtIndex:1];
                    if(lonValue != nil)
                    {
                        pRecord.m_NewsLongitude = [lonValue doubleValue];
                    }
                }
            }
        }
    }
}

-(void)LoadTweetID:(NOMNewsMetaDataRecord*)pRecord from:(NSDictionary*)tweetData
{
    if(tweetData != nil)
    {
        NSString* strID = [tweetData objectForKey:TTSEARCH_KEY_IDSTRING];
        if(strID != nil)
        {
#ifdef DEBUG
            NSLog(@"Tweet ID:%@\n", strID);
#endif
            
            pRecord.m_NewsID = strID;
        }
        else
        {
            NSNumber* numID = [tweetData objectForKey:TTSEARCH_KEY_ID];
            if(numID != nil)
            {
                pRecord.m_NewsID = [numID stringValue];
#ifdef DEBUG
                NSLog(@"Tweet ID:%@\n", pRecord.m_NewsID);
#endif
            }
        }
        if(pRecord.m_NewsID == nil || pRecord.m_NewsID.length <= 0)
        {
            pRecord.m_NewsID = [[NSUUID UUID] UUIDString];
        }
    }
}

-(void)LoadTweetUser:(NOMNewsMetaDataRecord*)pRecord from:(NSDictionary*)tweetData
{
    if(tweetData != nil)
    {
        NSDictionary* userData = nil;
        
        id testData = [tweetData objectForKey:TTSEARCH_KEY_USER];
        if([testData isKindOfClass:[NSDictionary class]] == YES)
        {
            userData = (NSDictionary*)testData;
        }
        
        if(userData != nil && 0 < userData.count)
        {
            NSString* szID = [userData objectForKey:TTSEARCH_KEY_NAME];
            if(szID != nil && 0 < szID.length)
            {
#ifdef DEBUG
                NSLog(@"Tweet name:%@\n", szID);
#endif
                pRecord.m_NewsPosterEmail = szID;
                NSString* szScreenName = [userData objectForKey:TTSEARCH_KEY_SCREENNAME];
                if(szScreenName != nil && 0 < szScreenName.length)
                {
#ifdef DEBUG
                    NSLog(@"Tweet screen name:%@\n", szScreenName);
#endif
                    pRecord.m_NewsPosterDisplayName = szScreenName;
                }
                
                NSString* szIconURL = [userData objectForKey:TTSEARCH_KEY_PROFILEIMAGEURLHTTPS];
                if(szIconURL != nil && 0 < szIconURL.length)
                {
#ifdef DEBUG
                    NSLog(@"Tweet user icon url:%@\n", szIconURL);
#endif
                    pRecord.m_TwitterUserIconURL = szIconURL;
                }
                else
                {
                    szIconURL = [userData objectForKey:TTSEARCH_KEY_PROFILEIMAGEURL];
                    if(szIconURL != nil && 0 < szIconURL.length)
                    {
#ifdef DEBUG
                        NSLog(@"Tweet user icon url:%@\n", szIconURL);
#endif
                        pRecord.m_TwitterUserIconURL = szIconURL;
                    }
                }
            }
        }
    }
}

-(int64_t)QueryTweetTime:(NSDictionary*)tweetData
{
    int64_t nRet = -1;
   
    if(tweetData != nil)
    {
        NSString* timeString = [tweetData objectForKey:TTSEARCH_KEY_CREATEDAT];
#ifdef DEBUG
        NSLog(@"Tweet time:%@\n", timeString);
#endif
        if(timeString != nil && 0 < timeString.length)
        {
            /*            NSDate* time3 = [NSDate dateWithISO8061Format:timeString];
             NSDate* time2 = [NSDate dateWithRFC822Format:timeString];
             #ifdef DEBUG
             NSLog(@"Tweet time:%@\n", [time3 description]);
             NSLog(@"Tweet time:%@\n", [time2 description]);
             #endif
             */
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz yyyy"];
            
            NSDate *time = [dateFormatter dateFromString:timeString];
#ifdef DEBUG
            NSLog(@"Date : %@", time);
#endif
            nRet = [NOMTimeHelper ConvertNSDateToInteger:time];
        }
    }
    
    return nRet;
}

-(void)LoadTweetTime:(NOMNewsMetaDataRecord*)pRecord from:(NSDictionary*)tweetData
{
    if(tweetData != nil)
    {
        NSString* timeString = [tweetData objectForKey:TTSEARCH_KEY_CREATEDAT];
#ifdef DEBUG
        NSLog(@"Tweet time:%@\n", timeString);
#endif
        
        if(timeString != nil && 0 < timeString.length)
        {
/*            NSDate* time3 = [NSDate dateWithISO8061Format:timeString];
            NSDate* time2 = [NSDate dateWithRFC822Format:timeString];
#ifdef DEBUG
            NSLog(@"Tweet time:%@\n", [time3 description]);
            NSLog(@"Tweet time:%@\n", [time2 description]);
#endif
*/            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz yyyy"];
            
            NSDate *time = [dateFormatter dateFromString:timeString];
#ifdef DEBUG
            NSLog(@"Date : %@", time);
#endif
            pRecord.m_nNewsTime = [NOMTimeHelper ConvertNSDateToInteger:time];
        }
    }
 
}

-(void)LoadTweetImage:(NOMNewsMetaDataRecord*)pRecord from:(NSDictionary*)tweetData
{
    if(tweetData != nil)
    {
        NSDictionary* entitiesData = nil;
        
        id testData = [tweetData objectForKey:TTSEARCH_KEY_ENTITIES];
        if([testData isKindOfClass:[NSDictionary class]] == YES)
        {
            entitiesData = (NSDictionary*)testData;
        }
        
        if(entitiesData != nil && 0 < entitiesData.count)
        {
            NSDictionary* mediaData = nil;
            testData = [tweetData objectForKey:TTSEARCH_KEY_MEDIA];
            if([testData isKindOfClass:[NSDictionary class]] == YES)
            {
                mediaData = (NSDictionary*)testData;
            }
            
            if(mediaData != nil  && 0 < mediaData.count)
            {
                NSString* szImageURL = [mediaData objectForKey:TTSEARCH_KEY_MEDIAURLHTTPS];
                if(szImageURL != nil && 0 < szImageURL.length)
                {
#ifdef DEBUG
                    NSLog(@"Tweet photo url:%@\n", szImageURL);
#endif
                    pRecord.m_NewsResourceURL = szImageURL;
                }
                else
                {
                    szImageURL = [mediaData objectForKey:TTSEARCH_KEY_MEDIAURL];
                    if(szImageURL != nil && 0 < szImageURL.length)
                    {
#ifdef DEBUG
                        NSLog(@"Tweet photo url:%@\n", szImageURL);
#endif
                        pRecord.m_NewsResourceURL = szImageURL;
                    }
                }
                
            }
        }
    }
}

-(void)LoadTweetInformation:(NSDictionary*)tweetData
{
    int64_t nTweetTime = 0;
    if(-1 < m_TimeStart)
    {
        nTweetTime = [self QueryTweetTime:tweetData];
        if(nTweetTime < 0)
            return;
        if(nTweetTime <= m_TimeStart)
            return;
    }
    else
    {
        nTweetTime = [self QueryTweetTime:tweetData];
        if(nTweetTime < 0)
            return;
    }
    
    NOMNewsMetaDataRecord* pRecord = nil;
    pRecord = [[NOMNewsMetaDataRecord alloc] init];
    pRecord.m_NewsMainCategory = m_NewsMainCategory;
    pRecord.m_NewsSubCategory = m_NewsSubCategory;
    pRecord.m_NewsThirdCategory = m_NewsThirdCategory;
    pRecord.m_bTwitterTweet = YES;
    BOOL bFromAppSharing = NO;
    bFromAppSharing = [self LoadTweetText:pRecord from:tweetData];
    if(bFromAppSharing == NO)
    {
        [self LoadTweetLocation:pRecord from:tweetData];
        [self LoadTweetID:pRecord from:tweetData];
        [self LoadTweetUser:pRecord from:tweetData];
        [self LoadTweetImage:pRecord from:tweetData];
        //[self LoadTweetTime:pRecord from:tweetData];
        pRecord.m_nNewsTime = nTweetTime;
        [m_RecordList addObject:pRecord];
    }
}

-(void)ParseTweetJSONData:(NSDictionary*)searchData
{
    if(searchData != nil)
    {
        
        NSArray* statusData = [searchData objectForKey:TTSEARCH_KEY_STATUSES];
        if(statusData != nil)
        {
            int nCount = (int)[statusData count];
#ifdef DEBUG
            NSLog(@"Tweet Search tweet status count: %i\n", nCount);
#endif
            for(int i = 0; i < nCount; ++i)
            {
                NSDictionary* tweetData = (NSDictionary*)[statusData objectAtIndex:i];
                if(tweetData)
                {
                    [self LoadTweetInformation:tweetData];
                }
            }
        }
    }
}


-(void)StartSearch
{
    if(m_SearchParameters == nil || m_SearchParameters.count <= 0 || m_Account == nil)
    {
        [self SearchTaskDone:NO];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:TWITTER_TWEET_SEARCH_URL];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:m_SearchParameters];
    
    //  Attach an account to the request
    [request setAccount:m_Account];
    
    SLRequestHandler handler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        if(error != nil)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
            [self SearchTaskDone:NO];
        }
        else
        {
            if(responseData != nil)
            {
                if(urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
                {
                    NSError *jsonError;
                    m_SearchResult = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                    if (m_SearchResult != nil && 0 < [m_SearchResult count])
                    {
                        NSLog(@"Tweet Search Response: %@\n", m_SearchResult);
                        [self ParseTweetJSONData:m_SearchResult];
                        [self SearchTaskDone:YES];
                    }
                    else
                    {
                        // Our JSON deserialization went awry
                        NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                        [self SearchTaskDone:NO];
                    }
                }
                else
                {
                    // The server did not respond ... were we rate-limited?
                    NSLog(@"The response status code is %ld", urlResponse.statusCode);
                    [self SearchTaskDone:NO];
                }
            }
            else
            {
                [self SearchTaskDone:NO];
            }
        }
    };
    
    [request performRequestWithHandler:handler];
    
}

-(void)SearchTwitterTweet
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void)
    {
        [self StartSearch];
    });
}

-(void)ParseUserTimeLineJSONData:(id)searchData
{
    if(searchData != nil)
    {
        if([searchData isKindOfClass:[NSArray class]])
        {
            NSArray* statusData = (NSArray*)searchData;
            if(statusData != nil)
            {
                int nCount = (int)[statusData count];
#ifdef DEBUG
                NSLog(@"Tweet Search tweet status count: %i\n", nCount);
#endif
                for(int i = 0; i < nCount; ++i)
                {
                    NSDictionary* tweetData = (NSDictionary*)[statusData objectAtIndex:i];
                    if(tweetData)
                    {
                        [self LoadTweetInformation:tweetData];
                    }
                }
            }
        }
        
/*
        //NSArray* statusData = m_SearchResult.allValues;
        if(m_SearchResult.allValues != nil)
        {
            int nCount = (int)[m_SearchResult.allValues count];
#ifdef DEBUG
            NSLog(@"Tweet Search tweet status count: %i\n", nCount);
#endif
            for(int i = 0; i < nCount; ++i)
            {
                NSDictionary* tweetData = (NSDictionary*)[m_SearchResult.allValues objectAtIndex:i];
                if(tweetData)
                {
                    [self LoadTweetInformation:tweetData];
                }
            }
        }
*/
    }

}

-(void)StartSearchByScreenName
{
    if(m_SearchParameters == nil || m_SearchParameters.count <= 0 || m_Account == nil)
    {
        [self SearchTaskDone:NO];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:TWITTER_TWEETBYUSER_SEARCH_URL];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:m_SearchParameters];
    
    //  Attach an account to the request
    [request setAccount:m_Account];
    
    SLRequestHandler handler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        if(error != nil)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
            [self SearchTaskDone:NO];
        }
        else
        {
            if(responseData != nil)
            {
                if(urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
                {
                    NSError *jsonError;
                    id jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                    
                    //m_SearchResult = [[NSMutableDictionary alloc] initWithDictionary:tempJson];
                                       
                    if (jsonData != nil /*&& 0 < [m_SearchResult count]*/)
                    {
                        //NSLog(@"Tweet Search Response: %@\n", id);
                        [self ParseUserTimeLineJSONData:jsonData];
                        [self SearchTaskDone:YES];
                    }
                    else
                    {
                        // Our JSON deserialization went awry
                        NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                        [self SearchTaskDone:NO];
                    }
                }
                else
                {
                    // The server did not respond ... were we rate-limited?
                    NSLog(@"The response status code is %ld", urlResponse.statusCode);
                    [self SearchTaskDone:NO];
                }
            }
            else
            {
                [self SearchTaskDone:NO];
            }
        }
    };
    
    [request performRequestWithHandler:handler];
}

-(void)SearchTwitterTweetByScreenName
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void)
    {
        [self StartSearchByScreenName];
    });
}

-(void)ClearSearchResults
{
    [m_RecordList removeAllObjects];
}

@end
