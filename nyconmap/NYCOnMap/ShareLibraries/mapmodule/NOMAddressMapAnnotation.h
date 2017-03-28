//
//  NOMAddressMapAnnotation.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-07.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <MapKit/MapKit.h>

@interface NOMAddressMapAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D              m_Coordinate;
}

-(void)SetCoordinate:(CLLocationCoordinate2D)coordinate;

@end
