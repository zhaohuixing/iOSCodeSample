//
//  TextMsgDisplay.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextMsgBoardDelegate

-(void)OnMsgBoardClose;

@end


@interface TextMsgDisplay : UIView <UITextViewDelegate>
{
@private
    CGPoint                     m_AchorPoint;
	UITextView*                 m_MessageBoard;
	UIButton*                   m_CloseButton;
    id<TextMsgBoardDelegate>    m_Parent;          
}

-(void)SetAchorAtTop:(float)fPostion;
-(void)SetAchorAtBottom:(float)fPostion;
-(void)RegisterParent:(id<TextMsgBoardDelegate>)parent;
-(void)UpdateViewLayout;
-(NSString*)GetTextMessage;
-(BOOL)HasTextMessage;
-(void)CleanTextMessage;
-(void)SetTextMessage:(NSString*)text;

@end
