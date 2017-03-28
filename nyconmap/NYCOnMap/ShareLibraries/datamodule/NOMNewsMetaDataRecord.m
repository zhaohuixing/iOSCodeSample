//
//  NOMNewsMetaDataRecord.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-05-31.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsMetaDataRecord.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"
#import "NOMTimeHelper.h"
#import "NOMGEOConfigration.h"
#import "IPlainTextLocationParser.h"
#import <MapKit/MapKit.h>
#import <AddressBook/ABPerson.h>
#import "NOMJSONDataBuilder.h"
#import "NOMAppInfo.h"
#import "NOMMapConstants.h"
#import "NOMDataEncryptionHelper.h"
#import "NOMAppWatchDataHelper.h"
#import "NOMAppWatchConstants.h"

@interface NOMNewsMetaDataRecord ()
{
    NSString*                   _m_NewsID;
    NSString*                   _m_NewsPosterEmail;
    NSString*                   _m_NewsPosterDisplayName;
    int64_t                     _m_nNewsTime;                  //Since 1970
    double                      _m_NewsLatitude;
    double                      _m_NewsLongitude;
    int16_t                     _m_NewsMainCategory;
    int16_t                     _m_NewsSubCategory;
    int16_t                     _m_NewsThirdCategory;           //For traffic
    NSString*                   _m_NewsResourceURL;
    NSString*                   _m_NewsLoactionKmlURL;
    NSString*                   _m_NewsImageURL;
    int16_t                     _m_DisplayStateByComplain;      // = 0: no reader complaint and display it; 0 <: reader complainit, don't display
    int16_t                     _m_DisplayForWearable;          // = 0: can not display on wearable device; 0 <: can display on wearable device
    NSString*                   _m_NewsDomainURL;
    
    
    NSString*                   _m_NewsTitleSource;
    NSString*                   _m_NewsBodySource;
    NSString*                   _m_NewsCopyRightSource;
    NSString*                   _m_NewsKeywordSource;
    NSString*                   _m_NewsKMLSource;
    
    BOOL                        _m_bTwitterTweet;
    NSString*                   _m_TweetText;
    NSString*                   _m_TwitterUserIconURL;
    NSString*                   _m_TwitterTweetLinkURL;
    
    BOOL                        _m_bRealTimeTrafficSearch;
    
@private
    id<NOMNewsMetaDataLocationUpdateDelegate>   m_LocationUpdateDelegate;
    
    NOMRTSSourceService*         m_TrafficRouteSource;
}

@end

@implementation NOMNewsMetaDataRecord

@synthesize m_NewsID = _m_NewsID;
@synthesize m_NewsPosterEmail = _m_NewsPosterEmail;
@synthesize m_NewsPosterDisplayName = _m_NewsPosterDisplayName;
@synthesize m_nNewsTime = _m_nNewsTime;                  //Since 1970
@synthesize m_NewsLatitude = _m_NewsLatitude;
@synthesize m_NewsLongitude = _m_NewsLongitude;
@synthesize m_NewsMainCategory = _m_NewsMainCategory;
@synthesize m_NewsSubCategory = _m_NewsSubCategory;
@synthesize m_NewsResourceURL = _m_NewsResourceURL;
@synthesize m_DisplayStateByComplain = _m_DisplayStateByComplain;
@synthesize m_DisplayForWearable = _m_DisplayForWearable;
@synthesize m_NewsThirdCategory = _m_NewsThirdCategory;
@synthesize m_NewsDomainURL = _m_NewsDomainURL;
@synthesize m_NewsLoactionKmlURL = _m_NewsLoactionKmlURL;

@synthesize m_NewsImageURL = _m_NewsImageURL;
@synthesize m_NewsTitleSource = _m_NewsTitleSource;
@synthesize m_NewsBodySource = _m_NewsBodySource;
@synthesize m_NewsCopyRightSource = _m_NewsCopyRightSource;
@synthesize m_NewsKeywordSource = _m_NewsKeywordSource;
@synthesize m_NewsKMLSource = _m_NewsKMLSource;

@synthesize m_bTwitterTweet = _m_bTwitterTweet;
@synthesize m_TweetText = _m_TweetText;

@synthesize m_TwitterUserIconURL = _m_TwitterUserIconURL;
@synthesize m_TwitterTweetLinkURL = _m_TwitterTweetLinkURL;

