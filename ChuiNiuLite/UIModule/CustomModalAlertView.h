//
//  CustomModalAlertView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CustomGlossyButton.h"

@protocol CustomModalAlertDelegate <NSObject>
-(int)GetClickedButtonID;
-(void)SetClickedButtonID:(int)nButtonID;
@end

@interface CustomModalAlertBackgroundView : UIView
{
}

-(void)UpdateSubViewsOrientation;

@end

@interface CustomModalAlertView : UIView<CustomGlossyButtonDelegate>
{
    // Ensures that UI elements behind the dialog are disabled.
    id<CustomModalAlertDelegate>                    m_Delegate;
    UILabel*                                        m_Label;
    UIView*                                         m_BackgroundView;
    int                                             m_nButtonNumber;
    BOOL                                            m_bMultiChoice;
}

-(id)init;
-(void)RegisterDelegate:(id<CustomModalAlertDelegate>)delegate;
-(void)UpdateSubViewsOrientation;

+(int)SimpleSay:(NSString*)msg closeButton:(NSString*)closeBtn;
+(int)SimpleSay:(NSString *)closeBtn withMsg:(id)formatstring,...;

+(int)Ask:(NSString*)msg withButton1:(NSString*)btnCaption1 withButton2:(NSString*)btnCaption2;
+(int)Ask:(NSString*)btnCaption1 andButton2:(NSString*)btnCaption2 forMessage:(id)formatstring,...;

+(int)MultChoice:(NSString*)msg withCancel:(NSString*)btnCancel withChoice:(NSArray*)btnChoice;

@end
