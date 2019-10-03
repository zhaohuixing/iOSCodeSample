//
//  SwitchCell.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListConstants.h"

@interface SwitchCell : UIView <ListCellTemplate> 
{
    UILabel*                    m_Text;
    UISwitch*                   m_Switch;
    int                         m_nCtrlID;
}

-(void)RegisterControlID:(int)nID;
-(void)SetSwitch:(BOOL)bOnOff;
-(BOOL)GetSwitchOnOff;

@end
