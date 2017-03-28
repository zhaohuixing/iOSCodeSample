//
//  NOMNewsTopicManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AmazonClientManager.h"
#import "NOMOperationCompleteDelegate.h"
#import "NOMAWSServiceProtocols.h"

@protocol NOMNewsTopicDelegate <NSObject>

@optional

-(void)TrafficTopicHookupDone;
-(void)TaxiTopicHookupDone;
-(void)MobileDeviceSubscribeDone;

@end


@interface NOMNewsTopicManager : NSObject<INOMMobileEndPointARNCreationDelegate,
                                            INOMMobileDeviceSubscribeDelegate,
                                            INOMNewsTopicSearchDelegate,
                                            INOMNewsTopicCreateDelegate>

-(id)initWithTopicName:(NSString*)szTopic;
-(id)initWithTrafficTopicName:(NSString*)szTrafficTopic withTaxiTopicName:(NSString*)szTaxiTopic;

-(void)RegisterDelegate:(id<NOMNewsTopicDelegate>)delegate;
-(void)HookupTrafficTopic;
-(void)HookupTaxiTopic;

-(NSString*)GetTrafficTopicARN;
-(NSString*)GetTrafficTopicName;

-(NSString*)GetTaxiTopicARN;
-(NSString*)GetTaxiTopicName;

-(NSString*)GetEndPointARN;
-(AmazonSNSClient*)GetSNSClient;

-(void)InitializeMobilePushEndPointTrafficARN;
-(void)InitializeMobilePushEndPointTaxiARN;
-(void)HandleActiveRegionChanged;

//
// INOMMobileEndPointARNCreationDelegate methods
//
-(void)MobileEndPointARNCreation:(id)ARNCreation result:(BOOL)bOK;

//
//INOMMobileDeviceSubscribeDelegate methods
//
-(void)NewsMobileDeviceSubscribeCreation:(id)subrciption result:(BOOL)bOK;

//
//INOMNewsTopicSearchDelegate methods
//
-(void)NewsTopicSearchCompletion:(id)search result:(BOOL)bOK;

//
//INOMNewsTopicCreateDelegate methods
//
-(void)NewsTopicCreateCompletion:(id)creation result:(BOOL)bOK;

@end
