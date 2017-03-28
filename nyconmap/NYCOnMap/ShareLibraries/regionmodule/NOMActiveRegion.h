//
//  NOMActiveRegion.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-01.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMActiveRegion : NSObject
{
@private
    NSString*           _m_CentralCity;
    NSString*           _m_CentralCityKEY;
    NSString*           _m_CentralStateOrProvince;
    NSString*           _m_CentralStateOrProvinceKey;
    NSString*           _m_CentralCountry;
    NSString*           _m_CentralCountryKey;
    
    NSString*           _m_NewsTopicName;
    NSString*           _m_TrafficTopicName;
    NSString*           _m_TaxiTopicName;
    
    NSString*           _m_NewsMessagePrefix;
    NSString*           _m_TrafficMessagePrefix;
    NSString*           _m_TaxiMessagePrefix;
    
    double              _m_AppLatitude;
    double              _m_AppLongitude;
    
    double              _m_AppLongitudeStart;
    double              _m_AppLongitudeEnd;
    double              _m_AppLatitudeStart;
    double              _m_AppLatitudeEnd;
    
    NSMutableArray*     _m_NewsQueryTwitterAcountList;
    NSMutableArray*     _m_TafficQueryTwitterAcountList;
}

@property (nonatomic, readonly)NSString*           m_CentralCity;
@property (nonatomic, readonly)NSString*           m_CentralCityKEY;
@property (nonatomic, readonly)NSString*           m_CentralStateOrProvince;
@property (nonatomic, readonly)NSString*           m_CentralStateOrProvinceKey;
@property (nonatomic, readonly)NSString*           m_CentralCountry;
@property (nonatomic, readonly)NSString*           m_CentralCountryKey;

@property (nonatomic, readonly)NSString*           m_NewsTopicName;
@property (nonatomic, readonly)NSString*           m_TrafficTopicName;
@property (nonatomic, readonly)NSString*           m_TaxiTopicName;

//@property (nonatomic, readonly)NSString*           m_NewsMessagePrefix;
//@property (nonatomic, readonly)NSString*           m_TrafficMessagePrefix;
//@property (nonatomic, readonly)NSString*           m_TaxiMessagePrefix;

@property (nonatomic, readonly)double              m_AppLatitude;
@property (nonatomic, readonly)double              m_AppLongitude;

@property (nonatomic, readonly)double              m_AppLongitudeStart;
@property (nonatomic, readonly)double              m_AppLongitudeEnd;
@property (nonatomic, readonly)double              m_AppLatitudeStart;
@property (nonatomic, readonly)double              m_AppLatitudeEnd;

@property (nonatomic, readonly)NSMutableArray*     m_NewsQueryTwitterAcountList;
@property (nonatomic, readonly)NSMutableArray*     m_TafficQueryTwitterAcountList;


-(BOOL)InRegion:(double)dLatitude longitude:(double)dLongitude;
-(BOOL)IntersectRectangle:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong;

-(BOOL)IsDefaultRegion;

-(void)CreateDefaultRegion;

//
//Canada cities
//
-(void)CreateCalgaryRegion;
-(void)CreateEdmontonRegion;

//
//US cities
//
-(void)CreateNewYorkRegion;
-(void)CreateWashingtonDCRegion;
-(void)CreateChicagoRegion;
-(void)CreateTampaRegion;

@end
