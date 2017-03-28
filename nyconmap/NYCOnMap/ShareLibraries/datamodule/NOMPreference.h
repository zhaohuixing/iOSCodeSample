//
//  NOMPreference.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-20.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMPreference : NSObject

+(NOMPreference*)GetSharedPreference;
+(void)InitSharedPreference;

-(void)Save;
-(void)Load;

-(NSString*)GetTrafficMessageQueueName;
-(NSString*)GetTaxiMessageQueueName;
-(NSString*)GetAWSDeviceToken;
-(void)SetAWSDeviceToken:(NSString*)deviceToken;
-(NSString*)GetAWSEndPointARN;
-(void)SetAWSEndPointARN:(NSString*)EndPointARN;

-(NSString*)GetCurrentRegionKey;
-(void)SetCurrentRegionKey:(NSString*)regionKey;
-(BOOL)GetAutoRegionChangeSwitch;
-(void)SetAutoRegionChangeSwitch:(BOOL)bEnable;
-(BOOL)GetAskRegionChangeSwitchSearchRegionFlag;
-(void)SetAskRegionChangeSwitchSearchRegionFlag:(BOOL)bEnable;


@end
