//
//  MainViewBottomStatusBarController.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-08-26.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "MainViewBottomStatusBarController.h"
#import "NOMAppInfo.h"
#import "NOMGUILayout.h"
#import "CustomMapViewPinItem.h"
//#import "ADConfiguration.h"
//#import "SystemConfiguration.h"
#import "NOMGEOConfigration.h"
#import "NOMQueryAnnotationDataDelegate.h"

@interface MainViewBottomStatusBarController ()
{
@private
    id<MainViewBottomStatusBarControllerDelegate>   m_Delegate;
    UIButton*                                       m_PopupToolbarButton;
    /*    UIButton*                                       m_DriveStateButton;
     
     UIButton*                                       m_JamButton;
     UIButton*                                       m_CrashButton;
     UIButton*                                       m_PoliceButton;
     UIButton*                                       m_ConstructionButton;
     UIButton*                                       m_RoadClosureButton;
     UIButton*                                       m_BrokenLightButton;
     */
    //UIButton*                                       m_PhotoRadarButton;
    
    NSMutableArray*                                 m_NoneLocationTweetList;
    UIButton*                                       m_TwitterTweetButton;
    
    id<INOMCustomListCalloutDelegate>               m_CalloutDelegate;
}
@end

@implementation MainViewBottomStatusBarController

-(void)UpdateLayout
{
    if(m_Delegate != nil)
    {
        CGRect frame = [m_Delegate GetFrame];
        float size = [NOMGUILayout GetActivateButtonSize];
        float fHeight = size*0.5;
        CGRect rect = CGRectMake((frame.size.width - size)*0.5, frame.size.height-fHeight, size, fHeight);
        [m_PopupToolbarButton setFrame:rect];
        
        rect = CGRectMake((frame.size.width-size)*0.5, 0, size, size);
        [m_TwitterTweetButton setFrame:rect];
    }
}

-(void)OnTweetButtonClick
{
    if(m_CalloutDelegate != nil)
        [m_CalloutDelegate OpenListCallout:self];
}

-(void)InitializeControls_iPhone
{
    if(m_Delegate != nil)
    {
        CGRect frame = [m_Delegate GetFrame];
        float size = [NOMGUILayout GetActivateButtonSize];
        float fHeight = size*0.5;
        CGRect rect = CGRectMake((frame.size.width - size)*0.5, frame.size.height-fHeight, size, fHeight);
        
        m_PopupToolbarButton = [[CustomImageButton alloc] initWithFrame:rect];
        m_PopupToolbarButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_PopupToolbarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_PopupToolbarButton setBackgroundImage:[UIImage imageNamed:@"abtn200.png"] forState:UIControlStateNormal];
        //[m_PopupToolbarButton SetCustomImage:[UIImage imageNamed:@"abtn200.png"].CGImage];
        [m_PopupToolbarButton addTarget:m_Delegate action:@selector(OpenToolbarButtonClick) forControlEvents:UIControlEventTouchUpInside];
/*
        rect = CGRectMake(frame.size.width - size, frame.size.height-size, size, size);
        m_DriveStateButton = [[UIButton alloc] initWithFrame:rect];
        m_DriveStateButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_DriveStateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_DriveStateButton setBackgroundImage:[UIImage imageNamed:@"driving200.png"] forState:UIControlStateNormal];
        [m_DriveStateButton addTarget:m_Delegate action:@selector(OnDrivingButtonClick) forControlEvents:UIControlEventTouchUpInside];
*/
        rect = CGRectMake((frame.size.width-size)*0.5, 0, size, size);
        m_TwitterTweetButton = [[UIButton alloc] initWithFrame:rect];
        m_TwitterTweetButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_TwitterTweetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_TwitterTweetButton setBackgroundImage:[UIImage imageNamed:@"twitterbtn.png"] forState:UIControlStateNormal];
        [m_TwitterTweetButton addTarget:self action:@selector(OnTweetButtonClick) forControlEvents:UIControlEventTouchUpInside];