@synthesize m_bRealTimeTrafficSearch = _m_bRealTimeTrafficSearch;

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        _m_NewsID = nil;
        _m_NewsPosterEmail = nil;
        _m_NewsPosterDisplayName = nil;
        _m_nNewsTime = 0;                  //Since 1970
        _m_NewsLatitude = 0;
        _m_NewsLongitude = 0;
        _m_NewsMainCategory = -1;
        _m_NewsSubCategory = -1;
        _m_NewsResourceURL = nil;
        _m_DisplayStateByComplain = 0;
        _m_DisplayForWearable = 0;
        
        _m_NewsThirdCategory = 0;
        
        _m_NewsDomainURL = nil;
        _m_NewsLoactionKmlURL = nil;

        _m_NewsImageURL = nil;
        _m_NewsTitleSource = nil;
        _m_NewsBodySource = nil;
        _m_NewsCopyRightSource = nil;
        _m_NewsKeywordSource = nil;
        _m_NewsKMLSource = nil;
        
        _m_bTwitterTweet = NO;
        _m_TweetText = nil;
        _m_TwitterUserIconURL = nil;
        _m_TwitterTweetLinkURL = nil;
        
        m_LocationUpdateDelegate = nil;
        m_TrafficRouteSource = nil;
        
        _m_bRealTimeTrafficSearch = NO;
    }
    return self;
}


-(id)initWithID:(NSString*)newsID withTime:(int64_t)nTime withLatitude:(double)lat withLongitude:(double)lon withPEmail:(NSString*)pEmail withPDName:(NSString*)pDName withCategory:(int16_t)nCategory withSubCategory:(int16_t)nSubCategory withResourceURL:(NSString*)resURL withWearable:(int16_t)support
{
    self = [super init];
    if(self != nil)
    {
        _m_NewsID = newsID;
        _m_NewsPosterEmail = pEmail;
        _m_NewsResourceURL = resURL;
        _m_NewsPosterDisplayName = pDName;
        _m_nNewsTime = nTime;                  //Since 1970
        _m_NewsLatitude = lat;
        _m_NewsLongitude = lon;
        _m_NewsMainCategory = nCategory;
        _m_NewsSubCategory = nSubCategory;
        _m_DisplayStateByComplain = 0;
        _m_DisplayForWearable = support;
        
        _m_NewsThirdCategory = 0;
        _m_NewsDomainURL = nil;
        _m_NewsLoactionKmlURL = nil;
        
        _m_NewsImageURL = nil;
        _m_NewsTitleSource = nil;
        _m_NewsBodySource = nil;
        _m_NewsCopyRightSource = nil;
        _m_NewsKeywordSource = nil;
        _m_NewsKMLSource = nil;
        
        _m_bTwitterTweet = NO;
        _m_TweetText = nil;
        _m_TwitterUserIconURL = nil;
        _m_TwitterTweetLinkURL = nil;
        
        m_LocationUpdateDelegate = nil;
        m_TrafficRouteSource = nil;
        
        _m_bRealTimeTrafficSearch = NO;
    }
    return self;
}


-(id)initWithID:(NSString*)newsID withTime:(int64_t)nTime withLatitude:(double)lat withLongitude:(double)lon withPEmail:(NSString*)pEmail withPDName:(NSString*)pDName withCategory:(int16_t)nCategory withSubCategory:(int16_t)nSubCategory withThirdCategory:(int16_t)nThirdCategory withResourceURL:(NSString*)resURL withWearable:(int16_t)support
{
    self = [super init];
    if(self != nil)
    {
        _m_NewsID = newsID;
        _m_NewsPosterEmail = pEmail;
        _m_NewsResourceURL = resURL;
        _m_NewsPosterDisplayName = pDName;
        _m_nNewsTime = nTime;                  //Since 1970
        _m_NewsLatitude = lat;
        _m_NewsLongitude = lon;
        _m_NewsMainCategory = nCategory;
        _m_NewsSubCategory = nSubCategory;
        _m_DisplayStateByComplain = 0;
        _m_DisplayForWearable = support;
        
        _m_NewsThirdCategory = nThirdCategory;
        _m_NewsDomainURL = nil;
        _m_NewsLoactionKmlURL = nil;
        
        _m_NewsImageURL = nil;
        _m_NewsTitleSource = nil;
        _m_NewsBodySource = nil;
        _m_NewsCopyRightSource = nil;
        _m_NewsKeywordSource = nil;
        _m_NewsKMLSource = nil;
        
        _m_bTwitterTweet = NO;
        _m_TweetText = nil;
        _m_TwitterUserIconURL = nil;
        _m_TwitterTweetLinkURL = nil;
        
        m_LocationUpdateDelegate = nil;
        m_TrafficRouteSource = nil;
        
        _m_bRealTimeTrafficSearch = NO;
    }
    return self;
}

