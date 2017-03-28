//
//  CustomMapViewPinFrame.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomMapViewPinItem;

@interface CustomMapViewPinFrame : UIView

-(float)GetCalloutItemHeight;
-(float)GetAllCalloutItemHeight;
-(int)GetCalloutItemCount;

-(void)UpdateLayout;

-(void)RemoveAllPinItems;
-(void)AddPinItem:(CustomMapViewPinItem*)item;
-(void)SetFlipState:(BOOL)bFlipped;

@end
