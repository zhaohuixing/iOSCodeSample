//
//  NOMMapPoint.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-03.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NOMMapPoint : NSObject

@property (nonatomic, readonly)CLLocationCoordinate2D      coordinate;

-(id)initWithLatitude:(CLLocationDegrees)lat withLongitude:(CLLocationDegrees)lon;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;


@end
