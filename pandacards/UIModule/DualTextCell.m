//
//  DualTextCell.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DualTextCell.h"
#import "drawhelper.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#import "ApplicationConfigure.h"
#import "ImageLoader.h"

@implementation DualTextCell

@synthesize			m_DataStorage;

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)SetTitleAlignment:(enCELLTEXTALIGNMENT)alignment
{
    switch(alignment)
    {
        case enCELLTEXTALIGNMENT_LEFT:
            [m_Title setTextAlignment:UITextAlignmentLeft];
            break;
        case enCELLTEXTALIGNMENT_CENTER:
            [m_Title setTextAlignment:UITextAlignmentCenter];
            break;
        case enCELLTEXTALIGNMENT_RIGHT:
            [m_Title setTextAlignment:UITextAlignmentRight];
            break;
    }        
}

-(void)SetTextAlignment:(enCELLTEXTALIGNMENT)alignment
{
    switch(alignment)
    {
        case enCELLTEXTALIGNMENT_LEFT:
            [m_Text setTextAlignment:UITextAlignmentLeft];
            //m_Text.baselineAdjustment = UIBaselineAdjustmentNone;
            break;
        case enCELLTEXTALIGNMENT_CENTER:
            [m_Text setTextAlignment:UITextAlignmentCenter];
            //m_Text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            break;
        case enCELLTEXTALIGNMENT_RIGHT:
            [m_Text setTextAlignment:UITextAlignmentRight];
            //m_Text.baselineAdjustment = UIBaselineAdjustmentNone;
            break;
    }        
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_bSelectable = NO;
        m_bSelected = NO;
        m_DataStorage = nil;
        
        float fDelta = frame.size.height/20.0;
        float fTextLength = frame.size.width-frame.size.height;
        CGRect innerRect = CGRectMake(frame.size.height/2.0, fDelta, fTextLength*0.6, frame.size.height-2.0*fDelta);
		m_Title = [[UILabel alloc] initWithFrame:innerRect];
		m_Title.backgroundColor = [UIColor clearColor];
		[m_Title setTextColor:[UIColor blackColor]];
        m_Title.highlightedTextColor = [UIColor grayColor];
        [m_Title setTextAlignment:UITextAlignmentLeft];
        m_Title.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Title.adjustsFontSizeToFitWidth = YES;
		m_Title.font = [UIFont fontWithName:@"Georgia" size:18];
		[m_Title setText:@"test123"];
		[self addSubview:m_Title];
		[m_Title release];
        
        innerRect = CGRectMake(frame.size.height/2.0+fTextLength*0.6, fDelta, fTextLength*0.4, frame.size.height-2.0*fDelta);
		m_Text = [[UILabel alloc] initWithFrame:innerRect];
		m_Text.backgroundColor = [UIColor clearColor];
		[m_Text setTextColor:[UIColor blackColor]];
        m_Text.highlightedTextColor = [UIColor grayColor];
        [m_Text setTextAlignment:UITextAlignmentRight];
        m_Text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Text.adjustsFontSizeToFitWidth = YES;
		m_Text.font = [UIFont fontWithName:@"Georgia" size:16];//[UIFont systemFontOfSize:16];
		[m_Text setText:@"test123"];
		[self addSubview:m_Text];
		[m_Text release];
        m_bLongerText = NO;
        m_Icon = NULL;
        
    }
    return self;
}

- (id)initWithResource:(NSString*)icon withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_bSelectable = NO;
        m_bSelected = NO;
        m_DataStorage = nil;
       
        float fDelta = frame.size.height/20.0;
        float fTextLength = frame.size.width-frame.size.height;
        CGRect innerRect = CGRectMake(frame.size.height/2.0, fDelta, fTextLength*0.70, frame.size.height-2.0*fDelta);
		m_Title = [[UILabel alloc] initWithFrame:innerRect];
		m_Title.backgroundColor = [UIColor clearColor];
		[m_Title setTextColor:[UIColor blackColor]];
        m_Title.highlightedTextColor = [UIColor grayColor];
        [m_Title setTextAlignment:UITextAlignmentLeft];
        m_Title.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Title.adjustsFontSizeToFitWidth = YES;
		m_Title.font = [UIFont fontWithName:@"Georgia" size:18];
		[m_Title setText:@"test123"];
		[self addSubview:m_Title];
		[m_Title release];
        
        innerRect = CGRectMake(frame.size.height/2.0+fTextLength*0.70, fDelta, fTextLength*0.30, frame.size.height-2.0*fDelta);
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
        
        
        float fSize = frame.size.height-2.0*fDelta;
		
		m_Icon = [ImageLoader LoadImageWithName:icon];
        
        CGRect rt = m_Title.frame;
        rt.size.width -= fSize;
        rt.origin.x += fSize;
        [m_Title setFrame:rt];
    }
    return self;
}

