//
//  MenuItemBase.m
//  xxxxx
//
//  Created by Zhaohui Xing on 11-03-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuItemBase.h"


@implementation MenuItemBase

- (BOOL)canBecomeFirstResponder 
{
	return YES;
}

-(id)initWithMeueID:(int)nID withFrame:(CGRect)frame withContainer:(id<MenuHolderTemplate>)p
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		m_nMenuID = nID;
		m_bEnable = YES;
		m_bSelected = NO;
		m_bCheckable = YES;
		m_bChecked = NO;
		m_Container = p;
		self.hidden = YES;
		
	}
    return self;
}

-(void)AssignMenuID:(int)nID
{
	m_nMenuID = nID;
}

-(int)GetMenuID
{
	return m_nMenuID;
}

-(void)OnMenuUpdate
{
}

-(void)Show
{
	self.hidden = NO;
	[self setNeedsDisplay];
}

-(void)Hide
{
	self.hidden = NO;
	[self setNeedsDisplay];
}	

-(void)SetSize:(float)w withHeight:(float)h
{
	CGRect rect = self.frame;
	rect.size.width = w;
	rect.size.height = h;
	[self setFrame:rect];
	[self setNeedsDisplay];
}	

-(float)GetWidth
{
	return self.frame.size.width;
}

-(float)GetHeight
{
	return self.frame.size.height;
}

-(void)Selected
{
	m_bSelected = YES;
	[self setNeedsDisplay];
}

-(void)UnSelected
{
	m_bSelected = NO;
	[self setNeedsDisplay];
}

-(void)Enable:(BOOL)bEnable
{
	m_bEnable = bEnable;
	[self setNeedsDisplay];
}

-(BOOL)IsEnable
{
	return m_bEnable; 
}

-(void)Checkable:(BOOL)bCheckable
{
	m_bCheckable = bCheckable;
	if(!m_bCheckable)
	{	
		m_bChecked = NO;
		[self setNeedsDisplay];
	}	
}

-(BOOL)IsCheckable
{
	return m_bCheckable; 
}

-(void)SetChecked:(BOOL)bChecked
{
	if(m_bCheckable)
	{	
		m_bChecked = bChecked;
		[self setNeedsDisplay];	
	}	
}

-(BOOL)IsChecked
{
	if(m_bCheckable)
	{	
		return m_bChecked;
	}	
	else
	{
		return NO;
	}
}

- (void)dealloc 
{
    [super dealloc];
}

- (void) touchesBegan : (NSSet*)touches withEvent: (UIEvent*)event
{
	if(m_Container != nil)
	{	
		if([m_Container respondsToSelector: @selector(UnSelectedAllMenuItems)]) 
			[m_Container UnSelectedAllMenuItems];
		[self Selected];
	}	
}	


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(m_bSelected)
	{	
		if(m_Container != nil)
		{	
			[self UnSelected];
			
			if([m_Container respondsToSelector: @selector(OnMenuEvent:)]) 
				[m_Container OnMenuEvent:m_nMenuID];
		}	
	}
	[self setNeedsDisplay];
}	

@end
