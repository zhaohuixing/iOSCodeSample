//
//  AddressFinderView.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-26.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NOMAddressFinderViewButtonPanel.h"

@interface  NOMAddressFinderUICore : UIView<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

+(float)GetViewLayoutHeight;

-(void)UpdateLayout;

-(void)ValidateAddress;
-(CLLocationCoordinate2D)GetSelectedCoordinate;
-(CLLocationDegrees)GetSelectedCoordinateLantiude;
-(CLLocationDegrees)GetSelectedCoordinateLongitude;
-(NSString*)GetStreetAddress;
-(NSString*)GetCity;
-(NSString*)GetState;
-(NSString*)GetZipCode;
-(NSString*)GetCountry;
-(NSString*)GetCountryKey;

-(void)HideKeyboard;

-(void)SetButtonPanel:(NOMAddressFinderViewButtonPanel*)panel;

-(void)CleanControlState;

@end
