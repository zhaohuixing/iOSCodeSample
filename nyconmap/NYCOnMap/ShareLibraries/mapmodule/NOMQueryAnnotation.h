//
//  NOMQueryAnnotation.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMAnnotationBase.h"
#import "NOMNewsMetaDataRecord.h"


#define NOM_QUERYPIN_TYPE_MIXED         0
#define NOM_QUERYPIN_TYPE_PUBLIC        1
#define NOM_QUERYPIN_TYPE_COMMUNIT      2
#define NOM_QUERYPIN_TYPE_TRAFFIC       3
#define NOM_QUERYPIN_TYPE_TAXI          4

#define NOM_QUERYPIN_SUBTYPE_INVALID                               -1

#define NOM_QUERYPIN_SUBTYPE_PUBLIC_MIX                            0
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_PUBLICISSUE                    1
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_POLITICS                       2
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_BUSINESS                       3
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_MONEY                          4
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_HEALTH                         5
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_SPORTS                         6
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_ARTANDENTERTAINMENT            7
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_EDUCATION                      8
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_TECHNOLOGYANDSCIENCE           9
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_FOODANDDRINK                   10
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_TRAVELANDTOURISM               11
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_LIFESTYLE                      12
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_REALESTATE                     13
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_AUTO                           14
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_CRIMEANDDISASTER               15
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_WEATHER                        16
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_CHARITY                        17
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_CULTURE                        18
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_RELIGION                       19
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_PET                            20
#define NOM_QUERYPIN_SUBTYPE_PUBLIC_MISC                           21


#define NOM_QUERYPIN_SUBTYPE_COMMUNITY_MIX                          0
#define NOM_QUERYPIN_SUBTYPE_COMMUNITY_EVENT                        1
#define NOM_QUERYPIN_SUBTYPE_COMMUNITY_YARDSALE                     2
#define NOM_QUERYPIN_SUBTYPE_COMMUNITY_WIKI                         3


#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_MIX                            0
//#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_DELAY                          1
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_BUS_DELAY                      1
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_TRAIN_DELAY                    2
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_FLIGHT_DELAY                   3
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_PASSENGERSTUCK                 4

#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_JAM                            5
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_CRASH                          6
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_POLICE                         7
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_CONSTRUCTION                   8
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_ROADCLOSURE                    9
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_BROKENTRAFFICLIGHT             10
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_STALLEDCAR                     11
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_FOG                            12
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_DANGEROUSCONDITION             13
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_RAIN                           14
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_ICE                            15
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_WIND                           16
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_LANECLOSURE                    17
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_SLIPROADCLOSURE                18
#define NOM_QUERYPIN_SUBTYPE_TRAFFIC_DETOUR                         19

#define NOM_QUERYPIN_SUBTYPE_TAXI_DRIVER                            0
#define NOM_QUERYPIN_SUBTYPE_TAXI_PASSENGER                         1


@class NOMQueryLocationPin;

@interface NOMQueryAnnotation : NOMAnnotationBase<NOMNewsMetaDataLocationUpdateDelegate>
{
@private
    NSMutableArray*         _m_NOMMetaDataList;
    int                     _m_Index;
    BOOL                    _m_bActive;
    NOMQueryLocationPin*    _m_ActiveView;
}

@property (nonatomic)NSMutableArray* m_NOMMetaDataList;
@property (nonatomic)NOMQueryLocationPin*    m_ActiveView;


-(void)Reset;
-(int)CheckPinType;

-(int)GetNewsSubType;
-(int)GetCommunitySubType;
-(int)GetTrafficSubType;
-(int)GetTaxiSubType;
-(BOOL)IsDrivingConditionType;

-(int)GetSubType:(int)nPinType;
-(void)AddData:(NOMNewsMetaDataRecord*)data;
-(void)SetIndex:(int)index;
-(int)GetIndex;
-(void)SetActive:(BOOL)bActive;
-(BOOL)IsActive;
-(int)GetNewsDataIndex:(NSString*)szNewsID;
-(NOMNewsMetaDataRecord*)GetNewsData:(NSString*)szNewsID;
-(int)NewsDataCount;
-(void)RemoveData:(int)index;

-(BOOL)IsTwitterTweet;
-(NSString*)GetTwitterAutherDisplayName;
-(int16_t)GetMainDataCateType;

-(void)ShowAlert;

@end
