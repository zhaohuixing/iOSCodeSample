//
//  NOMAppWatchConstants.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-03-30.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#ifndef __NYCONMAP_NOMAPPWATCHCONSTANTS_H__
#define __NYCONMAP_NOMAPPWATCHCONSTANTS_H__

#define EMSG_APPGROUP_NAME      @"YOURAPPAPPLEWATCHGROUPNAME"
#define EMSG_APPMESSAGE_ID      @"NYCONMAP_WATCH_MESSAGE_ID"


//Message ID and key from watch to main app
#define EMSG_ID_WATCH_ACTIONEVENT           @"EMSG_ID_WATCH_ACTIONEVENT"
#define EMSG_ID_WATCH_LOCATIONREQUEST       @"EMSG_ID_WATCH_LOCATIONREQUEST"
#define EMSG_ID_WATCH_GENERALSEARCHREQUEST  @"EMSG_ID_WATCH_GENERALSEARCHREQUEST"

//#define EMSG_ID_WATCH_SWITCHCHANGE      @"EMSG_ID_WATCH_SWITCHCHANGE"


//Message ID and key sent to watch from main app
#define EMSG_ID_MAIN_MAPCENTER                      @"EMSG_ID_MAIN_MAPCENTER"
//#define EMSG_ID_MAIN_ADDANNOTATION                  @"EMSG_ID_MAIN_ADDANNOTATION"
//#define EMSG_ID_MAIN_ADDANNOTATIONLIST              @"EMSG_ID_MAIN_ADDANNOTATIONLIST"

#define EMSG_ID_MAIN_GASSTATIONLIST                 @"EMSG_ID_MAIN_GASSTATIONLIST"
#define EMSG_ID_MAIN_PHOTORADARLIST                 @"EMSG_ID_MAIN_PHOTORADARLIST"
#define EMSG_ID_MAIN_SCHOOLZONELIST                 @"EMSG_ID_MAIN_SCHOOLZONELIST"
#define EMSG_ID_MAIN_PLAYGROUNDLIST                 @"EMSG_ID_MAIN_PLAYGROUNDLIST"
#define EMSG_ID_MAIN_PARKINGGROUNDLIST              @"EMSG_ID_MAIN_PARKINGGROUNDLIST"
#define EMSG_ID_MAIN_TRAFFICMESSAGE                 @"EMSG_ID_MAIN_TRAFFICMESSAGE"
#define EMSG_ID_MAIN_TAXIMESSAGE                    @"EMSG_ID_MAIN_TAXIMESSAGE"
#define EMSG_ID_MAIN_SOCIALTRAFFICMESSAGE           @"EMSG_ID_MAIN_SOCIALTRAFFICMESSAGE"

#define EMSG_ID_MAIN_REMOVEALLANNOTATIONS           @"EMSG_ID_MAIN_REMOVEALLANNOTATIONS"
#define EMSG_ID_MAIN_REMOVETRAFFICANNOTATIONS       @"EMSG_ID_MAIN_REMOVETRAFFICANNOTATIONS"
#define EMSG_ID_MAIN_REMOVESPOTANNOTATIONS          @"EMSG_ID_MAIN_REMOVESPOTANNOTATIONS"
#define EMSG_ID_MAIN_REMOVETAXIANNOTATIONS          @"EMSG_ID_MAIN_REMOVETAXIANNOTATIONS"

#define EMSG_ID_MAIN_WARNINGMESSAGE                 @"EMSG_ID_MAIN_WARNINGMESSAGE"

#define EMSG_ID_MAIN_DEBUGLOGMESSAGE                @"EMSG_ID_MAIN_DEBUGLOGMESSAGE"

#define EMSG_ID_MAIN_MAINAPPRUNMODE                 @"EMSG_ID_MAIN_MAINAPPRUNMODE"

//#define EMSG_ID_MAIN_SWITCHCHANGE      @"EMSG_ID_MAIN_SWITCHCHANGE"
//#define EMSG_ID_MAIN_SETTEXT           @"EMSG_ID_MAIN_SETTEXT"


//Key for watch action message data
#define EMSG_KEY_MAINAPPRUNMODE             @"EMSG_KEY_MAINAPPRUNMODE"
#define EMSG_KEY_ACTION                     @"EMSG_KEY_ACTION"
#define EMSG_KEY_ACTIONCHOICE               @"EMSG_KEY_ACTIONCHOICE"
#define EMSG_KEY_ACTIONOPTION               @"EMSG_KEY_ACTIONOPTION"
#define EMSG_KEY_LOCATIONLATITUDE           @"EMSG_KEY_LOCATIONLATITUDE"
#define EMSG_KEY_LOCATIONLONGITUDE          @"EMSG_KEY_LOCATIONLONGITUDE"
#define EMSG_KEY_ANNOTATIONTYPE             @"EMSG_KEY_ANNOTATIONTYPE"
#define EMSG_KEY_ANNOTATIONID               @"EMSG_KEY_ANNOTATIONID"