-(id)initTrafficWithID:(NSString*)newsID withTime:(int64_t)nTime withLatitude:(double)lat withLongitude:(double)lon withPEmail:(NSString*)pEmail withPDName:(NSString*)pDName withSubCategory:(int16_t)nSubCategory withThirdCategory:(int16_t)nThirdCategory withResourceURL:(NSString*)resURL
{
    self = [super init];
    if(self != nil)
    {
        _m_NewsID = newsID;
        
        if(pEmail != nil && 0 < [pEmail length])
            _m_NewsPosterEmail = pEmail;
        else
            _m_NewsPosterEmail = [StringFactory GetString_Anonymous];
        
        if(pDName != nil && 0 < [pDName length])
            _m_NewsPosterDisplayName = pDName;
        else
            _m_NewsPosterDisplayName = [StringFactory GetString_Anonymous];
        
        if(resURL != nil && 0 < [resURL length])
            _m_NewsResourceURL = resURL;
        else
            _m_NewsResourceURL = nil;

        _m_nNewsTime = nTime;                  //Since 1970
        _m_NewsLatitude = lat;
        _m_NewsLongitude = lon;
        _m_NewsMainCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC;
        _m_NewsSubCategory = nSubCategory;
        _m_DisplayStateByComplain = 0;
        _m_DisplayForWearable = 1;
       
        _m_NewsThirdCategory = nThirdCategory;
        _m_NewsDomainURL = nil;
        _m_NewsLoactionKmlURL = nil;
     
        _m_NewsImageURL = nil;
        _m_NewsTitleSource = nil;
        _m_NewsBodySource = nil;
        _m_NewsCopyRightSource = nil;
        _m_NewsKeywordSource = nil;
        _m_NewsKMLSource = nil;
        
        _m_bTwitterTweet = NO;
        _m_TweetText = nil;
        _m_TwitterUserIconURL = nil;
        _m_TwitterTweetLinkURL = nil;
        
        m_LocationUpdateDelegate = nil;
        m_TrafficRouteSource = nil;
        
        _m_bRealTimeTrafficSearch = NO;
    }
    return self;
}

-(id)initTrafficDataWithID:(NSString*)newsID withTime:(int64_t)nTime withLatitude:(double)lat withLongitude:(double)lon withPEmail:(NSString*)pEmail withPDName:(NSString*)pDName withCategory:(int16_t)nCategory withSubCategory:(int16_t)nSubCategory withThirdCategory:(int16_t)nType withResourceURL:(NSString*)resURL withWearable:(int16_t)support
{
    self = [super init];
    if(self != nil)
    {
        _m_NewsID = newsID;
        
        if(pEmail != nil && 0 < [pEmail length])
            _m_NewsPosterEmail = pEmail;
        else
            _m_NewsPosterEmail = [StringFactory GetString_Anonymous];
        
        if(pDName != nil && 0 < [pDName length])
            _m_NewsPosterDisplayName = pDName;
        else
            _m_NewsPosterDisplayName = [StringFactory GetString_Anonymous];
        
        if(resURL != nil && 0 < [resURL length])
            _m_NewsResourceURL = resURL;
        else
            _m_NewsResourceURL = nil;

        _m_nNewsTime = nTime;                  //Since 1970
        _m_NewsLatitude = lat;
        _m_NewsLongitude = lon;
        _m_NewsMainCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC;
        _m_NewsSubCategory = nSubCategory;
        _m_DisplayStateByComplain = 0;
        _m_DisplayForWearable = support;
        
        _m_NewsThirdCategory = nType;
        _m_NewsDomainURL = nil;
        _m_NewsLoactionKmlURL = nil;
     
        _m_NewsImageURL = nil;
        _m_NewsTitleSource = nil;
        _m_NewsBodySource = nil;
        _m_NewsCopyRightSource = nil;
        _m_NewsKeywordSource = nil;
        _m_NewsKMLSource = nil;
        
        _m_bTwitterTweet = NO;
        _m_TweetText = nil;
        _m_TwitterUserIconURL = nil;
        _m_TwitterTweetLinkURL = nil;
        
        m_LocationUpdateDelegate = nil;
        m_TrafficRouteSource = nil;
        
        _m_bRealTimeTrafficSearch = NO;
    }
    return self;
}

