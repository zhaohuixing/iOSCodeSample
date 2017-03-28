//
//  InterfaceController.m
//  nyconmap WatchKit Extension
//
//  Created by Zhaohui Xing on 2015-03-26.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "InterfaceController.h"
#import "NYCCommunicationManager.h"
#import "NOMSystemConstants.h"
#import "NOMAppWatchConstants.h"
#import "NOMAppWatchDataHelper.h"
#import "NOMWatchResourceHelper.h"

@interface InterfaceController()
{
    NSString*           m_ActionsChoiceControllerIdentifier;       //pageOneController
    NSString*           m_AlertControllerIdentifier;
    double              m_dLatitude;
    double              m_dLongitude;
    double              m_dSpan;
    
    double              m_dLatitudeStart;
    double              m_dLatitudeEnd;
    double              m_dLongitudeStart;
    double              m_dLongitudeEnd;
    
    //NSMutableArray*     m_Annotations;

    NSMutableArray*     m_PhotoRadarAnnotations;
    NSMutableArray*     m_GasStationAnnotations;
    NSMutableArray*     m_SchoolZoneAnnotations;
    NSMutableArray*     m_PlayGroundAnnotations;
    NSMutableArray*     m_ParkingGroundAnnotations;
    
    NSMutableArray*     m_TrafficMessageAnnotations;
    NSMutableArray*     m_TaxiMessageAnnotations;
    NSMutableArray*     m_SocialTrafficAnnotations;
    
    BOOL                m_bLoadDataFromMainApp;
}

@property (weak, nonatomic) IBOutlet WKInterfaceMap *m_MapView;

- (IBAction)onMenuShareEvent;
- (IBAction)onMenuSearchEvent;
- (IBAction)onMenuCancelEvent;
- (IBAction)onMenuCurrentLocationEvent;

-(void)__RemovePhotoRadarAnnotations;
-(void)__RemoveGasStationAnnotations;
-(void)__RemoveSchoolZoneAnnotations;
-(void)__RemovePlayGroundAnnotations;
-(void)__RemoveParkingGroundAnnotations;

-(void)__RemoveTrafficMessageAnnotations;
-(void)__RemoveTrafficAndSocialMessageAnnotations;
-(void)__RemoveTaxiMessageAnnotations;
-(void)__RemoveSocialTrafficAnnotations;

//-(void)InitializeWithMainReplyData:(NSDictionary*)replyInfo;


@end


@implementation InterfaceController

static BOOL g_CleanupMapView = NO;

+(void)SetForceCleanupMapViewFlag:(BOOL)bCleanup
{
    g_CleanupMapView = bCleanup;
}

+(BOOL)GetForceCleanupMapViewFlag
{
    return g_CleanupMapView;
}

-(BOOL)HasObjects
{
    if(0 < m_PhotoRadarAnnotations.count)
        return YES;
    
    if(0 < m_GasStationAnnotations.count)
        return YES;

    if(0 < m_SchoolZoneAnnotations.count)
        return YES;

    if(0 < m_PlayGroundAnnotations.count)
        return YES;

    if(0 < m_ParkingGroundAnnotations.count)
        return YES;

    if(0 < m_TrafficMessageAnnotations.count)
        return YES;

    if(0 < m_TaxiMessageAnnotations.count)
        return YES;

    if(0 < m_SocialTrafficAnnotations.count)
        return YES;

    return NO;
}

-(void)__RemovePhotoRadarAnnotations
{
    if(m_PhotoRadarAnnotations != nil)
    {
        [m_PhotoRadarAnnotations removeAllObjects];
    }
}

-(void)__RemoveGasStationAnnotations
{
    if(m_GasStationAnnotations != nil)
    {
        [m_GasStationAnnotations removeAllObjects];
    }
}

-(void)__RemoveSchoolZoneAnnotations
{
    if(m_SchoolZoneAnnotations != nil)
    {
        [m_SchoolZoneAnnotations removeAllObjects];
    }
}

-(void)__RemovePlayGroundAnnotations
{
    if(m_PlayGroundAnnotations != nil)
    {
        [m_PlayGroundAnnotations removeAllObjects];
    }
}

-(void)__RemoveParkingGroundAnnotations
{
    if(m_ParkingGroundAnnotations != nil)
    {
        [m_ParkingGroundAnnotations removeAllObjects];
    }
}

-(void)__RemoveTrafficMessageAnnotations
{
    if(m_TrafficMessageAnnotations != nil)
    {
        [m_TrafficMessageAnnotations removeAllObjects];
    }
}

-(void)__RemoveTrafficAndSocialMessageAnnotations
{
    if(m_TrafficMessageAnnotations != nil)
    {
        [m_TrafficMessageAnnotations removeAllObjects];
    }

    if(m_SocialTrafficAnnotations != nil)
    {
        [m_SocialTrafficAnnotations removeAllObjects];
    }
}

-(void)__RemoveTaxiMessageAnnotations
{
    if(m_TaxiMessageAnnotations != nil)
    {
        [m_TaxiMessageAnnotations removeAllObjects];
    }
}

-(void)__RemoveSocialTrafficAnnotations
{
    if(m_SocialTrafficAnnotations != nil)
    {
        [m_SocialTrafficAnnotations removeAllObjects];
    }
}


-(BOOL)CheckAnnotationExist:(NSString*)szID
{
/*
    for(NOMWatchMapAnnotation* pAnnotation in m_Annotations)
    {
        if(pAnnotation != nil && pAnnotation.m_AnnotationID != nil && [pAnnotation.m_AnnotationID isEqualToString:szID] == YES)
        {
            return YES;
        }
    }
*/
    return NO;
}

