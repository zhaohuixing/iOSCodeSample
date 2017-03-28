//
//  NOMSpotPhotoRadarViewFrame.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-24.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMSpotPhotoRadarViewFrame : UIScrollView<UIScrollViewDelegate>

-(void)UpdateLayout;
-(void)ScrollViewTo:(float)scrollOffsetY;
-(void)RestoreScrollViewDefaultPosition;

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

@end
