//
//  NOMTrafficNewsObjectController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficNewsObjectController.h"
#import "NOMQueryLocationPin.h"
#import "NOMQueryAnnotation.h"
#import "NOMSystemConstants.h"
#import "NOMGUILayout.h"
#import "NOMGEOConfigration.h"
#import "NOMTrafficNewsDataOverlayController.h"


@interface NOMTrafficNewsObjectController()
{
@private
    id<IMapViewDelegate>                        m_MapView;

    //NSMutableArray*                             m_PublicTransitAnnotations;
    //NSMutableArray*                             m_DrivingConditionAnnotations;
    NSMutableArray*                             m_TrafficAnnotations;

    NOMTrafficNewsDataOverlayController*        m_Overlays;
}

@end

@implementation NOMTrafficNewsObjectController

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_MapView = nil;
        //m_PublicTransitAnnotations = [[NSMutableArray alloc] init];
        //m_DrivingConditionAnnotations = [[NSMutableArray alloc] init];
        m_TrafficAnnotations = [[NSMutableArray alloc] init];
        m_Overlays = [[NOMTrafficNewsDataOverlayController alloc] init];
    }
    
    return self;
}

-(double)GetVisibleRegionGEOWidthInMeter
{
    double fRet = 0.0;
    
    if(m_MapView != nil)
    {
        fRet = [m_MapView GetVisibleRegionGEOWidthInMeter];
    }
    
    return fRet;
}

-(void)RegisterMapView:(id<IMapViewDelegate>)mapView
{
    m_MapView = mapView;
    [m_Overlays RegisterMapView:mapView];
}

-(BOOL)IsTrafficNewsExisted:(NSString*)newsID
{
    BOOL bRet = NO;

/*
    if(0 < m_PublicTransitAnnotations.count)
    {
        for(int i = 0; i < m_PublicTransitAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_PublicTransitAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        return YES;
                    }
                }
            }
        }
    }
    
    if(0 < m_DrivingConditionAnnotations.count)
    {
        for(int i = 0; i < m_DrivingConditionAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_DrivingConditionAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        return YES;
                    }
                }
            }
        }
    }
*/
    if(0 < m_TrafficAnnotations.count)
    {
        for(int i = 0; i < m_TrafficAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_TrafficAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        return YES;
                    }
                }
            }
        }
    }
    
    
    return bRet;
}

-(void)UpdateExistedNewsData:(NOMNewsMetaDataRecord*)newsData
{
    //????????????????????
    //????????????????????
    //????????????????????
    //????????????????????
    //????????????????????
    
}

