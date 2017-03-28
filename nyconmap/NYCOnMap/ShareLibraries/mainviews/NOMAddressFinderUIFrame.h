//
//  NOMAddressFinderUIFrame.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-11.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NOMAddressFinderViewButtonPanel.h"

@interface NOMAddressFinderUIFrame : UIScrollView<UIScrollViewDelegate>

-(void)UpdateLayout;

-(void)ScrollViewTo:(float)scrollOffsetY;
-(void)RestoreScrollViewDefaultPosition;
-(void)SetButtonPanel:(NOMAddressFinderViewButtonPanel*)panel;

-(void)ValidateAddress;
-(void)AddressValidationSuccessed;
-(void)CleanControlState;

-(CLLocationCoordinate2D)GetSelectedCoordinate;

-(NSString*)GetStreetAddress;
-(NSString*)GetCity;
-(NSString*)GetState;
-(NSString*)GetZipCode;
-(NSString*)GetCountry;
-(NSString*)GetCountryKey;

@end
