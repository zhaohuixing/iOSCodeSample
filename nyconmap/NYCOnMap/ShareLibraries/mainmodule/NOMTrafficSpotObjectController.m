//
//  NOMTrafficSpotObjectController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficSpotObjectController.h"
#import "NOMTrafficSpotAnnotation.h"
#import "NOMSystemConstants.h"
#import "NOMAppWatchConstants.h"

@interface NOMTrafficSpotObjectController()
{
@private
    id<IMapViewDelegate>            m_MapView;
    
    NSMutableArray*                 m_RedLightCameraSpotAnnotations;
    NSMutableArray*                 m_SpeedCameraSpotAnnotations;
    NSMutableArray*                 m_SchoolZoneSpotAnnotations;
    NSMutableArray*                 m_PlaygroundSpotAnnotations;
    NSMutableArray*                 m_GasStationAnnotations;
    NSMutableArray*                 m_ParkingAnnotations;
    
    //NOMWatchCommunicationManager*       m_WatchMessager;
}

@end

@implementation NOMTrafficSpotObjectController

//
//Collect Data to Apple Watch open reqest
//
-(void)CollectSpotDataForAppleWatch:(NSMutableDictionary*)collectionSet
{
    //Gas station list
    if(0 < m_GasStationAnnotations.count)
    {
        NSMutableArray* gasArray = [[NSMutableArray alloc] init];
        NSString* szGasKey = EMSG_KEY_GASSTATIONLIST;
        for(int i = 0; i < m_GasStationAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_GasStationAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil && 0 < pAnnotation.m_NOMTrafficSpot.m_SpotID.length)
            {
                NSDictionary* pData = [pAnnotation.m_NOMTrafficSpot CreateWatchAnnotationKeyValueBlock];
                [gasArray addObject:pData];
            }
        }
        if(0 < gasArray.count)
        {
            [collectionSet setValue:gasArray forKey:szGasKey];
        }
    }
    
    //Photo Radar list
    if(0 < m_RedLightCameraSpotAnnotations.count || 0 < m_SpeedCameraSpotAnnotations.count)
    {
        NSMutableArray* cameraArray = [[NSMutableArray alloc] init];
        NSString* szCameraKey = EMSG_KEY_PHOTORADARLIST;

        for(int i = 0; i < m_RedLightCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_RedLightCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil && 0 < pAnnotation.m_NOMTrafficSpot.m_SpotID.length)
            {
                NSDictionary* pData = [pAnnotation.m_NOMTrafficSpot CreateWatchAnnotationKeyValueBlock];
                [cameraArray addObject:pData];
            }
        }
        for(int i = 0; i < m_SpeedCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SpeedCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil && 0 < pAnnotation.m_NOMTrafficSpot.m_SpotID.length)
            {
                NSDictionary* pData = [pAnnotation.m_NOMTrafficSpot CreateWatchAnnotationKeyValueBlock];
                [cameraArray addObject:pData];
            }
        }
        if(0 < cameraArray.count)
        {
            [collectionSet setValue:cameraArray forKey:szCameraKey];
        }
    }
    
    //School list
    if(0 < m_SchoolZoneSpotAnnotations.count)
    {
        NSMutableArray* schoolArray = [[NSMutableArray alloc] init];
        NSString* szSchoolKey = EMSG_KEY_SCHOOLZONELIST;
        
        for(int i = 0; i < m_SchoolZoneSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SchoolZoneSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil && 0 < pAnnotation.m_NOMTrafficSpot.m_SpotID.length)
            {
                NSDictionary* pData = [pAnnotation.m_NOMTrafficSpot CreateWatchAnnotationKeyValueBlock];
                [schoolArray addObject:pData];
            }
        }
        if(0 < schoolArray.count)
        {
            [collectionSet setValue:schoolArray forKey:szSchoolKey];
        }
    }

    //Play ground list
    if(0 < m_PlaygroundSpotAnnotations.count)
    {
        NSMutableArray* playgroundArray = [[NSMutableArray alloc] init];
        NSString* szPlaygroundKey = EMSG_KEY_PLAYGROUNDLIST;
        for(int i = 0; i < m_PlaygroundSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_PlaygroundSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil && 0 < pAnnotation.m_NOMTrafficSpot.m_SpotID.length)
            {
                NSDictionary* pData = [pAnnotation.m_NOMTrafficSpot CreateWatchAnnotationKeyValueBlock];
                [playgroundArray addObject:pData];
            }
        }
        if(0 < playgroundArray.count)
        {
            [collectionSet setValue:playgroundArray forKey:szPlaygroundKey];
        }
    }

    //Parking ground
    if(0 < m_ParkingAnnotations.count)
    {
        NSMutableArray* parkingArray = [[NSMutableArray alloc] init];
        NSString* szParkingKey = EMSG_KEY_PARKINGGROUNDLIST;
        for(int i = 0; i < m_ParkingAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_ParkingAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil && 0 < pAnnotation.m_NOMTrafficSpot.m_SpotID.length)
            {
                NSDictionary* pData = [pAnnotation.m_NOMTrafficSpot CreateWatchAnnotationKeyValueBlock];
                [parkingArray addObject:pData];
            }
        }
        if(0 < parkingArray.count)
        {
            [collectionSet setValue:parkingArray forKey:szParkingKey];
        }
    }
}

