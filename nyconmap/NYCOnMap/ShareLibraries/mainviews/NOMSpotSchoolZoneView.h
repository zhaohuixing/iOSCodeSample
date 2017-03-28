//
//  NOMSpotSchoolZoneView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ISpotUIInterfaces.h"

@interface NOMSpotSchoolZoneView : UIView

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
-(void)SetAddress:(NSString*)address;
-(void)SetName:(NSString*)name;

-(NSString*)GetAddress;
-(NSString*)GetName;

-(void)RegisterController:(id<ISpotUIController>)controller;

-(BOOL)AllowTwitterShare;
-(void)SetTwitterEnabling:(BOOL)bTwitterEnable;

@end
