//
//  NOMDocumentController.m
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-23.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMDocumentController.h"
#import "NOMMapObjectController.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#import "NOMAppConstants.h"
#import "NOMSystemConstants.h"
#import "NOMAppInfo.h"
#import "NOMAppRegionHelper.h"
#import "NOMSpotPhotoRadarView.h"
#import "NOMSpotGasStationView.h"
#import "NOMSpotParkingGroundView.h"
#import "NOMSpotSchoolZoneView.h"
#import "StringFactory.h"
#import "NOMSpotViewController.h"
#import "NOMPostViewController.h"
#import "NOMTimeHelper.h"
#import "AmazonClientManager.h"
#import "NOMReadViewController.h"
#import "NOMSocialAccountManager.h"
#import "INOMSocialServiceInterface.h"
#import "NOMTimingService.h"
#import "NOMGEOConfigration.h"
#import "NOMNewsServiceHelper.h"
#import "NOMDataEncryptionHelper.h"
#import "NOMPreference.h"
#import "NOMAppWatchConstants.h"
#import "NOMAppWatchDataHelper.h"

typedef struct
{
	int16_t     m_UserMode;
	int16_t     m_NewsCategory;
    int16_t     m_NewsSubCategory;
    int16_t     m_NewsThirdCategory;
    int16_t     m_MarkSpotType;
    int16_t     m_MarkSpotDS;
    double      m_CachedLongitude;
    double      m_CachedLatitude;
} NOMUserStatus;


@interface NOMDocumentController()
{
@private
    NOMMapObjectController*         m_MapObjectController;
    id<IMainViewDelegate>           m_MainViewObject;
    NOMSpotViewController*          m_SpotViewController;
    NOMPostViewController*          m_PostViewController;
    NOMReadViewController*          m_ReadViewController;
    
    NOMUserStatus                   m_UserStatus;
    
    NOMPublishController*           m_PublishController;
    NOMBrowseController*            m_BrowseController;
    NOMPostLocationSelector*        m_PostLocationSelector;
    NOMLocationController*          m_LocationManager;
    NOMPostPreActionSelector*       m_PostPreActionSelector;
    NOMLocationServiceOperator*     m_LocationServiceOperator;
    
    NOMTrafficSpotRecord*           m_CurrentUpdateSpot;
    
    NOMSocialAccountManager*        m_SocialAccountManager;

    NOMWatchCommunicationManager*   m_WatchMessageManager;
    
    id<INOMCachedSoicalNewsContainer>   m_CachedSocialNewsContainer;
    NOMTimingService*               m_TimingService;
    int16_t                         m_nAutoQueryCount;
    int16_t                         m_nAutoSpotQueryCount;
    int16_t                         m_nAutoTaxiQueryCount;
    
    NSString*   m_szStreetAddress;
    NSString*   m_szCity;
    NSString*   m_szState;
    NSString*   m_szZipCode;
    NSString*   m_szCountry;
    NSString*   m_szCountryKey;

    BOOL        m_TrafficServiceInitializedInternally;
    
    BOOL        m_bPauseCloudInitialize;
    
    BOOL        m_bQueryStateDirty;
}

-(void)MarkMyLocationPinForPost;

-(void)OnMyLocationPinOK;
-(void)OnMyLocationPinCancel;
-(void)OnPostLocationPinOK;
-(void)OnPostLocationPinCancel;

-(void)OnTwitterAccountInitialized;
-(void)OnTwitterAccountGEOEnableChecked;

-(BOOL)PorcessNewsDataFromRemoteNotificationDictionary:(NSDictionary*)ndAlert;
-(BOOL)PorcessNewsDataFromRemoteNotificationString:(NSString*)sAlert;

-(void)StartPostSimpleTaxiInformation;

-(void)HandleSearchRegionToCurrentMapVisableRegion;
-(BOOL)CheckCurrentMapVisableRegionChangedFromSearchRegion;

-(void)SendGasStattionListToWatch:(NSArray*)spotList;
-(void)SendPhotoRadarListToWatch:(NSArray*)spotList;
-(void)SendSchoolZoneListToWatch:(NSArray*)spotList;
-(void)SendPlayGroundListToWatch:(NSArray*)spotList;
-(void)SendParkingGroundListToWatch:(NSArray*)spotList;

-(void)SendWatchPublishedNewsData:(NOMNewsMetaDataRecord*)pNewsData;
-(void)SendWatchPublishedSpotData:(NOMTrafficSpotRecord*)pSpot;

@end

@implementation NOMDocumentController

-(void)HandleLowMemoryState
{
    if(m_MainViewObject != nil)
        [m_MainViewObject RemoveAllNoLocationSocialNewsData];
 
//Remove alert for low memory
/*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[StringFactory GetString_Warning] message:[StringFactory GetString_LowMemoryAndCloseApps] delegate:nil cancelButtonTitle:[StringFactory GetString_Close] otherButtonTitles:nil];
    [alertView show];
*/
}

-(void)InitializeTrafficMessageQueueService
{
    if(m_PublishController != nil)
    {
        NSString* topicARN = [m_PublishController GetTrafficTopicARN];
        AmazonSNSClient* snsClient = [m_PublishController GetSNSClient];
        if(topicARN != nil && 0 < [topicARN length] && snsClient != nil)
        {
            if(m_BrowseController != nil)
            {
                [m_BrowseController RegisterTrafficTopic:topicARN withSNSClient:snsClient];
                [m_BrowseController InitializeTrafficMessageQueueService];
            }
        }
    }
}

-(void)InitializeTaxiMessageQueueService
{
    if(m_PublishController != nil)
    {
        NSString* topicARN = [m_PublishController GetTaxiTopicARN];
        AmazonSNSClient* snsClient = [m_PublishController GetSNSClient];
        if(topicARN != nil && 0 < [topicARN length] && snsClient != nil)
        {
            if(m_BrowseController != nil)
            {
                [m_BrowseController RegisterTaxiTopic:topicARN withSNSClient:snsClient];
                [m_BrowseController InitializeTaxiMessageQueueService];
            }
        }
    }
}

-(BOOL)IsCloudServiceInitialized
{
    return m_TrafficServiceInitializedInternally;
}

-(BOOL)IsCloudInitializationPaused
{
    return m_bPauseCloudInitialize;
}

-(void)SetCloudInitializationPause:(BOOL)bPause
{
    m_bPauseCloudInitialize = bPause;
}

-(void)InitializeCloudService
{
    if(m_TrafficServiceInitializedInternally == NO)
    {
        [self TrafficServiceInitializeInternally];
        [self TaxiServiceInitializeInternally];
        m_TrafficServiceInitializedInternally = YES;
        [self LoadCurrentRegionTrafficSpots];
    }
}

-(void)TrafficServiceInitializeInternally
{
    if(m_bPauseCloudInitialize == YES)
        return;
    
    [self InitializeMobilePushEndPointTrafficARN];
    [self InitializeTrafficMessageQueueService];
    if(m_MainViewObject)
        [m_MainViewObject MakeAppLocationOnMap];
    
    [self InitializeTimerService];
}

-(void)TaxiServiceInitializeInternally
{
    if(m_bPauseCloudInitialize == YES)
        return;
    
    [self InitializeMobilePushEndPointTaxiARN];
    [self InitializeTaxiMessageQueueService];
    [self InitializeTimerService];
}

-(void)OnTwitterAccountInitialized
{
    [m_SocialAccountManager CheckTwitterAccountGEOEnabling];
}

-(void)OnTwitterAccountGEOEnableChecked
{
    //???
    NSLog(@"OnTwitterAccountGEOEnableChecked");
}

-(void)ShowSimpleAlert:(NSString*)msgAlert
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgAlert delegate:nil cancelButtonTitle:[StringFactory GetString_Close] otherButtonTitles:nil];
	[alertView show];
}

-(void)ResetUserStatus
{
    m_UserStatus.m_UserMode = -1;
    m_UserStatus.m_NewsCategory = -1;
    m_UserStatus.m_NewsSubCategory = -1;
    m_UserStatus.m_NewsThirdCategory = -1;
    m_UserStatus.m_MarkSpotType = -1;
    m_UserStatus.m_MarkSpotDS = -1;
    m_UserStatus.m_CachedLongitude = 0.0;
    m_UserStatus.m_CachedLatitude = 0.0;
    
    m_szStreetAddress = nil;
    m_szCity = nil;
    m_szState = nil;
    m_szZipCode = nil;
    m_szCountry = nil;
    m_szCountryKey = nil;
    m_CurrentUpdateSpot = nil;
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_bPauseCloudInitialize = YES;
        //m_WatchMessageManager = [[NOMWatchCommunicationManager alloc] init];
        //[m_WatchMessageManager RegisterDocumentController:self];
        m_WatchMessageManager = [[NOMWatchCommunicationManager alloc] initWithDcoumentController:self];
        
        
        m_TrafficServiceInitializedInternally = NO;
        m_MapObjectController = [[NOMMapObjectController alloc] init];
        [m_MapObjectController SetParentController:self];
        
        m_SpotViewController = [[NOMSpotViewController alloc] init];
        [m_SpotViewController RegisterParent:self];
        
        m_PostViewController = [[NOMPostViewController alloc] init];
        [m_PostViewController RegisterParent:self];
        
        m_ReadViewController = [[NOMReadViewController alloc] init];
        [m_ReadViewController RegisterParent:self];
        
        m_MainViewObject = nil;
        [self ResetUserStatus];
        m_UserStatus.m_UserMode = NOM_USERMODE_UNINITIALIZEDTOU;
        
        m_PublishController = [[NOMPublishController alloc] init];
        [m_PublishController RegisterDelegate:self];
        m_BrowseController = [[NOMBrowseController alloc] init];
        [m_BrowseController RegisterDelegate:self];
        [self HookupPublishTrafficTopic];
        [self HookupPublishTaxiTopic];
        
        m_PostLocationSelector = [[NOMPostLocationSelector alloc] initWithDelegate:self];
        m_PostPreActionSelector = [[NOMPostPreActionSelector alloc] initWithDelegate:self];
        m_LocationServiceOperator = [[NOMLocationServiceOperator alloc] initWithDelegate:self];
        
        m_LocationManager = [[NOMLocationController alloc] init];
        [m_LocationManager AttachDelegate:self];
        
        m_CachedSocialNewsContainer = nil;
        
        [GUIEventLoop RegisterEvent:GUIID_TWITTER_ACCOUNT_INITIALIZATION_DONE eventHandler:@selector(OnTwitterAccountInitialized) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_TWITTER_ACCOUNT_GEOENABLING_CHECK_DONE eventHandler:@selector(OnTwitterAccountGEOEnableChecked) eventReceiver:self eventSender:nil];
        m_SocialAccountManager = [[NOMSocialAccountManager alloc] init];
        [m_SocialAccountManager RegisterDelegate:self];

        
        [self ClearMapPostMarkFlags];
        [GUIEventLoop RegisterEvent:GUIID_MAPVIEW_PIN_MYLOCATION_OKBUTTON_CLICKDOWN eventHandler:@selector(OnMyLocationPinOK) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_MAPVIEW_PIN_MYLOCATION_CANCELBUTTON_CLICKDOWN eventHandler:@selector(OnMyLocationPinCancel) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_MAPVIEW_PIN_POSTLOCATION_OKBUTTON_CLICKDOWN eventHandler:@selector(OnPostLocationPinOK) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_MAPVIEW_PIN_POSTLOCATION_CANCELBUTTON_CLICKDOWN eventHandler:@selector(OnPostLocationPinCancel) eventReceiver:self eventSender:nil];
        m_bQueryStateDirty = NO;
        
        [NOMGEOConfigration RegisterNOMQueryAnnotationDataDelegate:self];
        
        //[m_MapObjectController RegisterWatchMessageManager:m_WatchMessageManager];
    }
    
    return self;
}