-(void)SetDBDomainURL:(NSString*)szDomain
{
    _m_NewsDomainURL = szDomain;
}

-(void)SetNewsLocationURL:(NSString*)szLocationKmlURL
{
    _m_NewsLoactionKmlURL = szLocationKmlURL;
}

-(void)SetComplainState:(int)nState
{
    _m_DisplayStateByComplain = nState;
}


-(NOMNewsMetaDataRecord*)Clone
{
    NOMNewsMetaDataRecord* pClone = nil;
    
   pClone = [[NOMNewsMetaDataRecord alloc] initWithID: _m_NewsID withTime:_m_nNewsTime withLatitude:_m_NewsLatitude withLongitude:_m_NewsLongitude withPEmail:_m_NewsPosterEmail withPDName:_m_NewsPosterDisplayName withCategory:_m_NewsMainCategory withSubCategory:_m_NewsSubCategory withThirdCategory:_m_NewsThirdCategory withResourceURL:_m_NewsResourceURL withWearable:_m_DisplayForWearable];
    if(_m_NewsDomainURL != nil)
    {
        pClone.m_NewsDomainURL = [_m_NewsDomainURL copy];
    }
    if(_m_NewsLoactionKmlURL != nil)
    {
        pClone.m_NewsLoactionKmlURL = [_m_NewsLoactionKmlURL copy];
    }
    
    
    return pClone;
}

-(void)RegisterLocationUpdateDelegate:(id<NOMNewsMetaDataLocationUpdateDelegate>)delegate
{
    m_LocationUpdateDelegate = delegate;
}

-(void)HandleLocationChanged
{
    if(m_LocationUpdateDelegate != nil)
    {
        [m_LocationUpdateDelegate LocationUpdated:self];
    }
}

-(void)LoadDetailDataFromTrafficRouteSource
{
    if(m_TrafficRouteSource == nil)
        return;
    
    _m_bRealTimeTrafficSearch = YES;
    _m_NewsID = [m_TrafficRouteSource GetID];
    _m_NewsPosterEmail = NOM_CUSTOMER_EMAIL;
    _m_NewsPosterDisplayName = [NOMAppInfo GetAppDisplayName];
    //if([m_TrafficRouteSource GetTrafficDetail] != nil)
    //    _m_TweetText = [m_TrafficRouteSource GetTrafficDetail];

    _m_nNewsTime = [NOMTimeHelper ConvertNSDateToInteger:[NSDate date]];
    _m_NewsLatitude = [m_TrafficRouteSource GetBaseLatitude];
    _m_NewsLongitude = [m_TrafficRouteSource GetBaseLongitude];
    _m_NewsMainCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC;
    _m_NewsSubCategory = NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION;
    _m_NewsThirdCategory = [m_TrafficRouteSource GetTrafficType];           //For traffic
    
    _m_NewsTitleSource = [m_TrafficRouteSource GetTrafficDetail];
    _m_NewsBodySource = [m_TrafficRouteSource GetTrafficIssueContent];
    _m_NewsKMLSource = [m_TrafficRouteSource GetRouteKML:MAP_PLAN_ROUTE_DEFAULT_WIDTH lineColor:MAP_PLAN_LINE_COLOR];
}

-(void)SetTrafficRouteSource:(NOMRTSSourceService*)pRoute
{
    m_TrafficRouteSource = pRoute;
    [self LoadDetailDataFromTrafficRouteSource];
}

-(BOOL)FromTrafficRouteSource
{
    BOOL bRet = NO;
    
    if(m_TrafficRouteSource != nil)
        bRet = YES;
    
    return bRet;
}

-(NSString*)GetTrafficRouteIssueDetail
{
    NSString* szRet = @"";
    
    if(m_TrafficRouteSource != nil)
        szRet = [m_TrafficRouteSource GetTrafficIssueContent];
    
    return szRet;
}

