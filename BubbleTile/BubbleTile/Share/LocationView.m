//
//  LocationView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "LocationView.h"
#import "GUILayout.h"
#import "GameLayout.h"
#import "DrawHelper2.h"
#import "ApplicationConfigure.h"
#import "StringFactory.h"
#include "drawhelper.h"

#define MAPVIEW_BUTTON_EVENT_SHOWME         0
#define MAPVIEW_BUTTON_EVENT_SHOWALL        1
#define MAPVIEW_BUTTON_EVENT_MAPSTANDARD    2
#define MAPVIEW_BUTTON_EVENT_MAPSATELLITE   3
#define MAPVIEW_BUTTON_EVENT_MAPHYBRID      4

@implementation LocationView

-(void)UpdateButtonsLayout
{
    float fMarginY = [GUILayout GetDefaultAlertUIEdge];
    if([ApplicationConfigure iPADDevice])
        fMarginY *= 2.0;
    
    float w = [GUILayout GetMapViewButtonWidth];
    float h = [GUILayout GetMapViewButtonHeight];
    float sx = 0;
    float sy = 0;
    float fMarginX = fMarginY*2.0;//(m_MapView.frame.size.width - w*3.0)/2.0;
    if([ApplicationConfigure iPADDevice])
        fMarginX = fMarginY*4.0;
    
    CGRect rect;
    if([GUILayout IsProtrait])
    {
        sx = m_MapView.frame.origin.x;
        sy = m_MapView.frame.origin.y - fMarginY - h;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnShowMe setFrame:rect];
        
        sx = m_MapView.frame.origin.x + fMarginX + w;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnShowAll setFrame:rect];
        
        sx = m_MapView.frame.origin.x;
        sy = m_MapView.frame.origin.y + m_MapView.frame.size.height + fMarginY;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnMapStardard setFrame:rect];

        sx = m_MapView.frame.origin.x + fMarginX + w;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnMapSatellite setFrame:rect];

        sx = m_MapView.frame.origin.x + (fMarginX + w)*2.0;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnMapHybird setFrame:rect];
    }
    else 
    {
        fMarginX = fMarginY;
        sx = m_MapView.frame.origin.x - w - fMarginX;
        sy = m_MapView.frame.origin.y + fMarginY*2.0;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnShowMe setFrame:rect];
        
        sy = m_MapView.frame.origin.y + fMarginY*2.0 + fMarginY + h;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnShowAll setFrame:rect];
        
        sx = m_MapView.frame.origin.x + m_MapView.frame.size.width + fMarginX;
        sy = m_MapView.frame.origin.y + fMarginY*2.0;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnMapStardard setFrame:rect];
        
        sy = m_MapView.frame.origin.y + fMarginY*2.0 + fMarginY + h;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnMapSatellite setFrame:rect];
        
        sy = m_MapView.frame.origin.y + fMarginY*2.0 + (fMarginY + h)*2.0;
        rect = CGRectMake(sx, sy, w, h);
        [m_btnMapHybird setFrame:rect];
    }
}

