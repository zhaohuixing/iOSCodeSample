//
//  CDropdownListItem.m
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "CDropdownListItem.h"


#define LISTITEM_SIZE_OFFSET        1

@implementation CDropdownListItem


-(void)InitializeParameters
{
    self.backgroundColor = [UIColor clearColor];
	m_bSelected = NO;
    
    size_t num_locations = 2;
    CGFloat locations[3] = {0.0, 1.0};
    CGFloat colors[12] =
    {
        0.4, 0.4, 1.0, 1.0,
        0.0, 0.0, 0.75, 1.0,
    };
    m_Colorspace = CGColorSpaceCreateDeviceRGB();
    m_Gradient = CGGradientCreateWithColorComponents (m_Colorspace, colors, locations, num_locations);
    
    m_Icon = NULL;
    
    CGRect innerRect = CGRectMake(self.frame.origin.x+LISTITEM_SIZE_OFFSET, self.frame.origin.y+LISTITEM_SIZE_OFFSET, self.frame.size.width-2*LISTITEM_SIZE_OFFSET, self.frame.size.height-2*LISTITEM_SIZE_OFFSET);
    
    m_Title = [[UILabel alloc] initWithFrame:innerRect];
    m_Title.backgroundColor = [UIColor clearColor];
    [m_Title setTextColor:[UIColor blackColor]];
    m_Title.highlightedTextColor = [UIColor grayColor];
    [m_Title setTextAlignment:NSTextAlignmentCenter];
    m_Title.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_Title.adjustsFontSizeToFitWidth = YES;
    m_Title.font = [UIFont fontWithName:@"Georgia" size:18];
    [m_Title setText:@""];
    [self addSubview:m_Title];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_bSelected = NO;
        m_bSelectable = YES;
        m_nItemID = -1;
        m_Delegate = nil;
        [self InitializeParameters];
    }
    return self;
}

-(void)UpdateForSelectionChange
{
    if(!m_bSelectable)
        return;
    
    if(m_Title != nil)
    {
        if(m_bSelected == YES)
            [m_Title setTextColor:[UIColor whiteColor]];
        else
            [m_Title setTextColor:[UIColor blackColor]];
    }
    [self setNeedsDisplay];
}

-(void)SetSelectState:(BOOL)bSelected
{
    if(!m_bSelectable)
        return;
    
    if(bSelected == YES)
    {
        if([[self superview] respondsToSelector:@selector(UnselectedAllItems)] == YES)
        {
            [[self superview] performSelector:@selector(UnselectedAllItems)];
        }
        
        
    }
    m_bSelected = bSelected;
    [self UpdateForSelectionChange];
}

-(BOOL)IsSelected
{
    return m_bSelected;
}

-(void)ResetSelectState
{
    m_bSelectable = YES;
    m_bSelected = NO;
    [self UpdateForSelectionChange];
}

-(void)SetLabel:(NSString*)text
{
    if(m_Title != nil)
    {
        [m_Title setText:text];
    }
    [self UpdateForSelectionChange];
}

-(BOOL)IsSelectable
{
    return m_bSelectable;
}

-(void)SetSelectable:(BOOL)bSelectable
{
    m_bSelectable = bSelectable;
    if(m_bSelectable == NO)
    {
        if(m_bSelected == YES)
        {
            m_bSelected = NO;
            [self UpdateForSelectionChange];
        }
    }
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!m_bSelectable)
        return;
    
    if(m_bSelected == NO)
    {
        m_bSelected = YES;
        [self UpdateForSelectionChange];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!m_bSelectable)
        return;
	
    NSArray *allTouches = [touches allObjects];
	CGPoint pt = [[allTouches objectAtIndex:0] locationInView:self];
    if(pt.x < 0 || self.frame.size.width < pt.x || pt.y < 0 || self.frame.size.height < pt.y)
    {
        if(m_bSelected == YES)
        {
            m_bSelected = NO;
            [self UpdateForSelectionChange];
        }
        return;
    }
    
    
    if(m_bSelected == NO)
    {
        m_bSelected = YES;
        [self UpdateForSelectionChange];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!m_bSelectable)
        return;
    
    if(m_bSelected == YES)
    {
        m_bSelected = NO;
        [self UpdateForSelectionChange];
    }
}

*/ 


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!m_bSelectable)
        return;
    
	NSArray *allTouches = [touches allObjects];
	CGPoint pt = [[allTouches objectAtIndex:0] locationInView:self];
    if(pt.x < 0 || self.frame.size.width < pt.x || pt.y < 0 || self.frame.size.height < pt.y)
    {
        if(m_bSelected == YES)
        {
            m_bSelected = NO;
            [self UpdateForSelectionChange];
        }
        return;
    }
    
    if(m_bSelected == YES)
    {
        m_bSelected = NO;
        [self UpdateForSelectionChange];
    }
    else
    {
        m_bSelected = YES;
        [self UpdateForSelectionChange];
    }
    
    if(m_bSelected == YES)
    {
        if(m_Delegate != nil)
            [m_Delegate OnListItemSelected:self];
    }
}

-(void)DrawBlueBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect rt = CGRectMake(rect.origin.x+LISTITEM_SIZE_OFFSET, rect.origin.y+LISTITEM_SIZE_OFFSET, rect.size.width-2*LISTITEM_SIZE_OFFSET, rect.size.height-2*LISTITEM_SIZE_OFFSET);
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, rt);
    CGContextClip(context);
    CGPoint pt1, pt2;
    pt1.x = rt.origin.x;
    pt1.y = rt.origin.y;
    pt2.x = rt.origin.x;
    pt2.y = pt1.y+rt.size.height;
    CGContextDrawLinearGradient (context, m_Gradient, pt1, pt2, 0);
    
    CGContextRestoreGState(context);
}

-(void)DrawWhiteBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect rt = CGRectMake(rect.origin.x+LISTITEM_SIZE_OFFSET, rect.origin.y+LISTITEM_SIZE_OFFSET, rect.size.width-2*LISTITEM_SIZE_OFFSET, rect.size.height-2*LISTITEM_SIZE_OFFSET);
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, rt);
    CGContextClip(context);
    CGFloat clr[] = {1, 1, 1, 1};
    CGContextSetFillColor(context, clr);
    CGContextFillPath(context);
    CGContextFillRect(context, rt);
    
    CGContextRestoreGState(context);
}

-(void)SetItemID:(int)nItemID
{
    m_nItemID = nItemID;
}

-(int)GetItemID
{
    return m_nItemID;
}

-(void)SetText:(NSString*)text
{
    [self SetLabel:text];
}

-(NSString*)GetText
{
    return m_Title.text;
}

-(void)RegisterDelegate:(id<IDropdownListDelegate>)delegate
{
    m_Delegate = delegate;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    if(m_bSelected == YES)
        [self DrawBlueBackground:context inRect:rect];
    else
        [self DrawWhiteBackground:context inRect:rect];
}


@end
