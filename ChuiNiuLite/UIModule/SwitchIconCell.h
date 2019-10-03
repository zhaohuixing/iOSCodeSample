//
//  SwitchIconCell.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListConstants.h"

@interface SwitchIconCell : UIView <ListCellTemplate>
{
    UIImageView*                m_Icon;
    UISwitch*                   m_Switch;
    int                         m_nCtrlID;
}
- (id)initWithFrame:(CGRect)frame withImage:(NSString*)srcImage;
-(void)RegisterControlID:(int)nID;
-(void)SetSwitch:(BOOL)bOnOff;
-(BOOL)GetSwitchOnOff;

@end
