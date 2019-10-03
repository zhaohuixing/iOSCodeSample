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

-(id)initWithLabelImageSource:(NSString*) __unused srcImage withFrame:(CGRect)frame withLabelHeight:(CGFloat)lHeight;
-(id)initWithLabelImage:(CGImageRef) __unused srcImage withFrame:(CGRect)frame withLabelHeight:(CGFloat)lHeight;

-(void)OnUnCellsCheckBox:(id)sender;
-(void)OnUnSelectAllCells:(id)sender;
-(void)OnCellSelectedEvent:(id)sender;

@end
