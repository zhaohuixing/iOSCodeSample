//
//  TextMsgDisplay.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "TextMsgDisplay.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#include "drawhelper.h"
#import "DrawHelper2.h"
#import "ApplicationConfigure.h"

@implementation TextMsgDisplay

-(void)OnViewClose
{
    if(m_Parent)
        [m_Parent OnMsgBoardClose];
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

-(void)OnViewOpen
{
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


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        float fsize = [GUILayout GetDefaultAlertUIEdge]*2.5;
        float width = self.frame.size.width-2.0*fsize;
        float height = self.frame.size.height-2.0*fsize;
        
        float sx = fsize;
        float sy = fsize;
        CGRect rect = CGRectMake(sx, sy, width, height);
		m_MessageBoard = [[UITextView alloc] initWithFrame:rect];
		[m_MessageBoard setAutocorrectionType:UITextAutocorrectionTypeNo];
		[m_MessageBoard setEditable:NO];
		m_MessageBoard.backgroundColor = [UIColor whiteColor];
        [m_MessageBoard setTextColor:[UIColor darkTextColor]];
        float fFontSize = 10;
        if([ApplicationConfigure iPADDevice])
            fFontSize *= 1.4;
		m_MessageBoard.font = [UIFont fontWithName:@"Georgia" size:fFontSize];
		m_MessageBoard.delegate = self;
		[self addSubview:m_MessageBoard];
        [self sendSubviewToBack:m_MessageBoard];
        
        [self UpdateViewLayout];
    }
    return self;
}

-(void)RegisterParent:(id<TextMsgBoardDelegate>)parent
{
    m_Parent = parent;
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
    float fsize = [GUILayout GetDefaultAlertUIEdge]*2.5;
    float width = self.frame.size.width-2.0*fsize;
    float height = self.frame.size.height-2.0*fsize;
    
    float sx = fsize;
    float sy = fsize;
    CGRect rect = CGRectMake(sx, sy, width, height);
    [m_MessageBoard setFrame:rect];
    [self setNeedsDisplay];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
}	

- (void)textViewDidChange:(UITextView *)textView
{
}	

-(NSString*)GetTextMessage
{
	if([m_MessageBoard hasText] == YES)
	{
		return m_MessageBoard.text;
	}	

    return @"";
}

-(BOOL)HasTextMessage
{
    return [m_MessageBoard hasText];
}

-(void)CleanTextMessage
{
    m_MessageBoard.text = @"";
}

-(void)SetTextMessage:(NSString*)text
{
    m_MessageBoard.text = text;
}

@end
