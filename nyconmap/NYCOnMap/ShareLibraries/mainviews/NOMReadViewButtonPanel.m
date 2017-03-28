//
//  NOMReadViewButtonPanel.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMReadViewButtonPanel.h"
#import "NOMReadView.h"
#import "CustomImageButton.h"
#import "ImageLoader.h"
#import "DrawHelper2.h"

@interface NOMReadViewButtonPanel ()
{
    CustomImageButton*                   m_CancelBtn;
    CustomImageButton*                   m_OKBtn;
    CustomImageButton*                   m_ReportBtn;
}

@end

@implementation NOMReadViewButtonPanel

-(void)InitButtonPanel
{
    float fSize = [NOMReadView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    
    sx = self.frame.size.width - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_CancelBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_CancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_CancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_CancelBtn addTarget:self.superview action:@selector(OnCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_CancelBtn SetCustomImage:[DrawHelper2 CloneImage:[UIImage imageNamed:@"close200.png"].CGImage withFlip:YES]];
    [self addSubview:m_CancelBtn];

    
    sx -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_OKBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_OKBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OKBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_OKBtn addTarget:self.superview action:@selector(OnOKButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OKBtn SetCustomImage:[DrawHelper2 CloneImage:[UIImage imageNamed:@"ok200.png"].CGImage withFlip:YES]];
    [self addSubview:m_OKBtn];
    
    sx -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_ReportBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_ReportBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_ReportBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_ReportBtn addTarget:self.superview action:@selector(OnReportButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_ReportBtn SetCustomImage:[DrawHelper2 CloneImage:[UIImage imageNamed:@"reportbtn400.png"].CGImage withFlip:YES]];
    [self addSubview:m_ReportBtn];
    
    m_OKBtn.hidden = YES;
    m_ReportBtn.hidden = YES;
    
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
    float fSize = [NOMReadView GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    
    CGRect rect;
    
    sy = self.frame.size.height - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CancelBtn setFrame:rect];
    
    sy -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_OKBtn setFrame:rect];
    
    sy -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_ReportBtn setFrame:rect];
}

-(void)UpdateHorizontalLayout
{
    float fSize = [NOMReadView GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    
    CGRect rect;
    
    sx = self.frame.size.width - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CancelBtn setFrame:rect];
    
    sx -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_OKBtn setFrame:rect];
    
    sx -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_ReportBtn setFrame:rect];
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

-(void)SetOKButtonEnable:(BOOL)bEnable
{
    m_OKBtn.enabled = bEnable;
}

-(void)SetCancelButtonEnable:(BOOL)bEnable
{
    m_CancelBtn.enabled = bEnable;
}


@end
