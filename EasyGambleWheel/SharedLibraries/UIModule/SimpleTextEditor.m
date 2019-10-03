//
//  SimpleTextEditor.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "SimpleTextEditor.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"
#import "DrawHelper2.h"
#include "drawhelper.h"

#define TEXTEDITOR_BUTTON_ID_CANCEL         0
#define TEXTEDITOR_BUTTON_ID_OK             1

@implementation TextEditorUI

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float textHeight = [GUILayout GetDefaultTextEditorButtonHeight];
        float textWidth = [GUILayout GetDefaultTextEditorWidth]-2.0*([GUILayout GetDefaultTextEditorHeightMargin]+[GUILayout GetDefaultAlertUIEdge]);
        float btnWidth = [GUILayout GetDefaultTextEditorButtonWidth];
        
        float sx = [GUILayout GetDefaultTextEditorHeightMargin]+[GUILayout GetDefaultAlertUIEdge];
        float sy = [GUILayout GetDefaultTextEditorHeightMargin]+[GUILayout GetDefaultAlertUIEdge];
        CGRect rect = CGRectMake(sx, sy, textWidth, textHeight);
        m_TextEditor = [[UITextField alloc] initWithFrame:rect];
        m_TextEditor.borderStyle = UITextBorderStyleRoundedRect;
		m_TextEditor.textColor = [UIColor blackColor]; 
		m_TextEditor.font = [UIFont systemFontOfSize:textHeight*0.6]; 
		m_TextEditor.placeholder = @"<enter text>";  
		m_TextEditor.backgroundColor = [UIColor whiteColor]; 
		m_TextEditor.autocorrectionType = UITextAutocorrectionTypeNo;	
		
		m_TextEditor.keyboardType = UIKeyboardTypeDefault; 
		m_TextEditor.returnKeyType = UIReturnKeyDone; 
		m_TextEditor.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
		m_TextEditor.delegate = self;  
        [self addSubview:m_TextEditor];
        
        sx = rect.origin.x+rect.size.width - btnWidth;
        sy = rect.origin.y+rect.size.height+[GUILayout GetDefaultTextEditorHeightMargin];
        rect = CGRectMake(sx, sy, btnWidth, textHeight);
        m_OKButton = [[CustomGlossyButton alloc] initWithFrame:rect];
        [self addSubview:m_OKButton];

        sx -= (btnWidth+[GUILayout GetDefaultTextEditorHeightMargin]);
        rect = CGRectMake(sx, sy, btnWidth, textHeight);
        m_CancelButton = [[CustomGlossyButton alloc] initWithFrame:rect];
        [self addSubview:m_CancelButton];
        m_bKeyboardActive = NO;
    }
    return self;
}

-(void)dealloc
{
    m_Parent = nil;
    
}


-(NSString*)GetText
{
    NSString* text = @"";
    text = m_TextEditor.text;
    return text;
}

-(void)SetButtonCaptions:(NSString*)okString cancelString:(NSString*)cancelString
{
    [m_OKButton RegisterButton:self withID:TEXTEDITOR_BUTTON_ID_OK withLabel:okString];
    [m_OKButton SetGreenDisplay];
    [m_CancelButton RegisterButton:self withID:TEXTEDITOR_BUTTON_ID_CANCEL withLabel:cancelString];
}

-(void)SetParent:(id<TextEditorUIDelegate>)parent
{
    m_Parent = parent;
}

-(void)OnTextEditorOpen
{
    //Do nothing.
    m_bKeyboardActive = NO;
}

-(void)OnTextEditorClose
{
    [m_TextEditor resignFirstResponder];
    if(m_Parent)
        [m_Parent OnTextEditorClosed];
}

-(void)OpenTextEditor:(NSString*)text
{
    if(text == nil)
        [m_TextEditor setText:@""];
    else
        [m_TextEditor setText:text];
   
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnTextEditorOpen)];
    self.hidden = NO;
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
    [UIView commitAnimations];
}

-(void)CloseTextEditor
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnTextEditorClose)];
    self.hidden = YES;
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];
}

