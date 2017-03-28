//
//  CDropdownListContainer.m
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "CDropdownListContainer.h"
#import "NOMGUILayout.h"
//#include "drawhelper.h"


@interface CDropdownListContainer ()
{
    CDropdownListDisplayView*       m_ListView;
    int                             m_nCtrlID;
    
    CGGradientRef           m_Gradient;
    CGColorSpaceRef         m_Colorspace;
    
}

@end


@implementation CDropdownListContainer

-(float)GetContainerViewMaxHeight
{
    float fRet = 5*[NOMGUILayout GetDefaultTextEditorButtonHeight];
    
    return fRet;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_ListView = nil;
        m_nCtrlID = -1;
    
        self.backgroundColor = [UIColor clearColor];
        
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};
        CGFloat colors[8] =
        {
            0.9, 0.9, 0.9, 1.0,
            0.7, 0.7, 0.7, 1.0,
        };
        
        m_Colorspace = CGColorSpaceCreateDeviceRGB();
        m_Gradient = CGGradientCreateWithColorComponents (m_Colorspace, colors, locations, num_locations);
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        m_ListView = [[CDropdownListDisplayView alloc] initWithFrame:rect];
        [self addSubview:m_ListView];
    }
    return self;
}

-(void)RegisterCtrlID:(int)nCtrlID
{
    m_nCtrlID = nCtrlID;
    
}

-(int)GetCtrlID
{
    return m_nCtrlID;
}

-(void)UpdateContentLayout
{
    CGRect frame = self.frame;
    frame.size.height = [self GetLayoutHeight];
    [self setFrame:frame];
}

-(void)UpdateLayout:(float)origX withY:(float)origY
{
    [self UpdateContentLayout];
    CGRect frame = self.frame;
    frame.origin.x = origX;
    frame.origin.y = origY;
    [self setFrame:frame];
    frame = m_ListView.frame;
    frame.size.height = self.frame.size.height;
    [m_ListView setFrame:frame];
    [m_ListView UpdateLayout];
}

-(float)GetLayoutWidth
{
    float width = self.frame.size.width;
    return width;
}

-(float)GetLayoutHeight
{
    float height = [self GetContainerViewMaxHeight];

    if(m_ListView != nil)
    {
        float h = [m_ListView GetItemsHeight];
        if(h < height)
            height = h;
    }
    return height;
}

-(void)AddItem:(CDropdownListItem*)item
{
    if(m_ListView != nil)
    {
        [m_ListView AddItem:item];
    }
}

-(void)SetSelectedItem:(int)nItemID
{
    if(m_ListView != nil)
    {
        [m_ListView SetSelectedItem:nItemID];
    }
}

-(void)Open
{
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    [self becomeFirstResponder];
}

-(void)Close
{
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
    [m_ListView UpdateLayout];
    [self resignFirstResponder];
}

- (void)DrawBasicBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
//    float fsize = 2.0;
//    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_Gradient, pt1, pt2, 0);
    
    CGContextRestoreGState(context);
}

- (void)DrawGlossyBackground:(CGContextRef)context inRect:(CGRect)rect
{
    [self DrawBasicBackground:context inRect:rect];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    [self DrawGlossyBackground:context inRect:rect];
}


@end