-(BOOL)ProcessRemoteNotificationNewsData:(NOMNewsMetaDataRecord*)pNewsData
{
    BOOL bRet = NO;

    if(pNewsData != nil)
    {
        [self PinNewsDataOnMap:pNewsData];
        bRet = YES;
    }
    
    return bRet;
}

-(BOOL)PorcessNewsDataFromRemoteNotificationDictionary:(NSDictionary*)ndAlert
{
    BOOL bRet = NO;
    
    if(ndAlert != nil)
    {
        if([ndAlert objectForKey:@"body"] != nil)
        {
            if([[ndAlert objectForKey:@"body"] isKindOfClass:[NSString class]] == YES)
            {
                NSString* sRPAlert = [ndAlert objectForKey:@"body"];
                bRet = [self PorcessNewsDataFromRemoteNotificationString:sRPAlert];
            }
            else if([[ndAlert objectForKey:@"body"] isKindOfClass:[NSDictionary class]] == YES)
            {
                NSDictionary* ndRPAlert = [ndAlert objectForKey:@"body"];
                bRet = [self PorcessNewsDataFromRemoteNotificationDictionary:ndRPAlert];
            }
        }
        else
        {
            NOMNewsMetaDataRecord* pNewsData = [[NOMNewsMetaDataRecord alloc] init];
            if([pNewsData LoadFromJSONData:ndAlert] == YES)
            {
                bRet = [self ProcessRemoteNotificationNewsData:pNewsData];
            }
        }
    }
    
    return bRet;
}

-(BOOL)PorcessNewsDataFromRemoteNotificationString:(NSString*)sAlert
{
    BOOL bRet = NO;
    
    if(sAlert != nil && 0 < sAlert.length)
    {
        NSError *jsonError = nil;
        NSData* rawData = [sAlert dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:rawData options:kNilOptions error:&jsonError];
        if(jsonObject != nil && [jsonObject isKindOfClass:[NSDictionary class]] == YES)
        {
            bRet = [self PorcessNewsDataFromRemoteNotificationDictionary:jsonObject];
        }
    }
    return bRet;
}