//Key for watch news data message list
#define EMSG_KEY_GASSTATIONLIST                 @"EMSG_KEY_GASSTATIONLIST"
#define EMSG_KEY_PHOTORADARLIST                 @"EMSG_KEY_PHOTORADARLIST"
#define EMSG_KEY_SCHOOLZONELIST                 @"EMSG_KEY_SCHOOLZONELIST"
#define EMSG_KEY_PLAYGROUNDLIST                 @"EMSG_KEY_PLAYGROUNDLIST"
#define EMSG_KEY_PARKINGGROUNDLIST              @"EMSG_KEY_PARKINGGROUNDLIST"

#define EMSG_KEY_TRAFFICMESSAGE                 @"EMSG_KEY_TRAFFICMESSAGE"
#define EMSG_KEY_TAXIMESSAGE                    @"EMSG_KEY_TAXIMESSAGE"
#define EMSG_KEY_SOCIALTRAFFICMESSAGE           @"EMSG_KEY_SOCIALTRAFFICMESSAGE"


#define EMSG_KEY_OPENCONTAINERAPP_ID            @"EMSG_KEY_OPENCONTAINERAPP_ID"
#define EMSG_KEY_OPENCONTAINERAPP_MSG_ID        @"EMSG_KEY_OPENCONTAINERAPP_MSG_ID"

#define EMSG_MSG_INITIALIZE_OPEN_MAINAPP        @"EMSG_MSG_INITIALIZE_OPEN_MAINAPP"


/********************************************************************************************/
//
// Watch action type paramter
//
/********************************************************************************************/
#define NOM_WATCH_ACTION_INVALID                                             -1
#define NOM_WATCH_ACTION_SEARCH                                              0
#define NOM_WATCH_ACTION_POST                                                1
#define NOM_WATCH_ACTION_CURRENTLOCATION                                     2


/********************************************************************************************/
//
// Watch action choice paramter
//
/********************************************************************************************/
#define NOM_WATCH_ACTION_CHOICE_TRAFIC                                              0
#define NOM_WATCH_ACTION_CHOICE_SPOT                                                1
#define NOM_WATCH_ACTION_CHOICE_TAXI                                                2


/********************************************************************************************/
//
// Watch action sub action option for traffic (thrid paramter for App query/search criterion)
//
/********************************************************************************************/
#define NOM_WATCH_LOCALTRAFFIC_ALL                                           -1
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_JAM                          0
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_CRASH                        1
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_POLICE                       2
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_CONSTRUCTION                 3
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_ROADCLOSURE                  4
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_BROKENTRAFFICLIGHT           5
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_STALLEDCAR                   6
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_FOG                          7
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_DANGEROUSCONDITION           8
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_RAIN                         9
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_ICE                          10
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_WIND                         11
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_LANECLOSURE                  12
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_SLIPROADCLOSURE              13
#define NOM_WATCH_LOCALTRAFFIC_DRIVINGCONDITION_DETOUR                       14
#define NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_BUS_DELAY                       15
#define NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_TRAIN_DELAY                     16
#define NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_FLIGHT_DELAY                    17
#define NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_PASSENGERSTUCK                  18

#define NOM_WATCH_LOCALTRAFFIC_FIRSTID                                       NOM_WATCH_LOCALTRAFFIC_ALL
#define NOM_WATCH_LOCALTRAFFIC_LASTID                                        NOM_WATCH_LOCALTRAFFIC_PUBLICTRANSIT_PASSENGERSTUCK

/********************************************************************************************/
//
// Watch action sub action options for spot
//
/********************************************************************************************/
#define NOM_WATCH_TRAFFICSPOT_ALL                                     -1
#define NOM_WATCH_TRAFFICSPOT_REDLIGHTCAMERA                          0
#define NOM_WATCH_TRAFFICSPOT_SPEEDCAMERA                             1
#define NOM_WATCH_TRAFFICSPOT_SCHOOLZONE                              2
#define NOM_WATCH_TRAFFICSPOT_PLAYGROUND                              3
#define NOM_WATCH_TRAFFICSPOT_GASSTATION                              4
#define NOM_WATCH_TRAFFICSPOT_PARKINGGROUND                           5

#define NOM_WATCH_TRAFFICSPOT_FIRSTID                                 NOM_WATCH_TRAFFICSPOT_ALL
#define NOM_WATCH_TRAFFICSPOT_LASTID                                  NOM_WATCH_TRAFFICSPOT_PARKINGGROUND

/********************************************************************************************/
//
// Watch action sub action options for taxi/passenger
//
/********************************************************************************************/
#define NOM_WATCH_TAXI_ALL                                   -1
#define NOM_WATCH_TAXI_TAXIAVAILABLEBYDRIVER                 0
#define NOM_WATCH_TAXI_TAXIREQUESTBYPASSENGER                1

#define NOM_WATCH_TAXI_FIRSTID                               NOM_WATCH_TAXI_ALL
#define NOM_WATCH_TAXI_LASTID                                NOM_WATCH_TAXI_TAXIREQUESTBYPASSENGER


/********************************************************************************************/
//
// Watch map annotation identifiers
//
/********************************************************************************************/

