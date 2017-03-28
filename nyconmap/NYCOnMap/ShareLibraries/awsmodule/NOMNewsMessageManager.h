//
//  NOMNewsMessageManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-19.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NOMAWSServiceProtocols.h"
#import "AmazonClientManager.h"
//#import "NOMNewsQueryTask.h"

@interface NOMNewsMessageManager : NSObject<INOMNewsMessageQCreationDelegate, INOMNewsMessageQSubscribeDelegate, INOMNewsMessageQFindDelegate, INOMNewsQueryTaskDelegate>

//+(NOMNewsMessageManager*)GetSharedTrafficMessageManager;

-(id)initWithQueueName:(NSString*)queueName withSQSRentionTime:(int)nRentionTime;

-(NSDictionary*)GetCachedTrafficMessages;

-(void)RegisterDelegate:(id<NOMNewsMessageManagerDelegate>)delegate;
-(void)RegisterNewsTopic:(NSString*)topicARN withSNSClient:(AmazonSNSClient*)snsService;
-(void)InitializeMessageQueueService;
-(void)SubcribeNewsMessageQueueToNoficationService;

-(AmazonSQSClient*)GetNewsMessageSQSClient;
-(NSString*)GetNewsMessageTopicARN;
-(NSString*)GetNewsMessageQueueName;
-(NSString*)GetNewsMessageQueueURL;
-(NSString*)GetNewsMessageQueueARN;
-(void)RemoveNewsRecordByTimeStamp:(int64_t)nTimeBefore;
-(void)QueryNewsRecordsFromSQS;

//
//INOMNewsMessageQCreationDelegate methods
//
-(void)MessageQCreationDone:(id)Qservice result:(BOOL)bOK;

//
//INOMNewsMessageQFindDelegate method
//
-(void)MessageQFindDone:(id)QFinder result:(BOOL)bSucceed;

//
//INOMNewsMessageQSubscribeDelegate
//
-(void)MessageQSubscribeDone:(id)Qservice result:(BOOL)bOK;

//
//Collect Data to Apple Watch open reqest
//
-(void)CollectNewsDataForAppleWatch:(NSMutableDictionary*)collectionSet storageKey:(NSString*)szKey;
-(void)CollectNewsDataFromSocialMediaForAppleWatch:(NSMutableDictionary*)collectionSet storageKey:(NSString*)szKey;

@end
