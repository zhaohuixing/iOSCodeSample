//
//  NOMBrowseController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-19.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "NOMNewsMessageManager.h"
#import "NOMNewsMetaDataRecord.h"
#import "INOMSocialServiceInterface.h"
#import "NOMAWSServiceProtocols.h"
#ifdef USING_TOMTOMSDK
#import "TTServiceManager.h"
#endif


@protocol NOMBrowseControllerDelegate <NSObject>

@optional

-(void)TrafficMessageQueueInitialized:(BOOL)bNeedSubcribe;
-(void)TaxiMessageQueueInitialized:(BOOL)bNeedSubcribe;
-(void)HandleSearchTrafficSpotList:(NSArray*)spotList withSpotType:(int16_t)nType;
-(void)PinNewsDataOnMap:(NOMNewsMetaDataRecord*)pNewsData;
-(ACAccount*)GetCurrentTwitterAccount;

-(void)HandleSoicalSearchToWatch:(NSArray*)rawDataList;
-(void)SendTrafficMessagesToWatch:(NSArray*)rawDataList;
-(void)SendTaxiMessagesToWatch:(NSArray*)rawDataList;


@end

#ifdef USING_TOMTOMSDK
@interface NOMBrowseController : NSObject<TTServiceManagerDelegate, NOMNewsMessageManagerDelegate, INOMTrafficSpotQueryDelegate, INOMSoicalSearchDelegate>

//
//
// TTServiceManagerDelegate methods
//
//
-(void)TrafficSearchDone:(NSArray*)pRouteList withResult:(BOOL)bSucceed;

#else

@interface NOMBrowseController : NSObject<NOMNewsMessageManagerDelegate, INOMTrafficSpotQueryDelegate, INOMSoicalSearchDelegate>

#endif

-(void)RegisterDelegate:(id<NOMBrowseControllerDelegate>)delegate;

-(void)RegisterTrafficTopic:(NSString*)topicARN withSNSClient:(AmazonSNSClient*)snsService;
-(void)InitializeTrafficMessageQueueService;

-(void)RegisterTaxiTopic:(NSString*)topicARN withSNSClient:(AmazonSNSClient*)snsService;
-(void)InitializeTaxiMessageQueueService;


-(void)HandleActiveRegionChanged;
-(void)SearchTrafficSpots:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd;
-(void)SearchTrafficSpotRecords:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withType:(int16_t)nType;
-(void)SearchTrafficSpotRecords:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withType:(int16_t)nType withSubType:(int16_t)nSubType;

-(void)BrowseSpots:(int16_t)nType spotDS:(int16_t)nSpotDS;
-(void)BrowseNewsFromSQS:(int16_t)nMainCate subCate:(int16_t)nSubCate thirdCate:(int16_t)nThirdCate;
-(void)SubcribeTrafficMessageQueueToNoficationService;
-(void)SubcribeTaxiMessageQueueToNoficationService;
-(void)QueryAllDataFromTrafficSQS;
-(void)QueryAllDataFromTaxiSQS;

-(void)HandleSearchResult:(id)record;
-(void)HandleSoicalSearchToWatch:(NSArray*)dataArray;
-(void)BrowseAllTrafficNews;
-(void)BrowseAllTaxiNews;
//
//
// INOMTrafficSpotQueryDelegate methods
//
//
-(void)NOMTrafficSpotQueryTaskDone:(id)task result:(BOOL)bSuceeded;


@end
