//
//  NOMSystemConstants.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-05-23.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#ifndef newsonmap_NOMSystemConstants_h
#define newsonmap_NOMSystemConstants_h

/**********************************************************************************
 * NOM DB system configuration DB setting (current using Simple DB domain to store
 * information)
***********************************************************************************/
#define NOM_DBSYSTYPECONFIGURE_DOMAIN               @"xxxxxxxxxxxxxxxxxxxxxx"

#define NOM_DBSYSTYPE_ATTRIBUTE_TYPE_TAG            @"NEWSONMAP_DBSYSTYPE"

#define NOM_DBSYSTYPE_ATTRIBUTE_CURRENT_IOS_BUILD_TAG           @"CURRENT_IOS_BUILDNO"        //_m_CurrentiOSVersion
#define NOM_DBSYSTYPE_ATTRIBUTE_LEAST_IOS_BUILD_TAG             @"LEAST_IOS_BUILDNO"          //_m_LeastiOSVersion

#define NOM_DBSYSTYPE_ATTRIBUTE_CURRENT_ANDROID_BUILD_TAG           @"CURRENT_ANDROID_BUILDNO"        //_m_CurrentAndroidVersion
#define NOM_DBSYSTYPE_ATTRIBUTE_LEAST_ANDROID_BUILD_TAG             @"LEAST_ANDROID_BUILDNO"          //_m_LeastAndroidVersion


#define NOM_DBSYSTYPE_ATTRIBUTE_OLD_REGIONSDB_COUNT_TAG             @"OLD_REGION_SDB_COUNT"          //_m_OldRegionSDBCount;
#define NOM_DBSYSTYPE_ATTRIBUTE_OLD_REGIONSDB_TIMELINE_TAG          @"OLD_REGION_SDB_TIMELINE_"       //_m_OldRegionSDBTimeLineList;
#define NOM_DBSYSTYPE_ATTRIBUTE_OLD_REGIONSDB_DOMAIN_PREFIX_TAG     @"OLD_REGION_SDB_DOMAIN_PREFIX_"  //_m_OldRegionSDBDomainList;
#define NOM_DBSYSTYPE_ATTRIBUTE_CURRENT_REGIONSDB_DOMAIN_PREFIX_TAG     @"CURRENT_REGION_SDB_DOMAIN_PREFIX"  //_m_CurrentRegionSDBDomain;
#define NOM_DBSYSTYPE_ATTRIBUTE_CURRENT_COMMUNITYREGIONSDB_DOMAIN_PREFIX_TAG     @"CURRENT_REGION_CMT_SDB_DOMAIN_PREFIX"  //_m_CurrentCommunityRegionSDBDomain;
#define NOM_DBSYSTYPE_ATTRIBUTE_CURRENT_TRAFFICREGIONSDB_DOMAIN_PREFIX_TAG     @"CURRENT_REGION_TRA_SDB_DOMAIN_PREFIX"  //_m_CurrentTrafficRegionSDBDomain;

#define NOM_DBSYSTYPE_ATTRIBUTE_CURRENT_COMPLAINREPORT_DOMAIN     @"CURRENT_COMPLAIN_DB_DOMAIN"  //_m_ComplainReportSDBDomain;

#define NOM_DBSYSTYPE_ATTRIBUTE_APPSTORE_URL_TAG                @"APPSTORE_URL"             //_m_AppStoreURL;
#define NOM_DBSYSTYPE_ATTRIBUTE_GOOGLEPLAY_URL_TAG              @"GOOGLEPLAY_URL"           //_m_GooglePlayURL;
#define NOM_DBSYSTYPE_ATTRIBUTE_AMAZON_URL_TAG                  @"AMAZON_URL"               //_m_AmazonURL;
#define NOM_DBSYSTYPE_ATTRIBUTE_BLACKBERRY_URL_TAG              @"BLACKBERRY_URL"           //_m_BlackberryURL;


#define NOM_DBSYSTYPE_ATTRIBUTE_GOOGLEAD_IOS_BANNER_ID_TAG              @"GAD_IOS_BANNER_ID"         
#define NOM_DBSYSTYPE_ATTRIBUTE_GOOGLEAD_IOS_INTERSTITIAL_ID_TAG        @"GAD_IOS_INTERSTITIAL_ID"
#define NOM_DBSYSTYPE_ATTRIBUTE_GOOGLEAD_ANDROID_BANNER_ID_TAG              @"GAD_ANDROID_BANNER_ID"
#define NOM_DBSYSTYPE_ATTRIBUTE_GOOGLEAD_ANDROID_INTERSTITIAL_ID_TAG        @"GAD_ANDROID_INTERSTITIAL_ID"
#define NOM_DBSYSTYPE_ATTRIBUTE_AMAZONAD_ANDROID_BANNER_ID_TAG              @"AMAZON_BANNER_ID"
#define NOM_DBSYSTYPE_ATTRIBUTE_AMAZONAD_ANDROID_INTERSTITIAL_ID_TAG        @"AMAZON_INTERSTITIAL_ID"



