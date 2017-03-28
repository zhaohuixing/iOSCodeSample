//
//  NOMReadView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMReadView.h"
#import "NOMReadViewButtonPanel.h"
#import "NOMReadUIFrame.h"
#import "NOMAppInfo.h"

@interface NOMReadView ()
{
    NOMReadViewButtonPanel*                 m_ButtonPanel;
    NOMReadUIFrame*                         m_ReadView;
    BOOL                                    m_bCloseViewByOK;
}

@end

@implementation NOMReadView

+(double)GetDefaultBasicUISize
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 40;
}

-(void)InitializeSubViews
{
    float fSize = [NOMReadView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width, sy);
    m_ButtonPanel = [[NOMReadViewButtonPanel alloc] initWithFrame:rect];
    [self addSubview:m_ButtonPanel];
    
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    rect = CGRectMake(0, 0, width, height);
    
    m_ReadView = [[NOMReadUIFrame alloc] initWithFrame:rect];
    [self addSubview:m_ReadView];
    
    
    [self UpdateLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor darkGrayColor];
        m_bCloseViewByOK = NO;
        [self InitializeSubViews];
    }
    return self;
}

-(void)UpdateLayout
{
    float fSize = [NOMReadView GetDefaultBasicUISize];
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
        [m_ReadView setFrame:rect];
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
        [m_ReadView setFrame:rect];
    }
    [m_ButtonPanel UpdateLayout];
    [m_ReadView UpdateLayout];
}

-(void)OnViewClose
{
	self.hidden = YES;
	[self setAlpha:1.0];
	[[self superview] sendSubviewToBack:self];
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
}

-(void)CleanControlState
{
    [m_ReadView CleanControlState];
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

-(void)OnReportButtonClick
{
    
}

-(void)SetSubject:(NSString*)szTitle
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetSubject:szTitle];
    }
}

-(void)SetAuthor:(NSString*)szAuthor
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetAuthor:szAuthor];
    }
}

-(void)SetPost:(NSString*)szPost
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetPost:szPost];
    }
}

-(void)SetKeywords:(NSString*)szKeywords
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetKeywords:szKeywords];
    }
}

-(void)SetCopyright:(NSString*)szCopyright
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetCopyright:szCopyright];
    }
}

-(void)SetGeographicKML:(NSString*)szKML
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetGeographicKML:szKML];
    }
}

-(void)SetImage:(UIImage*)image
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetImage:image];
    }
}

-(void)SetNewsData:(NOMNewsMetaDataRecord*)pData
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetNewsData:pData];
    }
}

-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetReferencePoint:dLat withLongitude:dLong withSpan:Span];
    }
}

@end
