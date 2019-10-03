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

@implementation TextMsgDisplay

-(void)OnClose
{
    if(m_Parent)
        [m_Parent OnMsgBoardClose];
}

-(void)CloseButtonClick
{
    self.hidden = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnClose:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
    [UIView commitAnimations];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_AchorPoint = CGPointMake(frame.size.width, frame.size.height*0.3);
        
        float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
        float archorSize = self.frame.size.width*[GUILayout GetTMSViewAchorRatio];
        float btnSize = [GUILayout GetCloseButtonSize];
        
        float width = self.frame.size.width-2.0*roundSize-archorSize;
        float height = self.frame.size.height-2.0*roundSize-btnSize-4;
        
        float sx = roundSize+archorSize;
        float sy = roundSize;
        CGRect rect = CGRectMake(sx, sy, width, height);
        
		m_MessageBoard = [[UITextView alloc] initWithFrame:rect];
		[m_MessageBoard setAutocorrectionType:UITextAutocorrectionTypeNo];
		[m_MessageBoard setEditable:NO];
		m_MessageBoard.backgroundColor = [UIColor whiteColor];
		m_MessageBoard.font = [UIFont fontWithName:@"Georgia" size:10];
		m_MessageBoard.delegate = self;
		[self addSubview:m_MessageBoard];
		[m_MessageBoard release];
    
        
        
        sx = self.frame.size.width - btnSize - roundSize;
        sy = self.frame.size.height - btnSize - roundSize;
        rect = CGRectMake(sx, sy, width, height);
		m_CloseButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_CloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_CloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_CloseButton setBackgroundImage:[UIImage imageNamed:@"closeicon.png"] forState:UIControlStateNormal];
		[m_CloseButton addTarget:self action:@selector(CloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_CloseButton];
        
        m_Parent = nil;
        
        [self UpdateViewLayout];
    }
    return self;
}

-(void)RegisterParent:(id<TextMsgBoardDelegate>)parent
{
    m_Parent = parent;
}

-(void)SetAchorAtLeft:(float)fPostion
{
    m_AchorPoint = CGPointMake(0, self.frame.size.height*fPostion);
    [self UpdateViewLayout];
}

-(void)SetAchorAtRight:(float)fPostion
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
    float clr1[] = {0.9, 0.9, 0.9, 1.0};

    float clrg[8] = {0.9, 0.9, 0.9, 1.0, 0.4, 0.4, 0.4, 1.0};
    
    float archorSize = self.frame.size.width*[GUILayout GetTMSViewAchorRatio];
   
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
    float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    
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
    
    float clr1[] = {0.4, 0.4, 0.4, 1.0};
    
    float clrg[8] = {0.9, 0.9, 0.9, 1.0, 0.4, 0.4, 0.4, 1.0};
    
    float archorSize = self.frame.size.width*[GUILayout GetTMSViewAchorRatio];
    
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
    float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    
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
    float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    float archorSize = self.frame.size.width*[GUILayout GetTMSViewAchorRatio];
    float btnSize = [GUILayout GetCloseButtonSize];
    
    float width = self.frame.size.width-roundSize-archorSize;
    float height = self.frame.size.height-roundSize-btnSize-4;

    float sx = roundSize*0.5+archorSize;
    float sy = roundSize*0.5;
    CGRect rect = CGRectMake(sx, sy, width, height);
    
    [m_MessageBoard setFrame:rect];

    sx = self.frame.size.width - btnSize - roundSize*0.5;
    sy = self.frame.size.height - btnSize - roundSize*0.5;
    rect = CGRectMake(sx, sy, btnSize, btnSize);
    [m_CloseButton setFrame:rect];
}

-(void)UpdateViewLayoutByRight
{
    float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    float archorSize = self.frame.size.width*[GUILayout GetTMSViewAchorRatio];
    float btnSize = [GUILayout GetCloseButtonSize];
    
    float width = self.frame.size.width-roundSize-archorSize;
    float height = self.frame.size.height-roundSize-btnSize-4;

    float sx = roundSize*0.5;
    float sy = roundSize*0.5;
    CGRect rect = CGRectMake(sx, sy, width, height);
    
    [m_MessageBoard setFrame:rect];
    
    sx = self.frame.size.width - btnSize - roundSize*0.5-archorSize;
    sy = self.frame.size.height - btnSize - roundSize*0.5;
    rect = CGRectMake(sx, sy, btnSize, btnSize);
    [m_CloseButton setFrame:rect];
}

-(void)UpdateViewLayout
{
    if(m_AchorPoint.x == 0.0)
        [self UpdateViewLayoutByLeft];
    else
        [self UpdateViewLayoutByRight];
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
