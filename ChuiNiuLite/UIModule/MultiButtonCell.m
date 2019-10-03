//
//  MultiButtonCell.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiButtonCell.h"
#include "drawhelper.h"
#import "GUIEventLoop.h"


@implementation MultiButtonCell

@synthesize			m_DataStorage;

- (void)OnButtonClick1
{
    [GUIEventLoop SendEvent:m_nCtrlID1 eventSender:self];
}

- (void)OnButtonClick2
{
    [GUIEventLoop SendEvent:m_nCtrlID2 eventSender:self];
}

- (void)OnButtonClick3
{
    [GUIEventLoop SendEvent:m_nCtrlID3 eventSender:self];
}

- (void)OnButtonClick4
{
    [GUIEventLoop SendEvent:m_nCtrlID4 eventSender:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        float fDelta = frame.size.height/20.0;
        CGRect innerRect = CGRectMake(frame.size.height/2.0, fDelta, frame.size.width*0.75, frame.size.height-2.0*fDelta);
		m_Text = [[UILabel alloc] initWithFrame:innerRect];
		m_Text.backgroundColor = [UIColor clearColor];
		[m_Text setTextColor:[UIColor blackColor]];
        m_Text.highlightedTextColor = [UIColor grayColor];
        [m_Text setTextAlignment:UITextAlignmentLeft];
        m_Text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Text.adjustsFontSizeToFitWidth = YES;
		m_Text.font = [UIFont systemFontOfSize:18];
		[m_Text setText:@"test123"];
		[self addSubview:m_Text];
		[m_Text release];
        
        fDelta = frame.size.height/20.0;
        float sx = frame.size.width - frame.size.height;
        float sy = fDelta*4;
        float w = frame.size.height-fDelta*8;
        float h = w;
        innerRect = CGRectMake(sx, sy, w, h);
		m_Button1 = [[UIButton alloc] initWithFrame:innerRect];
		m_Button1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_Button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_Button1 addTarget:self action:@selector(OnButtonClick1) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_Button1];

        sx -= w;
        innerRect = CGRectMake(sx, sy, w, h);
		m_Button2 = [[UIButton alloc] initWithFrame:innerRect];
		m_Button2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_Button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[m_Button2 addTarget:self action:@selector(OnButtonClick2) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_Button2];

        sx -= w;
        innerRect = CGRectMake(sx, sy, w, h);
		m_Button3 = [[UIButton alloc] initWithFrame:innerRect];
		m_Button3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_Button3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[m_Button3 addTarget:self action:@selector(OnButtonClick3) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_Button3];

        sx -= w;
        innerRect = CGRectMake(sx, sy, w, h);
		m_Button4 = [[UIButton alloc] initWithFrame:innerRect];
		m_Button4.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_Button4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[m_Button4 addTarget:self action:@selector(OnButtonClick4) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_Button4];
        
        m_nCtrlID1 = 0;
        m_nCtrlID2 = 0;
        m_nCtrlID3 = 0;
        m_nCtrlID4 = 0;
        
        m_DataStorage = nil;
        
    }
    return self;
}

- (void)RegisterButtonResouce1:(int)nID withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage
{
    m_nCtrlID1 = nID;
    [m_Button1 setBackgroundImage:[UIImage imageNamed:szImage] forState:UIControlStateNormal];
    [m_Button1 setBackgroundImage:[UIImage imageNamed:szHLImage] forState:UIControlStateHighlighted];
}

- (void)RegisterButtonResouce2:(int)nID withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage
{
    m_nCtrlID2 = nID;
    [m_Button2 setBackgroundImage:[UIImage imageNamed:szImage] forState:UIControlStateNormal];
    [m_Button2 setBackgroundImage:[UIImage imageNamed:szHLImage] forState:UIControlStateHighlighted];
}

- (void)RegisterButtonResouce3:(int)nID withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage
{
    m_nCtrlID3 = nID;
    [m_Button3 setBackgroundImage:[UIImage imageNamed:szImage] forState:UIControlStateNormal];
    [m_Button3 setBackgroundImage:[UIImage imageNamed:szHLImage] forState:UIControlStateHighlighted];
}

- (void)RegisterButtonResouce4:(int)nID withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage
{
    m_nCtrlID4 = nID;
    [m_Button4 setBackgroundImage:[UIImage imageNamed:szImage] forState:UIControlStateNormal];
    [m_Button4 setBackgroundImage:[UIImage imageNamed:szHLImage] forState:UIControlStateHighlighted];
}

