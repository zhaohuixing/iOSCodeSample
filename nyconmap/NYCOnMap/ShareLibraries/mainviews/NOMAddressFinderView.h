//
//  NOMAddressFinderView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-11.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMAddressFinderView : UIView

+(double)GetDefaultBasicUISize;

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;

-(void)OnCheckButtonClick;
-(void)OnOKButtonClick;
-(void)OnCancelButtonClick;

-(void)UpdateLayout;

-(void)AddressValidationSuccessed;

-(CLLocationCoordinate2D)GetSelectedCoordinate;
-(NSString*)GetStreetAddress;
-(NSString*)GetCity;
-(NSString*)GetState;
-(NSString*)GetZipCode;
-(NSString*)GetCountry;
-(NSString*)GetCountryKey;

@end