-(void)AddMapViewAnnotationByType:(int16_t)nAnnotationType at:(CLLocationCoordinate2D)point
{
    UIImage* pImage = [NOMWatchResourceHelper GetWatchAnnotationImageFromType:nAnnotationType];
    if(pImage == nil)
    {
        [self.m_MapView addAnnotation:point withPinColor:WKInterfaceMapPinColorRed];
        return;
    }
    [self.m_MapView addAnnotation:point withImage:pImage centerOffset:CGPointMake(0, pImage.size.height*(-0.5))];
    [self.m_MapView setHidden:YES];
    [self.m_MapView setHidden:NO];
    [self.m_MapView setAlpha:0.8];
    [self.m_MapView setAlpha:1.0];
    
    //[self.m_MapView addAnnotation:point withImageNamed:@"pinsrc.png" centerOffset:CGPointMake(0, 0)];
    

/*
    //Testing
    if(NOM_WATCH_ANNOTATION_TRAFFIC_FIRST <= nAnnotationType && nAnnotationType <= NOM_WATCH_ANNOTATION_TRAFFIC_LAST)
    {
        [self.m_MapView addAnnotation:point withPinColor:WKInterfaceMapPinColorRed];
#if DEBUG
        NSLog(@"AddMapViewAnnotationByType:Red type = %i", nAnnotationType);
#endif
    }
    else if(NOM_WATCH_ANNOTATION_SPOT_FIRST <= nAnnotationType && nAnnotationType <= NOM_WATCH_ANNOTATION_SPOT_LAST)
    {
        [self.m_MapView addAnnotation:point withPinColor:WKInterfaceMapPinColorGreen];
#if DEBUG
        NSLog(@"AddMapViewAnnotationByType:Green type = %i", nAnnotationType);
#endif
    }
    else if(NOM_WATCH_ANNOTATION_TAXI_FIRST <= nAnnotationType && nAnnotationType <= NOM_WATCH_ANNOTATION_TAXI_LAST)
    {
        [self.m_MapView addAnnotation:point withPinColor:WKInterfaceMapPinColorPurple];
#if DEBUG
        NSLog(@"AddMapViewAnnotationByType:Purple type = %i", nAnnotationType);
#endif
    }

    //?????????????????
    //????????????????
    else
    {
        [self.m_MapView addAnnotation:point withPinColor:WKInterfaceMapPinColorGreen];
#if DEBUG
        NSLog(@"AddMapViewAnnotationByType:Green unknow type");
#endif
    }
*/
}

-(void)AddMapViewAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(AddMapViewAnnotation:) withObject:pAnnotation waitUntilDone:NO];
        return;
    }
    
/*
#if DEBUG
    NSLog(@"AddMapViewAnnotation Begin:type = %i", pAnnotation.m_AnnotationType);
    NSLog(@"m_dLatitude:%f", m_dLatitude);
    NSLog(@"m_dLongitude:%f", m_dLongitude);
    NSLog(@"m_dSpan:%f", m_dSpan);
    NSLog(@"m_dLatitudeStart:%f", m_dLatitudeStart);
    NSLog(@"m_dLatitudeEnd:%f", m_dLatitudeEnd);
    NSLog(@"m_dLongitudeStart:%f", m_dLongitudeStart);
    NSLog(@"m_dLongitudeEnd:%f", m_dLongitudeEnd);
    NSLog(@"pAnnotation.m_Latitude:%f", pAnnotation.m_Latitude);
    NSLog(@"pAnnotation.m_Longitude:%f", pAnnotation.m_Longitude);
#endif
*/
    if(m_dLatitudeStart <= pAnnotation.m_Latitude && pAnnotation.m_Latitude <= m_dLatitudeEnd &&
       m_dLongitudeStart <= pAnnotation.m_Longitude && pAnnotation.m_Longitude <= m_dLongitudeEnd)
    {
        CLLocationCoordinate2D point;
        point.latitude = pAnnotation.m_Latitude;
        point.longitude = pAnnotation.m_Longitude;
        [self AddMapViewAnnotationByType:pAnnotation.m_AnnotationType at:point];
#if DEBUG
        NSLog(@"AddMapViewAnnotation called and put into mapview:%i", pAnnotation.m_AnnotationType);
#endif
    }
#if DEBUG
    else
    {
        NSLog(@"AddMapViewAnnotation Annotation is not in visible area");
    }
#endif
}

-(void)MapViewLoadAnnotations
{
/*
    if(m_Annotations && 0 < m_Annotations.count)
    {
        for(NOMWatchMapAnnotation* pAnnotation in m_Annotations)
        {
            if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
            {
                [self AddMapViewAnnotation:pAnnotation];
            }
        }
    }
*/
    
    if(m_PhotoRadarAnnotations && 0 < m_PhotoRadarAnnotations.count)
    {
        for(NOMWatchMapAnnotation* pAnnotation in m_PhotoRadarAnnotations)
        {
            if(pAnnotation != nil /*&& pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID*/)
            {
                [self AddMapViewAnnotation:pAnnotation];
            }
        }
    }
   
    if(m_GasStationAnnotations && 0 < m_GasStationAnnotations.count)
    {
        for(NOMWatchMapAnnotation* pAnnotation in m_GasStationAnnotations)
        {
            if(pAnnotation != nil /*&& pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID*/)
            {
                [self AddMapViewAnnotation:pAnnotation];
            }
        }
    }

    if(m_SchoolZoneAnnotations && 0 < m_SchoolZoneAnnotations.count)
    {
        for(NOMWatchMapAnnotation* pAnnotation in m_SchoolZoneAnnotations)
        {
            if(pAnnotation != nil /*&& pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID*/)
            {
                [self AddMapViewAnnotation:pAnnotation];
            }
        }
    }

    if(m_PlayGroundAnnotations && 0 < m_PlayGroundAnnotations.count)
    {
        for(NOMWatchMapAnnotation* pAnnotation in m_PlayGroundAnnotations)
        {
            if(pAnnotation != nil /*&& pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID*/)
            {
                [self AddMapViewAnnotation:pAnnotation];
            }
        }
    }

    if(m_ParkingGroundAnnotations && 0 < m_ParkingGroundAnnotations.count)
    {
        for(NOMWatchMapAnnotation* pAnnotation in m_ParkingGroundAnnotations)
        {
            if(pAnnotation != nil /*&& pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID*/)
            {
                [self AddMapViewAnnotation:pAnnotation];
            }
        }
    }

    if(m_TrafficMessageAnnotations && 0 < m_TrafficMessageAnnotations.count)
    {
        for(NOMWatchMapAnnotation* pAnnotation in m_TrafficMessageAnnotations)
        {
            if(pAnnotation != nil /*&& pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID*/)
            {
                [self AddMapViewAnnotation:pAnnotation];
            }
        }
    }
    
    if(m_TaxiMessageAnnotations && 0 < m_TaxiMessageAnnotations.count)
    {
        for(NOMWatchMapAnnotation* pAnnotation in m_TaxiMessageAnnotations)
        {
            if(pAnnotation != nil /*&& pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID*/)
            {
                [self AddMapViewAnnotation:pAnnotation];
            }
        }
    }

    if(m_SocialTrafficAnnotations && 0 < m_SocialTrafficAnnotations.count)
    {
        for(NOMWatchMapAnnotation* pAnnotation in m_SocialTrafficAnnotations)
        {
            if(pAnnotation != nil /*&& pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID*/)
            {
                [self AddMapViewAnnotation:pAnnotation];
            }
        }
    }
}

