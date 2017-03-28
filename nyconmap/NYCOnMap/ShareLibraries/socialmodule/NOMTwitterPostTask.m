//
//  NOMTwitterPostTask.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#include "SocialAPIConstants.h"
#import "NOMTwitterPostTask.h"
#import "NOMAppInfo.h"

@interface NOMTwitterPostTask ()
{
    id<INOMTwitterPostTaskDelegate>         m_Delegate;
    ACAccount*          m_Account;
    
    NSString*           m_Tweet;
    NSNumber*           m_Latitude;
    NSNumber*           m_Longitude;
    double              m_dLat;
    double              m_dLong;
    UIImage*            m_Photo;
    NSData*             m_ImageRawData;
    
    NSDictionary*       m_TweetParams;
    NSURL*              m_PostURL;
    SLRequest*          m_PostRequest;
}
@end

@implementation NOMTwitterPostTask

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Delegate = nil;
        m_Account = nil;
        m_Tweet = nil;
        m_dLat = 0;
        m_dLong = 0;
        m_Photo = nil;
        m_Latitude = [[NSNumber alloc] initWithDouble:m_dLat];
        m_Longitude = [[NSNumber alloc] initWithDouble:m_dLong];
        
        m_TweetParams = nil;
        m_PostURL = nil;
        m_PostRequest = nil;
        m_ImageRawData = nil;
    }
    
    return self;
}

-(void)RegisterDelegate:(id<INOMTwitterPostTaskDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)SetAccount:(ACAccount*)account
{
    m_Account = account;
}

-(void)SetLocation:(double)dLatitude withLongitude:(double)dLongitude
{
    m_dLat = dLatitude;
    m_dLong = dLongitude;
    m_Latitude = [[NSNumber alloc] initWithDouble:m_dLat];
    m_Longitude = [[NSNumber alloc] initWithDouble:m_dLong];
}

-(void)SetTweet:(NSString*)tweet
{
    m_Tweet = tweet;
}

-(void)SetPhoto:(UIImage*)image
{
    m_Photo = image;
}

-(void)StartPost
{
    if(m_Account == nil)
    {
        NSLog(@"Twitter Account does not exist.");
        [self TweetPostDone:NO];
        return;
    }
    if(m_Tweet == nil || m_Tweet.length <= 0)
    {
        NSLog(@"Tweet content is empty.");
        [self TweetPostDone:NO];
        return;
    }
/*
    NSString* szLat = [NSString stringWithFormat:@"%f", m_dLat];
    
    //Twitter Post API requires the string passing to "lat" no longer than 8.
    //See: https://dev.twitter.com/rest/reference/post/statuses/update
    if(8 < szLat.length)
    {
        NSRange range = NSMakeRange(0, 7); //7 or 8 ??????
        szLat = [szLat substringWithRange:range];
    }
    NSString* szLong = [NSString stringWithFormat:@"%f", m_dLong];
*/    
    SLRequestHandler requestHandler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        BOOL bSuccess = YES;
        if (responseData)
        {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300)
            {
                
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                
                bSuccess = YES;
            }
            else
            {
                
                NSLog(@"[ERROR] Server responded: status code %ld %@", (long)statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                
                bSuccess = NO;
            }
        }
        else
        {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
            bSuccess = NO;
        }
        [self TweetPostDone:bSuccess];
    };
   
    
    //????????????????????????????
    if(m_Photo != nil)
    {
        m_PostURL = [NSURL URLWithString:TWITTER_MEDIA_UPDATE_URL];
        m_TweetParams = [NSDictionary dictionaryWithObjectsAndKeys:
                         m_Tweet,  TTPOST_KEY_STATUS,
                         [NSString stringWithFormat:@"%f", m_dLat], TTPOST_KEY_LATITUDE,
                         [NSString stringWithFormat:@"%f", m_dLong], TTPOST_KEY_LONGITUDE,
                         @"true", TTPOST_KEY_DISPLAYCOORDINATES,
                         nil];
    }
    else
    {
        m_PostURL = [NSURL URLWithString:TWITTER_TEXT_UPDATE_URL];
        m_TweetParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                       m_Tweet,  TTPOST_KEY_STATUS,
                                       m_Latitude, TTPOST_KEY_LATITUDE,
                                       m_Longitude, TTPOST_KEY_LONGITUDE,
                                       @"true", TTPOST_KEY_DISPLAYCOORDINATES,
                                       nil];
    }

    m_PostRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:m_PostURL
                                                   parameters:m_TweetParams];
    
    if(m_Photo != nil)
    {
        m_ImageRawData = UIImageJPEGRepresentation(m_Photo, 1.f);
        [m_PostRequest addMultipartData:m_ImageRawData
                             withName:TTPOST_KEY_MEDIA_NAME_PARAMS
                                 type:TTPOST_KEY_MEDIA_TYPE_PARAMS
                             filename:TTPOST_KEY_MEDIA_FILE_PARAMS];
    }
    
    [m_PostRequest setAccount:m_Account];
    [m_PostRequest performRequestWithHandler:requestHandler];
}

-(void)PostTwitterTweet
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void)
    {
        [self StartPost];
    });
}

-(void)TweetPostDone:(BOOL)bSucceed
{
    if(m_Delegate != nil)
    {
        [m_Delegate PostTaskDone:self result:bSucceed];
    }
}

@end