-(void)UpdateViewLayout
{
    CGRect rect = self.frame;
    rect.origin.x = ([GUILayout GetMainUIWidth] - rect.size.width)/2.0;
    if(!m_bKeyboardActive || ([ApplicationConfigure iPADDevice] && [GUILayout IsProtrait]))
    {
        rect.origin.y = ([GUILayout GetMainUIHeight] - self.frame.size.height)/2.0;
    }
    else 
    {
        rect.origin.y = [GUILayout GetMainUIHeight] - [GUILayout GetDefaultKeyboardHeight] - 2*[GUILayout GetDefaultAlertUIEdge]-self.frame.size.height;
    }
    [self setFrame:rect];
}

//CustomGlossyButtonDelegate method
-(void)OnButtonClick:(int)nButtonID
{
    if(m_Parent)
    {
        [m_Parent OnButtonClickHandler:nButtonID];
    }
}

//UITextFieldDelegate method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_bKeyboardActive = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    float sx = ([GUILayout GetMainUIWidth] - self.frame.size.width)/2.0;
    float sy = [GUILayout GetMainUIHeight] - [GUILayout GetDefaultKeyboardHeight] - 2*[GUILayout GetDefaultAlertUIEdge]-self.frame.size.height;
    if([ApplicationConfigure iPADDevice] && [GUILayout IsProtrait])
    {
        sy = ([GUILayout GetMainUIHeight] - self.frame.size.height)/2.0;
    }
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width, self.frame.size.height);
    [self setFrame:rect];
    [UIView commitAnimations];    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    m_bKeyboardActive = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    float sx = ([GUILayout GetMainUIWidth] - self.frame.size.width)/2.0;
    float sy = ([GUILayout GetMainUIHeight] - self.frame.size.height)*2;
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width, self.frame.size.height);
    [self setFrame:rect];
    [UIView commitAnimations];    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[m_TextEditor resignFirstResponder];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    float fsize = [GUILayout GetOptionalAlertUIConner];
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    [DrawHelper2 DrawOptionalAlertBackground:context at:rect];
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float foffset = [GUILayout GetDefaultAlertUIEdge]/2.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawOptionalAlertBackgroundDecoration:context];
    CGContextRestoreGState(context);
}

@end


@implementation SimpleTextEditor

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_Delegate = nil;
        float textHeight = [GUILayout GetDefaultTextEditorHeight];
        float textWidth = [GUILayout GetDefaultTextEditorWidth];
        float sx = ([GUILayout GetMainUIWidth] - textWidth)*0.5;
        float sy = ([GUILayout GetMainUIHeight] - textHeight)*0.5;
        
        CGRect rect = CGRectMake(sx, sy, textWidth, textHeight);
        m_TextEditor = [[TextEditorUI alloc] initWithFrame:rect];
        m_TextEditor.hidden = YES;
        [self addSubview:m_TextEditor];
    }
    return self;
}

-(void)dealloc
{
    m_Delegate = nil;
    
}

-(void)SetButtonCaptions:(NSString*)okString cancelString:(NSString*)cancelString
{
    [m_TextEditor SetParent:self];
    [m_TextEditor SetButtonCaptions:okString cancelString:cancelString];
}


-(void)OnButtonClickHandler:(int)nButtonID
{
    if(nButtonID == TEXTEDITOR_BUTTON_ID_OK)
    {
        if(m_Delegate)
        {
            [m_Delegate SetEditedText:[m_TextEditor GetText]];
        }
    }
    [m_TextEditor CloseTextEditor];
}

-(void)SetDelegate:(id<SimpleTextEditorDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)OnTextEditorClosed
{
    m_Delegate = nil;
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
    if([self.superview respondsToSelector:@selector(OnTextEditingDone)])
    {
        [self.superview performSelector:@selector(OnTextEditingDone)];
    }
}

-(void)OpenTextEditor:(id<SimpleTextEditorDelegate>)delegate withText:(NSString*)text
{
    m_Delegate = delegate;
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    float textHeight = [GUILayout GetDefaultTextEditorHeight];
    float textWidth = [GUILayout GetDefaultTextEditorWidth];
    float sx = ([GUILayout GetMainUIWidth] - textWidth)*0.5;
    float sy = ([GUILayout GetMainUIHeight] - textHeight)*0.5;
    
    CGRect rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_TextEditor setFrame:rect];
    [m_TextEditor OpenTextEditor:text];
}

-(void)UpdateViewLayout
{
    [m_TextEditor UpdateViewLayout];
}
@end
