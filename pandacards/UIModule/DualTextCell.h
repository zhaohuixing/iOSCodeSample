//
//  DualTextCell.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListConstants.h"


@interface DualTextCell : UIView <ListCellTemplate> 
{
    UILabel*                    m_Title;
    UILabel*                    m_Text;
	BOOL                        m_bSelectable;
	BOOL                        m_bSelected;

    CGImageRef                  m_Icon;
    BOOL                        m_bLongerText;
    id<ListCellDataTemplate>    m_DataStorage;
}

@property (nonatomic, retain)id<ListCellDataTemplate>	m_DataStorage;


- (id)initWithResource:(NSString*)icon withFrame:(CGRect)frame;
- (id)initWithImage:(CGImageRef)image withFrame:(CGRect)frame;

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
-(float)GetCellHeight;
-(void)OffsetYCell:(float)Y;
-(CGRect)GetFrame;
-(void)SetFrame:(CGRect)rect;
-(void)SetTitle:(NSString*)text;
-(NSString*)GetTitle;
-(void)SetText:(NSString*)text;
-(NSString*)GetText;
-(void)SetTitleAlignment:(enCELLTEXTALIGNMENT)alignment;
-(void)SetTextAlignment:(enCELLTEXTALIGNMENT)alignment;
-(void)SetLongerText;

-(void)SetCellData:(id<ListCellDataTemplate>)data;
-(id<ListCellDataTemplate>)GetCellData;

@end