/*
        rect = CGRectMake(0, frame.size.height-size, size, size);
        m_JamButton = [[UIButton alloc] initWithFrame:rect];
        m_JamButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_JamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_JamButton setBackgroundImage:[UIImage imageNamed:@"jambtn200.png"] forState:UIControlStateNormal];
        [m_JamButton addTarget:m_Delegate action:@selector(OnJamButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        rect = CGRectMake(size, frame.size.height-size, size, size);
        m_CrashButton = [[UIButton alloc] initWithFrame:rect];
        m_CrashButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_CrashButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_CrashButton setBackgroundImage:[UIImage imageNamed:@"crashbtn200.png"] forState:UIControlStateNormal];
        [m_CrashButton addTarget:m_Delegate action:@selector(OnCrashButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        rect = CGRectMake(size*2, frame.size.height-size, size, size);
        m_PoliceButton = [[UIButton alloc] initWithFrame:rect];
        m_PoliceButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_PoliceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_PoliceButton setBackgroundImage:[UIImage imageNamed:@"policebtn200.png"] forState:UIControlStateNormal];
        [m_PoliceButton addTarget:m_Delegate action:@selector(OnPoliceButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        rect = CGRectMake(size*3, frame.size.height-size, size, size);
        m_ConstructionButton = [[UIButton alloc] initWithFrame:rect];
        m_ConstructionButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_ConstructionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_ConstructionButton setBackgroundImage:[UIImage imageNamed:@"constbtn200.png"] forState:UIControlStateNormal];
        [m_ConstructionButton addTarget:m_Delegate action:@selector(OnConstructZoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
        rect = CGRectMake(0, frame.size.height-size*2, size, size);
        m_RoadClosureButton = [[UIButton alloc] initWithFrame:rect];
        m_RoadClosureButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_RoadClosureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_RoadClosureButton setBackgroundImage:[UIImage imageNamed:@"roadclosebtn200.png"] forState:UIControlStateNormal];
        [m_RoadClosureButton addTarget:m_Delegate action:@selector(OnRoadCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        

        rect = CGRectMake(size, frame.size.height-size*2, size, size);
        m_BrokenLightButton = [[UIButton alloc] initWithFrame:rect];
        m_BrokenLightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_BrokenLightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_BrokenLightButton setBackgroundImage:[UIImage imageNamed:@"brokenlight200.png"] forState:UIControlStateNormal];
        [m_BrokenLightButton addTarget:m_Delegate action:@selector(OnBrokenLightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
 //       rect = CGRectMake(size*2, frame.size.height-size*2, size, size);
 //       m_PhotoRadarButton = [[UIButton alloc] initWithFrame:rect];
 //       m_PhotoRadarButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
 //       m_PhotoRadarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
 //       [m_PhotoRadarButton setBackgroundImage:[UIImage imageNamed:@"photobtn200.png"] forState:UIControlStateNormal];
 //       [m_PhotoRadarButton addTarget:m_Delegate action:@selector(OnPhotoRadarButtonClick) forControlEvents:UIControlEventTouchUpInside];
 
        m_JamButton.hidden = YES;
        m_CrashButton.hidden = YES;
        m_PoliceButton.hidden = YES;
        m_ConstructionButton.hidden = YES;
        m_RoadClosureButton.hidden = YES;
 //       m_PhotoRadarButton.hidden = YES;
        m_BrokenLightButton.hidden = YES;
*/
      

        
//        [m_Delegate AddChildView:m_DriveStateButton];
        
        [m_Delegate AddChildView:m_PopupToolbarButton];
  
/*
        [m_Delegate AddChildView:m_JamButton];
        [m_Delegate AddChildView:m_CrashButton];
        [m_Delegate AddChildView:m_PoliceButton];
        [m_Delegate AddChildView:m_ConstructionButton];
        [m_Delegate AddChildView:m_RoadClosureButton];
//        [m_Delegate AddChildView:m_PhotoRadarButton];
        [m_Delegate AddChildView:m_BrokenLightButton];
*/
        m_TwitterTweetButton.hidden = YES;
        [m_Delegate AddChildView:m_TwitterTweetButton];

    }
}

