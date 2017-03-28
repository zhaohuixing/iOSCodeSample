//
//  CustomGlossyButton.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-12-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ALERT_CANCEL        0
#define ALERT_CLOSE         ALERT_CANCEL
#define ALERT_NO            ALERT_CANCEL
#define ALERT_OK            1
#define ALERT_YES           ALERT_OK        


@protocol CustomGlossyButtonDelegate <NSObject>

-(void)OnButtonClick:(int)nButtonID;

@end

@interface CustomGlossyButton : UIView
{
    id<CustomGlossyButtonDelegate>                      m_Delegate;
    UILabel*                                            m_Label;
    int                                                 m_nEventID;
    int                                                 m_nColorTheme;
}

-(void)RegisterButton:(id<CustomGlossyButtonDelegate>)delegate withID:(int)nEventID withLabel:(NSString*)label;
-(void)SetGreenDisplay;
-(void)SetRedDisplay;
-(void)SetBlueDisplay;
-(int)GetID;
-(void)SetLabel:(NSString*)label;
-(BOOL)canBecomeFirstResponder;
@end
