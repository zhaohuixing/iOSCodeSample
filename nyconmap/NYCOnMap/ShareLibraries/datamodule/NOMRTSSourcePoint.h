//
//  NOMRTSSourcePoint.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-12-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMRTSSourcePoint : NSObject

@property (nonatomic, readonly)CLLocation*  m_Location;
@property (nonatomic, readonly)NSString*    m_NameRawSource;

-(id)init;
-(id)initWith:(double)dLat longitude:(double)dLong;
-(id)initWith:(double)dLat longitude:(double)dLong source:(NSString*)pRawSource;

-(void)SetData:(double)dLat longitude:(double)dLong;
-(void)SetData:(double)dLat longitude:(double)dLong source:(NSString*)pRawSource;

-(double)GetLatitude;
-(double)GetLongitude;

@end