#define NOM_DBSYSTYPE_DEFAULTKEY_VALUE              @"current_type"

#define NOM_DBSYSTYPE_SIMPLEDB_VALUE                @"0"
#define NOM_DBSYSTYPE_CURRENT_BUILD                 @"1"


#define NOM_DBSYSTYPE_INVALID                       -1
#define NOM_DBSYSTYPE_SIMPLEDB                      0
#define NOM_DBSYSTYPE_DYNAMODB                      1

/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM complain report DB system (current using simple DB domain to store information)
 **********************************************************************************/
#define NOM_COMPAINREPORT_DEFAULT_DOMAIN               @"xxxxxxxxxxxxxxxxxxxxxx"

/**********************************************************************************/
/**********************************************************************************/


/**********************************************************************************
 * NOM publisher user DB system (current using dynamo DB domain to store information)
 **********************************************************************************/
#define NOM_PUBLISHUSERLIST_DOMAIN               @"xxxxxxxxxxxxxxxxxxxxxx"

//Primary key
//#define NOM_PUBLISHUSERLIST_USERID               @"id"

//Primary key
//Range key
#define NOM_PUBLISHUSERLIST_EMAIL                @"email"

#define NOM_PUBLISHUSERLIST_PW                   @"pw"

#define NOM_PUBLISHUSERLIST_DISPLAYNAME          @"dname"

#define NOM_PUBLISHUSERLIST_LNAME                @"lname"

#define NOM_PUBLISHUSERLIST_FNAME                @"fname"

#define NOM_PUBLISHUSERLIST_TYPE                 @"type"

#define NOM_PUBLISHUSERLIST_COMPAINSTATE         @"complain"                   //0: Normal. 1: posting offensive post.
                                                                               //2: posting middle offensive post.
                                                                               //3: posting serious offensive post, and user account disabled.

#define NOM_USERCOMPLAIN_LEVEL_NORMAL                   0
#define NOM_USERCOMPLAIN_LEVEL_SLIGHT                   1
#define NOM_USERCOMPLAIN_LEVEL_MODERATE                 2
#define NOM_USERCOMPLAIN_LEVEL_SEVERE                   3
#define NOM_USERPOSTINGBAN_DEFAULT_TIME                 86400
#define NOM_USERACCOUNT_UPDATECHECK_TIME                900

/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM news meta DB system (current using dynamo DB domain to store information)
 **********************************************************************************/
#define NOM_DEFAULT_NEWSMETA_DOMAIN            @"xxxxxxxxxxxxxxxxxxxxxx"
#define NOM_DEFAULT_NEWSMETA_DOMAIN_ROOT            @"xxxxxxxxxxxxxxxxxx"
#define NOM_DEFAULT_COMMUNITYMETA_DOMAIN_ROOT            @"xxxxxxxxxxxxxxxxxx"
#define NOM_DEFAULT_TRAFFICMETA_DOMAIN_ROOT              @"xxxxxxxxxxxxxxxxxx"

//Primary key
#define NOM_NEWSMETA_NEWID                          @"nid"

#define NOM_NEWSMETA_PUBLISHEREMAIL                 @"pemail"

#define NOM_NEWSMETA_PUBLISHERDISPLAYNAME           @"pdname"

#define NOM_NEWSMETA_NEWSTIME                       @"ntime"

#define NOM_NEWSMETA_NEWSLATITUDE                   @"nlat"

#define NOM_NEWSMETA_NEWSLONGITUDE                  @"nlon"

#define NOM_NEWSMETA_NEWSTYPE                       @"ntype"

#define NOM_NEWSMETA_NEWSSUBTYPE                    @"ntype2"

#define NOM_NEWSMETA_NEWSDISPLAYSTATEBYCOMPLAIN     @"ndsc"

#define NOM_NEWSMETA_NEWSWEARABLEENABLE             @"nweb"

#define NOM_NEWSMETA_S3RESOURCEURL                  @"s3storageKey"

#define NOM_NEWSMETA_NEWSTHIRDTYPE                  @"ntype3"


/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM news meta DB system (current using dynamo DB domain to store information)
 **********************************************************************************/
#define NOM_NEWSRESOURCE_STORAGE_ROOT               @"xxxxxxxxxxxxxxxxxxxxxx"

#define NOM_NEWSRESOURCE_STORAGE_NEWS_FOLDER        @"news"

#define NOM_NEWSRESOURCE_STORAGE_NEWSIMAGE_FOLDER   @"nimages"

#define NOM_NEWSRESOURCE_STORAGE_NEWSKML_FOLDER     @"nkml"

#define NOM_NEWSRESOURCE_NEWFILE_POSTFIX            @"news"

#define NOM_NEWSRESOURCE_STORAGE_PUBLISH_FOLDER        @"publish"

#define NOM_NEWSRESOURCE_STORAGE_MAINJSON_FILENAME     @"newsmainfile.json"

#define NOM_NEWSRESOURCE_STORAGE_IMAGE_FILEEXT          @"jpg"

