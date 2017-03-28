//
//  NOMLocationController.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-22.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@protocol NOMLocationControllerDelegate <NSObject>

-(void)LocationUpdateCompleted:(BOOL)bSucceed;
-(void)LocationServiceNotAvaliable;
//-(void)LocationUpdateInDrivingMode;
//-(void)LocationUpdateInStaticMode;

@end

@interface NOMLocationController : NSObject<CLLocationManagerDelegate>

-(void)AttachDelegate:(id<NOMLocationControllerDelegate>)delgate;

-(void)CheckCurrentLocation:(BOOL)bCheckForPost;
-(BOOL)IsCheckingLocation;
-(BOOL)IsCheckForPosting;
-(void)SetCheckForPosting:(BOOL)bCheckForPost;
-(CLLocation*)GetLocation;
-(BOOL)LocationServiceEnable;
-(void)Reset;

-(void)AuthorizeLocationService;

@end