-(void)SetMapViewLimit
{
    m_dLatitudeStart = m_dLatitude - m_dSpan;
    m_dLatitudeEnd = m_dLatitude + m_dSpan;
    m_dLongitudeStart = m_dLongitude - m_dSpan;
    m_dLongitudeEnd = m_dLongitude + m_dSpan;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        m_bLoadDataFromMainApp = NO;
        // Initialize variables here.
        // Configure interface objects here.
        
        //m_Annotations = [[NSMutableArray alloc] init];
        m_PhotoRadarAnnotations = [[NSMutableArray alloc] init];
        m_GasStationAnnotations = [[NSMutableArray alloc] init];
        m_SchoolZoneAnnotations = [[NSMutableArray alloc] init];
        m_PlayGroundAnnotations = [[NSMutableArray alloc] init];
        m_ParkingGroundAnnotations = [[NSMutableArray alloc] init];
        
        m_TrafficMessageAnnotations = [[NSMutableArray alloc] init];
        m_TaxiMessageAnnotations = [[NSMutableArray alloc] init];
        m_SocialTrafficAnnotations = [[NSMutableArray alloc] init];
        
        
        m_ActionsChoiceControllerIdentifier = @"nycWatchActionsChoiceController";
        m_AlertControllerIdentifier = @"nycWatchAlertController";
        [[NYCCommunicationManager GetCommunicationManager] RegisterWatchController:self];
        
        m_dLatitude = 40.759221;
        m_dLongitude = -73.984638;
        m_dSpan = [NOMAppWatchDataHelper GetDefaultWatchMapViewMaxSpan];
        [self SetMapViewLimit];
    }
    
    return self;
}

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    // Configure interface objects here.
    [[NYCCommunicationManager GetCommunicationManager] RegisterWatchController:self];
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [[NYCCommunicationManager GetCommunicationManager] RegisterWatchController:self];
    [super willActivate];

    /*BOOL didOpenParent = */
    
    MKCoordinateRegion region;
    region.center.latitude = m_dLatitude;
    region.center.longitude = m_dLongitude;
    region.span.latitudeDelta = m_dSpan;
    region.span.longitudeDelta = m_dSpan;
    [self.m_MapView setRegion:region];
    [self SetMapViewLimit];
    
    //???
    //[self.m_MapView removeAllAnnotations];
    
    if([InterfaceController GetForceCleanupMapViewFlag] == YES)
    {
        [self.m_MapView removeAllAnnotations];
        [self.m_MapView removeAllAnnotations];
        // [m_Annotations removeAllObjects];
        [self __RemovePhotoRadarAnnotations];
        [self __RemoveGasStationAnnotations];
        [self __RemoveSchoolZoneAnnotations];
        [self __RemovePlayGroundAnnotations];
        [self __RemoveParkingGroundAnnotations];
        
        [self __RemoveTrafficMessageAnnotations];
        [self __RemoveTaxiMessageAnnotations];
        [self __RemoveSocialTrafficAnnotations];
    }
    
    [InterfaceController SetForceCleanupMapViewFlag:NO];
    
     
    if(m_bLoadDataFromMainApp == NO)
    {
        m_bLoadDataFromMainApp = YES;
        //[self RemoveAllAnnotations];
        NSDictionary *openAppData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     EMSG_MSG_INITIALIZE_OPEN_MAINAPP, EMSG_KEY_OPENCONTAINERAPP_ID,
                                     nil];
        
        [WKInterfaceController openParentApplication:openAppData reply:^(NSDictionary *replyInfo, NSError *error)
         {
             if(error == nil && replyInfo != nil)
             {
                 [self InitializeWithMainReplyData:replyInfo withRemovePeviousObject:NO withEmptyAlert:NO];
             }
         }];
    }
    //if(didOpenParent == YES)
    //    [self MapViewLoadAnnotations];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    //????[self RemoveAllAnnotations];
    m_bLoadDataFromMainApp = YES;
    [super didDeactivate];
}

-(void)SetMapViewVisableRegionSpan:(double)dSpan
{
    m_dSpan = dSpan;
    MKCoordinateRegion region;
    region.center.latitude = m_dLatitude;
    region.center.longitude = m_dLongitude;
    region.span.latitudeDelta = m_dSpan;
    region.span.longitudeDelta = m_dSpan;
    [self.m_MapView setRegion:region];
    [self SetMapViewLimit];
    [self.m_MapView removeAllAnnotations];
    [self MapViewLoadAnnotations];
}

