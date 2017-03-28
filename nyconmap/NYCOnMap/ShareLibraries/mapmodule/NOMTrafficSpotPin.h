//
//  NOMTrafficSpotPin.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-18.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface NOMTrafficSpotPin : MKAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withSize:(CGSize)size;
- (void)ReloadInformation;
- (NSString*)GetSpotName;
- (void)RegisterMap:(MKMapView*)map;
- (void)UpdateZoomSize;

@end
