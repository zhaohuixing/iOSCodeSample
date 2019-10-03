//
//  GroupCell.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListConstants.h"
#import "LabelCell.h"

@interface GroupCell : UIView <ListCellTemplate, ListCellGroupTemplate>
{
    LabelCell*              m_Title;
    BOOL                    m_bSelectable;
}

-(void)OnUnCellsCheckBox:(id)sender;
-(void)OnUnselectAllCells:(id)sender;
-(void)OnCellSelectedEvent:(id)sender;

@end
