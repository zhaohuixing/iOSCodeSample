//
//  CustomMapViewPinCallout.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-16.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <CoreLocation/CLLocation.h>


@class CustomMapViewPinItem;

@interface CustomMapViewPinCallout : UIView

+(float)GetContainerViewWidth;
+(float)GetDefaultContainerViewHeight;
+(float)GetCalloutItemWidth;
+(float)GetCalloutItemHeight;
+(int)GetMaxDisplayCalloutItemNumber;
+(int)GetMinDisplayCalloutItemNumber;
+(float)GetCornerSize;
+(float)GetAchorSize;

-(void)UpdateLayout;
-(void)SetArchor:(CGPoint)pt;
-(void)RemoveAllPinItems;
-(void)AddPinItem:(CustomMapViewPinItem*)item;

-(void)Open:(BOOL)bAnimation;
-(void)Close:(BOOL)bAnimation;
-(void)SetCurrentLocation:(CLLocationCoordinate2D)location;
-(CLLocationCoordinate2D)GetCurrentLocation;
-(void)SetFixedLocation:(BOOL)bFixedLocation;
-(BOOL)IsFixedLocation;

@end
