//
//  NOMTrafficSpotSearchManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMAWSServiceProtocols.h"

@interface NOMTrafficSpotSearchManager : NSObject

-(id)initWithOperationManager:(NSMutableArray*)operMan;

-(void)RegisterDelegate:(id<INOMTrafficSpotQueryDelegate>)delegate;

-(void)SearchSpotRecords:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withType:(int16_t)nType;
-(void)SearchSpotRecords:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withType:(int16_t)nType withSubType:(int16_t)nSubType;

@end
