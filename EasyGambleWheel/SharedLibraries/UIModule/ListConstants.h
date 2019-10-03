//
//  ListConstants.h
//  testscollview
//
//  Created by Zhaohui Xing on 10-12-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    enCELLTEXTALIGNMENT_LEFT,
    enCELLTEXTALIGNMENT_CENTER,
    enCELLTEXTALIGNMENT_RIGHT,
}enCELLTEXTALIGNMENT;

typedef enum 
{
	enLISTCELLDATA_INT,
	enLISTCELLDATA_FLOAT,
	/*enLISTCELLDATA_DOUBLE,*/
	enLISTCELLDATA_STRING,
	enLISTCELLTYPE_OBJECT,
} enLISTCELLDATATYPE;

typedef enum 
{
	enLISTCELLTYPE_BASIC,
	enLISTCELLTYPE_TITLE,
	enLISTCELLTYPE_CHECKBOX,
	enLISTCELLTYPE_BUTTON,
	enLISTCELLTYPE_SWITCH,
	enLISTCELLTYPE_GROUP,
	enLISTCELLTYPE_ADBANNER,
} enLISTCELLTYPE;

@protocol ListCellDataTemplate
-(enLISTCELLDATATYPE)GetDataType; 
-(void)Destroy;
@end

@protocol ListCellDataIntegerTemplate
-(int)GetData;  
@end

@protocol ListCellDataFloatTemplate
-(float)GetData;  
@end

/*
@protocol ListCellDataTemplateDouble
-(double)GetData;  
@end
*/

@protocol ListCellDataStringTemplate
-(NSString*)GetData;  
@end

@protocol ListCellDataObjectTemplate
-(id)GetData;  
@end

@protocol ListCellTemplate
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
-(NSString*)GetTitle;
@end

@protocol ListCellGroupTemplate
-(void)OnUnCheckAllCells:(id)sender;
-(void)OnUnSelectAllCells:(id)sender;
-(void)OnCellSelectedEvent:(id)sender;
-(NSString*)GetTitleText;
-(int)GetCellCount;
-(void)AddCell:(id<ListCellTemplate>)pCell;
-(id<ListCellTemplate>)GetCellAt:(int)index;
-(void)RemoveCellAt:(int)index;
-(int)FindCellIndex:(id<ListCellTemplate>)pCell;
-(CGSize)GetSize;
-(float)GetGroupHeight;
@end

@protocol ListCellAdBannerTemplate
-(void)RefreshAd;
@end

@protocol ListContentViewTemplate
-(void)OnUnCheckAllCells:(id)sender;
-(void)OnUnSelectAllCells:(id)sender;
-(void)OnCellSelectedEvent:(id)sender;
-(float)GetListHeight;
-(void)AddCell:(id<ListCellTemplate>)cell;
-(void)OnLayoutChange;
-(void)RemoveCellAt:(int)pos;
-(void)RemoveCell:(id<ListCellTemplate>)cell;
-(void)RemoveAllCells;
-(void)UpdateLayoutHeight;
-(int)GetCellCount;
-(id<ListCellTemplate>)GetCell:(int)index;
@end

@protocol ListContainerTemplate
-(void)OnCellSelectedEvent:(id)sender;
-(void)UpdateContentSizeByContentView;
-(CGSize)GetContainerSize;
-(void)ResetContent;
-(void)AddCell:(id<ListCellTemplate>)cell;
-(void)RemoveCellAt:(int)pos;
-(void)RemoveCell:(id<ListCellTemplate>)cell;
-(void)RemoveAllCells;
-(int)GetCellCount;
-(id<ListCellTemplate>)GetCell:(int)index;
@end
