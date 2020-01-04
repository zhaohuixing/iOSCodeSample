//
//  CustomDummyClickView.m
//  pandacards
//
//  Created by Zhaohui Xing on 12-04-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CustomDummyClickView.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"
#include "drawhelper.h"
#import "DrawHelper2.h"
#import "ApplicationConfigure.h"


@implementation CustomClickLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        m_nEventID = -1;
    }
    return self;
}

@end


@implementation CustomDummyClickView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        float w = self.frame.size.width;
        float h = self.frame.size.height;
        float dsize = [GUILayout GetDefaultAlertUIEdge];
        float dw = (self.frame.size.height - dsize*2.0)*0.8;
        float sx = (w - dsize) - dw*1.1;
        float sy = (self.frame.size.height - dw)/2.0;
        
        CGRect rt = CGRectMake(sx, sy, dw, dw);
        m_btnOK = [[CustomGlossyButton alloc] initWithFrame:rt];
        [m_btnOK SetGreenDisplay];
        [m_btnOK RegisterButton:self withID:ALERT_OK withLabel:@"Yes"];
        m_btnOK.hidden = NO;
        [m_btnOK SetLargerLabel];
        [self addSubview:m_btnOK];
        [m_btnOK release];
        
        dw = w-dsize*2.0 - h;
        float dh = h-dsize*2.0;
        rt = CGRectMake(dsize, dsize, dw, dh);
        m_Label = [[CustomClickLabel alloc] initWithFrame:rt];
        m_Label.backgroundColor = [UIColor clearColor];
        [m_Label setTextColor:[UIColor yellowColor]];
        float fontSize = 10;
        if([ApplicationConfigure iPADDevice])
            fontSize = 20;
        m_Label.font = [UIFont fontWithName:@"Times New Roman" size:fontSize];
        [m_Label setTextAlignment:UITextAlignmentCenter];
        m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label.adjustsFontSizeToFitWidth = YES;
        m_Label.numberOfLines = 1;
        [self addSubview:m_Label];
        [m_Label release];
        m_nEventID = -1;
    }
    return self;
}

-(void)OnButtonClick:(int)nButtonID
{
    [self Hide];
    if(0 <= m_nEventID)
    {
        [GUIEventLoop PostEvent:m_nEventID];
    }
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
    [DrawHelper2 DrawDefaultFrameViewBackground:context at:rect];
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float foffset = [GUILayout GetDefaultAlertUIEdge]/2.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawDefaultAlertBackgroundDecoration:context];
    CGContextRestoreGState(context);
}

-(void)SetMessage:(NSString*)text
{
    [m_Label setText:text];
}

-(void)UpdateSubViewsOrientation
{
    /*float w = self.frame.size.width;
    float h = self.frame.size.height;
    float dsize = [GUILayout GetDefaultAlertUIEdge];
    float dw = w-dsize*2.0;
    float dh = h-dsize*2.0;
    CGRect rt = CGRectMake(dsize, dsize, dw, dh);
    [m_Label setFrame:rt]; */ 
    [self setNeedsDisplay];
}

-(void)onViewOpened
{
    [self setNeedsDisplay];
}

-(void)Show
{
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onViewOpened)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];
}

-(void)onViewClosed
{
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
}

-(void)Hide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onViewClosed)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    self.hidden = YES;
    [UIView commitAnimations];
    
}

-(void)SetEventID:(int)nEvent
{
    m_nEventID = nEvent;
}

-(void)SetButtonString:(NSString*)szOK
{
    [m_btnOK SetLabel:szOK];
}


@end
