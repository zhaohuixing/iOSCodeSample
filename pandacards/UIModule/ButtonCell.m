//
//  ButttonCell.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ButtonCell.h"
#include "drawhelper.h"
#import "GUIEventLoop.h"


@implementation ButtonCell

- (void)OnButtonClick
{
    [GUIEventLoop SendEvent:m_nCtrlID eventSender:self];
}

- (id)initWithFrame:(CGRect)frame withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage
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
		m_Text.font = [UIFont systemFontOfSize:16];
		[m_Text setText:@"test123"];
		[self addSubview:m_Text];
		[m_Text release];
        
        fDelta = frame.size.height/20.0;
        float fsize = frame.size.height-fDelta*8;
        innerRect = CGRectMake(frame.size.width - fsize*1.3, fDelta*4, fsize, fsize);
		m_Button = [[[UIButton alloc] initWithFrame:innerRect] autorelease];
		m_Button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_Button setBackgroundImage:[UIImage imageNamed:szImage] forState:UIControlStateNormal];
		[m_Button setBackgroundImage:[UIImage imageNamed:szHLImage] forState:UIControlStateHighlighted];
		[m_Button addTarget:self action:@selector(OnButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_Button];
        
        m_nCtrlID = 0;
        
    }
    return self;
}

-(void)RegisterControlID:(int)nID
{
    m_nCtrlID = nID;
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
}

-(id<ListCellDataTemplate>)GetCellData
{
    return nil;
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
    float fsize = frame.size.height-fDelta*8;
    CGRect innerRect = CGRectMake(frame.size.width - fsize*1.4, fDelta*4, fsize, fsize);
    [m_Button setFrame:innerRect];
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