#define NOM_NEWSRESOURCE_STORAGE_IMAGE_FILEPREFIX       @"newsimage_"

/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM news main json file tags
 **********************************************************************************/
#define NOM_NEWSJSON_TAG_NEWID                          @"nid"                  //string value
#define NOM_NEWSJSON_TAG_PUBLISHEREMAIL                 @"pemail"               //string value
#define NOM_NEWSJSON_TAG_PUBLISHERDISPLAYNAME           @"pdname"               //string value
#define NOM_NEWSJSON_TAG_NEWSLATITUDE                   @"nlat"                 //number value
#define NOM_NEWSJSON_TAG_NEWSLONGITUDE                  @"nlon"                 //number value
#define NOM_NEWSJSON_TAG_NEWSTIME                       @"ntime"                //number value
#define NOM_NEWSJSON_TAG_NEWSCATEGORY                   @"ncategory"            //number value
#define NOM_NEWSJSON_TAG_NEWSSUBCATEGORY                @"nsubcategory"         //number value
#define NOM_NEWSJSON_TAG_NEWSTHIRDCATEGORY              @"n3rdcategory"         //number value
#define NOM_NEWSJSON_TAG_NEWSFILEURL                    @"newsurl"              //string value
#define NOM_NEWSJSON_TAG_NEWSKMLURL                     @"nkmlurl"              //string value
#define NOM_NEWSJSON_TAG_COMPLAINFLAG                   @"ncomplain"            //number value
#define NOM_NEWSJSON_TAG_WEARABLEFLAG                   @"nwearable"            //number value
#define NOM_NEWSJSON_TAG_NEWSDOMAINURL                  @"newsdomain"           //string value

#define NOM_NEWSJSON_TAG_NEWSIMAGECOUNT                 @"nimages"              //number value
#define NOM_NEWSJSON_TAG_NEWSIMAGEKEYPREFIX             @"nimage_"              //string value
#define NOM_NEWSJSON_TAG_NEWSTITLE                      @"ntile"                //string value
#define NOM_NEWSJSON_TAG_NEWSBODY                       @"nbody"                //string value
#define NOM_NEWSJSON_TAG_NEWSKEYWORDS                   @"nkeywords"            //string value
#define NOM_NEWSJSON_TAG_NEWSCOPYRIGHT                  @"ncopyright"           //string value

#define NOM_NEWSJSON_TAG_NEWSKMLSOURCE                  @"nkmlsrc"              //string value


#define NOM_AWSSQS_MESSAGE_TAG                          @"Message"              //String value
/**********************************************************************************/
/**********************************************************************************/

#define NOM_NEWSJSON_CONTENTTYPE                            @"text/plain"
#define NOM_NEWSIMAGE_CONTENTTYPE                           @"image/jpeg"
#define NOM_NEWSKML_CONTENTTYPE                             @"text/kml"

#define NOM_FILETYPE_NONSPECIFIC                            0
#define NOM_FILETYPE_JSON                                   1
#define NOM_FILETYPE_IMAGE                                  2
#define NOM_FILETYPE_KML                                    3

/**********************************************************************************
 * NOM news main category id
 **********************************************************************************/
#define NOM_NEWSCATEGORY_LOCALNEWS                          0
#define NOM_NEWSCATEGORY_COMMUNITY                          1
#define NOM_NEWSCATEGORY_LOCALTRAFFIC                       2
#define NOM_NEWSCATEGORY_TAXI                               3

#define NOM_NEWSCATEGORY_NONENEWS_BASE_ID                   100

#define NOM_NEWSCATEGORY_FIRSTID                            NOM_NEWSCATEGORY_LOCALNEWS
#define NOM_NEWSCATEGORY_LASTID                             (NOM_NEWSCATEGORY_NONENEWS_BASE_ID -1)


/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM sub news category id in local news category
 **********************************************************************************/
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_PUBLICISSUE                    0
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_POLITICS                       1
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_BUSINESS                       2
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_MONEY                          3
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_HEALTH                         4
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_SPORTS                         5
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ARTANDENTERTAINMENT            6
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_EDUCATION                      7
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TECHNOLOGYANDSCIENCE           8
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_FOODANDDRINK                   9
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TRAVELANDTOURISM               10
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_LIFESTYLE                      11
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_REALESTATE                     12
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_AUTO                           13
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CRIMEANDDISASTER               14
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_WEATHER                        15
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CHARITY                        16
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CULTURE                        17
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_RELIGION                       18
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ANIMALPET                      19
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_MISC                           20
#define NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ALL                            21

/**********************************************************************************/
/**********************************************************************************/


/**********************************************************************************
 * NOM sub news category id in community category
 **********************************************************************************/
#define NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYEVENT                 0
#define NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYYARDSALE              1
#define NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYWIKI                  2
#define NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_ALL                            3

/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM sub news category id in traffic category
 **********************************************************************************/
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT                 0
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION              1
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_ALL                           2

/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM sub news category id in traffic category
 **********************************************************************************/
