//
//  NOMPreference.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-20.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMPreference.h"
#import "NOMAppInfo.h"

static NOMPreference* g_Preference = nil;

@interface NOMPreference ()
{
    NSString*           m_TrafficMessageQueueName;
    NSString*           m_TaxiMessageQueueName;
    NSString*           m_AWSDeviceToken;
    NSString*           m_AWSEndPointARN;
    NSString*           m_CurrentRegionKey;
    
    BOOL                m_bAutoRegionChangeSwitch;
    BOOL                m_bAskRegionChangeSwitchSearchRegionFlag;
}

-(void)InitializeAWSPreference;
-(void)SaveTrafficMessageQueueName;
-(void)SaveTaxiMessageQueueName;
-(void)SaveAWSDeviceToken;
-(void)LoadAWSDeviceToken;
-(void)SaveAWSEndPointARN;
-(void)LoadAWSEndPointARN;

-(void)SaveCurrentRegionKey;
-(void)LoadCurrentRegionKey;

-(void)SaveAutoRegionChangeSwitch;
-(void)LoadAutoRegionChangeSwitch;
-(void)SaveAskRegionChangeSwitchSearchRegionFlag;
-(void)LoadAskRegionChangeSwitchSearchRegionFlag;

@end

@implementation NOMPreference

+(NOMPreference*)GetSharedPreference
{
    if(g_Preference == nil)
    {
        g_Preference = [[NOMPreference alloc] init];
    }
    return g_Preference;
}

+(void)InitSharedPreference
{
    if(g_Preference == nil)
    {
        g_Preference = [[NOMPreference alloc] init];
    }
}

-(id)init
{
    self = [super init];
    if(self)
    {
        m_TrafficMessageQueueName = nil;
        m_TaxiMessageQueueName = nil;
        m_AWSDeviceToken = nil;
        m_AWSEndPointARN = nil;
        m_CurrentRegionKey = nil;
        m_bAutoRegionChangeSwitch = NO;
        m_bAskRegionChangeSwitchSearchRegionFlag = YES;
        [self InitializeAWSPreference];
    }
    
    return self;
}

-(void)SaveTrafficMessageQueueName
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* szMsgQKey = [NOMAppInfo GetTrafficMessageQueueKey];
    [prefs setObject:m_TrafficMessageQueueName forKey:szMsgQKey];
    [prefs synchronize];
}

-(void)SaveTaxiMessageQueueName
{
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* szMsgQKey = [NOMAppInfo GetTaxiMessageQueueKey];
    [prefs setObject:m_TaxiMessageQueueName forKey:szMsgQKey];
    [prefs synchronize];
}

-(void)InitializeAWSPreference
{
	[NSUserDefaults resetStandardUserDefaults];
    NSString* szMsgQKey = [NOMAppInfo GetTrafficMessageQueueKey];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    m_TrafficMessageQueueName = [prefs stringForKey:szMsgQKey];
    NSString* guidUIID = [[NSUUID UUID] UUIDString];
    if(m_TrafficMessageQueueName == nil || [m_TrafficMessageQueueName length] <= 0)
    {
        NSString* namePrefix = [NOMAppInfo GetTrafficMessageQueueNamePrefix];
        NSString* guidStr = guidUIID;
        guidStr = [guidStr stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        m_TrafficMessageQueueName = [NSString stringWithFormat:@"%@%@", namePrefix, guidStr];
        [self SaveTrafficMessageQueueName];
    }

    szMsgQKey = [NOMAppInfo GetTaxiMessageQueueKey];
    m_TaxiMessageQueueName = [prefs stringForKey:szMsgQKey];
    if(m_TaxiMessageQueueName == nil || [m_TaxiMessageQueueName length] <= 0)
    {
        NSString* namePrefix1 = [NOMAppInfo GetTaxiMessageQueueNamePrefix];
        NSString* guidStr1 = guidUIID;
        guidStr1 = [guidStr1 stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        m_TaxiMessageQueueName = [NSString stringWithFormat:@"%@%@", namePrefix1, guidStr1];
        [self SaveTaxiMessageQueueName];
    }
    
    
    [self LoadAWSDeviceToken];
    [self LoadAWSEndPointARN];
    [self LoadCurrentRegionKey];
    [self LoadAutoRegionChangeSwitch];
    [self LoadAskRegionChangeSwitchSearchRegionFlag];
}

-(NSString*)GetTrafficMessageQueueName
{
    return m_TrafficMessageQueueName;
}

-(NSString*)GetTaxiMessageQueueName
{
    return m_TaxiMessageQueueName;
}

-(NSString*)GetAWSDeviceToken
{
    return m_AWSDeviceToken;
}

-(void)SetAWSDeviceToken:(NSString*)deviceToken
{
    m_AWSDeviceToken = deviceToken;
    [self SaveAWSDeviceToken];
}

-(void)SaveAWSDeviceToken
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* szKey = [NOMAppInfo GetAWSDeviceTokenPrefKey];
    [prefs setObject:m_AWSDeviceToken forKey:szKey];
    [prefs synchronize];
}

-(void)LoadAWSDeviceToken
{
    NSString* szMsgQKey = [NOMAppInfo GetAWSDeviceTokenPrefKey];
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    m_AWSDeviceToken = [prefs stringForKey:szMsgQKey];
}

-(NSString*)GetAWSEndPointARN
{
    return m_AWSEndPointARN;
}

-(void)SetAWSEndPointARN:(NSString*)EndPointARN
{
    m_AWSEndPointARN = EndPointARN;
    [self SaveAWSEndPointARN];
}

-(void)SaveAWSEndPointARN
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* szKey = [NOMAppInfo GetAWSMobileEndPointARNPrefKey];
    [prefs setObject:m_AWSEndPointARN forKey:szKey];
    [prefs synchronize];
}