-(void)InitializeControls_iPad
{
    if(m_Delegate != nil)
    {
        CGRect frame = [m_Delegate GetFrame];
        float size = [NOMGUILayout GetActivateButtonSize];
        float fHeight = size*0.5;
        CGRect rect = CGRectMake((frame.size.width - size)*0.5, frame.size.height-fHeight, size, fHeight);
        
        m_PopupToolbarButton = [[UIButton alloc] initWithFrame:rect];
        m_PopupToolbarButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_PopupToolbarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_PopupToolbarButton setBackgroundImage:[UIImage imageNamed:@"abtn200.png"] forState:UIControlStateNormal];
        [m_PopupToolbarButton addTarget:m_Delegate action:@selector(OpenToolbarButtonClick) forControlEvents:UIControlEventTouchUpInside];
/*
        rect = CGRectMake(frame.size.width - size, frame.size.height-size, size, size);
        m_DriveStateButton = [[UIButton alloc] initWithFrame:rect];
        m_DriveStateButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_DriveStateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_DriveStateButton setBackgroundImage:[UIImage imageNamed:@"driving200.png"] forState:UIControlStateNormal];
        [m_DriveStateButton addTarget:m_Delegate action:@selector(OnDrivingButtonClick) forControlEvents:UIControlEventTouchUpInside];
*/
        rect = CGRectMake((frame.size.width-size)*0.5, 0, size, size);
        m_TwitterTweetButton = [[UIButton alloc] initWithFrame:rect];
        m_TwitterTweetButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_TwitterTweetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_TwitterTweetButton setBackgroundImage:[UIImage imageNamed:@"twitterbtn.png"] forState:UIControlStateNormal];
        [m_TwitterTweetButton addTarget:self action:@selector(OnTweetButtonClick) forControlEvents:UIControlEventTouchUpInside];
/*
        rect = CGRectMake(0, frame.size.height-size, size, size);
        m_JamButton = [[UIButton alloc] initWithFrame:rect];
        m_JamButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_JamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_JamButton setBackgroundImage:[UIImage imageNamed:@"jambtn200.png"] forState:UIControlStateNormal];
        [m_JamButton addTarget:m_Delegate action:@selector(OnJamButtonClick) forControlEvents:UIControlEventTouchUpInside];

        rect = CGRectMake(size, frame.size.height-size, size, size);
        m_CrashButton = [[UIButton alloc] initWithFrame:rect];
        m_CrashButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_CrashButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_CrashButton setBackgroundImage:[UIImage imageNamed:@"crashbtn200.png"] forState:UIControlStateNormal];
        [m_CrashButton addTarget:m_Delegate action:@selector(OnCrashButtonClick) forControlEvents:UIControlEventTouchUpInside];

        rect = CGRectMake(size*2, frame.size.height-size, size, size);
        m_PoliceButton = [[UIButton alloc] initWithFrame:rect];
        m_PoliceButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_PoliceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_PoliceButton setBackgroundImage:[UIImage imageNamed:@"policebtn200.png"] forState:UIControlStateNormal];
        [m_PoliceButton addTarget:m_Delegate action:@selector(OnPoliceButtonClick) forControlEvents:UIControlEventTouchUpInside];

        rect = CGRectMake(size*3, frame.size.height-size, size, size);
        m_ConstructionButton = [[UIButton alloc] initWithFrame:rect];
        m_ConstructionButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_ConstructionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_ConstructionButton setBackgroundImage:[UIImage imageNamed:@"constbtn200.png"] forState:UIControlStateNormal];
        [m_ConstructionButton addTarget:m_Delegate action:@selector(OnConstructZoneButtonClick) forControlEvents:UIControlEventTouchUpInside];

        rect = CGRectMake(size*4, frame.size.height-size, size, size);
        m_RoadClosureButton = [[UIButton alloc] initWithFrame:rect];
        m_RoadClosureButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_RoadClosureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_RoadClosureButton setBackgroundImage:[UIImage imageNamed:@"roadclosebtn200.png"] forState:UIControlStateNormal];
        [m_RoadClosureButton addTarget:m_Delegate action:@selector(OnRoadCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];

        rect = CGRectMake(size*5, frame.size.height-size, size, size);
        m_BrokenLightButton = [[UIButton alloc] initWithFrame:rect];
        m_BrokenLightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_BrokenLightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_BrokenLightButton setBackgroundImage:[UIImage imageNamed:@"brokenlight200.png"] forState:UIControlStateNormal];
        [m_BrokenLightButton addTarget:m_Delegate action:@selector(OnBrokenLightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
//        rect = CGRectMake(size*6, frame.size.height-size, size, size);
//        m_PhotoRadarButton = [[UIButton alloc] initWithFrame:rect];
//        m_PhotoRadarButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        m_PhotoRadarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
//        [m_PhotoRadarButton setBackgroundImage:[UIImage imageNamed:@"photobtn200.png"] forState:UIControlStateNormal];
//        [m_PhotoRadarButton addTarget:m_Delegate action:@selector(OnPhotoRadarButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        m_JamButton.hidden = YES;
        m_CrashButton.hidden = YES;
        m_PoliceButton.hidden = YES;
        m_ConstructionButton.hidden = YES;
        m_RoadClosureButton.hidden = YES;
//        m_PhotoRadarButton.hidden = YES;
        m_BrokenLightButton.hidden = YES;
 
        
        [m_Delegate AddChildView:m_DriveStateButton];
 */
        
        [m_Delegate AddChildView:m_PopupToolbarButton];
      
