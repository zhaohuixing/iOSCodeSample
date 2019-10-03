//
//  CustomDummyAlertView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CustomGlossyButton.h"

@interface CustomDummyAlertView : UIView 
{
    UILabel*                                        m_Label;
}

-(void)SetMessage:(NSString*)text;
-(void)UpdateSubViewsOrientation;
-(void)Show;
-(void)Hide;
-(void)SetMultiLineText:(BOOL)bMultiLine;

@end


@interface CustomDummyAlertButtonView : CustomDummyAlertView<CustomGlossyButtonDelegate> 
{
    CustomGlossyButton*     m_btnOK;
    CustomGlossyButton*     m_btnCancel;
    int                     m_nClickedButton;
}

-(int)GetClickedButton;
-(void)SetOKButtonString:(NSString*)szOK;
-(void)SetCancelButtonString:(NSString*)szCancel;
-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;



@end

