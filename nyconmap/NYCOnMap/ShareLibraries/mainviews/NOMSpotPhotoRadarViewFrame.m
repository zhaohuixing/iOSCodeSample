//
//  NOMSpotPhotoRadarViewFrame.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-24.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSpotPhotoRadarViewFrame.h"
#import "NOMSpotPhotoRadarContentView.h"

@interface NOMSpotPhotoRadarViewFrame ()
{
    NOMSpotPhotoRadarContentView*         m_SpotDetailView;
}

@end

@implementation NOMSpotPhotoRadarViewFrame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		self.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
		self.scrollEnabled = YES;
		[self setCanCancelContentTouches:NO];
		self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        CGRect rect = CGRectMake(0, 0, width, height);
        m_SpotDetailView = [[NOMSpotPhotoRadarContentView alloc] initWithFrame:rect];
        [self addSubview:m_SpotDetailView];
        [self UpdateLayout];
    }
    return self;
}

-(void)UpdateLayout
{
    float height = [m_SpotDetailView GetContentViewHeight];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, height);
    [m_SpotDetailView setFrame:rect];
    [m_SpotDetailView UpdateLayout];
	[self setContentSize:CGSizeMake(self.frame.size.width, height)];
}

-(void)ScrollViewTo:(float)scrollOffsetY
{
    CGPoint pt = CGPointMake(0, scrollOffsetY);
    [self setContentOffset:pt animated:YES];
}

-(void)RestoreScrollViewDefaultPosition
{
    CGPoint pt = CGPointMake(0, 0);
    [self setContentOffset:pt animated:YES];
}

-(void)Reset
{
    [m_SpotDetailView Reset];
}

-(void)SetType:(int16_t)nType
{
    [m_SpotDetailView SetType:nType];
}

-(void)SetDirection:(int16_t)nDir
{
    [m_SpotDetailView SetDirection:nDir];
}

-(void)SetSpeedCameraDeviceType:(int16_t)nType
{
    [m_SpotDetailView SetSpeedCameraDeviceType:nType];
}

-(void)SetAddress:(NSString*)address
{
    [m_SpotDetailView SetAddress:address];
}

-(int16_t)GetType
{
    return [m_SpotDetailView GetType];
}

-(int16_t)GetDirection
{
    return [m_SpotDetailView GetDirection];
}

-(int16_t)GetSpeedCameraDeviceType
{
    return [m_SpotDetailView GetSpeedCameraDeviceType];
}

-(NSString*)GetAddress
{
    return [m_SpotDetailView GetAddress];
}

-(void)SetFine:(double)dPrice
{
    [m_SpotDetailView SetFine:dPrice];
}

-(double)GetFine
{
    return [m_SpotDetailView GetFine];
}

@end
