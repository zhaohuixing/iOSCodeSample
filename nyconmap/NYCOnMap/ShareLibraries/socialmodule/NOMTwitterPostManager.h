//
//  NOMTwitterPostManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-21.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "NOMNewsMetaDataRecord.h"
#import "INOMSocialServiceInterface.h"


@class NOMSocialPostManager;
@interface NOMTwitterPostManager : NSObject<INOMTwitterPostTaskDelegate>

-(void)SetParent:(NOMSocialPostManager*)parent;
-(void)StartSharing:(NOMNewsMetaDataRecord*)pNewsMetaData withPost:(NSString*)szPost withImage:(UIImage*)pImage toAccount:(ACAccount*)pAccount;
-(void)PostTaskDone:(id)task result:(BOOL)succed;
-(void)StartSpotTwitterSharing:(NOMTrafficSpotRecord*)pSpot toAccount:(ACAccount*)pAccount;

@end
