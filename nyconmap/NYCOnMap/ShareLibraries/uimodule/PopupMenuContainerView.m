//
//  PopupMenuContainerView.m
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-06.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "PopupMenuContainerView.h"
#import "PopupMenu.h"
#import "TwoStateButton.h"
#import "ImageLoader.h"
#import "NOMAppInfo.h"
#import "DrawHelper2.h"

//#include "drawhelper.h"

#define POPUPMENU_MAX_DISPLAY_ITEMS             5

@implementation PopupMenuContainerView

+(float)GetContainerViewMaxHeight
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 300;
    }
    else
    {
        return 240;
    }
}

+(float)GetContainerViewWidth
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 280;
    }
    else
    {
        return 180;
    }
}

+(float)GetAchorSize
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 50;
    }
    else
    {
        return 30;
    }
}

+(float)GetCornerSize
{
    float w = [PopupMenuContainerView GetContainerViewWidth];
    float ret = w*0.05;
    return ret;
}

+(float)GetMenuItemWidth
{
    float w = [PopupMenuContainerView GetContainerViewWidth];
    float ret = w*0.9;
    return ret;
}

+(float)GetMenuItemHeight
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 50;
    }
    else
    {
        return 40;
    }
}

+(int)GetMaxDisplayMenuItemNumber
{
    return POPUPMENU_MAX_DISPLAY_ITEMS;
}

+(int)GetMinDisplayMenuItemNumber
{
    return 1;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};
        CGFloat colors[8] =
        {
            0.4, 0.4, 0.4, 1.0,  //0.7,
            0.0, 0.0, 0.0, 1.0,
        };
        
        
        m_Colorspace = CGColorSpaceCreateDeviceRGB();
        m_Gradient = CGGradientCreateWithColorComponents (m_Colorspace, colors, locations, num_locations);
        
        
        m_nMenuID = -1;
        m_ArchorPoint = CGPointMake(frame.origin.x+frame.size.width*0.5, frame.origin.y+frame.size.height);
        float size = [PopupMenuContainerView GetAchorSize];
        float sx = (frame.size.width - size)*0.5;
        float sy = frame.size.height -size;
        CGRect rect = CGRectMake(sx, sy, size, size);
        m_CloseButton = [[TwoStateButton alloc] initWithFrame:rect];
        m_CloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_CloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_CloseButton addTarget:self action:@selector(CloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_CloseButton];
        
        m_Controller = nil;
        
        m_UpSign = [ImageLoader LoadImageWithName:@"scrollup.png"];
        m_DownSign = [ImageLoader LoadImageWithName:@"scrolldown.png"];
    }
    return self;
}

- (void)dealloc
{
    //if(m_UpSign != NULL)
    //    CGImageRelease(m_UpSign);
    //if(m_DownSign != NULL)
    //    CGImageRelease(m_DownSign);
    
    CGColorSpaceRelease(m_Colorspace);
    CGGradientRelease(m_Gradient);
}

-(void)Register:(int)nMenu withArchor:(CGPoint)archorPoint withController:(id<PopupMenuDelegate>)controller
{
    m_nMenuID = nMenu;
    m_ArchorPoint = CGPointMake(archorPoint.x, archorPoint.y);
    m_Controller = controller;
    [self UpdateLayout];
}

-(float)GetLayoutWidth
{
    float width = [PopupMenuContainerView GetContainerViewWidth];
    return width;
}

-(float)GetLayoutHeight
{
    float height = [PopupMenuContainerView GetContainerViewMaxHeight];
    
    if(m_CurrentDisplayMenu != nil)
    {
        height = [m_CurrentDisplayMenu GetMenuHeight];
        height += [PopupMenuContainerView GetAchorSize] + [PopupMenuContainerView GetCornerSize]*2;
    }
    
    return height;
}

-(void)UpdateFrameSize
{
    float h = [self GetLayoutHeight];
    float bottom = self.frame.origin.y + self.frame.size.height;
    float top = bottom - h;
    float left = self.frame.origin.x;
    float w = self.frame.size.width;
    CGRect rect = CGRectMake(left, top, w, h);
    [self setFrame:rect];
    if(m_CurrentDisplayMenu != nil)
    {
        rect = m_CurrentDisplayMenu.frame;
        rect.size.height = [m_CurrentDisplayMenu GetMenuHeight];
        [m_CurrentDisplayMenu setFrame:rect];
        [m_CurrentDisplayMenu setContentSize:CGSizeMake(rect.size.width, [m_CurrentDisplayMenu GetAllItemHeight])];
    }
}

-(void)UpdateLayout
{
    [self UpdateFrameSize];
    float size = [PopupMenuContainerView GetAchorSize];
    float sx =  m_ArchorPoint.x - size*0.5;//(self.frame.size.width - size)*0.5;
    float sy = self.frame.size.height -size;
    CGRect rect = CGRectMake(sx, sy, size, size);
    [m_CloseButton setFrame:rect];
    [self setNeedsDisplay];
    if(m_CurrentDisplayMenu != nil)
    {
        [m_CurrentDisplayMenu UpdateLayout];
    }
}

- (void)DrawScrollUpSign:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    float srcw = CGImageGetWidth(m_UpSign);
    float srch = CGImageGetHeight(m_UpSign);
    float ratio = srcw/srch;
    float cornerHeight = [PopupMenuContainerView GetCornerSize];
    float h = cornerHeight;
    float w = ratio*h;
    float sx = rect.origin.x + (rect.size.width - w)*0.5;
    float sy = rect.origin.y;
    CGRect rt = CGRectMake(sx, sy, w, h);
    
