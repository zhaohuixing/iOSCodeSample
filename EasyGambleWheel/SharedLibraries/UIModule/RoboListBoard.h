//
//  RoboListBoard.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-08-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DualTextCell.h"

@interface RoboListBoard : UIView <UITextViewDelegate>
{
@private
    CGPoint                     m_AchorPoint;
    UILabel*                    m_Title;
    DualTextCell*               m_ListCell1;
    DualTextCell*               m_ListCell2;
    DualTextCell*               m_ListCell3;
    DualTextCell*               m_ListCell4;
    
}

-(void)SetAchorAtLeft:(float)fPostion;
-(void)SetAchorAtRight:(float)fPostion;
-(void)UpdateViewLayout;
-(void)SetTitle:(NSString*)szTitle;
-(void)SetCell1:(NSString*)szTitle withText:(NSString*)szText;
-(void)SetCell2:(NSString*)szTitle withText:(NSString*)szText;
-(void)SetCell3:(NSString*)szTitle withText:(NSString*)szText;
-(void)SetCell4:(NSString*)szTitle withText:(NSString*)szText;
-(void)EnableCell1:(BOOL)bEnable;
-(void)EnableCell2:(BOOL)bEnable;
-(void)EnableCell3:(BOOL)bEnable;
-(void)EnableCell4:(BOOL)bEnable;

@end
