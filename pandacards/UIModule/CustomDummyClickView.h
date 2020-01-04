//
//  CustomDummyClickView.h
//  pandacards
//
//  Created by Zhaohui Xing on 12-04-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CustomGlossyButton.h"

@interface CustomClickLabel : UILabel 
{
    int                         m_nEventID;
}

-(void)SetEventID:(int)nEvent;

@end


@interface CustomDummyClickView : UIView<CustomGlossyButtonDelegate> 
{
    CustomClickLabel*                                           m_Label;
    CustomGlossyButton*                                         m_btnOK;
    int                                                         m_nEventID;
}

-(void)SetMessage:(NSString*)text;
-(void)SetEventID:(int)nEvent;
-(void)UpdateSubViewsOrientation;
-(void)Show;
-(void)Hide;
-(void)SetMultiLineText:(BOOL)bMultiLine;
-(void)SetButtonString:(NSString*)szOK;

@end

