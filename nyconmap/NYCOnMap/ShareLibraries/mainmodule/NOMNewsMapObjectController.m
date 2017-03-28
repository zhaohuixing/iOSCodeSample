//
//  NOMNewsMapObjectController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsMapObjectController.h"
#import "NOMQueryLocationPin.h"
#import "NOMQueryAnnotation.h"
#import "NOMSystemConstants.h"
#import "NOMGUILayout.h"
#import "NOMGEOConfigration.h"
#import "NOMTrafficNewsDataOverlayController.h"


@interface NOMNewsMapObjectController()
{
@private
    id<IMapViewDelegate>                        m_MapView;

    NSMutableArray*                             m_NewsAnnotations;

    NOMTrafficNewsDataOverlayController*        m_Overlays;
    
    //NOMWatchCommunicationManager*               m_WatchMessager;
    
}

-(void)LoadTrafficAnnotations;

@end

@implementation NOMNewsMapObjectController

/*
-(void)RegisterWatchMessageManager:(NOMWatchCommunicationManager*)watchMessager
{
    m_WatchMessager = watchMessager;
}
*/

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        //m_WatchMessager = nil;
        m_MapView = nil;
        //m_PublicTransitAnnotations = [[NSMutableArray alloc] init];
        //m_DrivingConditionAnnotations = [[NSMutableArray alloc] init];
        m_NewsAnnotations = [[NSMutableArray alloc] init];
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
    [self LoadTrafficAnnotations];
    [m_Overlays RegisterMapView:mapView];
}

-(BOOL)IsNewsDataExisted:(NSString*)newsID
{
    BOOL bRet = NO;

    if(0 < m_NewsAnnotations.count)
    {
        for(int i = 0; i < m_NewsAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
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
    if(newsData != nil && newsData.m_NewsID != nil && 0 < newsData.m_NewsID.length && m_MapView != nil && [m_MapView CheckAnnotationWithMetaDataID:newsData.m_NewsID] == NO)
    {
        if(newsData.m_NewsKMLSource != nil && 0 < newsData.m_NewsKMLSource.length)
        {
            [m_Overlays AddOverlay:newsData.m_NewsID withKML:newsData.m_NewsKMLSource];
        }
        
        int nCount = (int)m_NewsAnnotations.count;
        int index = 0;
        BOOL bChecked = NO;
        for(int i = 0; i < nCount; ++i)
        {
            bChecked = NO;
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsData.m_NewsID] == YES)
                    {
                        bChecked = YES;
                        break;
                    }
                }
            }
            if(bChecked == YES)
            {
                index = i;
                break;
            }
        }
        NOMQueryAnnotation* pAnnotation = [[NOMQueryAnnotation alloc] init];
        [pAnnotation Reset];
        [pAnnotation SetCoordinate:newsData.m_NewsLongitude withLatitude:newsData.m_NewsLatitude];
        [pAnnotation SetActive:YES];
        [pAnnotation AddData:newsData];
        [pAnnotation SetIndex:index];
        if(m_MapView != nil)
            [m_MapView AddAnnotation:pAnnotation];
        return;
    }
}

/*
-(void)BroadcastNewsDataToWatch:(NOMNewsMetaDataRecord*)newsData
{
    if(newsData != nil && newsData.m_NewsID != nil && 0 < newsData.m_NewsID.length && m_WatchMessager != nil)
    {
        NOMWatchMapAnnotation* pAnnotation = [newsData CreateWatchAnnotation];
        [m_WatchMessager BroadcastAddAnnotation:pAnnotation];
    }
}
*/

