//
//  NOMTrafficSpotRecord.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMWatchMapAnnotation.h"

@interface NOMTrafficSpotRecord : NSObject

@property (nonatomic)NSString*                      m_SpotID;
@property (nonatomic)NSString*                      m_SpotName;
@property (nonatomic)NSString*                      m_SpotAddress;
@property (nonatomic)double                         m_SpotLatitude;
@property (nonatomic)double                         m_SpotLongitude;
@property (nonatomic)int16_t                        m_Type;
@property (nonatomic)int16_t                        m_SubType;
@property (nonatomic)int16_t                        m_ThirdType;
@property (nonatomic)int16_t                        m_FourType;
@property (nonatomic)double                         m_Price;
@property (nonatomic)int64_t                        m_PriceTime;
@property (nonatomic)int16_t                        m_PriceUnit;


-(id)initWithID:(NSString*)spotID withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType;

-(id)initWithID:(NSString*)spotID withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withPrice:(double)dPrice withTime:(int64_t)nTime withUnit:(int16_t)nUnit;

-(id)initWithID:(NSString*)spotID withName:(NSString*)spotName withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType;
-(id)initWithID:(NSString*)spotID withName:(NSString*)spotName withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withPrice:(double)dPrice withTime:(int64_t)nTime withUnit:(int16_t)nUnit;

-(id)initWithID:(NSString*)spotID withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withSubType:(int16_t)nSubType;
-(id)initWithID:(NSString*)spotID withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withSubType:(int16_t)nSubType withPrice:(double)dPrice;

-(id)initWithID:(NSString*)spotID withAddress:(NSString*)address withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withSubType:(int16_t)nSubType;
-(id)initWithID:(NSString*)spotID withAddress:(NSString*)address withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withSubType:(int16_t)nSubType withPrice:(double)dPrice;

-(id)initWithID:(NSString*)spotID withName:(NSString*)spotName withAddress:(NSString*)address withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType;
-(id)initWithID:(NSString*)spotID withName:(NSString*)spotName withAddress:(NSString*)address withLatitude:(double)lat withLongitude:(double)lon withType:(int16_t)nType withPrice:(double)dPrice withTime:(int64_t)nTime withUnit:(int16_t)nUnit;

-(NOMWatchMapAnnotation*)CreateWatchAnnotation;
-(NSDictionary*)CreateWatchAnnotationKeyValueBlock;


@end