-(double)GetMapViewCenterLatitude
{
    return m_dLatitude;
}

-(double)GetMapViewCenterLongitude
{
    return m_dLongitude;
}

- (IBAction)onMenuShareEvent
{
    int16_t nAction = NOM_WATCH_ACTION_POST;
    NSNumber* pAction = [[NSNumber alloc] initWithInt:nAction];
    [self pushControllerWithName:m_ActionsChoiceControllerIdentifier context:pAction];
}

- (IBAction)onMenuSearchEvent
{
    int16_t nAction = NOM_WATCH_ACTION_SEARCH;
    NSNumber* pAction = [[NSNumber alloc] initWithInt:nAction];
    [self pushControllerWithName:m_ActionsChoiceControllerIdentifier context:pAction];
}

- (IBAction)onMenuCancelEvent
{
    return;
}

- (IBAction)onMenuCurrentLocationEvent
{
    [[NYCCommunicationManager GetCommunicationManager] SendCurrentLocationRequestToMainApp];
    return;
}

-(void)ShowAlertMessage:(NSString*)szAlertMessage
{
    [self pushControllerWithName:m_AlertControllerIdentifier context:szAlertMessage];
}

//
//MainApp/Watch messaging handler functions
//
-(void)SetMapViewCenter:(double)dLatiude withLongitude:(double)dLongitude
{
    MKCoordinateRegion region;
    m_dLatitude = dLatiude;
    m_dLongitude = dLongitude;
    region.center.latitude = m_dLatitude;
    region.center.longitude = m_dLongitude;
    region.span.latitudeDelta = m_dSpan;
    region.span.longitudeDelta = m_dSpan;
    [self.m_MapView setRegion:region];
    [self SetMapViewLimit];
//??    [self.m_MapView removeAllAnnotations];
//??    [self MapViewLoadAnnotations];
}

/*
-(void)AsynAddAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    NSLog(@"AsynAddAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_Annotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
}


-(void)AddAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    NSLog(@"AddAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_Annotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
    
 
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    //dispatch_async(queue, ^(void)
    //{
    //    [self AsynAddAnnotation:pAnnotation];
    //});
 
}
*/

-(void)AsynRemoveAllAnnotations
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(AsynRemoveAllAnnotations) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self.m_MapView removeAllAnnotations];
    //[self.m_MapView s]
   // [m_Annotations removeAllObjects];
    [self __RemovePhotoRadarAnnotations];
    [self __RemoveGasStationAnnotations];
    [self __RemoveSchoolZoneAnnotations];
    [self __RemovePlayGroundAnnotations];
    [self __RemoveParkingGroundAnnotations];
    
    [self __RemoveTrafficMessageAnnotations];
    [self __RemoveTaxiMessageAnnotations];
    [self __RemoveSocialTrafficAnnotations];
}

-(void)RemoveAllAnnotations
{
/*
    [self.m_MapView removeAllAnnotations];
    [m_Annotations removeAllObjects];
*/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self AsynRemoveAllAnnotations];
    });
}

-(void)AsynRemoveTrafficAnnotations
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(AsynRemoveTrafficAnnotations) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self.m_MapView removeAllAnnotations];
    [self __RemoveTrafficMessageAnnotations];
    [self __RemoveSocialTrafficAnnotations];
    [self MapViewLoadAnnotations];
}

-(void)RemoveTrafficAnnotations
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self AsynRemoveTrafficAnnotations];
    });
}

-(void)AsynRemoveSpotAnnotations
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(AsynRemoveSpotAnnotations) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self.m_MapView removeAllAnnotations];
    [self __RemovePhotoRadarAnnotations];
    [self __RemoveGasStationAnnotations];
    [self __RemoveSchoolZoneAnnotations];
    [self __RemovePlayGroundAnnotations];
    [self __RemoveParkingGroundAnnotations];
    [self MapViewLoadAnnotations];
}

-(void)RemoveSpotAnnotations
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self AsynRemoveSpotAnnotations];
    });
}

-(void)AsynRemoveTaxiAnnotations
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(AsynRemoveTaxiAnnotations) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self.m_MapView removeAllAnnotations];
    [self __RemoveTaxiMessageAnnotations];
    [self MapViewLoadAnnotations];
}

-(void)RemoveTaxiAnnotations
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self AsynRemoveTaxiAnnotations];
    });
}

/**********************************************************************/
//
//Adding Traffic Messages
//
/**********************************************************************/
-(void)AsynAddTrafficAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    assert(pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID);
    NSLog(@"AsynAddTrafficAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_TrafficMessageAnnotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
}

-(BOOL)IsTrafficMessageAnnotationIsExisted:(NSString*)szID
{
    for(NOMWatchMapAnnotation* pAnnotation in m_TrafficMessageAnnotations)
    {
        if(pAnnotation != nil && pAnnotation.m_AnnotationID != nil && [pAnnotation.m_AnnotationID isEqualToString:szID] == YES)
        {
            return YES;
        }
    }
    return NO;
}

-(void)HandleTrafficMessageAnnotationFromDictionary:(NSDictionary*)pKeyData
{
    if(pKeyData)
    {
        NSString* szID = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONID];
        if(szID != nil && 0 < szID.length &&[self CheckAnnotationExist:szID] == NO && [self IsTrafficMessageAnnotationIsExisted:szID] == NO)
        {
            NSNumber* pLatitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLATITUDE];
            NSNumber* pLongitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
            double   dLatiude = (double)[pLatitude doubleValue];
            double   dLongitude = (double)[pLongitude doubleValue];
            
            NSNumber* pType = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONTYPE];
            int16_t   nType = (int16_t)[pType intValue];
            
            NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
            pAnnotation.m_AnnotationID = szID;
            pAnnotation.m_AnnotationType = nType;
            pAnnotation.m_Latitude = dLatiude;
            pAnnotation.m_Longitude = dLongitude;
            [self AsynAddTrafficAnnotation:pAnnotation];
        }
    }
}

