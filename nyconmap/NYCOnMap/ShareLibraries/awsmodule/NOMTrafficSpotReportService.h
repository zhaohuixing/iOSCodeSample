//
//  NOMTrafficSpotReportService.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NOMTrafficSpotRecord.h"
#import "AmazonClientManager.h"
#import "NOMAWSServiceProtocols.h"

@interface NOMTrafficSpotReportService : NSObject//NSOperation<AmazonServiceRequestDelegate>

-(id)initWith:(NSString*)domain WithSpotData:(NOMTrafficSpotRecord*)data;
-(NOMTrafficSpotRecord*)GetSpotData;
-(void)RegisterDelegate:(id<INOMTrafficSpotReportDelegate>)delegate;

-(void)DeleteSpot;

-(void)StartPost;

@end
