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


@implementation DualTextCell

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
            break;
        case enCELLTEXTALIGNMENT_CENTER:
            [m_Text setTextAlignment:UITextAlignmentCenter];
            break;
        case enCELLTEXTALIGNMENT_RIGHT:
            [m_Text setTextAlignment:UITextAlignmentRight];
            break;
    }        
}

-(void)SetTitleFontSize:(float)fSize
{
    m_Title.font = [UIFont fontWithName:@"Georgia" size:fSize];
}

-(void)SetTextFontSize:(float)fSize
{
    m_Text.font = [UIFont systemFontOfSize:fSize];
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
        
        float fDelta = frame.size.height/20.0;
        CGRect innerRect = CGRectMake(frame.size.height/2.0, fDelta, frame.size.width*0.75, frame.size.height-2.0*fDelta);
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
        
        innerRect = CGRectMake(frame.size.width*0.75, fDelta, frame.size.width*0.25, frame.size.height-2.0*fDelta);
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
        m_bAsSingleCell = NO;
        m_Icon = nil;
        
    }
    return self;
}

- (id)initWithResource:(NSString*)icon withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_bSelectable = NO;
        m_bSelected = NO;
        
        float fDelta = frame.size.height/20.0;
        CGRect innerRect = CGRectMake(frame.size.height/2.0, fDelta, frame.size.width*0.70, frame.size.height-2.0*fDelta);
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
        
        innerRect = CGRectMake(frame.size.width*0.70, fDelta, frame.size.width*0.30, frame.size.height-2.0*fDelta);
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
        innerRect = CGRectMake(frame.size.height/2.0, fDelta, fSize, fSize);
		UIImage* iconImage = [UIImage imageNamed:icon];
		
		m_Icon = [[UIImageView alloc] initWithImage:iconImage];
		[m_Icon setFrame:innerRect];
		[self addSubview:m_Icon];
        
        CGRect rt = m_Title.frame;
        rt.size.width -= fSize;
        rt.origin.x += fSize;
        [m_Title setFrame:rt];
        
        m_bAsSingleCell = NO;
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
        CGFloat colors[8] = {c1, c1, c1, 1.0, c2, c2, c2, 1.0};
        gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    }
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
    if(m_Icon != nil)    
        [m_Icon release];
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

-(void)AdjustAsSingleCell
{
    CGRect rect = m_Title.frame;
    if(m_Icon == nil)
    {    
        CGRect rt = m_Title.frame;
        rt.size.width = rect.size.width;
        [m_Title setFrame:rt];
        
        rt = m_Text.frame;
        rt.origin.x = m_Title.frame.origin.x + rect.size.width;
        rt.size.width = 0;
        rt.size.height = 0;
        [m_Text setFrame:rt];
    }
    else
    {
        CGRect rt = m_Title.frame;
        float fDelta = rect.size.height/20.0;
        float fSize = rect.size.height-2.0*fDelta;
        
        rt.size.width = rect.size.width-fSize;
        [m_Title setFrame:rt];
        
        rt = m_Text.frame;
        rt.origin.x = m_Title.frame.origin.x + rect.size.width-fSize;
        rt.size.width = 0;
        rt.size.height = 0;
        [m_Text setFrame:rt];
    }
}

-(void)SetFrame:(CGRect)rect
{
	[self setFrame:rect];
    
    if(m_Icon == nil)
    {    
        CGRect rt = m_Title.frame;
        rt.size.width = rect.size.width*0.75;
        [m_Title setFrame:rt];
        
        rt = m_Text.frame;
        rt.origin.x = m_Title.frame.origin.x + rect.size.width*0.75;
        rt.size.width = rect.size.width*0.25;
        [m_Text setFrame:rt];
    }
    else
    {
        CGRect rt = m_Title.frame;
        float fDelta = rect.size.height/20.0;
        float fSize = rect.size.height-2.0*fDelta;
        
        rt.size.width = rect.size.width*0.70-fSize;
        [m_Title setFrame:rt];
        
        rt = m_Text.frame;
        rt.origin.x = m_Title.frame.origin.x + rect.size.width*0.70-fSize;
        rt.size.width = rect.size.width*0.30;
        [m_Text setFrame:rt];
        
    }
    
    if(m_bAsSingleCell == YES)
        [self AdjustAsSingleCell];
    
    [self setNeedsDisplay];
}	

- (void)UnSelectPeersCells
{
    if([self.superview respondsToSelector:@selector(OnUnSelectAllCells:)])
    {
        [self.superview OnUnSelectAllCells:self]; 
    }
}

- (void)SelectMe
{
    if([self.superview respondsToSelector:@selector(OnCellSelectedEvent:)])
    {
        [self.superview OnCellSelectedEvent:self]; 
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

-(void)SetAsSingleSingle
{
    m_bAsSingleCell = YES;
    [self AdjustAsSingleCell];
}

@end
