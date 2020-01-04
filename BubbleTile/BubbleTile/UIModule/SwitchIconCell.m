//
//  SwitchIconCell.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "SwitchIconCell.h"
#include "drawhelper.h"
#import "GUIEventLoop.h"
#import "ImageLoader.h"

@implementation SwitchIconCell

@synthesize			m_DataStorage;

- (void)OnSwitchChange:(id)sender
{
    [GUIEventLoop SendEvent:m_nCtrlID eventSender:self];
    [self setNeedsDisplay];
}


- (id)initWithFrame:(CGRect)frame withImage:(NSString*)szImage withDisableImage:(NSString*)disableIcon
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_DataStorage = nil;
        
        /*UIImage* srcImage = [UIImage imageNamed:szImage];
        m_Icon = [[UIImageView alloc] initWithImage:srcImage];
        float h = frame.size.height*0.8;
        float w = h*0.92;
        float x = frame.size.height*0.2;
        float y = frame.size.height*0.1;
        CGRect innerRect = CGRectMake(x, y, w, h);
        [m_Icon setFrame:innerRect];
        [self addSubview:m_Icon];
        [m_Icon release];
        */
        m_IconEnableState = [ImageLoader LoadImageWithName:szImage];
        m_IconDisableState = [ImageLoader LoadImageWithName:disableIcon];
        
		m_Switch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [m_Switch setCenter:CGPointMake(frame.size.width - 55, frame.size.height*0.5)];
		[m_Switch addTarget:self action:@selector(OnSwitchChange:) forControlEvents:UIControlEventValueChanged];        
        [m_Switch setNeedsLayout]; 
		[self addSubview:m_Switch];
		[m_Switch release];
        m_nCtrlID = -1;
        m_bSelectable = NO;
        m_bSelected = NO;
        m_EventReciever = nil;
    }
    return self;
}

-(void)DisableSwitch
{
    m_Switch.enabled = NO;
}

-(void)RegisterControlID:(int)nID
{
    m_nCtrlID = nID;
}

-(void)RegisterControlEvent:(id)reciever withHandler:(SEL)handler;
{
    if(m_nCtrlID < 0)
        return;
    
    m_EventReciever = reciever;
    [GUIEventLoop RegisterEvent:m_nCtrlID eventHandler:handler eventReceiver:m_EventReciever eventSender:self];
}

-(int)GetControlID
{
    return m_nCtrlID;
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
    float c2 = 0.65;    
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = innerRect.origin.x;
	pt1.y = innerRect.origin.y;
	pt2.x = pt1.x;//innerRect.origin.x+innerRect.size.width;
	pt2.y = innerRect.origin.y+innerRect.size.height;
	if(m_bSelected)
    {    
        CGFloat colors[8] = {c1/2, c1/2, c1, 1.0, c2/2, c2/2, c2, 1.0};
        gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    }
    else
    {
        if(m_bSelectable)
        {
            CGFloat colors[8] = {c2, c1, c2, 1.0, c2/2.0, c2, c2/2.0, 1.0};
            gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
        }
        else
        {    
            CGFloat colors[8] = {c1, c1, c1, 1.0, c2, c2, c2, 1.0};
            gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
        }    
    }
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
    
    CGContextRestoreGState(context);
}

- (void)DrawIcon:(CGContextRef)context inRect:(CGRect)rect
{
    float fDelta = rect.size.height/20.0;
    float fR = rect.size.height-2.0*fDelta;
    float fSize = fR*0.9;
    float sx = rect.origin.x+fR/2.0;
    float sy = rect.origin.y+(rect.size.height-fSize)/2.0;
    CGRect rt = CGRectMake(sx, sy, fSize, fSize);
    if([self GetSwitchOnOff])
    {
        if(m_IconEnableState)
        {
            CGContextSaveGState(context);
            CGContextDrawImage(context, rt, m_IconEnableState);
            CGContextRestoreGState(context);
        }
    }
    else
    {
        if(m_IconDisableState)
        {
            CGContextSaveGState(context);
            CGContextDrawImage(context, rt, m_IconDisableState);
            CGContextRestoreGState(context);
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
	[self DrawBackGround:context inRect: rect];
    [self DrawIcon:context inRect:rect];
}

- (void)dealloc
{
    if(m_DataStorage)
    {
        [m_DataStorage Destroy];
    }
    if(m_IconEnableState)
    {
        CGImageRelease(m_IconEnableState);
    }
    if(m_IconDisableState)
    {
        CGImageRelease(m_IconDisableState);
    }
    
    if(0 <= m_nCtrlID && m_EventReciever != nil)
    {
        [GUIEventLoop RemoveEvent:m_nCtrlID eventReceiver:m_EventReciever eventSender:self];
    }
    
    [super dealloc];
}

-(enLISTCELLTYPE)GetListCellType
{
    return enLISTCELLTYPE_SWITCH;
}

-(BOOL)IsSelectable
{
	return m_bSelectable;
}

-(void)SetSelectable:(BOOL)bSelectable
{
	m_bSelectable = bSelectable;
}

-(void)SetSelectionState:(BOOL)bSelected
{
	if(m_bSelectable == YES)
	{	
		m_bSelected = bSelected;
		[self setNeedsDisplay];
	}	
}

-(BOOL)GetSelectionState
{
	if(m_bSelectable == YES)
		return m_bSelected;
	else
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
}

-(NSString*)GetTitle
{
    return @"";
}

-(void)SetSwitch:(BOOL)bOnOff
{
    [m_Switch setOn:bOnOff];
}

-(BOOL)GetSwitchOnOff
{
    return [m_Switch isOn];
}

- (void)UnSelectPeersCells
{
    if([self.superview respondsToSelector:@selector(OnUnSelectAllCells:)])
    {
        [self.superview performSelector:@selector(OnUnSelectAllCells:) withObject:self]; 
    }
}

- (void)SelectMe
{
    if([self.superview respondsToSelector:@selector(OnCellSelectedEvent:)])
    {
        [self.superview performSelector:@selector(OnCellSelectedEvent:) withObject:self]; 
    }
}


- (void) touchesBegan : (NSSet*)touches withEvent: (UIEvent*)event
{
	if(m_bSelectable == YES)
	{
        [self UnSelectPeersCells];
        [self SelectMe];
	}
	[self setNeedsDisplay];
}

-(void)SetCellData:(id<ListCellDataTemplate>)data
{
    if(m_DataStorage)
    {
        [m_DataStorage Destroy];
        m_DataStorage = nil;
    }
    m_DataStorage = data;
}

-(id<ListCellDataTemplate>)GetCellData
{
    return m_DataStorage;
}

@end
