//
//  NOMGEOPlanRect.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "IIDGEOOverlay.h"


@interface NOMGEOPlanRect : MKPolygon<IIDGEOOverlay>

- (id)initWithStart:(CLLocationCoordinate2D)startpoint end:(CLLocationCoordinate2D)endpoint;
- (void)SetID:(NSString*)overlayID;
- (NSString*)GetID;

@end
