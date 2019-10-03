//
//  AdConfiguration.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "AdConfiguration.h"
#import "ApplicationConfigure.h"

#define ADMOB_PUBLISHKEY_FLYINGCOW_IPHONE			@"xxxxxxxxxxxx"
#define ADMOB_PUBLISHKEY_FLYINGCOW_IPAD				@"xxxxxxxxxxxx"
#define MOBCLIX_PUBLISHKEY_FLYINGCOW				@"xxxxxxxxxxxx"
#define MOBCLIX_PUBLISHKEY_LUCKYCOMPASS				@"xxxxxxxxxxxx"
#define MOBCLIX_PUBLISHKEY_MINDFIRE                 @"xxxxxxxxxxxx"

#define MOBFOX_PUBLISHKEY_FLYINGCOW                 @"xxxxxxxxxxxx"


@implementation AdConfiguration

+(NSString*)GetCurrentAdMobPublishKey
{
	NSString* szKey = @"";
	
	if([ApplicationConfigure iPhoneDevice])
	{
		//if(m_ProductID == APPLICATION_PRODUCT_FLYINGCOW)
		//{
        szKey = ADMOB_PUBLISHKEY_FLYINGCOW_IPHONE;
		//}	
	}
	else 
	{
		//if(m_ProductID == APPLICATION_PRODUCT_FLYINGCOW)
		//{
        szKey = ADMOB_PUBLISHKEY_FLYINGCOW_IPAD;
		//}	
	}
    
	return szKey;
}

+(NSString*)GetCurrentMobClixPublishKey
{
	NSString* szKey = @"";
	
//	if(m_ProductID == APPLICATION_PRODUCT_FLYINGCOW)
//	{
		szKey = MOBCLIX_PUBLISHKEY_FLYINGCOW;
//	}	
//	else if(m_ProductID == APPLICATION_PRODUCT_LUCKYCOMPASS)
//	{
//		szKey = MOBCLIX_PUBLISHKEY_LUCKYCOMPASS;
//	}	
//	else if(m_ProductID == APPLICATION_PRODUCT_MINDFIRE)
//  {
//		szKey = MOBCLIX_PUBLISHKEY_MINDFIRE;
//    }
    
	return szKey;
}

+(NSString*)GetMobFoxPublishKey
{
	NSString* szKey = MOBFOX_PUBLISHKEY_FLYINGCOW;
    
	return szKey;
}

+(NSString*)GetAdMobPublishKey
{
	return [AdConfiguration GetCurrentAdMobPublishKey];
}

+(NSString*)GetMobClixPublishKey
{
	return [AdConfiguration GetCurrentMobClixPublishKey];
}	

+(NSString*)GetMMSDKBottomAdID
{
    return @"xxxxxxxxxxxx";
}

+(NSString*)GetMMSDKSquareAdID
{
    return @"xxxxxxxxxxxx";
}

+(NSString*)GetMMSDKFullScreenAdID
{
    return @"xxxxxxxxxxxx";
}

+(int)GetSOMAPublisherID
{
    return 12345678;
}

+(int)GetSOMAAdSpaceIDKey
{
    return 12345678;
}

+(NSString*)GetTinMooKey
{
    return @"xxxxxxxxxxxx";
}

+(NSString*)GetInmobiKey
{
    return @"xxxxxxxxxxxx";
}
@end