-(NSString*)GetTrafficRouteIssueTitle;
{
    NSString* szRet = @"";
    
    if(m_TrafficRouteSource != nil)
        szRet = [m_TrafficRouteSource GetTrafficDetail];
    
    return szRet;
}

-(NSString*)GetTrafficRouteIssueCause
{
    NSString* szRet = @"";
    
    if(m_TrafficRouteSource != nil)
        szRet = [m_TrafficRouteSource GetTrafficCause];
    
    return szRet;
}

-(void)StartTrafficRouteDetailLoading
{
    if(m_TrafficRouteSource != nil)
        [m_TrafficRouteSource Finish];
}

-(NOMRTSSourceService*)GetTrafficRouteSource
{
    return m_TrafficRouteSource;
}

-(void)StartTweetLocationDecode
{
    //??????????????
    //??????????????
    //??????????????
    //??????????????
    //??????????????
    return;
    //??????????????
    //??????????????
    //??????????????
    //??????????????
    //??????????????
    //??????????????
    
    
    if(_m_bTwitterTweet == NO || _m_TweetText == nil || _m_TweetText.length <= 0)
    {
        if(m_LocationUpdateDelegate != nil)
            [m_LocationUpdateDelegate LocationDecodeDone:self withResult:NO];
            
        return;
    }
    
    id<IPlainTextLocationParser> streetParser = [NOMAppInfo CreatePlainTextLocationParser];
    [streetParser ParseLocationFromText:_m_TweetText];
    NSArray* streetList = [streetParser GetLocationList];
    
    if(streetList != nil && 0 < streetList.count)
    {
        NSString* streetAddress;
        if(streetList.count == 1)
        {
            streetAddress = [NSString stringWithFormat:@"%@", [streetList objectAtIndex:0]];
        }
        else
        {
            streetAddress = [NSString stringWithFormat:@"%@ and %@", [streetList objectAtIndex:0], [streetList objectAtIndex:1]];
        }
        
        NSDictionary *locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            //[NOMGEOConfigration GetCurrentCity], kABPersonAddressCityKey,
                                            [NOMGEOConfigration GetCurrentState], kABPersonAddressStateKey,
                                            [NOMGEOConfigration GetCurrentCounty], kABPersonAddressCountryKey,
                                            [NOMGEOConfigration GetCurrentCountryCode], kABPersonAddressCountryCodeKey,
                                            streetAddress, kABPersonAddressStreetKey,
                                            nil];
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder geocodeAddressDictionary:locationDictionary completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if(placemarks != nil && 0 < [placemarks count] && error == nil)
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 CLLocation *location = placemark.location;
                 _m_NewsLongitude = location.coordinate.longitude;
                 _m_NewsLatitude = location.coordinate.latitude;
                 if(m_LocationUpdateDelegate != nil)
                 {
                     [m_LocationUpdateDelegate LocationDecodeDone:self withResult:YES];
                 }
#ifdef DEBUG
                 NSLog(@"Parse location data succeed inside tweet. Lat:%f, Long:%f, Name:%@\n", self.m_NewsLatitude, self.m_NewsLongitude, placemark.name);
#endif
             }
#ifdef DEBUG
             else
             {
                 NSLog(@"Parse location data failed inside tweet.\n");
                 if(m_LocationUpdateDelegate != nil)
                 {
                     [m_LocationUpdateDelegate LocationDecodeDone:self withResult:NO];
                 }
             }
