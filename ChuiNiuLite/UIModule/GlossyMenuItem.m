//
//  GlossyMenuItem.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlossyMenuItem.h"


@implementation GlossyMenuItem


-(id)initWithMeueID:(int)nID withFrame:(CGRect)frame withContainer:(id<MenuHolderTemplate>)p 
{
    
    self = [super initWithMeueID:nID withFrame:frame withContainer:p];
    if (self) 
	{
        // Initialization code.
		m_ImageNormal = NULL;
		m_ImageHighLight = NULL;
		m_ImageChecked = NULL;
		m_ImageCheckedHighLight = NULL;
    
		m_ptGroundZero = CGPointMake(0, 0);
		m_ptDestination = CGPointMake(0, 0);
		m_NormalSize = CGSizeMake(frame.size.width, frame.size.height);
		m_fDuration = 0.5; //in second, animation duration
		self.backgroundColor = [UIColor clearColor];
		m_bInFadeOut = NO;
		m_bReflection = YES;
		
	}
    return self;
}

- (CGImageRef)GetHighLightImage
{
	if([self IsChecked] && m_ImageCheckedHighLight != NULL)
		return m_ImageCheckedHighLight;
	
	return m_ImageHighLight; 
}

- (CGImageRef)GetNormalImage
{
	if([self IsChecked] && m_ImageChecked != NULL)
		return m_ImageChecked;
	return m_ImageNormal; 
}

- (void)DrawReflectButtonImage:(CGContextRef)context inRect:(CGRect)rect withImage:(CGImageRef)image
{
	CGContextRef layerDC;
	CGLayerRef   layerObj;
	float cy = rect.origin.y + rect.size.height;
	
	layerObj = CGLayerCreateWithContext(context, rect.size, NULL);
	layerDC = CGLayerGetContext(layerObj);
	CGContextSaveGState(layerDC);
	
	CGContextDrawImage(layerDC, rect, image);
	CGContextSaveGState(layerDC);
	CGContextTranslateCTM(layerDC, 0, cy+rect.size.height*0.35);
	CGContextScaleCTM(layerDC, 1, -0.35);
	CGContextSetAlpha(layerDC, 0.85);
	CGContextDrawImage(layerDC, rect, image);
	
	CGContextRestoreGState(layerDC);
	CGContextSaveGState(context);
	CGContextDrawLayerAtPoint(context, CGPointMake(0.0f, 0.0f), layerObj);
	CGContextRestoreGState(context);
	CGLayerRelease(layerObj);
}	

- (void)DrawButtonHighLight:(CGContextRef)context inRect:(CGRect)rect
{
	CGImageRef image = [self GetHighLightImage];
	if(image)
	{	
		//if(m_bReflection)
		//{
		//	[self DrawReflectButtonImage:context inRect:rect withImage:image];
		//}
		//else
		//{	
			CGContextDrawImage(context, rect, image);
		//}	
	}	
    image = NULL;
}	

- (void)DrawButtonNormal:(CGContextRef)context inRect:(CGRect)rect
{
	CGImageRef image = [self GetNormalImage];
	if(image)
	{	
		//if(m_bReflection)
		//{
		//	[self DrawReflectButtonImage:context inRect:rect withImage:image];
		//}
		//else
		//{	
			CGContextDrawImage(context, rect, image);
		//}	
	}	
    image = NULL;
}	

- (void)DrawButton:(CGContextRef)context inRect:(CGRect)rect
{
	if(m_bSelected)
	{
		[self DrawButtonHighLight:context inRect: rect];
	}
	else 
	{
		[self DrawButtonNormal:context inRect: rect];
	}
}	


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self DrawButton:context inRect: rect];
}


- (void)dealloc 
{
	if(m_ImageNormal != NULL)
		CGImageRelease(m_ImageNormal);
	
	if(m_ImageHighLight != NULL)
		CGImageRelease(m_ImageHighLight);
		
	if(m_ImageChecked != NULL)
		CGImageRelease(m_ImageChecked);
	
	if(m_ImageCheckedHighLight != NULL)
		CGImageRelease(m_ImageCheckedHighLight);
	
    [super dealloc];
}