- (BOOL)HandleRemoteNotificationData:(NSDictionary *)userInfo
{
    BOOL bRet = NO;
    
    //????????????????????????????????????
    
    if(userInfo != nil)
    {
        NSDictionary* appData = [userInfo objectForKey:@"aps"];
        if(appData != nil)
        {
            if([appData objectForKey:@"alert"] != nil)
            {
                /*if([[appData objectForKey:@"alert"] isKindOfClass:[NSString class]] == YES)
                {
                    NSString* sRPAlert = [appData objectForKey:@"alert"];
                    bRet = [self PorcessNewsDataFromRemoteNotificationString:sRPAlert];
                }
                else*/
                if([[appData objectForKey:@"alert"] isKindOfClass:[NSDictionary class]] == YES)
                {
                    NSDictionary* ndRPAlert = [appData objectForKey:@"alert"];
                    bRet = [self PorcessNewsDataFromRemoteNotificationDictionary:ndRPAlert];
                }
                else if([[appData objectForKey:@"alert"] isKindOfClass:[NSString class]] == YES)
                {
                    NSString* szMessageBody = [appData objectForKey:@"alert"];
                    NSString* rawJSONString = [NOMDataEncryptionHelper DecodingData:szMessageBody];
                    if(!(rawJSONString == nil || rawJSONString.length == 0))
                    {
                        NSError *jsonError = nil;
                        NSData* rawData = [rawJSONString dataUsingEncoding:NSUTF8StringEncoding];
                        id jsonObject = [NSJSONSerialization JSONObjectWithData:rawData options:kNilOptions error:&jsonError];
                        if(jsonObject != nil)
                        {
                            if ([jsonObject isKindOfClass:[NSDictionary class]])
                            {
                                NSLog(@"its probably a dictionary");
                                NSDictionary *jsonDictionarySrc = (NSDictionary *)jsonObject;
                                NSLog(@"jsonDictionary - %@", jsonDictionarySrc);
                                if(jsonDictionarySrc != nil)
                                {
                                    bRet = [self PorcessNewsDataFromRemoteNotificationDictionary:jsonDictionarySrc];
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        if(bRet == NO)
            m_bQueryStateDirty = YES;
    }
    else
    {
        m_bQueryStateDirty = NO;
        if(bRet == YES)
            return bRet;
        
        if(m_BrowseController != nil)
        {
            [m_BrowseController BrowseAllTrafficNews];
            [m_BrowseController BrowseAllTaxiNews];
        }
        [self LoadCurrentRegionTrafficSpots];
    }
    return bRet;
}

-(void)ApplicationBecomeActive
{
    if(m_bQueryStateDirty == YES)
    {
        if(m_BrowseController != nil)
        {
            [m_BrowseController BrowseAllTrafficNews];
            [m_BrowseController BrowseAllTaxiNews];
        }
        [self LoadCurrentRegionTrafficSpots];
        m_bQueryStateDirty = NO;
    }
}

-(void)ApplicationBecomeInActive
{
//    m_bQueryStateDirty = YES;
}

-(void)InitializeSpotViewController:(UIView*)pMainView
{
    [m_SpotViewController InitializeSpotViews:pMainView];
}

-(void)UpdateSpotViewControllerLayout
{
    [m_SpotViewController UpdateSpotViewLayout];
}

-(void)InitializePostViewController:(UIView*)pMainView
{
    [m_PostViewController InitializePostView:pMainView];
}

-(void)UpdatePostViewControllerLayout
{
    [m_PostViewController UpdatePostViewLayout];
}

-(void)InitializeReadViewController:(UIView*)pMainView
{
    [m_ReadViewController InitializeReadView:pMainView];
}

-(void)UpdateReadViewControllerLayout
{
    [m_ReadViewController UpdateReadViewLayout];
}

-(id<INOMCustomMapViewPinItemDelegate>)GetCustomMapViewPinItemDelegate
{
    return m_ReadViewController;
}

-(id<IMapObjectController>)GetMapObjectController
{
    return m_MapObjectController;
}

-(void)SetMainViewObject:(id<IMainViewDelegate>)mainview
{
    m_MainViewObject = mainview;
}

-(void)OnMenuEvent:(int)nMenuID
{
    if(m_MainViewObject != nil)
        [m_MainViewObject OnMenuEvent:nMenuID];
}

-(void)OnTouchBegin:(CGPoint)touchPoint
{
    
}

-(void)OnTouchMoved:(CGPoint)touchPoint
{
    
}

-(void)OnTouchEnded:(CGPoint)touchPoint
{
    
}

-(void)OnTouchCancelled:(CGPoint)touchPoint
{
    
}

-(void)HandleMapViewTouchEvent:(CLLocationCoordinate2D)touchPoint
{
    if([m_MapObjectController IsMarkPinForPost] == YES)
    {
        if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
        {
            double longStart = [NOMAppInfo GetAppLongitudeStart];
            double longEnd = [NOMAppInfo GetAppLongitudeEnd];
            double latStart = [NOMAppInfo GetAppLatitudeStart];
            double latEnd = [NOMAppInfo GetAppLatitudeEnd];
            
            if(longStart <= touchPoint.longitude && touchPoint.longitude <= longEnd &&
               latStart <= touchPoint.latitude && touchPoint.latitude <= latEnd)
            {
                [m_MapObjectController ShowPostPinAnnotation:touchPoint];
                [m_MapObjectController SetMarkPinForPost:NO];
            }
            else
            {
                [self ShowSimpleAlert:[StringFactory GetString_PostLocationOutAppRegion]];
                return;
            }
        }
        else
        {
            [m_MapObjectController ShowPostPinAnnotation:touchPoint];
            [m_MapObjectController SetMarkPinForPost:NO];
        }
    }
}

-(void)ShowPostPinAnnotation:(CLLocationCoordinate2D)location
{
    [m_MapObjectController ShowPostPinAnnotation:location];
    [m_MapObjectController SetMarkPinForPost:NO];
}

-(void)ClearMapTrafficMark
{
    if(m_WatchMessageManager != nil)
    {
        [m_WatchMessageManager BroadcastRemoveTrafficAnnotations];
    }
    
    if(m_MapObjectController != nil)
        [m_MapObjectController ClearMapTrafficMark];
    
    if(m_MainViewObject != nil)
        [m_MainViewObject RemoveAllNoLocationSocialNewsData];
}

-(void)ClearMapSpotMark
{
    if(m_WatchMessageManager != nil)
    {
        [m_WatchMessageManager BroadcastRemoveSpotAnnotations];
    }
    
    if(m_MapObjectController != nil)
        [m_MapObjectController ClearMapSpotMark];
}

-(void)ClearMapTaxiDriverMark
{
    if(m_MapObjectController != nil)
        [m_MapObjectController ClearMapTaxiDriverMark];
}

-(void)ClearMapTaxiPassengerMark
{
    if(m_MapObjectController != nil)
        [m_MapObjectController ClearMapTaxiPassengerMark];
}

-(void)ClearAllMapTaxiPassengerMark
{
    if(m_WatchMessageManager != nil)
    {
        [m_WatchMessageManager BroadcastRemoveTaxiAnnotations];
    }
    
    if(m_MapObjectController != nil)
        [m_MapObjectController ClearAllMapTaxiPassengerMark];
}


-(void)ClearAllMapMark
{
    [self OnMenuEvent:-1];
    if(m_WatchMessageManager != nil)
    {
        [m_WatchMessageManager BroadcastRemoveAllAnnotations];
    }
    [self ClearMapTrafficMark];
    [self ClearMapSpotMark];
    [self ClearAllMapTaxiPassengerMark];
}

-(void)SetTwitterConfiguration
{
    //??????????????????????
    //??????????????????????
    //??????????????????????
    //??????????????????????
    //??????????????????????
    //??????????????????????
    //??????????????????????
    //??????????????????????
    //[self OnMenuEvent:-1];
    if(m_MainViewObject != nil)
        [m_MainViewObject OpenTwitterAccountSetting];
}

-(void)ShowMyCurrentLocation
{
    [self OnMenuEvent:-1];
    if([m_LocationManager LocationServiceEnable] == NO)
    {
        [m_MapObjectController SetShowCurrentLocation:YES];
        [self HandleLocationServiceDisable];
        return;
    }
    
    [m_LocationManager Reset];
    [m_LocationManager CheckCurrentLocation:NO];
    [m_MapObjectController SetShowCurrentLocation:YES];

//    [self ShowSimpleAlert:@"Show my current location"];
}

-(void)OpenPrivacyClaim
{
    [self OnMenuEvent:GUIID_SETTINGMENU_ITEM_OPENPRIVACYVIEW_ID];
}

-(void)OpenTermOfUse
{
    [self OnMenuEvent:GUIID_SETTINGMENU_ITEM_OPENTERMSOFUSEVIEW_ID];
}

-(void)InitializeSettingMenuEvent
{
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_MAPTYPEMENU_ITEM_MAPSTANDARD_ID eventHandler:@selector(SetMapTypeStandard) eventReceiver:m_MapObjectController eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_MAPTYPEMENU_ITEM_MAPHYBIRD_ID eventHandler:@selector(SetMapTypeHybrid) eventReceiver:m_MapObjectController eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_MAPTYPEMENU_ITEM_MAPSATELLITE_ID eventHandler:@selector(SetMapTypeSatellite) eventReceiver:m_MapObjectController eventSender:nil];

//    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_TRAFFIC_ID eventHandler:@selector(ClearMapTrafficMark) eventReceiver:m_MapObjectController eventSender:nil];
//    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_SPOT_ID eventHandler:@selector(ClearMapSpotMark) eventReceiver:m_MapObjectController eventSender:nil];
//    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_ALL_ID eventHandler:@selector(ClearAllMapMark) eventReceiver:m_MapObjectController eventSender:nil];
    
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_TRAFFIC_ID eventHandler:@selector(ClearMapTrafficMark) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_SPOT_ID eventHandler:@selector(ClearMapSpotMark) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_ALL_ID eventHandler:@selector(ClearAllMapMark) eventReceiver:self eventSender:nil];

    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_CLEARTAXIMENU_ITEM_TAXIDRIVER_ID eventHandler:@selector(ClearMapTaxiDriverMark) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_CLEARTAXIMENU_ITEM_TAXIPASSENGER_ID eventHandler:@selector(ClearMapTaxiPassengerMark) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_CLEARTAXIMENU_ITEM_ALL_ID eventHandler:@selector(ClearAllMapTaxiPassengerMark) eventReceiver:self eventSender:nil];
    
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_CLEARMAPMENU_ITEM_TAXI_ID eventHandler:@selector(ClearAllMapTaxiPassengerMark) eventReceiver:self eventSender:nil];
    
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_ITEM_TWITTERSETTING_ID eventHandler:@selector(SetTwitterConfiguration) eventReceiver:self eventSender:nil];
    
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_ITEM_SHOWMYLOCATION_ID eventHandler:@selector(ShowMyCurrentLocation) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_ITEM_OPENPRIVACYVIEW_ID eventHandler:@selector(OpenPrivacyClaim) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_ITEM_OPENTERMSOFUSEVIEW_ID eventHandler:@selector(OpenTermOfUse) eventReceiver:self eventSender:nil];
    
}

-(void)SetUserMode:(int)nMode withCategory:(int)nMainCate withSubCategory:(int)nSubCate withThirdCategory:(int)nThirdCate
{
    [self ResetUserStatus];
    [self ClearMapPostMarkFlags];
    m_UserStatus.m_UserMode = nMode;
    m_UserStatus.m_NewsCategory = nMainCate;
    m_UserStatus.m_NewsSubCategory = nSubCate;
    m_UserStatus.m_NewsThirdCategory = nThirdCate;
}

-(void)SetUserModeSpotAction:(int)nMode withSpotType:(int16_t)nSpotType withSpotDS:(int32_t)nSpotDS
{
    [self ResetUserStatus];
    [self ClearMapPostMarkFlags];
    m_UserStatus.m_UserMode = nMode;
    m_UserStatus.m_MarkSpotType = nSpotType;
    m_UserStatus.m_MarkSpotDS = nSpotDS;
    if(nSpotType == -1)
    {
        m_nAutoSpotQueryCount = 0;
    }
}

-(void)ShowTaxiPostLocationOption
{
    //?????????????????
    //?????????????????
    //?????????????????
    //?????????????????
    //?????????????????
    //?????????????????
    [self HandlePostLocationSelectorCurrentLocationSelected];
}

-(void)StartHandlePostEvent
{
    //if(m_UserStatus.m_UserMode == NOM_USERMODE_POST && m_UserStatus.m_NewsCategory == NOM_NEWSCATEGORY_TAXI)
    //{
    //    [self ShowTaxiPostLocationOption];
    //}
    //else
    //{
        [m_PostLocationSelector ShowThreeLocationsOptionSelector];
    //}
}

-(void)StartHandleSearchEvent
{
/*
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(StartHandleSearchEvent) withObject:nil waitUntilDone:NO];
        return;
    }
*/    
    if(m_UserStatus.m_UserMode == NOM_USERMODE_QUERYTRAFFICSPOT)
    {
        [m_BrowseController BrowseSpots:m_UserStatus.m_MarkSpotType spotDS:m_UserStatus.m_MarkSpotDS];
        //????
#ifdef DEBUG
        [m_WatchMessageManager BroadcastDebugAlertMessage:@"m_BrowseController BrowseSpots:m_UserStatus.m_MarkSpotType spotDS:m_UserStatus.m_MarkSpotDS"];
#endif
    }
    else if(m_UserStatus.m_UserMode == NOM_USERMODE_QUERY)
    {
        if(m_UserStatus.m_NewsCategory == NOM_NEWSCATEGORY_TAXI)
        {
            m_nAutoTaxiQueryCount = 0;
            int64_t nCurrentTime = [NOMTimeHelper CurrentTimeInInteger];
            int64_t nTimeBefore = nCurrentTime - NOM_TAXINEWS_SQS_RETENTION_TIME_DEFAULT;
            [m_MapObjectController RemoveTaxiNewsRecordByTimeStamp:nTimeBefore];
            [m_BrowseController BrowseAllTaxiNews];
#ifdef DEBUG
            [m_WatchMessageManager BroadcastDebugAlertMessage:@"BrowseAllTaxiNews"];
#endif
        }
        else
        {
            m_nAutoQueryCount = 0;
            if(m_MainViewObject != nil)
                [m_MainViewObject RemoveAllNoLocationSocialNewsData];
        
            int64_t nCurrentTime = [NOMTimeHelper CurrentTimeInInteger];
            int64_t nTimeBefore = nCurrentTime - NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT;
            [m_MapObjectController RemoveNewsRecordByTimeStamp:nTimeBefore];
            //[m_BrowseController BrowseNewsFromSQS:m_UserStatus.m_NewsCategory subCate:m_UserStatus.m_NewsSubCategory thirdCate:m_UserStatus.m_NewsThirdCategory];
            [m_BrowseController BrowseAllTrafficNews];
#ifdef DEBUG
            [m_WatchMessageManager BroadcastDebugAlertMessage:@"BrowseAllTrafficNews"];
#endif
        }
    }
    m_bQueryStateDirty = NO;
}

-(void)StartAutoQueryNews
{
    [self SetUserMode:NOM_USERMODE_QUERY
        withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
        withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_ALL
        withThirdCategory:-1];
    [self StartHandleSearchEvent];
}

-(void)StartSpotAutoQueryNews
{
    [self SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:-1 withSpotDS:0];
    [self StartHandleSearchEvent];
}

-(void)StartTaxiAutoQueryNews
{
    [self SetUserMode:NOM_USERMODE_QUERY
         withCategory:NOM_NEWSCATEGORY_TAXI
      withSubCategory:NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_ALL
    withThirdCategory:-1];
    [self StartHandleSearchEvent];
}

-(void)HookupPublishTrafficTopic
{
    [m_PublishController HookupTrafficTopic];
}

-(void)HookupPublishTaxiTopic
{
    [m_PublishController HookupTaxiTopic];
}

-(NSString*)GetTrafficMessageQueueName
{
    NSString* sName = nil;
    
    return sName;
}

-(void)InitializeTimerService
{
    if(m_TimingService == nil)
    {
        m_nAutoQueryCount = 0;
        m_nAutoSpotQueryCount = 0;
        m_nAutoTaxiQueryCount = 0;
        m_TimingService = [[NOMTimingService alloc] init];
        [m_TimingService RegisterServiceRecipient:self];
        [m_TimingService Initialize];
    }
}

-(void)InitializeMobilePushEndPointTrafficARN
{
    if(m_PublishController != nil)
    {
        [m_PublishController InitializeMobilePushEndPointTrafficARN];
    }
}

-(void)InitializeMobilePushEndPointTaxiARN
{
    if(m_PublishController != nil)
    {
        [m_PublishController InitializeMobilePushEndPointTaxiARN];
    }
}

-(void)InitializeMobilePushEndPointARN
{
    if(m_PublishController != nil)
    {
        [m_PublishController InitializeMobilePushEndPointTrafficARN];
        [m_PublishController InitializeMobilePushEndPointTaxiARN];
    }
}

-(void)HandleSearchRegionToCurrentMapVisableRegion
{
    
}

-(void)HandleMultipleRegionAppRegionChange
{
#ifdef _SINGLE_CITYAPP_
    return;
#endif
    BOOL bChanged = [self CheckCurrentMapVisableRegionChangedFromSearchRegion];
    if(bChanged == NO)
        return;
    
    if([[NOMPreference GetSharedPreference] GetAutoRegionChangeSwitch] == NO)
    {
        if([[NOMPreference GetSharedPreference] GetAskRegionChangeSwitchSearchRegionFlag] == YES)
        {
            
        }
        else
        {
            return;
        }
    }
    else
    {
        [self HandleSearchRegionToCurrentMapVisableRegion];
    }
}

-(void)MapViewVisualRegionChanged
{
    //??????????????????
    /*
    [m_PublishController HandleActiveRegionChanged];
    [m_BrowseController HandleActiveRegionChanged];
    */
    if([NOMAppInfo IsCityBaseAppRegionOnly] == NO)
    {
        [self HandleMultipleRegionAppRegionChange];
    }
    MKCoordinateRegion region = [m_MapObjectController GetMapViewVisibleRegion];
    [m_WatchMessageManager BroadcastMapViewCenter:region.center.latitude withLongitude:region.center.longitude];
}

-(void)LoadingMapFinished
{
    if(m_UserStatus.m_UserMode < -1)
    {
        m_UserStatus.m_UserMode = -1;
    }
/*
    if(m_TrafficServiceInitializedInternally == NO)
    {
        BOOL bAccepted = [NOMAppInfo GetTermOfUse];
        if(bAccepted)
        {
            [self TrafficServiceInitializeInternally];
            [self TaxiServiceInitializeInternally];
        }
    }
    
    //Initialize Twiiter Account here
    if([m_SocialAccountManager IsAccountInitialized] == NO)
    {
        [m_SocialAccountManager InitializeAccount];
    }
*/
}

-(BOOL)CheckCurrentMapVisableRegionChangedFromSearchRegion
{
    BOOL bRet = NO;
    
    if([NOMAppInfo IsCityBaseAppRegionOnly] == NO)
    {
        MKMapRect mapRect = [m_MapObjectController GetMapViewVisibleRect];
        MKMapPoint ptStart = mapRect.origin;
        MKMapPoint ptEnd = MKMapPointMake(mapRect.origin.x + mapRect.size.width, mapRect.origin.y + mapRect.size.height);
        CLLocationCoordinate2D coordStart = MKCoordinateForMapPoint(ptStart);
        CLLocationCoordinate2D coordEnd = MKCoordinateForMapPoint(ptEnd);
        double startLat = coordStart.latitude;
        double endLat = coordEnd.latitude;
        double startLong = coordStart.longitude;
        double endLong = coordEnd.longitude;
        NSString* szRegion = [NOMAppRegionHelper QueryRegionKey:startLat endLatitude:endLat startLongitude:startLong endLongitude:endLong];
        NSString* szCurrentRegionKey = [NOMAppRegionHelper GetCurrentRegionKey];
        
        if(szRegion == nil && [NOMAppRegionHelper IsCurrentRegionDefault] == YES)
        {
            return YES;
        }
        else
        {
            if([szCurrentRegionKey isEqualToString:szRegion] == NO)
            {
                if(szRegion != nil)
                {
                    //????
                }
                else
                {
                    //????
                }
            }
            else
            {
                //????
            }
        }
        
    }
    else
    {
        
    }
    
    return bRet;
}

-(void)MapRenderingFinished
{
    if(m_TrafficServiceInitializedInternally == NO)
    {
        BOOL bAccepted = [NOMAppInfo GetTermOfUse];
        if(bAccepted)
        {
            if(m_TrafficServiceInitializedInternally == NO)
            {
            //[self TrafficServiceInitializeInternally];
            //[self TaxiServiceInitializeInternally];
                [self InitializeCloudService];
            }
        }
        //Initialize Twiiter Account here
        if([m_SocialAccountManager IsAccountInitialized] == NO)
        {
            [m_SocialAccountManager InitializeAccount];
        }
        m_TrafficServiceInitializedInternally = YES;
        return;
    }
    
    //[self CheckAndHandleRegionChange];
}

-(void)AsyncLoadCurrentRegionTrafficSpots
{
    double latStart, latEnd, lonStart, lonEnd;
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        [NOMAppRegionHelper GetCurrentRegion:&latStart toLatitude:&latEnd fromLongitude:&lonStart toLongitude:&lonEnd];
    }
    else
    {
        if([NOMAppRegionHelper IsCurrentRegionDefault] == NO)
        {
            [NOMAppRegionHelper GetCurrentRegion:&latStart toLatitude:&latEnd fromLongitude:&lonStart toLongitude:&lonEnd];
        }
        else
        {
            MKMapRect mapRect = [m_MapObjectController GetMapViewVisibleRect];
            MKMapPoint ptStart = mapRect.origin;
            MKMapPoint ptEnd = MKMapPointMake(mapRect.origin.x + mapRect.size.width, mapRect.origin.y + mapRect.size.height);
            CLLocationCoordinate2D coordStart = MKCoordinateForMapPoint(ptStart);
            CLLocationCoordinate2D coordEnd = MKCoordinateForMapPoint(ptEnd);
            latStart = MIN(coordStart.latitude, coordEnd.latitude);
            latEnd = MAX(coordStart.latitude, coordEnd.latitude);
            lonStart = MIN(coordStart.longitude, coordEnd.longitude);
            lonEnd = MAX(coordStart.longitude, coordEnd.longitude);
        }
    }
    
    [m_BrowseController SearchTrafficSpots:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd];
}