-(BOOL)CanHandleAppleWatchRequest
{
    if(0 < m_GasStationAnnotations.count)
    {
        return YES;
    }
    
    //Photo Radar list
    if(0 < m_RedLightCameraSpotAnnotations.count || 0 < m_SpeedCameraSpotAnnotations.count)
    {
        return YES;
    }
    
    //School list
    if(0 < m_SchoolZoneSpotAnnotations.count)
    {
        return YES;
    }
    
    //Play ground list
    if(0 < m_PlaygroundSpotAnnotations.count)
    {
        return YES;
    }
    
    //Parking ground
    if(0 < m_ParkingAnnotations.count)
    {
        return YES;
    }
    return NO;
}

-(void)LoadExistedAnnotations
{
    if(0 < m_GasStationAnnotations.count)
    {
        for(int i = 0; i < m_GasStationAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_GasStationAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [self AddTrafficAnnotation:pAnnotation];
            }
        }
    }
    
    if(0 < m_RedLightCameraSpotAnnotations.count)
    {
        for(int i = 0; i < m_RedLightCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_RedLightCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [self AddTrafficAnnotation:pAnnotation];
            }
        }
    }
    
    if(0 < m_SpeedCameraSpotAnnotations.count)
    {
        for(int i = 0; i < m_SpeedCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SpeedCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [self AddTrafficAnnotation:pAnnotation];
            }
        }
    }
    
    if(0 < m_SchoolZoneSpotAnnotations.count)
    {
        for(int i = 0; i < m_SchoolZoneSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SchoolZoneSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [self AddTrafficAnnotation:pAnnotation];
            }
        }
    }
    
    if(0 < m_PlaygroundSpotAnnotations.count)
    {
        for(int i = 0; i < m_PlaygroundSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_PlaygroundSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [self AddTrafficAnnotation:pAnnotation];
            }
        }
    }
    
    if(0 < m_ParkingAnnotations.count)
    {
        for(int i = 0; i < m_ParkingAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_ParkingAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [self AddTrafficAnnotation:pAnnotation];
            }
        }
    }
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        //m_WatchMessager = nil;
        m_MapView = nil;
        m_RedLightCameraSpotAnnotations = [[NSMutableArray alloc] init];
        m_SpeedCameraSpotAnnotations = [[NSMutableArray alloc] init];
        m_SchoolZoneSpotAnnotations = [[NSMutableArray alloc] init];
        m_PlaygroundSpotAnnotations = [[NSMutableArray alloc] init];
        m_GasStationAnnotations = [[NSMutableArray alloc] init];
        m_ParkingAnnotations = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)RegisterMapView:(id<IMapViewDelegate>)mapView
{
    m_MapView = mapView;
    [self LoadExistedAnnotations];
}

