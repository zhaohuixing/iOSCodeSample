//
//  TextMsgPoster.h
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"
#import "CustomGlossyButton.h"

@interface TextMsgPoster : FrameView <CustomGlossyButtonDelegate, UITextViewDelegate>
{
@private
	UITextView*                 m_MessageEditor;
	CustomGlossyButton*         m_SendButton;
    BOOL                        m_bEditing;
    float                       m_OriginalY;
    BOOL                        m_bShifted;
}

-(void)UpdateViewLayout;
-(NSString*)GetTextMessage;
-(BOOL)HasTextMessage;
-(void)CleanTextMessage;
-(BOOL)IsEditing;

@end
