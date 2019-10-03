//
//  GlossyMenu.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlossyMenu.h"


@implementation GlossyMenu

-(id)initByParent:(id<MenuViewTemplate>)pView
{
	self = [super init];
	if(self != nil)
	{
		m_Parent = pView;
        m_MenuItems = [[NSMutableArray alloc] init];
	}
	return self;
}	

-(void)AddMenuItem:(GlossyMenuItem*)item
{
	[m_MenuItems addObject:item];
}	

- (void)dealloc 
{
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			GlossyMenuItem* p = (GlossyMenuItem*)[m_MenuItems objectAtIndex:i];
			if(p)
			{
                [p removeFromSuperview];
			}	
		}	
	}	
	[m_MenuItems removeAllObjects];
}

-(void)AssignControlID:(int)nID
{
	m_nMenuID = nID;
}

-(int)GetControlID
{
	return 	m_nMenuID;
}

-(void)Show
{
	[self FadeIn];
}

-(void)Hide
{
	[self FadeOut];
}

-(int)GetMenuItemCount
{
	int nCount = (int)[m_MenuItems count];
	return nCount;
}	

-(id<MenuItemTemplate>)GetMenuItemAt:(int)index
{
	GlossyMenuItem* pMenu = nil;
	
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount && index < nCount)
	{
		pMenu = (GlossyMenuItem*)[m_MenuItems objectAtIndex:index];
	}	
		
	return pMenu;
}	

-(id<MenuItemTemplate>)GetMenuItem:(int)nControlID
{
	GlossyMenuItem* pMenu = nil;

	int nCount = (int)[m_MenuItems count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			GlossyMenuItem* p = (GlossyMenuItem*)[m_MenuItems objectAtIndex:i];
			if(p && [p GetMenuID] == nControlID)
			{
				pMenu = p;
				break;
			}	
		}	
	}	
	
	return pMenu;
}	

-(void)SetPopupPosition:(float)x withY:(float)y
{
}	

-(void)UnSelectedAllMenuItems
{
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			[(GlossyMenuItem*)[m_MenuItems objectAtIndex:i] UnSelected];
		}	
	}	
}	

-(void)OnMenuEvent:(int)menuID
{
	if(m_Parent != nil)
	{
		if([m_Parent respondsToSelector: @selector(OnMenuEvent:)]) 
			[m_Parent OnMenuEvent:menuID];
	}	
}	

-(void)SetVerticalDirection
{
}

-(void)SetHorizontalDirection
{
}	

-(void)DoFadeInAnimation
{
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount && m_nFrameIndex < nCount)
	{
		[(GlossyMenuItem*)[m_MenuItems objectAtIndex:m_nFrameIndex] FadeIn];
	}
	else 
	{
		if(0 < m_nFrameIndex)
		{	
			m_bShow = YES;
			if(m_Parent != nil)
			{
				if([m_Parent respondsToSelector: @selector(OnMenuShow)]) 
					[m_Parent OnMenuShow];
			}	
		}	
	}
}	

-(void)DoFadeOutAnimation
{
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount && m_nFrameIndex < nCount && 0 <= m_nFrameIndex)
	{
		[(GlossyMenuItem*)[m_MenuItems objectAtIndex:m_nFrameIndex] FadeOut];
	}
	else 
	{
		if(m_nFrameIndex < 0)
		{	
			m_bShow = NO;
			if(m_Parent != nil)
			{
				if([m_Parent respondsToSelector: @selector(OnMenuHide)]) 
					[m_Parent OnMenuHide];
			}	
		}	
	}
}

-(void)OnMenuItemShow:(int)menuID
{
	++m_nFrameIndex;
	[self DoFadeInAnimation];
}	

-(void)OnMenuItemHide:(int)menuID
{
	--m_nFrameIndex;
	[self DoFadeOutAnimation];
}

-(void)FadeIn
{
	m_nFrameIndex = 0;
	[self DoFadeInAnimation];
}

-(void)FadeOut
{
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount)
	{
		m_nFrameIndex = nCount-1;
		[self DoFadeOutAnimation];
	}	
}	

-(void)Reset
{
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			[(GlossyMenuItem*)[m_MenuItems objectAtIndex:i] Reset];
		}	
	}	
}	

-(void)SetMenuItem:(int)index atCenter:(CGPoint)pt
{
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount && 0 <= index && index < nCount)
	{
		[(GlossyMenuItem*)[m_MenuItems objectAtIndex:index] SetNormalCenter:pt];
	}	
}	

-(void)SetMenuItemGroundZero:(int)index atPoint:(CGPoint)pt
{
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount && 0 <= index && index < nCount)
	{
		[(GlossyMenuItem*)[m_MenuItems objectAtIndex:index] SetGroundZero:pt];
	}	
}

-(void)RemoveMenuItem:(int)nMenuID
{
	int nCount = (int)[m_MenuItems count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			GlossyMenuItem* p = (GlossyMenuItem*)[m_MenuItems objectAtIndex:i];
			if(p && [p GetMenuID] == nMenuID)
			{
                p.hidden = YES;
                [m_MenuItems removeObjectAtIndex:i];
                [p removeFromSuperview];
				break;
			}	
		}	
	}	
}

@end
