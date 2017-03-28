//
//  NYCCommunicationManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-03-30.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NYCCommunicationManager.h"
#import "MMWormhole.h"
#import "NOMAppWatchConstants.h"
#import "InterfaceController.h"
#import "NOMWatchMapAnnotation.h"

static NYCCommunicationManager*     g_Manager = nil;

@interface NYCCommunicationManager ()
{
    MMWormhole*                 m_ExtensionMessage;
    InterfaceController*        m_WatchMainController;
    BOOL                        m_bContarinerRunMode;
}

-(void)InitializeMessageHandler;

@end

@implementation NYCCommunicationManager

+(NYCCommunicationManager*)GetCommunicationManager
{
    if(g_Manager == nil)
    {
        @synchronized (self)
        {
            g_Manager = [[NYCCommunicationManager alloc] init];
            assert(g_Manager != nil);
        }
    }
    return g_Manager;
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_bContarinerRunMode = YES;
        m_WatchMainController = nil;
        m_ExtensionMessage = [[MMWormhole alloc] initWithApplicationGroupIdentifier:EMSG_APPGROUP_NAME optionalDirectory:EMSG_APPMESSAGE_ID];
        
        [self InitializeMessageHandler];
    }
    
    return self;
}

-(void)DirectSendMessageToContainerApp:(NSDictionary*)messageData withActionKey:(NSString*)szActionID
{
    NSDictionary *openAppData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 szActionID, EMSG_KEY_OPENCONTAINERAPP_ID,
                                 messageData, EMSG_KEY_OPENCONTAINERAPP_MSG_ID,
                                 nil];
    
    
    [WKInterfaceController openParentApplication:openAppData reply:^(NSDictionary *replyInfo, NSError *error)
     {
         if(error == nil && replyInfo != nil)
         {
             NSNumber* pAction = [replyInfo objectForKey:EMSG_KEY_ACTION];
             int16_t   nAction = (int16_t)[pAction intValue];
             if(nAction == NOM_WATCH_ACTION_SEARCH)
             {
                  if(m_WatchMainController != nil)
                  {
                      [m_WatchMainController InitializeWithMainReplyData:replyInfo withRemovePeviousObject:YES withEmptyAlert:NO];
                  }
                 return;
             }
             else if(nAction == NOM_WATCH_ACTION_POST)
             {
                 NSDictionary* pData = [replyInfo objectForKey:EMSG_KEY_OPENCONTAINERAPP_MSG_ID];
                 if(m_WatchMainController != nil && pData)
                 {
                     [m_WatchMainController HandlePostAnnotation:pData withRemovePeviousObject:YES];
                 }
                 return;
             }
             else if(nAction == NOM_WATCH_ACTION_CURRENTLOCATION)
             {
#if DEBUG
                 NSLog(@"openParentApplication reply as nAction == NOM_WATCH_ACTION_CURRENTLOCATION");
#endif
                 NSNumber* pLatitude = [replyInfo objectForKey:EMSG_KEY_LOCATIONLATITUDE];
                 NSNumber* pLongitude = [replyInfo objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
                 
                 if(pLatitude != nil && pLongitude != nil)
                 {
                     double   dLatiude = (double)[pLatitude doubleValue];
                     double   dLongitude = (double)[pLongitude doubleValue];
                     if(m_WatchMainController != nil)
                     {
                         [m_WatchMainController SetMapViewCenter:dLatiude withLongitude:dLongitude];
                     }
                 }
             }
             else if(nAction == NOM_WATCH_ACTION_INVALID)
             {
#if DEBUG
                 NSLog(@"openParentApplication reply as nAction == NOM_WATCH_ACTION_INVALID");
#endif
                 return;
             }
         }
     }];
}

