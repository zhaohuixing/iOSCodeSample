//
//  AddressMapView.h
//  newsonmap
//
//  Created by Zhaohui Xing on 27/6/13.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NOMAddressMapView : UIView<MKMapViewDelegate>

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(void)SetLocation:(CLLocationCoordinate2D)location;
-(void)UpdateLayout;

@end
