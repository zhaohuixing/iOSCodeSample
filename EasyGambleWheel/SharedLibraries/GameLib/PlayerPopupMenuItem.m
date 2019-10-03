//
//  PlayerPopupMenuItem.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "PlayerPopupMenuItem.h"
#import "RenderHelper.h"
#import "drawhelper.h"
#import "GUIEventLoop.h"

@implementation PlayerPopupMenuItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        CGRect rt = CGRectMake(0, 0, frame.size.width, frame.size.height);
        m_MenuLabel = [[UILabel alloc] initWithFrame:rt];
        m_MenuLabel.backgroundColor = [UIColor clearColor];
        [m_MenuLabel setTextColor:[UIColor yellowColor]];
        m_MenuLabel.font = [UIFont fontWithName:@"Times New Roman" size:frame.size.height*0.6];
        [m_MenuLabel setTextAlignment:NSTextAlignmentCenter];
        m_MenuLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_MenuLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:m_MenuLabel];
        m_Delegate = nil;
    }
    return self;
}

-(void)dealloc
{
    m_Delegate = nil;
    
}

-(void)RegisterMenuItem:(int)nEventID withLabel:(NSString*)label
{
    m_Delegate = nil;
    m_nMenuEventID = nEventID;
    [m_MenuLabel setText:label];
    [self setNeedsDisplay];
}

-(void)RegisterOnlinePlayerMenuItem:(int)nEventID withLabel:(NSString*)label withDelegate:(id<IOnlineGamePlayerPopupMenuDelegate>)delegate
{
    m_Delegate = delegate;
    m_nMenuEventID = nEventID;
    [m_MenuLabel setText:label];
    [self setNeedsDisplay];
}


- (void)DrawBasicBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    float fsize = rect.size.height;//*0.2;
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    [RenderHelper DrawBlueGlossyRectVertical:context at:rect];
    CGContextRestoreGState(context);
}

- (void)DrawHighLightBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    float w = rect.size.width-rect.size.height/2.0;
    float h = rect.size.height*0.4;
    float sx = rect.origin.x + (rect.size.width-w)*0.5;
    float sy = rect.origin.y;
    CGRect rt = CGRectMake(sx, sy, w, h);
    float fsize = h;//*0.2;
    AddRoundRectToPath(context, rt, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    
    [RenderHelper DrawBlueHighLightGlossyRectVertical:context at:rt];
    
    CGContextRestoreGState(context);
}

- (void)DrawGlossyBackground:(CGContextRef)context inRect:(CGRect)rect
{
    [self DrawBasicBackground:context inRect:rect];
    [self DrawHighLightBackground:context inRect:rect];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    [self DrawGlossyBackground:context inRect:rect];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_Delegate == nil)
        [GUIEventLoop SendEvent:m_nMenuEventID eventSender:self];
    else
        [m_Delegate OnMenuEvent:m_nMenuEventID];
}

-(void)OnCloseMenuItem
{
    m_Delegate = nil;
    [self removeFromSuperview];
}
@end