#endif
         }];
    }
    else
    {
        if(m_LocationUpdateDelegate != nil)
        {
            [m_LocationUpdateDelegate LocationDecodeDone:self withResult:YES];
        }
    }
 
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
// Data encoding/decoding
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString*)FormatInternalDataToRawJSONString
{
    NSString* szJSON = nil;
    
    NOMJSONDataBuilder* jsonBuilder = [[NOMJSONDataBuilder alloc] init];
    NSNumber* newLantitude = [[NSNumber alloc] initWithDouble:_m_NewsLatitude];
    NSNumber* newLongitude = [[NSNumber alloc] initWithDouble:_m_NewsLongitude];
    NSNumber* newTime = [[NSNumber alloc] initWithLongLong:(long long)_m_nNewsTime];
    NSNumber* newCategory = [[NSNumber alloc] initWithInt:_m_NewsMainCategory];
    NSNumber* newSubCategory = [[NSNumber alloc] initWithInt:_m_NewsSubCategory];
    NSNumber* new3rdCategory = [[NSNumber alloc] initWithInt:_m_NewsThirdCategory];
    NSNumber* newCompalinState = [[NSNumber alloc] initWithInt:_m_DisplayStateByComplain];
    NSNumber* newWearableState = [[NSNumber alloc] initWithInt:_m_DisplayForWearable];
    
   
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWID withObject:_m_NewsID];
    
    if(_m_NewsPosterEmail && 0 < _m_NewsPosterEmail.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_PUBLISHEREMAIL withObject:_m_NewsPosterEmail];
    if(_m_NewsPosterDisplayName && 0 < _m_NewsPosterDisplayName.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_PUBLISHERDISPLAYNAME withObject:_m_NewsPosterDisplayName];
    
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSLATITUDE withObject:newLantitude];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSLONGITUDE withObject:newLongitude];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSTIME withObject:newTime];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSCATEGORY withObject:newCategory];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSSUBCATEGORY withObject:newSubCategory];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSTHIRDCATEGORY withObject:new3rdCategory];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_COMPLAINFLAG withObject:newCompalinState];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_WEARABLEFLAG withObject:newWearableState];

    if(_m_NewsResourceURL && 0 < _m_NewsResourceURL.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSFILEURL withObject:_m_NewsResourceURL];
    if(_m_NewsLoactionKmlURL && 0 < _m_NewsLoactionKmlURL.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSKMLURL withObject:_m_NewsLoactionKmlURL];
    if(_m_NewsDomainURL && 0 < _m_NewsDomainURL.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSDOMAINURL withObject:_m_NewsDomainURL];
    
    if(_m_NewsTitleSource != nil && 0 < _m_NewsTitleSource.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSTITLE withObject:_m_NewsTitleSource];
    if(_m_NewsBodySource != nil && 0 < _m_NewsBodySource.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSBODY withObject:_m_NewsBodySource];
    
    if(_m_NewsKeywordSource != nil && 0 < _m_NewsKeywordSource.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSKEYWORDS withObject:_m_NewsKeywordSource];
    
    if(_m_NewsCopyRightSource != nil && 0 < _m_NewsCopyRightSource.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSCOPYRIGHT withObject:_m_NewsCopyRightSource];
    
    if(_m_NewsKMLSource != nil && 0 < _m_NewsKMLSource.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSKMLSOURCE withObject:_m_NewsKMLSource];
    
    if(_m_NewsImageURL != nil && 0 < _m_NewsImageURL.length)
    {
        NSString* sImageKey = [NSString stringWithFormat:@"%@%i", NOM_NEWSJSON_TAG_NEWSIMAGEKEYPREFIX, 0];
        [jsonBuilder Add:sImageKey withObject:_m_NewsImageURL];
    }
    
    
    szJSON = [jsonBuilder GetJSONString];
    
    return szJSON;
    
}

-(NSString*)FormatToJSONString
{
    NSString* rawJSONstring = [self FormatInternalDataToRawJSONString];
    
    NSString* szLabel;
    
    if(_m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        szLabel = [StringFactory GetString_TrafficTypeTitle:_m_NewsSubCategory withType:_m_NewsThirdCategory];
    }
    else
    {
        szLabel = [StringFactory GetString_NewsTitle:_m_NewsMainCategory subCategory:_m_NewsSubCategory];
    }
    
    NSString* szContent = [NSString stringWithFormat:@"%@ %@ %@", [NOMAppInfo GetAppDisplayName], [StringFactory GetString_Post], szLabel];
    
    NSString* encodedData = [NOMDataEncryptionHelper EncodingData:rawJSONstring];
    
    NSString* szRet = [NSString stringWithFormat:@"%@%@", szContent, encodedData];
    
    return szRet;
}


