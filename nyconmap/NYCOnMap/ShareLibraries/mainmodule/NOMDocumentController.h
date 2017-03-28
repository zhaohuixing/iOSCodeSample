//
//  NOMDocumentController.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-23.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "IMapObjectController.h"
#import "NOMPublishController.h"
#import "NOMBrowseController.h"
#import "NOMPostLocationSelector.h"
#import "NOMPostPreActionSelector.h"
#import "NOMLocationController.h"
#import "NOMTrafficSpotRecord.h"
#import "IMainViewDelegate.h"
#import "ISpotUIInterfaces.h"
#import "INOMCustomMapViewPinItemDelegate.h"
#import "INOMSocialServiceInterface.h"
#import "NOMLocationServiceOperator.h"
#import "INOMTimingServiceRecipient.h"
#import "NOMQueryAnnotationDataDelegate.h"
#import "NOMWatchCommunicationManager.h"

@interface NOMDocumentController : NSObject<NOMPublishControllerDelegate, NOMBrowseControllerDelegate, NOMPostLocationSelectorDelegate, NOMLocationControllerDelegate, NOMPostPreActionSelectorDelegate, INOMSocialAccountManagerDelegate, NOMLocationServiceOperatorDelegate, INOMTimingServiceRecipient, NOMQueryAnnotationDataDelegate>

-(id<IMapObjectController>)GetMapObjectController;
-(void)SetMainViewObject:(id<IMainViewDelegate>)mainview;
-(void)OnMenuEvent:(int)nMenuID;
-(void)OnTouchBegin:(CGPoint)touchPoint;
-(void)OnTouchMoved:(CGPoint)touchPoint;
-(void)OnTouchEnded:(CGPoint)touchPoint;
-(void)OnTouchCancelled:(CGPoint)touchPoint;
-(void)HandleMapViewTouchEvent:(CLLocationCoordinate2D)touchPoint;
-(void)ShowPostPinAnnotation:(CLLocationCoordinate2D)location;

-(void)InitializeSettingMenuEvent;
-(void)HandleLowMemoryState;

-(void)SetUserMode:(int)nMode withCategory:(int)nMainCate withSubCategory:(int)nSubCate withThirdCategory:(int)nThirdCate;
-(void)SetUserModeSpotAction:(int)nMode withSpotType:(int16_t)nSpotType withSpotDS:(int32_t)nSpotDS;

-(void)SetCachedSocialNewsContainer:(id<INOMCachedSoicalNewsContainer>)container;


-(void)HookupPublishTrafficTopic;
-(void)HookupPublishTaxiTopic;

-(NSString*)GetTrafficMessageQueueName;

-(void)InitializeTimerService;
-(void)InitializeMobilePushEndPointARN;
-(void)InitializeMobilePushEndPointTrafficARN;
-(void)InitializeMobilePushEndPointTaxiARN;

-(void)ShowMyCurrentLocation;
-(void)MapViewVisualRegionChanged;
-(void)LoadingMapFinished;
-(void)MapRenderingFinished;
-(void)LoadCurrentRegionTrafficSpots;
-(void)StartHandleSearchEvent;
-(void)StartHandlePostEvent;
-(void)HandleLocationServiceDisable;
-(void)EnableLocationService;

-(void)ClearMapPostMarkFlags;

-(void)CloseCallout;

-(void)SetUserModeCachedAddress:(NSString*)szStreet city:(NSString*)szCity state:(NSString*)szState zipCode:(NSString*)szZipCode country:(NSString*)szCountry countryKey:(NSString*)szCountryKey;

-(void)ResetUserStatus;
-(void)StartUpdateSpotData:(NOMTrafficSpotRecord*)pSpot;

-(void)InitializeSpotViewController:(UIView*)pMainView;
-(void)UpdateSpotViewControllerLayout;
-(void)InitializePostViewController:(UIView*)pMainView;
-(void)UpdatePostViewControllerLayout;
-(void)InitializeReadViewController:(UIView*)pMainView;
-(void)UpdateReadViewControllerLayout;
-(id<INOMCustomMapViewPinItemDelegate>)GetCustomMapViewPinItemDelegate;


