//
//  NOMSpotGasStationViewFrame.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMSpotGasStationViewFrame.h"
#import "NOMSpotGasStationContentView.h"

@interface NOMSpotGasStationViewFrame ()
{
    NOMSpotGasStationContentView*         m_SpotDetailView;
}

@end

@implementation NOMSpotGasStationViewFrame

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
        m_SpotDetailView = [[NOMSpotGasStationContentView alloc] initWithFrame:rect];
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

-(void)SetCarWashType:(int16_t)nType
{
    [m_SpotDetailView SetCarWashType:nType];
}

-(void)SetAddress:(NSString*)address
{
    [m_SpotDetailView SetAddress:address];
}

-(void)SetName:(NSString*)name
{
    [m_SpotDetailView SetName:name];
}

-(void)SetPrice:(double)dPrice
{
    [m_SpotDetailView SetPrice:dPrice];
}

-(void)SetPriceUnit:(int16_t)nUnit
{
    [m_SpotDetailView SetPriceUnit:nUnit];
}

-(int16_t)GetCarWashType
{
    return [m_SpotDetailView GetCarWashType];
}

-(NSString*)GetAddress
{
    return [m_SpotDetailView GetAddress];
}

-(NSString*)GetName
{
    return [m_SpotDetailView GetName];
}

-(double)GetPrice
{
    return [m_SpotDetailView GetPrice];
}

-(int16_t)GetPriceUnit
{
    return [m_SpotDetailView GetPriceUnit];
}

@end