/*
        [m_Delegate AddChildView:m_JamButton];
        [m_Delegate AddChildView:m_CrashButton];
        [m_Delegate AddChildView:m_PoliceButton];
        [m_Delegate AddChildView:m_ConstructionButton];
        [m_Delegate AddChildView:m_RoadClosureButton];
        [m_Delegate AddChildView:m_BrokenLightButton];
//        [m_Delegate AddChildView:m_PhotoRadarButton];
*/
        m_TwitterTweetButton.hidden = YES;
        [m_Delegate AddChildView:m_TwitterTweetButton];

    }
}

-(CGPoint)GetTwitetrButtonAchor
{
    CGRect frame = [m_Delegate GetFrame];
    float size = [NOMGUILayout GetActivateButtonSize];

    CGPoint pt = CGPointMake(frame.size.width*0.5, size);
    return pt;
}

-(NSArray*)GetTweetList
{
    return m_NoneLocationTweetList;
}

-(void)InitializeControls
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        [self InitializeControls_iPad];
    }
    else
    {
        [self InitializeControls_iPhone];
    }
}

-(id)initWithDelegate:(id<MainViewBottomStatusBarControllerDelegate>)delegate
{
    self = [super init];
    
    if(self != nil)
    {
        m_Delegate = delegate;
        
        m_PopupToolbarButton = nil;
//        m_DriveStateButton = nil;
        m_CalloutDelegate = nil;
    
        m_NoneLocationTweetList = [[NSMutableArray alloc] init];
        
        [self InitializeControls];
    }
    
    return self;
}

-(void)ShowPopupToolbarButton:(BOOL)bShow
{
    if(m_PopupToolbarButton != nil)
    {
        if(bShow == YES)
        {
            m_PopupToolbarButton.hidden = NO;
//            if(m_DriveStateButton != nil)
//                m_DriveStateButton.hidden = NO;
        }
        else
        {
            m_PopupToolbarButton.hidden = YES;
//            if(m_DriveStateButton != nil)
//                m_DriveStateButton.hidden = YES;
        }
    }
}

-(void)SetPopupToolbarButtonDisplay:(BOOL)bYes
{
    if(m_PopupToolbarButton != nil)
    {
        if(bYes == YES)
        {
            m_PopupToolbarButton.hidden = NO;
        }
        else
        {
            m_PopupToolbarButton.hidden = YES;
        }
    }
}

-(void)SetDrivingButtonState:(BOOL)bEnable
{
    if(bEnable == NO)
    {
//        [m_DriveStateButton setBackgroundImage:[UIImage imageNamed:@"driving200.png"] forState:UIControlStateNormal];
/*        if([SystemConfiguration IsDeviceIPhone] == YES)
        {
            CGRect frame = [m_Delegate GetFrame];
            float size = [self GetActivateButtonSize];
            CGRect rect = CGRectMake(frame.size.width - size, frame.size.height-size, size, size);
            [m_DriveStateButton setFrame:rect];
        }
*/
/*
        m_JamButton.hidden = YES;
        m_CrashButton.hidden = YES;
        m_PoliceButton.hidden = YES;
        m_ConstructionButton.hidden = YES;
        m_RoadClosureButton.hidden = YES;
//        m_PhotoRadarButton.hidden = YES;
        m_BrokenLightButton.hidden = YES;*/
    }
    else
    {
//        [m_DriveStateButton setBackgroundImage:[UIImage imageNamed:@"stopdriving200.png"] forState:UIControlStateNormal];
/*        if([SystemConfiguration IsDeviceIPhone] == YES)
        {
            CGRect frame = [m_Delegate GetFrame];
            float size = [self GetActivateButtonSize];
            CGRect rect = CGRectMake(frame.size.width - size, 0, size, size);
            [m_DriveStateButton setFrame:rect];
        }
 */
/*
        m_JamButton.hidden = NO;
        m_CrashButton.hidden = NO;
        m_PoliceButton.hidden = NO;
        m_ConstructionButton.hidden = NO;
        m_RoadClosureButton.hidden = NO;
//        m_PhotoRadarButton.hidden = NO;
        m_BrokenLightButton.hidden = NO;*/
    }
}

