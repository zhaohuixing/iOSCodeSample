//
//  NOMWatchCommunicationManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-04-01.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMWatchCommunicationManager.h"
#import "NOMDocumentController.h"
#import "MMWormhole.h"
#import "NOMAppWatchConstants.h"
#import "StringFactory.h"

@interface NOMWatchCommunicationManager ()
{
    MMWormhole*                 m_ExtensionMessage;
    NOMDocumentController*      m_pDocumentController;
}

-(void)InitializeMessageHandler;

@end

@implementation NOMWatchCommunicationManager

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_pDocumentController = nil;
        m_ExtensionMessage = [[MMWormhole alloc] initWithApplicationGroupIdentifier:EMSG_APPGROUP_NAME optionalDirectory:EMSG_APPMESSAGE_ID];
        
        [self InitializeMessageHandler];
    }
    
    return self;
}

-(id)initWithDcoumentController:(id)document
{
    self = [super init];
    
    if(self != nil)
    {
        m_pDocumentController = document;
        m_ExtensionMessage = [[MMWormhole alloc] initWithApplicationGroupIdentifier:EMSG_APPGROUP_NAME optionalDirectory:EMSG_APPMESSAGE_ID];
        
        [self InitializeMessageHandler];
    }
    
    return self;
}

-(void)RegisterDocumentController:(id)document
{
    if(document != nil && [document isKindOfClass:[NOMDocumentController class]] == YES)
    {
        m_pDocumentController = document;
    }
}

-(void)InitializeMessageHandler
{
#ifdef DEBUG
    [self BroadcastDebugAlertMessage:@"InitializeMessageHandler"];
#endif
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_WATCH_ACTIONEVENT listener:^(id messageObject)
     {
#ifdef DEBUG
         [self BroadcastDebugAlertMessage:@"EMSG_ID_WATCH_ACTIONEVENT"];
#endif
         
         // The number is identified with the buttonNumber key in the message object
         NSNumber* pAction = [messageObject objectForKey:EMSG_KEY_ACTION];
         NSNumber* pChoice = [messageObject objectForKey:EMSG_KEY_ACTIONCHOICE];
         NSNumber* pOption = [messageObject objectForKey:EMSG_KEY_ACTIONOPTION];
         
         int16_t   nAction = (int16_t)[pAction intValue];
         int16_t   nChoice = (int16_t)[pChoice intValue];
         int16_t   nOption = (int16_t)[pOption intValue];

         
         
         if(nAction == NOM_WATCH_ACTION_SEARCH)
         {
#ifdef DEBUG
//             [self BroadcastDebugAlertMessage:@"nAction == NOM_WATCH_ACTION_SEARCH"];
#endif
             if(m_pDocumentController != nil)
             {
                 [m_pDocumentController ProcessWatchSearchRequest:nChoice option:nOption];
             }
         }
         else if(nAction == NOM_WATCH_ACTION_CHOICE_SPOT)
         {
             if(m_pDocumentController != nil)
             {
                 NSNumber* pLatitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLATITUDE];
                 NSNumber* pLongitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
                 
                 double   dLatiude = (double)[pLatitude doubleValue];
                 double   dLongitude = (double)[pLongitude doubleValue];
                 [m_pDocumentController ProcessWatchPostRequest:nChoice option:nOption latitude:dLatiude longitude:dLongitude];
             }
         }
     }];
    
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_WATCH_LOCATIONREQUEST listener:^(id messageObject)
     {
         if(m_pDocumentController != nil)
         {
             [m_pDocumentController ShowMyCurrentLocation];
         }
     }];
    
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_WATCH_GENERALSEARCHREQUEST listener:^(id messageObject)
     {
         if(m_pDocumentController != nil)
         {
             [m_pDocumentController DoGeneralSearchForWatch];
         }
     }];

}

-(void)BroadcastContainerAppRunMode:(BOOL)bBackgroundMode
{
    NSNumber* pAppMode = [[NSNumber alloc] initWithBool:bBackgroundMode];
    
    
    NSDictionary *messageData =   [NSDictionary dictionaryWithObjectsAndKeys:
                                   pAppMode, EMSG_KEY_MAINAPPRUNMODE,
                                   nil];
    
    [m_ExtensionMessage passMessageObject:messageData identifier:EMSG_ID_MAIN_MAINAPPRUNMODE];
}

-(void)BroadcastMapViewCenter:(double)dLatitude withLongitude:(double)dLongitude
{
    NSNumber* pLatitude = [[NSNumber alloc] initWithDouble:dLatitude];
    NSNumber* pLongitude = [[NSNumber alloc] initWithDouble:dLongitude];

    
    NSDictionary *messageData =   [NSDictionary dictionaryWithObjectsAndKeys:
                                   pLatitude, EMSG_KEY_LOCATIONLATITUDE,
                                   pLongitude, EMSG_KEY_LOCATIONLONGITUDE,
                                   nil];
    
    [m_ExtensionMessage passMessageObject:messageData identifier:EMSG_ID_MAIN_MAPCENTER];
}

-(void)BroadcastRemoveAllAnnotations
{
    [m_ExtensionMessage passMessageObject:nil identifier:EMSG_ID_MAIN_REMOVEALLANNOTATIONS];
}