-(BOOL)LoadFromJSONData:(NSDictionary*)jsonData
{
    BOOL bRet = YES;
    
    if(jsonData == nil || jsonData.count <= 0)
        return NO;
    
    //[jsonBuilder Add:NOM_NEWSJSON_TAG_NEWID withObject:_m_NewsID];
    _m_NewsID = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWID];
    if(_m_NewsID == nil || _m_NewsID.length <= 0)
        return NO;

    //?????????????
    //????????????
    NSNumber* newLantitude = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSLATITUDE];
    if(newLantitude == nil)
        return NO;
    _m_NewsLatitude = [newLantitude doubleValue];

    NSNumber* newLongitude = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSLONGITUDE];
    if(newLongitude == nil)
        return NO;
    _m_NewsLongitude = [newLongitude doubleValue];

    NSNumber* newsTime = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSTIME];
    if(newsTime == nil)
        return NO;
    _m_nNewsTime = (int64_t)[newsTime longLongValue];
    
    
    NSNumber* newCategory = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSCATEGORY];
    if(newCategory == nil)
        return NO;
    _m_NewsMainCategory = (int16_t)[newCategory intValue];

    NSNumber* newSubCategory = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSSUBCATEGORY];
    if(newSubCategory == nil)
        return NO;
    _m_NewsSubCategory = (int16_t)[newSubCategory intValue];
    
    
    NSNumber* new3rdCategory = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSTHIRDCATEGORY];
    if(new3rdCategory != nil)
    {
        _m_NewsThirdCategory = (int16_t)[new3rdCategory intValue];
    }

    NSNumber* newCompalinState = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSTHIRDCATEGORY];
    if(newCompalinState != nil)
    {
        _m_DisplayStateByComplain = (int16_t)[newCompalinState intValue];
    }
    
    NSNumber* newWearableState = [jsonData objectForKey:NOM_NEWSJSON_TAG_WEARABLEFLAG];
    if(newWearableState != nil)
    {
        _m_DisplayForWearable = (int16_t)[newWearableState intValue];
    }
    
    _m_NewsPosterEmail = [jsonData objectForKey:NOM_NEWSJSON_TAG_PUBLISHEREMAIL];
    _m_NewsPosterDisplayName = [jsonData objectForKey:NOM_NEWSJSON_TAG_PUBLISHERDISPLAYNAME];
  
    
    _m_NewsResourceURL = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSFILEURL];
    _m_NewsLoactionKmlURL = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSKMLURL];
    _m_NewsDomainURL = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSDOMAINURL];
    
    _m_NewsTitleSource = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSTITLE];
    _m_NewsBodySource = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSBODY];
    
    _m_NewsKeywordSource = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSKEYWORDS];
    
    _m_NewsCopyRightSource = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSCOPYRIGHT];
    
    _m_NewsKMLSource = [jsonData objectForKey:NOM_NEWSJSON_TAG_NEWSKMLSOURCE];
    
    NSString* sImageKey = [NSString stringWithFormat:@"%@%i", NOM_NEWSJSON_TAG_NEWSIMAGEKEYPREFIX, 0];
    _m_NewsImageURL= [jsonData objectForKey:sImageKey];
    
    return bRet;
}

-(NOMWatchMapAnnotation*)CreateWatchAnnotation
{
    NOMWatchMapAnnotation* pAnnotation = [[NOMWatchMapAnnotation alloc] init];
    
    pAnnotation.m_AnnotationID = _m_NewsID;
    pAnnotation.m_Latitude = _m_NewsLatitude;
    pAnnotation.m_Longitude = _m_NewsLongitude;
    pAnnotation.m_AnnotationType = [NOMAppWatchDataHelper GetWatchAnnotationTypeFromMetaData:_m_NewsMainCategory subCate:_m_NewsSubCategory thirdCate:_m_NewsThirdCategory];
    
    return pAnnotation;
}

-(NSDictionary*)CreateWatchAnnotationKeyValueBlock
{
    int16_t nType = [NOMAppWatchDataHelper GetWatchAnnotationTypeFromMetaData:_m_NewsMainCategory subCate:_m_NewsSubCategory thirdCate:_m_NewsThirdCategory];
    
    NSString* pID = [NSString stringWithFormat:@"%@", _m_NewsID];
    NSNumber* pType = [[NSNumber alloc] initWithInt:nType];
    NSNumber* pLatitude = [[NSNumber alloc] initWithDouble:_m_NewsLatitude];
    NSNumber* pLongitude = [[NSNumber alloc] initWithDouble:_m_NewsLongitude];
    
    NSDictionary *messageData =   [NSDictionary dictionaryWithObjectsAndKeys:
                                   pID, EMSG_KEY_ANNOTATIONID,
                                   pType, EMSG_KEY_ANNOTATIONTYPE,
                                   pLatitude, EMSG_KEY_LOCATIONLATITUDE,
                                   pLongitude, EMSG_KEY_LOCATIONLONGITUDE,
                                   nil];
    
    return messageData;
}

@end