-(void)SendActionToMainApp:(int)nAction withChoice:(int)nChoice withOption:(int)nOption
{
    NSNumber* pAction = [[NSNumber alloc] initWithInt:nAction];
    NSNumber* pChoice = [[NSNumber alloc] initWithInt:nChoice];
    NSNumber* pOption = [[NSNumber alloc] initWithInt:nOption];

    if(nAction == NOM_WATCH_ACTION_SEARCH)
    {
        if(m_WatchMainController != nil)
        {
            [m_WatchMainController RemoveAllAnnotations];
        }
        
        NSDictionary *messageData = [NSDictionary dictionaryWithObjectsAndKeys:
                                    pAction, EMSG_KEY_ACTION,
                                    pChoice, EMSG_KEY_ACTIONCHOICE,
                                    pOption, EMSG_KEY_ACTIONOPTION,
                                    nil];
    
        if(m_bContarinerRunMode == NO)
        {
            [m_ExtensionMessage passMessageObject:messageData identifier:EMSG_ID_WATCH_ACTIONEVENT];
        }
        else
        {
            [self DirectSendMessageToContainerApp:messageData withActionKey:EMSG_ID_WATCH_ACTIONEVENT];
        }
    }
    else if(nAction == NOM_WATCH_ACTION_POST)
    {
        if(m_WatchMainController != nil)
        {
            double dLatitude = [m_WatchMainController GetMapViewCenterLatitude];
            double dLongitude = [m_WatchMainController GetMapViewCenterLongitude];
            NSNumber* pLatitude = [[NSNumber alloc] initWithDouble:dLatitude];
            NSNumber* pLongitude = [[NSNumber alloc] initWithDouble:dLongitude];
            
            NSDictionary *messageData = [NSDictionary dictionaryWithObjectsAndKeys:
                                         pAction, EMSG_KEY_ACTION,
                                         pChoice, EMSG_KEY_ACTIONCHOICE,
                                         pOption, EMSG_KEY_ACTIONOPTION,
                                         pLatitude, EMSG_KEY_LOCATIONLATITUDE,
                                         pLongitude, EMSG_KEY_LOCATIONLONGITUDE,
                                         nil];
        
            if(m_bContarinerRunMode == NO)
            {
                [m_ExtensionMessage passMessageObject:messageData identifier:EMSG_ID_WATCH_ACTIONEVENT];
            }
            else
            {
                [self DirectSendMessageToContainerApp:messageData withActionKey:EMSG_ID_WATCH_ACTIONEVENT];
            }
        }
    }
}

-(void)SendCurrentLocationRequestToMainApp
{
    NSDictionary *messageData =   [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"DUMY_MESSAGE", @"DUMY_MESSAGE_KEY",
                                   nil];
    
    if(m_bContarinerRunMode == NO)
    {
        [m_ExtensionMessage passMessageObject:messageData identifier:EMSG_ID_WATCH_LOCATIONREQUEST];
    }
    else
    {
        [self DirectSendMessageToContainerApp:messageData withActionKey:EMSG_ID_WATCH_LOCATIONREQUEST];
    }
}

-(void)SendGeneralRequestToMainApp
{
    NSDictionary *messageData =   [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"DUMY_MESSAGE", @"DUMY_MESSAGE_KEY",
                                   nil];
    
    if(m_bContarinerRunMode == NO)
    {
        [m_ExtensionMessage passMessageObject:messageData identifier:EMSG_ID_WATCH_GENERALSEARCHREQUEST];
    }
    else
    {
        [self DirectSendMessageToContainerApp:messageData withActionKey:EMSG_ID_WATCH_GENERALSEARCHREQUEST];
    }
}

-(void)RegisterWatchController:(id)wkController
{
    if(wkController != nil && [wkController isKindOfClass:[InterfaceController class]] == YES)
    {
        m_WatchMainController = wkController;
    }
}

-(void)DeleteMessageData:(NSString *)identifier
{
    [m_ExtensionMessage clearMessageContentsForIdentifier:identifier];
}

