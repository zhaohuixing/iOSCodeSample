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
#import "ApplicationConfigure.h"
#include "drawhelper.h"
#import "DrawHelper2.h"


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
        m_AchorPoint = CGPointMake(frame.size.width*0.3, 0);
        
        float btnSize = [GUILayout GetCloseButtonSize];
        
        float fsize = [GUILayout GetDefaultAlertUIEdge]*2.0;
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
		[m_MessageBoard release];
    
        
        
        sx = self.frame.size.width - btnSize;
        sy = 0;
        rect = CGRectMake(sx, sy, btnSize, btnSize);
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

-(void)UpdateViewLayoutByTop
{
    float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    float archorSize = self.frame.size.height*[GUILayout GetTMSViewAchorRatio];
    float btnSize = [GUILayout GetCloseButtonSize];
    
    float width = self.frame.size.width-roundSize;
    float height = self.frame.size.height-roundSize-archorSize-btnSize-4;

    float sx = roundSize*0.5;
    float sy = roundSize*0.5+archorSize;
    CGRect rect = CGRectMake(sx, sy, width, height);
    
    [m_MessageBoard setFrame:rect];

    sx = self.frame.size.width - btnSize - roundSize*0.5;
    sy = self.frame.size.height - btnSize - roundSize*0.5;
    rect = CGRectMake(sx, sy, btnSize, btnSize);
    [m_CloseButton setFrame:rect];
}

-(void)UpdateViewLayoutByBottom
{
    float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
    float archorSize = self.frame.size.height*[GUILayout GetTMSViewAchorRatio];
    float btnSize = [GUILayout GetCloseButtonSize];
    
    float width = self.frame.size.width-roundSize;
    float height = self.frame.size.height-roundSize-archorSize-btnSize-4;

    float sx = roundSize*0.5;
    float sy = roundSize*0.5;
    CGRect rect = CGRectMake(sx, sy, width, height);
    
    [m_MessageBoard setFrame:rect];
    
    sx = self.frame.size.width - btnSize - roundSize*0.5;
    sy = self.frame.size.height - btnSize - roundSize*0.5-archorSize;
    rect = CGRectMake(sx, sy, btnSize, btnSize);
    [m_CloseButton setFrame:rect];
}

-(void)UpdateViewLayout
{
//    if(m_AchorPoint.y == 0.0)
//        [self UpdateViewLayoutByTop];
//    else
//        [self UpdateViewLayoutByBottom];
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