#define NOM_WATCH_ANNOTATION_INVALID                                         -1

#define NOM_WATCH_ANNOTATION_FIRST                                           0

//
/********************************************************************************************/
#define NOM_WATCH_ANNOTATION_TRAFFIC_FIRST                          NOM_WATCH_ANNOTATION_FIRST

/********************************************************************************************/
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST                          NOM_WATCH_ANNOTATION_TRAFFIC_FIRST

#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_JAM                            NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+0
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_CRASH                          NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+1
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_POLICE                         NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+2
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_CONSTRUCTION                   NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+3
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_ROADCLOSURE                    NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+4
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_BROKENTRAFFICLIGHT             NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+5
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_STALLEDCAR                     NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+6
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_FOG                            NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+7
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_DANGEROUSCONDITION             NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+8
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_RAIN                           NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+9
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_ICE                            NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+10
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_WIND                           NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+11
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_LANECLOSURE                    NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+12
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_SLIPROADCLOSURE                NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+13
#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_DETOUR                         NOM_WATCH_ANNOTATION_TRAFFIC_DC_FIRST+14

#define NOM_WATCH_ANNOTATION_TRAFFIC_DC_LAST                           NOM_WATCH_ANNOTATION_TRAFFIC_DC_DETOUR
/********************************************************************************************/

/********************************************************************************************/
#define NOM_WATCH_ANNOTATION_TRAFFIC_PT_FIRST                       NOM_WATCH_ANNOTATION_TRAFFIC_DC_LAST+1

#define NOM_WATCH_ANNOTATION_TRAFFIC_PT_BUS_DELAY                   NOM_WATCH_ANNOTATION_TRAFFIC_PT_FIRST+0
#define NOM_WATCH_ANNOTATION_TRAFFIC_PT_TRAIN_DELAY                 NOM_WATCH_ANNOTATION_TRAFFIC_PT_FIRST+1
#define NOM_WATCH_ANNOTATION_TRAFFIC_PT_FLIGHT_DELAY                NOM_WATCH_ANNOTATION_TRAFFIC_PT_FIRST+2
#define NOM_WATCH_ANNOTATION_TRAFFIC_PT_PASSENGERSTUCK              NOM_WATCH_ANNOTATION_TRAFFIC_PT_FIRST+3

#define NOM_WATCH_ANNOTATION_TRAFFIC_PT_LAST                        NOM_WATCH_ANNOTATION_TRAFFIC_PT_PASSENGERSTUCK
/********************************************************************************************/

#define NOM_WATCH_ANNOTATION_TRAFFIC_LAST                           NOM_WATCH_ANNOTATION_TRAFFIC_PT_LAST
/***************************************************************************************************/
//
//
/***************************************************************************************************/
#define NOM_WATCH_ANNOTATION_SPOT_FIRST                             NOM_WATCH_ANNOTATION_TRAFFIC_LAST+1

#define NOM_WATCH_ANNOTATION_SPOT_REDLIGHTCAMERA                    NOM_WATCH_ANNOTATION_SPOT_FIRST+0
#define NOM_WATCH_ANNOTATION_SPOT_SPEEDCAMERA                       NOM_WATCH_ANNOTATION_SPOT_FIRST+1
#define NOM_WATCH_ANNOTATION_SPOT_SCHOOLZONE                        NOM_WATCH_ANNOTATION_SPOT_FIRST+2
#define NOM_WATCH_ANNOTATION_SPOT_PLAYGROUND                        NOM_WATCH_ANNOTATION_SPOT_FIRST+3
#define NOM_WATCH_ANNOTATION_SPOT_GASSTATION                        NOM_WATCH_ANNOTATION_SPOT_FIRST+4
#define NOM_WATCH_ANNOTATION_SPOT_PARKINGGROUND                     NOM_WATCH_ANNOTATION_SPOT_FIRST+5

#define NOM_WATCH_ANNOTATION_SPOT_LAST                              NOM_WATCH_ANNOTATION_SPOT_PARKINGGROUND
/***************************************************************************************************/
//
//
/***************************************************************************************************/
#define NOM_WATCH_ANNOTATION_TAXI_FIRST                             NOM_WATCH_ANNOTATION_SPOT_LAST+1

#define NOM_WATCH_ANNOTATION_TAXI_TAXIAVAILABLEBYDRIVER             NOM_WATCH_ANNOTATION_TAXI_FIRST+0
#define NOM_WATCH_ANNOTATION_TAXI_TAXIREQUESTBYPASSENGER            NOM_WATCH_ANNOTATION_TAXI_FIRST+1

#define NOM_WATCH_ANNOTATION_TAXI_LAST                              NOM_WATCH_ANNOTATION_TAXI_TAXIREQUESTBYPASSENGER
/***************************************************************************************************/
//

//
/***************************************************************************************************/
//??????????????
//??????????????
//??????????????
//??????????????
#define NOM_WATCH_ANNOTATION_LAST                                   NOM_WATCH_ANNOTATION_TAXI_LAST

#endif
