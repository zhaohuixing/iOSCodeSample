//
//  NOMSpotGasStationView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ISpotUIInterfaces.h"

@interface NOMSpotGasStationView : UIView

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
-(void)SetCarWashType:(int16_t)nType;
-(void)SetAddress:(NSString*)address;
-(void)SetName:(NSString*)name;
-(void)SetPrice:(double)dPrice;
-(void)SetPriceUnit:(int16_t)nUnit;

-(int16_t)GetCarWashType;
-(NSString*)GetAddress;
-(NSString*)GetName;
-(double)GetPrice;
-(int16_t)GetPriceUnit;

-(void)RegisterController:(id<ISpotUIController>)controller;

-(void)SetTwitterEnabling:(BOOL)bTwitterEnable;
-(BOOL)AllowTwitterShare;

@end
