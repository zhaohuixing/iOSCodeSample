//
//  AdConfiguration.h
//  XXXXXXXX
//
//  Created by Zhaohui Xing on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdConfiguration : NSObject

+(NSString*)GetAdMobPublishKey;
+(NSString*)GetMobClixPublishKey;
+(NSString*)GetMobFoxPublishKey;

//Millennial Media SDK
+(NSString*)GetMMSDKBottomAdID;
+(NSString*)GetMMSDKSquareAdID;
+(NSString*)GetMMSDKFullScreenAdID;

+(int)GetSOMAPublisherID;
+(int)GetSOMAAdSpaceIDKey;

+(NSString*)GetTinMooKey;
+(NSString*)GetInmobiKey;

@end