-(void)RegisterNormalImage:(NSString*)src
{
	UIImage* orgImagge = [UIImage imageNamed:src];
	if(orgImagge != nil)
	{
		if(m_ImageNormal != NULL)
			CGImageRelease(m_ImageNormal);
		m_ImageNormal  = CGImageRetain(orgImagge.CGImage);
	}	
}

-(void)RegisterHighLightImage:(NSString*)src
{
	UIImage* orgImagge = [UIImage imageNamed:src];
	if(orgImagge != nil)
	{ 
		if(m_ImageHighLight != NULL)
			CGImageRelease(m_ImageHighLight);
		m_ImageHighLight  = CGImageRetain(orgImagge.CGImage);
	}	
}

-(void)RegisterCheckedImage:(NSString*)src
{
	UIImage* orgImagge = [UIImage imageNamed:src];
	if(orgImagge != nil)
	{
		if(m_ImageChecked != NULL)
			CGImageRelease(m_ImageChecked);
		m_ImageChecked  = CGImageRetain(orgImagge.CGImage);
	}	
}

-(void)RegisterCheckedHighLightImage:(NSString*)src
{
	UIImage* orgImagge = [UIImage imageNamed:src];
	if(orgImagge != nil)
	{
		if(m_ImageCheckedHighLight != NULL)
			CGImageRelease(m_ImageCheckedHighLight);
		m_ImageCheckedHighLight  = CGImageRetain(orgImagge.CGImage);
	}	
}	

-(void)SetAnimationDuration:(float)fSecond
{
	m_fDuration = fSecond; //in second, animation duration
}

-(void)SetNormalCenter:(CGPoint)center
{
	m_ptDestination.x = center.x;
	m_ptDestination.y = center.y;
	if(m_bInFadeOut == NO && self.hidden == NO)
	{
		[self setFrame:CGRectMake(m_ptDestination.x-m_NormalSize.width/2, m_ptDestination.y-m_NormalSize.height/2, m_NormalSize.width, m_NormalSize.height)];
	}	
}

-(void)SetGroundZero:(CGPoint)zero
{
	m_ptGroundZero.x = zero.x;
	m_ptGroundZero.y = zero.y;
}	

-(void)Reset
{
	[self setFrame:CGRectMake(m_ptGroundZero.x, m_ptGroundZero.y, 1, 1)];
	self.hidden = YES;
	self.alpha = 0.0;
}	

-(void)Show
{
	[self FadeIn];
}

-(void)Hide
{
	[self FadeOut];
}

-(void)FadeIn
{
	m_bInFadeOut = NO;
	self.hidden = NO;
	[self setNeedsDisplay];
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:m_fDuration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(FadeInDone)];
	[self setAlpha:1.0];
	[self setFrame:CGRectMake(m_ptDestination.x-m_NormalSize.width/2, m_ptDestination.y-m_NormalSize.height/2, m_NormalSize.width, m_NormalSize.height)];
	[UIView commitAnimations];
}

-(void)FadeOut
{
	m_bInFadeOut = YES;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:m_fDuration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(FadeOutDone)];
	[self setAlpha:0.0];
	[self setFrame:CGRectMake(m_ptGroundZero.x, m_ptGroundZero.y, 1, 1)];
	[UIView commitAnimations];
}

-(void)FadeInDone
{
	[self setFrame:CGRectMake(m_ptDestination.x-m_NormalSize.width/2, m_ptDestination.y-m_NormalSize.height/2, m_NormalSize.width, m_NormalSize.height)];
	[self setNeedsDisplay];
	if(m_Container != nil)
	{	
		if([m_Container respondsToSelector: @selector(OnMenuItemShow:)]) 
			[m_Container OnMenuItemShow:m_nMenuID];
	}	
}

-(void)FadeOutDone
{
	self.hidden = YES;
	m_bInFadeOut = NO;
	if(m_Container != nil)
	{	
		if([m_Container respondsToSelector: @selector(OnMenuItemHide:)]) 
			[m_Container OnMenuItemHide:m_nMenuID];
	}	
}	

-(void)SetCoolVisual:(BOOL)bEnable
{
	m_bReflection = bEnable;
	[self setNeedsDisplay];
}


@end
