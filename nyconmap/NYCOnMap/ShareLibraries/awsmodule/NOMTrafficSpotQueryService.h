//
//  NOMTrafficSpotQueryService.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmazonClientManager.h"
#import "NOMAWSServiceProtocols.h"
#import "NOMTrafficSpotRecord.h"

@interface NOMTrafficSpotQueryService : NSObject  //NSOperation<AmazonServiceRequestDelegate>

-(id)initWithDomain:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd;

-(id)initWithDomain:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withSubType:(int16_t)nSubType;

-(id)initWithDomain:(NSString *)domain wittQuery:(NSString*)query;

-(void)RegisterDelegate:(id<INOMTrafficSpotQueryDelegate>)delegate;

-(NSArray*)GetItemList;

-(void)StartQuery;

-(void)SetSpotType:(int16_t)nType;
-(int16_t)GetSpotType;


@end
