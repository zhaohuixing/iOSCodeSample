//
//  PopupMenuItem.m
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-09.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "PopupMenuItem.h"
#import "PopupMenu.h"
#import "PopupMenuContainerView.h"
#import "GUIEventLoop.h"
#import "NOMAppInfo.h"

#define MENUITEM_SIZE_OFFSET        2

@implementation PopupMenuItem

-(void)InitializeParameters
{
    m_RootContainer = nil;
    m_ChildMenu = nil;
    self.backgroundColor = [UIColor clearColor];
    m_nMenuID = -1;
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
    
    CGRect innerRect = CGRectMake(self.frame.origin.x+MENUITEM_SIZE_OFFSET, self.frame.origin.y+MENUITEM_SIZE_OFFSET, self.frame.size.width-2*MENUITEM_SIZE_OFFSET, self.frame.size.height-2*MENUITEM_SIZE_OFFSET);
   
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

-(void)SetImage:(CGImageRef)imageResource inCenter:(BOOL)bCenter
{
    m_bCenter = bCenter;
    m_Icon = imageResource;
    if(m_bCenter == NO)
    {
        CGRect innerRect = CGRectMake(self.frame.origin.x+self.frame.size.height, self.frame.origin.y+MENUITEM_SIZE_OFFSET, self.frame.size.width-self.frame.size.height-MENUITEM_SIZE_OFFSET, self.frame.size.height-2*MENUITEM_SIZE_OFFSET);
        [m_Title setFrame:innerRect];
    }
}

-(void)SetLabeLFontSize:(float)fSize
{
    m_Title.font = [UIFont fontWithName:@"Georgia" size:fSize];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self InitializeParameters];
        m_bCenter = NO;
    }
    return self;
}

-(void)RegisterControllers:(PopupMenuContainerView*)rootContainer
{
    m_RootContainer = rootContainer;
}

-(void)dealloc
{
    CGColorSpaceRelease(m_Colorspace);
    CGGradientRelease(m_Gradient);
}

-(void)RegisterMenuID:(int)nID
{
    m_nMenuID = nID;
}

-(int)GetMenuID
{
    return m_nMenuID;
}

-(void)SetChildMenu:(PopupMenu*)childMenu
{
    m_ChildMenu = childMenu;
    
}

-(void)OpenChildMenu
{
    if(m_RootContainer != nil && m_ChildMenu != nil)
    {
        [m_RootContainer OpenMenu:m_ChildMenu];
    }
}

-(void)DrawBlueBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect rt = CGRectMake(rect.origin.x+MENUITEM_SIZE_OFFSET, rect.origin.y+MENUITEM_SIZE_OFFSET, rect.size.width-2*MENUITEM_SIZE_OFFSET, rect.size.height-2*MENUITEM_SIZE_OFFSET);
    
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
    CGRect rt = CGRectMake(rect.origin.x+MENUITEM_SIZE_OFFSET, rect.origin.y+MENUITEM_SIZE_OFFSET, rect.size.width-2*MENUITEM_SIZE_OFFSET, rect.size.height-2*MENUITEM_SIZE_OFFSET);
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, rt);
    CGContextClip(context);
    CGFloat clr[] = {1, 1, 1, 1};
    CGContextSetFillColor(context, clr);
    CGContextFillPath(context);
    CGContextFillRect(context, rt);
    
    CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    if(m_bSelected == YES)
        [self DrawBlueBackground:context inRect:rect];
    else
        [self DrawWhiteBackground:context inRect:rect];
    
    if(m_Icon != NULL)
    {
        CGRect rt = CGRectMake(rect.origin.x+MENUITEM_SIZE_OFFSET, rect.origin.y+MENUITEM_SIZE_OFFSET, rect.size.height-2*MENUITEM_SIZE_OFFSET, rect.size.height-2*MENUITEM_SIZE_OFFSET);
        
        if(m_bCenter == YES)
        {
            float size = rect.size.height-2*MENUITEM_SIZE_OFFSET;
            float sx = rect.origin.x + (rect.size.width - size)*0.5;
            float sy = rect.origin.x + (rect.size.height - size)*0.5;
            rt = CGRectMake(sx, sy, size, size);
        }
        
        CGContextDrawImage(context, rt, m_Icon);
    }
}

-(void)SetSelectState:(BOOL)bSelected
{
    m_bSelected = bSelected;
    [self UpdateForSelectionChange];
}

-(void)ResetSelectState
{
    m_bSelected = NO;
    [self UpdateForSelectionChange];
}

-(void)UpdateForSelectionChange
{
    if(m_Title != nil)
    {
        if(m_bSelected == YES)
            [m_Title setTextColor:[UIColor whiteColor]];
        else
            [m_Title setTextColor:[UIColor blackColor]];
    }
    [self setNeedsDisplay];
}

-(void)SetLabel:(NSString*)text
{
    if(m_Title != nil)
    {
        [m_Title setText:text];
    }
    [self UpdateForSelectionChange];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_bSelected == NO)
    {
        m_bSelected = YES;
        [self UpdateForSelectionChange];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *allTouches = [touches allObjects];
	//int nCount = [allTouches count];
	//for(int i = 0; i < nCount; ++i)
	//{
	CGPoint pt = [[allTouches objectAtIndex:0] locationInView:self];
    //    NSLog(@"x: %f, y: %f", pt.x, pt.y);
	//}
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
    if(m_bSelected == YES)
    {
        m_bSelected = NO;
        [self UpdateForSelectionChange];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    if(m_RootContainer != nil && m_ChildMenu != nil)
    {
        [m_RootContainer OpenMenu:m_ChildMenu];
    }
    else
    {
        [GUIEventLoop SendEvent:m_nMenuID eventSender:self];
    }
}

-(void)SetLineNumber:(int)nLine
{
    m_Title.numberOfLines = nLine;
}

@end
