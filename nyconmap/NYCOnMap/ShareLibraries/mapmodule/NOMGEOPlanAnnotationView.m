//
//  NOMGEOPlanAnnotationView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMGEOPlanAnnotationView.h"
#import "DrawHelper2.h"
#include "NOMMapConstants.h"

@interface NOMGEOPlanAnnotationView ()
{
    id<IGEOPlanAnnotationViewHost>      m_ParentView;
    BOOL                                m_bSelected;
    double                              m_dMinZoom;
    double                              m_dMaxZoom;
    
}

@end


///////////////////////////////////////////
@implementation NOMGEOPlanAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_ParentView = nil;
        m_bSelected = NO;
    }
    return self;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withSize:(CGSize)size withParent:(id<IGEOPlanAnnotationViewHost>)pParentView
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0.0, size.height*-0.5);
        CGRect frame = self.frame;
        frame.size = size;
        self.frame = frame;
        m_dMinZoom = MIN_MKMAPOBJECT_ZOOM;
        m_dMaxZoom = 1.0;
        
        m_ParentView = pParentView;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_ParentView != nil)
    {
        [m_ParentView SetPinDragState:YES];
    }
    m_bSelected = YES;
    //[super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    m_bSelected = NO;
    //[super touchesEnded:touches withEvent:event];
/*
    UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
    if(touch != nil && m_ParentView != nil)
    {
        CLLocationCoordinate2D touchCoordinate = [m_ParentView GetTouchCoordinate:touch];
        [self.annotation setCoordinate:touchCoordinate];
        [m_ParentView UpdateLayout];
        
    }
*/ 
 
    if(m_ParentView != nil)
    {
        [m_ParentView SetPinDragState:NO];
    }
    
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    m_bSelected = NO;
   
    //[super touchesCancelled:touches withEvent:event];
/*
    UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
    if(touch != nil && m_ParentView != nil)
    {
        CLLocationCoordinate2D touchCoordinate = [m_ParentView GetTouchCoordinate:touch];
        [self.annotation setCoordinate:touchCoordinate];
        [m_ParentView UpdateLayout];
        
    }
*/
    if(m_ParentView != nil)
    {
        [m_ParentView SetPinDragState:NO];
    }
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Drawing code
    double dZoom = 1.0;
    
    if(m_ParentView != nil)
    {
        dZoom = [m_ParentView GetZoomFactor]/(MAX_MKMAPVIEW_ZOOM*2.0);
        if(dZoom <= m_dMinZoom)
            dZoom = m_dMinZoom;
        if(m_dMaxZoom < dZoom)
            dZoom = m_dMaxZoom;
    }
    CGFloat rtwidth = rect.size.width*dZoom;
    CGFloat rtheight = rtwidth; //rect.size.height*dZoom;
    
    CGFloat sx = rect.origin.x + (rect.size.width - rtwidth)/2.0;
    CGFloat sy = rect.origin.y + (rect.size.height - rtheight);
    
    CGRect rt = CGRectMake(sx, sy, rtwidth, rtheight);
    
    if(m_bSelected == NO)
        [DrawHelper2 DrawGEOPlanPin:context at:rt];
    else
        [DrawHelper2 DrawGEOPlanPinHighlight:context at:rt];
}

-(void)SetZoomThreshold:(double)minZoom maxZoom:(double)maxZoom
{
    m_dMinZoom = minZoom;
    m_dMaxZoom = maxZoom;
}

@end
