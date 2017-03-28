//
//  NOMSpotViewButtonPanel.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-24.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSpotPhotoRadarView.h"
#import "NOMSpotViewButtonPanel.h"
#import "CustomImageButton.h"
#import "ImageLoader.h"
#import "NOMAppInfo.h"
#import "DualStateButton.h"
#import "DrawHelper2.h"

@interface NOMSpotViewButtonPanel ()
{
    CustomImageButton*                   m_CancelBtn;
    CustomImageButton*                   m_OKBtn;
    DualStateButton*                     m_TwitterBtn;
    
    
#ifdef DEBUG
    CustomImageButton*                   m_DeleteBtn;
#endif
}

@end

@implementation NOMSpotViewButtonPanel

+(double)GetDefaultBasicUISize
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 40;
}

-(void)OnTwitterButtonClick
{
    [m_TwitterBtn UpdateState];
}


-(void)InitButtonPanel
{
    float fSize = [NOMSpotViewButtonPanel GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    
    sx = self.frame.size.width - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_OKBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_OKBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OKBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_OKBtn addTarget:self.superview action:@selector(OnOKButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OKBtn SetCustomImage:[DrawHelper2 CloneImage:[UIImage imageNamed:@"ok200.png"].CGImage withFlip:YES]];
    [self addSubview:m_OKBtn];
    
    sx -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_CancelBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_CancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_CancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_CancelBtn addTarget:self.superview action:@selector(OnCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_CancelBtn SetCustomImage:[DrawHelper2 CloneImage:[UIImage imageNamed:@"close200.png"].CGImage withFlip:YES]];
    [self addSubview:m_CancelBtn];
    
    sx = 0;
    sy = 0;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_TwitterBtn = [[DualStateButton alloc] initWithFrame:rect];
    
    CGImageRef twitterEnable = [ImageLoader LoadImageWithName:@"twitterenablebtn.png"];
    CGImageRef twitterDisable = [ImageLoader LoadImageWithName:@"twitterdisablebtn.png"];
    [m_TwitterBtn SetImage:twitterEnable Image2:twitterDisable];
    [m_TwitterBtn addTarget:self action:@selector(OnTwitterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:m_TwitterBtn];

    //???????????????????
    //???????????????????
    //???????????????????
    //???????????????????
    //???????????????????
    m_TwitterBtn.hidden = YES;
    
#ifdef DEBUG
    sx += fSize;
    sy = 0;
    
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_DeleteBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_DeleteBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_DeleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_DeleteBtn addTarget:self.superview action:@selector(OnDeleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_DeleteBtn SetCustomImage:[DrawHelper2 CloneImage:[UIImage imageNamed:@"bclosebtn200.png"].CGImage withFlip:YES]];
    [self addSubview:m_DeleteBtn];

    //???????????????????
    //???????????????????
    //???????????????????
    //???????????????????
    //???????????????????
    m_DeleteBtn.hidden = YES;
#endif
    
    
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
    float fSize = [NOMSpotViewButtonPanel GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    
    CGRect rect;
    
    sy = self.frame.size.height - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_OKBtn setFrame:rect];
    
    sy -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CancelBtn setFrame:rect];
    
    sx = 0;
    sy = 0;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_TwitterBtn setFrame:rect];
    
#ifdef DEBUG
    sx = 0;
    sy += fSize;
    
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_DeleteBtn setFrame:rect];
    
    
    //???????????????????
    //???????????????????
    //???????????????????
    //???????????????????
    //???????????????????
    m_DeleteBtn.hidden = YES;
    
#endif
}

-(void)UpdateHorizontalLayout
{
    float fSize = [NOMSpotViewButtonPanel GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    
    CGRect rect;
    
    sx = self.frame.size.width - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_OKBtn setFrame:rect];
    
    sx -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CancelBtn setFrame:rect];

    sx = 0;
    sy = 0;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_TwitterBtn setFrame:rect];
    
#ifdef DEBUG
    sx += fSize;
    sy = 0;
    
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_DeleteBtn setFrame:rect];
#endif
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

-(BOOL)IsTwitterEnable
{
    if(m_TwitterBtn.hidden == YES)
        return NO;
    
    int nBtnState = [m_TwitterBtn GetState];
    BOOL bEnable = (nBtnState == 0);
    return bEnable;
}

-(void)SetTwitterEnabling:(BOOL)bTwitterEnable
{
    m_TwitterBtn.hidden = !(bTwitterEnable == YES);
    
    if(m_TwitterBtn.hidden == NO)
    {
        [m_TwitterBtn SetState:0];
    }
}

@end
