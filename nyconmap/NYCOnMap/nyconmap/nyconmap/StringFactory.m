//
//  StringFactory.m
//  XXXX
//
//  Created by Zhaohui Xing on 10-05-12.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "StringFactory.h"
#import "NOMSystemConstants.h"

#define LANGID_EN	0
#define LANGID_ZH	1
#define LANGID_CH	2
#define LANGID_FR	3
#define LANGID_GR	4
#define LANGID_JP	5

#ifdef RELEASE_VERSION_91
#undef RELEASE_VERSION_91
#endif

//#define RELEASE_VERSION_91
 

@implementation StringFactory

+(BOOL)IsOSLangEN
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_EN)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangFR
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_FR)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangGR
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_GR)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangJP
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_JP)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangZH
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_ZH)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangCH
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_CH)
		bRet = YES;
	
	return bRet;
}

+(int)GetString_OSLangID
{
	int nRet = LANGID_ZH;
	NSString* str = @"OS_LANGSETTING";
	
	//Localization string query here
	str = NSLocalizedString(@"OS_LANGSETTING", @"Start label string");
	
	if([str isEqualToString:@"0"] == YES)
		nRet = LANGID_EN;
	else if([str isEqualToString:@"1"] == YES)
		nRet = LANGID_ZH;
	else if([str isEqualToString:@"2"] == YES)
		nRet = LANGID_CH;
	else if([str isEqualToString:@"3"] == YES)
		nRet = LANGID_FR;

	
	return nRet;
}	


+(NSString*)GetString_Commercial
{
	NSString* str = @"Commercial";
	
	//Localization string query here
	str = NSLocalizedString(@"Commercial", @"Commercial label string");
	
	return str;
}

+(NSString*)GetString_Community
{
	NSString* str = @"Community";
	
	//Localization string query here
	str = NSLocalizedString(@"Community", @"Community label string");
	
	return str;
}

+(NSString*)GetString_LocalNews
{
	NSString* str = @"Local News";
	
	//Localization string query here
	str = NSLocalizedString(@"Local News", @"Local News label string");
	
	return str;
}

+(NSString*)GetString_Organization;
{
	NSString* str = @"Organization";
	
	//Localization string query here
	str = NSLocalizedString(@"Organization", @"Organization label string");
	
	return str;
}

+(NSString*)GetString_Traffic;
{
	NSString* str = @"Traffic";
	
	//Localization string query here
	str = NSLocalizedString(@"Traffic", @"Traffic label string");
	
	return str;
}


+(NSString*)GetString_CommercialFoodDrink
{
	NSString* str = @"Food & Drink";
	
	//Localization string query here
	str = NSLocalizedString(@"Food & Drink", @"Food & Drink label string");
	
	return str;
}
+(NSString*)GetString_CommercialRental
{
	NSString* str = @"Rental";
	
	//Localization string query here
	str = NSLocalizedString(@"Rental", @"Rental label string");
	
	return str;
}

+(NSString*)GetString_CommercialYardSale
{
	NSString* str = @"Yard Sale";
	
	//Localization string query here
	str = NSLocalizedString(@"Yard Sale", @"Yard Sale label string");
	
	return str;
}

+(NSString*)GetString_CommunityEvent
{
	NSString* str = @"Community Event";
	
	//Localization string query here
	str = NSLocalizedString(@"Community Event", @"Community Event label string");
	
	return str;
}

+(NSString*)GetString_CommunityYardSale
{
	NSString* str = @"Yard Sale";
	
	//Localization string query here
	str = NSLocalizedString(@"Yard Sale", @"Yard Sale label string");
	
	return str;
}

+(NSString*)GetString_CommunityNews
{
	NSString* str = @"News";
	
	//Localization string query here
	str = NSLocalizedString(@"News", @"News label string");
	
	return str;
}


+(NSString*)GetString_CalenderNew
{
	NSString* str = @"New";
	
	//Localization string query here
	str = NSLocalizedString(@"New", @"New label string");
	
	return str;
}


+(NSString*)GetString_CalenderCheck
{
	NSString* str = @"Calender";
	
	//Localization string query here
	str = NSLocalizedString(@"Calender", @"Calender label string");
	
	return str;
}

+(NSString*)GetString_MyGEOFavorite
{
	NSString* str = @"My GEO Favorite";
	
	//Localization string query here
	str = NSLocalizedString(@"My GEO Favorite", @"My GEO Favorite label string");
	
	return str;
}

+(NSString*)GetString_ManageGEOFavorite
{
	NSString* str = @"Manage GEO Favorite";
	
	//Localization string query here
	str = NSLocalizedString(@"Manage GEO Favorite", @"Manage GEO Favorite label string");
	
	return str;
}

+(NSString*)GetString_MapStandard
{
	NSString* str = @"Standard";
	
	//Localization string query here
	str = NSLocalizedString(@"Standard", @"Standard label string");
	
	return str;
}

+(NSString*)GetString_MapHybird
{
	NSString* str = @"Hybird";
	
	//Localization string query here
	str = NSLocalizedString(@"Hybird", @"Hybird label string");
	
	return str;
}

+(NSString*)GetString_MapSatellite
{
	NSString* str = @"Satellite";
	
	//Localization string query here
	str = NSLocalizedString(@"Satellite", @"Satellite label string");
	
	return str;
}

+(NSString*)GetString_Configuration
{
	NSString* str = @"Configuration";
	
	//Localization string query here
	str = NSLocalizedString(@"Configuration", @"Configuration label string");
	
	return str;
}

