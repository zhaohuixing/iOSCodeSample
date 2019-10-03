//
//  ActivePlayerAnimator.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivePlayerAnimator.h"
#import "RenderHelper.h"

#define ACTIVEPLAYERANIMATOR_TIMERINTERVAL  0.75

@interface ActivePlayerAnimator ()
{
    BOOL        m_bActive;
}

@end

@implementation ActivePlayerAnimator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_bActive = NO;
        self.hidden = YES;
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
    [RenderHelper DrawRedStar:context at:rect];
	CGContextRestoreGState(context);
}

-(BOOL)IsActive
{
    return m_bActive;
}

-(void)FlyOut
{
//    if(m_bActive)
//    {
        self.hidden = YES;
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:ACTIVEPLAYERANIMATOR_TIMERINTERVAL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(FlyIn)];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        [UIView commitAnimations];
//    }
}

-(void)FlyIn
{
//    if(m_bActive)
//    {
        self.hidden = NO;
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:ACTIVEPLAYERANIMATOR_TIMERINTERVAL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(FlyOut)];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        [UIView commitAnimations];
//    }
//    else
//    {
//        self.hidden = YES;
//    }
}

-(void)StartAnimation
{
    m_bActive = YES;
    [self FlyIn];
}

-(void)StopAnimation
{
    m_bActive = NO;
    self.hidden = YES;
}


@end
