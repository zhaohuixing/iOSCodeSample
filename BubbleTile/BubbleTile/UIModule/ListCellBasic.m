//
//  ListCellBasic.m
//  testscollview
//
//  Created by Zhaohui Xing on 10-12-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "ListCellBasic.h"
//#import "ImageHelper.h"
#import "drawhelper.h"
#import "GUILayout.h"
#import "ListConstants.h"
#import "GUIBasicConstant.h"
#import "GUIEventLoop.h"


@implementation ListCellBasic

@synthesize			m_bSelectable;
@synthesize			m_szTitle;
@synthesize			m_szDescription;
@synthesize			m_iconImage;
@synthesize			m_fHighlightAlpha;
@synthesize			m_fHighlightRed;
@synthesize			m_fHighlightGreen;
@synthesize			m_fHighlightBlue;
@synthesize			m_fOutlineAlpha;
@synthesize			m_fOutlineRed;
@synthesize			m_fOutlineGreen;
@synthesize			m_fOutlineBlue;
@synthesize			m_fFontSize;
@synthesize			m_DataStorage;


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		m_bSelectable = YES;
		m_DataStorage = nil;
		m_iconImage = NULL;

		m_szTitle = nil;
		m_szDescription = nil;
		m_iconImage = NULL;
		m_bSelected = NO;
		
		m_fHighlightAlpha = 0.5f;
		m_fHighlightRed = 0.0f;
		m_fHighlightGreen = 0.0f;
		m_fHighlightBlue = 1.0f;
		m_fOutlineAlpha = 0.5;
		m_fOutlineRed = 0.0;
		m_fOutlineGreen = 0.0;
		m_fOutlineBlue = 0.0;
		m_fFontSize = [GUILayout GetDefaultListCellHeight]/2.0;
		
		self.backgroundColor = [UIColor whiteColor];
	}
    return self;
}

- (void)drawIcon:(CGContextRef)context withRect:(CGRect)rect
{
	float x = rect.origin.x + [GUILayout GetDefaultListCellMargin];
	float y = rect.origin.y + [GUILayout GetDefaultListCellMargin];
	float h = rect.size.height - 2*[GUILayout GetDefaultListCellMargin];
	CGRect rt = CGRectMake(x, y, h, h);
	CGContextDrawImage(context, rt, m_iconImage);
}

- (void)drawText:(CGContextRef)context withRect:(CGRect)rect
{
	float x = 0;
	if(m_iconImage != NULL)
		x = rect.origin.x + rect.size.height;
	else
		x = rect.origin.x + [GUILayout GetDefaultListCellMargin];
	
	float fLength = (float)m_szTitle.length;
	
	UIFont* font = [UIFont systemFontOfSize:m_fFontSize];
	
	CGContextSaveGState(context);
	CGContextSetRGBFillColor(context, 0, 0, 0, 1);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
	
	float fCenterY = rect.origin.y+rect.size.height*0.5;	
	float y = fCenterY - m_fFontSize/2.0;	
	
	[m_szTitle drawInRect:CGRectMake(x, y, m_fFontSize*fLength*2, rect.size.height-[GUILayout GetDefaultListCellMargin]*2.0)
				 withFont:font];
	
	CGContextRestoreGState(context);
}

- (void)drawHighlight:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
	float colors[4] = {m_fHighlightRed, m_fHighlightGreen, m_fHighlightBlue, m_fHighlightAlpha};
	CGContextSetFillColor(context, colors);
	CGContextFillRect(context, rect);
	CGContextRestoreGState(context);
}	

- (void)drawOutline:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
	CGContextSetLineWidth(context, [GUILayout GetDefaultListCellStroke]);
	CGContextSetRGBStrokeColor(context, m_fOutlineRed, m_fOutlineGreen, m_fOutlineBlue, m_fOutlineAlpha);
	
	float x1, x2, y1, y2;
	
	//draw horzontal outlines
	x1 = rect.origin.x;
	x2 = rect.origin.x+rect.size.width;
	y2 = y1 = rect.origin.y;
	DrawLine2(context, x1, y1, x2, y2);
	
	y2 = y1 = rect.origin.y+rect.size.height;
	DrawLine2(context, x1, y1, x2, y2);
	
	//draw horzontal outlines
	y1 = rect.origin.y;
	y2 = rect.origin.y+rect.size.height;
	x2 = x1 = rect.origin.x;
	DrawLine2(context, x1, y1, x2, y2);
	
	x2 = x1 = rect.origin.x+rect.size.width;
	DrawLine2(context, x1, y1, x2, y2);
	
	CGContextRestoreGState(context);
}	

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if(m_iconImage != NULL)
		[self drawIcon:context withRect:rect];
	if(m_szTitle)
		[self drawText:context withRect:rect];
	if(m_bSelectable == YES && m_bSelected == YES)
		[self drawHighlight:context withRect:rect];
	[self drawOutline:context withRect:rect];
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


- (void)dealloc 
{
	if(m_DataStorage != nil)
		[m_DataStorage Destroy];
	if(m_iconImage != NULL)
		CGImageRelease(m_iconImage);
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
	return;
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
	float fRet = self.frame.size.height;
	return fRet;
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
}	

-(void)SetTitle:(NSString*)text
{
    m_szTitle = text;
}

-(NSString*)GetTitle
{
    return m_szTitle;    
}
@end
