//
//  CDropdownListContainer.h
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDropdownListDisplayView.h"

@interface CDropdownListContainer : UIView
{
}

-(void)RegisterCtrlID:(int)nCtrlID;
-(int)GetCtrlID;
-(float)GetLayoutWidth;
-(float)GetLayoutHeight;
-(void)UpdateLayout:(float)origX withY:(float)origY;
-(void)AddItem:(CDropdownListItem*)item;
-(void)SetSelectedItem:(int)nItemID;
-(void)Open;
-(void)Close;
@end