-(void)InitButtons
{
    CGRect rect = CGRectMake(0, 0, [GUILayout GetMapViewButtonWidth], [GUILayout GetMapViewButtonHeight]);

    m_btnShowMe = [[CustomGlossyButton alloc] initWithFrame:rect];
    [m_btnShowMe SetGreenDisplay];
    [m_btnShowMe RegisterButton:self withID:MAPVIEW_BUTTON_EVENT_SHOWME withLabel:[StringFactory GetString_ShowMe]];
    [self addSubview:m_btnShowMe];
    [m_btnShowMe release];

    m_btnShowAll = [[CustomGlossyButton alloc] initWithFrame:rect];
    [m_btnShowAll SetGreenDisplay];
    [m_btnShowAll RegisterButton:self withID:MAPVIEW_BUTTON_EVENT_SHOWALL withLabel:[StringFactory GetString_ShowAll]];
    [self addSubview:m_btnShowAll];
    [m_btnShowAll release];

    m_btnMapStardard = [[CustomGlossyButton alloc] initWithFrame:rect];
    [m_btnMapStardard SetGreenDisplay];
    [m_btnMapStardard RegisterButton:self withID:MAPVIEW_BUTTON_EVENT_MAPSTANDARD withLabel:[StringFactory GetString_MapStandard]];
    [self addSubview:m_btnMapStardard];
    [m_btnMapStardard release];

    m_btnMapSatellite = [[CustomGlossyButton alloc] initWithFrame:rect];
    [m_btnMapSatellite SetGreenDisplay];
    [m_btnMapSatellite RegisterButton:self withID:MAPVIEW_BUTTON_EVENT_MAPSATELLITE withLabel:[StringFactory GetString_MapSatellite]];
    [self addSubview:m_btnMapSatellite];
    [m_btnMapSatellite release];

    m_btnMapHybird = [[CustomGlossyButton alloc] initWithFrame:rect];
    [m_btnMapHybird SetGreenDisplay];
    [m_btnMapHybird RegisterButton:self withID:MAPVIEW_BUTTON_EVENT_MAPHYBRID withLabel:[StringFactory GetString_MapHybird]];
    [self addSubview:m_btnMapHybird];
    [m_btnMapHybird release];
    
    [self UpdateButtonsLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float fSize = [GameLayout GetDefaultLocationViewSize];
        float sx = (self.frame.size.width - fSize)*0.5;
        float sy = (self.frame.size.height - fSize)*0.5;
        CGRect rect = CGRectMake(sx, sy, fSize, fSize);
        m_MapView = [[MapFrameView alloc] initWithFrame:rect];
        m_MapView.hidden = YES;
        [self addSubview:m_MapView];
        [m_MapView release];
        [self InitButtons];
        m_nIndexOfMe = -1;
    }
    return self;
}

- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    float fsize = [GUILayout GetDefaultAlertUIConner];
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    [DrawHelper2 DrawDefaultFrameViewBackground:context at:rect];
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float foffset = [GUILayout GetDefaultAlertUIEdge]/2.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawDefaultFrameViewBackgroundDecoration:context];
    CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(void)ShowMe
{
    if(0 <= m_nIndexOfMe)
    {
        [m_MapView ShowAnnotation:m_nIndexOfMe];
    }
}

-(void)ShowAll
{
    [m_MapView ShowAllAnnotation];
}

-(void)CloseView
{
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
}

-(void)OpenView
{
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    [m_MapView DisplayStandardMap];
    [m_MapView OpenView:YES];
    if(0 <= m_nIndexOfMe)
    {
        [self ShowMe];
    }
    else 
    {
        [self ShowAll];
    }
}

-(void)UpdateViewLayout
{
    float fSize = [GameLayout GetDefaultLocationViewSize];
    float sx = (self.frame.size.width - fSize)*0.5;
    float sy = (self.frame.size.height - fSize)*0.5;
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    [m_MapView setFrame:rect];
    [self UpdateButtonsLayout];
    [self setNeedsDisplay];
}

-(void)OnButtonClick:(int)nButtonID
{
    switch (nButtonID) 
    {
        case MAPVIEW_BUTTON_EVENT_SHOWME:
            [self ShowMe];
            break;
        case MAPVIEW_BUTTON_EVENT_SHOWALL:
            [self ShowAll];
            break;
        case MAPVIEW_BUTTON_EVENT_MAPSTANDARD:
            [m_MapView DisplayStandardMap];
            break;
        case MAPVIEW_BUTTON_EVENT_MAPSATELLITE:
            [m_MapView DisplaySatelliteMap];
            break;
        case MAPVIEW_BUTTON_EVENT_MAPHYBRID:
            [m_MapView DisplayHybridMap];
            break;
        default:
            break;
    }
}

-(void)ResetMap
{
    [m_MapView Reset];
}

-(int)GetMapLocations
{
    int nRet = [m_MapView GetMKAnnotationCount];
    return nRet;
}

-(void)AddMapAnnotation:(UIImage*)icon withTitle:(NSString*)title withText:(NSString*)text withLatitude:(float)fLatitude withLongitude:(float)fLongitude isMaster:(BOOL)bMaster isMe:(BOOL)bMe
{
    int nID = [m_MapView GetMKAnnotationCount];
    if(bMe)
        m_nIndexOfMe = nID;
    [m_MapView AddMKAnnotation:icon withTitle:title withText:text withLatitude:fLatitude withLongitude:fLongitude withID:nID isMaster:(bMe || bMaster)];
}

-(void)HideMeAndAllButtons
{
    m_btnShowMe.hidden = YES;
    m_btnShowAll.hidden = YES;
}



@end
