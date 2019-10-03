//
//  TextMsgPoster.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "TextMsgPoster.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#include "drawhelper.h"
#import "DrawHelper2.h"
#import "ApplicationConfigure.h"
#import "StringFactory.h"

@implementation TextMsgPoster


- (void)keyboardWillShow:(NSNotification *)notification 
{
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    if(self.frame.origin.y < [GUILayout GetMainUIHeight]/2.0)
    {
        m_bShifted = NO;
        return;
    }
    m_bShifted = YES;

    if(m_bShifted)
    {
        // Get the duration of the animation.
        NSDictionary* userInfo = [notification userInfo];
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
    
        // Animate the resize of the text view's frame in sync with the keyboard's appearance.
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
    
        CGRect rect = self.frame;
        rect.origin.y -= [GUILayout GetMainUIHeight]/2.0;
        [self setFrame:rect];
        [UIView commitAnimations];
    }
}


- (void)keyboardWillHide:(NSNotification *)notification 
{
    if(m_bShifted)
    {    
        NSDictionary* userInfo = [notification userInfo];
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
    
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
    
        CGRect rect = self.frame;
        rect.origin.y += [GUILayout GetMainUIHeight]/2.0;
        [self setFrame:rect];
        m_bShifted = NO; 
        [UIView commitAnimations];
    }    
}


-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)OnViewClose
{
    if(m_bShifted)
    {
        CGRect rect = self.frame;
        rect.origin.y = m_OriginalY;
        [self setFrame:rect];
        m_bShifted = NO;
    }    
}

-(void)CloseView:(BOOL)bAnimation
{
    [m_MessageEditor resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];  
	
    if(bAnimation)
	{
        self.hidden = YES;
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(OnViewClose)];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        [UIView commitAnimations];
	}	
	else
	{
        self.hidden = YES;
		[self OnViewClose];
	}
}

-(void)OnViewOpen
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];      [self becomeFirstResponder];
    [self bringSubviewToFront:m_SendButton];
}	

-(void)OpenView:(BOOL)bAnimation
{
    m_OriginalY = self.frame.origin.y;
    m_bShifted = NO;
	self.hidden = NO;
	[[self superview] bringSubviewToFront:self];
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewOpen)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
		[UIView commitAnimations];
	}
	else 
	{
		[self OnViewOpen];
	}
}

-(void)SendButtonClick
{
    [GUIEventLoop SendEvent:GUIID_TEXTMESG_SENDBUTTON_CLICK eventSender:self];    
    [m_MessageEditor resignFirstResponder];
    m_bEditing = NO;
    [self CloseView:YES];
}

-(void)OnButtonClick:(int)nButtonID
{
    [self SendButtonClick];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float bw = [GUILayout GetDefaultAlertButtonWidth];
        float bh = [GUILayout GetDefaultAlertButtonHeight];
        
                 
        float fsize = [GUILayout GetDefaultAlertUIEdge]*2.0;
        float width = self.frame.size.width-2.0*fsize;
        float height = self.frame.size.height-2.0*fsize-bh-[GUILayout GetDefaultAlertUIEdge];
        
        float sx = fsize;
        float sy = fsize;
        CGRect rect = CGRectMake(sx, sy, width, height);
        
        
		m_MessageEditor = [[UITextView alloc] initWithFrame:rect];
		[m_MessageEditor setAutocorrectionType:UITextAutocorrectionTypeNo];
		[m_MessageEditor setEditable:YES];
		m_MessageEditor.backgroundColor = [UIColor whiteColor];
        float fFontSize = 10;
        if([ApplicationConfigure iPADDevice])
            fFontSize *= 1.4;
		m_MessageEditor.font = [UIFont fontWithName:@"Georgia" size:fFontSize];
        [m_MessageEditor setTextColor:[UIColor darkTextColor]];
 		m_MessageEditor.delegate = self;
		[self addSubview:m_MessageEditor];
        [self sendSubviewToBack:m_MessageEditor];

        sx = (self.frame.size.width-bw)/2.0;
        sy = self.frame.size.height-fsize-bh;
        rect = CGRectMake(sx, sy, bw, bh);
        
        m_SendButton = [[CustomGlossyButton alloc] initWithFrame:rect];
        [m_SendButton SetGreenDisplay];
        [m_SendButton RegisterButton:self withID:ALERT_CANCEL withLabel:[StringFactory GetString_Send]];
        [self addSubview:m_SendButton];
        
        [self UpdateViewLayout];
        m_bEditing = NO;
        m_OriginalY = self.frame.origin.y;
        m_bShifted = NO;
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawBackground:(CGContextRef)context inRect:(CGRect)rect;
{
    CGContextSaveGState(context);
    float fsize = [GUILayout GetDefaultAlertUIConner];
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    [DrawHelper2 DrawBlueTextureRect:context at:rect];
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float foffset = [GUILayout GetDefaultAlertUIEdge]/2.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawGrayFrameViewBackgroundDecoration:context];
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}


-(void)UpdateViewLayout
{
    [super UpdateViewLayout];
    
    m_OriginalY = self.frame.origin.y;
    if(0 < m_bShifted)
    {
        CGRect rect = self.frame;
        rect.origin.y -= [GUILayout GetMainUIHeight]/2.0;
        [self setFrame:rect];
    }
    
    
    float bw = [GUILayout GetDefaultAlertButtonWidth];
    float bh = [GUILayout GetDefaultAlertButtonHeight];
    
    
    float fsize = [GUILayout GetDefaultAlertUIEdge]*2.0;
    float width = self.frame.size.width-2.0*fsize;
    float height = self.frame.size.height-2.0*fsize-bh-[GUILayout GetDefaultAlertUIEdge];
    
    float sx = fsize;
    float sy = fsize;
    CGRect rect = CGRectMake(sx, sy, width, height);
    [m_MessageEditor setFrame:rect];
    
    sx = (self.frame.size.width-bw)/2.0;
    sy = self.frame.size.height-fsize-bh;
    rect = CGRectMake(sx, sy, bw, bh);
    [m_SendButton setFrame:rect];
    [self setNeedsDisplay];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    m_bEditing = NO;
    [self becomeFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    m_bEditing = YES;
}	

- (void)textViewDidChange:(UITextView *)textView
{
	if([textView hasText] == YES)
	{
		if(200 <= [textView.text length])
		{
            m_bEditing = NO;
			[textView resignFirstResponder];
            [self becomeFirstResponder];
		}	
	}	
}	

-(NSString*)GetTextMessage
{
	if([m_MessageEditor hasText] == YES)
	{
		return m_MessageEditor.text;
	}	

    return @"";
}

-(BOOL)HasTextMessage
{
    return [m_MessageEditor hasText];
}

-(void)CleanTextMessage
{
    m_MessageEditor.text = @"";
}

-(BOOL)IsEditing
{
    return m_bEditing;
}


@end


