//
//  NOMSocialAccountManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSocialAccountManager.h"
#import "NOMTwitterAccountManager.h"

@interface NOMSocialAccountManager ()
{
    id<INOMSocialAccountManagerDelegate>    m_Delegate;
    NOMTwitterAccountManager*               m_TwitterAccount;
    BOOL                                    m_bAccountInitialization;
}

@end

@implementation NOMSocialAccountManager

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Delegate = nil;
        m_bAccountInitialization = NO;
        m_TwitterAccount = [[NOMTwitterAccountManager alloc] init];
        [m_TwitterAccount SetParent:self];
    }
    
    return self;
}

-(void)RegisterDelegate:(id<INOMSocialAccountManagerDelegate>)delegate
{
    m_Delegate = delegate;
}

-(BOOL)IsAccountInitialized
{
    return m_bAccountInitialization;
}

-(void)InitializeAccount
{
    m_bAccountInitialization = YES;
    [m_TwitterAccount LoadAccount];
}

-(void)CheckTwitterAccountGEOEnabling
{
    [m_TwitterAccount CheckUserAccountGEOEnabling];
}

-(BOOL)TwitterAccountGEOEnable
{
    return [m_TwitterAccount UserGEOEnable];
}

-(BOOL)HasTwitterUserAccountInDevice
{
    return [m_TwitterAccount HasUserAccountInDevice];
}

-(ACAccount*)GetTwitterUserAccount
{
    return [m_TwitterAccount GetUserAccount];
}

@end
