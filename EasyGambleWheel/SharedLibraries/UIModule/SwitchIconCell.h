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
    CGImageRef                  m_IconEnableState;
    CGImageRef                  m_IconDisableState;
    UISwitch*                   m_Switch;
    int                         m_nCtrlID;
	BOOL                        m_bSelectable;
	BOOL                        m_bSelected;
    id<ListCellDataTemplate>    m_DataStorage;
}

@property (nonatomic, retain)id<ListCellDataTemplate>	m_DataStorage;

- (id)initWithFrame:(CGRect)frame withImage:(NSString*)srcImage withDisableImage:(NSString*)disableIcon;
-(void)RegisterControlID:(int)nID;
-(void)SetSwitch:(BOOL)bOnOff;
-(BOOL)GetSwitchOnOff;

-(void)SetCellData:(id<ListCellDataTemplate>)data;
-(id<ListCellDataTemplate>)GetCellData;
-(void)DisableSwitch;
@end