//#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_DELAY                           0

/**************************************************************************************************/
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_FIRST                       0

#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY                       NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_FIRST+0
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_TRAIN_DELAY                     NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_FIRST+1
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_FLIGHT_DELAY                    NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_FIRST+2
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK                  NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_FIRST+3

#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_LAST                        NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK
/**************************************************************************************************/

#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_ALL                             NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_KEY_LAST+1 //4

//
/**************************************************************************************************/
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST                    0

#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM                          NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+0
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH                        NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+1
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE                       NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+2
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION                 NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+3
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE                  NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+4
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT           NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+5
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR                   NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+6
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG                          NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+7
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION           NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+8
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN                         NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+9
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE                          NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+10
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND                         NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+11
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE                  NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+12
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE              NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+13
#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR                       NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_FIRST+14

#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_LAST                     NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR
/**************************************************************************************************/
//


#define NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ALL                          NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_KEY_LAST+1 //15


/**********************************************************************************/
/**********************************************************************************/


/**********************************************************************************
 * NOM sub news category id in taxi category
 **********************************************************************************/
#define NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIAVAILABLEBYDRIVER                 0
#define NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIREQUESTBYPASSENGER                1
#define NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_ALL                                   2

/**********************************************************************************/
/**********************************************************************************/


/**********************************************************************************
 * NOM local news minmum query time interval (in second)
 **********************************************************************************/
#define NOM_LOCALNEWS_PUBLICISSUE_QUERYTIME_MIN                                 1800
#define NOM_LOCALNEWS_POLITICS_QUERYTIME_MIN                                    1800
#define NOM_LOCALNEWS_BUSINESS_QUERYTIME_MIN                                    1800
#define NOM_LOCALNEWS_MONEY_QUERYTIME_MIN                                       1800
#define NOM_LOCALNEWS_HEALTH_QUERYTIME_MIN                                      1800
#define NOM_LOCALNEWS_SPORTS_QUERYTIME_MIN                                      1800
#define NOM_LOCALNEWS_ARTANDENTERTAINMENT_QUERYTIME_MIN                         1800
#define NOM_LOCALNEWS_EDUCATION_QUERYTIME_MIN                                   1800
#define NOM_LOCALNEWS_TECHNOLOGYANDSCIENCE_QUERYTIME_MIN                        1800
#define NOM_LOCALNEWS_FOODANDDRINK_QUERYTIME_MIN                                1800
#define NOM_LOCALNEWS_TRAVELANDTOURISM_QUERYTIME_MIN                            1800
#define NOM_LOCALNEWS_LIFESTYLE_QUERYTIME_MIN                                   1800
#define NOM_LOCALNEWS_REALESTATE_QUERYTIME_MIN                                  1800
#define NOM_LOCALNEWS_AUTO_QUERYTIME_MIN                                        1800
#define NOM_LOCALNEWS_CRIMEANDDISASTER_QUERYTIME_MIN                            1800
#define NOM_LOCALNEWS_WEATHER_QUERYTIME_MIN                                     1800

#define NOM_LOCALNEWS_CHARITY_QUERYTIME_MIN                                     1800
#define NOM_LOCALNEWS_CULTURE_QUERYTIME_MIN                                     1800
#define NOM_LOCALNEWS_RELIGION_QUERYTIME_MIN                                    1800
#define NOM_LOCALNEWS_PET_QUERYTIME_MIN                                         1800

#define NOM_LOCALNEWS_MISC_QUERYTIME_MIN                                        1800

/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM local news maxmum query time interval (in second)
 **********************************************************************************/
#define NOM_LOCALNEWS_PUBLICISSUE_QUERYTIME_MAX                                 2592000
#define NOM_LOCALNEWS_POLITICS_QUERYTIME_MAX                                    2592000
#define NOM_LOCALNEWS_BUSINESS_QUERYTIME_MAX                                    2592000
#define NOM_LOCALNEWS_MONEY_QUERYTIME_MAX                                       2592000
#define NOM_LOCALNEWS_HEALTH_QUERYTIME_MAX                                      2592000
#define NOM_LOCALNEWS_SPORTS_QUERYTIME_MAX                                      2592000
#define NOM_LOCALNEWS_ARTANDENTERTAINMENT_QUERYTIME_MAX                         2592000
#define NOM_LOCALNEWS_EDUCATION_QUERYTIME_MAX                                   2592000
#define NOM_LOCALNEWS_TECHNOLOGYANDSCIENCE_QUERYTIME_MAX                        2592000
#define NOM_LOCALNEWS_FOODANDDRINK_QUERYTIME_MAX                                2592000
#define NOM_LOCALNEWS_TRAVELANDTOURISM_QUERYTIME_MAX                            2592000
#define NOM_LOCALNEWS_LIFESTYLE_QUERYTIME_MAX                                   2592000
#define NOM_LOCALNEWS_REALESTATE_QUERYTIME_MAX                                  2592000
#define NOM_LOCALNEWS_AUTO_QUERYTIME_MAX                                        2592000
#define NOM_LOCALNEWS_CRIMEANDDISASTER_QUERYTIME_MAX                            2592000
#define NOM_LOCALNEWS_WEATHER_QUERYTIME_MAX                                     2592000

