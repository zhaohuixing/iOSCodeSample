//
//  NOMPostLocationSelector.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NOMPostLocationSelectorDelegate <NSObject>

@optional

-(void)HandlePostLocationSelectorCancelButtonClicked;
-(void)HandlePostLocationSelectorCurrentLocationSelected;
-(void)HandlePostLocationSelectorPinOnMapSelected;
-(void)HandlePostLocationSelectorInputLocationAddressSelected;

@end

@interface NOMPostLocationSelector : NSObject<UIAlertViewDelegate>

-(id)initWithDelegate:(id<NOMPostLocationSelectorDelegate>)delegate;
-(void)ShowThreeLocationsOptionSelector;

@end