-(void)AsynAddTrafficMessage:(NSArray*)pAnnotations
{
    for(NSDictionary* pKeyData in pAnnotations)
    {
        if(pKeyData  != nil)
        {
            [self HandleTrafficMessageAnnotationFromDictionary:pKeyData];
        }
    }
}

-(void)AddTrafficMessage:(NSArray*)pAnnotations
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^(void)
//    {
        [self AsynAddTrafficMessage:pAnnotations];
//    });
}
/**********************************************************************/
/**********************************************************************/


/**********************************************************************/
//
//Adding Taxi Messages
//
/**********************************************************************/
-(void)AsynAddTaxiAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    assert(pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID);
    NSLog(@"AsynAddTaxiAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_TaxiMessageAnnotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
}

-(BOOL)IsTaxiAnnotationIsExisted:(NSString*)szID
{
    for(NOMWatchMapAnnotation* pAnnotation in m_TaxiMessageAnnotations)
    {
        if(pAnnotation != nil && pAnnotation.m_AnnotationID != nil && [pAnnotation.m_AnnotationID isEqualToString:szID] == YES)
        {
            return YES;
        }
    }
    return NO;
}

-(void)HandleTaxiMessageAnnotationFromDictionary:(NSDictionary*)pKeyData
{
    if(pKeyData)
    {
        NSString* szID = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONID];
        if(szID != nil && 0 < szID.length &&[self CheckAnnotationExist:szID] == NO && [self IsTaxiAnnotationIsExisted:szID] == NO)
        {
            NSNumber* pLatitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLATITUDE];
            NSNumber* pLongitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
            double   dLatiude = (double)[pLatitude doubleValue];
            double   dLongitude = (double)[pLongitude doubleValue];
            
            NSNumber* pType = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONTYPE];
            int16_t   nType = (int16_t)[pType intValue];
            
            NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
            pAnnotation.m_AnnotationID = szID;
            pAnnotation.m_AnnotationType = nType;
            pAnnotation.m_Latitude = dLatiude;
            pAnnotation.m_Longitude = dLongitude;
            [self AsynAddTaxiAnnotation:pAnnotation];
        }
    }
}

-(void)AsynAddTaxiMessage:(NSArray*)pAnnotations
{
    for(NSDictionary* pKeyData in pAnnotations)
    {
        if(pKeyData  != nil)
        {
            [self HandleTaxiMessageAnnotationFromDictionary:pKeyData];
        }
    }
}

-(void)AddTaxiMessage:(NSArray*)pAnnotations
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^(void)
//    {
        [self AsynAddTaxiMessage:pAnnotations];
//    });
}
/**********************************************************************/
/**********************************************************************/


/**********************************************************************/
//
//Adding Traffic Message From Social Media
//
/**********************************************************************/
-(void)AsynAddSocialTrafficAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    assert(pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID);
    NSLog(@"AsynAddSocialTrafficAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_SocialTrafficAnnotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
}

-(BOOL)IsSocialTrafficAnnotationIsExisted:(NSString*)szID
{
    for(NOMWatchMapAnnotation* pAnnotation in m_SocialTrafficAnnotations)
    {
        if(pAnnotation != nil && pAnnotation.m_AnnotationID != nil && [pAnnotation.m_AnnotationID isEqualToString:szID] == YES)
        {
            return YES;
        }
    }
    return NO;
}


-(void)HandleSocialTrafficMessageAnnotationFromDictionary:(NSDictionary*)pKeyData
{
    if(pKeyData)
    {
        NSString* szID = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONID];
        if(szID != nil && 0 < szID.length &&[self CheckAnnotationExist:szID] == NO && [self IsSocialTrafficAnnotationIsExisted:szID] == NO)
        {
            NSNumber* pLatitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLATITUDE];
            NSNumber* pLongitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
            double   dLatiude = (double)[pLatitude doubleValue];
            double   dLongitude = (double)[pLongitude doubleValue];
            
            NSNumber* pType = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONTYPE];
            int16_t   nType = (int16_t)[pType intValue];
            
            NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
            pAnnotation.m_AnnotationID = szID;
            pAnnotation.m_AnnotationType = nType;
            pAnnotation.m_Latitude = dLatiude;
            pAnnotation.m_Longitude = dLongitude;
            [self AsynAddSocialTrafficAnnotation:pAnnotation];
        }
    }
}

-(void)AsynAddSocialTrafficMessage:(NSArray*)pAnnotations
{
    for(NSDictionary* pKeyData in pAnnotations)
    {
        if(pKeyData  != nil)
        {
            [self HandleSocialTrafficMessageAnnotationFromDictionary:pKeyData];
        }
    }
}

-(void)AddSocialTrafficMessage:(NSArray*)pAnnotations
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^(void)
//    {
        [self AsynAddSocialTrafficMessage:pAnnotations];
//    });
}
/**********************************************************************/
/**********************************************************************/

/**********************************************************************/
//
//Adding Gas Station list
//
/**********************************************************************/
-(void)AsynAddGasStationAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    assert(pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID);
    NSLog(@"AsynAddGasStationAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_GasStationAnnotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
}

-(BOOL)IsGasStationAnnotationIsExisted:(NSString*)szID
{
    for(NOMWatchMapAnnotation* pAnnotation in m_GasStationAnnotations)
    {
        if(pAnnotation != nil && pAnnotation.m_AnnotationID != nil && [pAnnotation.m_AnnotationID isEqualToString:szID] == YES)
        {
            return YES;
        }
    }
    return NO;
}