-(NOMTrafficSpotRecord*)GetSpotRecord:(NSString*)spotID
{
    NOMTrafficSpotRecord* pRecord = nil;
    
    if(0 < m_GasStationAnnotations.count)
    {
        for(int i = 0; i < m_GasStationAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_GasStationAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return pAnnotation.m_NOMTrafficSpot;
                }
            }
        }
    }
    
    if(0 < m_RedLightCameraSpotAnnotations.count)
    {
        for(int i = 0; i < m_RedLightCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_RedLightCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return pAnnotation.m_NOMTrafficSpot;
                }
            }
        }
    }
    
    if(0 < m_SpeedCameraSpotAnnotations.count)
    {
        for(int i = 0; i < m_SpeedCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SpeedCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return pAnnotation.m_NOMTrafficSpot;
                }
            }
        }
    }
    
    if(0 < m_SchoolZoneSpotAnnotations.count)
    {
        for(int i = 0; i < m_SchoolZoneSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SchoolZoneSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return pAnnotation.m_NOMTrafficSpot;
                }
            }
        }
    }
    
    if(0 < m_PlaygroundSpotAnnotations.count)
    {
        for(int i = 0; i < m_PlaygroundSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_PlaygroundSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return pAnnotation.m_NOMTrafficSpot;
                }
            }
        }
    }
    
    if(0 < m_ParkingAnnotations.count)
    {
        for(int i = 0; i < m_ParkingAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_ParkingAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return pAnnotation.m_NOMTrafficSpot;
                }
            }
        }
    }
    
    return pRecord;
}

-(BOOL)IsTrafficSpotExisted:(NSString*)spotID
{
    BOOL bRet = NO;
    
    if(0 < m_GasStationAnnotations.count)
    {
        for(int i = 0; i < m_GasStationAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_GasStationAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return YES;
                }
            }
        }
    }
    
    if(0 < m_RedLightCameraSpotAnnotations.count)
    {
        for(int i = 0; i < m_RedLightCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_RedLightCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return YES;
                }
            }
        }
    }
    
    if(0 < m_SpeedCameraSpotAnnotations.count)
    {
        for(int i = 0; i < m_SpeedCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SpeedCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return YES;
                }
            }
        }
    }
    
    if(0 < m_SchoolZoneSpotAnnotations.count)
    {
        for(int i = 0; i < m_SchoolZoneSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SchoolZoneSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return YES;
                }
            }
        }
    }
    
    if(0 < m_PlaygroundSpotAnnotations.count)
    {
        for(int i = 0; i < m_PlaygroundSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_PlaygroundSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return YES;
                }
            }
        }
    }
    
    if(0 < m_ParkingAnnotations.count)
    {
        for(int i = 0; i < m_ParkingAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_ParkingAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMTrafficSpot != nil && pAnnotation.m_NOMTrafficSpot.m_SpotID != nil)
            {
                if([pAnnotation.m_NOMTrafficSpot.m_SpotID isEqualToString:spotID] == YES)
                {
                    return YES;
                }
            }
        }
    }
    
    return bRet;
}

-(void)UpdateExistedSpotData:(NOMTrafficSpotRecord*)spot
{
    if(spot == nil)
        return;
    
    NOMTrafficSpotRecord* pExistSpot = [self GetSpotRecord:spot.m_SpotID];
    if(pExistSpot == nil || pExistSpot == spot)
        return;
    
    pExistSpot.m_SpotID = spot.m_SpotID;
    pExistSpot.m_SpotName = spot.m_SpotName;
    pExistSpot.m_SpotAddress = spot.m_SpotAddress;
    pExistSpot.m_SpotLatitude = spot.m_SpotLatitude;
    pExistSpot.m_SpotLongitude = spot.m_SpotLongitude;
    pExistSpot.m_Type = spot.m_Type;
    pExistSpot.m_SubType = spot.m_SubType;
    pExistSpot.m_ThirdType = spot.m_ThirdType;
    pExistSpot.m_FourType = spot.m_FourType;
    pExistSpot.m_Price = spot.m_Price;
    pExistSpot.m_PriceTime = spot.m_PriceTime;
    pExistSpot.m_PriceUnit = spot.m_PriceUnit;
    
    if(m_MapView != nil)
    {
        [m_MapView UpdateAnnotationViewData];
    }
}