-(void)AddNewTrafficNewsData:(NOMNewsMetaDataRecord*)newsData
{
/*
    if(newsData != nil && newsData.m_NewsID != nil && 0 < newsData.m_NewsID.length)
    {
        if(newsData.m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
        {
            if(newsData.m_NewsKMLSource != nil && 0 < newsData.m_NewsKMLSource.length)
            {
                [m_Overlays AddOverlay:newsData.m_NewsID withKML:newsData.m_NewsKMLSource];
            }
            
            CLLocation* originPt = [[CLLocation alloc] initWithLatitude:newsData.m_NewsLatitude longitude:newsData.m_NewsLongitude];
            double distMeter = [self GetVisibleRegionGEOWidthInMeter];
            double uiWidth = [NOMGUILayout GetLayoutWidth];
            if(newsData.m_NewsSubCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION)
            {
                for(int i = 0; i < m_DrivingConditionAnnotations.count; ++i)
                {
                    CLLocationCoordinate2D pt = [[m_DrivingConditionAnnotations objectAtIndex:i] GetCoordinate];
                    CLLocation* destPt = [[CLLocation alloc] initWithLatitude:pt.latitude longitude:pt.longitude];
                    double distPoints = [originPt distanceFromLocation:destPt];
                    double distUI = uiWidth*distPoints/distMeter;
                    if(distUI <= [NOMGEOConfigration GetAnnotationIntervalLimitInMapView])
                    {
                        [[m_DrivingConditionAnnotations objectAtIndex:i] AddData:newsData];
                        if(((NOMQueryAnnotation*)[m_DrivingConditionAnnotations objectAtIndex:i]).m_ActiveView != nil)
                        {
                            [((NOMQueryAnnotation*)[m_DrivingConditionAnnotations objectAtIndex:i]).m_ActiveView ReloadInformation];
                            return;
                        }
                    }
                }
                NOMQueryAnnotation* pAnnotation = [[NOMQueryAnnotation alloc] init];
                [pAnnotation Reset];
                [pAnnotation SetCoordinate:newsData.m_NewsLongitude withLatitude:newsData.m_NewsLatitude];
                [pAnnotation SetActive:YES];
                [pAnnotation AddData:newsData];
                [m_DrivingConditionAnnotations addObject:pAnnotation];
                [m_MapView AddAnnotation:pAnnotation];
                return;
            }
            else if(newsData.m_NewsSubCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT)
            {
                for(int i = 0; i < m_PublicTransitAnnotations.count; ++i)
                {
                    CLLocationCoordinate2D pt = [[m_PublicTransitAnnotations objectAtIndex:i] GetCoordinate];
                    CLLocation* destPt = [[CLLocation alloc] initWithLatitude:pt.latitude longitude:pt.longitude];
                    double distPoints = [originPt distanceFromLocation:destPt];
                    double distUI = uiWidth*distPoints/distMeter;
                    if(distUI <= [NOMGEOConfigration GetAnnotationIntervalLimitInMapView])
                    {
                        [[m_PublicTransitAnnotations objectAtIndex:i] AddData:newsData];
                        if(((NOMQueryAnnotation*)[m_PublicTransitAnnotations objectAtIndex:i]).m_ActiveView != nil)
                        {
                            [((NOMQueryAnnotation*)[m_PublicTransitAnnotations objectAtIndex:i]).m_ActiveView ReloadInformation];
                            return;
                        }
                    }
                }
                NOMQueryAnnotation* pAnnotation = [[NOMQueryAnnotation alloc] init];
                [pAnnotation Reset];
                [pAnnotation SetCoordinate:newsData.m_NewsLongitude withLatitude:newsData.m_NewsLatitude];
                [pAnnotation SetActive:YES];
                [pAnnotation AddData:newsData];
                [m_PublicTransitAnnotations addObject:pAnnotation];
                [m_MapView AddAnnotation:pAnnotation];
                return;
            }
        }
    }
*/
    if(newsData != nil && newsData.m_NewsID != nil && 0 < newsData.m_NewsID.length)
    {
        if(newsData.m_NewsKMLSource != nil && 0 < newsData.m_NewsKMLSource.length)
        {
            [m_Overlays AddOverlay:newsData.m_NewsID withKML:newsData.m_NewsKMLSource];
        }
            
        CLLocation* originPt = [[CLLocation alloc] initWithLatitude:newsData.m_NewsLatitude longitude:newsData.m_NewsLongitude];
//        double distMeter = [self GetVisibleRegionGEOWidthInMeter];
//        double uiWidth = [NOMGUILayout GetLayoutWidth];
        int nCount = (int)m_TrafficAnnotations.count;
        for(int i = 0; i < nCount; ++i)
        {
            CLLocationCoordinate2D pt = [[m_TrafficAnnotations objectAtIndex:i] GetCoordinate];
            CLLocation* destPt = [[CLLocation alloc] initWithLatitude:pt.latitude longitude:pt.longitude];
            double distPoints = [originPt distanceFromLocation:destPt];
            double distUI = distPoints; //uiWidth*distPoints/distMeter;
            if(distUI <= [NOMGEOConfigration GetAnnotationIntervalLimitInMapView])
            {
                NOMQueryAnnotation* pAnnotation = [m_TrafficAnnotations objectAtIndex:i];
                if(pAnnotation != nil)
                {
                    [pAnnotation AddData:newsData];
                    if(pAnnotation.m_ActiveView != nil)
                        [pAnnotation.m_ActiveView ReloadInformation];
                    return;
                }
            }
        }
        NOMQueryAnnotation* pAnnotation = [[NOMQueryAnnotation alloc] init];
        [pAnnotation Reset];
        [pAnnotation SetCoordinate:newsData.m_NewsLongitude withLatitude:newsData.m_NewsLatitude];
        [pAnnotation SetActive:YES];
        [pAnnotation AddData:newsData];
        [pAnnotation SetIndex:nCount];
        [m_TrafficAnnotations addObject:pAnnotation];
        [m_MapView AddAnnotation:pAnnotation];
        return;
    }
}

-(void)HandleTrafficNewsData:(NOMNewsMetaDataRecord*)newsData
{
    if(newsData != nil)
    {
        if([self IsTrafficNewsExisted:newsData.m_NewsID] == YES)
        {
            [self UpdateExistedNewsData:newsData];
            return;
        }
        else
        {
            [self AddNewTrafficNewsData:newsData];
        }
    }
}

-(NOMNewsMetaDataRecord*)GetTrafficNews:(NSString*)newsID
{
    NOMNewsMetaDataRecord* pNewsData = nil;
/*
    if(0 < m_PublicTransitAnnotations.count)
    {
        for(int i = 0; i < m_PublicTransitAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_PublicTransitAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        return pRecord;
                    }
                }
            }
        }
    }
    
    if(0 < m_DrivingConditionAnnotations.count)
    {
        for(int i = 0; i < m_DrivingConditionAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_DrivingConditionAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        return pRecord;
                    }
                }
            }
        }
    }
*/
    if(0 < m_TrafficAnnotations.count)
    {
        for(int i = 0; i < (int)m_TrafficAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_TrafficAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        return pRecord;
                    }
                }
            }
        }
    }
    
    return pNewsData;
}