-(void)HandleGasStationAnnotationFromDictionary:(NSDictionary*)pKeyData
{
    if(pKeyData)
    {
        NSString* szID = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONID];
        if(szID != nil && 0 < szID.length &&[self CheckAnnotationExist:szID] == NO && [self IsGasStationAnnotationIsExisted:szID] == NO)
        {
            NSNumber* pLatitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLATITUDE];
            NSNumber* pLongitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
            double   dLatiude = (double)[pLatitude doubleValue];
            double   dLongitude = (double)[pLongitude doubleValue];
            
            NSNumber* pType = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONTYPE];
            int16_t   nType = (int16_t)[pType intValue];
            
            NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
            pAnnotation.m_AnnotationID = szID;
            pAnnotation.m_AnnotationType = nType;
            pAnnotation.m_Latitude = dLatiude;
            pAnnotation.m_Longitude = dLongitude;
            [self AsynAddGasStationAnnotation:pAnnotation];
        }
    }
}

-(void)AsynAddGasStationList:(NSArray*)pAnnotations
{
    for(NSDictionary* pKeyData in pAnnotations)
    {
        if(pKeyData  != nil)
        {
            [self HandleGasStationAnnotationFromDictionary:pKeyData];
        }
    }
}

-(void)AddGasStationList:(NSArray*)pAnnotations
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^(void)
//    {
        [self AsynAddGasStationList:pAnnotations];
//    });
}
/**********************************************************************/
/**********************************************************************/


/**********************************************************************/
//
//Adding Gas Station list
//
/**********************************************************************/
-(void)AsynAddPhotoRadarAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    assert(pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID);
    NSLog(@"AsynAddPhotoRadarAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_PhotoRadarAnnotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
}

-(BOOL)IsPhotoRadarAnnotationIsExisted:(NSString*)szID
{
    for(NOMWatchMapAnnotation* pAnnotation in m_PhotoRadarAnnotations)
    {
        if(pAnnotation != nil && pAnnotation.m_AnnotationID != nil && [pAnnotation.m_AnnotationID isEqualToString:szID] == YES)
        {
            return YES;
        }
    }
    return NO;
}

-(void)HandlePhotoRadarAnnotationFromDictionary:(NSDictionary*)pKeyData
{
    if(pKeyData)
    {
        NSString* szID = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONID];
        if(szID != nil && 0 < szID.length &&[self CheckAnnotationExist:szID] == NO && [self IsPhotoRadarAnnotationIsExisted:szID] == NO)
        {
            NSNumber* pLatitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLATITUDE];
            NSNumber* pLongitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
            double   dLatiude = (double)[pLatitude doubleValue];
            double   dLongitude = (double)[pLongitude doubleValue];
            
            NSNumber* pType = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONTYPE];
            int16_t   nType = (int16_t)[pType intValue];
            
            NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
            pAnnotation.m_AnnotationID = szID;
            pAnnotation.m_AnnotationType = nType;
            pAnnotation.m_Latitude = dLatiude;
            pAnnotation.m_Longitude = dLongitude;
            [self AsynAddPhotoRadarAnnotation:pAnnotation];
        }
    }
}

-(void)AsynAddPhotoRadarList:(NSArray*)pAnnotations
{
    for(NSDictionary* pKeyData in pAnnotations)
    {
        if(pKeyData  != nil)
        {
            [self HandlePhotoRadarAnnotationFromDictionary:pKeyData];
        }
    }
}

-(void)AddPhotoRadarList:(NSArray*)pAnnotations
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^(void)
//    {
        [self AsynAddPhotoRadarList:pAnnotations];
//    });
}
/**********************************************************************/
/**********************************************************************/


/**********************************************************************/
//
//Adding School Zone list
//
/**********************************************************************/
-(void)AsynAddSchoolZoneAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    assert(pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID);
    NSLog(@"AsynAddSchoolZoneAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_SchoolZoneAnnotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
}

-(BOOL)IsSchoolZoneAnnotationIsExisted:(NSString*)szID
{
    for(NOMWatchMapAnnotation* pAnnotation in m_SchoolZoneAnnotations)
    {
        if(pAnnotation != nil && pAnnotation.m_AnnotationID != nil && [pAnnotation.m_AnnotationID isEqualToString:szID] == YES)
        {
            return YES;
        }
    }
    return NO;
}


-(void)HandleSchoolZoneAnnotationFromDictionary:(NSDictionary*)pKeyData
{
    if(pKeyData)
    {
        NSString* szID = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONID];
        if(szID != nil && 0 < szID.length &&[self CheckAnnotationExist:szID] == NO && [self IsSchoolZoneAnnotationIsExisted:szID] == NO)
        {
            NSNumber* pLatitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLATITUDE];
            NSNumber* pLongitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
            double   dLatiude = (double)[pLatitude doubleValue];
            double   dLongitude = (double)[pLongitude doubleValue];
            
            NSNumber* pType = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONTYPE];
            int16_t   nType = (int16_t)[pType intValue];
            
            NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
            pAnnotation.m_AnnotationID = szID;
            pAnnotation.m_AnnotationType = nType;
            pAnnotation.m_Latitude = dLatiude;
            pAnnotation.m_Longitude = dLongitude;
            [self AsynAddSchoolZoneAnnotation:pAnnotation];
        }
    }
}

-(void)AsynAddSchoolZoneList:(NSArray*)pAnnotations
{
    for(NSDictionary* pKeyData in pAnnotations)
    {
        if(pKeyData  != nil)
        {
            [self HandleSchoolZoneAnnotationFromDictionary:pKeyData];
        }
    }
}

-(void)AddSchoolZoneList:(NSArray*)pAnnotations
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^(void)
//    {
        [self AsynAddSchoolZoneList:pAnnotations];
//    });
}
/**********************************************************************/
/**********************************************************************/


/**********************************************************************/
//
//Adding Playground list
//
/**********************************************************************/
-(void)AsynAddPlayGroundAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    assert(pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID);
    NSLog(@"AsynAddPlayGroundAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_PlayGroundAnnotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
}

