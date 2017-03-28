//
//  NOMSpotViewController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSpotViewController.h"
#import "NOMSpotPhotoRadarView.h"
#import "NOMSpotGasStationView.h"
#import "NOMSpotParkingGroundView.h"
#import "NOMSpotSchoolZoneView.h"
#import "NOMSystemConstants.h"
#import "NOMGUILayout.h"

@interface NOMSpotViewController()
{
    NOMSpotPhotoRadarView*                      m_PhotoRadarConfigureView;
    NOMSpotGasStationView*                      m_GasStattionConfigureView;
    NOMSpotParkingGroundView*                   m_ParkingGroundConfigureView;
    NOMSpotSchoolZoneView*                      m_SchoolZoneConfigureView;
    
    NOMDocumentController*                      m_ParentController;
    
    NOMTrafficSpotRecord*                       m_CachedHandlingSpotData;
}
@end


@implementation NOMSpotViewController

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_PhotoRadarConfigureView = nil;
        m_GasStattionConfigureView = nil;
        m_ParkingGroundConfigureView = nil;
        m_SchoolZoneConfigureView = nil;
        m_ParentController = nil;
        m_CachedHandlingSpotData = nil;
    }
    
    return self;
}

-(void)AddNewSpotDetailForPosting:(int16_t)spotType withSubType:(int16_t)spotSubType
{
    m_CachedHandlingSpotData = nil;
    BOOL bCanShareOnTwitter = NO;//[m_ParentController CanShareOnTwitter];
    if(spotType == NOM_TRAFFICSPOT_PHOTORADAR && spotSubType == NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA)
    {
        if(m_PhotoRadarConfigureView != nil)
        {
            [m_PhotoRadarConfigureView Reset];
            [m_PhotoRadarConfigureView SetType:spotSubType];
            [m_PhotoRadarConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_PhotoRadarConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_PHOTORADAR && spotSubType == NOM_PHOTORADAR_TYPE_SPEEDCAMERA)
    {
        if(m_PhotoRadarConfigureView != nil)
        {
            [m_PhotoRadarConfigureView Reset];
            [m_PhotoRadarConfigureView SetType:spotSubType];
            [m_PhotoRadarConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_PhotoRadarConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_SCHOOLZONE)
    {
        if(m_SchoolZoneConfigureView != nil)
        {
            [m_SchoolZoneConfigureView Reset];
            [m_SchoolZoneConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_SchoolZoneConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_PLAYGROUND)
    {
        if(m_SchoolZoneConfigureView != nil)
        {
            [m_SchoolZoneConfigureView Reset];
            [m_SchoolZoneConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_SchoolZoneConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_PARKINGGROUND)
    {
        if(m_ParkingGroundConfigureView != nil)
        {
            [m_ParkingGroundConfigureView Reset];
            [m_ParkingGroundConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_ParkingGroundConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_GASSTATION)
    {
        if(m_GasStattionConfigureView != nil)
        {
            [m_GasStattionConfigureView Reset];
            [m_GasStattionConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_GasStattionConfigureView OpenView:YES];
        }
    }
}

-(void)UpdateSpotData:(NOMTrafficSpotRecord*)pSpot
{
    m_CachedHandlingSpotData = pSpot;
    if(pSpot == nil)
        return;
    
    int16_t spotType = m_CachedHandlingSpotData.m_Type;
    int16_t spotSubType = m_CachedHandlingSpotData.m_SubType;
    BOOL bCanShareOnTwitter = NO; //[m_ParentController CanShareOnTwitter];
    if(spotType == NOM_TRAFFICSPOT_PHOTORADAR && spotSubType <= NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA)
    {
        if(m_PhotoRadarConfigureView != nil)
        {
            [m_PhotoRadarConfigureView Reset];
            [m_PhotoRadarConfigureView SetType:spotSubType];
            [m_PhotoRadarConfigureView SetDirection:m_CachedHandlingSpotData.m_ThirdType];
            [m_PhotoRadarConfigureView SetSpeedCameraDeviceType:m_CachedHandlingSpotData.m_FourType];
            [m_PhotoRadarConfigureView SetAddress:m_CachedHandlingSpotData.m_SpotAddress];
            [m_PhotoRadarConfigureView SetFine:m_CachedHandlingSpotData.m_Price];
            [m_PhotoRadarConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_PhotoRadarConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_PHOTORADAR && spotSubType == NOM_PHOTORADAR_TYPE_SPEEDCAMERA)
    {
        if(m_PhotoRadarConfigureView != nil)
        {
            [m_PhotoRadarConfigureView Reset];
            [m_PhotoRadarConfigureView SetType:spotSubType];
            [m_PhotoRadarConfigureView SetDirection:m_CachedHandlingSpotData.m_ThirdType];
            [m_PhotoRadarConfigureView SetSpeedCameraDeviceType:m_CachedHandlingSpotData.m_FourType];
            [m_PhotoRadarConfigureView SetAddress:m_CachedHandlingSpotData.m_SpotAddress];
            [m_PhotoRadarConfigureView SetFine:m_CachedHandlingSpotData.m_Price];
            [m_PhotoRadarConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_PhotoRadarConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_SCHOOLZONE)
    {
        if(m_SchoolZoneConfigureView != nil)
        {
            [m_SchoolZoneConfigureView Reset];
            [m_SchoolZoneConfigureView SetAddress:pSpot.m_SpotAddress];
            [m_SchoolZoneConfigureView SetName:pSpot.m_SpotName];
            [m_SchoolZoneConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_SchoolZoneConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_PLAYGROUND)
    {
        if(m_SchoolZoneConfigureView != nil)
        {
            [m_SchoolZoneConfigureView Reset];
            [m_SchoolZoneConfigureView SetAddress:pSpot.m_SpotAddress];
            [m_SchoolZoneConfigureView SetName:pSpot.m_SpotName];
            [m_SchoolZoneConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_SchoolZoneConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_PARKINGGROUND)
    {
        if(m_ParkingGroundConfigureView != nil)
        {
            [m_ParkingGroundConfigureView Reset];
            [m_ParkingGroundConfigureView SetAddress:pSpot.m_SpotAddress];
            [m_ParkingGroundConfigureView SetName:pSpot.m_SpotName];
            [m_ParkingGroundConfigureView SetRate:pSpot.m_Price];
            [m_ParkingGroundConfigureView SetRateUnit:pSpot.m_PriceUnit];
            [m_ParkingGroundConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_ParkingGroundConfigureView OpenView:YES];
        }
    }
    else if(spotType == NOM_TRAFFICSPOT_GASSTATION)
    {
        if(m_GasStattionConfigureView != nil)
        {
            [m_GasStattionConfigureView Reset];
            [m_GasStattionConfigureView SetCarWashType:pSpot.m_SubType];
            [m_GasStattionConfigureView SetAddress:pSpot.m_SpotAddress];
            [m_GasStattionConfigureView SetName:pSpot.m_SpotName];
            [m_GasStattionConfigureView SetPrice:pSpot.m_Price];
            [m_GasStattionConfigureView SetPriceUnit:pSpot.m_PriceUnit];
            [m_GasStattionConfigureView SetTwitterEnabling:bCanShareOnTwitter];
            [m_GasStattionConfigureView OpenView:YES];
        }
    }
}


-(void)RegisterParent:(NOMDocumentController*)controller
{
    m_ParentController = controller;
}

-(void)InitializeSpotViews:(UIView*)pMainView
{
    if(pMainView == nil)
        return;
    
    CGFloat sy = [NOMGUILayout GetMapViewOriginY];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGRect frame = CGRectMake(0, sy, w, h);
    
    m_PhotoRadarConfigureView = [[NOMSpotPhotoRadarView alloc] initWithFrame:frame];
    [pMainView addSubview:m_PhotoRadarConfigureView];
    [m_PhotoRadarConfigureView CloseView:NO];
     
    m_GasStattionConfigureView = [[NOMSpotGasStationView alloc] initWithFrame:frame];
    [pMainView addSubview:m_GasStattionConfigureView];
    [m_GasStattionConfigureView CloseView:NO];
     
    m_ParkingGroundConfigureView = [[NOMSpotParkingGroundView alloc] initWithFrame:frame];
    [pMainView addSubview:m_ParkingGroundConfigureView];
    [m_ParkingGroundConfigureView CloseView:NO];
     
    m_SchoolZoneConfigureView = [[NOMSpotSchoolZoneView alloc] initWithFrame:frame];
    [pMainView addSubview:m_SchoolZoneConfigureView];
    [m_SchoolZoneConfigureView CloseView:NO];
    [m_PhotoRadarConfigureView RegisterController:self];
    [m_GasStattionConfigureView RegisterController:self];
    [m_ParkingGroundConfigureView RegisterController:self];
    [m_SchoolZoneConfigureView RegisterController:self];
}

-(void)UpdateSpotViewLayout
{
    CGFloat sy = [NOMGUILayout GetMapViewOriginY];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGRect frame = CGRectMake(0, sy, w, h);
    
    if(m_PhotoRadarConfigureView != nil)
    {
        [m_PhotoRadarConfigureView setFrame:frame];
        [m_PhotoRadarConfigureView UpdateLayout];
    }
    
    if(m_GasStattionConfigureView != nil)
    {
        [m_GasStattionConfigureView setFrame:frame];
        [m_GasStattionConfigureView UpdateLayout];
    }
    
    if(m_ParkingGroundConfigureView != nil)
    {
        [m_ParkingGroundConfigureView setFrame:frame];
        [m_ParkingGroundConfigureView UpdateLayout];
    }
    
    if(m_SchoolZoneConfigureView != nil)
    {
        [m_SchoolZoneConfigureView setFrame:frame];
        [m_SchoolZoneConfigureView UpdateLayout];
    }
}

-(void)HandleNewPhotoRadarPostingInformation:(NOMSpotPhotoRadarView*)pPhotoRadarView
{
    if(pPhotoRadarView != nil)
    {
        int16_t nPhotoCameraType = [pPhotoRadarView GetType];
        int16_t nCamDirection = [pPhotoRadarView GetDirection];
        int16_t nSCDeviceType = [pPhotoRadarView GetSpeedCameraDeviceType];
        NSString* szAddress = [pPhotoRadarView GetAddress];
        double dFine = [pPhotoRadarView GetFine];
        BOOL    bShareOnTwitter = [pPhotoRadarView AllowTwitterShare];
        [m_ParentController PostNewPhotoRadarInformation:nPhotoCameraType withDirection:nCamDirection withSCType:nSCDeviceType withAddress:szAddress withFine:dFine shareOnTwitter:bShareOnTwitter];
    }
}

-(void)HandleNewGasStationPostingInformation:(NOMSpotGasStationView*)pGasStationView
{
    if(pGasStationView != nil)
    {
        int16_t nCarWashType = [pGasStationView GetCarWashType];
        NSString* szAddress = [pGasStationView GetAddress];
        NSString* szName = [pGasStationView GetName];
        double dPrice = [pGasStationView GetPrice];
        int16_t nPriceUnit = [pGasStationView GetPriceUnit];
        BOOL    bShareOnTwitter = [pGasStationView AllowTwitterShare];
        [m_ParentController PostNewGasStationInformation:szName withAddress:szAddress withCarWash:nCarWashType withPrice:dPrice withPriceUnit:nPriceUnit shareOnTwitter:bShareOnTwitter];
    }
}

-(void)HandleNewParkingGroundPostingInformation:(NOMSpotParkingGroundView*)pParkingView
{
    if(pParkingView != nil)
    {
        NSString* szAddress = [pParkingView GetAddress];
        NSString* szName = [pParkingView GetName];
        double dRate = [pParkingView GetRate];
        int16_t nRateUnit = [pParkingView GetRateUnit];
        BOOL    bShareOnTwitter = [pParkingView AllowTwitterShare];
        [m_ParentController PostNewParkingGroundInformation:szName withAddress:szAddress withRate:dRate withRateUnit:nRateUnit shareOnTwitter:bShareOnTwitter];
    }
}

-(void)HandleNewSchoolZoneOrPlaygroundZonePostingInformation:(NOMSpotSchoolZoneView*)pSchoolView
{
    if(pSchoolView != nil)
    {
        NSString* szAddress = [pSchoolView GetAddress];
        NSString* szName = [pSchoolView GetName];
        BOOL    bShareOnTwitter = [pSchoolView AllowTwitterShare];
        [m_ParentController PostNewSchoolZoneOrPlaygroundZoneInformation:szName withAddress:szAddress shareOnTwitter:bShareOnTwitter];
    }
}

-(void)HandlePhotoRaderInformation:(NOMSpotPhotoRadarView*)pPhotoRadarView
{
    if(m_CachedHandlingSpotData == nil)
    {
        [self HandleNewPhotoRadarPostingInformation:pPhotoRadarView];
    }
    else
    {
        if(pPhotoRadarView != nil)
        {
            BOOL    bShareOnTwitter = [pPhotoRadarView AllowTwitterShare];
            m_CachedHandlingSpotData.m_SubType = [m_PhotoRadarConfigureView GetType];
            m_CachedHandlingSpotData.m_ThirdType = [m_PhotoRadarConfigureView GetDirection];
            m_CachedHandlingSpotData.m_FourType = [m_PhotoRadarConfigureView GetSpeedCameraDeviceType];
            m_CachedHandlingSpotData.m_SpotAddress = [m_PhotoRadarConfigureView GetAddress];
            m_CachedHandlingSpotData.m_Price = [m_PhotoRadarConfigureView GetFine];
            [m_ParentController PublishSpot:m_CachedHandlingSpotData shareOnTwitter:bShareOnTwitter];
        }
    }
}

-(void)HandleGasStationInformation:(NOMSpotGasStationView*)pGasStationView
{
    if(m_CachedHandlingSpotData == nil)
    {
        [self HandleNewGasStationPostingInformation:pGasStationView];
    }
    else
    {
        if(pGasStationView != nil)
        {
            BOOL    bShareOnTwitter = [pGasStationView AllowTwitterShare];
            m_CachedHandlingSpotData.m_SubType = [m_GasStattionConfigureView GetCarWashType];
            m_CachedHandlingSpotData.m_SpotAddress = [m_GasStattionConfigureView GetAddress];
            m_CachedHandlingSpotData.m_SpotName = [m_GasStattionConfigureView GetName];
            m_CachedHandlingSpotData.m_Price = [m_GasStattionConfigureView GetPrice];
            m_CachedHandlingSpotData.m_PriceUnit = [m_GasStattionConfigureView GetPriceUnit];
            [m_ParentController PublishSpot:m_CachedHandlingSpotData shareOnTwitter:bShareOnTwitter];
        }
    }
}

-(void)HandleParkingGroundInformation:(NOMSpotParkingGroundView*)pParkingView
{
    if(m_CachedHandlingSpotData == nil)
    {
        [self HandleNewParkingGroundPostingInformation:pParkingView];
    }
    else
    {
        if(pParkingView != nil)
        {
            BOOL    bShareOnTwitter = [pParkingView AllowTwitterShare];
            m_CachedHandlingSpotData.m_SpotAddress = [m_ParkingGroundConfigureView GetAddress];
            m_CachedHandlingSpotData.m_SpotName = [m_ParkingGroundConfigureView GetName];
            m_CachedHandlingSpotData.m_Price = [m_ParkingGroundConfigureView GetRate];
            m_CachedHandlingSpotData.m_PriceUnit = [m_ParkingGroundConfigureView GetRateUnit];
            [m_ParentController PublishSpot:m_CachedHandlingSpotData shareOnTwitter:bShareOnTwitter];
        }
    }
}

-(void)HandleSchoolZoneInformation:(NOMSpotSchoolZoneView*)pSchoolView
{
    if(m_CachedHandlingSpotData == nil)
    {
        [self HandleNewSchoolZoneOrPlaygroundZonePostingInformation:pSchoolView];
    }
    else
    {
        if(pSchoolView != nil)
        {
            BOOL    bShareOnTwitter = [pSchoolView AllowTwitterShare];
            m_CachedHandlingSpotData.m_SpotAddress = [m_SchoolZoneConfigureView GetAddress];
            m_CachedHandlingSpotData.m_SpotName = [m_SchoolZoneConfigureView GetName];
            [m_ParentController PublishSpot:m_CachedHandlingSpotData shareOnTwitter:bShareOnTwitter];
        }
    }
}

-(void)OnSpotUIClosed:(id)spotUI withResult:(BOOL)bOK
{
    if(bOK == YES && spotUI != nil)
    {
        if([spotUI isKindOfClass:[NOMSpotPhotoRadarView class]] == YES)
        {
            NOMSpotPhotoRadarView* pPhotoRadarView = (NOMSpotPhotoRadarView*)spotUI;
            [self HandlePhotoRaderInformation:pPhotoRadarView];
        }
        else if([spotUI isKindOfClass:[NOMSpotGasStationView class]] == YES)
        {
            NOMSpotGasStationView* pGasStationView = (NOMSpotGasStationView*)spotUI;
            [self HandleGasStationInformation:pGasStationView];
        }
        else if([spotUI isKindOfClass:[NOMSpotParkingGroundView class]] == YES)
        {
            NOMSpotParkingGroundView* pParkingView = (NOMSpotParkingGroundView*)spotUI;
            [self HandleParkingGroundInformation:pParkingView];
        }
        else if([spotUI isKindOfClass:[NOMSpotSchoolZoneView class]] == YES)
        {
            NOMSpotSchoolZoneView* pSchoolView = (NOMSpotSchoolZoneView*)spotUI;
            [self HandleSchoolZoneInformation:pSchoolView];
        }
    }
    else
    {
        [m_ParentController ResetUserStatus];
    }
}


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

@end
