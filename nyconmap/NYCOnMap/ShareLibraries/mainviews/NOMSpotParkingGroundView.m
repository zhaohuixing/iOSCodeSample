//
//  NOMSpotParkingGroundView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSpotParkingGroundView.h"
#import "NOMSpotViewButtonPanel.h"
#import "NOMSpotParkingGroundViewFrame.h"
#import "NOMAppInfo.h"

@interface NOMSpotParkingGroundView ()
{
    NOMSpotViewButtonPanel*                             m_ButtonPanel;
    NOMSpotParkingGroundViewFrame*                      m_SpotView;
    BOOL                                                m_bCloseViewByOK;
    id<ISpotUIController>                               m_Controller;
}

@end

@implementation NOMSpotParkingGroundView

-(void)RegisterController:(id<ISpotUIController>)controller
{
    m_Controller = controller;
}

-(void)InitializeSubViews
{
    float fSize = [NOMSpotViewButtonPanel GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width, sy);
    m_ButtonPanel = [[NOMSpotViewButtonPanel alloc] initWithFrame:rect];
    [self addSubview:m_ButtonPanel];
    
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    rect = CGRectMake(0, 0, width, height);
    
    m_SpotView = [[NOMSpotParkingGroundViewFrame alloc] initWithFrame:rect];
    [self addSubview:m_SpotView];
    
    
    [self UpdateLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_Controller = nil;
        self.backgroundColor = [UIColor darkGrayColor];
        m_bCloseViewByOK = NO;
        [self InitializeSubViews];
    }
    return self;
}

-(void)UpdateLayout
{
    float fSize = [NOMSpotViewButtonPanel GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    float height;
    float width;
    
    CGRect rect;
    
    if(self.frame.size.width < self.frame.size.height)
    {
        sy = self.frame.size.height - fSize;
        
        rect = CGRectMake(sx, sy, self.frame.size.width, fSize);
        [m_ButtonPanel setFrame:rect];
        [m_ButtonPanel UpdateLayout];
        
        height = self.frame.size.height - fSize;
        width = self.frame.size.width;
        
        rect = CGRectMake(0, 0, width, height);
        [m_SpotView setFrame:rect];
    }
    else
    {
        sx = self.frame.size.width - fSize;
        sy = 0;
        
        rect = CGRectMake(sx, sy, fSize, self.frame.size.height);
        [m_ButtonPanel setFrame:rect];
        
        height = self.frame.size.height;
        width = self.frame.size.width - fSize;
        
        rect = CGRectMake(0, 0, width, height);
        [m_SpotView setFrame:rect];
    }
    [m_ButtonPanel UpdateLayout];
    [m_SpotView UpdateLayout];
}

-(void)OnViewClose
{
	self.hidden = YES;
	[self setAlpha:1.0];
	[[self superview] sendSubviewToBack:self];
    if(m_Controller != nil)
    {
        [m_Controller OnSpotUIClosed:self withResult:m_bCloseViewByOK];
    }
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
    //[m_PostView OpenView];
}


-(void)OpenView:(BOOL)bAnimation
{
    m_bCloseViewByOK = NO;
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

#ifdef DEBUG
-(void)OnDeleteButtonClick
{
	self.hidden = YES;
	[self setAlpha:1.0];
	[[self superview] sendSubviewToBack:self];
    if(m_Controller != nil)
    {
        [m_Controller OnSpotUIDeleteEvent:self];
    }
}
#endif


-(void)Reset
{
    [m_SpotView Reset];
}

-(void)SetAddress:(NSString*)address
{
    [m_SpotView SetAddress:address];
}

-(void)SetName:(NSString*)name
{
    [m_SpotView SetName:name];
}

-(void)SetRate:(double)dPrice
{
    [m_SpotView SetRate:dPrice];
}

-(void)SetRateUnit:(int16_t)nUnit
{
    [m_SpotView SetRateUnit:nUnit];
}

-(NSString*)GetAddress
{
    return [m_SpotView GetAddress];
}

-(NSString*)GetName
{
    return [m_SpotView GetName];
}

-(double)GetRate
{
    return [m_SpotView GetRate];
}

-(int16_t)GetRateUnit
{
    return [m_SpotView GetRateUnit];
}

-(BOOL)AllowTwitterShare
{
    BOOL bRet = YES;
    
    bRet = [m_ButtonPanel IsTwitterEnable];
    
    return bRet;
}

-(void)SetTwitterEnabling:(BOOL)bTwitterEnable
{
    [m_ButtonPanel SetTwitterEnabling:bTwitterEnable];
}

@end
