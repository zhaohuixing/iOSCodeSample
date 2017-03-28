//
//  ReviewPrivacyView.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-09-07.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "ReviewPrivacyView.h"
#import "StringFactory.h"
#import "NOMGUILayout.h"

@implementation ReviewPrivacyView

-(float)GetViewEdge
{
//??    if([SystemConfiguration IsDeviceIPad])
//??        return 4;
//??    else
        return 2;
}

-(float)GetButtonHeight
{
//??    if([SystemConfiguration IsDeviceIPad])
//??        return 70;
//??    else
        return 50;
}

-(float)GetButtonWidth
{
//??    if([SystemConfiguration IsDeviceIPad])
//??        return 120;
//??    else
        return 80;
}

-(void)InitContentView
{
    float size = [self GetViewEdge];
    float sx = size;
    float sy = size;
    float h = self.frame.size.height - [self GetButtonHeight] - 3*size;
    float w = self.frame.size.width - 2*size;
    CGRect rect = CGRectMake(sx, sy, w, h);
    m_ContentView = [[UITextView alloc] initWithFrame:rect];
    [m_ContentView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [m_ContentView setEditable:NO];
    m_ContentView.scrollEnabled = YES;
    m_ContentView.backgroundColor = [UIColor whiteColor];
    m_ContentView.font = [UIFont systemFontOfSize:16];
    [self addSubview:m_ContentView];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"txt"];
    NSError *err = nil;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&err];
    if (fileContents == nil)
    {
        NSLog(@"Error reading %@: %@", filePath, err);
    } else
    {
        m_ContentView.text = fileContents;
    }
}

-(void)InitButtons
{
    float size = [self GetViewEdge];
    float h = [self GetButtonHeight];
    float w = [self GetButtonWidth];
    float sx = self.frame.size.width - w - size;
    float sy = self.frame.size.height - h - size;
    CGRect rect = CGRectMake(sx, sy, w, h);
    m_CloseButton = [[CustomGlossyButton alloc] initWithFrame:rect];
    [m_CloseButton SetGreenDisplay];
    [m_CloseButton RegisterButton:self withID:ALERT_OK withLabel:[StringFactory GetString_Close]];
    [self addSubview:m_CloseButton];
}

-(void)OnButtonClick:(int)nButtonID
{
    [self CloseView:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
        [self InitContentView];
        [self InitButtons];
    }
    return self;
}

-(void)OnViewClosed
{
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
}

-(void)CloseView:(BOOL)bAnimated
{
    if (bAnimated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(OnViewClosed)];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        self.hidden = YES;
        [UIView commitAnimations];
    }
    else
    {
        [self OnViewClosed];
    }
}

-(void)ForceCloseView
{
    self.hidden = YES;
}

-(void)OnViewShow
{
}

-(void)Flyin
{
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnViewShow)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];
}

-(void)OpenView:(BOOL)bAnimated
{
    if(bAnimated)
    {
        [self Flyin];
    }
    else
    {
        self.hidden = NO;
        [self.superview bringSubviewToFront:self];
        [self OnViewShow];
    }
}

@end