-(void)AddTrafficAnnotation:(NOMTrafficSpotAnnotation*)pAnnotation
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(AddTrafficAnnotation:) withObject:pAnnotation waitUntilDone:NO];
        return;
    }
    
    if(m_MapView != nil)
    {
        [m_MapView AddAnnotation:pAnnotation];
    }
}

/*
-(void)BroadcastTrafficSpotToWatch:(NOMTrafficSpotRecord*)spot
{
    if(spot != nil && (spot.m_SpotID != nil && 0 < spot.m_SpotID.length) && m_WatchMessager != nil)
    {
        NOMWatchMapAnnotation* pAnnotation = [spot CreateWatchAnnotation];
        [m_WatchMessager BroadcastAddAnnotation:pAnnotation];
    }
}
*/

-(void)HandleTrafficSpotData:(NOMTrafficSpotRecord*)spot
{
    if(spot != nil)
    {
//        [self BroadcastTrafficSpotToWatch:spot];
        
        if([self IsTrafficSpotExisted:spot.m_SpotID] == YES)
        {
            [self UpdateExistedSpotData:spot];
            return;
        }
        
        NOMTrafficSpotAnnotation* pAnnotation = [[NOMTrafficSpotAnnotation alloc] init];
        [pAnnotation AddData:spot];
        if(spot.m_Type == NOM_TRAFFICSPOT_GASSTATION)
        {
            int index = (int)m_GasStationAnnotations.count;
            [pAnnotation SetIndex:index];
            [m_GasStationAnnotations addObject:pAnnotation];
        }
        else if(spot.m_Type == NOM_TRAFFICSPOT_PHOTORADAR)
        {
            if(spot.m_SubType == NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA)
            {
                int index = (int)m_RedLightCameraSpotAnnotations.count;
                [pAnnotation SetIndex:index];
                [m_RedLightCameraSpotAnnotations addObject:pAnnotation];
            }
            else
            {
                int index = (int)m_SpeedCameraSpotAnnotations.count;
                [pAnnotation SetIndex:index];
                [m_SpeedCameraSpotAnnotations addObject:pAnnotation];
            }
        }
        else if(spot.m_Type == NOM_TRAFFICSPOT_SCHOOLZONE)
        {
            int index = (int)m_SchoolZoneSpotAnnotations.count;
            [pAnnotation SetIndex:index];
            [m_SchoolZoneSpotAnnotations addObject:pAnnotation];
        }
        else if(spot.m_Type == NOM_TRAFFICSPOT_PLAYGROUND)
        {
            int index = (int)m_PlaygroundSpotAnnotations.count;
            [pAnnotation SetIndex:index];
            [m_PlaygroundSpotAnnotations addObject:pAnnotation];
        }
        else if(spot.m_Type == NOM_TRAFFICSPOT_PARKINGGROUND)
        {
            int index = (int)m_ParkingAnnotations.count;
            [pAnnotation SetIndex:index];
            [m_ParkingAnnotations addObject:pAnnotation];
        }
        [self AddTrafficAnnotation:pAnnotation];
    }
}

-(void)HandleSearchTrafficSpotList:(NSArray*)spotList
{
    if(spotList != nil && 0 < spotList.count)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            for(int i = 0; i < spotList.count; ++i)
            {
                if([[spotList objectAtIndex:i] isKindOfClass:[NOMTrafficSpotRecord class]] == YES)
                {
                    NOMTrafficSpotRecord* pSpotRecord = (NOMTrafficSpotRecord*)[spotList objectAtIndex:i];
                    [self HandleTrafficSpotData:pSpotRecord];
                }
            }
        });
    }
}

