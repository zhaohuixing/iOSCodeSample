//
//  NOMTrafficSpotDBHelper.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NOMTrafficSpotDBHelper : NSObject

#ifdef DEBUG
//+(void)CreateDomain;
#endif

+(NSString*)GetDBDomain:(double)sx1 srcY:(double)sy1 withType:(int16_t)nType;
+(NSString*)GetDBDomain:(CLLocationDegrees)longitude withLatitude:(CLLocationDegrees)lantitude withType:(int16_t)nType;
+(NSString*)GetDBDomain:(CLLocationDegrees)longitudeStart withLongitudeEnd:(CLLocationDegrees)longitudeEnd withLatitudeStart:(CLLocationDegrees)latitudeStart withLatitudeEnd:(CLLocationDegrees)lantitudeEnd withType:(int16_t)nType;
+(CGRect)GetQueryRegion:(CLLocationDegrees)longitudeStart withLongitudeEnd:(CLLocationDegrees)longitudeEnd withLatitudeStart:(CLLocationDegrees)latitudeStart withLatitudeEnd:(CLLocationDegrees)lantitudeEnd;

@end
