//
//  CustomGlossyButton.m
//  XXXXXXX
//
//  Created by Zhaohui Xing on 11-12-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "CustomGlossyButton.h"
#import "DrawHelper2.h"
#import "drawhelper.h"
#import "GUIEventLoop.h"

@implementation CustomGlossyButton

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
        //CGRect rt = CGRectMake(0, 0, frame.size.width, frame.size.height);
        CGRect rt = CGRectMake(frame.size.height*0.25, 0, frame.size.width-frame.size.height*0.5, frame.size.height);
        
        
        m_Label = [[UILabel alloc] initWithFrame:rt];
        m_Label.backgroundColor = [UIColor clearColor];
        [m_Label setTextColor:[UIColor redColor]];
        m_Label.font = [UIFont fontWithName:@"Times New Roman" size:frame.size.height*0.65];
        [m_Label setTextAlignment:UITextAlignmentCenter];
        m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:m_Label];
        [m_Label release];
        m_Delegate = nil;
        m_nEventID = -1;
        m_bGreen = NO;
    }
    return self;
}

-(void)SetLargerLabel
{
    CGRect rt = CGRectMake(self.frame.size.height*0.1, 0, self.frame.size.width-self.frame.size.height*0.2, self.frame.size.height);
    [m_Label setFrame:rt];
}

-(void)RegisterButton:(id<CustomGlossyButtonDelegate>)delegate withID:(int)nEventID withLabel:(NSString*)label
{
    m_Delegate = delegate;
    m_nEventID = nEventID;
    [m_Label setText:label];
    [self setNeedsDisplay];
}

-(void)SetLabel:(NSString*)label
{
    [m_Label setText:label];
}

- (void)DrawBasicBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    float fsize = rect.size.height;//*0.2;
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    if(!m_bGreen)
        [DrawHelper2 DrawBlueGlossyRectVertical:context at:rect];
    else
        [DrawHelper2 DrawGreenGlossyRectVertical:context at:rect];
    
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
    
    if(!m_bGreen)
        [DrawHelper2 DrawBlueHighLightGlossyRectVertical:context at:rt];
    else
        [DrawHelper2 DrawGreenHighLightGlossyRectVertical:context at:rt];
        
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
    if(m_Delegate)
        [m_Delegate OnButtonClick:m_nEventID];
}

/*
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event 
{
    BOOL bRet = NO;
    if(self.bounds.origin.y <= point.y && point.y <= (self.bounds.origin.y+self.bounds.size.height) && 
       self.bounds.origin.x <= point.x && point.x <= (self.bounds.origin.x+self.bounds.size.width))
        bRet = YES;
    
    return bRet;
}*/

-(void)SetGreenDisplay
{
    m_bGreen = YES;
    [m_Label setTextColor:[UIColor yellowColor]];
}

-(int)GetID
{
    return m_nEventID;
}
@end
