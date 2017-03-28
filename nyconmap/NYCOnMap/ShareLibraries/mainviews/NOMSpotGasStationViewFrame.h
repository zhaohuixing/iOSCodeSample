//
//  NOMSpotGasStationViewFrame.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMSpotGasStationViewFrame : UIScrollView<UIScrollViewDelegate>

-(void)UpdateLayout;
-(void)ScrollViewTo:(float)scrollOffsetY;
-(void)RestoreScrollViewDefaultPosition;

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

@end