+(NSString*)GetString_LocalNewsTitle:(int)nSubCategory
{
    NSString* strTitle = @"";
    
    switch (nSubCategory)
    {
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_PUBLICISSUE:
            strTitle = NSLocalizedString(@"Public Issue", @"Public Issue label string");
            break;
        
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_POLITICS:
            strTitle = NSLocalizedString(@"Politics", @"Politics label string");
            break;
        
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_BUSINESS:
            strTitle = NSLocalizedString(@"Business", @"Business label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_MONEY:
            strTitle = NSLocalizedString(@"Money", @"Money label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_HEALTH:
            strTitle = NSLocalizedString(@"Health", @"Health label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_SPORTS:
            strTitle = NSLocalizedString(@"Sports", @"Sports label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ARTANDENTERTAINMENT:
            strTitle = NSLocalizedString(@"Art&Entertainment", @"Art&Entertainment label string");
            break;
        
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_EDUCATION:
            strTitle = NSLocalizedString(@"Education", @"Education label string");
            break;
        
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TECHNOLOGYANDSCIENCE:
            strTitle = NSLocalizedString(@"Technology&Science", @"Technology&Science label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_FOODANDDRINK:
            strTitle = NSLocalizedString(@"Food&Drink", @"Food&Drink label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_TRAVELANDTOURISM:
            strTitle = NSLocalizedString(@"Travel&Tourism", @"Travel&Tourism label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_LIFESTYLE:
            strTitle = NSLocalizedString(@"Life Style", @"Life Style label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_REALESTATE:
            strTitle = NSLocalizedString(@"Real Estate", @"Real Estate label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_AUTO:
            strTitle = NSLocalizedString(@"Auto", @"Auto label string");
            break;
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CRIMEANDDISASTER:
            strTitle = NSLocalizedString(@"Crime&Disaster", @"Crime&Disaster label string");
            break;
        
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_WEATHER:
            strTitle = NSLocalizedString(@"Weather", @"Weather label string");
            break;
        
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CHARITY:
            strTitle = NSLocalizedString(@"Charity", @"Charity label string");
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_CULTURE:
            strTitle = NSLocalizedString(@"Culture", @"Culture label string");
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_RELIGION:
            strTitle = NSLocalizedString(@"Religion", @"Religion label string");
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ANIMALPET:
            strTitle = NSLocalizedString(@"Animal & Pet", @"Animal & Pet label string");
            break;
            
        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_MISC:
            strTitle = NSLocalizedString(@"Misc", @"Misc label string");
            break;

        case NOM_NEWSCATEGORY_LOCALNEWS_SUBCATEGORY_ALL:
            strTitle = [StringFactory GetString_All];
            break;
            
        default:
            break;
    }
    
    return strTitle;
}


+(NSString*)GetString_CommunityTitle:(int)nSubCategory
{
    NSString* strTitle = @"";
    
    switch (nSubCategory)
    {
        case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYEVENT:
            strTitle = NSLocalizedString(@"Community Event", @"Community Event label string");
            break;

        case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYYARDSALE:
            strTitle = NSLocalizedString(@"Yard Sale", @"Yard Sale label string");
            break;
            
        case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYWIKI:
            strTitle = NSLocalizedString(@"Community Wiki", @"Community Wiki label string");
            break;
            
        case NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_ALL:
            //strTitle = NSLocalizedString(@"Point of Interest", @"Point of Interest label string");
            strTitle = [StringFactory GetString_All];
            break;
            
        default:
            break;
    }
    
    return strTitle;
}


+(NSString*)GetString_PublicTransitTypeString:(int)nType
{
    NSString* strTitle = @"";
    
    switch (nType)
    {
        //case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_DELAY:
        //    strTitle = NSLocalizedString(@"Delay", @"Delay label string");
        //    break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY:
            strTitle = NSLocalizedString(@"Bus Delay", @"Bus Delay label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_TRAIN_DELAY:
            strTitle = NSLocalizedString(@"Train Delay", @"Train Delay label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_FLIGHT_DELAY:
            strTitle = NSLocalizedString(@"Flight Delay", @"Flight Delay label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK:
            strTitle = NSLocalizedString(@"Passenger Overcrowd", @"Passenger Overcrowd label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_ALL:
            strTitle = [StringFactory GetString_All];
            break;
        default:
            break;
    }
    
    return strTitle;
}

+(NSString*)GetString_DrivingConditionTypeString:(int)nType
{
    NSString* strTitle = @"";
    
    switch (nType)
    {
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM:
            strTitle = NSLocalizedString(@"Traffic Jam", @"Traffic Jam label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH:
            strTitle = NSLocalizedString(@"Car Crash", @"Car Crash label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE:
            strTitle = NSLocalizedString(@"Police Checkpoint", @"Police Checkpoint label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION:
            strTitle = NSLocalizedString(@"Construction Zone", @"Construction Zone label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE:
            strTitle = NSLocalizedString(@"Road Closure", @"Road Closure label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT:
            strTitle = NSLocalizedString(@"Broken Traffic Light", @"Broken Traffic Light label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR:
            strTitle = NSLocalizedString(@"Stalled Car", @"Stalled Car label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG:
            strTitle = NSLocalizedString(@"Foggy Conditions", @"Foggy Conditions label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION:
            strTitle = NSLocalizedString(@"Dangerous Conditions", @"Dangerous Conditions label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN:
            strTitle = NSLocalizedString(@"Rain", @"Rain label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE:
            strTitle = NSLocalizedString(@"Icy Conditions", @"Icy Conditions label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND:
            strTitle = NSLocalizedString(@"Strong Winds", @"Strong Winds label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE:
            strTitle = NSLocalizedString(@"Lane Closure", @"Lane Closure label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE:
            strTitle = NSLocalizedString(@"Highway Ramp Closure", @"Highway Ramp Closure label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR:
            strTitle = NSLocalizedString(@"Detour", @"Detour label string");
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ALL:
            strTitle = [StringFactory GetString_All];
            break;
        default:
            break;
    }
    
    return strTitle;
}

+(NSString*)GetString_TrafficTypeTitle:(int)nSubCategory withType:(int)nType
{
    NSString* strTitle = @"";
    
    switch (nSubCategory)
    {
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT:
            strTitle = [StringFactory GetString_PublicTransitTypeString:nType];
            break;
            
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION:
            strTitle = [StringFactory GetString_DrivingConditionTypeString:nType];
            break;
            
        default:
            break;
    }
    
    return strTitle;
}

+(NSString*)GetString_TrafficTitle:(int)nSubCategory
{
    NSString* strTitle = @"";
    
    switch (nSubCategory)
    {
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT:
            strTitle = NSLocalizedString(@"Public Transit", @"Public Transit label string");
            break;
            
        case NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION:
            strTitle = NSLocalizedString(@"Driving Condition", @"Driving Condition label string");
            break;
        
        default:
            break;
    }
    
    return strTitle;
}

+(NSString*)GetString_TaxiTitle:(int)nSubCategory
{
    NSString* strTitle = @"";
    
    switch (nSubCategory)
    {
        case NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIAVAILABLEBYDRIVER:
            strTitle = NSLocalizedString(@"Taxi available for passenger", @"Taxi Available for Passenger label string");
            break;
        case NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIREQUESTBYPASSENGER:
            strTitle = NSLocalizedString(@"Passenger needing taxi", @"Passenger Needing Taxi label string");
            break;
        default:
            break;
    }
    
    return strTitle;
}

+(NSString*)GetString_NewsTitle:(int)nCategory subCategory:(int)nSubCategory
{
    NSString* strTitle = @"";
    
    switch (nCategory)
    {
        case NOM_NEWSCATEGORY_LOCALNEWS:
            strTitle = [StringFactory GetString_LocalNewsTitle:nSubCategory];
            break;
        case NOM_NEWSCATEGORY_COMMUNITY:
            strTitle = [StringFactory GetString_CommunityTitle:nSubCategory];
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC:
            strTitle = [StringFactory GetString_TrafficTitle:nSubCategory];
            break;
        case NOM_NEWSCATEGORY_TAXI:
            strTitle = [StringFactory GetString_TaxiTitle:nSubCategory];
            break;
        default:
            {
                int16_t nSpotType = (int16_t)nCategory - NOM_NEWSCATEGORY_NONENEWS_BASE_ID;
                strTitle = [StringFactory GetString_SpotSubTitle:nSpotType sithSubTitle:nSubCategory];
            }
            break;
    }
    
    return strTitle;
}

+(NSString*)GetString_NewsMainTitle:(int)nCategory
{
    NSString* strTitle = @"";
    
    switch (nCategory)
    {
        case NOM_NEWSCATEGORY_LOCALNEWS:
            strTitle = [StringFactory GetString_LocalNews];
            break;
        case NOM_NEWSCATEGORY_COMMUNITY:
            strTitle = [StringFactory GetString_Community];
            break;
        case NOM_NEWSCATEGORY_LOCALTRAFFIC:
            strTitle = [StringFactory GetString_Traffic];
            break;
            
        default:
            break;
    }
    
    return strTitle;
}

 
+(NSString*)GetString_OK
{
	NSString* str = @"OK";
	
	str = NSLocalizedString(@"OK", @"OK string");
    
    return str;
}

+(NSString*)GetString_Cancel
{
	NSString* str = @"Cancel";
	
	str = NSLocalizedString(@"Cancel", @"Cancel string");
    
    return str;
}

+(NSString*)GetString_Yes
{
	NSString* str = @"Yes";
	
	str = NSLocalizedString(@"Yes", @"Yes string");
    
    return str;
}

+(NSString*)GetString_No
{
	NSString* str = @"No";
	
	str = NSLocalizedString(@"No", @"No string");
    
    return str;
}

+(NSString*)GetString_Close
{
	NSString* str = @"Close";
	
	str = NSLocalizedString(@"Close", @"Close string");
    
    return str;
}

+(NSString*)GetString_LocationForPosting
{
	NSString* str = @"Location For Posting";
	
	str = NSLocalizedString(@"Location For Posting", @"Location For Posting string");
    
    return str;
}

+(NSString*)GetString_InputLocationAddress
{
	NSString* str = @"Input Location Address";
	
	str = NSLocalizedString(@"Input Location Address", @"Input Location Address string");
    
    return str;
}

+(NSString*)GetString_PinOnMap
{
	NSString* str = @"Pin Location On Map";
	
	str = NSLocalizedString(@"Pin Location On Map", @"Pin Location On Map string");
    
    return str;
}

+(NSString*)GetString_CurrentLocation
{
	NSString* str = @"Current Location";
	
	str = NSLocalizedString(@"Current Location", @"Current Location string");
    
    return str;
}

+(NSString*)GetString_Street
{
	NSString* str = @"Street";
	
	str = NSLocalizedString(@"Street", @"Street string");
    
    return str;
}

+(NSString*)GetString_City
{
	NSString* str = @"City";
	
	str = NSLocalizedString(@"City", @"City string");
    
    return str;
}

+(NSString*)GetString_State
{
	NSString* str = @"State/Prov";
	
	str = NSLocalizedString(@"State/Prov", @"State/Prov string");
    
    return str;
}


+(NSString*)GetString_Country
{
	NSString* str = @"Country";
	
	str = NSLocalizedString(@"Country", @"Country string");
    
    return str;
}

+(NSString*)GetString_ZipCode
{
	NSString* str = @"Zip Code";
	
	str = NSLocalizedString(@"Zip Code", @"Zip Code string");
    
    return str;
}

+(NSString*)GetString_InvalidStreet
{
	NSString* str = @"Invalid Street";
	
	str = NSLocalizedString(@"Invalid Street", @"Invalid Street string");
    
    return str;
}

+(NSString*)GetString_InvalidCity
{
	NSString* str = @"Invalid City";
	
	str = NSLocalizedString(@"Invalid City", @"Invalid City string");
    
    return str;
}

+(NSString*)GetString_InvalidZipCode
{
	NSString* str = @"Invalid ZipCode";
	
	str = NSLocalizedString(@"Invalid ZipCode", @"Invalid ZipCode string");
    
    return str;
}

+(NSString*)GetString_LantitudeABV
{
	NSString* str = @"Lat";
	
	str = NSLocalizedString(@"Lat", @"Lat string");
    
    return str;
}

+(NSString*)GetString_LongitudeABV
{
	NSString* str = @"Lon";
	
	str = NSLocalizedString(@"Lon", @"Lon string");
    
    return str;
}

+(NSString*)GetString_Post
{
	NSString* str = @"Post";
	
	str = NSLocalizedString(@"Post", @"Post string");
    
    return str;
}

+(NSString*)GetString_Photo
{
	NSString* str = @"Photo";
	
	str = NSLocalizedString(@"Photo", @"Post string");
    
    return str;
}

+(NSString*)GetString_DeletePhoto
{
	NSString* str = @"Delete Photo";
	
	str = NSLocalizedString(@"Delete", @"Delete Photo string");
    
    return str;
}

+(NSString*)GetString_SubjectLabel
{
	NSString* str = @"Subject Label";
	
	str = NSLocalizedString(@"Subject Label", @"Subject Label string");
    
    return str;
}

+(NSString*)GetString_PostLabel
{
	NSString* str = @"Post Label";
	
	str = NSLocalizedString(@"Post Label", @"Post Label Photo string");
    
    return str;
}

+(NSString*)GetString_KeywordLabel
{
	NSString* str = @"Keyword";
	
	str = NSLocalizedString(@"Keyword label", @"Keyword string");
    
    return str;
}

+(NSString*)GetString_CopyrightLabel
{
	NSString* str = @"Copyright";
	
	str = NSLocalizedString(@"Copyright label", @"Copyright string");
    
    return str;
}

+(NSString*)GetString_InvalidSubject
{
	NSString* str = @"InvalidSubject";
	
	str = NSLocalizedString(@"InvalidSubject", @"InvalidSubject string");
    
    return str;
}

+(NSString*)GetString_InvalidPost
{
	NSString* str = @"InvalidPost";
	
	str = NSLocalizedString(@"InvalidPost", @"InvalidPost string");
    
    return str;
}

+(NSString*)GetString_PostFailed
{
	NSString* str = @"PostFailed";
	
	str = NSLocalizedString(@"PostFailed", @"PostFailed string");
    
    return str;
}

+(NSString*)GetString_PostSucceed
{
	NSString* str = @"PostSucceed";
	
	str = NSLocalizedString(@"PostSucceed", @"PostSucceed string");
    
    return str;
}

+(NSString*)GetString_All
{
	NSString* str = @"All";
	
	str = NSLocalizedString(@"All", @"All string");
    
    return str;
}

+(NSString*)GetString_AddDetail
{
	NSString* str = @"Add Detail";
	
	str = NSLocalizedString(@"Add Detail", @"Add Detail string");
    
    return str;
}

+(NSString*)GetString_PostNow
{
	NSString* str = @"Post Now";
	
	str = NSLocalizedString(@"Post Now", @"Post Now string");
    
    return str;
}

+(NSString*)GetString_Anonymous
{
	NSString* str = @"Anonymous";
	
	str = NSLocalizedString(@"Anonymous", @"Anonymous string");
    
    return str;
}

+(NSString*)GetString_PostTime
{
	NSString* str = @"Post Time";
	
	str = NSLocalizedString(@"Post Time", @"Post Time string");
    
    return str;
}

+(NSString*)GetString_Period
{
	NSString* str = @"Period";
	
	str = NSLocalizedString(@"Period", @"Period string");
    
    return str;
}

+(NSString*)GetString_Refresh
{
	NSString* str = @"Auto Reload";
	
	str = NSLocalizedString(@"Auto Reload", @"Reload string");
    
    return str;
}

+(NSString*)GetString_Day
{
	NSString* str = @"Day";
	
	str = NSLocalizedString(@"Day", @"Day string");
    
    return str;
}

+(NSString*)GetString_Hour
{
	NSString* str = @"Hour";
	
	str = NSLocalizedString(@"Hour", @"Hour string");
    
    return str;
}

+(NSString*)GetString_Minute
{
	NSString* str = @"Minute";
	
	str = NSLocalizedString(@"Minute", @"Minute string");
    
    return str;
}

+(NSString*)GetString_Reload
{
	NSString* str = @"Reload";
	
	str = NSLocalizedString(@"Reload", @"Reload string");
    
    return str;
}

+(NSString*)GetString_ClearMap
{
	NSString* str = @"ClearMap";
	
	str = NSLocalizedString(@"Clear Map", @"ClearMap string");
    
    return str;
}

+(NSString*)GetString_MyLocation
{
	NSString* str = @"My Location";
	
	str = NSLocalizedString(@"My Location", @"My Location string");
    
    return str;
}

+(NSString*)GetString_EndQueryTime
{
	NSString* str = @"End Time To Search";
	
	str = NSLocalizedString(@"End Time To Search", @"End Time To Search string");
    
    return str;
}

+(NSString*)GetString_StartQueryTime
{
	NSString* str = @"Start Time To Search";
	
	str = NSLocalizedString(@"Start Time To Search", @"Start Time To Search string");
    
    return str;
}

+(NSString*)GetString_Now
{
	NSString* str = @"Now";
	
	str = NSLocalizedString(@"Now", @"Now string");
    
    return str;
}

+(NSString*)GetString_CustomizeSearchTime
{
	NSString* str = @"Customize Search Time";
	
	str = NSLocalizedString(@"Customize Search Time", @"Customize Search Time string");
    
    return str;
}

+(NSString*)GetString_SearchTime
{
	NSString* str = @"Search Time";
	
	str = NSLocalizedString(@"Search Time", @"Search Time string");
    
    return str;
}

+(NSString*)GetString_EnableAutoload
{
    NSString* str = @"Enable Auto Reload";
	
    str = NSLocalizedString(@"Enable Auto Reload", @"Enable Auto Reload string");
    
    return str;
}

+(NSString*)GetString_InstallNewVersion
{
    NSString* str = @"Install New Version";
	
    str = NSLocalizedString(@"Install New Version", @"Install New Version string");
    
    return str;
}

+(NSString*)GetString_CopyrightSign
{
    NSString* str = @"Copyright@";
	
    str = NSLocalizedString(@"Copyright@", @"Copyright@ string");
    
    return str;
}

+(NSString*)GetString_CopyrightCompany
{
    NSString* str = @"IPOwner";
	
    str = NSLocalizedString(@"IPOwner", @"IPOwner string");
    
    return str;
}

+(NSString*)GetString_NewVersionAlert
{
    NSString* str = @"NewVersionAlert";
	
    str = NSLocalizedString(@"NewVersionAlert", @"NewVersionAlert string");
    
    return str;
}


+(NSString*)GetString_Login
{
    NSString* str = @"Login";
	
    str = NSLocalizedString(@"Login", @"Login string");
    
    return str;
}

+(NSString*)GetString_Password
{
    NSString* str = @"Password";
	
    str = NSLocalizedString(@"Password", @"Password string");
    
    return str;
}

+(NSString*)GetString_Email
{
    NSString* str = @"Email";
	
    str = NSLocalizedString(@"Email", @"Email string");
    
    return str;
}

+(NSString*)GetString_ForgetPW
{
    NSString* str = @"Forget Password";
	
    str = NSLocalizedString(@"Forget Password", @"Forget Password string");
    
    return str;
}

+(NSString*)GetString_LoginFailedByUnknown
{
    NSString* str = @"Login is failed by unknown reason";
	
    str = NSLocalizedString(@"Login is failed by unknown reason", @"Login is failed by unknown reason string");
    
    return str;
}

+(NSString*)GetString_InvalidEmail
{
    NSString* str = @"Invalid user account email";
	
    str = NSLocalizedString(@"Invalid user account email", @"Invalid user account email string");
    
    return str;
}

+(NSString*)GetString_InvalidPW
{
    NSString* str = @"Invalid password";
	
    str = NSLocalizedString(@"Invalid password", @"Invalid password string");
    
    return str;
}

+(NSString*)GetString_EmptyEmail
{
    NSString* str = @"Empty Email";
	
    str = NSLocalizedString(@"Empty Email", @"Empty Email string");
    
    return str;
}

+(NSString*)GetString_EmptyPW
{
    NSString* str = @"Empty Password";
	
    str = NSLocalizedString(@"Empty Password", @"Empty Password string");
    
    return str;
}

+(NSString*)GetString_UserPWEmailSubject
{
    NSString* str = @"Information of your password";
	
    str = NSLocalizedString(@"Information of your password", @"Information of your password string");
    
    return str;
}

+(NSString*)GetString_CustomerEmailHead
{
    NSString* str = @"CustomerEmailHead";
	
    str = NSLocalizedString(@"CustomerEmailHead", @"CustomerEmailHead string");
    
    return str;
}

+(NSString*)GetString_CustomerSupportTeam;
{
    NSString* str = @"CustomerSupportTeam";
	
    str = NSLocalizedString(@"CustomerSupportTeam", @"ICustomerSupportTeam string");
    
    return str;
}

+(NSString*)GetString_QueryConfiguration
{
    NSString* str = @"Search Setting";
	
    str = NSLocalizedString(@"Search Setting", @"Search Setting string");
    
    return str;
}

+(NSString*)GetString_UserConfiguration
{
    NSString* str = @"User Setting";
	
    str = NSLocalizedString(@"User Setting", @"User Setting string");
    
    return str;
}

+(NSString*)GetString_DisplayName
{
    NSString* str = @"Display Name";
	
    str = NSLocalizedString(@"Display Name", @"Display Name string");
    
    return str;
}

+(NSString*)GetString_LastName
{
    NSString* str = @"Last Name";
	
    str = NSLocalizedString(@"Last Name", @"Last Name string");
    
    return str;
}

+(NSString*)GetString_FirstName
{
    NSString* str = @"First Name";
	
    str = NSLocalizedString(@"First Name", @"First Name string");
    
    return str;
}

+(NSString*)GetString_CreateUserAccount
{
    NSString* str = @"Create User Account";
	
    str = NSLocalizedString(@"Create User Account", @"Create User Account string");
    
    return str;
}

+(NSString*)GetString_UpdateUserAccount;
{
    NSString* str = @"Update User Account";
	
    str = NSLocalizedString(@"Update User Account", @"Update User Account string");
    
    return str;
}

+(NSString*)GetString_EmptyDName
{
    NSString* str = @"Empty DisplayName";
	
    str = NSLocalizedString(@"Empty DisplayName", @"Empty DisplayName string");
    
    return str;
}

+(NSString*)GetString_UserUpdateSucceed
{
    NSString* str = @"Succeed in updating user information";
	
    str = NSLocalizedString(@"Succeed in updating user information", @"Succeed in updating user information string");
    
    return str;
}

+(NSString*)GetString_UserUpdateFailed
{
    NSString* str = @"Failed to update user information";
	
    str = NSLocalizedString(@"Failed to update user information", @"Failed to update user information string");
    
    return str;
}

+(NSString*)GetString_UserCreateSucceed
{
    NSString* str = @"Succeed in creating user account";
	
    str = NSLocalizedString(@"Succeed in creating user account", @"Succeed in creating user acount string");
    
    return str;
}

+(NSString*)GetString_UserCreateFailed
{
    NSString* str = @"Failed to create user account";
	
    str = NSLocalizedString(@"Failed to create user account", @"Failed to update user account string");
    
    return str;
}

+(NSString*)GetString_PleaseEnableLocationService
{
    NSString* str = @"PleaseEnableLocationService";
	
    str = NSLocalizedString(@"PleaseEnableLocationService", @"PleaseEnableLocationService string");
    
    return str;
}

+(NSString*)GetString_LoginOrCreateAccountWarn
{
    NSString* str = @"LoginOrCreateAccountWarn";
	
    str = NSLocalizedString(@"LoginOrCreateAccountWarn", @"LoginOrCreateAccountWarn string");
    
    return str;
}

+(NSString*)GetString_CloseAdCaptionFormat
{
    NSString* str = @"CloseAdCaptionFormat";
	
    str = NSLocalizedString(@"CloseAdCaptionFormat", @"CloseAdCaptionFormat string");
    
    return str;
}

+(NSString*)GetString_CannotPostNonLocalMsgWarn
{
    NSString* str = @"CannotPostNonLocalMsgWarn";
	
    str = NSLocalizedString(@"CannotPostNonLocalMsgWarn", @"CannotPostNonLocalMsgWarn string");
    
    return str;
}

+(NSString*)GetString_Time
{
    NSString* str = @"Time";
	
    str = NSLocalizedString(@"Time", @"Time string");
    
    return str;
}

+(NSString*)GetString_InvalidTime
{
    NSString* str = @"InvalidTime";
	
    str = NSLocalizedString(@"InvalidTime", @"InvalidTime string");
    
    return str;
}

+(NSString*)GetString_NobodyPostWarn
{
    NSString* str = @"NobodyPostWarn";
	
    str = NSLocalizedString(@"NobodyPostWarn", @"NobodyPostWarn string");
    
    return str;
}

+(NSString*)GetString_NoCommunityEventWarn
{
    NSString* str = @"NoCommunityEventWarn";
	
    str = NSLocalizedString(@"NoCommunityEventWarn", @"NoCommunityEventWarn string");
    
    return str;
}

+(NSString*)GetString_NetworkWarn
{
	NSString* str = @"NetworkWarn";
	
	//Localization string query here
	str = NSLocalizedString(@"NetworkWarn", @"NetworkWarn label string");
	
    return str;
}

+(NSString*)GetString_Accept
{
	NSString* str = @"Accept";
	
	//Localization string query here
	str = NSLocalizedString(@"Accept", @"Accept string");
	
    return str;
}

+(NSString*)GetString_Reject
{
	NSString* str = @"Reject";
	
	//Localization string query here
	str = NSLocalizedString(@"Reject", @"Reject string");
	
    return str;
}

+(NSString*)GetString_Privacy
{
	NSString* str = @"Privacy";
	
	//Localization string query here
	str = NSLocalizedString(@"Privacy", @"Privacy string");
	
    return str;
}

+(NSString*)GetString_TermOfUse
{
	NSString* str = @"TermOfUse";
	
	//Localization string query here
	str = NSLocalizedString(@"TermOfUse", @"TermOfUse string");
	
    return str;
}

+(NSString*)GetString_AcceptedTermOfUseFMT
{
	NSString* str = @"AcceptedTermOfUseFMT";
	
	//Localization string query here
	str = NSLocalizedString(@"AcceptedTermOfUseFMT", @"TermOfUse string");
	
    return str;
}

+(NSString*)GetString_DonotAcceptedTermOfUseFMT
{
	NSString* str = @"DonotAcceptedTermOfUseFMT";
	
	//Localization string query here
	str = NSLocalizedString(@"DonotAcceptedTermOfUseFMT", @"TermOfUse string");
	
    return str;
}

+(NSString*)GetString_ReportPost
{
	NSString* str = @"ReportPost";
	
	//Localization string query here
	str = NSLocalizedString(@"ReportPost", @"ReportPost string");
	
    return str;
}

+(NSString*)GetString_ReportFailed
{
	NSString* str = @"ReportFailed";
	
	//Localization string query here
	str = NSLocalizedString(@"ReportFailed", @"ReportFailed string");
	
    return str;
}

+(NSString*)GetString_ReportSucceed
{
	NSString* str = @"ReportSucceed";
	
	//Localization string query here
	str = NSLocalizedString(@"ReportSucceed", @"ReportSucceed string");
	
    return str;
}

+(NSString*)GetString_Slight
{
	NSString* str = @"Slight";
	
	//Localization string query here
	str = NSLocalizedString(@"Slight", @"Slight string");
	
    return str;
}

+(NSString*)GetString_Moderate
{
	NSString* str = @"Moderate";
	
	//Localization string query here
	str = NSLocalizedString(@"Moderate", @"Moderate string");
	
    return str;
}

+(NSString*)GetString_Severe
{
	NSString* str = @"Severe";
	
	//Localization string query here
	str = NSLocalizedString(@"Severe", @"Severe string");
	
    return str;
}

+(NSString*)GetString_ComplainReportTitle
{
	NSString* str = @"ComplainReportTitle";
	
	//Localization string query here
	str = NSLocalizedString(@"ComplainReportTitle", @"ComplainReportTitle string");
	
    return str;
}


+(NSString*)GetString_SeverityString:(int)nSeverity
{
	NSString* str = @"Normal";
	
	//Localization string query here
	switch(nSeverity)
    {
        case NOM_USERCOMPLAIN_LEVEL_SLIGHT:
            str = [StringFactory GetString_Slight];
            break;
        case NOM_USERCOMPLAIN_LEVEL_MODERATE:
            str = [StringFactory GetString_Moderate];
            break;
        case NOM_USERCOMPLAIN_LEVEL_SEVERE:
            str = [StringFactory GetString_Severe];
            break;
    }
	
    return str;
}


+(NSString*)GetString_HigherSeverityWarn
{
	NSString* str = @"HigherSeverityWarn";
	
	//Localization string query here
	str = NSLocalizedString(@"HigherSeverityWarn", @"HigherSeverityWarn string");
	
    return str;
}

+(NSString*)GetString_BanForWronPost
{
	NSString* str = @"BanForWronPost";
	
	//Localization string query here
	str = NSLocalizedString(@"BanForWronPost", @"BanForWronPost string");
	
    return str;
}

+(NSString*)GetString_BanForever
{
	NSString* str = @"BanForever";
	
	//Localization string query here
	str = NSLocalizedString(@"BanForever", @"BanForever string");
	
    return str;
}

+(NSString*)GetString_ImproperPostWarn
{
	NSString* str = @"ImproperPostWarn";
	
	//Localization string query here
	str = NSLocalizedString(@"ImproperPostWarn", @"ImproperPostWarn string");
	
    return str;
}


+(NSString*)GetString_SpotTitle:(int16_t)nType
{
	NSString* str = @"SpotTitle";
    
    switch (nType)
    {
        case NOM_TRAFFICSPOT_PHOTORADAR:
            str = [StringFactory GetString_EnforcementRadar];
            break;
        case NOM_TRAFFICSPOT_SCHOOLZONE:
            str = [StringFactory GetString_SchoolZone];
            break;
        case NOM_TRAFFICSPOT_PLAYGROUND:
            str = [StringFactory GetString_Playground];
            break;
        case NOM_TRAFFICSPOT_GASSTATION:
            str = [StringFactory GetString_GasStation];
            break;
        case NOM_TRAFFICSPOT_PARKINGGROUND:
            str = [StringFactory GetString_ParkingGround];
            break;
    }
    
    return str;
}


+(NSString*)GetString_SpotSubTitle:(int16_t)nType sithSubTitle:(int16_t)nSubType
{
	NSString* str = @"SpotSubTitle";
    
    switch (nType)
    {
        case NOM_TRAFFICSPOT_PHOTORADAR:
            if(nSubType <= NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA)
                str = [StringFactory GetString_PhotoRadar];
            else
                str = [StringFactory GetString_SpeedCamera];
            break;
        case NOM_TRAFFICSPOT_SCHOOLZONE:
            str = [StringFactory GetString_SchoolZone];
            break;
        case NOM_TRAFFICSPOT_PLAYGROUND:
            str = [StringFactory GetString_Playground];
            break;
        case NOM_TRAFFICSPOT_GASSTATION:
            str = [StringFactory GetString_GasStation];
            break;
        case NOM_TRAFFICSPOT_PARKINGGROUND:
            str = [StringFactory GetString_ParkingGround];
            break;
    }
    
    return str;
}

 

+(NSString*)GetString_MarkSpot
{
	NSString* str = @"MarkSpot";
	
	//Localization string query here
	str = NSLocalizedString(@"MarkSpot", @"MarkSpot string");
	
    return str;
}

+(NSString*)GetString_TrafficSpot
{
	NSString* str = @"TrafficSpot";
	
	//Localization string query here
	str = NSLocalizedString(@"TrafficSpot", @"TrafficSpot string");
	
    return str;
}

+(NSString*)GetString_PhotoRadar
{
	NSString* str = @"PhotoRadar";
	
	//Localization string query here
	str = NSLocalizedString(@"PhotoRadar", @"PhotoRadar string");
	
    return str;
}

+(NSString*)GetString_SpeedCamera
{
	NSString* str = @"SpeedCamera";
	
	//Localization string query here
	str = NSLocalizedString(@"SpeedCamera", @"PhotoRadar string");
	
    return str;
}

+(NSString*)GetString_SchoolZone
{
	NSString* str = @"SchoolZone";
	
	//Localization string query here
	str = NSLocalizedString(@"SchoolZone", @"SchoolZone string");
	
    return str;
}

+(NSString*)GetString_Playground
{
	NSString* str = @"Playground";
	
	//Localization string query here
	str = NSLocalizedString(@"Playground", @"Playground string");
	
    return str;
}

+(NSString*)GetString_GasStation
{
	NSString* str = @"GasStation";
	
	//Localization string query here
	str = NSLocalizedString(@"GasStation", @"GasStation string");
	
    return str;
}

+(NSString*)GetString_MapType
{
	NSString* str = @"MapType";
	
	//Localization string query here
	str = NSLocalizedString(@"MapType", @"MapType string");
	
    return str;
}

+(NSString*)GetString_LocationForMarkSpot
{
	NSString* str = @"LocationForMarkSpot";
	
	//Localization string query here
	str = NSLocalizedString(@"LocationForMarkSpot", @"LocationForMarkSpot string");
	
    return str;
}

+(NSString*)GetString_AskAddSpotName
{
	NSString* str = @"AskAddSpotName";
	
	//Localization string query here
	str = NSLocalizedString(@"AskAddSpotName", @"AskAddSpotName string");
	
    return str;
}

+(NSString*)GetString_Name
{
	NSString* str = @"Name";
	
	//Localization string query here
	str = NSLocalizedString(@"Name", @"Name string");
	
    return str;
}

+(NSString*)GetString_Spot
{
	NSString* str = @"Spot";
	
	//Localization string query here
	str = NSLocalizedString(@"Spot", @"Spot string");
	
    return str;
}

+(NSString*)GetString_SpeedLimit
{
	NSString* str = @"SpeedLimit";
	
	//Localization string query here
	str = NSLocalizedString(@"SpeedLimit", @"SpeedLimit string");
	
    return str;
}

+(NSString*)GetString_Add2Calender
{
	NSString* str = @"Add to Calender";
	
	//Localization string query here
	str = NSLocalizedString(@"Add to Calender", @"Add to Calender string");
	
    return str;
}

+(NSString*)GetString_Price
{
	NSString* str = @"Price";
	
	//Localization string query here
	str = NSLocalizedString(@"Price", @"Price string");
	
    return str;
}


+(NSString*)GetString_PriceUnit:(int16_t)nUnitType
{
	NSString* str = @"¢/L";
	
	//Localization string query here
    switch(nUnitType)
    {
        case NOM_GASSTATION_PRICEUNIT_CENTLITRE:
            str = NSLocalizedString(@"¢/L", @"Price string");
            break;
    
        case NOM_GASSTATION_PRICEUNIT_DOLLARLITRE:
            str = NSLocalizedString(@"$/L", @"Price string");
            break;
        
        case NOM_GASSTATION_PRICEUNIT_DOLLARGALLON:
            str = NSLocalizedString(@"$/G", @"Price string");
            break;
        
        case NOM_GASSTATION_PRICEUNIT_CENTGALLON:
            str = NSLocalizedString(@"¢/G", @"Price string");
            break;
	}
    
    return str;
}

+(NSString*)GetString_PriceUnitDescription:(int16_t)nUnitType
{
	NSString* str = @"Cent/Litre";
	
	//Localization string query here
    switch(nUnitType)
    {
        case NOM_GASSTATION_PRICEUNIT_CENTLITRE:
            str = NSLocalizedString(@"Cent/Litre", @"Price string");
            break;
            
        case NOM_GASSTATION_PRICEUNIT_DOLLARLITRE:
            str = NSLocalizedString(@"Dollar/Litre", @"Price string");
            break;
            
        case NOM_GASSTATION_PRICEUNIT_DOLLARGALLON:
            str = NSLocalizedString(@"Dollar/Gallon", @"Price string");
            break;
            
        case NOM_GASSTATION_PRICEUNIT_CENTGALLON:
            str = NSLocalizedString(@"Cent/Gallon", @"Price string");
            break;
	}
    
    return str;
}
 

+(NSString*)GetString_Unit
{
	NSString* str = @"Unit";
	
	//Localization string query here
	str = NSLocalizedString(@"Unit", @"Price string");
	
    return str;
}

+(NSString*)GetString_Change
{
	NSString* str = @"Change";
	
	//Localization string query here
	str = NSLocalizedString(@"Change", @"Change string");
	
    return str;
}

+(NSString*)GetString_EmptyString
{
	NSString* str = @"N/A";
	
	//Localization string query here
	str = NSLocalizedString(@"N/A", @"N/A string");
	
    return str;
}

+(NSString*)GetString_AddName
{
	NSString* str = @"Add Name";
	
	//Localization string query here
	str = NSLocalizedString(@"Add Name", @"Add Name string");
	
    return str;
}

+(NSString*)GetString_AddPrice
{
	NSString* str = @"Add Price";
	
	//Localization string query here
	str = NSLocalizedString(@"Add Price", @"Add Price string");
	
    return str;
}


+(NSString*)GetString_ParkingGround
{
	NSString* str = @"Parking Ground";
	
	//Localization string query here
	str = NSLocalizedString(@"Parking Ground", @"Parking Ground string");
	
    return str;
}

+(NSString*)GetString_SpeedTrap
{
	NSString* str = @"Speed Trap";
	
	//Localization string query here
	str = NSLocalizedString(@"Speed Trap", @"Speed Trap string");
	
    return str;
}

+(NSString*)GetString_Type
{
	NSString* str = @"Type";
	
	//Localization string query here
	str = NSLocalizedString(@"Type", @"Type string");
	
    return str;
}

+(NSString*)GetString_Address
{
	NSString* str = @"Address";
	
	//Localization string query here
	str = NSLocalizedString(@"Address", @"Address string");
	
    return str;
}

+(NSString*)GetString_CarWash
{
	NSString* str = @"Car Wash";
	
	//Localization string query here
	str = NSLocalizedString(@"Car Wash", @"Car Wash string");
	
    return str;
}

+(NSString*)GetString_FixedType
{
	NSString* str = @"Fixed";
	
	//Localization string query here
	str = NSLocalizedString(@"Fixed", @"Fixed string");
	
    return str;
}

+(NSString*)GetString_MobileType
{
	NSString* str = @"Mobile";
	
	//Localization string query here
	str = NSLocalizedString(@"Mobile", @"Mobile string");
	
    return str;
}

+(NSString*)GetString_EnforcementRadar
{
	NSString* str = @"Enforcement Radar";
	
	//Localization string query here
	str = NSLocalizedString(@"Enforcement Radar", @"Enforcement Radar string");
	
    return str;
}

+(NSString*)GetString_PoliceCar
{
	NSString* str = @"Police Car";
	
	//Localization string query here
	str = NSLocalizedString(@"Police Car", @"Police Car string");
	
    return str;
}

+(NSString*)GetString_Fine
{
	NSString* str = @"Fine";
	
	//Localization string query here
	str = NSLocalizedString(@"Fine", @"Fine string");
	
    return str;
}

+(NSString*)GetString_DollarSign
{
	NSString* str = @"$";
	
	//Localization string query here
	str = NSLocalizedString(@"$", @"$ string");
	
    return str;
}

+(NSString*)GetString_Direction
{
	NSString* str = @"Direction";
	
	//Localization string query here
	str = NSLocalizedString(@"Direction", @"Direction string");
	
    return str;
}

+(NSString*)GetString_NorthBound
{
	NSString* str = @"NorthBound";
	
	//Localization string query here
	str = NSLocalizedString(@"NorthBound", @"NorthBound string");
	
    return str;
}

+(NSString*)GetString_SouthBound
{
	NSString* str = @"SouthBound";
	
	//Localization string query here
	str = NSLocalizedString(@"SouthBound", @"SouthBound string");
	
    return str;
}

+(NSString*)GetString_EastBound
{
	NSString* str = @"EastBound";
	
	//Localization string query here
	str = NSLocalizedString(@"EastBound", @"EastBound string");
	
    return str;
}

+(NSString*)GetString_WestBound
{
	NSString* str = @"WestBound";
	
	//Localization string query here
	str = NSLocalizedString(@"WestBound", @"WestBound string");
	
    return str;
}

+(NSString*)GetString_NBDir
{
	NSString* str = @"NB";
	
	//Localization string query here
	str = NSLocalizedString(@"NB", @"NB string");
	
    return str;
}

+(NSString*)GetString_SBDir
{
	NSString* str = @"SB";
	
	//Localization string query here
	str = NSLocalizedString(@"SB", @"SB string");
	
    return str;
}

+(NSString*)GetString_EBDir
{
	NSString* str = @"EB";
	
	//Localization string query here
	str = NSLocalizedString(@"EB", @"EB string");
	
    return str;
}

+(NSString*)GetString_WBDir
{
	NSString* str = @"WB";
	
	//Localization string query here
	str = NSLocalizedString(@"WB", @"WB string");
	
    return str;
}


+(NSString*)GetString_TrafficDirectFullString:(int16_t)nDirection
{
    NSString* stRet = @"";
    
    switch(nDirection)
    {
        case NOM_PHOTORADAR_DIRECTION_NONE:
            stRet = [StringFactory GetString_EmptyString];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB:
            stRet = [StringFactory GetString_NorthBound];
            break;
        case NOM_PHOTORADAR_DIRECTION_SB:
            stRet = [StringFactory GetString_SouthBound];
            break;
        case NOM_PHOTORADAR_DIRECTION_EB:
            stRet = [StringFactory GetString_EastBound];
            break;
        case NOM_PHOTORADAR_DIRECTION_WB:
            stRet = [StringFactory GetString_WestBound];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_SB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_NorthBound], [StringFactory GetString_SouthBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_EB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_NorthBound], [StringFactory GetString_EastBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_NorthBound], [StringFactory GetString_WestBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_SB_EB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_SouthBound], [StringFactory GetString_EastBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_SB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_SouthBound], [StringFactory GetString_WestBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_EB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_EastBound], [StringFactory GetString_WestBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_SB_EB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_NorthBound], [StringFactory GetString_SouthBound], [StringFactory GetString_EastBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_SB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_NorthBound], [StringFactory GetString_SouthBound], [StringFactory GetString_WestBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_EB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_NorthBound], [StringFactory GetString_EastBound], [StringFactory GetString_WestBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_SB_EB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_SouthBound], [StringFactory GetString_EastBound], [StringFactory GetString_WestBound]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_SB_EB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@/%@", [StringFactory GetString_NorthBound], [StringFactory GetString_SouthBound], [StringFactory GetString_EastBound], [StringFactory GetString_WestBound]];
            break;
    }
    
    return stRet;
}

+(NSString*)GetString_TrafficDirectShortString:(int16_t)nDirection
{
    NSString* stRet = @"";
    
    switch(nDirection)
    {
        case NOM_PHOTORADAR_DIRECTION_NONE:
            stRet = [StringFactory GetString_EmptyString];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB:
            stRet = [StringFactory GetString_NBDir];
            break;
        case NOM_PHOTORADAR_DIRECTION_SB:
            stRet = [StringFactory GetString_SBDir];
            break;
        case NOM_PHOTORADAR_DIRECTION_EB:
            stRet = [StringFactory GetString_EBDir];
            break;
        case NOM_PHOTORADAR_DIRECTION_WB:
            stRet = [StringFactory GetString_WBDir];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_SB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_NBDir], [StringFactory GetString_SBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_EB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_NBDir], [StringFactory GetString_EBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_NBDir], [StringFactory GetString_WBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_SB_EB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_SBDir], [StringFactory GetString_EBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_SB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_SBDir], [StringFactory GetString_WBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_EB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@", [StringFactory GetString_EBDir], [StringFactory GetString_WBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_SB_EB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_NBDir], [StringFactory GetString_SBDir], [StringFactory GetString_EBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_SB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_NBDir], [StringFactory GetString_SBDir], [StringFactory GetString_WBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_EB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_NBDir], [StringFactory GetString_EBDir], [StringFactory GetString_WBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_SB_EB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@", [StringFactory GetString_SBDir], [StringFactory GetString_EBDir], [StringFactory GetString_WBDir]];
            break;
        case NOM_PHOTORADAR_DIRECTION_NB_SB_EB_WB:
            stRet = [NSString stringWithFormat:@"%@/%@/%@/%@", [StringFactory GetString_NBDir], [StringFactory GetString_SBDir], [StringFactory GetString_EBDir], [StringFactory GetString_WBDir]];
            break;
    }
    
    return stRet;
}

 
+(NSString*)GetString_Rate
{
	NSString* str = @"Rate";
	
	//Localization string query here
	str = NSLocalizedString(@"Rate", @"Rate string");
	
    return str;
}

+(NSString*)GetString_OneHour
{
	NSString* str = @"OneHour";
	
	//Localization string query here
	str = NSLocalizedString(@"OneHour", @"OneHour string");
	
    return str;
}

+(NSString*)GetString_QuarterHour
{
	NSString* str = @"QuarterHour";
	
	//Localization string query here
	str = NSLocalizedString(@"QuarterHour", @"QuarterHour string");
	
    return str;
}

+(NSString*)GetString_HalfHour
{
	NSString* str = @"HalfHour";
	
	//Localization string query here
	str = NSLocalizedString(@"HalfHour", @"HalfHour string");
	
    return str;
}

+(NSString*)GetString_TwoHour
{
	NSString* str = @"TwoHour";
	
	//Localization string query here
	str = NSLocalizedString(@"TwoHour", @"TwoHour string");
	
    return str;
}

+(NSString*)GetString_HalfDay
{
	NSString* str = @"HalfDay";
	
	//Localization string query here
	str = NSLocalizedString(@"HalfDay", @"HalfDay string");
	
    return str;
}

+(NSString*)GetString_OneDay
{
	NSString* str = @"OneDay";
	
	//Localization string query here
	str = NSLocalizedString(@"OneDay", @"OneDay string");
	
    return str;
}


+(NSString*)GetString_ParkingRate:(int16_t)nUnit
{
    NSString* stRet = @"";
    
    switch(nUnit)
    {
        case NOM_PARKING_RATEUNIT_HOUR:
            stRet = [StringFactory GetString_OneHour];
            break;
        case NOM_PARKING_RATEUNIT_QUARTERHOUR:
            stRet = [StringFactory GetString_QuarterHour];
            break;
        case NOM_PARKING_RATEUNIT_HALFHOUR:
            stRet = [StringFactory GetString_HalfHour];
            break;
        case NOM_PARKING_RATEUNIT_TWOHOUR:
            stRet = [StringFactory GetString_TwoHour];
            break;
        case NOM_PARKING_RATEUNIT_HALFDAY:
            stRet = [StringFactory GetString_HalfDay];
            break;
        case NOM_PARKING_RATEUNIT_ONEDAY:
            stRet = [StringFactory GetString_OneDay];
            break;
    }
    
    return stRet;
}

 
+(NSString*)GetString_EnableTwitterService
{
	NSString* str = @"EnableTwitterService";
	
	//Localization string query here
	str = NSLocalizedString(@"EnableTwitterService", @"EnableTwitterService string");
	
    return str;
}

+(NSString*)GetString_TwitterSetting
{
	NSString* str = @"TwitterSetting";
	
	//Localization string query here
	str = NSLocalizedString(@"TwitterSetting", @"TwitterSetting string");
	
    return str;
}

+(NSString*)GetString_ReadLink
{
	NSString* str = @"Read Link";
	
	str = NSLocalizedString(@"Read Link", @"Read Link string");
	
    return str;
}

+(NSString*)GetString_AskAddSpotInformation
{
	NSString* str = @"AskAddSpotInformation";
	
	str = NSLocalizedString(@"AskAddSpotInformation", @"AskAddSpotInformation string");
	
    return str;
}

+(NSString*)GetString_TP_PREP_OF
{
	NSString* str = @"of";
	
	str = NSLocalizedString(@"of", @"of string");
	
    return str;
}

+(NSString*)GetString_TP_PREP_ON
{
	NSString* str = @"on";
	
	str = NSLocalizedString(@"on", @"on string");
	
    return str;
}

+(NSString*)GetString_TP_PREP_AT
{
	NSString* str = @"at";
	
	str = NSLocalizedString(@"at", @"at string");
	
    return str;
}

+(NSString*)GetString_TP_PREP_FROM
{
	NSString* str = @"from";
	
    str = NSLocalizedString(@"from", @"from string");
	
    return str;
}

+(NSString*)GetString_TP_PREP_TO
{
	NSString* str = @"to";
	
    str = NSLocalizedString(@"to", @"to string");
	
    return str;
}

+(NSString*)GetString_TP_PREP_IN
{
	NSString* str = @"in";
	
    str = NSLocalizedString(@"in", @"in string");
	
    return str;
}

+(NSString*)GetString_TP_PREP_AND
{
	NSString* str = @"and";
	
    str = NSLocalizedString(@"and", @"and string");
	
    return str;
}

+(NSString*)GetString_TP_PREP_BETWEEN
{
	NSString* str = @"between";
	
    str = NSLocalizedString(@"between", @"between string");
	
    return str;
}

+(NSString*)GetString_TP_DIRWORD_NB
{
	NSString* str = @"northbound";
    
    str = NSLocalizedString(@"northbound", @"northbound string");
	
    return str;
}
+(NSString*)GetString_TP_DIRWORD_EB
{
	NSString* str = @"eastbound";
    
    str = NSLocalizedString(@"eastbound", @"eastbound string");
	
    return str;
}

+(NSString*)GetString_TP_DIRWORD_SB
{
	NSString* str = @"southbound";
    
    str = NSLocalizedString(@"southbound", @"southbound string");
	
    return str;
}

+(NSString*)GetString_TP_DIRWORD_WB
{
	NSString* str = @"westbound";
    
    str = NSLocalizedString(@"westbound", @"westbound string");
	
    return str;
}

+(NSString*)GetString_TP_DIRWORD_APPROACHING
{
	NSString* str = @"approaching";
    
    str = NSLocalizedString(@"approaching", @"approaching string");
	
    return str;
}

+(NSString*)GetString_PostLocationOutAppRegion
{
	NSString* str = @"The postion location is out of app region.";
    
    str = NSLocalizedString(@"The post location is out of app region.", @"The post location is out of app region. string");
	
    return str;
}

+(NSString*)GetString_WhatIsNext
{
	NSString* str = @"What's Next?";
    
    str = NSLocalizedString(@"What's Next?", @"What's Next? string");
	
    return str;
}

+(NSString*)GetString_Author
{
	NSString* str = @"Author";
    
    str = NSLocalizedString(@"Author", @"Author string");
	
    return str;
}

+(NSString*)GetString_LocationServiceRequired
{
    NSString* str = @"LocationServiceRequired";
    
    str = NSLocalizedString(@"LocationServiceRequired", @"Author string");
    
    return str;
}

+(NSString*)GetString_Enable
{
    NSString* str = @"Enable";
    
    str = NSLocalizedString(@"Enable", @"Enable string");
    
    return str;
}

+(NSString*)GetString_Warning
{
    NSString* str = @"Warning";
    
    str = NSLocalizedString(@"Warning", @"Warning string");
    
    return str;
}

+(NSString*)GetString_NotAcceptTermOfUse
{
    NSString* str = @"NotAcceptTermOfUse";
    
    str = NSLocalizedString(@"NotAcceptTermOfUse", @"Enable string");
    
    return str;
}

+(NSString*)GetString_CarWashIncluded
{
    NSString* str = @"Carwash included";
    
    str = NSLocalizedString(@"Carwash included", @"Carwash included string");
    
    return str;
}

+(NSString*)GetString_TaxiInfo
{
    NSString* str = @"Taxi & Passenger";
    
    str = NSLocalizedString(@"Taxi & Passenger", @"Taxi & Passenger string");
    
    return str;
}

+(NSString*)GetString_TaxiAvailableByDriver
{
    NSString* str = @"Taxi Available (by driver)";

    str = NSLocalizedString(@"Taxi Available (by driver)", @"Taxi Available (by driver) string");
    
    return str;
}

+(NSString*)GetString_TaxiPassengerAvailable
{
    NSString* str = @"Taxi Request (by passenger)";
    
    str = NSLocalizedString(@"Taxi Request (by passenger)", @"Taxi Request (by passenger) string");
    
    return str;
}

+(NSString*)GetString_Taxi
{
    NSString* str = @"Taxi";
    
    str = NSLocalizedString(@"Taxi", @"Taxistring");
    
    return str;
}

+(NSString*)GetString_Passenger
{
    NSString* str = @"Passenger";
    
    str = NSLocalizedString(@"Passenger", @"Passenger string");
    
    return str;
}

+(NSString*)GetString_Both
{
    NSString* str = @"Both";
    
    str = NSLocalizedString(@"Both", @"Both string");
    
    return str;
}

+(NSString*)GetString_LowMemoryAndCloseApps
{
    NSString* str = @"LowMemoryAndCloseApps";
    
    str = NSLocalizedString(@"LowMemoryAndCloseApps", @"LowMemoryAndCloseApps string");
    
    return str;
}

/*
+(NSString*)GetString_Kindergarten
{
	NSString* str = @"Kindergarten";
	
	//Localization string query here
	str = NSLocalizedString(@"Kindergarten", @"DayCare string");
	
    return str;
}

+(NSString*)GetString_Elementary
{
	NSString* str = @"Elementary";
	
	//Localization string query here
	str = NSLocalizedString(@"DayCare", @"DayCare string");
	
    return str;
}

+(NSString*)GetString_JuniorHigh
{
    
}

+(NSString*)GetString_HighSchool
{
    
}

+(NSString*)GetString_College
{
    
}

+(NSString*)GetString_University
{
    
}

+(NSString*)GetString_MiscType
{
    
}
*/

@end
