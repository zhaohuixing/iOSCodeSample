//
//  NOMTwitterAccountManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-16.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#include "SocialAPIConstants.h"
#import "NOMSocialAccountManager.h"
#import "NOMTwitterAccountManager.h"
#import "NOMAppInfo.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"

@interface NOMTwitterAccountManager()
{
    NOMSocialAccountManager*        m_Parent;
    BOOL                            m_bTwitterEnablingOnDevice;
    BOOL                            m_bTwiiterAccountGEOEnable;
    ACAccount*                      m_TwitterAccount;
    ACAccountStore*                 m_LocalAccountStore;
}

-(void)InitializeDefaultLocalTwitterAccount;
-(void)InitializeDefaultOnMapTwitterAccount;

@end

@implementation NOMTwitterAccountManager

-(BOOL)CheckTwitterEnablingOnDevice
{
    BOOL bEnable = NO;
    
    bEnable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    
    return bEnable;
}

-(void)CheckTwitterAccountLocationConfiguration
{
    NSString* userName = nil;
    
    if(m_TwitterAccount != nil)
    {
        userName = m_TwitterAccount.username;
    }
    
    if(m_TwitterAccount == nil || userName == nil || userName.length <= 0)
    {
        //???????
        return;
    }
    
    
    NSURL*              queryURL = [NSURL URLWithString:TWITTER_USER_SHOW_URL];
    NSDictionary*       tweetParams = [NSDictionary dictionaryWithObject:userName forKey:TTUSERACCOUNT_KEY_USER_SHOWNAME];
    
    
    SLRequest* getRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:queryURL
                                                   parameters:tweetParams];
    
    //[getRequest setAccount:m_TwitterAccount];
    getRequest.account = m_TwitterAccount;
    
    SLRequestHandler requestHandler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        BOOL bSuccess = YES;
        if (responseData)
        {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300)
            {
                NSError *jsonError;
                NSDictionary *queryResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                
                if(queryResponseData != nil)
                {
                    //??????????????
                    //??????????????
                    NSNumber* geoEnable = [queryResponseData objectForKey:TTUSERACCOUNT_KEY_USER_GEOENABLE];
                    if(geoEnable != nil)
                    {
                        bSuccess = [geoEnable boolValue];
                    }
                }
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
        m_bTwiiterAccountGEOEnable = bSuccess;
        [GUIEventLoop SendEvent:GUIID_TWITTER_ACCOUNT_GEOENABLING_CHECK_DONE eventSender:self];
    };
    [getRequest performRequestWithHandler:requestHandler];
}

-(void)LoadLocalAccount
{
    if(m_LocalAccountStore == nil)
    {
        m_LocalAccountStore = [[ACAccountStore alloc] init];
    }
    ACAccount* pAccount = nil;
    NSString* defUserName = [NOMAppInfo GetAppTwitterDevUserName];
    ACAccountType* defaultTwitterType = [m_LocalAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray* AccountList = [m_LocalAccountStore accountsWithAccountType:defaultTwitterType];
    if(AccountList != nil && 0 < AccountList.count)
    {
        //If don't find user account, use default system account
        for (ACAccount *account in AccountList)
        {
            if(account != nil && account.username != nil && 0 < account.username.length)
            {
                //if([account.username isEqualToString:defUserName] == NO)
                //{
                    m_TwitterAccount = account;
                    break;
                //}
            }
        }
    }
    //m_TwitterAccount = pAccount;
    if(m_TwitterAccount == nil)
    {
        m_bTwitterEnablingOnDevice = NO;
        [self InitializeDefaultOnMapTwitterAccount];
    }
    else
    {
        m_bTwitterEnablingOnDevice = YES;
        //?????Always asserted by queue if called from inside of ACAccountStoreRequestAccessCompletionHandler
        //[self CheckTwitterAccountLocationConfiguration];
    }
    [GUIEventLoop SendEvent:GUIID_TWITTER_ACCOUNT_INITIALIZATION_DONE eventSender:self];
}

-(void)InitializeDefaultLocalTwitterAccount
{
    if(m_LocalAccountStore == nil)
    {
        m_LocalAccountStore = [[ACAccountStore alloc] init];
    }
    ACAccountType* defaultTwitterType = [m_LocalAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccountStoreRequestAccessCompletionHandler handler = ^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            m_bTwitterEnablingOnDevice = YES;
            [self LoadLocalAccount];
        }
        else
        {
            m_bTwitterEnablingOnDevice = NO;
            NSLog(@"Erorr: %@", [error description]);
            [self InitializeDefaultOnMapTwitterAccount];
        }
        
        //block(granted);
    };
    [m_LocalAccountStore requestAccessToAccountsWithType:defaultTwitterType options:NULL completion:handler];
}

//
//Create a temporary user account with OnMap(or default development twiiter account) credential,
//and this temp account will not be save to device account store.
//
-(void)InitializeDefaultOnMapTwitterAccount
{
    NSString* defToken = [NOMAppInfo GetAppTwitterAccessToken];
    NSString* defSecret = [NOMAppInfo GetAppTwitterAccessTokenSecret];
    NSString* defUserName = [NOMAppInfo GetAppTwitterDevUserName];
    ACAccountCredential* defaultCredential = [[ACAccountCredential alloc] initWithOAuthToken:defToken tokenSecret:defSecret];
    
    ACAccountStore* accountStore = [[ACAccountStore alloc] init];

    ACAccountType* defaultTwitterType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    m_TwitterAccount = [[ACAccount alloc] initWithAccountType:defaultTwitterType];
    m_TwitterAccount.credential = defaultCredential;
    m_TwitterAccount.username = defUserName;
    [GUIEventLoop SendEvent:GUIID_TWITTER_ACCOUNT_INITIALIZATION_DONE eventSender:self];
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Parent = nil;
        m_bTwiiterAccountGEOEnable = NO;
        m_TwitterAccount = nil;
        m_LocalAccountStore = nil;
        m_bTwitterEnablingOnDevice = NO;
    }
    
    return self;
}

-(void)SetParent:(NOMSocialAccountManager*)parent
{
    m_Parent = parent;
}

-(void)LoadAccount
{
    m_bTwiiterAccountGEOEnable = NO;
    m_TwitterAccount = nil;
    m_LocalAccountStore = nil;
    m_bTwitterEnablingOnDevice = [self CheckTwitterEnablingOnDevice];
    if(m_bTwitterEnablingOnDevice)
        [self InitializeDefaultLocalTwitterAccount];
    else
        [self InitializeDefaultOnMapTwitterAccount];
    
}

-(BOOL)UserGEOEnable
{
    return m_bTwiiterAccountGEOEnable;
}

-(BOOL)HasUserAccountInDevice
{
    return m_bTwitterEnablingOnDevice;
}

-(ACAccount*)GetUserAccount
{
    ACAccount* pAccount = nil;
    if(m_bTwitterEnablingOnDevice == NO)
        return pAccount;
    
    return m_TwitterAccount;
}

-(void)CheckUserAccountGEOEnabling
{
    [self CheckTwitterAccountLocationConfiguration];
}
@end
