//
//  NOMGEORouteQuery.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-05.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NOMGEORouteQuery : NSOperation

-(id)initQuery:(CLLocationCoordinate2D)startPoint end:(CLLocationCoordinate2D)endPoint;

-(MKRoute*)GetResult;
-(void)SetQueryID:(int)qID;
-(int)GetQueryID;
-(BOOL)IsSuccess;

@end
