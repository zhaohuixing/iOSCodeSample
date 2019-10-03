//
//  SpinnerBtn.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "SpinnerBtn.h"
#import "ApplicationConfigure.h"

@implementation SpinnerBtn

-(id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if(self)
    {
        if([ApplicationConfigure iPhoneDevice])
            m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        else
            m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
        m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:m_Spinner];
        [m_Spinner release];
        m_Spinner.center = CGPointMake(rect.size.width*0.5, rect.size.height*0.5);
    }
    
    return self;
}

-(void)StartSpin
{
    [self bringSubviewToFront:m_Spinner];
    m_Spinner.hidden = NO;
    [m_Spinner sizeToFit];
    [m_Spinner startAnimating];
    
    m_Spinner.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
}

-(void)StopSpin
{
    [m_Spinner stopAnimating];
    m_Spinner.hidden = YES;
}

-(void)HideButton
{
    [self StopSpin];
    self.hidden = YES;
}

@end
