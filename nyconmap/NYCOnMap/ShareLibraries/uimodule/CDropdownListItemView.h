//
//  CDropdownListItemView.h
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDropdownListItem.h"

@interface CDropdownListItemView : UIView

-(void)RemoveAllItems;
-(void)UnselectedAllItems;
-(int)GetItemCount;
-(void)AddItem:(CDropdownListItem*)item;
-(void)UpdateLayout;
-(float)GetContentHeight;
-(void)SetSelectedItem:(int)nItemID;


@end