-(void)UpdateTwitterButtonStatus
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(UpdateTwitterButtonStatus) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(0 < m_NoneLocationTweetList.count)
    {
        m_TwitterTweetButton.hidden = NO;
        [m_TwitterTweetButton.superview bringSubviewToFront:m_TwitterTweetButton];
    }
    else
    {
        m_TwitterTweetButton.hidden = YES;
        [m_TwitterTweetButton.superview sendSubviewToBack:m_TwitterTweetButton];
    }
}


-(void)CleanNoneLocationTweetList
{
    [m_NoneLocationTweetList removeAllObjects];
    [self UpdateTwitterButtonStatus];
}


-(void)AddNoneLocationTweetData:(NOMNewsMetaDataRecord*)pRecord
{
    if(pRecord == nil || pRecord.m_NewsID == nil || pRecord.m_NewsID.length <= 0)
        return;
    
    int nCount = (int)m_NoneLocationTweetList.count; //[self GetNextAvaliableOueryPinIndex];
    
    BOOL bExisted = NO;
    
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NOMNewsMetaDataRecord* pItem = ( NOMNewsMetaDataRecord*)[m_NoneLocationTweetList objectAtIndex:i];
            if(pItem != nil && pItem.m_NewsID != nil && 0 < pItem.m_NewsID.length)
            {
                if([pItem.m_NewsID isEqualToString:pRecord.m_NewsID] == YES)
                {
                    bExisted = YES;
                    break;
                }
            }
        }
    }
    
    if(bExisted == NO && nCount <= 200)
    {
        [pRecord RegisterLocationUpdateDelegate:self];
        [m_NoneLocationTweetList addObject:pRecord];
        
        //???[pRecord StartTweetLocationDecode];
    }
#ifdef DEBUG
    else
    {
        NSLog(@"m_NoneLocationTweetList is overflown.\n");
    }
#endif
    [self UpdateTwitterButtonStatus];
}

-(NOMNewsMetaDataRecord*)GetNewsMetaDataRecord:(NSString*)newsID
{
    if(newsID == nil || newsID.length <= 0)
        return nil;
    
    int nCount = (int)m_NoneLocationTweetList.count; //[self GetNextAvaliableOueryPinIndex];
    
    
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NOMNewsMetaDataRecord* pItem = ( NOMNewsMetaDataRecord*)[m_NoneLocationTweetList objectAtIndex:i];
            if(pItem != nil && pItem.m_NewsID != nil && 0 < pItem.m_NewsID.length)
            {
                if([pItem.m_NewsID isEqualToString:newsID] == YES)
                {
                    return pItem;
                }
            }
        }
    }
    
    return nil;
}

-(NOMNewsMetaDataRecord*)GetNewsMetaDataRecordByIndex:(int)index
{
    if(index < 0)
        return nil;
    
    int nCount = (int)m_NoneLocationTweetList.count; //[self GetNextAvaliableOueryPinIndex];
    
    
    if(0 < nCount && index < nCount)
    {
        NOMNewsMetaDataRecord* pItem = ( NOMNewsMetaDataRecord*)[m_NoneLocationTweetList objectAtIndex:index];
        return pItem;
    }
    
    return nil;
}

-(int)GetNewsDataIndex:(NSString*)szNewsID
{
    int nRet = -1;
    if(0 < m_NoneLocationTweetList.count)
    {
        for(int i = 0; i < m_NoneLocationTweetList.count; ++i)
        {
            NOMNewsMetaDataRecord* pRecord = (NOMNewsMetaDataRecord*)[m_NoneLocationTweetList objectAtIndex:i];
            if(pRecord != nil && pRecord.m_NewsID != nil)
            {
                if([pRecord.m_NewsID isEqualToString:szNewsID] == YES)
                    return i;
            }
        }
    }
    
    return nRet;
}

