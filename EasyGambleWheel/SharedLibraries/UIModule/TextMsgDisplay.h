//
//  TextMsgDisplay.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"

@protocol TextMsgBoardDelegate

-(void)OnMsgBoardClose;

@end


@interface TextMsgDisplay : FrameView <UITextViewDelegate>
{
@private
	UITextView*                 m_MessageBoard;
    id<TextMsgBoardDelegate>    m_Parent;   
}

-(void)SetAchorAtLeft:(float)fPostion;
-(void)SetAchorAtRight:(float)fPostion;

-(void)RegisterParent:(id<TextMsgBoardDelegate>)parent;
-(void)UpdateViewLayout;
-(NSString*)GetTextMessage;
-(BOOL)HasTextMessage;
-(void)CleanTextMessage;
-(void)SetTextMessage:(NSString*)text;
@end