-(void)BroadcastRemoveTrafficAnnotations
{
    [m_ExtensionMessage passMessageObject:nil identifier:EMSG_ID_MAIN_REMOVETRAFFICANNOTATIONS];
}

-(void)BroadcastRemoveSpotAnnotations
{
    [m_ExtensionMessage passMessageObject:nil identifier:EMSG_ID_MAIN_REMOVESPOTANNOTATIONS];
}

-(void)BroadcastRemoveTaxiAnnotations
{
    [m_ExtensionMessage passMessageObject:nil identifier:EMSG_ID_MAIN_REMOVETAXIANNOTATIONS];
}

/*
-(void)BroadcastAddAnnotation:(NOMWatchMapAnnotation*)pAnnotation
{
    if(pAnnotation == nil)
        return;
    
    NSString* pID = [NSString stringWithFormat:@"%@", pAnnotation.m_AnnotationID];
    NSNumber* pType = [[NSNumber alloc] initWithInt:pAnnotation.m_AnnotationType];
    NSNumber* pLatitude = [[NSNumber alloc] initWithDouble:pAnnotation.m_Latitude];
    NSNumber* pLongitude = [[NSNumber alloc] initWithDouble:pAnnotation.m_Longitude];
    
    NSDictionary *messageData =   [NSDictionary dictionaryWithObjectsAndKeys:
                                   pID, EMSG_KEY_ANNOTATIONID,
                                   pType, EMSG_KEY_ANNOTATIONTYPE,
                                   pLatitude, EMSG_KEY_LOCATIONLATITUDE,
                                   pLongitude, EMSG_KEY_LOCATIONLONGITUDE,
                                   nil];
    
    [m_ExtensionMessage passMessageObject:messageData identifier:EMSG_ID_MAIN_ADDANNOTATION];
}

-(void)BroadcastAnnotations:(NSArray*)pAnnotations
{
    if(pAnnotations != nil && 0 < pAnnotations.count)
    {
        [m_ExtensionMessage passMessageObject:pAnnotations identifier:EMSG_ID_MAIN_ADDANNOTATIONLIST];
    }
}
*/ 

-(void)BroadcastGasStattionList:(NSArray*)pAnnotations
{
    if(pAnnotations != nil && 0 < pAnnotations.count)
    {
        [m_ExtensionMessage passMessageObject:pAnnotations identifier:EMSG_ID_MAIN_GASSTATIONLIST];
    }
}

-(void)BroadcastPhotoRadarList:(NSArray*)pAnnotations
{
    if(pAnnotations != nil && 0 < pAnnotations.count)
    {
        [m_ExtensionMessage passMessageObject:pAnnotations identifier:EMSG_ID_MAIN_PHOTORADARLIST];
    }
}

-(void)BroadcastSchoolZoneList:(NSArray*)pAnnotations
{
    if(pAnnotations != nil && 0 < pAnnotations.count)
    {
        [m_ExtensionMessage passMessageObject:pAnnotations identifier:EMSG_ID_MAIN_SCHOOLZONELIST];
    }
}

-(void)BroadcastPlayGroundList:(NSArray*)pAnnotations
{
    if(pAnnotations != nil && 0 < pAnnotations.count)
    {
        [m_ExtensionMessage passMessageObject:pAnnotations identifier:EMSG_ID_MAIN_PLAYGROUNDLIST];
    }
}

-(void)BroadcastParkingGroundList:(NSArray*)pAnnotations
{
    if(pAnnotations != nil && 0 < pAnnotations.count)
    {
        [m_ExtensionMessage passMessageObject:pAnnotations identifier:EMSG_ID_MAIN_PARKINGGROUNDLIST];
    }
}

-(void)BroadcastTafficMessage:(NSArray*)pAnnotations
{
    if(pAnnotations != nil && 0 < pAnnotations.count)
    {
        [m_ExtensionMessage passMessageObject:pAnnotations identifier:EMSG_ID_MAIN_TRAFFICMESSAGE];
    }
}

-(void)BroadcastTaxiMessage:(NSArray*)pAnnotations
{
    if(pAnnotations != nil && 0 < pAnnotations.count)
    {
        [m_ExtensionMessage passMessageObject:pAnnotations identifier:EMSG_ID_MAIN_TAXIMESSAGE];
    }
}

-(void)BroadcastSocialTafficMessage:(NSArray*)pAnnotations
{
    if(pAnnotations != nil && 0 < pAnnotations.count)
    {
        [m_ExtensionMessage passMessageObject:pAnnotations identifier:EMSG_ID_MAIN_SOCIALTRAFFICMESSAGE];
    }
}

-(void)BroadcastLocationNotSuppotPostingWarnMessage
{
    NSString* szWarning = [StringFactory GetString_PostLocationOutAppRegion];
    [m_ExtensionMessage passMessageObject:szWarning identifier:EMSG_ID_MAIN_WARNINGMESSAGE];
}

-(void)BroadcastDebugAlertMessage:(NSString*)message
{
#ifdef DEBUG
    [m_ExtensionMessage passMessageObject:message identifier:EMSG_ID_MAIN_DEBUGLOGMESSAGE];
#endif
}

@end
