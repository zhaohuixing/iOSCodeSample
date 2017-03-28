//
//  NOMSpotParkingGroundViewFrame.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMSpotParkingGroundViewFrame : UIScrollView<UIScrollViewDelegate>

-(void)UpdateLayout;
-(void)ScrollViewTo:(float)scrollOffsetY;
-(void)RestoreScrollViewDefaultPosition;

-(void)Reset;
-(void)SetAddress:(NSString*)address;
-(void)SetName:(NSString*)name;
-(void)SetRate:(double)dPrice;
-(void)SetRateUnit:(int16_t)nUnit;

-(NSString*)GetAddress;
-(NSString*)GetName;
-(double)GetRate;
-(int16_t)GetRateUnit;

@end
