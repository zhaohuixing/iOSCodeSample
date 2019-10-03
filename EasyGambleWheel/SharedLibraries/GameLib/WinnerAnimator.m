//
//  WinnerAnimator.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "WinnerAnimator.h"
#import "RenderHelper.h"

#define WINNERANIMATOR_TIMERINTERVAL  1

@implementation WinnerFlying

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
    [RenderHelper DrawCashPaper:context at:rect];
	CGContextRestoreGState(context);
}

@end



@implementation WinnerAnimator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_Flyer = [[WinnerFlying alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:m_Flyer];
        self.hidden = YES;
        m_bFirstFrame = YES;
        m_bActive = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(m_bFirstFrame == NO)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [RenderHelper DrawCashPaper:context at:rect];
        CGContextRestoreGState(context);
    }
}

-(BOOL)IsActive
{
    return m_bActive;
}

-(void)FlyDone
{
    if(m_bActive)
    {
        m_bFirstFrame = NO;
        [m_Flyer setNeedsDisplay];
        m_Flyer.hidden = YES;
        [self FlyIn];
    }    
}

-(void)FlyIn
{
    if(m_bActive)
    {
        m_Flyer.hidden = NO;
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:WINNERANIMATOR_TIMERINTERVAL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(FlyDone)];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:m_Flyer cache:YES];
        [UIView commitAnimations];
    }
    else
    {
        self.hidden = YES;
    }
}

-(void)StartAnimation
{
    self.hidden = NO;
    m_bFirstFrame = YES;
    m_bActive = YES;
    [self FlyIn];
    [self setNeedsDisplay];
}

-(void)StopAnimation
{
    m_bFirstFrame = YES;
    m_bActive = NO;
    self.hidden = YES;
}

@end
