//
//  CustomMapViewPinItem.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-17.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "INOMCustomListCalloutInterfaces.h"
#import "INOMCustomMapViewPinItemDelegate.h"


@interface CustomMapViewPinItem : UIView<INOMCustomListCalloutItem>

-(void)AttachDelegate:(id<INOMCustomMapViewPinItemDelegate>)delegate;
-(void)SetSelectState:(BOOL)bSelected;
-(void)ResetSelectState;
-(void)Set:(NSString*)newsID withTitle1:(NSString*)title1 withTitle2:(NSString*)title2;
-(BOOL)IsSelectable;
-(void)SetSelectable:(BOOL)bSelectable;
-(void)SetEnableReport:(BOOL)bEnable;
//-(void)SetCachedLocationData:(NSString*)city with:(NSString*)community;
-(void)SetEnableCalender:(double)lat withLongitude:(double)lon;

-(BOOL)IsCalenderSupported;

-(void)SetTwitterLogo;

-(BOOL)LoadItemData:(id)data;

@end