-(BOOL)IsPlayGroundAnnotationIsExisted:(NSString*)szID
{
    for(NOMWatchMapAnnotation* pAnnotation in m_PlayGroundAnnotations)
    {
        if(pAnnotation != nil && pAnnotation.m_AnnotationID != nil && [pAnnotation.m_AnnotationID isEqualToString:szID] == YES)
        {
            return YES;
        }
    }
    return NO;
}

-(void)HandlePlayGroundAnnotationFromDictionary:(NSDictionary*)pKeyData
{
    if(pKeyData)
    {
        NSString* szID = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONID];
        if(szID != nil && 0 < szID.length &&[self CheckAnnotationExist:szID] == NO && [self IsPlayGroundAnnotationIsExisted:szID] == NO)
        {
            NSNumber* pLatitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLATITUDE];
            NSNumber* pLongitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
            double   dLatiude = (double)[pLatitude doubleValue];
            double   dLongitude = (double)[pLongitude doubleValue];
            
            NSNumber* pType = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONTYPE];
            int16_t   nType = (int16_t)[pType intValue];
            
            NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
            pAnnotation.m_AnnotationID = szID;
            pAnnotation.m_AnnotationType = nType;
            pAnnotation.m_Latitude = dLatiude;
            pAnnotation.m_Longitude = dLongitude;
            [self AsynAddPlayGroundAnnotation:pAnnotation];
        }
    }
}

-(void)AsynAddPlayGroundList:(NSArray*)pAnnotations
{
    for(NSDictionary* pKeyData in pAnnotations)
    {
        if(pKeyData  != nil)
        {
            [self HandlePlayGroundAnnotationFromDictionary:pKeyData];
        }
    }
}

-(void)AddPlayGroundList:(NSArray*)pAnnotations
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^(void)
//    {
        [self AsynAddPlayGroundList:pAnnotations];
//    });
}
/**********************************************************************/
/**********************************************************************/


/**********************************************************************/
//
//Adding Parking Ground list
//
/**********************************************************************/
-(void)AsynAddParkingGroundAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
#if DEBUG
    assert(pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID);
    NSLog(@"AsynAddParkingGroundAnnotation called:%i", pAnnotation.m_AnnotationType);
#endif
    if(pAnnotation != nil && pAnnotation.m_AnnotationType != NOM_WATCH_ANNOTATION_INVALID)
    {
        [m_ParkingGroundAnnotations addObject:pAnnotation];
        [self AddMapViewAnnotation:pAnnotation];
    }
}

-(BOOL)IsParkingGroundAnnotationIsExisted:(NSString*)szID
{
     for(NOMWatchMapAnnotation* pAnnotation in m_ParkingGroundAnnotations)
     {
         if(pAnnotation != nil && pAnnotation.m_AnnotationID != nil && [pAnnotation.m_AnnotationID isEqualToString:szID] == YES)
         {
             return YES;
         }
     }
    return NO;
}

-(void)HandleParkingGroundAnnotationFromDictionary:(NSDictionary*)pKeyData
{
    if(pKeyData)
    {
        NSString* szID = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONID];
        if(szID != nil && 0 < szID.length &&[self CheckAnnotationExist:szID] == NO && [self IsParkingGroundAnnotationIsExisted:szID] == NO)
        {
            NSNumber* pLatitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLATITUDE];
            NSNumber* pLongitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
            double   dLatiude = (double)[pLatitude doubleValue];
            double   dLongitude = (double)[pLongitude doubleValue];
            
            NSNumber* pType = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONTYPE];
            int16_t   nType = (int16_t)[pType intValue];
            
            NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
            pAnnotation.m_AnnotationID = szID;
            pAnnotation.m_AnnotationType = nType;
            pAnnotation.m_Latitude = dLatiude;
            pAnnotation.m_Longitude = dLongitude;
            [self AsynAddParkingGroundAnnotation:pAnnotation];
        }
    }
}

-(void)AsynAddParkingGroundList:(NSArray*)pAnnotations
{
    for(NSDictionary* pKeyData in pAnnotations)
    {
        if(pKeyData  != nil)
        {
            [self HandleParkingGroundAnnotationFromDictionary:pKeyData];
        }
    }
}

-(void)AddParkingGroundList:(NSArray*)pAnnotations
{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^(void)
//    {
        [self AsynAddParkingGroundList:pAnnotations];
//    });
}
/**********************************************************************/
/**********************************************************************/