#define NOM_LOCALNEWS_CHARITY_QUERYTIME_MAX                                     2592000
#define NOM_LOCALNEWS_CULTURE_QUERYTIME_MAX                                     2592000
#define NOM_LOCALNEWS_RELIGION_QUERYTIME_MAX                                    2592000
#define NOM_LOCALNEWS_PET_QUERYTIME_MAX                                         2592000

#define NOM_LOCALNEWS_MISC_QUERYTIME_MAX                                        2592000

/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM community query time interval (in second)
 **********************************************************************************/
#define NOM_COMMUNITY_EVENT_QUERYTIME_MIN                                       86400
#define NOM_COMMUNITY_EVENT_QUERYTIME_MAX                                       31536000
#define NOM_COMMUNITY_YARDSALE_QUERYTIME_MIN                                    86400
#define NOM_COMMUNITY_YARDSALE_QUERYTIME_MAX                                    31536000
/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM local news minmum query time interval (in second)
 **********************************************************************************/
#define NOM_TRAFFIC_PUBLICTRANSIT_DELAY_QUERYTIME_MIN                               600
#define NOM_TRAFFIC_PUBLICTRANSIT_PASSENGERSTUCK_QUERYTIME_MIN                      600

#define NOM_TRAFFIC_DRIVINGCONDITION_JAM_QUERYTIME_MIN                              600
#define NOM_TRAFFIC_DRIVINGCONDITION_CRASH_QUERYTIME_MIN                            600
#define NOM_TRAFFIC_DRIVINGCONDITION_POLICE_QUERYTIME_MIN                           600
#define NOM_TRAFFIC_DRIVINGCONDITION_CONSTRUCTION_QUERYTIME_MIN                     600
#define NOM_TRAFFIC_DRIVINGCONDITION_ROADCLOSURE_QUERYTIME_MIN                      600
#define NOM_TRAFFIC_DRIVINGCONDITION_BROKENTRAFFICLIGHT_QUERYTIME_MIN               600
#define NOM_TRAFFIC_DRIVINGCONDITION_STALLEDCAR_QUERYTIME_MIN                       600
/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM local news minmum query time interval (in second)
 **********************************************************************************/
#define NOM_TRAFFIC_PUBLICTRANSIT_DELAY_QUERYTIME_MAX                               86400
#define NOM_TRAFFIC_PUBLICTRANSIT_PASSENGERSTUCK_QUERYTIME_MAX                      86400

#define NOM_TRAFFIC_DRIVINGCONDITION_JAM_QUERYTIME_MAX                              86400
#define NOM_TRAFFIC_DRIVINGCONDITION_CRASH_QUERYTIME_MAX                            86400
#define NOM_TRAFFIC_DRIVINGCONDITION_POLICE_QUERYTIME_MAX                           86400
#define NOM_TRAFFIC_DRIVINGCONDITION_CONSTRUCTION_QUERYTIME_MAX                     172800
#define NOM_TRAFFIC_DRIVINGCONDITION_ROADCLOSURE_QUERYTIME_MAX                      172800
#define NOM_TRAFFIC_DRIVINGCONDITION_BROKENTRAFFICLIGHT_QUERYTIME_MAX               3600
#define NOM_TRAFFIC_DRIVINGCONDITION_STALLEDCAR_QUERYTIME_MAX                       3600
/**********************************************************************************/
/**********************************************************************************/


/**********************************************************************************
 * NOM local news minmum query time interval (in second)
 **********************************************************************************/
#define NOM_LOCALNEWS_PUBLICISSUE_FRESHRATE_MIN                                 600
#define NOM_LOCALNEWS_POLITICS_FRESHRATE_MIN                                    600
#define NOM_LOCALNEWS_BUSINESS_FRESHRATE_MIN                                    600
#define NOM_LOCALNEWS_MONEY_FRESHRATE_MIN                                       600
#define NOM_LOCALNEWS_HEALTH_FRESHRATE_MIN                                      600
#define NOM_LOCALNEWS_SPORTS_FRESHRATE_MIN                                      600
#define NOM_LOCALNEWS_ARTANDENTERTAINMENT_FRESHRATE_MIN                         600
#define NOM_LOCALNEWS_EDUCATION_FRESHRATE_MIN                                   600
#define NOM_LOCALNEWS_TECHNOLOGYANDSCIENCE_FRESHRATE_MIN                        600
#define NOM_LOCALNEWS_FOODANDDRINK_FRESHRATE_MIN                                600
#define NOM_LOCALNEWS_TRAVELANDTOURISM_FRESHRATE_MIN                            600
#define NOM_LOCALNEWS_LIFESTYLE_FRESHRATE_MIN                                   600
#define NOM_LOCALNEWS_REALESTATE_FRESHRATE_MIN                                  600
#define NOM_LOCALNEWS_AUTO_FRESHRATE_MIN                                        600
#define NOM_LOCALNEWS_CRIMEANDDISASTER_FRESHRATE_MIN                            600
#define NOM_LOCALNEWS_WEATHER_FRESHRATE_MIN                                     600