-(void)RemoveRedlightCameraSpotFromMap
{
    if(m_MapView != nil)
    {
        [m_MapView RemoveAnnotations:m_RedLightCameraSpotAnnotations];
    }
    [m_RedLightCameraSpotAnnotations removeAllObjects];
}

-(void)RemoveSpeedCameraSpotFromMap
{
    if(m_MapView != nil)
    {
        [m_MapView RemoveAnnotations:m_SpeedCameraSpotAnnotations];
    }
    [m_SpeedCameraSpotAnnotations removeAllObjects];
}

-(void)RemoveAllPhotoRadarSpotsFromMap
{
    [self RemoveRedlightCameraSpotFromMap];
    [self RemoveSpeedCameraSpotFromMap];
}

-(void)RemoveSchoolZoneSpotFromMap
{
    if(m_MapView != nil)
    {
        [m_MapView RemoveAnnotations:m_SchoolZoneSpotAnnotations];
    }
    [m_SchoolZoneSpotAnnotations removeAllObjects];
}

-(void)RemovePlayGroundSpotFromMap
{
    if(m_MapView != nil)
    {
        [m_MapView RemoveAnnotations:m_PlaygroundSpotAnnotations];
    }
    [m_PlaygroundSpotAnnotations removeAllObjects];
}

-(void)RemoveAllSpeedLimitSpotsFromMap
{
    [self RemoveAllPhotoRadarSpotsFromMap];
    [self RemoveSchoolZoneSpotFromMap];
    [self RemovePlayGroundSpotFromMap];
}

-(void)RemoveGasStationSpotFromMap
{
    if(m_MapView != nil)
    {
        [m_MapView RemoveAnnotations:m_GasStationAnnotations];
    }
    [m_GasStationAnnotations removeAllObjects];
}

-(void)RemoveParkingGroundSpotFromMap
{
    if(m_MapView != nil)
    {
        [m_MapView RemoveAnnotations:m_ParkingAnnotations];
    }
    [m_ParkingAnnotations removeAllObjects];
}

-(void)RemoveAllTrafficSpotFromMap
{
    [self RemoveAllSpeedLimitSpotsFromMap];
    [self RemoveGasStationSpotFromMap];
    [self RemoveParkingGroundSpotFromMap];
}

-(void)DrawAnnotions
{
    if(0 < m_GasStationAnnotations.count)
    {
        for(int i = 0; i < m_GasStationAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_GasStationAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [pAnnotation DrawAnnotationView];
            }
        }
    }
    
    if(0 < m_RedLightCameraSpotAnnotations.count)
    {
        for(int i = 0; i < m_RedLightCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_RedLightCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [pAnnotation DrawAnnotationView];
            }
        }
    }
    
    if(0 < m_SpeedCameraSpotAnnotations.count)
    {
        for(int i = 0; i < m_SpeedCameraSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SpeedCameraSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [pAnnotation DrawAnnotationView];
            }
        }
    }
    
    if(0 < m_SchoolZoneSpotAnnotations.count)
    {
        for(int i = 0; i < m_SchoolZoneSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_SchoolZoneSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [pAnnotation DrawAnnotationView];
            }
        }
    }
    
    if(0 < m_PlaygroundSpotAnnotations.count)
    {
        for(int i = 0; i < m_PlaygroundSpotAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_PlaygroundSpotAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [pAnnotation DrawAnnotationView];
            }
        }
    }
    
    if(0 < m_ParkingAnnotations.count)
    {
        for(int i = 0; i < m_ParkingAnnotations.count; ++i)
        {
            NOMTrafficSpotAnnotation* pAnnotation = (NOMTrafficSpotAnnotation*)[m_ParkingAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                [pAnnotation DrawAnnotationView];
            }
        }
    }
}

@end
