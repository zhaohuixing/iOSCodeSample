//
//  NOMAddressFinderView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-11.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMAddressFinderView.h"
#import "NOMAddressFinderViewButtonPanel.h"
#import "NOMAddressFinderUIFrame.h"
#import "NOMAddressMapView.h"
#import "NOMAppInfo.h"

@interface NOMAddressFinderView ()
{
    NOMAddressFinderViewButtonPanel*        m_ButtonPanel;
    NOMAddressFinderUIFrame*                m_AddressInputView;
//!!!    NOMAddressMapView*                      m_AddressMapView;
    BOOL                                    m_bCloseViewByOK;
}


@end

@implementation NOMAddressFinderView

+(double)GetDefaultBasicUISize
{
    if([NOMAppInfo IsDeviceIPad])
        return 80;
    else
        return 50;
}

-(void)InitializeSubViews
{
    float fSize = [NOMAddressFinderView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width, sy);
    m_ButtonPanel = [[NOMAddressFinderViewButtonPanel alloc] initWithFrame:rect];
    [self addSubview:m_ButtonPanel];
    
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    rect = CGRectMake(0, 0, width, height);

    m_AddressInputView = [[NOMAddressFinderUIFrame alloc] initWithFrame:rect];
    [self addSubview:m_AddressInputView];
/*//!!!!!
    m_AddressMapView = [[NOMAddressMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:m_AddressMapView];
    [m_AddressMapView CloseView:NO];
*/
    [m_AddressInputView SetButtonPanel:m_ButtonPanel];

    [self UpdateLayout];
 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_ButtonPanel = nil;
        m_AddressInputView = nil;
//!!!        m_AddressMapView = nil;
        // Initialization code
        self.backgroundColor = [UIColor darkGrayColor];
        [self InitializeSubViews];
        m_bCloseViewByOK = NO;
    }
    return self;
}


-(void)OnCheckButtonClick
{
    [m_AddressInputView ValidateAddress];
}

-(void)HandleAddressViewClosed:(BOOL)bOK
{
    if([self.superview respondsToSelector:@selector(AddressFindingViewClosed:)] == YES)
    {
        SEL sel = @selector(AddressFindingViewClosed:);
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self.superview methodSignatureForSelector:sel]];
        [inv setSelector:sel];
        [inv setTarget:self.superview];
        [inv setArgument:&bOK atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [inv invoke];
    }
}

-(void)OnOKButtonClick
{
    m_bCloseViewByOK = YES;
    [self CloseView:YES];
}

-(void)OnCancelButtonClick
{
    m_bCloseViewByOK = NO;
    [self CloseView:YES];
}

-(void)OnViewClose
{
	self.hidden = YES;
	[self setAlpha:1.0];
	[[self superview] sendSubviewToBack:self];

    [self HandleAddressViewClosed:m_bCloseViewByOK];

}

-(void)CloseView:(BOOL)bAnimation
{
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[self setAlpha:0.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewClose)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
		[UIView commitAnimations];
	}
	else
	{
		[self OnViewClose];
	}
}

-(void)OnViewOpen
{
    //[self CleanControlState];
}

-(void)CleanControlState
{
    [m_AddressInputView CleanControlState];
}

-(void)OpenView:(BOOL)bAnimation
{
    m_bCloseViewByOK = NO;
    [self CleanControlState];
	self.hidden = NO;
	[[self superview] bringSubviewToFront:self];
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewOpen)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
		[UIView commitAnimations];
	}
	else
	{
		[self OnViewOpen];
	}
}

-(void)UpdateHorizontalLayout
{
    float fSize = [NOMAddressFinderView GetDefaultBasicUISize];
    float sx = self.frame.size.width - fSize;
    float sy = 0;
    
    CGRect rect = CGRectMake(sx, sy, fSize, self.frame.size.height);
    if(m_ButtonPanel != nil)
    {
        [m_ButtonPanel setFrame:rect];
        [m_ButtonPanel UpdateLayout];
    }
    
    float height = self.frame.size.height;
    float width = self.frame.size.width - fSize;
    
    rect = CGRectMake(0, 0, width, height);
    if(m_AddressInputView != nil)
    {
        [m_AddressInputView setFrame:rect];
        [m_AddressInputView UpdateLayout];
    }
    
    rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//!!!    if(m_AddressMapView != nil)
//!!!    {
//!!!        [m_AddressMapView setFrame:rect];
//!!!        [m_AddressMapView UpdateLayout];
//!!!    }
}


-(void)UpdateVerticalLayout
{
    float fSize = [NOMAddressFinderView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width, fSize);
    if(m_ButtonPanel != nil)
    {
        [m_ButtonPanel setFrame:rect];
        [m_ButtonPanel UpdateLayout];
    }

    float height = self.frame.size.height - fSize;
    float width = self.frame.size.width;
    
    rect = CGRectMake(0, 0, width, height);
    if(m_AddressInputView != nil)
    {
        [m_AddressInputView setFrame:rect];
        [m_AddressInputView UpdateLayout];
    }

    rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//!!!    if(m_AddressMapView != nil)
//!!!    {
//!!!        [m_AddressMapView setFrame:rect];
//!!!        [m_AddressMapView UpdateLayout];
//!!!    }
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

-(void)AddressValidationSuccessed
{
//!!!    if(m_AddressMapView != nil)
//!!!    {
//!!!        [m_AddressMapView SetLocation:[m_AddressInputView GetSelectedCoordinate]];
//!!!        [m_AddressMapView OpenView:YES];
//!!!    }
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