-(void)InitializeWithMainReplyData:(NSDictionary*)replyInfo withRemovePeviousObject:(BOOL)bRemove withEmptyAlert:(BOOL)bShow
{
    //???????
    if(bRemove == YES)
    {
        [self.m_MapView removeAllAnnotations];
        [self.m_MapView setAlpha:0.8];
        [self.m_MapView setAlpha:1.0];
    
        [self __RemovePhotoRadarAnnotations];
        [self __RemoveGasStationAnnotations];
        [self __RemoveSchoolZoneAnnotations];
        [self __RemovePlayGroundAnnotations];
        [self __RemoveParkingGroundAnnotations];
    
        [self __RemoveTrafficMessageAnnotations];
        [self __RemoveTaxiMessageAnnotations];
        [self __RemoveSocialTrafficAnnotations];
    }
    //????
    
    
    NSNumber* pLatitude = [replyInfo objectForKey:EMSG_KEY_LOCATIONLATITUDE];
    NSNumber* pLongitude = [replyInfo objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
    
    //Center
    if(pLatitude != nil && pLongitude != nil)
    {
        double   dLatiude = (double)[pLatitude doubleValue];
        double   dLongitude = (double)[pLongitude doubleValue];
        [self SetMapViewCenter:dLatiude withLongitude:dLongitude];
    }
    
    //
    //Traffic
    NSArray* trafficMessages = [replyInfo objectForKey:EMSG_KEY_TRAFFICMESSAGE];
    if(trafficMessages && 0 < trafficMessages.count)
    {
        [self AddTrafficMessage:trafficMessages];
    }
    
    //Social Traffic
    NSArray* socialTrafficMessages = [replyInfo objectForKey:EMSG_KEY_SOCIALTRAFFICMESSAGE];
    if(socialTrafficMessages && 0 < socialTrafficMessages.count)
    {
        [self AddSocialTrafficMessage:socialTrafficMessages];
    }
    
    //Taxi
    NSArray* taxiMessages = [replyInfo objectForKey:EMSG_KEY_TAXIMESSAGE];
    if(taxiMessages && 0 < taxiMessages.count)
    {
        [self AddTaxiMessage:taxiMessages];
    }
    
    //Gas Station
    NSArray* gasMessages = [replyInfo objectForKey:EMSG_KEY_GASSTATIONLIST];
    if(gasMessages && 0 < gasMessages.count)
    {
        [self AddGasStationList:gasMessages];
    }

    //Photo Radar
    NSArray* cameraMessages = [replyInfo objectForKey:EMSG_KEY_PHOTORADARLIST];
    if(cameraMessages && 0 < cameraMessages.count)
    {
        [self AddPhotoRadarList:cameraMessages];
    }

    //School Zone
    NSArray* schoolMessages = [replyInfo objectForKey:EMSG_KEY_SCHOOLZONELIST];
    if(schoolMessages && 0 < schoolMessages.count)
    {
        [self AddSchoolZoneList:schoolMessages];
    }

    //Play Ground
    NSArray* playMessages = [replyInfo objectForKey:EMSG_KEY_PLAYGROUNDLIST];
    if(playMessages && 0 < playMessages.count)
    {
        [self AddPlayGroundList:schoolMessages];
    }

    //Paring ground
    NSArray* parkingMessages = [replyInfo objectForKey:EMSG_KEY_PARKINGGROUNDLIST];
    if(parkingMessages && 0 < parkingMessages.count)
    {
        [self AddParkingGroundList:parkingMessages];
    }
    
    if([self HasObjects] == NO)
    {
        [[NYCCommunicationManager GetCommunicationManager] SendGeneralRequestToMainApp];
        if(bShow == YES)
        {
            [self ShowAlertMessage:@"Empty search result!"];
        }
    }
}

-(void)HandlePostAnnotation:(NSDictionary*)pKeyData withRemovePeviousObject:(BOOL)bRemove
{
    //???????
    if(bRemove == YES)
    {
        [self.m_MapView removeAllAnnotations];
        [self.m_MapView setAlpha:0.8];
        [self.m_MapView setAlpha:1.0];
        
        [self __RemovePhotoRadarAnnotations];
        [self __RemoveGasStationAnnotations];
        [self __RemoveSchoolZoneAnnotations];
        [self __RemovePlayGroundAnnotations];
        [self __RemoveParkingGroundAnnotations];
        
        [self __RemoveTrafficMessageAnnotations];
        [self __RemoveTaxiMessageAnnotations];
        [self __RemoveSocialTrafficAnnotations];
    }
    //????
    
    if(pKeyData)
    {
        NSString* szID = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONID];
        if(szID != nil && 0 < szID.length &&[self CheckAnnotationExist:szID] == NO && [self IsSocialTrafficAnnotationIsExisted:szID] == NO)
        {
            NSNumber* pLatitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLATITUDE];
            NSNumber* pLongitude = [pKeyData objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
            double   dLatiude = (double)[pLatitude doubleValue];
            double   dLongitude = (double)[pLongitude doubleValue];
            
            NSNumber* pType = [pKeyData objectForKey:EMSG_KEY_ANNOTATIONTYPE];
            int16_t   nType = (int16_t)[pType intValue];
            
            NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
            pAnnotation.m_AnnotationID = szID;
            pAnnotation.m_AnnotationType = nType;
            pAnnotation.m_Latitude = dLatiude;
            pAnnotation.m_Longitude = dLongitude;
            if(NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST <= pAnnotation.m_AnnotationType && pAnnotation.m_AnnotationType <= NOM_WATCH_ANNOTATION_TRAFFIC_DC_LAST)
            {
                [self AsynAddTrafficAnnotation:pAnnotation];
            }
            else if(NOM_WATCH_ANNOTATION_TAXI_FIRST <= pAnnotation.m_AnnotationType && pAnnotation.m_AnnotationType <= NOM_WATCH_ANNOTATION_TAXI_LAST)
            {
                [self AsynAddTaxiAnnotation:pAnnotation];
            }
            else if(pAnnotation.m_AnnotationType == NOM_WATCH_ANNOTATION_SPOT_REDLIGHTCAMERA)
            {
                [self AsynAddPhotoRadarAnnotation:pAnnotation];
            }
            else if(pAnnotation.m_AnnotationType == NOM_WATCH_ANNOTATION_SPOT_SPEEDCAMERA)
            {
                [self AsynAddPhotoRadarAnnotation:pAnnotation];
            }
            else if(pAnnotation.m_AnnotationType == NOM_WATCH_ANNOTATION_SPOT_SCHOOLZONE)
            {
                [self AsynAddSchoolZoneAnnotation:pAnnotation];
            }
            else if(pAnnotation.m_AnnotationType == NOM_WATCH_ANNOTATION_SPOT_PLAYGROUND)
            {
                [self AsynAddPlayGroundAnnotation:pAnnotation];
            }
            else if(pAnnotation.m_AnnotationType == NOM_WATCH_ANNOTATION_SPOT_GASSTATION)
            {
                [self AsynAddGasStationAnnotation:pAnnotation];
            }
            else if(pAnnotation.m_AnnotationType == NOM_WATCH_ANNOTATION_SPOT_PARKINGGROUND)
            {
                [self AsynAddParkingGroundAnnotation:pAnnotation];
            }
        }
    }
    
}
@end
