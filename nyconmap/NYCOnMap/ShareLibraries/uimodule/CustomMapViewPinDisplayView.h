//
//  CustomMapViewPinDisplayView.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-17.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMapViewPinItemListView.h"

@interface CustomMapViewPinDisplayView : UIScrollView<UIScrollViewDelegate>
{
    CustomMapViewPinItemListView*           m_ItemListView;
}

-(float)GetCalloutItemHeight;
-(float)GetAllCalloutItemHeight;
-(int)GetCalloutItemCount;

-(void)UpdateLayout;

-(void)RemoveAllPinItems;
-(void)AddPinItem:(CustomMapViewPinItem*)item;

@end
