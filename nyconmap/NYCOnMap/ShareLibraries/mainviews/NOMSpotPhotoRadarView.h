//
//  NOMSpotPhotoRadarView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-23.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ISpotUIInterfaces.h"

@interface NOMSpotPhotoRadarView : UIView

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;

-(void)OnOKButtonClick;
-(void)OnCancelButtonClick;

#ifdef DEBUG
-(void)OnDeleteButtonClick;
#endif

-(void)UpdateLayout;

-(void)Reset;
-(void)SetType:(int16_t)nType;
-(void)SetDirection:(int16_t)nDir;
-(void)SetSpeedCameraDeviceType:(int16_t)nType;
-(void)SetAddress:(NSString*)address;
-(void)SetFine:(double)dPrice;

-(int16_t)GetType;
-(int16_t)GetDirection;
-(int16_t)GetSpeedCameraDeviceType;
-(NSString*)GetAddress;
-(double)GetFine;

-(void)RegisterController:(id<ISpotUIController>)controller;

-(BOOL)AllowTwitterShare;
-(void)SetTwitterEnabling:(BOOL)bTwitterEnable;

@end