- (void)SetButton1Enable:(BOOL)bEnable
{
    m_Button1.hidden = (!bEnable);
}

- (void)SetButton2Enable:(BOOL)bEnable
{
    m_Button2.hidden = (!bEnable);
}

- (void)SetButton3Enable:(BOOL)bEnable
{
    m_Button3.hidden = (!bEnable);
}

- (void)SetButton4Enable:(BOOL)bEnable
{
    m_Button4.hidden = (!bEnable);
}

- (BOOL)GetButton1Enable
{
    BOOL bRet = (m_Button1.hidden == NO);
    
    return bRet;
}

- (BOOL)GetButton2Enable
{
    BOOL bRet = (m_Button2.hidden == NO);
    
    return bRet;
}

- (BOOL)GetButton3Enable
{
    BOOL bRet = (m_Button3.hidden == NO);
    
    return bRet;
}

- (BOOL)GetButton4Enable
{
    BOOL bRet = (m_Button4.hidden == NO);
    
    return bRet;
}

- (void)DrawBackGround:(CGContextRef)context inRect:(CGRect)rect
{
    float fDelta = rect.size.height/20.0;
    CGRect innerRect = CGRectMake(rect.origin.x+fDelta, rect.origin.y+fDelta, rect.size.width-2*fDelta, rect.size.height-2.0*fDelta);
    
    CGContextSaveGState(context);
    float fR = innerRect.size.height;
    AddRoundRectToPath(context, innerRect, CGSizeMake(fR, fR), 0.5);
    
	CGContextClip(context);
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
    float c1 = 1.0;
    float c2 = 0.9;    
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = innerRect.origin.x;
	pt1.y = innerRect.origin.y;
	pt2.x = pt1.x;//innerRect.origin.x+innerRect.size.width;
	pt2.y = innerRect.origin.y+innerRect.size.height;
    CGFloat colors[8] = {c1, c1, c1, 1.0, c2, c2, c2, 1.0};
    gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
    
    CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
	[self DrawBackGround:context inRect: rect];
}

- (void)dealloc
{
    [super dealloc];
}

-(enLISTCELLTYPE)GetListCellType
{
    return enLISTCELLTYPE_BUTTON;
}

-(BOOL)IsSelectable
{
	return NO;
}

-(void)SetSelectable:(BOOL)bSelectable
{
}

-(void)SetSelectionState:(BOOL)bSelected
{
}

-(BOOL)GetSelectionState
{
	return NO; 
}

-(BOOL)HasCheckBox
{
    return YES; 
}

-(void)SetCheckBoxState:(BOOL)bChecked
{
}

-(BOOL)GetCheckBoxState
{
    return NO;
}

-(BOOL)HasSwitch
{
    return YES; 
}
-(BOOL)GetSwitchState
{
    return YES;
}

-(void)SetCellData:(id<ListCellDataTemplate>)data
{
	if(m_DataStorage != nil)
		[m_DataStorage Destroy];
	
    m_DataStorage = data;
}

-(id<ListCellDataTemplate>)GetCellData
{
	return m_DataStorage;
}	

-(float)GetCellHeight
{
    return self.frame.size.height;
}

-(void)OffsetYCell:(float)Y
{
	CGRect rect = self.frame;
	rect.origin.y += Y;
	[self setFrame:rect];
	[self setNeedsDisplay];
}	

-(CGRect)GetFrame
{
	return self.frame;
}

-(void)SetFrame:(CGRect)frame
{
	[self setFrame:frame];
    [self setNeedsDisplay];
    float fDelta = frame.size.height/20.0;

    float sx = frame.size.width - frame.size.height;
    float sy = fDelta*4;
    float w = frame.size.height-fDelta*8;
    float h = w;
    CGRect innerRect = CGRectMake(sx, sy, w, h);
    [m_Button1 setFrame:innerRect];
    
    sx -= w;
    innerRect = CGRectMake(sx, sy, w, h);
    [m_Button2 setFrame:innerRect];
    
    sx -= w;
    innerRect = CGRectMake(sx, sy, w, h);
    [m_Button3 setFrame:innerRect];
    
    sx -= w;
    innerRect = CGRectMake(sx, sy, w, h);
    [m_Button4 setFrame:innerRect];
}	

-(void)SetTitle:(NSString*)text
{
    [m_Text setText: text];
}

-(NSString*)GetTitle
{
    return m_Text.text;
}


@end
