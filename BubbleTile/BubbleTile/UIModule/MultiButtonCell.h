//
//  MultiButttonCell.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListConstants.h"

@interface MultiButtonCell : UIView <ListCellTemplate> 
{
    UILabel*                    m_Text;
    UIButton*                   m_Button1;
    int                         m_nCtrlID1;

    UIButton*                   m_Button2;
    int                         m_nCtrlID2;
    
    UIButton*                   m_Button3;
    int                         m_nCtrlID3;
    
    UIButton*                   m_Button4;
    int                         m_nCtrlID4;
    
	id<ListCellDataTemplate>	m_DataStorage;    
}

@property (nonatomic, retain)id<ListCellDataTemplate>	m_DataStorage;

- (id)initWithFrame:(CGRect)frame;
- (void)RegisterButtonResouce1:(int)nID withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage;
- (void)RegisterButtonResouce2:(int)nID withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage;
- (void)RegisterButtonResouce3:(int)nID withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage;
- (void)RegisterButtonResouce4:(int)nID withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage;

- (void)SetButton1Enable:(BOOL)bEnable;
- (void)SetButton2Enable:(BOOL)bEnable;
- (void)SetButton3Enable:(BOOL)bEnable;
- (void)SetButton4Enable:(BOOL)bEnable;

- (BOOL)GetButton1Enable;
- (BOOL)GetButton2Enable;
- (BOOL)GetButton3Enable;
- (BOOL)GetButton4Enable;

-(void)SetCellData:(id<ListCellDataTemplate>)data;
-(id<ListCellDataTemplate>)GetCellData;

@end
