//
//  ListCellBasic.h
//  testscollview
//
//  Created by Zhaohui Xing on 10-12-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ListConstants.h"

@interface ListCellBasic : UIView<ListCellTemplate> 
{
	BOOL				m_bSelectable;
	BOOL				m_bSelected;
	
	NSString*			m_szTitle;
	NSString*			m_szDescription;
	CGImageRef			m_iconImage;
	float				m_fHighlightAlpha;
	float				m_fHighlightRed;
	float				m_fHighlightGreen;
	float				m_fHighlightBlue;
	float				m_fOutlineAlpha;
	float				m_fOutlineRed;
	float				m_fOutlineGreen;
	float				m_fOutlineBlue;
	float				m_fFontSize;
	id<ListCellDataTemplate>	m_DataStorage;
}

@property (nonatomic)BOOL						m_bSelectable;
@property (nonatomic, retain)NSString*			m_szTitle;
@property (nonatomic, retain)NSString*			m_szDescription;
@property (nonatomic)CGImageRef					m_iconImage;
@property (nonatomic)float						m_fHighlightAlpha;
@property (nonatomic)float						m_fHighlightRed;
@property (nonatomic)float						m_fHighlightGreen;
@property (nonatomic)float						m_fHighlightBlue;
@property (nonatomic)float						m_fOutlineAlpha;
@property (nonatomic)float						m_fOutlineRed;
@property (nonatomic)float						m_fOutlineGreen;
@property (nonatomic)float						m_fOutlineBlue;
@property (nonatomic)float						m_fFontSize;
@property (nonatomic, retain)id<ListCellDataTemplate>	m_DataStorage;



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
@end
