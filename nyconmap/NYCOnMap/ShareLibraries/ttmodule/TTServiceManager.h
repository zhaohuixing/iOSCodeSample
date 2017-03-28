//
//  TTServiceManager.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2/20/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <TomTomLBS/TTLBSSDK.h>
#import <Foundation/Foundation.h>
#import "TTTrafficSearch.h"
#import "NOMOperationCompleteDelegate.h"

@protocol TTServiceManagerDelegate <NSObject>

@optional
-(void)TrafficSearchDone:(NSArray*)pRouteList withResult:(BOOL)bSucceed;

@end

#ifdef _USING_GCD_TTT_SEARCH
@interface TTServiceManager : NSObject<TTTrafficSearchDelegate>
#else
@interface TTServiceManager : NSObject<TTTrafficSearchDelegate, NOMOperationCompleteDelegate>
#endif

+(void)RegisterTTService;
//+(TTServiceManager*)getServiceManager;

//+(void)InitializeTTService:(id<TTServiceManagerDelegate>)delegate;
-(void)RegisterDelegate:(id<TTServiceManagerDelegate>)delegate;
-(void)SearchTraffic:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withZoom:(double)dZoom;

#ifdef _USING_GCD_TTT_SEARCH
-(void)TrafficSearchDone:(id)pTTSearch withResult:(BOOL)bSucceed;
#endif

@end
