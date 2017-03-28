//
//  MainToolbarView.m
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-04.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "MainToolbarView.h"
#import "GUIBasicConstant.h"
#import "GUIEventLoop.h"

@implementation MainToolbarView

- (void)CloseButtonClick
{
    [GUIEventLoop SendEvent:GUIID_TOOLBARVIEW_CLOSEBUTTON_CLICKDOWN eventSender:self];
}

- (void)FavoriteButtonClick
{
    [GUIEventLoop SendEvent:GUIID_FAVORITEBUTTON_ID eventSender:self];
}

- (void)SearchButtonClick
{
    [GUIEventLoop SendEvent:GUIID_SEARCHBUTTON_ID eventSender:self];
}

- (void)ClockButtonClick
{
    [GUIEventLoop SendEvent:GUIID_CALENDERBUTTON_ID eventSender:self];
}

- (void)PostButtonClick
{
    [GUIEventLoop SendEvent:GUIID_POSTBUTTON_ID eventSender:self];
}

- (void)SettingButtonClick
{
    [GUIEventLoop SendEvent:GUIID_SETTINGBUTTON_ID eventSender:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float size;
        CGRect rect;
        
        size = frame.size.height;
        float step = 2; //4;
        float w = size*3 + step*2;//size*5 + step*4;
        
        float sx = (frame.size.width - w)*0.5;
        rect = CGRectMake(sx, 0, size, size);
        
        rect = CGRectMake(sx, 0, size, size);
        m_SearchButton = [[UIButton alloc] initWithFrame:rect];
        m_SearchButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_SearchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_SearchButton setBackgroundImage:[UIImage imageNamed:@"find200.png"] forState:UIControlStateNormal];
        [m_SearchButton addTarget:self action:@selector(SearchButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_SearchButton];
        sx = sx + size + step;
        rect = CGRectMake(sx, 0, size, size);
        m_SettingButton = [[UIButton alloc] initWithFrame:rect];
        m_SettingButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_SettingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_SettingButton setBackgroundImage:[UIImage imageNamed:@"setting200.png"] forState:UIControlStateNormal];
        [m_SettingButton addTarget:self action:@selector(SettingButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_SettingButton];
        
        sx = sx + size + step;
        rect = CGRectMake(sx, 0, size, size);
        m_PostButton = [[UIButton alloc] initWithFrame:rect];
        m_PostButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_PostButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_PostButton setBackgroundImage:[UIImage imageNamed:@"post200.png"] forState:UIControlStateNormal];
        [m_PostButton addTarget:self action:@selector(PostButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_PostButton];
    }
    return self;
}

-(CGPoint)GetSearchButtonArchorPoint
{
    //float size = self.frame.size.height;
    //float step = 4;
    //float w = size*3 + step*2;
    
    //float sx = (self.frame.size.width - w)*0.5;
    
    //CGPoint pt = CGPointMake(sx + size*0.5, 0);
    CGPoint pt = CGPointMake(m_SearchButton.frame.origin.x + m_SearchButton.frame.size.width*0.5, 0);
    
    return pt;
}

-(CGPoint)GetPostButtonArchorPoint
{
//    float size = self.frame.size.height;
//    float step = 4;
//    float w = size*3 + step*2;
    
//    float sx = (self.frame.size.width - w)*0.5 + (size + step)*2;

//    CGPoint pt = CGPointMake(sx + size*0.5, 0);
    CGPoint pt = CGPointMake(m_PostButton.frame.origin.x + m_PostButton.frame.size.width*0.5, 0);
    
    return pt;
}

-(CGPoint)GetCalenderButtonArchorPoint
{
    float size = self.frame.size.height;
    float step = 4;
    float w = size*3 + step*2;
    
    float sx = (self.frame.size.width - w)*0.5 + size + step;
    
    CGPoint pt = CGPointMake(sx + size*0.5, 0);
    
    return pt;
}

-(CGPoint)GetFavoriteButtonArchorPoint
{
    float size = self.frame.size.height;
    float step = 4;
    float w = size*5 + step*4;
    
    float sx = (self.frame.size.width - w)*0.5;
    
    CGPoint pt = CGPointMake(sx + size*0.5, 0);
    
    return pt;
}

-(CGPoint)GetSettingButtonArchorPoint
{
    float sx = self.frame.size.width/2.0;
    
    CGPoint pt = CGPointMake(sx, 0);
    
    return pt;
}

- (void)UpdateLayout
{
    float size;
    CGRect rect;
    
    size = self.frame.size.height;
    float step = 2; //4;
    float w = size*3 + step*2;//size*5 + step*4;
    
    float sx = (self.frame.size.width - w)*0.5;
    rect = CGRectMake(sx, 0, size, size);
    
    [m_SearchButton setFrame:rect];
    sx = sx + size + step;
    rect = CGRectMake(sx, 0, size, size);
    [m_SettingButton setFrame:rect];
    
    sx = sx + size + step;
    rect = CGRectMake(sx, 0, size, size);
    [m_PostButton setFrame:rect];
}


@end