#define NOM_LOCALNEWS_CHARITY_FRESHRATE_MIN                                     600
#define NOM_LOCALNEWS_CULTURE_FRESHRATE_MIN                                     600
#define NOM_LOCALNEWS_RELIGION_FRESHRATE_MIN                                    600
#define NOM_LOCALNEWS_PET_FRESHRATE_MIN                                         600

#define NOM_LOCALNEWS_MISC_FRESHRATE_MIN                                        600

/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM local news maxmum query time interval (in second)
 **********************************************************************************/
#define NOM_LOCALNEWS_PUBLICISSUE_FRESHRATE_MAX                                 7200
#define NOM_LOCALNEWS_POLITICS_FRESHRATE_MAX                                    7200
#define NOM_LOCALNEWS_BUSINESS_FRESHRATE_MAX                                    7200
#define NOM_LOCALNEWS_MONEY_FRESHRATE_MAX                                       7200
#define NOM_LOCALNEWS_HEALTH_FRESHRATE_MAX                                      7200
#define NOM_LOCALNEWS_SPORTS_FRESHRATE_MAX                                      7200
#define NOM_LOCALNEWS_ARTANDENTERTAINMENT_FRESHRATE_MAX                         7200
#define NOM_LOCALNEWS_EDUCATION_FRESHRATE_MAX                                   7200
#define NOM_LOCALNEWS_TECHNOLOGYANDSCIENCE_FRESHRATE_MAX                        7200
#define NOM_LOCALNEWS_FOODANDDRINK_FRESHRATE_MAX                                7200
#define NOM_LOCALNEWS_TRAVELANDTOURISM_FRESHRATE_MAX                            7200
#define NOM_LOCALNEWS_LIFESTYLE_FRESHRATE_MAX                                   7200
#define NOM_LOCALNEWS_REALESTATE_FRESHRATE_MAX                                  7200
#define NOM_LOCALNEWS_AUTO_FRESHRATE_MAX                                        7200
#define NOM_LOCALNEWS_CRIMEANDDISASTER_FRESHRATE_MAX                            7200
#define NOM_LOCALNEWS_WEATHER_FRESHRATE_MAX                                     7200

#define NOM_LOCALNEWS_CHARITY_FRESHRATE_MAX                                     7200
#define NOM_LOCALNEWS_CULTURE_FRESHRATE_MAX                                     7200
#define NOM_LOCALNEWS_RELIGION_FRESHRATE_MAX                                    7200
#define NOM_LOCALNEWS_PET_FRESHRATE_MAX                                         7200

#define NOM_LOCALNEWS_MISC_FRESHRATE_MAX                                        7200

/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM community query time interval (in second)
 **********************************************************************************/
#define NOM_COMMUNITY_EVENT_FRESHRATE_MIN                                 1800
#define NOM_COMMUNITY_EVENT_FRESHRATE_MAX                                 86400
#define NOM_COMMUNITY_YARDSALE_FRESHRATE_MIN                                 1800
#define NOM_COMMUNITY_YARDSALE_FRESHRATE_MAX                                 86400
/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM local news minmum query time interval (in second)
 **********************************************************************************/
#define NOM_TRAFFIC_PUBLICTRANSIT_DELAY_FRESHRATE_MIN                               60
#define NOM_TRAFFIC_PUBLICTRANSIT_PASSENGERSTUCK_FRESHRATE_MIN                      60

#define NOM_TRAFFIC_DRIVINGCONDITION_JAM_FRESHRATE_MIN                              60
#define NOM_TRAFFIC_DRIVINGCONDITION_CRASH_FRESHRATE_MIN                            60
#define NOM_TRAFFIC_DRIVINGCONDITION_POLICE_FRESHRATE_MIN                           60
#define NOM_TRAFFIC_DRIVINGCONDITION_CONSTRUCTION_FRESHRATE_MIN                     60
#define NOM_TRAFFIC_DRIVINGCONDITION_ROADCLOSURE_FRESHRATE_MIN                      60
#define NOM_TRAFFIC_DRIVINGCONDITION_BROKENTRAFFICLIGHT_FRESHRATE_MIN               60
#define NOM_TRAFFIC_DRIVINGCONDITION_STALLEDCAR_FRESHRATE_MIN                       60
/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM local news maxmum query time interval (in second)
 **********************************************************************************/
#define NOM_TRAFFIC_PUBLICTRANSIT_DELAY_FRESHRATE_MAX                               3600
#define NOM_TRAFFIC_PUBLICTRANSIT_PASSENGERSTUCK_FRESHRATE_MAX                      3600

