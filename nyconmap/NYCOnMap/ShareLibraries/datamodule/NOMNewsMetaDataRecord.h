//
//  NOMNewsMetaDataRecord.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-05-31.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMRTSSourceService.h"
#import "NOMWatchMapAnnotation.h"

@class NOMNewsMetaDataRecord;

@protocol NOMNewsMetaDataLocationUpdateDelegate <NSObject>

@optional
-(void)LocationUpdated:(NOMNewsMetaDataRecord*)pMetaData;
-(void)LocationDecodeDone:(NOMNewsMetaDataRecord*)pMetaData withResult:(BOOL)bResultOK;

@end

@interface NOMNewsMetaDataRecord : NSObject

@property (nonatomic)NSString*                      m_NewsID;
@property (nonatomic)NSString*                      m_NewsPosterEmail;
@property (nonatomic)NSString*                      m_NewsPosterDisplayName;
@property (nonatomic)int64_t                        m_nNewsTime;                  //Since 1970
@property (nonatomic)double                         m_NewsLatitude;
@property (nonatomic)double                         m_NewsLongitude;
@property (nonatomic)int16_t                        m_NewsMainCategory;
@property (nonatomic)int16_t                        m_NewsSubCategory;
@property (nonatomic)int16_t                        m_NewsThirdCategory;
@property (nonatomic)NSString*                      m_NewsResourceURL;
@property (nonatomic)NSString*                      m_NewsLoactionKmlURL;

@property (nonatomic)NSString*                      m_NewsImageURL;

@property (nonatomic)int16_t                        m_DisplayStateByComplain;
@property (nonatomic)int16_t                        m_DisplayForWearable;
@property (nonatomic)NSString*                      m_NewsDomainURL;


@property (nonatomic)NSString*                      m_NewsTitleSource;
@property (nonatomic)NSString*                      m_NewsBodySource;
@property (nonatomic)NSString*                      m_NewsCopyRightSource;
@property (nonatomic)NSString*                      m_NewsKeywordSource;
@property (nonatomic)NSString*                      m_NewsKMLSource;


@property (nonatomic)BOOL                           m_bTwitterTweet;
@property (nonatomic)NSString*                      m_TweetText;
@property (nonatomic)NSString*                      m_TwitterUserIconURL;
@property (nonatomic)NSString*                      m_TwitterTweetLinkURL;

@property (nonatomic)BOOL                           m_bRealTimeTrafficSearch;


-(id)initWithID:(NSString*)newsID withTime:(int64_t)nTime withLatitude:(double)lat withLongitude:(double)lon withPEmail:(NSString*)pEmail withPDName:(NSString*)pDName withCategory:(int16_t)nCategory withSubCategory:(int16_t)nSubCategory withResourceURL:(NSString*)resURL withWearable:(int16_t)support;

-(id)initWithID:(NSString*)newsID withTime:(int64_t)nTime withLatitude:(double)lat withLongitude:(double)lon withPEmail:(NSString*)pEmail withPDName:(NSString*)pDName withCategory:(int16_t)nCategory withSubCategory:(int16_t)nSubCategory withThirdCategory:(int16_t)nThirdCategory withResourceURL:(NSString*)resURL withWearable:(int16_t)support;

-(id)initTrafficWithID:(NSString*)newsID withTime:(int64_t)nTime withLatitude:(double)lat withLongitude:(double)lon withPEmail:(NSString*)pEmail withPDName:(NSString*)pDName withSubCategory:(int16_t)nSubCategory withThirdCategory:(int16_t)nThirdCategory withResourceURL:(NSString*)resURL;

-(id)initTrafficDataWithID:(NSString*)newsID withTime:(int64_t)nTime withLatitude:(double)lat withLongitude:(double)lon withPEmail:(NSString*)pEmail withPDName:(NSString*)pDName withCategory:(int16_t)nCategory withSubCategory:(int16_t)nSubCategory withThirdCategory:(int16_t)nType withResourceURL:(NSString*)resURL withWearable:(int16_t)support;

-(void)SetDBDomainURL:(NSString*)szDomain;
-(void)SetNewsLocationURL:(NSString*)szLocationKmlURL;
-(void)SetComplainState:(int)nState;

-(NOMNewsMetaDataRecord*)Clone;

-(void)RegisterLocationUpdateDelegate:(id<NOMNewsMetaDataLocationUpdateDelegate>)delegate;

-(void)HandleLocationChanged;

-(void)SetTrafficRouteSource:(NOMRTSSourceService*)pRoute;

-(BOOL)FromTrafficRouteSource;
-(NSString*)GetTrafficRouteIssueDetail;
-(NSString*)GetTrafficRouteIssueTitle;
-(NSString*)GetTrafficRouteIssueCause;
-(void)StartTrafficRouteDetailLoading;

-(NOMRTSSourceService*)GetTrafficRouteSource;

-(void)StartTweetLocationDecode;

-(NSString*)FormatToJSONString;
-(BOOL)LoadFromJSONData:(NSDictionary*)jsonData;

-(NOMWatchMapAnnotation*)CreateWatchAnnotation;
-(NSDictionary*)CreateWatchAnnotationKeyValueBlock;


@end
