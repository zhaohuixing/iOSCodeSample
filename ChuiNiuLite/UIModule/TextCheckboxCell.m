//
//  TextCheckboxCell.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "TextCheckboxCell.h"
#import "drawhelper.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"

@implementation TextCheckboxCell

@synthesize			m_Data;

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_bSelectable = YES;
        m_bSelected = NO;
        m_Data = nil;
        
        float fDelta = frame.size.height/20.0;
        CGRect innerRect = CGRectMake(frame.size.height/2.0, fDelta, frame.size.width*0.7, frame.size.height-2.0*fDelta);
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
      
        UIImage* checkerImage = [UIImage imageNamed:@"checkmark.png"];
        m_CheckBox = [[UIImageView alloc] initWithImage:checkerImage];
        innerRect = CGRectMake(frame.size.width - frame.size.height*1.5, 0, frame.size.height, frame.size.height);
        [m_CheckBox setFrame:innerRect];
        [self addSubview:m_CheckBox];
        [m_CheckBox release];
        m_CheckBox.hidden = YES;
        m_CheckBoxToggleabel = NO;
        
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
        self.backgroundColor = [UIColor clearColor];
        m_bSelectable = YES;
        m_bSelected = NO;
        m_Data = nil;
        
        float fDelta = frame.size.height/20.0;
        CGRect innerRect = CGRectMake(frame.size.height/2.0, fDelta, frame.size.width*0.7, frame.size.height-2.0*fDelta);
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
        
        UIImage* checkerImage = [UIImage imageNamed:@"checkmark.png"];
        m_CheckBox = [[UIImageView alloc] initWithImage:checkerImage];
        innerRect = CGRectMake(frame.size.width - frame.size.height*1.5, 0, frame.size.height, frame.size.height);
        [m_CheckBox setFrame:innerRect];
        [self addSubview:m_CheckBox];
        [m_CheckBox release];
        m_CheckBox.hidden = YES;
        m_CheckBoxToggleabel = NO;
        
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
    if(m_Data != nil)
    {
        [m_Data Destroy];
    }
    [super dealloc];
}

-(enLISTCELLTYPE)GetListCellType
{
    return enLISTCELLTYPE_CHECKBOX;
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
    m_CheckBox.hidden = !bChecked;
}

-(BOOL)GetCheckBoxState
{
    return !(m_CheckBox.hidden);
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
    m_Data = data;
}

-(id<ListCellDataTemplate>)GetCellData
{
    return m_Data;
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
    
    CGRect innerRect = CGRectMake(rect.size.width - rect.size.height*1.5, 0, rect.size.height, rect.size.height);
    [m_CheckBox setFrame:innerRect];
    
    [self setNeedsDisplay];
}	

- (void)UnCheckPeersCheckBox
{
    if([self.superview respondsToSelector:@selector(OnUnCheckAllCells:)])
    {
        [self.superview OnUnCheckAllCells:self]; 
    }
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
        [self UnCheckPeersCheckBox];
        if(m_CheckBoxToggleabel == NO)
        {    
            [self SetCheckBoxState:YES];
        }
        else
        {
            BOOL bChecked = [self GetCheckBoxState];
            [self SetCheckBoxState:!bChecked];
        }
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

-(void)SetToggleable:(BOOL)bToggle
{
    m_CheckBoxToggleabel = bToggle;
}

@end
