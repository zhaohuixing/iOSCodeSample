//
//  TextCheckboxCell.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ListConstants.h"

@interface TextCheckboxCell : UIView <ListCellTemplate>
{
    UILabel*                    m_Title;
    UIImageView*                m_CheckBox;
	BOOL                        m_bSelectable;
	BOOL                        m_bSelected;
    id<ListCellDataTemplate>    m_Data;

    BOOL                        m_CheckBoxToggleabel;

    UIImageView*                m_Icon;
}

@property (nonatomic, retain)id<ListCellDataTemplate>	m_Data;

- (id)initWithResource:(NSString*)icon withFrame:(CGRect)frame;

-(enLISTCELLTYPE)GetListCellType;
-(BOOL)IsSelectable;
-(void)SetSelectable:(BOOL)bSelectable;
-(void)SetSelectionState:(BOOL)bSelected;
-(BOOL)GetSelectionState;
-(BOOL)HasCheckBox;
-(void)SetCheckBoxState:(BOOL)bChecked;
-(BOOL)GetCheckBoxState;
-(BOOL)HasSwitch;
-(BOOL)GetSwitchState;
-(void)SetCellData:(id<ListCellDataTemplate>)data;
-(id<ListCellDataTemplate>)GetCellData;
-(float)GetCellHeight;
-(void)OffsetYCell:(float)Y;
-(CGRect)GetFrame;
-(void)SetFrame:(CGRect)rect;
-(void)SetTitle:(NSString*)text;

-(void)SetToggleable:(BOOL)bToggle;
@end