#define NOM_TRAFFIC_DRIVINGCONDITION_JAM_FRESHRATE_MAX                              3600
#define NOM_TRAFFIC_DRIVINGCONDITION_CRASH_FRESHRATE_MAX                            3600
#define NOM_TRAFFIC_DRIVINGCONDITION_POLICE_FRESHRATE_MAX                           3600
#define NOM_TRAFFIC_DRIVINGCONDITION_CONSTRUCTION_FRESHRATE_MAX                     86400
#define NOM_TRAFFIC_DRIVINGCONDITION_ROADCLOSURE_FRESHRATE_MAX                      86400
#define NOM_TRAFFIC_DRIVINGCONDITION_BROKENTRAFFICLIGHT_FRESHRATE_MAX               3600
#define NOM_TRAFFIC_DRIVINGCONDITION_STALLEDCAR_FRESHRATE_MAX                       3600
/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM user login state
 **********************************************************************************/
#define NOM_USER_LOGIN_OK                                                           0
#define NOM_USER_LOGIN_FAILED_UNKNOWN                                               1
#define NOM_USER_LOGIN_FAILED_INVALIDUSER                                           2
#define NOM_USER_LOGIN_FAILED_INVALIDPW                                             3
#define NOM_USER_LOGIN_CANCEL                                                       -1
/**********************************************************************************/
/**********************************************************************************/

/**********************************************************************************
 * NOM user login state
 **********************************************************************************/
#define NOM_CUSTOMER_EMAIL               @"support@t2ge.com"
/**********************************************************************************/
/**********************************************************************************/


#define UNITTIMING_TIMER_INTERVAL                                 60
#define UNITTIMING_TIMER_SECOND                                   1
#define UNITTIMING_ADBANNER_AUTOHIDE_TIMER_INTERVAL               1

#define NOM_POSTREGION_OFFSET_LIMIT                         50000

#define NOM_AUTO_QUERY_DEFAULT_STEP                               20 //30
#define NOM_AUTO_SPOT_QUERY_DEFAULT_STEP                          241
#define NOM_AUTO_TAXI_QUERY_DEFAULT_STEP                          15

/**********************************************************************************
 * NOM Traffic spot
 **********************************************************************************/
#define NOM_TRAFFICSPOT_PHOTORADAR                              0
#define NOM_TRAFFICSPOT_SCHOOLZONE                              1
#define NOM_TRAFFICSPOT_PLAYGROUND                              2
#define NOM_TRAFFICSPOT_GASSTATION                              3
#define NOM_TRAFFICSPOT_PARKINGGROUND                           4

#define NOM_TRAFFICSPOT_ALL_SPEEDLIMIT                          5

#define NOM_TRAFFICSPOT_TYPEFIRSTONE                            NOM_TRAFFICSPOT_PHOTORADAR
#define NOM_TRAFFICSPOT_TYPELASTONE                             NOM_TRAFFICSPOT_ALL_SPEEDLIMIT

#define NOM_TRAFFICSPOT_PHOTORADAR_PREFIX                       @"xxxxxxxxxxxxxxxxxxxxxx"
#define NOM_TRAFFICSPOT_SCHOOLZONE_PREFIX                       @"xxxxxxxxxxxxxxxxxxxxxx"
#define NOM_TRAFFICSPOT_PLAYGROUND_PREFIX                       @"xxxxxxxxxxxxxxxxxxxxxx"
#define NOM_TRAFFICSPOT_GASSTATION_PREFIX                       @"xxxxxxxxxxxxxxxxxxxxxx"
#define NOM_TRAFFICSPOT_PARKING_DOMAIN                          @"xxxxxxxxxxxxxxxxxxxxxx"

//Primary key
#define NOM_TRAFFICSPOT_ID_KEY                          @"tsid"
#define NOM_TRAFFICSPOT_NAME_KEY                        @"tsname"
#define NOM_TRAFFICSPOT_LATITUDE_KEY                    @"tslat"
#define NOM_TRAFFICSPOT_LONGITUDE_KEY                   @"tslon"
#define NOM_TRAFFICSPOT_TYPE_KEY                        @"tstype"
#define NOM_TRAFFICSPOT_PRICE_KEY                       @"tsprice"
#define NOM_TRAFFICSPOT_PRICETIME_KEY                   @"tsptime"
#define NOM_TRAFFICSPOT_PRICEUNIT_KEY                   @"tspunit"
#define NOM_TRAFFICSPOT_ADDRESS_KEY                     @"tsaddress"
#define NOM_TRAFFICSPOT_SUBTYPE_KEY                     @"tstype2"
#define NOM_TRAFFICSPOT_THIRDTYPE_KEY                   @"tstype3"
#define NOM_TRAFFICSPOT_FOURTHTYPE_KEY                  @"tstype4"

#define NOM_GASSTATION_PRICEUNIT_CENTLITRE                                  0
#define NOM_GASSTATION_PRICEUNIT_DOLLARLITRE                                1
#define NOM_GASSTATION_PRICEUNIT_DOLLARGALLON                               2
#define NOM_GASSTATION_PRICEUNIT_CENTGALLON                                 3