-(void)LoadAWSEndPointARN
{
    NSString* szKey = [NOMAppInfo GetAWSMobileEndPointARNPrefKey];
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    m_AWSEndPointARN = [prefs stringForKey:szKey];
}

-(NSString*)GetCurrentRegionKey
{
    return m_CurrentRegionKey;
}

-(void)SetCurrentRegionKey:(NSString*)regionKey
{
    m_CurrentRegionKey = regionKey;
    [self SaveCurrentRegionKey];
}

-(void)SaveCurrentRegionKey
{
#ifndef _SINGLE_CITYAPP_
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* szKey = [NOMAppInfo GetCurrentRegionPrefKey];
    [prefs setObject:m_CurrentRegionKey forKey:szKey];
    [prefs synchronize];
#endif
}

-(void)LoadCurrentRegionKey
{
#ifndef _SINGLE_CITYAPP_
    NSString* szKey = [NOMAppInfo GetCurrentRegionPrefKey];
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    m_CurrentRegionKey = [prefs stringForKey:szKey];
#endif
}

#define DEFAULT_AUTO_REGION_CHANGE_KEY                          @"onmap_auto_region_switch_key"
#define DEFAULT_ASK_REGION_CHANGE_SWITCH_REGION_KEY             @"onmap_ask_region_change_switch_region_key"

-(void)SaveAutoRegionChangeSwitch
{
#ifndef _SINGLE_CITYAPP_
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:m_bAutoRegionChangeSwitch forKey:DEFAULT_AUTO_REGION_CHANGE_KEY];
    [prefs synchronize];
#endif
}

-(void)LoadAutoRegionChangeSwitch
{
#ifndef _SINGLE_CITYAPP_
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    m_bAutoRegionChangeSwitch = [prefs boolForKey:DEFAULT_AUTO_REGION_CHANGE_KEY];
#endif
}

-(void)SaveAskRegionChangeSwitchSearchRegionFlag
{
#ifndef _SINGLE_CITYAPP_
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:m_bAskRegionChangeSwitchSearchRegionFlag forKey:DEFAULT_ASK_REGION_CHANGE_SWITCH_REGION_KEY];
    [prefs synchronize];
#endif
}

-(void)LoadAskRegionChangeSwitchSearchRegionFlag
{
#ifndef _SINGLE_CITYAPP_
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    m_bAskRegionChangeSwitchSearchRegionFlag = [prefs boolForKey:DEFAULT_ASK_REGION_CHANGE_SWITCH_REGION_KEY];
#endif
}

-(BOOL)GetAutoRegionChangeSwitch
{
#ifndef _SINGLE_CITYAPP_
    return m_bAutoRegionChangeSwitch;
#else
    return NO;
#endif
}

-(void)SetAutoRegionChangeSwitch:(BOOL)bEnable
{
#ifndef _SINGLE_CITYAPP_
    m_bAutoRegionChangeSwitch = bEnable;
    [self SaveAutoRegionChangeSwitch];
#endif
}

-(BOOL)GetAskRegionChangeSwitchSearchRegionFlag
{
#ifndef _SINGLE_CITYAPP_
    return m_bAskRegionChangeSwitchSearchRegionFlag;
#else
    return NO;
#endif
}

-(void)SetAskRegionChangeSwitchSearchRegionFlag:(BOOL)bEnable
{
#ifndef _SINGLE_CITYAPP_
    m_bAskRegionChangeSwitchSearchRegionFlag = bEnable;
    [self SaveAskRegionChangeSwitchSearchRegionFlag];
#endif
}

-(void)Save
{
    
}

-(void)Load
{
    
}


@end
