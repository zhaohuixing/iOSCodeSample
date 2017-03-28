//
//  NOMTermAcceptViewButtonPanel.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTermAcceptViewButtonPanel.h"
#import "NOMTermAcceptView.h"
#import "CustomImageButton.h"
#import "ImageLoader.h"
//#include "drawhelper.h"
#import "NOMAppInfo.h"
#import "StringFactory.h"

@interface NOMTermAcceptViewButtonPanel ()
{
    UIButton*                    m_CancelBtn;
    UIButton*                    m_OKBtn;
}

@end

@implementation NOMTermAcceptViewButtonPanel

+(CGFloat)GetPanelMargin
{
    if([NOMAppInfo IsDeviceIPad])
        return 3;
    else
        return 2;
}

-(void)InitButtonPanel
{
    float fSize = [NOMTermAcceptViewButtonPanel GetPanelMargin];
    float sx = 0;
    float sy = fSize;
    float h = self.frame.size.height - 2.0*fSize;
    float w = 2.0*h;
    
    
    CGRect rect = CGRectMake(sx, sy, w, h);
    
    sx = self.frame.size.width - (fSize + w);
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_CancelBtn = [[UIButton alloc] initWithFrame:rect];
    [m_CancelBtn setBackgroundColor:[UIColor whiteColor]];
    m_CancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_CancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_CancelBtn addTarget:self.superview action:@selector(OnCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_CancelBtn setTitle:[StringFactory GetString_Close] forState:UIControlStateNormal];
    [m_CancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_CancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    m_CancelBtn.reversesTitleShadowWhenHighlighted = YES;
    [self addSubview:m_CancelBtn];

    
    sx -= (w + fSize);
    rect = CGRectMake(sx, sy, w, h);
    m_OKBtn = [[UIButton alloc] initWithFrame:rect];
    //[m_OKBtn setBackgroundColor:[UIColor greenColor]];
    m_OKBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OKBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_OKBtn addTarget:self.superview action:@selector(OnOKButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OKBtn setTitle:[StringFactory GetString_Accept] forState:UIControlStateNormal];
    
    m_OKBtn.backgroundColor = [UIColor colorWithRed:0.5 green:1.0 blue:0.5 alpha:1.0];
    [m_OKBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_OKBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    m_OKBtn.reversesTitleShadowWhenHighlighted = YES;
    
    [self addSubview:m_OKBtn];
    
    [self UpdateLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self InitButtonPanel];
    }
    return self;
}

-(void)UpdateVerticalLayout
{
    float fSize = [NOMTermAcceptViewButtonPanel GetPanelMargin];
    float sx = 0;
    float sy = fSize;
    float h = self.frame.size.height - 2.0*fSize;
    float w = 2.0*h;
    
    CGRect rect;
    
    sx = self.frame.size.width - (fSize + w);
    rect = CGRectMake(sx, sy, w, h);
    [m_CancelBtn setFrame:rect];
    
    sx -= (fSize + w);
    rect = CGRectMake(sx, sy, w, h);
    [m_OKBtn setFrame:rect];
    
}

-(void)UpdateLayout
{
    [self UpdateVerticalLayout];
}

-(void)ShowAcceptButton
{
    m_OKBtn.hidden = NO;
}

-(void)HideAcceptButton
{
    m_OKBtn.hidden = YES;
}

-(void)ShowCloseButton
{
    m_CancelBtn.hidden = NO;
}

-(void)HideCloseButton
{
    m_CancelBtn.hidden = YES;
}


@end
