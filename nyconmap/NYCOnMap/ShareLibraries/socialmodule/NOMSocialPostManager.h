//
//  NOMSocialPostManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-21.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMNewsMetaDataRecord.h"
#import "NOMTrafficSpotRecord.h"
#import <Social/Social.h>

@interface NOMSocialPostManager : NSObject

-(void)StartTwitterSharing:(NOMNewsMetaDataRecord*)pNewsMetaData withPost:(NSString*)szPost withImage:(UIImage*)pImage toAccount:(ACAccount*)pAccount;
-(void)StartSpotTwitterSharing:(NOMTrafficSpotRecord*)pSpot toAccount:(ACAccount*)pAccount;

@end