-(void)LoadCurrentRegionTrafficSpots
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self AsyncLoadCurrentRegionTrafficSpots];
    });
}

-(void)ClearMapPostMarkFlags
{
    [m_MapObjectController SetMapMode:NO];
    [m_MapObjectController SetMarkPinForPost:NO];
}

-(void)PrepareSpotPosting
{
    [m_PostPreActionSelector ShowTwoPostPreActionOptionSelector];
}

-(void)PrepareNewsPosting
{
	//int16_t     m_NewsCategory;
    //int16_t     m_NewsSubCategory;
    //int16_t     m_NewsThirdCategory;
    
    [m_PostViewController CreatePostingNewsDetail:m_UserStatus.m_NewsCategory withSubCategory:m_UserStatus.m_NewsSubCategory withThirdCategory:m_UserStatus.m_NewsThirdCategory];
    double minSpan = [m_MapObjectController GetVisibleRegionMinimumSpan];
    [m_PostViewController SetPostingViewReferencePoint:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withSpan:minSpan];
}

///////////////////////////////////////////////////////////////////////
//
//Post taxi information
//
///////////////////////////////////////////////////////////////////////
-(void)StartPostTaxiInformation
{
    //???????????????????????
    [self StartPostSimpleTaxiInformation];
}
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////


-(double)GetCurrentMapVisibleRegionMinSpan
{
    return [m_MapObjectController GetVisibleRegionMinimumSpan];
}

-(void)PreparePosting
{
    if(m_UserStatus.m_UserMode == NOM_USERMODE_MARKTRAFFICSPOT)
    {
        [self PrepareSpotPosting];
    }
    else if(m_UserStatus.m_UserMode == NOM_USERMODE_POST)
    {
        if(m_UserStatus.m_NewsCategory == NOM_NEWSCATEGORY_TAXI)
        {
            [self StartPostTaxiInformation];
        }
        else
        {
            [self PrepareNewsPosting];
        }
    }
}

-(void)StartNewsDirectPosting
{
    NSString* newsID = [[NSUUID UUID] UUIDString];
    int64_t   nTime = [NOMTimeHelper CurrentTimeInInteger];
    NSString* pEmail = nil;
    NSString* pDName = nil;
    
    NOMNewsMetaDataRecord* pNewsMetaData = [[NOMNewsMetaDataRecord alloc] initWithID:newsID withTime:nTime withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withPEmail:pEmail withPDName:pDName withCategory:m_UserStatus.m_NewsCategory withSubCategory:m_UserStatus.m_NewsSubCategory withThirdCategory:m_UserStatus.m_NewsThirdCategory withResourceURL:nil withWearable:1];
    
    NSString* szLabel;
    
    if(m_UserStatus.m_NewsCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        szLabel = [StringFactory GetString_NewsTitle:m_UserStatus.m_NewsCategory subCategory:m_UserStatus.m_NewsSubCategory];
    }
    else
    {
        szLabel = [StringFactory GetString_TrafficTypeTitle:m_UserStatus.m_NewsSubCategory withType:m_UserStatus.m_NewsThirdCategory];
    }
    
    NSString* sentFromWK = @"Sent from #AppleWatch";
    NSString* appURL = [NOMAppInfo GetAppStoreURL];
    
    NSString* szPosting = [NSString stringWithFormat:@"%@ %@", sentFromWK, appURL];
    
    [m_PublishController StartPostNews:pNewsMetaData
                           withSubject:szLabel
                              withPost:szPosting
                           withKeyWord:nil
                         withCopyRight:nil
                               withKML:nil
                             withImage:nil
                        shareOnTwitter:[self CanShareOnTwitter]];
}

-(void)StartDirectPosting
{
    if(m_UserStatus.m_UserMode == NOM_USERMODE_MARKTRAFFICSPOT)
    {
        [self DoSpotPostingNow];
    }
    else if(m_UserStatus.m_UserMode == NOM_USERMODE_POST)
    {
        if(m_UserStatus.m_NewsCategory == NOM_NEWSCATEGORY_TAXI)
        {
            [self StartPostSimpleTaxiInformation];
        }
        else
        {
            [self StartNewsDirectPosting];
        }
    }
}

-(BOOL)CheckPostLocationInsideAppRegion:(CLLocationCoordinate2D)postPoint
{
    BOOL bRet = [NOMAppInfo IsLocationInAppRegion:postPoint];
    
    if(bRet == NO)
    {
        [self ShowSimpleAlert:[StringFactory GetString_PostLocationOutAppRegion]];
    }
    
    return bRet;
}

-(void)OnMyLocationPinOK
{
    CLLocationCoordinate2D postPoint = [m_MapObjectController GetMyPostPinLocation];
    
    //Check the ?????????
    BOOL bInsidePostRegion = [self CheckPostLocationInsideAppRegion:postPoint];
    if(bInsidePostRegion == NO)
        return;
    
    m_UserStatus.m_CachedLongitude = postPoint.longitude;
    m_UserStatus.m_CachedLatitude = postPoint.latitude;
    [m_MapObjectController HideMyLocationPostAnnotation];
    [m_MapObjectController SetShowCurrentLocation:NO];
    [self ClearMapPostMarkFlags];
    
    [self PreparePosting];
}

-(void)OnMyLocationPinCancel
{
    [m_MapObjectController HideMyLocationPostAnnotation];
    [m_MapObjectController SetShowCurrentLocation:NO];
    [self ClearMapPostMarkFlags];
    [self ResetUserStatus];
}

-(void)OnPostLocationPinOK
{
    CLLocationCoordinate2D postPoint = [m_MapObjectController GetPostPinLocation];
    
    //Check the ?????????
    BOOL bInsidePostRegion = [self CheckPostLocationInsideAppRegion:postPoint];
    if(bInsidePostRegion == NO)
        return;
    
    m_UserStatus.m_CachedLongitude = postPoint.longitude;
    m_UserStatus.m_CachedLatitude = postPoint.latitude;
    [m_MapObjectController HidePostPinAnnotation];
    [m_MapObjectController SetShowCurrentLocation:NO];
    [self ClearMapPostMarkFlags];
    [self PreparePosting];
}

-(void)OnPostLocationPinCancel
{
    [m_MapObjectController HidePostPinAnnotation];
    [m_MapObjectController SetShowCurrentLocation:NO];
    [self ClearMapPostMarkFlags];
    [self ResetUserStatus];
}

-(void)CloseCallout
{
    if(m_MainViewObject != nil)
        [m_MainViewObject CloseCallout];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//NOMBrowseControllerDelegate metods
//
-(void)TrafficMessageQueueInitialized:(BOOL)bNeedSubcribe
{
    if(bNeedSubcribe == YES)
    {
        [m_BrowseController SubcribeTrafficMessageQueueToNoficationService];
    }
    else
    {
        //[m_BrowseController QueryAllDataFromTrafficSQS];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_async(queue, ^(void)
        {
            [m_BrowseController QueryAllDataFromTrafficSQS];
        });
    }
}

-(void)TaxiMessageQueueInitialized:(BOOL)bNeedSubcribe
{
    if(bNeedSubcribe == YES)
    {
        [m_BrowseController SubcribeTaxiMessageQueueToNoficationService];
    }
    else
    {
        //[m_BrowseController QueryAllDataFromTaxiSQS];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_async(queue, ^(void)
        {
            [m_BrowseController QueryAllDataFromTaxiSQS];
        });
    }
}

-(void)HandleGasStattionList:(NSArray*)spotList
{
    [self SendGasStattionListToWatch:spotList];
    [m_MapObjectController HandleSearchTrafficSpotList:spotList];
}

-(void)HandlePhotoRadarList:(NSArray*)spotList
{
    [self SendPhotoRadarListToWatch:spotList];
    [m_MapObjectController HandleSearchTrafficSpotList:spotList];
}

-(void)HandleSchoolZoneList:(NSArray*)spotList
{
    [self SendSchoolZoneListToWatch:spotList];
    [m_MapObjectController HandleSearchTrafficSpotList:spotList];
}

-(void)HandlePlayGroundList:(NSArray*)spotList
{
    [self SendPlayGroundListToWatch:spotList];
    [m_MapObjectController HandleSearchTrafficSpotList:spotList];
}

-(void)HandleParkingGroundList:(NSArray*)spotList
{
    [self SendParkingGroundListToWatch:spotList];
    [m_MapObjectController HandleSearchTrafficSpotList:spotList];
}

-(void)HandleSearchTrafficSpotList:(NSArray*)spotList withSpotType:(int16_t)nType;
{
/*
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(HandleSearchTrafficSpotList:) withObject:spotList waitUntilDone:NO];
        return;
    }
    
    [m_MapObjectController HandleSearchTrafficSpotList:spotList];
    [self SendSpotDataToWatch:spotList];
*/
    if(nType == NOM_TRAFFICSPOT_GASSTATION)
    {
        [self HandleGasStattionList:spotList];
    }
    else if(nType == NOM_TRAFFICSPOT_PHOTORADAR)
    {
        [self HandlePhotoRadarList:spotList];
    }
    else if(nType == NOM_TRAFFICSPOT_SCHOOLZONE)
    {
        [self HandleSchoolZoneList:spotList];
    }
    else if(nType == NOM_TRAFFICSPOT_PLAYGROUND)
    {
        [self HandlePlayGroundList:spotList];
    }
    else if(nType == NOM_TRAFFICSPOT_PARKINGGROUND)
    {
        [self HandleParkingGroundList:spotList];
    }
    
}

-(void)ProcessNoLocationSocialNewsData:(NOMNewsMetaDataRecord*)pNewsData
{
    if(m_MainViewObject != nil)
        [m_MainViewObject AddNoLocationSocialNewsData:pNewsData];
}

