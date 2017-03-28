//
//  NOMAddressFinderViewButtonPanel.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-11.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMAddressFinderViewButtonPanel.h"
#import "NOMAddressFinderView.h"
#import "NOMAppInfo.h"


@interface NOMAddressFinderViewButtonPanel ()
{
    UIButton*                   m_CheckBtn;
    UIButton*                   m_CancelBtn;
    UIButton*                   m_OKBtn;
}

@end

@implementation NOMAddressFinderViewButtonPanel

-(void)InitButtonPanel
{
    float fSize = [NOMAddressFinderView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    m_CheckBtn = [[UIButton alloc] initWithFrame:rect];
    m_CheckBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_CheckBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_CheckBtn addTarget:self.superview action:@selector(OnCheckButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_CheckBtn setBackgroundImage:[UIImage imageNamed:@"check200.png"] forState:UIControlStateNormal];
    [self addSubview:m_CheckBtn];
    
    sx = self.frame.size.width - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_OKBtn = [[UIButton alloc] initWithFrame:rect];
    m_OKBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OKBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_OKBtn addTarget:self.superview action:@selector(OnOKButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OKBtn setBackgroundImage:[UIImage imageNamed:@"ok200.png"] forState:UIControlStateNormal];
    [self addSubview:m_OKBtn];
    
    sx -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_CancelBtn = [[UIButton alloc] initWithFrame:rect];
    m_CancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_CancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_CancelBtn addTarget:self.superview action:@selector(OnCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_CancelBtn setBackgroundImage:[UIImage imageNamed:@"close200.png"] forState:UIControlStateNormal];
    [self addSubview:m_CancelBtn];
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
    float fSize = [NOMAddressFinderView GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;

    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CheckBtn setFrame:rect];

    sy = self.frame.size.height - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_OKBtn setFrame:rect];
    
    sy -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CancelBtn setFrame:rect];
}

-(void)UpdateHorizontalLayout
{
    float fSize = [NOMAddressFinderView GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CheckBtn setFrame:rect];
  
    sx = self.frame.size.width - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_OKBtn setFrame:rect];
    
    sx -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CancelBtn setFrame:rect];
}

-(void)UpdateLayout
{
    if(self.frame.size.width < self.frame.size.height)
    {
        [self UpdateVerticalLayout];
    }
    else
    {
        [self UpdateHorizontalLayout];
    }
}

-(void)SetCheckButtonEnable:(BOOL)bEnable
{
    m_CheckBtn.enabled = bEnable;
}

-(void)SetOKButtonEnable:(BOOL)bEnable
{
    m_OKBtn.enabled = bEnable;
}

-(void)SetCancelButtonEnable:(BOOL)bEnable
{
    m_CancelBtn.enabled = bEnable;
}

@end
