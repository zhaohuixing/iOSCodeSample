//
//  NOMTwitterSearchManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-10-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "INOMSocialServiceInterface.h"

@class NOMSocialSearchManager;
@interface NOMTwitterSearchManager : NSObject<INOMTwitterSearchTaskDelegate>

-(void)SetParent:(NOMSocialSearchManager*)parent;
-(void)Search:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate withAccount:(ACAccount*)account fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd;
-(void)Search:(int16_t)nMainCate withAccount:(ACAccount*)account fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd;

@end