- (id)initWithImage:(CGImageRef)image withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_bSelectable = NO;
        m_bSelected = NO;
        m_DataStorage = nil;
        
        float fDelta = frame.size.height/20.0;
        float fTextLength = frame.size.width-frame.size.height;
        CGRect innerRect = CGRectMake(frame.size.height/2.0, fDelta, fTextLength*0.70, frame.size.height-2.0*fDelta);
		m_Title = [[UILabel alloc] initWithFrame:innerRect];
		m_Title.backgroundColor = [UIColor clearColor];
		[m_Title setTextColor:[UIColor blackColor]];
        m_Title.highlightedTextColor = [UIColor grayColor];
        [m_Title setTextAlignment:UITextAlignmentLeft];
        m_Title.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Title.adjustsFontSizeToFitWidth = YES;
		m_Title.font = [UIFont fontWithName:@"Georgia" size:18];
		[m_Title setText:@"test123"];
		[self addSubview:m_Title];
		[m_Title release];
        
        innerRect = CGRectMake(frame.size.height/2.0+fTextLength*0.70, fDelta, fTextLength*0.30, frame.size.height-2.0*fDelta);
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
        
        
        float fSize = frame.size.height-2.0*fDelta;
		
		m_Icon = image;
        
        CGRect rt = m_Title.frame;
        rt.size.width -= fSize;
        rt.origin.x += fSize;
        [m_Title setFrame:rt];
    }
    return self;
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
	
    float c1 = 0.95;
    float c2 = 0.7;    
	
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
        //CGFloat colors[8] = {c1, c1, c1, 1.0, c2, c2, c2, 1.0};
        CGFloat colors[8] = {c1*0.6, c1+0.05, c1*0.6, 1.0, c2*0.5, c2, c2*0.5, 1.0};
        
        gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
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
    CGContextSaveGState(context);
    CGContextDrawImage(context, rt, m_Icon);
    CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
	[self DrawBackGround:context inRect: rect];
    if(m_Icon)
    {
        [self DrawIcon:context inRect:rect];
    }
}

- (void)dealloc
{
    if(m_DataStorage)
        [m_DataStorage Destroy];
    
    if(m_Icon)    
        CGImageRelease(m_Icon);
    
    [super dealloc];
}

-(enLISTCELLTYPE)GetListCellType
{
    return enLISTCELLTYPE_BASIC;
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
    return NO; 
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
    return NO; 
}
-(BOOL)GetSwitchState
{
    return NO;
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

-(void)SetLongerText
{
    m_bLongerText = YES;
    CGRect rect = self.frame;
    [self SetFrame:rect];
}

-(void)SetFrame:(CGRect)rect
{
	[self setFrame:rect];
    
    if(m_Icon == nil)
    {    
        float fTextLength = self.frame.size.width-self.frame.size.height;
        CGRect rt = m_Title.frame;
        if(!m_bLongerText)
            rt.size.width = fTextLength*0.6;
        else
            rt.size.width = fTextLength*0.3;
        [m_Title setFrame:rt];
        
        rt = m_Text.frame;
        if(!m_bLongerText)
        {    
            rt.origin.x = m_Title.frame.origin.x + fTextLength*0.6;
            rt.size.width = fTextLength*0.4;
        } 
        else
        {
            rt.origin.x = m_Title.frame.origin.x + fTextLength*0.3;
            rt.size.width = fTextLength*0.7;
        }
        [m_Text setFrame:rt];
    }
    else
    {
        CGRect rt = m_Title.frame;
        float fDelta = rect.size.height/20.0;
        float fSize = rect.size.height-2.0*fDelta;
        float fTextLength = self.frame.size.width-self.frame.size.height;
        if(!m_bLongerText)
            rt.size.width = fTextLength*0.70-fSize;
        else
            rt.size.width = fTextLength*0.30-fSize;
        [m_Title setFrame:rt];
        
        rt = m_Text.frame;
        if(!m_bLongerText)
        {    
            rt.origin.x = m_Title.frame.origin.x + fTextLength*0.70-fSize;
            rt.size.width = fTextLength*0.30;
        }
        else
        {
            rt.origin.x = m_Title.frame.origin.x + fTextLength*0.30-fSize;
            rt.size.width = fTextLength*0.70;
        }
        [m_Text setFrame:rt];
        
    }
    
    [self setNeedsDisplay];
}	

- (void)UnSelectPeersCells
{
    if([self.superview respondsToSelector:@selector(OnUnSelectAllCells:)])
    {
        [self.superview performSelector:@selector(OnUnSelectAllCells:) withObject:self]; 
        //[self.superview OnUnSelectAllCells:self]; 
    }
}

- (void)SelectMe
{
    if([self.superview respondsToSelector:@selector(OnCellSelectedEvent:)])
    {
        [self.superview performSelector:@selector(OnCellSelectedEvent:) withObject:self]; 
        //[self.superview OnCellSelectedEvent:self]; 
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

-(void)SetTitle:(NSString*)text
{
    [m_Title setText: text];
}

-(NSString*)GetTitle
{
    return m_Title.text;
}

-(void)SetText:(NSString*)text
{
    [m_Text setText:text];
}

-(NSString*)GetText
{
    return m_Text.text;
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
