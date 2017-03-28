//
//  NOMAddressFinderUIFrame.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-11.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMAddressFinderUIFrame.h"
#import "NOMAddressFinderUICore.h"

@interface NOMAddressFinderUIFrame ()
{
    NOMAddressFinderUICore*         m_AddressInputView;
}

@end

@implementation NOMAddressFinderUIFrame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
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
        float height = [NOMAddressFinderUICore GetViewLayoutHeight];
        CGRect rect = CGRectMake(0, 0, width, height);
        m_AddressInputView = [[NOMAddressFinderUICore alloc] initWithFrame:rect];
        [self addSubview:m_AddressInputView];
        [self UpdateLayout];
    }
    return self;
}


-(void)UpdateLayout
{
    float width = self.frame.size.width;
    float height = [NOMAddressFinderUICore GetViewLayoutHeight];
    CGRect rect = CGRectMake(0, 0, width, height);
    [m_AddressInputView setFrame:rect];
    [m_AddressInputView UpdateLayout];
	[self setContentSize:CGSizeMake(width, height)];
    
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

-(void)SetButtonPanel:(NOMAddressFinderViewButtonPanel*)panel
{
    [m_AddressInputView SetButtonPanel:panel];
}

-(void)ValidateAddress
{
    [m_AddressInputView ValidateAddress];
}

-(void)AddressValidationSuccessed
{
    if([self.superview respondsToSelector:@selector(AddressValidationSuccessed)] == YES)
    {
        [self.superview performSelector:@selector(AddressValidationSuccessed)];
    }
}

-(void)CleanControlState
{
    [m_AddressInputView CleanControlState];
}

-(CLLocationCoordinate2D)GetSelectedCoordinate
{
    return [m_AddressInputView GetSelectedCoordinate];
}

-(NSString*)GetStreetAddress
{
    return [m_AddressInputView GetStreetAddress];
}

-(NSString*)GetCity
{
    return [m_AddressInputView GetCity];
}

-(NSString*)GetState
{
    return [m_AddressInputView GetState];
}

-(NSString*)GetZipCode
{
    return [m_AddressInputView GetZipCode];
}

-(NSString*)GetCountry
{
    return [m_AddressInputView GetCountry];
}

-(NSString*)GetCountryKey
{
    return [m_AddressInputView GetCountryKey];
}

@end
