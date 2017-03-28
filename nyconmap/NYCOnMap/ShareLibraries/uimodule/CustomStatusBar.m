//
//  CustomStatusBar.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-30.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "CustomStatusBar.h"
#import "CustomImageButton.h"
#import "NOMGUILayout.h"

@interface CustomStatusBar()
{
    UILabel*                                        m_Label;
    CustomImageButton*                              m_btnClose;
}

@end


@implementation CustomStatusBar

-(void)OnCloseButtonClick
{
    [self CloseView:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        CGFloat dsize = 4;
        CGFloat dw = w-dsize*2.0;
        CGFloat dh = h-dsize*2.0;
        CGRect rt = CGRectMake(dsize, dsize, dw, dh);
        m_Label = [[UILabel alloc] initWithFrame:rt];
        m_Label.backgroundColor = [UIColor clearColor];
        [m_Label setTextColor:[UIColor blackColor]];
        m_Label.font = [UIFont fontWithName:@"Times New Roman" size:dh*0.4];
        [m_Label setTextAlignment:NSTextAlignmentCenter];
        m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label.adjustsFontSizeToFitWidth = YES;
        m_Label.numberOfLines = 0;
        [self addSubview:m_Label];
        
        CGFloat size = 20;
        
        rt = CGRectMake(frame.size.width-size, frame.size.height-size, size, size);
        m_btnClose = [[CustomImageButton alloc] initWithFrame:rt];
        m_btnClose.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_btnClose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [m_btnClose addTarget:self action:@selector(OnCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [m_btnClose SetCustomImage:CGImageRetain([UIImage imageNamed:@"redclose400.png"].CGImage)];
        [self addSubview:m_btnClose];
        
    }
    return self;
}

-(void)OnViewClose
{
	[[self superview] sendSubviewToBack:self];
}

-(void)CloseView:(BOOL)bAnimation
{
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:1.0];
        self.hidden = YES;
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewClose)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
		[UIView commitAnimations];
	}
	else
	{
        self.hidden = YES;
		[self OnViewClose];
	}
}

-(void)OnViewOpen
{
}

-(void)OpenView:(BOOL)bAnimation
{
	[[self superview] bringSubviewToFront:self];
	self.hidden = NO;
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewOpen)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
		[UIView commitAnimations];
	}
	else
	{
		[self OnViewOpen];
	}
}

-(void)UpdateLayout
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat dsize = 4;
    CGFloat dw = w-dsize*2.0;
    CGFloat dh = h-dsize*2.0;
    CGRect rt = CGRectMake(dsize, dsize, dw, dh);
    [m_Label setFrame:rt];
    
    CGFloat size = 20;
    
    rt = CGRectMake(self.frame.size.width-size, self.frame.size.height-size, size, size);
    [m_btnClose setFrame:rt];
}

-(void)SetText:(NSString*)text
{
    [m_Label setText:text];
}

- (void)handleTimer:(NSTimer*)timer
{
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if(self.hidden == NO)
    {
        [self CloseView:YES];
    }
}

-(void)StartAutoDisplay:(int)showSecond
{
    [NSTimer scheduledTimerWithTimeInterval:showSecond
                                    target:self
                                    selector:@selector(handleTimer:)
                                    userInfo:nil
                                    repeats:NO];


    if(self.hidden == YES)
    {
        [self OpenView:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
