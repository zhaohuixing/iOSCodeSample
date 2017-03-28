//
//  TTTrafficSearch.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2/22/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TomTomLBS/TTLBSSDK.h>

@protocol TTTrafficSearchDelegate <NSObject>

@optional
-(void)TrafficSearchDone:(id)pTTSearch withResult:(BOOL)bSucceed;

@end


#ifdef _USING_GCD_TTT_SEARCH
@interface TTTrafficSearch : NSObject<TTAPITrafficDelegate> //NSOperation<TTAPITrafficDelegate>//, NOMTrafficRouteSourceLoadDelegate>
#else
@interface TTTrafficSearch : NSOperation<TTAPITrafficDelegate>
#endif

-(id)initWith:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withZoom:(double)dZoom;

-(void)RegisterDelegate:(id<TTTrafficSearchDelegate>)delegate;

-(BOOL)IsSucceeded;
-(BOOL)IsCompleted;

-(NSArray*)GetRecordList;
-(void)SearchTraffic:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withZoom:(double)dZoom;
-(void)SetTrafficSearchParameters:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withZoom:(double)dZoom;
#ifdef _USING_GCD_TTT_SEARCH
-(void)StartSearch;
#endif

@end
