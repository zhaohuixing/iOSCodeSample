//
//  NOMTrafficNewsDataOverlayController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-08-20.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "IMapViewDelegate.h"

@interface NOMTrafficNewsDataOverlayController : NSObject

-(void)RegisterMapView:(id<IMapViewDelegate>)mapView;
-(void)AddOverlay:(NSString*)newsID withKML:(NSString*)newsKMLSource;
-(void)RemoveOverlay:(NSString*)newsID;
-(void)RemoveAllOverlays;
-(void)UpdateLayout;

@end