-(void)AddNewNewsData:(NOMNewsMetaDataRecord*)newsData
{
    if(newsData != nil && newsData.m_NewsID != nil && 0 < newsData.m_NewsID.length)
    {
        if(newsData.m_NewsKMLSource != nil && 0 < newsData.m_NewsKMLSource.length)
        {
            [m_Overlays AddOverlay:newsData.m_NewsID withKML:newsData.m_NewsKMLSource];
        }
        
//        [self BroadcastNewsDataToWatch:newsData];
        
        
        CLLocation* originPt = [[CLLocation alloc] initWithLatitude:newsData.m_NewsLatitude longitude:newsData.m_NewsLongitude];
//        double distMeter = [self GetVisibleRegionGEOWidthInMeter];
//        double uiWidth = [NOMGUILayout GetLayoutWidth];
        int nCount = (int)m_NewsAnnotations.count;
      
        if(newsData.m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALNEWS)
        {
            for(int i = 0; i < nCount; ++i)
            {
                CLLocationCoordinate2D pt = [[m_NewsAnnotations objectAtIndex:i] GetCoordinate];
                CLLocation* destPt = [[CLLocation alloc] initWithLatitude:pt.latitude longitude:pt.longitude];
                double distPoints = [originPt distanceFromLocation:destPt];
                double distUI = distPoints; //uiWidth*distPoints/distMeter;
                if(distUI <= [NOMGEOConfigration GetAnnotationIntervalLimitInMapView])
                {
                    NOMQueryAnnotation* pAnnotation = [m_NewsAnnotations objectAtIndex:i];
                    if(pAnnotation != nil)
                    {
                        [pAnnotation AddData:newsData];
                        if(pAnnotation.m_ActiveView != nil)
                            [pAnnotation.m_ActiveView ReloadInformation];
                        return;
                    }
                }
            }
        }
        NOMQueryAnnotation* pAnnotation = [[NOMQueryAnnotation alloc] init];
        [pAnnotation Reset];
        [pAnnotation SetCoordinate:newsData.m_NewsLongitude withLatitude:newsData.m_NewsLatitude];
        [pAnnotation SetActive:YES];
        [pAnnotation AddData:newsData];
        [pAnnotation SetIndex:nCount];
        [m_NewsAnnotations addObject:pAnnotation];
        if(m_MapView != nil)
            [m_MapView AddAnnotation:pAnnotation];
        return;
    }
}

-(void)HandleNewsData:(NOMNewsMetaDataRecord*)newsData
{
    if(newsData != nil)
    {
        if([self IsNewsDataExisted:newsData.m_NewsID] == YES)
        {
            [self UpdateExistedNewsData:newsData];
            return;
        }
        else
        {
            [self AddNewNewsData:newsData];
        }
    }
}

-(NOMNewsMetaDataRecord*)GetNewsRecord:(NSString*)newsID
{
    NOMNewsMetaDataRecord* pNewsData = nil;
    if(0 < m_NewsAnnotations.count)
    {
        for(int i = 0; i < (int)m_NewsAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
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


-(void)RemoveNewsData:(NOMNewsMetaDataRecord*)newsData
{
    if(newsData != nil && newsData.m_NewsID != nil && 0 < newsData.m_NewsID.length)
    {
        [self RemoveNewsDataByNewsID:newsData.m_NewsID];
    }
}

-(void)RemoveNewsDataByNewsID:(NSString*)newsID
{
    if(0 < m_NewsAnnotations.count)
    {
        for(int i = ((int)m_NewsAnnotations.count-1); 0 <= i; --i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = ((int)pAnnotation.m_NOMMetaDataList.count -1); 0 <= j; --j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && [pRecord.m_NewsID isEqualToString:newsID] == YES)
                    {
                        [m_Overlays RemoveOverlay:newsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            if(m_MapView != nil)
                                [m_MapView RemoveAnnotation:pAnnotation];
                            [m_NewsAnnotations removeObjectAtIndex:i];
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

-(void)RemoveAllNewsDataFromMap
{
    [m_Overlays RemoveAllOverlays];
    if(0 < m_NewsAnnotations.count)
    {
        for(int i = 0; i < m_NewsAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
            if(m_MapView != nil)
                [m_MapView RemoveAnnotation:pAnnotation];
        }
        [m_NewsAnnotations removeAllObjects];
    }
    
}

-(void)RemoveNewsDataByMainCate:(int16_t)nMainCate
{
    if(0 < m_NewsAnnotations.count)
    {
        for(int i = (int)(m_NewsAnnotations.count - 1); 0 <= i; --i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = (int)(pAnnotation.m_NOMMetaDataList.count-1); 0 <= j; --j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsMainCategory == nMainCate)
                    {
                        [m_Overlays RemoveOverlay:pRecord.m_NewsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            if(m_MapView != nil)
                                [m_MapView RemoveAnnotation:pAnnotation];
                            [m_NewsAnnotations objectAtIndex:i];
                            break;
                        }
                        else
                        {
                            [pAnnotation.m_ActiveView ReloadInformation];
                        }
                    }
                }
            }
        }
    }
}

-(void)RemoveNewsDataByMainCate:(int16_t)nMainCate subCate:(int16_t)nSubCate
{
    if(0 < m_NewsAnnotations.count)
    {
        for(int i = (int)(m_NewsAnnotations.count - 1); 0 <= i; --i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = (int)(pAnnotation.m_NOMMetaDataList.count-1); 0 <= j; --j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsMainCategory == nMainCate && pRecord.m_NewsSubCategory == nSubCate)
                    {
                        [m_Overlays RemoveOverlay:pRecord.m_NewsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            if(m_MapView != nil)
                                [m_MapView RemoveAnnotation:pAnnotation];
                            [m_NewsAnnotations objectAtIndex:i];
                            break;
                        }
                        else
                        {
                            [pAnnotation.m_ActiveView ReloadInformation];
                        }
                    }
                }
            }
        }
    }
}

-(void)RemoveNewsDataByMainCate:(int16_t)nMainCate subCate:(int16_t)nSubCate thirdCate:(int16_t)nThirdCate
{
    if(0 < m_NewsAnnotations.count)
    {
        for(int i = (int)(m_NewsAnnotations.count - 1); 0 <= i; --i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = (int)(pAnnotation.m_NOMMetaDataList.count-1); 0 <= j; --j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsMainCategory == nMainCate && pRecord.m_NewsSubCategory == nSubCate && pRecord.m_NewsThirdCategory == nThirdCate)
                    {
                        [m_Overlays RemoveOverlay:pRecord.m_NewsID];
                        [pAnnotation.m_NOMMetaDataList removeObjectAtIndex:j];
                        if(pAnnotation.m_NOMMetaDataList.count <= 0)
                        {
                            if(m_MapView != nil)
                                [m_MapView RemoveAnnotation:pAnnotation];
                            [m_NewsAnnotations objectAtIndex:i];
                            break;
                        }
                        else
                        {
                            [pAnnotation.m_ActiveView ReloadInformation];
                        }
                    }
                }
            }
        }
    }
}

