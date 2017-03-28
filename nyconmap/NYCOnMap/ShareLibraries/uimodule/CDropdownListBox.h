//
//  CDropdownListBox.h
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDropdownListContainer.h"
#import "IDropdownListDelegate.h"

@interface CDropdownListBox : UIView<IDropdownListDelegate>
{
}

-(void)RegisterCtrlID:(int)nCtrlID;
-(void)RegisterDropdownList:(CDropdownListContainer*)list;
-(int)GetCtrlID;
-(void)SetEnable:(BOOL)bEnable;
-(BOOL)IsEnable;
-(void)SetOriginInContainer:(float)x withY:(float)y;
-(void)UpdateLayout;

-(void)SetLabel:(NSString*)szLabel;
-(void)SetSelectedItem:(int)nItemID;
-(int)GetSelectedItem;

-(void)CloseDropdownList;
@end
