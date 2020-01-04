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

-(void)SendButtonClick
{
    [GUIEventLoop SendEvent:GUIID_TEXTMESG_SENDBUTTON_CLICK eventSender:self];    
    [m_MessageEditor resignFirstResponder];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_AchorPoint = CGPointMake(frame.size.width*0.3, 0);
        
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
		[m_MessageEditor release];
        [self sendSubviewToBack:m_MessageEditor];
        
        sx = (self.frame.size.width-bw)/2.0;
        sy = self.frame.size.height-fsize-bh;
        rect = CGRectMake(sx, sy, bw, bh);
        
        m_SendButton = [[CustomGlossyButton alloc] initWithFrame:rect];
        [m_SendButton SetGreenDisplay];
        [m_SendButton RegisterButton:self withID:ALERT_CANCEL withLabel:[StringFactory GetString_Send]];
        [self addSubview:m_SendButton];
        [m_SendButton release];
        
        [self UpdateViewLayout];
    }
    return self;
}

-(void)SetAchorAtTop:(float)fPostion
{
    m_AchorPoint = CGPointMake(self.frame.size.width*fPostion, 0);
    [self UpdateViewLayout];
}

-(void)SetAchorAtBottom:(float)fPostion
{
    m_AchorPoint = CGPointMake(self.frame.size.width*fPostion, self.frame.size.height);
    [self UpdateViewLayout];
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
    float foffset = [GUILayout GetDefaultAlertUIEdge]/4.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawHalfSizeGrayBackgroundDecoration:context];
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
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
}	

- (void)textViewDidChange:(UITextView *)textView
{
	if([textView hasText] == YES)
	{
		if(200 <= [textView.text length])
		{
			[textView resignFirstResponder];
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

-(void)CloseView:(BOOL)bAnimation
{
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

-(void)OpenView:(BOOL)bAnimation
{
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

-(void)OnButtonClick:(int)nButtonID
{
    [self SendButtonClick];
}


@end