-(void)PostNewPhotoRadarInformation:(int16_t)nPhotoCameraType withDirection:(int16_t)nCamDirection withSCType:(int16_t)nSCDeviceType withAddress:(NSString*)szAddress withFine:(double)dFine shareOnTwitter:(BOOL)bShareOnTwitter;
-(void)PostNewGasStationInformation:(NSString*)szName withAddress:(NSString*)szAddress withCarWash:(int16_t)nCarWashType withPrice:(double)dPrice withPriceUnit:(int16_t)nPriceUnit shareOnTwitter:(BOOL)bShareOnTwitter;
-(void)PostNewParkingGroundInformation:(NSString*)szName withAddress:(NSString*)szAddress withRate:(double)dRate withRateUnit:(int16_t)nRateUnit shareOnTwitter:(BOOL)bShareOnTwitter;
-(void)PostNewSchoolZoneOrPlaygroundZoneInformation:(NSString*)szName withAddress:(NSString*)szAddress shareOnTwitter:(BOOL)bShareOnTwitter;
-(void)PublishSpot:(NOMTrafficSpotRecord*)pRecord shareOnTwitter:(BOOL)bShareOnTwitter;

-(void)StartPostNews:(NSString*)szSubject
            withPost:(NSString*)szPost
         withKeyWord:(NSString*)szKeyWord
       withCopyRight:(NSString*)szCopyRight
             withKML:(NSString*)szKML
           withImage:(UIImage*)pImage
      shareOnTwitter:(BOOL)bShareOnTwitter;

-(void)StartNewsDirectPosting;
-(void)StartDirectPosting;

-(NOMNewsMetaDataRecord*)GetNews:(NSString*)pNewsID;
-(NOMNewsMetaDataRecord*)GetNewsRecord:(NSString*)pNewsID;
-(NOMNewsMetaDataRecord*)GetCachedSocialNews:(NSString*)pNewsID;

-(double)GetCurrentMapVisibleRegionMinSpan;
-(BOOL)CanShareOnTwitter;

-(BOOL)HandleRemoteNotificationData:(NSDictionary *)userInfo;

-(BOOL)IsLocationServiceAuthorization;

-(BOOL)IsCloudServiceInitialized;
-(BOOL)IsCloudInitializationPaused;
-(void)SetCloudInitializationPause:(BOOL)bPause;
-(void)InitializeCloudService;
-(void)ApplicationBecomeActive;
-(void)ApplicationBecomeInActive;

//
//NOMBrowseControllerDelegate metods
//
-(void)TrafficMessageQueueInitialized:(BOOL)bNeedSubcribe;
-(void)HandleSearchTrafficSpotList:(NSArray*)spotList withSpotType:(int16_t)nType;
-(void)ProcessNoLocationSocialNewsData:(NOMNewsMetaDataRecord*)pNewsData;
-(void)PinNewsDataOnMap:(NOMNewsMetaDataRecord*)pNewsData;

//
//Apple Watch handling code
//
-(NOMWatchCommunicationManager*)GetWatchCommunicationManager;
-(void)ProcessWatchSearchRequest:(int16_t)nChoice option:(int16_t)nOption;
-(void)ProcessWatchPostRequest:(int16_t)nChoice option:(int16_t)nOption latitude:(double)dLatiude longitude:(double)dLongitude;

-(void)HandleSoicalSearchToWatch:(NSArray*)dataArray;

-(void)SendTrafficMessagesToWatch:(NSArray*)rawDataList;
-(void)SendTaxiMessagesToWatch:(NSArray*)rawDataList;

-(void)DoGeneralSearchForWatch;

//
//Apple Watch opening event
//
-(void)HandleAppleWatchOpenRequest:(NSMutableDictionary*)appData;
-(void)HandleAppleWatchOpenRequestForSearch:(NSMutableDictionary*)appData withChoice:(int16_t)nChoice whithOption:(int16_t)nOption;
-(void)HandleAppleWatchOpenRequestForCurrentLocation:(NSMutableDictionary*)appData;
-(void)HandleAppleWatchOpenRequestForPost:(NSMutableDictionary*)appData withChoice:(int16_t)nChoice whithOption:(int16_t)nOption atLatitude:(double)dLatiude atLongitude:(double)dLongitude;

-(void)HandleAppleWatchOpenRequestForGeneralSearch;

-(void)SendDebugMessageToAppleWatch:(NSString*)msg;
-(void)BroadcastContainerAppRunMode:(BOOL)bBackgroundMode;


@end
