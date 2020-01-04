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

-(id)initWithLabelImageSource:(NSString*)srcImage withFrame:(CGRect)frame withLabelHeight:(float)lHeight;
-(id)initWithLabelImage:(CGImageRef)srcImage withFrame:(CGRect)frame withLabelHeight:(float)lHeight;

-(void)OnUnCellsCheckBox:(id)sender;
-(void)OnUnSelectAllCells:(id)sender;
-(void)OnCellSelectedEvent:(id)sender;

@end