-(void)InitializeMessageHandler
{
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_MAINAPPRUNMODE listener:^(id messageObject)
     {
         // The number is identified with the buttonNumber key in the message object
         NSNumber* pRunMode = [messageObject objectForKey:EMSG_KEY_MAINAPPRUNMODE];

         m_bContarinerRunMode = [pRunMode boolValue];
#if DEBUG
         if(m_bContarinerRunMode)
             NSLog(@"Container running mode is in background mode.");
         else
             NSLog(@"Container running mode is in active foreground mode.");
#endif
         
     }];

    
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_MAPCENTER listener:^(id messageObject)
     {
         // The number is identified with the buttonNumber key in the message object
         NSNumber* pLatitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLATITUDE];
         NSNumber* pLongitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
         
         if(pLatitude != nil && pLongitude != nil)
         {
             double   dLatiude = (double)[pLatitude doubleValue];
             double   dLongitude = (double)[pLongitude doubleValue];
             if(m_WatchMainController != nil)
             {
                 [m_WatchMainController SetMapViewCenter:dLatiude withLongitude:dLongitude];
             }
         }
     }];

    
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_REMOVEALLANNOTATIONS listener:^(id messageObject)
     {
         if(m_WatchMainController != nil)
         {
             [m_WatchMainController RemoveAllAnnotations];
         }
     }];

    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_REMOVETRAFFICANNOTATIONS listener:^(id messageObject)
     {
         if(m_WatchMainController != nil)
         {
             [m_WatchMainController RemoveTrafficAnnotations];
         }
     }];

    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_REMOVESPOTANNOTATIONS listener:^(id messageObject)
     {
         if(m_WatchMainController != nil)
         {
             [m_WatchMainController RemoveSpotAnnotations];
         }
     }];

     
     
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_REMOVETAXIANNOTATIONS listener:^(id messageObject)
     {
         if(m_WatchMainController != nil)
         {
             [m_WatchMainController RemoveTaxiAnnotations];
         }
     }];