-(void)PinNewsDataOnMap:(NOMNewsMetaDataRecord*)pNewsData
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(PinNewsDataOnMap:) withObject:pNewsData waitUntilDone:NO];
        return;
    }
    
    if(pNewsData.m_bTwitterTweet == NO || (pNewsData.m_NewsLatitude != 0.0 && pNewsData.m_NewsLongitude != 0.0))
    {
        [m_MapObjectController PinNewsDataOnMap:pNewsData];
    }
    else
    {
        //Don't collect non-location tweet data
        //[self ProcessNoLocationSocialNewsData:pNewsData];
        
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//NOMPublishControllerDelegate metods
//
-(void)TrafficTopicHookupDone
{
    if(m_bPauseCloudInitialize == NO)
    {
        if(m_TrafficServiceInitializedInternally == NO)
        {
            //[self InitializeCloudService];
            [self TrafficServiceInitializeInternally];
        }
    }
}

-(void)TaxiTopicHookupDone
{
    if(m_bPauseCloudInitialize == NO)
    {
        if(m_TrafficServiceInitializedInternally == NO)
        {
            //[self InitializeCloudService];
            [self TaxiServiceInitializeInternally];
        }
    }
}

-(void)MobileDeviceSubscribeDone
{
    //?????????????????
}

-(void)PostNewSpotDataToTrafficMessageQ:(NOMTrafficSpotRecord*)pSpot
{
    NOMNewsMetaDataRecord* pNewsData = [[NOMNewsMetaDataRecord alloc] init];
    [NOMNewsServiceHelper ConvertSpotRecord:pSpot toNewsRecord:pNewsData];
    [m_PublishController DirectPostNews:pNewsData];
}

-(void)SpotPublished:(NOMTrafficSpotRecord*)pSpot
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(SpotPublished:) withObject:pSpot waitUntilDone:NO];
        return;
    }
    
    if(m_MapObjectController != nil)
    {
        [m_MapObjectController HandleSpotRecord:pSpot];
    }
    
    [self PostNewSpotDataToTrafficMessageQ:pSpot];
   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self SendWatchPublishedSpotData:pSpot];
    });
}

-(void)StartUpdateSpotData:(NOMTrafficSpotRecord*)pSpot
{
    [m_SpotViewController UpdateSpotData:pSpot];
}

-(void)NewsPublishedSuceed:(NOMNewsMetaDataRecord*)pNewsData
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(NewsPublishedSuceed:) withObject:pNewsData waitUntilDone:NO];
        return;
    }
    
    
    if(m_MapObjectController != nil)
    {
        [m_MapObjectController PinNewsDataOnMap:pNewsData];
    }
    [self SendWatchPublishedNewsData:pNewsData];
}

-(ACAccount*)GetCurrentTwitterAccount
{
    ACAccount* pAccount = nil;
    if(m_SocialAccountManager != nil)
    {
        pAccount = [m_SocialAccountManager GetTwitterUserAccount];
    }
    
    return pAccount;
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//NOMPostLoctionSelectorDelegate methods
//
-(void)HandlePostLocationSelectorCancelButtonClicked
{
    [self ClearMapPostMarkFlags];
}

-(void)HandlePostLocationSelectorCurrentLocationSelected
{
    if([m_LocationManager LocationServiceEnable] == NO)
    {
        [m_MapObjectController SetShowCurrentLocation:YES];
        [self HandleLocationServiceDisable];
        return;
    }
    if([m_MapObjectController IsMarkingMode] == YES || [m_MapObjectController IsMarkPinForPost] == YES)
        return;
    
    [m_MapObjectController SetShowCurrentLocation:YES];
    [m_LocationManager Reset];
    [m_LocationManager CheckCurrentLocation:YES];
}

-(void)HandlePostLocationSelectorPinOnMapSelected
{
    if([m_MapObjectController IsMarkingMode] == YES || [m_MapObjectController IsMarkPinForPost] == YES)
        return;
    
    [m_MapObjectController SetMapMode:NO];
    [m_MapObjectController SetMarkPinForPost:YES];
}

-(void)HandlePostLocationSelectorInputLocationAddressSelected
{
    if([m_MapObjectController IsMarkingMode] == YES || [m_MapObjectController IsMarkPinForPost] == YES)
        return;
    
    //?????????
    [m_MainViewObject StartFindLocationForPosting];
}

-(void)PostNewPhotoRadarInformation:(int16_t)nPhotoCameraType withDirection:(int16_t)nCamDirection withSCType:(int16_t)nSCDeviceType withAddress:(NSString*)szAddress withFine:(double)dFine shareOnTwitter:(BOOL)bShareOnTwitter
{
    NSString* spotID = [[NSUUID UUID] UUIDString];
    NOMTrafficSpotRecord* pSpot = [[NOMTrafficSpotRecord alloc] initWithID:spotID withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withType:m_UserStatus.m_MarkSpotType withSubType:nPhotoCameraType];
    pSpot.m_ThirdType = nCamDirection;
    pSpot.m_FourType = nSCDeviceType;
    pSpot.m_SpotAddress = szAddress;
    pSpot.m_Price = dFine;
    if(0.0 < pSpot.m_Price)
        pSpot.m_PriceTime = [NOMTimeHelper CurrentTimeInInteger];
    [m_PublishController PublishSpot:pSpot shareOnTwitter:bShareOnTwitter];
    [self ResetUserStatus];
}

-(void)PostNewGasStationInformation:(NSString*)szName withAddress:(NSString*)szAddress withCarWash:(int16_t)nCarWashType withPrice:(double)dPrice withPriceUnit:(int16_t)nPriceUnit shareOnTwitter:(BOOL)bShareOnTwitter
{
    NSString* spotID = [[NSUUID UUID] UUIDString];
    NOMTrafficSpotRecord* pSpot = [[NOMTrafficSpotRecord alloc] initWithID:spotID withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withType:m_UserStatus.m_MarkSpotType withSubType:nCarWashType];
    pSpot.m_SpotAddress = szAddress;
    pSpot.m_SpotName = szName;
    pSpot.m_Price = dPrice;
    if(0.0 < pSpot.m_Price)
        pSpot.m_PriceTime = [NOMTimeHelper CurrentTimeInInteger];
    pSpot.m_PriceUnit = nPriceUnit;
    
    [m_PublishController PublishSpot:pSpot shareOnTwitter:bShareOnTwitter];
    [self ResetUserStatus];
}

-(void)PostNewParkingGroundInformation:(NSString*)szName withAddress:(NSString*)szAddress withRate:(double)dRate withRateUnit:(int16_t)nRateUnit shareOnTwitter:(BOOL)bShareOnTwitter
{
    NSString* spotID = [[NSUUID UUID] UUIDString];
    NOMTrafficSpotRecord* pSpot = [[NOMTrafficSpotRecord alloc] initWithID:spotID withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withType:m_UserStatus.m_MarkSpotType withSubType:0];
    pSpot.m_SpotAddress = szAddress;
    pSpot.m_SpotName = szName;
    pSpot.m_Price = dRate;
    if(0.0 < pSpot.m_Price)
        pSpot.m_PriceTime = [NOMTimeHelper CurrentTimeInInteger];
    pSpot.m_PriceUnit = nRateUnit;
    
    [m_PublishController PublishSpot:pSpot shareOnTwitter:bShareOnTwitter];
    [self ResetUserStatus];
}

-(void)PostNewSchoolZoneOrPlaygroundZoneInformation:(NSString*)szName withAddress:(NSString*)szAddress shareOnTwitter:(BOOL)bShareOnTwitter
{
    NSString* spotID = [[NSUUID UUID] UUIDString];
    NOMTrafficSpotRecord* pSpot = [[NOMTrafficSpotRecord alloc] initWithID:spotID withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withType:m_UserStatus.m_MarkSpotType withSubType:0];
    pSpot.m_SpotAddress = szAddress;
    pSpot.m_SpotName = szName;
    
    [m_PublishController PublishSpot:pSpot shareOnTwitter:bShareOnTwitter];
    [self ResetUserStatus];
}

-(void)PublishSpot:(NOMTrafficSpotRecord*)pRecord shareOnTwitter:(BOOL)bShareOnTwitter
{
    [m_PublishController PublishSpot:pRecord shareOnTwitter:bShareOnTwitter];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//NOMPostPreActionSelectorDelegate methods
//
-(void)DoSpotPostingNow
{
    NSString* spotID = [[NSUUID UUID] UUIDString];
    NOMTrafficSpotRecord* pSpot = [[NOMTrafficSpotRecord alloc] initWithID:spotID withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withType:m_UserStatus.m_MarkSpotType withSubType:m_UserStatus.m_MarkSpotDS];
    BOOL bCanShareOnTwitter = [self CanShareOnTwitter];
    [m_PublishController PublishSpot:pSpot shareOnTwitter:bCanShareOnTwitter];
}

-(void)DoPostNow
{
    if(m_UserStatus.m_UserMode == NOM_USERMODE_MARKTRAFFICSPOT)
    {
        [self DoSpotPostingNow];
    }
}

-(void)HandlePostNowSelected
{
    [self DoPostNow];
}

-(void)DoAddSpotPostingDetail
{
    if(m_UserStatus.m_UserMode == NOM_USERMODE_MARKTRAFFICSPOT)
    {
        [m_SpotViewController AddNewSpotDetailForPosting:m_UserStatus.m_MarkSpotType withSubType:m_UserStatus.m_MarkSpotDS];
    }
}

-(void)DoAddPostDetail
{
    if(m_UserStatus.m_UserMode == NOM_USERMODE_MARKTRAFFICSPOT)
    {
        [self DoAddSpotPostingDetail];
    }
}

-(void)HandleAddPostDetailSelected
{
    [self DoAddPostDetail];
}
//////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//NOMLocationControllerDelegate methods
//
-(void)MarkMyLocationPinForPost
{
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        double longStart = [NOMAppInfo GetAppLongitudeStart];
        double longEnd = [NOMAppInfo GetAppLongitudeEnd];
        double latStart = [NOMAppInfo GetAppLatitudeStart];
        double latEnd = [NOMAppInfo GetAppLatitudeEnd];
        CLLocationCoordinate2D touchPoint = [m_LocationManager GetLocation].coordinate;
        
        if(longStart <= touchPoint.longitude && touchPoint.longitude <= longEnd &&
           latStart <= touchPoint.latitude && touchPoint.latitude <= latEnd)
        {
            [m_MapObjectController ShowPostPinAnnotation:touchPoint];
            [m_MapObjectController SetMarkPinForPost:NO];
        }
        else
        {
            [self ShowSimpleAlert:[StringFactory GetString_PostLocationOutAppRegion]];
            return;
        }
    }
    else
    {
        [m_MapObjectController SetMapMode:YES];
        [m_MapObjectController ShowMyLocationPostAnnotation:[m_LocationManager GetLocation].coordinate];
    }
    
}

-(void)CheckMyLocationAndShowMyLocationRegion
{
    CLLocationCoordinate2D location = [m_LocationManager GetLocation].coordinate;
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        double longStart = [NOMAppInfo GetAppLongitudeStart];
        double longEnd = [NOMAppInfo GetAppLongitudeEnd];
        double latStart = [NOMAppInfo GetAppLatitudeStart];
        double latEnd = [NOMAppInfo GetAppLatitudeEnd];
        
        if(longStart <= location.longitude && location.longitude <= longEnd &&
           latStart <= location.latitude && location.latitude <= latEnd)
        {
            MKCoordinateRegion region = [m_MapObjectController GetMapViewVisibleRegion];
            region.center.longitude = location.longitude;
            region.center.latitude = location.latitude;
            [m_MapObjectController SetMapViewVisibleRegion:region];
            [m_WatchMessageManager BroadcastMapViewCenter:location.latitude withLongitude:location.longitude];
        }
        else
        {
            return;
        }
    }
    else
    {
        //????????????????????????????
        //????????????????????????????
        [m_WatchMessageManager BroadcastMapViewCenter:location.latitude withLongitude:location.longitude];
        return;
    }
}

