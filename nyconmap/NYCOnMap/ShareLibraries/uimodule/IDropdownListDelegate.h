//
//  IDropdownListDelegate.h
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDropdownListItem;
@protocol IDropdownListDelegate <NSObject>

-(void)OnListItemSelected:(CDropdownListItem*)item;

@end
