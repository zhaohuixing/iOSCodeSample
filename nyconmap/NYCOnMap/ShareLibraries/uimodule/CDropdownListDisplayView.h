//
//  CDropdownListDisplayView.h
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CDropdownListItemView.h"
#import "CDropdownListItem.h"

@interface CDropdownListDisplayView : UIScrollView<UIScrollViewDelegate>
{
@private
    CDropdownListItemView*           m_ListItemView;
}

-(int)GetItemsCount;
-(float)GetItemsWidth;
-(float)GetItemsHeight;
-(void)AddItem:(CDropdownListItem*)item;
-(void)UpdateLayout;
-(void)SetSelectedItem:(int)nItemID;

@end