-(void)RemoveTrafficNewsData:(NOMNewsMetaDataRecord*)newsData
{
    if(newsData != nil && newsData.m_NewsID != nil && 0 < newsData.m_NewsID.length)
    {
        [self RemoveTrafficNewsDataByNewsID:newsData.m_NewsID];
    }
}

-(void)RemoveTrafficNewsDataByNewsID:(NSString*)newsID
{
/*
    if(0 < m_PublicTransitAnnotations.count)
    {
        for(int i = 0; i < m_PublicTransitAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_PublicTransitAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        [m_Overlays RemoveOverlay:newsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            [m_MapView RemoveAnnotation:pAnnotation];
                        }
                        else
                        {
                            [pAnnotation.m_ActiveView ReloadInformation];
                        }
                        return;
                    }
                }
            }
        }
    }
    
    if(0 < m_DrivingConditionAnnotations.count)
    {
        for(int i = 0; i < m_DrivingConditionAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_DrivingConditionAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        [m_Overlays RemoveOverlay:newsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            [m_MapView RemoveAnnotation:pAnnotation];
                        }
                        else
                        {
                            [pAnnotation.m_ActiveView ReloadInformation];
                        }
                        return;
                    }
                }
            }
        }
    }
*/
    if(0 < m_TrafficAnnotations.count)
    {
        for(int i = 0; i < m_TrafficAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_TrafficAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        [m_Overlays RemoveOverlay:newsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            [m_MapView RemoveAnnotation:pAnnotation];
                        }
                        else
                        {
                            [pAnnotation.m_ActiveView ReloadInformation];
                        }
                        return;
                    }
                }
            }
        }
    }
    
}

-(void)RemoveAllTrafficNewsDataFromMap
{
/*
    if(0 < m_PublicTransitAnnotations.count)
    {
        for(int i = 0; i < m_PublicTransitAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_PublicTransitAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil)
                    {
                        [m_Overlays RemoveOverlay:pRecord.m_NewsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            [m_MapView RemoveAnnotation:pAnnotation];
                        }
                    }
                }
            }
        }
    }
    
    if(0 < m_DrivingConditionAnnotations.count)
    {
        for(int i = 0; i < m_DrivingConditionAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_DrivingConditionAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil)
                    {
                        [m_Overlays RemoveOverlay:pRecord.m_NewsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            [m_MapView RemoveAnnotation:pAnnotation];
                        }
                    }
                }
            }
        }
    }
*/
    [m_Overlays RemoveAllOverlays];
    if(0 < m_TrafficAnnotations.count)
    {
        for(int i = 0; i < m_TrafficAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_TrafficAnnotations objectAtIndex:i];
            /*
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil)
                    {
                        [m_Overlays RemoveOverlay:pRecord.m_NewsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            [m_MapView RemoveAnnotation:pAnnotation];
                        }
                    }
                }
            }*/
            [m_MapView RemoveAnnotation:pAnnotation];
        }
        [m_TrafficAnnotations removeAllObjects];
    }
    
}

-(void)UpdateAnnotationDrawState
{
    if(0 < m_TrafficAnnotations.count)
    {
        for(int i = 0; i < m_TrafficAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_TrafficAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_ActiveView != nil)
            {
                [pAnnotation.m_ActiveView UpdateZoomSize];
            }
        }
        [m_Overlays UpdateLayout];
    }
}

-(void)RemoveNewsRecordByTimeStamp:(int64_t)nTimeBefore
{
    if(0 < m_TrafficAnnotations.count)
    {
        for(int i = (int)m_TrafficAnnotations.count-1; 0 <= i; --i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_TrafficAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = (int)pAnnotation.m_NOMMetaDataList.count-1; 0 <= j; --j)
                {
                    NOMNewsMetaDataRecord* pRecord = [pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil)
                    {
                        if(pRecord.m_nNewsTime <= nTimeBefore)
                        {
                            [pAnnotation.m_NOMMetaDataList removeObject:pRecord];
                            [m_Overlays RemoveOverlay:pRecord.m_NewsID];
                        }
                    }
                }
                if(pAnnotation.m_NOMMetaDataList.count <= 0)
                {
                    [m_MapView RemoveAnnotation:pAnnotation];
                }
                else
                {
                    [pAnnotation.m_ActiveView ReloadInformation];
                }
            }
        }
    }
}
@end
