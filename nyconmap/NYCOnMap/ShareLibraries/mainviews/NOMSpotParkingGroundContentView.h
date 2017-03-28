//
//  NOMSpotParkingGroundContentView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMSpotParkingGroundContentView : UIView<UITextFieldDelegate>

-(float)GetContentViewHeight;
-(void)UpdateLayout;

-(void)Reset;
-(void)SetAddress:(NSString*)address;
-(void)SetName:(NSString*)name;
-(void)SetRate:(double)dRate;
-(void)SetRateUnit:(int16_t)nUnit;

-(NSString*)GetAddress;
-(NSString*)GetName;
-(double)GetRate;
-(int16_t)GetRateUnit;


@end
