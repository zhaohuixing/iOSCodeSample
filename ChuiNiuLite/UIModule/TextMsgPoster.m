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
        
        float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
        float archorSize = self.frame.size.width*[GUILayout GetTMSViewAchorRatio];
        float sendbtnWidth = [GUILayout GetTMSButtonWidth];
        float sendbtnHeight = [GUILayout GetTMSButtonHeight];
        
        float width = self.frame.size.width-2.0*roundSize;
        float height = self.frame.size.height-2.0*roundSize-archorSize-sendbtnHeight-4;
        
        float sx = roundSize;
        float sy = roundSize+archorSize;
        CGRect rect = CGRectMake(sx, sy, width, height);
        
		m_MessageEditor = [[UITextView alloc] initWithFrame:rect];
		[m_MessageEditor setAutocorrectionType:UITextAutocorrectionTypeNo];
		[m_MessageEditor setEditable:YES];
		m_MessageEditor.backgroundColor = [UIColor whiteColor];
		m_MessageEditor.font = [UIFont fontWithName:@"Georgia" size:10];
		m_MessageEditor.delegate = self;
		[self addSubview:m_MessageEditor];
		[m_MessageEditor release];
    
        
        
        sx = self.frame.size.width - sendbtnWidth - roundSize;
        sy = self.frame.size.height - sendbtnHeight - roundSize;
        rect = CGRectMake(sx, sy, width, height);
		m_SendButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_SendButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_SendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_SendButton setBackgroundImage:[UIImage imageNamed:@"txtsendicon.png"] forState:UIControlStateNormal];
		[m_SendButton addTarget:self action:@selector(SendButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_SendButton];
        
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
- (void)drawBackGroundFromTop:(CGRect)rect
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
    CGContextAddLineToPoint(context, m_AchorPoint.x-archorSize*0.5, archorSize);
    CGContextAddLineToPoint(context, m_AchorPoint.x+archorSize*0.5, archorSize);
    CGContextAddLineToPoint(context, m_AchorPoint.x, m_AchorPoint.y);
    CGContextClosePath(context);
	//CGContextClip(context);
    CGContextFillPath(context);    
    CGContextRestoreGState(context);
    
    CGRect innerRect = CGRectMake(0, archorSize, rect.size.width, rect.size.height-archorSize);
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

- (void)drawBackGroundFromBottom:(CGRect)rect
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
    CGContextAddLineToPoint(context, m_AchorPoint.x-archorSize*0.5, rect.size.height - archorSize);
    CGContextAddLineToPoint(context, m_AchorPoint.x+archorSize*0.5, rect.size.height - archorSize);
    CGContextAddLineToPoint(context, m_AchorPoint.x, m_AchorPoint.y);
    CGContextClosePath(context);
	//CGContextClip(context);
    CGContextFillPath(context);    
    CGContextRestoreGState(context);
    
    CGRect innerRect = CGRectMake(0, 0, rect.size.width, rect.size.height-archorSize);
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
    if(m_AchorPoint.y == 0.0)
        [self drawBackGroundFromTop:rect];
    else
        [self drawBackGroundFromBottom:rect];
}

-(void)UpdateViewLayoutByTop
{
    float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    float archorSize = self.frame.size.width*[GUILayout GetTMSViewAchorRatio];
    float sendbtnWidth = [GUILayout GetTMSButtonWidth];
    float sendbtnHeight = [GUILayout GetTMSButtonHeight];
    
    float width = self.frame.size.width-roundSize;
    float height = self.frame.size.height-roundSize-archorSize-sendbtnHeight-4;

    float sx = roundSize*0.5;
    float sy = roundSize*0.5+archorSize;
    CGRect rect = CGRectMake(sx, sy, width, height);
    
    [m_MessageEditor setFrame:rect];

    sx = self.frame.size.width - sendbtnWidth - roundSize*0.5;
    sy = self.frame.size.height - sendbtnHeight - roundSize*0.5;
    rect = CGRectMake(sx, sy, sendbtnWidth, sendbtnHeight);
    [m_SendButton setFrame:rect];
}

-(void)UpdateViewLayoutByBottom
{
    float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    float archorSize = self.frame.size.width*[GUILayout GetTMSViewAchorRatio];
    float sendbtnWidth = [GUILayout GetTMSButtonWidth];
    float sendbtnHeight = [GUILayout GetTMSButtonHeight];
    
    float width = self.frame.size.width-roundSize;
    float height = self.frame.size.height-roundSize-archorSize-sendbtnHeight-4;

    float sx = roundSize*0.5;
    float sy = roundSize*0.5;
    CGRect rect = CGRectMake(sx, sy, width, height);
    
    [m_MessageEditor setFrame:rect];
    
    sx = self.frame.size.width - sendbtnWidth - roundSize*0.5;
    sy = self.frame.size.height - sendbtnHeight - roundSize*0.5-archorSize;
    rect = CGRectMake(sx, sy, sendbtnWidth, sendbtnHeight);
    [m_SendButton setFrame:rect];
    
}

-(void)UpdateViewLayout
{
    if(m_AchorPoint.y == 0.0)
        [self UpdateViewLayoutByTop];
    else
        [self UpdateViewLayoutByBottom];
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

@end


