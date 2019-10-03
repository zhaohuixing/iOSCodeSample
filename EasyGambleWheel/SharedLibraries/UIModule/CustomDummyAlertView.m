//
//  CustomDummyAlertView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CustomDummyAlertView.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "DrawHelper2.h"
#include "drawhelper.h"

///////////////////////////////////////////////////////////////////////////////////////////
//
// CustomDummyAlertView
//
///////////////////////////////////////////////////////////////////////////////////////////
@implementation CustomDummyAlertView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        float w = self.frame.size.width;
        float h = self.frame.size.height;
        float dsize = [GUILayout GetDefaultAlertUIEdge];
        float dw = w-dsize*2.0;
        float dh = h-dsize*2.0;
        CGRect rt = CGRectMake(dsize, dsize, dw, dh);
        m_Label = [[UILabel alloc] initWithFrame:rt];
        m_Label.backgroundColor = [UIColor clearColor];
        [m_Label setTextColor:[UIColor yellowColor]];
        m_Label.font = [UIFont fontWithName:@"Times New Roman" size:dh*0.8];
        [m_Label setTextAlignment:NSTextAlignmentCenter];
        m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label.adjustsFontSizeToFitWidth = YES;
        m_Label.numberOfLines = 1;
        [self addSubview:m_Label];
    }
    return self;
}

-(void)SetMultiLineText:(BOOL)bMultiLine
{
    if(bMultiLine)
        m_Label.numberOfLines = 0;
    else
        m_Label.numberOfLines = 1;
    [m_Label setNeedsLayout];
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

-(void)SetMessage:(NSString*)text
{
    [m_Label setText:text];
}

-(void)UpdateSubViewsOrientation
{
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    float dsize = [GUILayout GetDefaultAlertUIEdge];
    float dw = w-dsize*2.0;
    float dh = h-dsize*2.0;
    CGRect rt = CGRectMake(dsize, dsize, dw, dh);
    [m_Label setFrame:rt];  
    [self setNeedsDisplay];
}

-(void)Show
{
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    [self setNeedsDisplay];
}

-(void)Hide
{
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
//
// CustomDummyAlertButtonView
//
///////////////////////////////////////////////////////////////////////////////////////////
@implementation CustomDummyAlertButtonView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        float w = self.frame.size.width;
        float h = self.frame.size.height;
        float dy = [GUILayout GetDefaultAlertUIEdge]*2.0;
        float bw = [GUILayout GetDefaultAlertButtonWidth];
        float bh = [GUILayout GetDefaultAlertButtonHeight];
        CGRect rt = CGRectMake(w*0.5+(w*0.5-bw)/2.0, h-bh-dy, bw, bh);
        m_btnCancel = [[CustomGlossyButton alloc] initWithFrame:rt];
        [m_btnCancel RegisterButton:self withID:ALERT_CANCEL withLabel:@"No"];
        m_btnCancel.hidden = NO;
        [self addSubview:m_btnCancel];
        
        rt = CGRectMake((w*0.5-bw)/2.0, h-bh-dy, bw, bh);
        m_btnOK = [[CustomGlossyButton alloc] initWithFrame:rt];
        [m_btnOK SetGreenDisplay];
        [m_btnOK RegisterButton:self withID:ALERT_OK withLabel:@"Yes"];
        m_btnOK.hidden = NO;
        [self addSubview:m_btnOK];
        rt = m_Label.frame;
        rt.origin.y = dy;
        rt.size.height = m_Label.frame.size.height-bh-dy*2.0;
        [m_Label setFrame:rt];
        m_Label.font = [UIFont fontWithName:@"Times New Roman" size:bh*0.8];
        [self SetMultiLineText:YES];        
    }
    return self;
}

-(void)OnButtonClick:(int)nButtonID
{
    m_nClickedButton = nButtonID;
    [self CloseView:YES];
}

-(int)GetClickedButton
{
    return  m_nClickedButton;
}

-(void)SetOKButtonString:(NSString*)szOK
{
    [m_btnOK SetLabel:szOK];
}

-(void)SetCancelButtonString:(NSString*)szCancel
{
    [m_btnCancel SetLabel:szCancel];
}

-(void)OnViewClose
{
	[[self superview] sendSubviewToBack:self];
    if([[self superview] respondsToSelector:@selector(OnCustomDummyAlertViewClosed)])
    {
        [[self superview] performSelector:@selector(OnCustomDummyAlertViewClosed)];
    }
}	

-(void)CloseView:(BOOL)bAnimation
{
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
        self.hidden = YES;
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewClose)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
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
    m_nClickedButton = -1;
	[[self superview] bringSubviewToFront:self];
	self.hidden = NO;
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewOpen)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
		[UIView commitAnimations];
	}
	else 
	{
		[self OnViewOpen];
	}
}


@end