-(void)LocationUpdateCompleted:(BOOL)bSucceed
{
    if(bSucceed == YES)
    {
        if([m_LocationManager IsCheckForPosting] == YES)
        {
            [self MarkMyLocationPinForPost];
        }
    }
    else
    {
        [m_LocationManager Reset];
        [self ResetUserStatus];
    }
    //Initialize Twiiter Account here
    if([m_SocialAccountManager IsAccountInitialized] == NO)
    {
        [m_SocialAccountManager InitializeAccount];
    }

    if(bSucceed == YES)
    {
        [self CheckMyLocationAndShowMyLocationRegion];
    }
}

-(void)HandleLocationServiceDisable
{
    [m_LocationServiceOperator ShowLocationServiceIndicator];
}

-(void)LocationServiceNotAvaliable
{
    if([m_LocationManager LocationServiceEnable] == NO)
    {
        [self HandleLocationServiceDisable];
    }
}

-(void)EnableLocationService
{
    //[m_LocationManager AuthorizeLocationService];
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        if([NOMAppInfo IsVersion8] == YES)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        else
        {
            [m_LocationManager AuthorizeLocationService];
        }
    });
}

//////////////////////////////////////////////////////////////////////////////////////////////////////


-(void)SetUserModeCachedAddress:(NSString*)szStreet city:(NSString*)szCity state:(NSString*)szState zipCode:(NSString*)szZipCode country:(NSString*)szCountry countryKey:(NSString*)szCountryKey
{
    m_szStreetAddress = szStreet;
    m_szCity = szCity;
    m_szState = szState;
    m_szZipCode = szZipCode;
    m_szCountry = szCountry;
    m_szCountryKey = szCountryKey;
}


/*
#ifdef DEBUG

-(void)DeleteCurrentPhotoRaderInformation
{
    
}

-(void)DeleteCurrentGasStationInformation
{
    
}

-(void)DeleteCurrentParkingGroundInformation
{
    
}

-(void)DeleteCurrentSchoolZoneInformation
{
    
}

-(void)OnSpotUIDeleteEvent:(id)spotUI
{
    if(spotUI != nil)
    {
        if([spotUI isKindOfClass:[NOMSpotPhotoRadarView class]] == YES)
        {
            [self DeleteCurrentPhotoRaderInformation];
        }
        else if([spotUI isKindOfClass:[NOMSpotGasStationView class]] == YES)
        {
            [self DeleteCurrentGasStationInformation];
        }
        else if([spotUI isKindOfClass:[NOMSpotParkingGroundView class]] == YES)
        {
            [self DeleteCurrentParkingGroundInformation];
        }
        else if([spotUI isKindOfClass:[NOMSpotSchoolZoneView class]] == YES)
        {
            [self DeleteCurrentSchoolZoneInformation];
        }
    }
}

#endif
*/

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
// Post news data method
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)StartPostNews:(NSString*)szSubject
            withPost:(NSString*)szPost
         withKeyWord:(NSString*)szKeyWord
       withCopyRight:(NSString*)szCopyRight
             withKML:(NSString*)szKML
           withImage:(UIImage*)pImage
      shareOnTwitter:(BOOL)bShareOnTwitter
{
    NSString* newsID = [[NSUUID UUID] UUIDString];
    int64_t   nTime = [NOMTimeHelper CurrentTimeInInteger];
    NSString* pEmail = nil;
    NSString* pDName = nil;
    
    NOMNewsMetaDataRecord* pNewsMetaData = [[NOMNewsMetaDataRecord alloc] initWithID:newsID withTime:nTime withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withPEmail:pEmail withPDName:pDName withCategory:m_UserStatus.m_NewsCategory withSubCategory:m_UserStatus.m_NewsSubCategory withThirdCategory:m_UserStatus.m_NewsThirdCategory withResourceURL:nil withWearable:1];

    [m_PublishController StartPostNews:pNewsMetaData
                           withSubject:szSubject
                              withPost:szPost
                           withKeyWord:szKeyWord
                         withCopyRight:szCopyRight
                               withKML:szKML
                             withImage:pImage
                        shareOnTwitter:bShareOnTwitter];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
// Post taxi data
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)StartPostSimpleTaxiInformation
{

    NSString* newsID = [[NSUUID UUID] UUIDString];
    int64_t   nTime = [NOMTimeHelper CurrentTimeInInteger];
    NSString* pEmail = nil;
    NSString* pDName = nil;
    
    NOMNewsMetaDataRecord* pNewsMetaData = [[NOMNewsMetaDataRecord alloc] initWithID:newsID withTime:nTime withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withPEmail:pEmail withPDName:pDName withCategory:m_UserStatus.m_NewsCategory withSubCategory:m_UserStatus.m_NewsSubCategory withThirdCategory:m_UserStatus.m_NewsThirdCategory withResourceURL:nil withWearable:1];
    
    [m_PublishController StartPostTaxiInformation:pNewsMetaData];

}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////

-(NOMNewsMetaDataRecord*)GetNews:(NSString*)pNewsID
{
    NOMNewsMetaDataRecord* pNews = nil;
    
    pNews = [self GetNewsRecord:pNewsID];
    
    return pNews;
}

-(NOMNewsMetaDataRecord*)GetNewsRecord:(NSString*)pNewsID
{
    NOMNewsMetaDataRecord* pNews = nil;
    
    if(m_MapObjectController != nil)
    {
        pNews = [m_MapObjectController GetNewsRecord:pNewsID];
    }
    
    return pNews;
}

-(NOMNewsMetaDataRecord*)GetCachedSocialNews:(NSString*)pNewsID
{
    NOMNewsMetaDataRecord* pNews = nil;
    
    if(m_CachedSocialNewsContainer != nil)
    {
        pNews = (NOMNewsMetaDataRecord*)[m_CachedSocialNewsContainer GetCachedSocialNews:pNewsID];
    }
    
    return pNews;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)CanShareOnTwitter
{
    BOOL bYes = NO;
    
    if(m_SocialAccountManager != nil)
    {
        bYes = [m_SocialAccountManager HasTwitterUserAccountInDevice];
    }
    
    return bYes;
}

