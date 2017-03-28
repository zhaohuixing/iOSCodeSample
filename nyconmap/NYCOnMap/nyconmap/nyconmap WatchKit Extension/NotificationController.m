//
//  NotificationController.m
//  nyconmap WatchKit Extension
//
//  Created by Zhaohui Xing on 2015-03-26.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NotificationController.h"
#import "NOMDataEncryptionHelper.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"

@interface NotificationController()
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *m_AlertText;

@end


@implementation NotificationController

- (instancetype)init {
    self = [super init];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
        
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

/*
- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
    // This method is called when a local notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}
*/
-(BOOL)IsValidNewsMetaDataMainCategory:(int16_t)nMainCate
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

-(int16_t)ConvertToSpotTypeIDFromNewsCategoryID:(int16_t)newsMainCateType;
{
    int16_t nRet = newsMainCateType - NOM_NEWSCATEGORY_NONENEWS_BASE_ID;
    return nRet;
}


-(BOOL)ProcessRemoteNotificationNewsData:(NSDictionary*)jsonData
{
    if(jsonData == nil || jsonData.count <= 0)
        return NO;
    
    NSNumber* newCategory = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSCATEGORY];
    if(newCategory == nil)
        return NO;
    int16_t _m_NewsMainCategory = (int16_t)[newCategory intValue];
    
    NSNumber* newSubCategory = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSSUBCATEGORY];
    if(newSubCategory == nil)
        return NO;
    int16_t _m_NewsSubCategory = (int16_t)[newSubCategory intValue];
    
    int16_t _m_NewsThirdCategory = 0;
    
    NSNumber* new3rdCategory = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSTHIRDCATEGORY];
    if(new3rdCategory != nil)
    {
        _m_NewsThirdCategory = (int16_t)[new3rdCategory intValue];
    }
    
    
    NSString* _m_NewsPosterEmail = [jsonData objectForKey:NOM_NEWSJSON_TAG_PUBLISHEREMAIL];
    NSString* _m_NewsPosterDisplayName = [jsonData objectForKey:NOM_NEWSJSON_TAG_PUBLISHERDISPLAYNAME];
    
    NSString* sPoster = @"Someone";
    
    if(_m_NewsPosterDisplayName != nil && 0 < _m_NewsPosterDisplayName.length)
    {
        sPoster = _m_NewsPosterDisplayName;
    }
    else if(_m_NewsPosterEmail != nil && 0 < _m_NewsPosterEmail.length)
    {
        sPoster = _m_NewsPosterEmail;
    }
        
    
    if([self IsValidNewsMetaDataMainCategory:_m_NewsMainCategory] == NO)
    {
        int16_t nSpotType = [self ConvertToSpotTypeIDFromNewsCategoryID:_m_NewsMainCategory];
        int16_t nSubType = _m_NewsSubCategory;
        
        NSString* msgTitle = [StringFactory GetString_SpotSubTitle:nSpotType sithSubTitle:nSubType];
        
        NSString* msg = [NSString stringWithFormat:@"%@ Shares %@ information", sPoster, msgTitle];
        [self.m_AlertText setText:msg];
        return YES;
    }
    
    if(_m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI)
    {
        NSString* msg = [NSString stringWithFormat:@"%@ Shares taxi information", sPoster];
        [self.m_AlertText setText:msg];
        return YES;
    }
    else
    {
        NSString* msgTitle;
        
        if(_m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
        {
            msgTitle = [StringFactory GetString_TrafficTypeTitle:_m_NewsSubCategory withType:_m_NewsThirdCategory];
        }
        else
        {
            msgTitle = [StringFactory GetString_NewsTitle:_m_NewsMainCategory subCategory:_m_NewsSubCategory];
        }
        
        NSString* msg = [NSString stringWithFormat:@"%@ Shares %@ information", sPoster, msgTitle];
        [self.m_AlertText setText:msg];
        return YES;
    }
    
    
    return NO;
}


-(BOOL)PorcessNewsDataFromRemoteNotificationDictionary:(NSDictionary*)ndAlert
{
    BOOL bRet = NO;
    
    if(ndAlert != nil)
    {
        if([ndAlert objectForKey:@"body"] != nil)
        {
            if([[ndAlert objectForKey:@"body"] isKindOfClass:[NSString class]] == YES)
            {
                NSString* sRPAlert = [ndAlert objectForKey:@"body"];
                bRet = [self PorcessNewsDataFromRemoteNotificationString:sRPAlert];
            }
            else if([[ndAlert objectForKey:@"body"] isKindOfClass:[NSDictionary class]] == YES)
            {
                NSDictionary* ndRPAlert = [ndAlert objectForKey:@"body"];
                bRet = [self PorcessNewsDataFromRemoteNotificationDictionary:ndRPAlert];
            }
        }
        else
        {
            bRet = [self ProcessRemoteNotificationNewsData:ndAlert];
            if(bRet == NO)
            {
                [self.m_AlertText setText:@"Receive Posting Message!"];
            }
        }
    }
    
    return bRet;
}

-(BOOL)PorcessNewsDataFromRemoteNotificationString:(NSString*)sAlert
{
    BOOL bRet = NO;
    
    if(sAlert != nil && 0 < sAlert.length)
    {
        NSError *jsonError = nil;
        NSData* rawData = [sAlert dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:rawData options:kNilOptions error:&jsonError];
        if(jsonObject != nil && [jsonObject isKindOfClass:[NSDictionary class]] == YES)
        {
            bRet = [self PorcessNewsDataFromRemoteNotificationDictionary:jsonObject];
        }
    }
    return bRet;
}

-(void)ParserNotificationContent:(NSDictionary *)userInfo
{
    if(userInfo != nil)
    {
        NSDictionary* appData = [userInfo objectForKey:@"aps"];
        if(appData != nil)
        {
            if([appData objectForKey:@"alert"] != nil)
            {
                if([[appData objectForKey:@"alert"] isKindOfClass:[NSDictionary class]] == YES)
                {
                    NSDictionary* ndRPAlert = [appData objectForKey:@"alert"];
                    [self PorcessNewsDataFromRemoteNotificationDictionary:ndRPAlert];
                }
                else if([[appData objectForKey:@"alert"] isKindOfClass:[NSString class]] == YES)
                {
                    NSString* szMessageBody = [appData objectForKey:@"alert"];
                    NSString* rawJSONString = [NOMDataEncryptionHelper DecodingData:szMessageBody];
                    if(!(rawJSONString == nil || rawJSONString.length == 0))
                    {
                        NSError *jsonError = nil;
                        NSData* rawData = [rawJSONString dataUsingEncoding:NSUTF8StringEncoding];
                        id jsonObject = [NSJSONSerialization JSONObjectWithData:rawData options:kNilOptions error:&jsonError];
                        if(jsonObject != nil)
                        {
                            if ([jsonObject isKindOfClass:[NSDictionary class]])
                            {
                                NSLog(@"its probably a dictionary");
                                NSDictionary *jsonDictionarySrc = (NSDictionary *)jsonObject;
                                NSLog(@"jsonDictionary - %@", jsonDictionarySrc);
                                if(jsonDictionarySrc != nil)
                                {
                                    [self PorcessNewsDataFromRemoteNotificationDictionary:jsonDictionarySrc];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler
{
    // This method is called when a remote notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    [self ParserNotificationContent:remoteNotification];
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}


@end



