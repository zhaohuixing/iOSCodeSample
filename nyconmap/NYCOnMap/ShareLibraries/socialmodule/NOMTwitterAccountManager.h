//
//  NOMTwitterAccountManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-16.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>


@class NOMSocialAccountManager;
@interface NOMTwitterAccountManager : NSObject

-(void)SetParent:(NOMSocialAccountManager*)parent;
-(void)LoadAccount;
-(BOOL)UserGEOEnable;
-(BOOL)HasUserAccountInDevice;
-(ACAccount*)GetUserAccount;
-(void)CheckUserAccountGEOEnabling;
@end
