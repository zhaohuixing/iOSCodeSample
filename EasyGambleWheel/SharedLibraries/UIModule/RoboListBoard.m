//
//  RoboListBoard.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "RoboListBoard.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#import "ApplicationConfigure.h"
#include "drawhelper.h"

@implementation RoboListBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_AchorPoint = CGPointMake(0, frame.size.height*0.3);
        
        CGFloat fFontSize = 14.0;
        if([ApplicationConfigure iPhoneDevice])
            fFontSize = 8.0;
        
        CGFloat roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
        CGFloat archorSize = self.frame.size.height*[GUILayout GetTMSViewAchorRatio];
        
        CGFloat width = self.frame.size.width-2.0*roundSize;
        CGFloat height = (self.frame.size.height-roundSize-archorSize-5)*0.20;
        
        CGFloat sx = roundSize;
        CGFloat sy = roundSize+archorSize;
        CGRect rect = CGRectMake(sx, sy, width, height);

		m_Title = [[UILabel alloc] initWithFrame:rect];
		m_Title.backgroundColor = [UIColor clearColor];
		[m_Title setTextColor:[UIColor redColor]];
		m_Title.font = [UIFont fontWithName:@"Georgia" size:fFontSize];
        [m_Title setTextAlignment:NSTextAlignmentCenter];
        m_Title.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Title.adjustsFontSizeToFitWidth = YES;
		[m_Title setText:@"Test Title"];
		[self addSubview:m_Title];
        
    
        sy += height+1;
        rect = CGRectMake(sx, sy, width, height);
        m_ListCell1 = [[DualTextCell alloc] initWithFrame:rect];
        [m_ListCell1 SetTitle:@"Cell1"]; 
        [m_ListCell1 SetText:@"Text1"];
        [m_ListCell1 SetTitleFontSize:fFontSize]; 
        [m_ListCell1 SetTextFontSize:fFontSize];
        [m_ListCell1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
		[self addSubview:m_ListCell1];

        sy += height+1;
        rect = CGRectMake(sx, sy, width, height);
        m_ListCell2 = [[DualTextCell alloc] initWithFrame:rect];
        [m_ListCell2 SetTitle:@"Cell2"]; 
        [m_ListCell2 SetText:@"Text2"];
        [m_ListCell2 SetTitleFontSize:fFontSize]; 
        [m_ListCell2 SetTextFontSize:fFontSize];
        [m_ListCell2 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
		[self addSubview:m_ListCell2];

        sy += height+1;
        rect = CGRectMake(sx, sy, width, height);
        m_ListCell3 = [[DualTextCell alloc] initWithFrame:rect];
        [m_ListCell3 SetTitle:@"Cell3"]; 
        [m_ListCell3 SetText:@"Text3"];
        [m_ListCell3 SetTitleFontSize:fFontSize]; 
        [m_ListCell3 SetTextFontSize:fFontSize];
        [m_ListCell3 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
		[self addSubview:m_ListCell3];

        sy += height+1;
        rect = CGRectMake(sx, sy, width, height);
        m_ListCell4 = [[DualTextCell alloc] initWithFrame:rect];
        [m_ListCell4 SetTitle:@"Cell4"]; 
        [m_ListCell4 SetText:@"Text4"];
        [m_ListCell4 SetTitleFontSize:fFontSize]; 
        [m_ListCell4 SetTextFontSize:fFontSize];
        [m_ListCell4 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
		[self addSubview:m_ListCell4];
        
        [self UpdateViewLayout];
    }
    return self;
}

-(void)SetAchorAtLeft:(CGFloat)fPostion
{
    m_AchorPoint = CGPointMake(0, self.frame.size.height*fPostion);
    [self UpdateViewLayout];
}

-(void)SetAchorAtRight:(CGFloat)fPostion
{
    m_AchorPoint = CGPointMake(self.frame.size.width, self.frame.size.height*fPostion);
    [self UpdateViewLayout];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawBackGroundFromLeft:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGFloat clr1[] = {0.9, 0.9, 0.9, 1.0};
    
    CGFloat clrg[8] = {0.9, 0.9, 0.9, 1.0, 0.4, 0.4, 0.4, 1.0};
    
    CGFloat archorSize = self.frame.size.height*[GUILayout GetTMSViewAchorRatio];
    
    CGContextSaveGState(context);
    CGContextSetFillColor(context, clr1);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, m_AchorPoint.x, m_AchorPoint.y);
    CGContextAddLineToPoint(context, archorSize, m_AchorPoint.y-archorSize*0.5);
    CGContextAddLineToPoint(context, archorSize, m_AchorPoint.y+archorSize*0.5);
    CGContextAddLineToPoint(context, m_AchorPoint.x, m_AchorPoint.y);
    CGContextClosePath(context);
	//CGContextClip(context);
    CGContextFillPath(context);    
    CGContextRestoreGState(context);
    
    CGRect innerRect = CGRectMake(archorSize, 0, rect.size.width-archorSize, rect.size.height);
    CGFloat roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    
    AddRoundRectToPath(context, innerRect, CGSizeMake(roundSize, roundSize), 0.5);
	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = innerRect.origin.x;
	pt1.y = innerRect.origin.y;
	pt2.x = pt1.x;
	pt2.y = innerRect.origin.y+innerRect.size.height;
    gradientFill = CGGradientCreateWithColorComponents(fillColorspace, clrg, NULL, sizeof(clrg)/(sizeof(clrg[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
    
    CGContextRestoreGState(context);
}

- (void)drawBackGroundFromRight:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat clr1[] = {0.4, 0.4, 0.4, 1.0};
    
    CGFloat clrg[8] = {0.9, 0.9, 0.9, 1.0, 0.4, 0.4, 0.4, 1.0};
    
    CGFloat archorSize = self.frame.size.height*[GUILayout GetTMSViewAchorRatio];
    
    CGContextSaveGState(context);
    CGContextSetFillColor(context, clr1);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, m_AchorPoint.x, m_AchorPoint.y);
    CGContextAddLineToPoint(context, rect.size.width - archorSize, m_AchorPoint.y-archorSize*0.5);
    CGContextAddLineToPoint(context, rect.size.width - archorSize, m_AchorPoint.y+archorSize*0.5);
    CGContextAddLineToPoint(context, m_AchorPoint.x, m_AchorPoint.y);
    CGContextClosePath(context);
	//CGContextClip(context);
    CGContextFillPath(context);    
    CGContextRestoreGState(context);
    
    CGRect innerRect = CGRectMake(0, 0, rect.size.width-archorSize, rect.size.height);
    CGFloat roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    
    AddRoundRectToPath(context, innerRect, CGSizeMake(roundSize, roundSize), 0.5);
	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = innerRect.origin.x;
	pt1.y = innerRect.origin.y;
	pt2.x = pt1.x;
	pt2.y = innerRect.origin.y+innerRect.size.height;
    gradientFill = CGGradientCreateWithColorComponents(fillColorspace, clrg, NULL, sizeof(clrg)/(sizeof(clrg[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
    
    CGContextRestoreGState(context);
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(m_AchorPoint.x == 0.0)
        [self drawBackGroundFromLeft:rect];
    else
        [self drawBackGroundFromRight:rect];
}

-(void)UpdateViewLayoutByLeft
{
    CGFloat roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    CGFloat archorSize = self.frame.size.height*[GUILayout GetTMSViewAchorRatio];
    
    CGFloat width = self.frame.size.width-roundSize-archorSize;
    CGFloat height = (self.frame.size.height-roundSize-5)*0.2;

    CGFloat sx = roundSize*0.5+archorSize;
    CGFloat sy = roundSize*0.5;
    CGRect rect = CGRectMake(sx, sy, width, height);
    
    [m_Title setFrame:rect];
    
    sy += height+1;
    rect = CGRectMake(sx, sy, width, height);
    [m_ListCell1 setFrame:rect]; 
    
    sy += height+1;
    rect = CGRectMake(sx, sy, width, height);
    [m_ListCell2 setFrame:rect]; 
    
    sy += height+1;
    rect = CGRectMake(sx, sy, width, height);
    [m_ListCell3  setFrame:rect]; 
    
    sy += height+1;
    rect = CGRectMake(sx, sy, width, height);
    [m_ListCell4  setFrame:rect]; 
}

-(void)UpdateViewLayoutByRight
{
    CGFloat roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    CGFloat archorSize = self.frame.size.height*[GUILayout GetTMSViewAchorRatio];
    
    CGFloat width = self.frame.size.width-roundSize-archorSize;
    CGFloat height = (self.frame.size.height-roundSize-5)*0.2;

    CGFloat sx = roundSize*0.5;
    CGFloat sy = roundSize*0.5;
    CGRect rect = CGRectMake(sx, sy, width, height);
    
    [m_Title setFrame:rect];
    
    sy += height+1;
    rect = CGRectMake(sx, sy, width, height);
    [m_ListCell1 setFrame:rect]; 
    
    sy += height+1;
    rect = CGRectMake(sx, sy, width, height);
    [m_ListCell2 setFrame:rect]; 
    
    sy += height+1;
    rect = CGRectMake(sx, sy, width, height);
    [m_ListCell3  setFrame:rect]; 
    
    sy += height+1;
    rect = CGRectMake(sx, sy, width, height);
    [m_ListCell4  setFrame:rect]; 
    
}

-(void)UpdateViewLayout
{
    if(m_AchorPoint.x == 0.0)
        [self UpdateViewLayoutByLeft];
    else
        [self UpdateViewLayoutByRight];
}

-(void)SetTitle:(NSString*)szTitle
{
    [m_Title setText:szTitle];
}

-(void)SetCell1:(NSString*)szTitle withText:(NSString*)szText
{
    [m_ListCell1 SetTitle:szTitle];
    [m_ListCell1 SetText:szText];
}

-(void)SetCell2:(NSString*)szTitle withText:(NSString*)szText
{
    [m_ListCell2 SetTitle:szTitle];
    [m_ListCell2 SetText:szText];
    
}

-(void)SetCell3:(NSString*)szTitle withText:(NSString*)szText
{
    [m_ListCell3 SetTitle:szTitle];
    [m_ListCell3 SetText:szText];
}

-(void)SetCell4:(NSString*)szTitle withText:(NSString*)szText
{
    [m_ListCell4 SetTitle:szTitle];
    [m_ListCell4 SetText:szText];
}

-(void)EnableCell1:(BOOL)bEnable
{
    m_ListCell1.hidden = !bEnable;
}

-(void)EnableCell2:(BOOL)bEnable
{
    m_ListCell2.hidden = !bEnable;
    
}

-(void)EnableCell3:(BOOL)bEnable
{
    m_ListCell3.hidden = !bEnable;
}

-(void)EnableCell4:(BOOL)bEnable
{
    m_ListCell4.hidden = !bEnable;
}


@end