-(void)SetCachedSocialNewsContainer:(id<INOMCachedSoicalNewsContainer>)container
{
    m_CachedSocialNewsContainer = container;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//INOMTimingServiceRecipient methods
//
//////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)HandleNormalAutoQueryEvent
{
    ++m_nAutoQueryCount;
    if(NOM_AUTO_QUERY_DEFAULT_STEP <= m_nAutoQueryCount)
    {
        if(m_UserStatus.m_UserMode == -1 || m_UserStatus.m_UserMode == NOM_USERMODE_QUERYTRAFFICSPOT || m_UserStatus.m_UserMode == NOM_USERMODE_QUERY)
        {
            [self StartAutoQueryNews];
        }
    }
}

-(void)HandleNormalSpotAutoQueryEvent
{
    ++m_nAutoSpotQueryCount;
    if(NOM_AUTO_SPOT_QUERY_DEFAULT_STEP <= m_nAutoSpotQueryCount)
    {
        if(m_UserStatus.m_UserMode == -1 || m_UserStatus.m_UserMode == NOM_USERMODE_QUERYTRAFFICSPOT || m_UserStatus.m_UserMode == NOM_USERMODE_QUERY)
        {
            [self StartSpotAutoQueryNews];
        }
    }
}

-(void)HandleNormalTaxiAutoQueryEvent
{
    ++m_nAutoTaxiQueryCount;
    if(NOM_AUTO_TAXI_QUERY_DEFAULT_STEP <= m_nAutoTaxiQueryCount)
    {
        if(m_UserStatus.m_UserMode == -1 || m_UserStatus.m_UserMode == NOM_USERMODE_QUERYTRAFFICSPOT || m_UserStatus.m_UserMode == NOM_USERMODE_QUERY)
        {
            [self StartTaxiAutoQueryNews];
        }
    }
}

-(void)OnUnitTimingEvent
{
//    [self RemoveObseleteData];
    [self HandleNormalAutoQueryEvent];
    [self HandleNormalTaxiAutoQueryEvent];
    [self HandleNormalSpotAutoQueryEvent];
}

-(BOOL)IsLocationServiceAuthorization
{
    if(m_LocationManager != nil)
    {
        return [m_LocationManager LocationServiceEnable];
    }
    return NO;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//NOMQueryAnnotationDataDelegate method
//
//////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)QueryAnnontationDataChanged:(id)data
{
    if(data && [data isKindOfClass:[NOMNewsMetaDataRecord class]] == YES)
    {
        [self PinNewsDataOnMap:(NOMNewsMetaDataRecord*)data];
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//Apple Watch handling code
//
//////////////////////////////////////////////////////////////////////////////////////////////////////
-(NOMWatchCommunicationManager*)GetWatchCommunicationManager
{
    return m_WatchMessageManager;
}

-(void)ProcessWatchSearchRequest:(int16_t)nChoice option:(int16_t)nOption
{
#ifdef DEBUG
    [m_WatchMessageManager BroadcastDebugAlertMessage:@"ProcessWatchSearchRequest:(int16_t)nChoice option:(int16_t)nOption"];
#endif

    m_UserStatus.m_UserMode = NOM_USERMODE_QUERY; //[NOMAppWatchDataHelper GetPostUserModeTypeFromWatchActionChoice:nChoice];
    
    int16_t pMainCate = 0;
    int16_t pSubCate = 0;
    int16_t pThirdCate = 0;
    
    [NOMAppWatchDataHelper QueryUserModeDetailFromWatchActionChoice:nChoice actionOption:nOption toMainCate:&pMainCate toSubCate:&pSubCate toThirdCate:&pThirdCate];
    
    if(nChoice == NOM_WATCH_ACTION_CHOICE_TRAFIC)
    {
        [self SetUserMode:NOM_USERMODE_QUERY
             withCategory:pMainCate
          withSubCategory:pSubCate
        withThirdCategory:pThirdCate];
    }
    else if(nChoice == NOM_WATCH_ACTION_CHOICE_SPOT)
    {
        [self SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:pSubCate withSpotDS:pThirdCate];
    }
    else if(nChoice == NOM_WATCH_ACTION_CHOICE_TAXI)
    {
        [self SetUserMode:NOM_USERMODE_QUERY
             withCategory:NOM_NEWSCATEGORY_TAXI
          withSubCategory:pSubCate
        withThirdCategory:-1];
    }
    [self StartHandleSearchEvent];
}

-(void)ProcessWatchPostRequest:(int16_t)nChoice option:(int16_t)nOption latitude:(double)dLatiude longitude:(double)dLongitude
{
    m_UserStatus.m_UserMode = [NOMAppWatchDataHelper GetPostUserModeTypeFromWatchActionChoice:nChoice];
    
    int16_t pMainCate = 0;
    int16_t pSubCate = 0;
    int16_t pThirdCate = 0;
    
    [NOMAppWatchDataHelper QueryUserModeDetailFromWatchActionChoice:nChoice actionOption:nOption toMainCate:&pMainCate toSubCate:&pSubCate toThirdCate:&pThirdCate];
    
    if(nChoice == NOM_WATCH_ACTION_CHOICE_TRAFIC)
    {
        [self SetUserMode:NOM_USERMODE_POST
             withCategory:pMainCate
          withSubCategory:pSubCate
        withThirdCategory:pThirdCate];
    }
    else if(nChoice == NOM_WATCH_ACTION_CHOICE_SPOT)
    {
        [self SetUserModeSpotAction:NOM_USERMODE_MARKTRAFFICSPOT withSpotType:pSubCate withSpotDS:pThirdCate];
    }
    else if(nChoice == NOM_WATCH_ACTION_CHOICE_TAXI)
    {
        [self SetUserMode:NOM_USERMODE_POST
             withCategory:NOM_NEWSCATEGORY_TAXI
          withSubCategory:pSubCate
        withThirdCategory:-1];
    }
    
    CLLocationCoordinate2D postPoint;
    postPoint.latitude = dLatiude;
    postPoint.longitude = dLongitude;
    
    //Check the ?????????
    BOOL bInsidePostRegion = [NOMAppInfo IsLocationInAppRegion:postPoint];//[self CheckPostLocationInsideAppRegion:postPoint];
    if(bInsidePostRegion == NO)
    {
        //??????????????????
        //??????????????????
        //Send watch for Wrong region posting
        if(m_WatchMessageManager != nil)
        {
            [m_WatchMessageManager BroadcastLocationNotSuppotPostingWarnMessage];
        }
        return;
    }
    
    m_UserStatus.m_CachedLongitude = postPoint.longitude;
    m_UserStatus.m_CachedLatitude = postPoint.latitude;
    [m_MapObjectController HidePostPinAnnotation];
    [m_MapObjectController SetShowCurrentLocation:NO];
    [self ClearMapPostMarkFlags];
    [self StartDirectPosting];
    //[self PreparePosting];
}

-(void)AsynSendSocialTrafficMessagesToWatch:(NSArray*)dataArray
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [m_WatchMessageManager BroadcastSocialTafficMessage:dataArray];
    });
}

-(void)HandleSoicalSearchToWatch:(NSArray*)rawDataList
{
    if(rawDataList != nil && 0 < rawDataList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(NOMNewsMetaDataRecord* pNewsData in rawDataList)
        {
            if(pNewsData != nil)
            {
                NSDictionary* pData = [pNewsData CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [self AsynSendSocialTrafficMessagesToWatch:dataArray];
    }
}

/*
-(void)AsynSendNewsDataMessagesToWatch:(NSArray*)rawDataList
{
    if(rawDataList != nil && 0 < rawDataList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(NOMNewsMetaDataRecord* pNewsData in rawDataList)
        {
            if(pNewsData != nil)
            {
                NSDictionary* pData = [pNewsData CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [m_WatchMessageManager BroadcastAnnotations:dataArray];
    }
}
*/

-(void)AsynSendTrafficMessagesToWatch:(NSArray*)rawDataList
{
    if(rawDataList != nil && 0 < rawDataList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(NOMNewsMetaDataRecord* pNewsData in rawDataList)
        {
            if(pNewsData != nil)
            {
                NSDictionary* pData = [pNewsData CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [m_WatchMessageManager BroadcastTafficMessage:dataArray];
    }
}

-(void)SendTrafficMessagesToWatch:(NSArray*)rawDataList
{
    if(rawDataList != nil && 0 < rawDataList.count)
    {
        [m_WatchMessageManager BroadcastDebugAlertMessage:@"SetTrafficMessageToWatch with valid data"];
    }
    else
    {
        [m_WatchMessageManager BroadcastDebugAlertMessage:@"SetTrafficMessageToWatch empty"];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {

        [self AsynSendTrafficMessagesToWatch:rawDataList];
    });
}

-(void)AsynSendTaxiMessagesToWatch:(NSArray*)rawDataList
{
    if(rawDataList != nil && 0 < rawDataList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(NOMNewsMetaDataRecord* pNewsData in rawDataList)
        {
            if(pNewsData != nil)
            {
                NSDictionary* pData = [pNewsData CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [m_WatchMessageManager BroadcastTaxiMessage:dataArray];
    }
}

-(void)SendTaxiMessagesToWatch:(NSArray*)rawDataList
{
    if(rawDataList != nil && 0 < rawDataList.count)
    {
        [m_WatchMessageManager BroadcastDebugAlertMessage:@"SetTaxiMessageToWatch with valid data"];
    }
    else
    {
        [m_WatchMessageManager BroadcastDebugAlertMessage:@"SetTaxiMessageToWatch empty"];
    }

    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self AsynSendTaxiMessagesToWatch:rawDataList];
    });
}

-(void)SendWatchPublishedNewsData:(NOMNewsMetaDataRecord*)pNewsData
{
    if(pNewsData != nil && pNewsData.m_NewsID != nil && 0 < pNewsData.m_NewsID.length)
    {
        if(pNewsData.m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
        {
            NSArray* rawDataList = [NSArray arrayWithObject:pNewsData];
            [self SendTrafficMessagesToWatch:rawDataList];
        }
        else if(pNewsData.m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI)
        {
            NSArray* rawDataList = [NSArray arrayWithObject:pNewsData];
            [self SendTaxiMessagesToWatch:rawDataList];
        }
    }
}


/*
-(void)SendSpotDataToWatch:(NSArray*)spotList
{
    if(spotList != nil && 0 < spotList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < spotList.count; ++i)
        {
            if([[spotList objectAtIndex:i] isKindOfClass:[NOMTrafficSpotRecord class]] == YES)
            {
                NOMTrafficSpotRecord* pSpotRecord = (NOMTrafficSpotRecord*)[spotList objectAtIndex:i];
                NSDictionary* pData = [pSpotRecord CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [self AsynBroadcastAnnotations:dataArray];
    }
}
*/
 
-(void)SendGasStattionListToWatch:(NSArray*)spotList
{
    if(spotList != nil && 0 < spotList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < spotList.count; ++i)
        {
            if([[spotList objectAtIndex:i] isKindOfClass:[NOMTrafficSpotRecord class]] == YES)
            {
                NOMTrafficSpotRecord* pSpotRecord = (NOMTrafficSpotRecord*)[spotList objectAtIndex:i];
                NSDictionary* pData = [pSpotRecord CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [m_WatchMessageManager BroadcastGasStattionList:dataArray];
    }
}

-(void)SendPhotoRadarListToWatch:(NSArray*)spotList
{
    if(spotList != nil && 0 < spotList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < spotList.count; ++i)
        {
            if([[spotList objectAtIndex:i] isKindOfClass:[NOMTrafficSpotRecord class]] == YES)
            {
                NOMTrafficSpotRecord* pSpotRecord = (NOMTrafficSpotRecord*)[spotList objectAtIndex:i];
                NSDictionary* pData = [pSpotRecord CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [m_WatchMessageManager BroadcastPhotoRadarList:dataArray];
    }
}

-(void)SendSchoolZoneListToWatch:(NSArray*)spotList
{
    if(spotList != nil && 0 < spotList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < spotList.count; ++i)
        {
            if([[spotList objectAtIndex:i] isKindOfClass:[NOMTrafficSpotRecord class]] == YES)
            {
                NOMTrafficSpotRecord* pSpotRecord = (NOMTrafficSpotRecord*)[spotList objectAtIndex:i];
                NSDictionary* pData = [pSpotRecord CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [m_WatchMessageManager BroadcastSchoolZoneList:dataArray];
    }
}

-(void)SendPlayGroundListToWatch:(NSArray*)spotList
{
    if(spotList != nil && 0 < spotList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < spotList.count; ++i)
        {
            if([[spotList objectAtIndex:i] isKindOfClass:[NOMTrafficSpotRecord class]] == YES)
            {
                NOMTrafficSpotRecord* pSpotRecord = (NOMTrafficSpotRecord*)[spotList objectAtIndex:i];
                NSDictionary* pData = [pSpotRecord CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [m_WatchMessageManager BroadcastPlayGroundList:dataArray];
    }
}

-(void)SendParkingGroundListToWatch:(NSArray*)spotList
{
    if(spotList != nil && 0 < spotList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < spotList.count; ++i)
        {
            if([[spotList objectAtIndex:i] isKindOfClass:[NOMTrafficSpotRecord class]] == YES)
            {
                NOMTrafficSpotRecord* pSpotRecord = (NOMTrafficSpotRecord*)[spotList objectAtIndex:i];
                NSDictionary* pData = [pSpotRecord CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        [m_WatchMessageManager BroadcastParkingGroundList:dataArray];
    }
}

-(void)SendWatchPublishedSpotData:(NOMTrafficSpotRecord*)pSpot
{
    if(pSpot != nil && pSpot.m_SpotID != nil && 0 < pSpot.m_SpotID.length)
    {
        if(pSpot.m_Type == NOM_TRAFFICSPOT_SCHOOLZONE)
        {
            NSArray* spotList = [NSArray arrayWithObject:pSpot];
            [self SendSchoolZoneListToWatch:spotList];
        }
        else if(pSpot.m_Type == NOM_TRAFFICSPOT_PHOTORADAR)
        {
            NSArray* spotList = [NSArray arrayWithObject:pSpot];
            [self SendPhotoRadarListToWatch:spotList];
        }
        else if(pSpot.m_Type == NOM_TRAFFICSPOT_PLAYGROUND)
        {
            NSArray* spotList = [NSArray arrayWithObject:pSpot];
            [self SendPlayGroundListToWatch:spotList];
        }
        else if(pSpot.m_Type == NOM_TRAFFICSPOT_PARKINGGROUND)
        {
            NSArray* spotList = [NSArray arrayWithObject:pSpot];
            [self SendParkingGroundListToWatch:spotList];
        }
        else if(pSpot.m_Type == NOM_TRAFFICSPOT_GASSTATION)
        {
            NSArray* spotList = [NSArray arrayWithObject:pSpot];
            [self SendGasStattionListToWatch:spotList];
        }
    }
}

-(void)DoGeneralSearchForWatch
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [m_BrowseController QueryAllDataFromTrafficSQS];
    });
    
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue2, ^(void)
    {
        [m_BrowseController QueryAllDataFromTaxiSQS];
    });
    
}

//
//Apple Watch opening event
//
-(void)HandleAppleWatchOpenRequest:(NSMutableDictionary*)appData
{
    m_UserStatus.m_UserMode = NOM_USERMODE_QUERY;
    
    if(m_LocationManager != nil)
    {
        [m_LocationManager Reset];
        [m_LocationManager CheckCurrentLocation:NO];
        [m_MapObjectController SetShowCurrentLocation:YES];
    }
    
    if(m_MapObjectController != nil && [m_MapObjectController CanHandleAppleWatchRequest] == YES)
    {
#ifdef DEBUG
        [self SendDebugMessageToAppleWatch:@"Can load cached map data for apple watch open app request"];
#endif
        [m_MapObjectController HandleAppleWatchOpenRequest:appData];
    }
    else
    {
#ifdef DEBUG
        [self SendDebugMessageToAppleWatch:@"No cached map data for apple watch open app request, start search data"];
#endif
        
        NSNumber* pLatitude = [[NSNumber alloc] initWithDouble:[NOMAppInfo GetAppLatitude]];
        NSNumber* pLongitude = [[NSNumber alloc] initWithDouble:[NOMAppInfo GetAppLongitude]];
        
        [appData setValue:pLatitude forKey:EMSG_KEY_LOCATIONLATITUDE];
        [appData setValue:pLongitude forKey:EMSG_KEY_LOCATIONLONGITUDE];
    }
    if(([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground))
    {
        if(m_BrowseController != nil)
        {
            [m_BrowseController BrowseAllTrafficNews];
            [m_BrowseController BrowseAllTaxiNews];
        }
        [self LoadCurrentRegionTrafficSpots];
    }
    m_bQueryStateDirty = NO;
}

-(void)HandleAppleWatchOpenRequestForSearch:(NSMutableDictionary*)appData withChoice:(int16_t)nChoice whithOption:(int16_t)nOption
{
#ifdef DEBUG
    [m_WatchMessageManager BroadcastDebugAlertMessage:@"HandleAppleWatchOpenRequestForSearch:(NSMutableDictionary*)appData withChoice:(int16_t)nChoice whithOption:(int16_t)nOption"];
#endif
    if(m_LocationManager != nil)
    {
        [m_LocationManager Reset];
        [m_LocationManager CheckCurrentLocation:NO];
        [m_MapObjectController SetShowCurrentLocation:YES];
    }
    
    m_UserStatus.m_UserMode = NOM_USERMODE_QUERY;
    int16_t pMainCate = 0;
    int16_t pSubCate = 0;
    int16_t pThirdCate = 0;
    
    [NOMAppWatchDataHelper QueryUserModeDetailFromWatchActionChoice:nChoice actionOption:nOption toMainCate:&pMainCate toSubCate:&pSubCate toThirdCate:&pThirdCate];

    
    if(nChoice == NOM_WATCH_ACTION_CHOICE_TRAFIC)
    {
#ifdef DEBUG
        [m_WatchMessageManager BroadcastDebugAlertMessage:@"HandleAppleWatchOpenRequestForSearch:nChoice == NOM_WATCH_ACTION_CHOICE_TRAFIC"];
#endif
        if(m_MapObjectController != nil && [m_MapObjectController CanHandleAppleWatchRequestSearchTraffic] == YES)
        {
            [m_MapObjectController HandleAppleWatchOpenRequestSearchTraffic:appData];
        }
        
        if(m_BrowseController != nil)
        {
            [m_BrowseController BrowseAllTrafficNews];
            [m_BrowseController BrowseAllTaxiNews];
        }
        return;
    }
    else if(nChoice == NOM_WATCH_ACTION_CHOICE_SPOT)
    {
#ifdef DEBUG
        [m_WatchMessageManager BroadcastDebugAlertMessage:@"HandleAppleWatchOpenRequestForSearch:nChoice == NOM_WATCH_ACTION_CHOICE_SPOT"];
#endif
        if(m_MapObjectController != nil && [m_MapObjectController CanHandleAppleWatchRequestSearchSpot] == YES)
        {
            [m_MapObjectController HandleAppleWatchOpenRequestSearchSpot:appData];
        }
        [self LoadCurrentRegionTrafficSpots];
        return;
    }
    else if(nChoice == NOM_WATCH_ACTION_CHOICE_TAXI)
    {
#ifdef DEBUG
        [m_WatchMessageManager BroadcastDebugAlertMessage:@"HandleAppleWatchOpenRequestForSearch:nChoice == NOM_WATCH_ACTION_CHOICE_TAXI"];
#endif
        if(m_MapObjectController != nil && [m_MapObjectController CanHandleAppleWatchRequestSearchTaxi] == YES)
        {
            [m_MapObjectController HandleAppleWatchOpenRequestSearchTaxi:appData];
        }
        if(m_BrowseController != nil)
        {
            [m_BrowseController BrowseAllTrafficNews];
            [m_BrowseController BrowseAllTaxiNews];
        }
        return;
    }
}

-(void)HandleAppleWatchOpenRequestForCurrentLocation:(NSMutableDictionary*)appData
{
    if(m_LocationManager != nil && [m_LocationManager LocationServiceEnable] == YES)
    {
        CLLocation* pLocation = [m_LocationManager GetLocation];
        if(pLocation != nil)
        {
            NSNumber* pLatitude = [[NSNumber alloc] initWithDouble:pLocation.coordinate.latitude];
            NSNumber* pLongitude = [[NSNumber alloc] initWithDouble:pLocation.coordinate.longitude];
            
            [appData setValue:pLatitude forKey:EMSG_KEY_LOCATIONLATITUDE];
            [appData setValue:pLongitude forKey:EMSG_KEY_LOCATIONLONGITUDE];
        }
        [m_LocationManager Reset];
        [m_LocationManager CheckCurrentLocation:NO];
        [m_MapObjectController SetShowCurrentLocation:YES];
    }
}

-(void)DoSpotPostingReplyData:(NSMutableDictionary*)appData
{
    NSString* spotID = [[NSUUID UUID] UUIDString];
    NOMTrafficSpotRecord* pSpot = [[NOMTrafficSpotRecord alloc] initWithID:spotID withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withType:m_UserStatus.m_MarkSpotType withSubType:m_UserStatus.m_MarkSpotDS];
    BOOL bCanShareOnTwitter = [self CanShareOnTwitter];
    [m_PublishController PublishSpot:pSpot shareOnTwitter:bCanShareOnTwitter];
    NSDictionary* pData = [pSpot CreateWatchAnnotationKeyValueBlock];
    [appData setObject:pData forKey:EMSG_KEY_OPENCONTAINERAPP_MSG_ID];
}

-(void)DoPostSimpleTaxiInformationReplyData:(NSMutableDictionary*)appData
{
    NSString* newsID = [[NSUUID UUID] UUIDString];
    int64_t   nTime = [NOMTimeHelper CurrentTimeInInteger];
    NSString* pEmail = nil;
    NSString* pDName = nil;
    
    NOMNewsMetaDataRecord* pNewsMetaData = [[NOMNewsMetaDataRecord alloc] initWithID:newsID withTime:nTime withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withPEmail:pEmail withPDName:pDName withCategory:m_UserStatus.m_NewsCategory withSubCategory:m_UserStatus.m_NewsSubCategory withThirdCategory:m_UserStatus.m_NewsThirdCategory withResourceURL:nil withWearable:1];
    
    [m_PublishController StartPostTaxiInformation:pNewsMetaData];
    NSDictionary* pData = [pNewsMetaData CreateWatchAnnotationKeyValueBlock];
    [appData setObject:pData forKey:EMSG_KEY_OPENCONTAINERAPP_MSG_ID];
}

-(void)DoNewsDirectPostingReplyData:(NSMutableDictionary*)appData
{
    NSString* newsID = [[NSUUID UUID] UUIDString];
    int64_t   nTime = [NOMTimeHelper CurrentTimeInInteger];
    NSString* pEmail = nil;
    NSString* pDName = nil;
    
    NOMNewsMetaDataRecord* pNewsMetaData = [[NOMNewsMetaDataRecord alloc] initWithID:newsID withTime:nTime withLatitude:m_UserStatus.m_CachedLatitude withLongitude:m_UserStatus.m_CachedLongitude withPEmail:pEmail withPDName:pDName withCategory:m_UserStatus.m_NewsCategory withSubCategory:m_UserStatus.m_NewsSubCategory withThirdCategory:m_UserStatus.m_NewsThirdCategory withResourceURL:nil withWearable:1];
    
    NSString* szLabel;
    
    if(m_UserStatus.m_NewsCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        szLabel = [StringFactory GetString_NewsTitle:m_UserStatus.m_NewsCategory subCategory:m_UserStatus.m_NewsSubCategory];
    }
    else
    {
        szLabel = [StringFactory GetString_TrafficTypeTitle:m_UserStatus.m_NewsSubCategory withType:m_UserStatus.m_NewsThirdCategory];
    }
    
    NSString* sentFromWK = @"Sent from #AppleWatch";
    NSString* appURL = [NOMAppInfo GetAppStoreURL];
    
    NSString* szPosting = [NSString stringWithFormat:@"%@ %@", sentFromWK, appURL];
    
    [m_PublishController StartPostNews:pNewsMetaData
                           withSubject:szLabel
                              withPost:szPosting
                           withKeyWord:nil
                         withCopyRight:nil
                               withKML:nil
                             withImage:nil
                        shareOnTwitter:[self CanShareOnTwitter]];
    
    NSDictionary* pData = [pNewsMetaData CreateWatchAnnotationKeyValueBlock];
    [appData setObject:pData forKey:EMSG_KEY_OPENCONTAINERAPP_MSG_ID];
    
}

-(void)DoDirectPostingWithReplyData:(NSMutableDictionary*)appData
{
    if(m_UserStatus.m_UserMode == NOM_USERMODE_MARKTRAFFICSPOT)
    {
        //[self DoSpotPostingNow];
        [self DoSpotPostingReplyData:appData];
    }
    else if(m_UserStatus.m_UserMode == NOM_USERMODE_POST)
    {
        if(m_UserStatus.m_NewsCategory == NOM_NEWSCATEGORY_TAXI)
        {
            //[self StartPostSimpleTaxiInformation];
            [self DoPostSimpleTaxiInformationReplyData:appData];
        }
        else
        {
            //[self StartNewsDirectPosting];
            [self DoNewsDirectPostingReplyData:appData];
        }
    }
}

-(void)HandleAppleWatchOpenRequestForPost:(NSMutableDictionary*)appData withChoice:(int16_t)nChoice whithOption:(int16_t)nOption atLatitude:(double)dLatiude atLongitude:(double)dLongitude
{
    m_UserStatus.m_UserMode = [NOMAppWatchDataHelper GetPostUserModeTypeFromWatchActionChoice:nChoice];
    
    int16_t pMainCate = 0;
    int16_t pSubCate = 0;
    int16_t pThirdCate = 0;
    
    [NOMAppWatchDataHelper QueryUserModeDetailFromWatchActionChoice:nChoice actionOption:nOption toMainCate:&pMainCate toSubCate:&pSubCate toThirdCate:&pThirdCate];
    
    if(nChoice == NOM_WATCH_ACTION_CHOICE_TRAFIC)
    {
        [self SetUserMode:NOM_USERMODE_POST
             withCategory:pMainCate
          withSubCategory:pSubCate
        withThirdCategory:pThirdCate];
    }
    else if(nChoice == NOM_WATCH_ACTION_CHOICE_SPOT)
    {
        [self SetUserModeSpotAction:NOM_USERMODE_MARKTRAFFICSPOT withSpotType:pSubCate withSpotDS:pThirdCate];
    }
    else if(nChoice == NOM_WATCH_ACTION_CHOICE_TAXI)
    {
        [self SetUserMode:NOM_USERMODE_POST
             withCategory:NOM_NEWSCATEGORY_TAXI
          withSubCategory:pSubCate
        withThirdCategory:-1];
    }
    
    CLLocationCoordinate2D postPoint;
    postPoint.latitude = dLatiude;
    postPoint.longitude = dLongitude;
    
    //Check the ?????????
    BOOL bInsidePostRegion = [NOMAppInfo IsLocationInAppRegion:postPoint];//[self CheckPostLocationInsideAppRegion:postPoint];
    if(bInsidePostRegion == NO)
    {
        //Send watch for Wrong region posting
        if(m_WatchMessageManager != nil)
        {
            [m_WatchMessageManager BroadcastLocationNotSuppotPostingWarnMessage];
        }
        return;
    }
    
    m_UserStatus.m_CachedLongitude = postPoint.longitude;
    m_UserStatus.m_CachedLatitude = postPoint.latitude;
    [m_MapObjectController HidePostPinAnnotation];
    [m_MapObjectController SetShowCurrentLocation:NO];
    [self ClearMapPostMarkFlags];
    [self DoDirectPostingWithReplyData:appData];
}

-(void)HandleAppleWatchOpenRequestForGeneralSearch
{
    if(([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground))
    {
        if(m_BrowseController != nil)
        {
            [m_BrowseController BrowseAllTrafficNews];
            [m_BrowseController BrowseAllTaxiNews];
        }
        [self LoadCurrentRegionTrafficSpots];
     }
    
    if(m_LocationManager != nil)
    {
        [m_LocationManager Reset];
        [m_LocationManager CheckCurrentLocation:NO];
        [m_MapObjectController SetShowCurrentLocation:YES];
    }
    
}

-(void)SendDebugMessageToAppleWatch:(NSString*)msg
{
    if(m_WatchMessageManager != nil)
    {
        [m_WatchMessageManager BroadcastDebugAlertMessage:msg];
    }
}

-(void)BroadcastContainerAppRunMode:(BOOL)bBackgroundMode
{
    if(m_WatchMessageManager != nil)
    {
        [m_WatchMessageManager BroadcastContainerAppRunMode:bBackgroundMode];
    }
}
@end