-(void)UpdateAnnotationDrawState
{
    if(0 < m_NewsAnnotations.count)
    {
        for(int i = 0; i < m_NewsAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
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
    if(0 < m_NewsAnnotations.count)
    {
        for(int i = (int)m_NewsAnnotations.count-1; 0 <= i; --i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
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
                    if(m_MapView != nil)
                        [m_MapView RemoveAnnotation:pAnnotation];
                    [m_NewsAnnotations objectAtIndex:i];
                }
                else
                {
                    [pAnnotation.m_ActiveView ReloadInformation];
                }
            }
        }
    }
}

//
//Collect Data to Apple Watch open reqest
//
-(void)CollectNewsDataForAppleWatch:(NSMutableDictionary*)collectionSet storageKey:(NSString*)szKey
{
    if(0 < m_NewsAnnotations.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < m_NewsAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && pRecord.m_NewsID.length && pRecord.m_bTwitterTweet == NO)
                    {
                        NSDictionary* pData = [pRecord CreateWatchAnnotationKeyValueBlock];
                        [dataArray addObject:pData];
                    }
                }
            }
        }
        if(0 < dataArray.count)
        {
            [collectionSet setValue:dataArray forKey:szKey];
        }
    }
}

-(void)CollectNewsDataFromSocialMediaForAppleWatch:(NSMutableDictionary*)collectionSet storageKey:(NSString*)szKey
{
    if(0 < m_NewsAnnotations.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < m_NewsAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
            if(pAnnotation != nil && pAnnotation.m_NOMMetaDataList != nil && 0 < pAnnotation.m_NOMMetaDataList.count)
            {
                for(int j = 0; j < pAnnotation.m_NOMMetaDataList.count; ++j)
                {
                    NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[pAnnotation.m_NOMMetaDataList objectAtIndex:j];
                    if(pRecord != nil && pRecord.m_NewsID != nil && pRecord.m_NewsID.length && pRecord.m_bTwitterTweet == YES)
                    {
                        NSDictionary* pData = [pRecord CreateWatchAnnotationKeyValueBlock];
                        [dataArray addObject:pData];
                    }
                }
            }
        }
        if(0 < dataArray.count)
        {
            [collectionSet setValue:dataArray forKey:szKey];
        }
    }
}

-(BOOL)CanHandleAppleWatchRequest
{
    if(0 < m_NewsAnnotations.count)
    {
        return YES;
    }
    return NO;
}

-(void)LoadTrafficAnnotations
{
    if(0 < m_NewsAnnotations.count)
    {
        for(int i = 0; i < m_NewsAnnotations.count; ++i)
        {
            NOMQueryAnnotation* pAnnotation = (NOMQueryAnnotation*)[m_NewsAnnotations objectAtIndex:i];
            if(pAnnotation != nil)
            {
                if(m_MapView != nil)
                    [m_MapView AddAnnotation:pAnnotation];
            }
        }
        //?????????????
        //
        //Load overlay
        //
        //????????????
        //[m_Overlays UpdateLayout];
    }
}

@end