#define NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA                                  0
#define NOM_PHOTORADAR_TYPE_SPEEDCAMERA                                     1

#define NOM_PHOTORADAR_DIRECTION_NONE                                       0
#define NOM_PHOTORADAR_DIRECTION_NB                                         1
#define NOM_PHOTORADAR_DIRECTION_SB                                         2
#define NOM_PHOTORADAR_DIRECTION_EB                                         3
#define NOM_PHOTORADAR_DIRECTION_WB                                         4
#define NOM_PHOTORADAR_DIRECTION_NB_SB                                      5
#define NOM_PHOTORADAR_DIRECTION_NB_EB                                      6
#define NOM_PHOTORADAR_DIRECTION_NB_WB                                      7
#define NOM_PHOTORADAR_DIRECTION_SB_EB                                      8
#define NOM_PHOTORADAR_DIRECTION_SB_WB                                      9
#define NOM_PHOTORADAR_DIRECTION_EB_WB                                      10
#define NOM_PHOTORADAR_DIRECTION_NB_SB_EB                                   11
#define NOM_PHOTORADAR_DIRECTION_NB_SB_WB                                   12
#define NOM_PHOTORADAR_DIRECTION_NB_EB_WB                                   13
#define NOM_PHOTORADAR_DIRECTION_SB_EB_WB                                   14
#define NOM_PHOTORADAR_DIRECTION_NB_SB_EB_WB                                15

#define NOM_SPEEDCAMERA_TYPE_FIXED                                          0
#define NOM_SPEEDCAMERA_TYPE_MOBILORSPEEDTRAP                               1

#define NOM_GASSTATION_CARWASH_TYPE_NONE                                    0
#define NOM_GASSTATION_CARWASH_TYPE_HAVE                                    1


#define NOM_PARKING_RATEUNIT_HOUR                                           0
#define NOM_PARKING_RATEUNIT_QUARTERHOUR                                    1
#define NOM_PARKING_RATEUNIT_HALFHOUR                                       2
#define NOM_PARKING_RATEUNIT_TWOHOUR                                        3
#define NOM_PARKING_RATEUNIT_HALFDAY                                        4
#define NOM_PARKING_RATEUNIT_ONEDAY                                         5

/**********************************************************************************/
/**********************************************************************************/

#define NOM_MAPSPOT_DS_NONE                                        0
#define NOM_MAPSPOT_DS_TRAFFIC_GASSTATION                          1
#define NOM_MAPSPOT_DS_TRAFFIC_REDLIGHTCAMERA                      2
#define NOM_MAPSPOT_DS_TRAFFIC_SPEEDCAMERA                         4
#define NOM_MAPSPOT_DS_TRAFFIC_SCHOOLZONE                          8
#define NOM_MAPSPOT_DS_TRAFFIC_PLAYGROUND                          16
#define NOM_MAPSPOT_DS_TRAFFIC_PARKINGGROUND                       32
#define NOM_MAPSPOT_DS_TRAFFIC_SPEEDLIMITSPOTS                     64

#define NOM_MAPSPOT_DS_SPAN_DEFAULT                                30                           //km
#define NOM_MAPSPOT_DS_SPAN_MAX                                    100                           //km

#define NOM_DRIVINGMODE_QUERY_TIME_MAX                             7200
#define NOM_DRIVINGMODE_QUERY_TIME_MIN                             1800
#define NOM_DRIVINGMODE_QUERY_TIME_DEFAULT                         3600

#define NOM_DRIVINGMODE_REFRESH_TIME_MAX                           600
#define NOM_DRIVINGMODE_REFRESH_TIME_MIN                           30
#define NOM_DRIVINGMODE_REFRESH_TIME_DEFAULT                       30

#define NOM_DRIVINGMODE_POSITION_UPDATE_TIME_MAX                   120
#define NOM_DRIVINGMODE_POSITION_UPDATE_TIME_MIN                   2
#define NOM_DRIVINGMODE_POSITION_UPDATE_TIME_DEFAULT               4


//#define NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT                  86400
#define NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT                  3600
#define NOM_TAXINEWS_SQS_RETENTION_TIME_DEFAULT                     900
#define NOM_SQS_VISIBLE_TIMEOUT_DEFAULT                             20

/**********************************************************************************
 * NOM user state
 **********************************************************************************/
#define NOM_USERMODE_UNINITIALIZEDTOU   -3
#define NOM_USERMODE_LOADINGMAP         -2
#define NOM_USERMODE_IDLE               -1
#define NOM_USERMODE_QUERY              0
#define NOM_USERMODE_POST               1
#define NOM_USERMODE_SETUP              2
#define NOM_USERMODE_TWITTERSETUP       3
#define NOM_USERMODE_MARKTRAFFICSPOT    4
#define NOM_USERMODE_QUERYTRAFFICSPOT   5
#define NOM_USERMODE_DRIVINGMODE        6

/**********************************************************************************
 * NOM message retention time in AWS SQS
 **********************************************************************************/

#define NOM_TWITTER_TITLE_MAX_LENGHT        24

#endif
