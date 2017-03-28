//
//  NOMPublishController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "NOMNewsTopicManager.h"
#import "NOMOperationManager.h"
#import "NOMTrafficSpotRecord.h"
#import "NOMNewsMessagePublishManager.h"
#import "NOMAWSServiceProtocols.h"

@protocol NOMPublishControllerDelegate <NSObject>

@optional

-(void)TrafficTopicHookupDone;
-(void)TaxiTopicHookupDone;
-(void)MobileDeviceSubscribeDone;
-(void)SpotPublished:(NOMTrafficSpotRecord*)pSpot;
-(void)NewsPublishedSuceed:(NOMNewsMetaDataRecord*)pSpot;
-(ACAccount*)GetCurrentTwitterAccount;

@end


@interface NOMPublishController : NSObject<NOMNewsTopicDelegate, INOMTrafficSpotReportDelegate, INOMNewsMessagePublishManagerDelegate>

-(void)HookupTrafficTopic;
-(void)HookupTaxiTopic;
-(void)RegisterDelegate:(id<NOMPublishControllerDelegate>)delegate;

-(NSString*)GetTrafficTopicARN;
-(NSString*)GetTrafficTopicName;
-(NSString*)GetTaxiTopicARN;
-(NSString*)GetTaxiTopicName;

-(AmazonSNSClient*)GetSNSClient;
-(void)InitializeMobilePushEndPointTrafficARN;
-(void)InitializeMobilePushEndPointTaxiARN;
-(void)HandleActiveRegionChanged;
-(void)PublishSpot:(NOMTrafficSpotRecord*)pRecord shareOnTwitter:(BOOL)bShareOnTwitter;
-(void)NOMTrafficMessagePublishDone:(NOMNewsMetaDataRecord*)pData result:(BOOL)bSuceeded;

-(void)StartPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData
         withSubject:(NSString*)szSubject
            withPost:(NSString*)szPost
         withKeyWord:(NSString*)szKeyWord
       withCopyRight:(NSString*)szCopyRight
             withKML:(NSString*)szKML
           withImage:(UIImage*)pImage
      shareOnTwitter:(BOOL)bShareOnTwitter;

-(void)DirectPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData;
-(void)StartPostTaxiInformation:(NOMNewsMetaDataRecord*)pNewsMetaData;

@end
