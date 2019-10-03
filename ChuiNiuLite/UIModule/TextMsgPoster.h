//
//  TextMsgPoster.h
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextMsgPoster : UIView <UITextViewDelegate>
{
@private
    CGPoint                 m_AchorPoint;
	UITextView*				m_MessageEditor;
	UIButton*				m_SendButton;
}

-(void)SetAchorAtTop:(float)fPostion;
-(void)SetAchorAtBottom:(float)fPostion;
-(void)UpdateViewLayout;
-(NSString*)GetTextMessage;
-(BOOL)HasTextMessage;
-(void)CleanTextMessage;

@end