//    float clr[] = {0, 0, 0, 0.5};
//    CGContextSetFillColor(context, clr);
//    CGContextFillRect(context, rt);
    
    CGContextDrawImage(context, rt, m_UpSign);
    CGContextRestoreGState(context);
}

- (void)DrawScrollDownSign:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    float srcw = CGImageGetWidth(m_DownSign);
    float srch = CGImageGetHeight(m_DownSign);
    float ratio = srcw/srch;
    float cornerHeight = [PopupMenuContainerView GetCornerSize];
    float h = cornerHeight;
    float w = ratio*h;
    float sx = rect.origin.x + (rect.size.width - w)*0.5;
    float sy = rect.origin.y + rect.size.height - [PopupMenuContainerView GetAchorSize] - h;
    CGRect rt = CGRectMake(sx, sy, w, h);
    
//    float clr[] = {0, 0, 0, 1};
//    CGContextSetFillColor(context, clr);
//    CGContextFillRect(context, rt);
    
    CGContextDrawImage(context, rt, m_DownSign);
    CGContextRestoreGState(context);
}

- (void)DrawScrollSigns:(CGContextRef)context inRect:(CGRect)rect
{
    [self DrawScrollUpSign:context inRect:rect];
    [self DrawScrollDownSign:context inRect:rect];
}


- (void)DrawBasicBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);

    float fsize = rect.size.width*0.1;
    CGRect rt = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - [PopupMenuContainerView GetAchorSize]);
//    AddRoundRectToPath(context, rt, CGSizeMake(fsize, fsize), 0.5);
    [DrawHelper2 AddRoundRectToPath:context in:rt radius:CGSizeMake(fsize, fsize) size:0.5];
    CGContextClip(context);
    CGPoint pt1, pt2;
    pt1.x = rt.origin.x;
    pt1.y = rt.origin.y;
    pt2.x = rt.origin.x;
    pt2.y = pt1.y+rt.size.height;
    CGContextDrawLinearGradient (context, m_Gradient, pt1, pt2, 0);
    
    CGContextRestoreGState(context);
    if(m_CurrentDisplayMenu != nil)
    {
        int nMenuCount = [m_CurrentDisplayMenu GetMenuItemCount];
        if([PopupMenuContainerView GetMaxDisplayMenuItemNumber] < nMenuCount)
        {
            [self DrawScrollSigns:context inRect:rect];
        }
    }
}

- (void)DrawTriangleBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    CGFloat clr[] = {0.1, 0.1, 0.1, 0.9};
    CGContextSetFillColor(context, clr);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y+rect.size.height - [PopupMenuContainerView GetAchorSize]);
    CGContextAddLineToPoint(context, rect.origin.x+rect.size.width*0.5, rect.origin.y+rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height - [PopupMenuContainerView GetAchorSize]);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+rect.size.height - [PopupMenuContainerView GetAchorSize]);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

- (void)DrawGlossyBackground:(CGContextRef)context inRect:(CGRect)rect
{
    [self DrawBasicBackground:context inRect:rect];
   // [self DrawTriangleBackground:context inRect:rect];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    [self DrawGlossyBackground:context inRect:rect];
}


-(void)CloseButtonClick
{
    if(m_CurrentDisplayMenu == m_RootMenu || [m_CurrentDisplayMenu IsRootMenu])
    {
        if(m_Controller != nil)
            [m_Controller CloseMenu:m_nMenuID];
    }
    else
    {
        if(m_CurrentDisplayMenu != nil)
            [m_CurrentDisplayMenu GotoParentMenu];
    }
}

-(int)GetMenuID
{
    return m_nMenuID;
}

/*
-(BOOL)IsMySubView:(PopupMenu*)menu
{
    BOOL bRet = NO;
    
    
}
*/

-(void)OpenMenu:(PopupMenu*)menu
{
    if(menu != nil)
    {
        if(m_CurrentDisplayMenu != nil)
        {
            m_CurrentDisplayMenu.hidden = YES;
            [self sendSubviewToBack:m_CurrentDisplayMenu];
        }

        menu.hidden = NO;
        [self bringSubviewToFront:menu];
        m_CurrentDisplayMenu = menu;
        
        [self UpdateLayout];
        
        if(m_CurrentDisplayMenu == m_RootMenu || [m_CurrentDisplayMenu IsRootMenu])
        {
            [m_CloseButton SetState:YES];
        }
        else
        {
            [m_CloseButton SetState:NO];
        }
        
    }
}

-(void)OpenRootMenu
{
    if(m_RootMenu != nil)
    {
        [self OpenMenu:m_RootMenu];
    }
}

-(void)SetRootMenu:(PopupMenu*)rootMenu
{
    m_RootMenu = rootMenu;
}

-(PopupMenu*)GetRootMenu
{
    return m_RootMenu;
}

-(void)SetCurrentMenu:(PopupMenu*)menu
{
    m_CurrentDisplayMenu = menu;
}

-(void)AddMenu:(PopupMenu*)menu
{
    [self addSubview:menu];
    [self sendSubviewToBack:menu];
    menu.hidden = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)SetArchor:(CGPoint)archorPoint
{
    m_ArchorPoint = CGPointMake(archorPoint.x, archorPoint.y);
    [self UpdateLayout];
}


@end
