//
//  NOMPostViewButtonPanel.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMPostViewButtonPanel.h"
#import "NOMPostView.h"
#import "DualStateButton.h"
#import "ImageLoader.h"
#import "CustomImageButton.h"
#import "DrawHelper2.h"

@interface NOMPostViewButtonPanel ()
{
    CustomImageButton*                   m_CancelBtn;
    CustomImageButton*                   m_OKBtn;
    DualStateButton*                     m_TwitterBtn;
}

@end


@implementation NOMPostViewButtonPanel

-(void)OnTwitterButtonClick
{
    [m_TwitterBtn UpdateState];
}

-(void)InitButtonPanel
{
    float fSize = [NOMPostView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    
    sx = self.frame.size.width - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_OKBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_OKBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OKBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_OKBtn addTarget:self.superview action:@selector(OnOKButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //[m_OKBtn setBackgroundImage:[UIImage imageNamed:@"ok200.png"] forState:UIControlStateNormal];
    [m_OKBtn SetCustomImage:[DrawHelper2 CloneImage:[UIImage imageNamed:@"ok200.png"].CGImage withFlip:YES]];
    [self addSubview:m_OKBtn];
    
    sx -= fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_CancelBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_CancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_CancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_CancelBtn addTarget:self.superview action:@selector(OnCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //[m_CancelBtn setBackgroundImage:[UIImage imageNamed:@"close200.png"] forState:UIControlStateNormal];
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
    float fSize = [NOMPostView GetDefaultBasicUISize];
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
    
}

-(void)UpdateHorizontalLayout
{
    float fSize = [NOMPostView GetDefaultBasicUISize];
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

-(BOOL)IsTwitterEnable
{
    if(m_TwitterBtn.hidden == YES)
        return NO;
    
    int nBtnState = [m_TwitterBtn GetState];
    BOOL bEnable = (nBtnState == 0);
    return bEnable;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if([self.superview respondsToSelector:@selector(HideKeyboard)] == YES)
    {
        [self.superview performSelector:@selector(HideKeyboard)];
    }
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
