//
//  NOMSocialAccountManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "INOMSocialServiceInterface.h"

@interface NOMSocialAccountManager : NSObject

-(void)RegisterDelegate:(id<INOMSocialAccountManagerDelegate>)delegate;
-(BOOL)IsAccountInitialized;
-(void)InitializeAccount;

-(void)CheckTwitterAccountGEOEnabling;
-(BOOL)TwitterAccountGEOEnable;
-(BOOL)HasTwitterUserAccountInDevice;
-(ACAccount*)GetTwitterUserAccount;

@end
