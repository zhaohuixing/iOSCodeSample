//
//  SwitchCell.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "SwitchCell.h"
#include "drawhelper.h"
#import "GUIEventLoop.h"

@implementation SwitchCell

- (void)OnSwitchChange:(id)sender
{
    [GUIEventLoop SendEvent:m_nCtrlID eventSender:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        float fDelta = frame.size.height/20.0;
        CGRect innerRect = CGRectMake(frame.size.height/2.0, fDelta, frame.size.width/2, frame.size.height-2.0*fDelta);
		m_Text = [[UILabel alloc] initWithFrame:innerRect];
		m_Text.backgroundColor = [UIColor clearColor];
		[m_Text setTextColor:[UIColor blackColor]];
        m_Text.highlightedTextColor = [UIColor grayColor];
        [m_Text setTextAlignment:NSTextAlignmentLeft];
        m_Text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Text.adjustsFontSizeToFitWidth = YES;
		m_Text.font = [UIFont systemFontOfSize:18];
		[m_Text setText:@"test123"];
		[self addSubview:m_Text];
        
        fDelta = frame.size.height/20.0;
		m_Switch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [m_Switch setCenter:CGPointMake(frame.size.width - 55, frame.size.height*0.5)];
		[m_Switch addTarget:self action:@selector(OnSwitchChange:) forControlEvents:UIControlEventValueChanged];        
        [m_Switch setNeedsLayout]; 
		[self addSubview:m_Switch];
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
    
}

-(enLISTCELLTYPE)GetListCellType
{
    return enLISTCELLTYPE_SWITCH;
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

-(void)SetFrame:(CGRect)rect
{
	[self setFrame:rect];
    [self setNeedsDisplay];
    [m_Switch setCenter:CGPointMake(rect.size.width - 55, rect.size.height*0.5)];
    [m_Switch setNeedsLayout]; 
}	

-(void)SetTitle:(NSString*)text
{
    [m_Text setText: text];
}

-(NSString*)GetTitle
{
    return m_Text.text;
}

-(void)SetSwitch:(BOOL)bOnOff
{
    [m_Switch setOn:bOnOff];
}

-(BOOL)GetSwitchOnOff
{
    return [m_Switch isOn];
}


@end