/*
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_ADDANNOTATION listener:^(id messageObject)
     {
         if(m_WatchMainController != nil && messageObject != nil)
         {
             NSNumber* pLatitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLATITUDE];
             NSNumber* pLongitude = [messageObject objectForKey:EMSG_KEY_LOCATIONLONGITUDE];
             double   dLatiude = (double)[pLatitude doubleValue];
             double   dLongitude = (double)[pLongitude doubleValue];

             NSNumber* pType = [messageObject objectForKey:EMSG_KEY_ANNOTATIONTYPE];
             int16_t   nType = (int16_t)[pType intValue];
             
             NSString* szID = [messageObject objectForKey:EMSG_KEY_ANNOTATIONID];
             
             
             //[self DeleteMessageData:EMSG_ID_MAIN_ADDANNOTATION];
             
             NOMWatchMapAnnotation *pAnnotation = [[NOMWatchMapAnnotation alloc] init];
             pAnnotation.m_AnnotationID = szID;
             pAnnotation.m_AnnotationType = nType;
             pAnnotation.m_Latitude = dLatiude;
             pAnnotation.m_Longitude = dLongitude;
             
             [m_WatchMainController AddAnnotation:pAnnotation];
         }
     }];

    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_ADDANNOTATIONLIST listener:^(id messageObject)
     {
         if(m_WatchMainController != nil && messageObject != nil)
         {
             if([messageObject isKindOfClass:[NSArray class]] == YES)
             {
                 [m_WatchMainController AddAnnotations:((NSArray*)messageObject)];
             }
         }
     }];
*/
 
     [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_GASSTATIONLIST listener:^(id messageObject)
      {
#if DEBUG
          NSLog(@"EMSG_ID_MAIN_GASSTATIONLIST/Gas Station called");
#endif
          if(m_WatchMainController != nil && messageObject != nil)
          {
              if([messageObject isKindOfClass:[NSArray class]] == YES)
              {
                  [m_WatchMainController AddGasStationList:((NSArray*)messageObject)];
              }
          }
      }];

    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_PHOTORADARLIST listener:^(id messageObject)
     {
#if DEBUG
         NSLog(@"EMSG_ID_MAIN_PHOTORADARLIST/Photo Radar called");
#endif
         if(m_WatchMainController != nil && messageObject != nil)
         {
             if([messageObject isKindOfClass:[NSArray class]] == YES)
             {
                 [m_WatchMainController AddPhotoRadarList:((NSArray*)messageObject)];
             }
         }
     }];

    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_SCHOOLZONELIST listener:^(id messageObject)
     {
#if DEBUG
         NSLog(@"EMSG_ID_MAIN_SCHOOLZONELIST/School Zone called");
#endif
         if(m_WatchMainController != nil && messageObject != nil)
         {
             if([messageObject isKindOfClass:[NSArray class]] == YES)
             {
                 [m_WatchMainController AddSchoolZoneList:((NSArray*)messageObject)];
             }
         }
     }];

    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_PLAYGROUNDLIST listener:^(id messageObject)
     {
#if DEBUG
         NSLog(@"EMSG_ID_MAIN_PLAYGROUNDLIST/Play Ground called");
#endif
         if(m_WatchMainController != nil && messageObject != nil)
         {
             if([messageObject isKindOfClass:[NSArray class]] == YES)
             {
                 [m_WatchMainController AddPlayGroundList:((NSArray*)messageObject)];
             }
         }
     }];

    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_PARKINGGROUNDLIST listener:^(id messageObject)
     {
#if DEBUG
         NSLog(@"EMSG_ID_MAIN_PARKINGGROUNDLIST/Parking Ground called");
#endif
         if(m_WatchMainController != nil && messageObject != nil)
         {
             if([messageObject isKindOfClass:[NSArray class]] == YES)
             {
                 [m_WatchMainController AddParkingGroundList:((NSArray*)messageObject)];
             }
         }
     }];

    
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_TRAFFICMESSAGE listener:^(id messageObject)
     {
#if DEBUG
         NSLog(@"EMSG_ID_MAIN_TRAFFICMESSAGE/Traffic Message called");
#endif
         if(m_WatchMainController != nil && messageObject != nil)
         {
             if([messageObject isKindOfClass:[NSArray class]] == YES)
             {
                 [m_WatchMainController AddTrafficMessage:((NSArray*)messageObject)];
             }
         }
     }];

    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_TAXIMESSAGE listener:^(id messageObject)
     {
#if DEBUG
         NSLog(@"EMSG_ID_MAIN_TAXIMESSAGE/Taxi Message called");
#endif
         if(m_WatchMainController != nil && messageObject != nil)
         {
             if([messageObject isKindOfClass:[NSArray class]] == YES)
             {
                 [m_WatchMainController AddTaxiMessage:((NSArray*)messageObject)];
             }
         }
     }];
    
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_SOCIALTRAFFICMESSAGE listener:^(id messageObject)
     {
#if DEBUG
         NSLog(@"EMSG_ID_MAIN_SOCIALTRAFFICMESSAGE/Social Traffic Message called");
#endif
         if(m_WatchMainController != nil && messageObject != nil)
         {
             if([messageObject isKindOfClass:[NSArray class]] == YES)
             {
                 [m_WatchMainController AddSocialTrafficMessage:((NSArray*)messageObject)];
             }
         }
     }];

    
    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_WARNINGMESSAGE listener:^(id messageObject)
     {
#if DEBUG
         NSLog(@"EMSG_ID_MAIN_WARNINGMESSAGE:%@", (NSString*)messageObject);
#endif
         if(m_WatchMainController != nil && messageObject != nil)
         {
             if([messageObject isKindOfClass:[NSString class]] == YES)
             {
                 [m_WatchMainController ShowAlertMessage:((NSString*)messageObject)];
             }
         }
     }];

    [m_ExtensionMessage listenForMessageWithIdentifier:EMSG_ID_MAIN_DEBUGLOGMESSAGE listener:^(id messageObject)
     {
#if DEBUG
         NSLog(@"EMSG_ID_MAIN_DEBUGLOGMESSAGE:%@", (NSString*)messageObject);
#endif
     }];

    
}

-(void)BroadcastRemoveAllAnnotations
{
    [m_ExtensionMessage passMessageObject:nil identifier:EMSG_ID_MAIN_REMOVEALLANNOTATIONS];
}


@end
