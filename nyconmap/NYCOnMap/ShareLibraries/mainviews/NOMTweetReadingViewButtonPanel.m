//
//  NOMTweetReadingViewButtonPanel.m
//  nyconmap
//
//  Created by ZXing on 2014-05-22.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTweetReadingViewButtonPanel.h"
#import "NOMTweetReadingView.h"
#import "CustomImageButton.h"
#import "ImageLoader.h"
#import "DrawHelper2.h"

@interface NOMTweetReadingViewButtonPanel()
{
    CustomImageButton*                   m_CloseBtn;
    CustomImageButton*                   m_RetweetBtn;
    CustomImageButton*                   m_LinkBtn;
}

@end



@implementation NOMTweetReadingViewButtonPanel


-(void)InitButtonPanel
{
    float fSize = [NOMTweetReadingView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    
    sx = self.frame.size.width - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_CloseBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_CloseBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_CloseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_CloseBtn addTarget:self.superview action:@selector(OnCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_CloseBtn SetCustomImage:[DrawHelper2 CloneImage:[UIImage imageNamed:@"close200.png"].CGImage withFlip:YES]];
    [self addSubview:m_CloseBtn];
    
    sx = 0;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_LinkBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_LinkBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_LinkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_LinkBtn addTarget:self.superview action:@selector(OnLinkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_LinkBtn SetCustomImage:CGImageRetain([UIImage imageNamed:@"weblink200.png"].CGImage)];
    [self addSubview:m_LinkBtn];
    
    sx += fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    m_RetweetBtn = [[CustomImageButton alloc] initWithFrame:rect];
    m_RetweetBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_RetweetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_RetweetBtn addTarget:self.superview action:@selector(OnRetweetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_RetweetBtn SetCustomImage:CGImageRetain([UIImage imageNamed:@"retweet200.png"].CGImage)]; //??????????????????????
    [self addSubview:m_RetweetBtn];
    
    [self UpdateLayout];
}

-(void)EnableLinkButton:(BOOL)bEnable
{
    if(bEnable == YES)
    {
        m_LinkBtn.hidden = NO;
    }
    else
    {
        m_LinkBtn.hidden = YES;
    }
}


-(void)EnableRetweetButton:(BOOL)bEnable
{
    if(bEnable == YES)
    {
        m_RetweetBtn.hidden = NO;
    }
    else
    {
        m_RetweetBtn.hidden = YES;
    }
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
    float fSize = [NOMTweetReadingView GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    
    CGRect rect;
    
    sy = self.frame.size.height - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CloseBtn setFrame:rect];
    
    sy = 0;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_LinkBtn setFrame:rect];
    
    sy += fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_RetweetBtn setFrame:rect];
}

-(void)UpdateHorizontalLayout
{
    float fSize = [NOMTweetReadingView GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    
    CGRect rect;
    
    sx = self.frame.size.width - fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_CloseBtn setFrame:rect];
    
    sx = 0;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_LinkBtn setFrame:rect];
    
    sx += fSize;
    rect = CGRectMake(sx, sy, fSize, fSize);
    [m_RetweetBtn setFrame:rect];
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

@end
