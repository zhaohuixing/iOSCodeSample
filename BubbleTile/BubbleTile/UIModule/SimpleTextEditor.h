//
//  SimpleTextEditor.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CustomGlossyButton.h"

@protocol TextEditorUIDelegate <NSObject>
-(void)OnButtonClickHandler:(int)nButtonID;
-(void)OnTextEditorClosed;
@end

@protocol SimpleTextEditorDelegate <NSObject>
-(void)SetEditedText:(NSString*)newText;
@end

@interface TextEditorUI : UIView<CustomGlossyButtonDelegate, UITextFieldDelegate>
{
    id<TextEditorUIDelegate>    m_Parent;
    UITextField*                m_TextEditor;
    CustomGlossyButton*         m_OKButton;
    CustomGlossyButton*         m_CancelButton;
    BOOL                        m_bKeyboardActive;
}

-(NSString*)GetText;
-(void)SetButtonCaptions:(NSString*)okString cancelString:(NSString*)cancelString;
-(void)SetParent:(id<TextEditorUIDelegate>)parent;
-(void)OpenTextEditor:(NSString*)text;
-(void)CloseTextEditor;
-(void)UpdateViewLayout;


//CustomGlossyButtonDelegate method
-(void)OnButtonClick:(int)nButtonID;

//UITextFieldDelegate method
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

@end


@interface SimpleTextEditor : UIView<TextEditorUIDelegate> 
{
    TextEditorUI*                           m_TextEditor;
    id<SimpleTextEditorDelegate>            m_Delegate;
}

-(void)SetButtonCaptions:(NSString*)okString cancelString:(NSString*)cancelString;
-(void)OnButtonClickHandler:(int)nButtonID;
-(void)SetDelegate:(id<SimpleTextEditorDelegate>)delegate;
-(void)OpenTextEditor:(id<SimpleTextEditorDelegate>)delegate withText:(NSString*)text;
-(void)UpdateViewLayout;
@end
