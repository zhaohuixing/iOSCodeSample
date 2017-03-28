//
//  NOMQueryLocationPin.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-15.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <MapKit/MapKit.h>
//#import "NonTouchableLabel.h"
#import "INOMCustomListCalloutInterfaces.h"

@class NOMQueryLocationPin;

//@protocol NOMQueryPinDelegate <NSObject>

//-(void)OpenLocationNewsListCallout:(NOMQueryLocationPin*)Pin;

//@end

@interface NOMQueryLocationPin : MKAnnotationView<INOMCustomListCalloutCaller>

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withSize:(CGSize)size;
- (void)ReloadInformation;
//- (void)AttachDelegate:(id<NOMQueryPinDelegate>)delegate;
-(void)RegisterCallout:(id<INOMCustomListCalloutDelegate>)callout;

- (NSString*)GetCountryCode;
- (NSString*)GetCity;
- (NSString*)GetCommunity;

- (void)UpdateZoomSize;

- (void)RegisterMap:(MKMapView*)map;

-(void)ShowAlert;

@end
