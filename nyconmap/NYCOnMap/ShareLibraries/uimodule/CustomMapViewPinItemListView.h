//
//  CustomMapViewPinItemListView.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-17.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMapViewPinItem.h"


@interface CustomMapViewPinItemListView : UIView

-(void)RemoveAllItems;
-(void)UnselectedAllItems;
-(int)GetItemCount;
-(void)AddItem:(CustomMapViewPinItem*)item;
-(void)UpdateLayout;
-(float)GetContentHeight;

@end