//
//INOMCachedSoicalNewsContainer methods
//
-(id)GetCachedSocialNews:(NSString*)szNewsID
{
    NOMNewsMetaDataRecord* pRecord = nil;
    
    if(0 < m_NoneLocationTweetList.count)
    {
        for(int i = 0; i < m_NoneLocationTweetList.count; ++i)
        {
            pRecord = (NOMNewsMetaDataRecord*)[m_NoneLocationTweetList objectAtIndex:i];
            if(pRecord != nil && pRecord.m_NewsID != nil)
            {
                if([pRecord.m_NewsID isEqualToString:szNewsID] == YES)
                    return pRecord;
            }
        }
    }
    
    pRecord = nil;
    return pRecord;
}

-(BOOL)RemoveData:(int)index
{
    if(0 < m_NoneLocationTweetList.count && 0 <= index && index < m_NoneLocationTweetList.count)
    {
        [m_NoneLocationTweetList removeObjectAtIndex:index];
        [self UpdateTwitterButtonStatus];
        return YES;
    }
    
    return NO;
}

-(void)LocationUpdated:(NOMNewsMetaDataRecord*)pMetaData
{
    if(m_NoneLocationTweetList == nil || m_NoneLocationTweetList.count <= 0 || pMetaData == nil)
        return;
    
    int index = [self GetNewsDataIndex:pMetaData.m_NewsID];
    if(0 <= index)
    {
        [self RemoveData:index];
    }
    id<NOMQueryAnnotationDataDelegate> pDelegate = [NOMGEOConfigration GetNOMQueryAnnotationDataDelegate];
    if(pDelegate)
        [pDelegate QueryAnnontationDataChanged:pMetaData];

}

-(int)GetMetaDataIndex:(NOMNewsMetaDataRecord*)pMetaData
{
    int nRet = 0;
    
    if(m_NoneLocationTweetList != nil && 0 < m_NoneLocationTweetList.count && pMetaData != nil)
    {
        nRet = [self GetNewsDataIndex:pMetaData.m_NewsID];
    }
    
    return nRet;
}

-(void)LocationDecodeDone:(NOMNewsMetaDataRecord*)pMetaData withResult:(BOOL)bResultOK
{
    if(m_NoneLocationTweetList == nil || m_NoneLocationTweetList.count <= 0)
        return;
    
    int index = [self GetMetaDataIndex:pMetaData];
    if(bResultOK)
    {
        id<NOMQueryAnnotationDataDelegate> pDelegate = [NOMGEOConfigration GetNOMQueryAnnotationDataDelegate];
        if(pDelegate)
            [pDelegate QueryAnnontationDataChanged:pMetaData];
        if(0 <= index)
        {
            [self RemoveData:index];
        }
    }
}

-(void)StartTweetMetaDataLocationDecode:(int)index
{
    NOMNewsMetaDataRecord*  pMetaData = [self GetNewsMetaDataRecordByIndex:index];
    if(pMetaData)
        [pMetaData StartTweetLocationDecode];
}

//
//INOMCustomListCalloutCaller methods
//
-(BOOL)PrepareCalloutList:(id<INOMCustomListCalloutDelegate>)callout
{
    m_CalloutDelegate = callout;
    
    if(m_CalloutDelegate == nil)
        return NO;
    
    BOOL bRet = NO;
    if(m_NoneLocationTweetList != nil && m_NoneLocationTweetList.count)
    {
        for(int i = 0; i < m_NoneLocationTweetList.count; ++i)
        {
            CustomMapViewPinItem* item = (CustomMapViewPinItem*)[m_CalloutDelegate CreateCustomeCalloutItem];
            NOMNewsMetaDataRecord* data = [m_NoneLocationTweetList objectAtIndex:i];
            if(item != nil && data != nil)
            {
                if([item LoadItemData:data] == YES)
                {
                    [m_CalloutDelegate AddCalloutItem:item];
                    bRet = YES;
                }
            }
        }
    }
    else
    {
        return NO;
    }
    return bRet;
}

-(CGPoint)GetViewPointFromCurrentLocation
{
    CGPoint pt = CGPointMake(0, 0);
    
    if(m_Delegate != nil)
    {
        CGRect frame = [m_Delegate GetFrame];
        float size = [NOMGUILayout GetActivateButtonSize];
        
        pt = CGPointMake(frame.size.width*0.5, size);
    }
    
    return pt;
}

-(CLLocationCoordinate2D)GetCurrentLocation
{
    CLLocationCoordinate2D loc;
    
    loc.latitude = 0;
    loc.longitude = 0;
    
    return loc;
}

-(void)RegisterCallout:(id<INOMCustomListCalloutDelegate>)callout
{
    m_CalloutDelegate = callout;
}

@end
