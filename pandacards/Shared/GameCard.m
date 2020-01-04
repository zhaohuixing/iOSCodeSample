//
//  GameCard.m
//  Mindfire
//
//  Created by ZXing on 24/10/2009.
//  Copyright 2009 Zhaohui Xing. All rights reserved.
//
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#include "GameUtility.h"
#include "GameState.h"
#import "GameCard.h"
#import "RenderHelper.h"
#import "CGameLayout.h"


@implementation GameCard

@synthesize m_Card;

- (void)dealloc 
{
	if(m_TempCardImage != NULL)
	{
		CGImageRelease(m_TempCardImage);
		m_TempCardImage = NULL;
	}	
    [super dealloc];
}

- (id)initCard:(int)nCard withRect:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        // Custom initialization
		m_TempCardImage = NULL;
		m_Card = nCard;
		if(IsTempCard(m_Card)==1)
		{
			[self LoadTempCardImages];
		}	
		m_bHighlight = NO;	
		m_bDragDrop = NO;
		m_ptCursor.x = 0;
		m_ptCursor.y = 0;
		m_bShow = YES;
		m_CardState = GAME_CARD_STATE_NONE;
    }
    return self;
}

- (void)SetHighlight:(BOOL)bHighlight
{
	m_bHighlight = bHighlight;
	[self setNeedsDisplay];
}	

- (void)SetCard:(int)nCard
{
	m_Card = nCard;
	if(IsTempCard(m_Card)==1)
	{
		[self LoadTempCardImages];
	}	
    [self setNeedsDisplay];
}

- (BOOL)IsValid
{
	BOOL bRet = YES;
	if(GetCardType(m_Card) == CARD_INVALID)
		bRet = NO;
	
	return bRet;
}	

- (int)GetCard
{
	return m_Card;
}

- (int)GetCardIndex
{
	return m_Card;
}

- (int)GetCardValue
{
	int nRet  = GetCardValue(m_Card);
	return nRet;	
}

- (int)GetCardtype
{
	int nRet  = GetCardType(m_Card);
	return nRet;	
}	

- (int)GetViewType
{
	return GAME_VIEW_CARD;
}	

- (BOOL)IsBasicCard
{
	BOOL bRet = YES;
	int nType = [self GetCardtype];
	if(nType == CARD_TEMPCARD || nType == CARD_INVALID)
	{
		bRet = NO;
	}	
	return bRet;
}

- (BOOL)IsTempCard
{
	BOOL bRet = NO;
	int nType = [self GetCardtype];
	if(nType == CARD_TEMPCARD)
	{
		bRet = YES;
	}	
	return bRet;
}	

- (void)OnTimerEvent
{
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect 
{
	if(m_bShow == NO)
		return;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if(IsBasicCard(m_Card) == 1)
	{	
		[RenderHelper DrawBasicCardAnimation:context withCard:m_Card inRect:rect witHit:m_bHighlight];
	}
	else if(IsTempCard(m_Card) == 1)
	{
		[RenderHelper DrawTempCard:context withImage:m_TempCardImage inRect:rect witHit:m_bHighlight];
	}
}	

- (void)LoadTempCardImages
{
	if(m_TempCardImage != NULL)
	{
		CGImageRelease(m_TempCardImage);
		m_TempCardImage = NULL;
	}	
	m_TempCardImage = [RenderHelper GetTempCardImage_p:m_Card];
}


- (void)UpdateNonTouchBasicCardLayout:(int)i
{
	if(m_bShow == NO)
		return;
	
	CGRect rect;
	if([self AsOperand1] == YES)
	{
		rect = [CGameLayout GetOperand1Rect];
	}
	else if([self AsOperand2] == YES)
	{
		rect = [CGameLayout GetOperand2Rect];
	}
	else 
	{
		rect = [CGameLayout GetBasicCardRect:i];
	}

	[self setFrame:rect];
	//NSLog(@"UpdateNonTouchBasicCardLayout:%i, x:%f, y:%f, width:%f, height:%f", i, rect.origin.x, rect.origin.y, rect.size.x, rect.size.y);  
}

- (void)UpdateNonTouchTempCardLayout:(int)i
{
	if(m_bShow == NO)
		return;
	CGRect rect;
	
	//????????????????????????????????????????????
	//????????????????????????????????????????????
	//????????????????????????????????????????????
	//????????????????????????????????????????????
	//if([self IsInOperand1] == YES)
	if([self AsOperand1] == YES)
	{
		rect = [CGameLayout GetOperand1Rect];
	}
	//else if([self IsInOperand2] == YES)
	else if([self AsOperand2] == YES)
	{
		rect = [CGameLayout GetOperand2Rect];
	}
	//else if([self IsInResult] == YES)
	else if([self AsResult] == YES)
	{
		rect = [CGameLayout GetResultRect];
	}
	else 
	{
		rect = [CGameLayout GetTempCardRect:i];
	}
	//????????????????????????????????????????????
	//????????????????????????????????????????????
	//????????????????????????????????????????????
	//????????????????????????????????????????????
	
	[self setFrame:rect];
	//NSLog(@"UpdateNonTouchTempCardLayout:%i, x:%f, y:%f, width:%f, height:%f", i, rect.origin.x, rect.origin.y, rect.size.x, rect.size.y);  
}	
	
- (void)UpdateNonTouchLayout:(int)i
{
	if([self IsBasicCard] == YES)
	{
		[self UpdateNonTouchBasicCardLayout:i];
	}
	else 
	{
		[self UpdateNonTouchTempCardLayout:i];
	}
	[self setNeedsDisplay];
}

- (void)UpdateTouchedLayout
{
	CGRect rect = self.frame;
	
	NSLog(@"UpdateTouchedLayout old rect:x:%f, y:%f, width:%f, height:%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);  
	
	CGPoint oldcenter;
	oldcenter.x = rect.origin.x + rect.size.width/2.0;
	oldcenter.y = rect.origin.y + rect.size.height/2.0;
	NSLog(@"UpdateTouchedLayout old center:x:%f, y:%f", oldcenter.x, oldcenter.y);  
    CGPoint newcenter;
	CGPoint newCursor;
	if([GUILayout IsLandscape])
	{
		newcenter = [CGameLayout ChangeToLandscape:oldcenter];
		NSLog(@"UpdateTouchedLayout new center of landscape:x:%f, y:%f", newcenter.x, newcenter.y);  
		
		if(m_bDragDrop == YES)
		{	
			NSLog(@"UpdateTouchedLayout old cursor:x:%f, y:%f", m_ptCursor.x, m_ptCursor.y);  
			newCursor = [CGameLayout ChangeToLandscape:m_ptCursor];
			m_ptCursor.x = newCursor.x;
			m_ptCursor.y = newCursor.y;
			NSLog(@"UpdateTouchedLayout new cursor of landscape:x:%f, y:%f", m_ptCursor.x, m_ptCursor.y);  
		}	
	}
	else 
	{
		newcenter = [CGameLayout ChangeToProtrait:oldcenter];
		NSLog(@"UpdateTouchedLayout new center of protrait:x:%f, y:%f", newcenter.x, newcenter.y);  
		
		if(m_bDragDrop == YES)
		{	
			NSLog(@"UpdateTouchedLayout old cursor:x:%f, y:%f", m_ptCursor.x, m_ptCursor.y);  
			newCursor = [CGameLayout ChangeToProtrait:m_ptCursor];
			m_ptCursor.x = newCursor.x;
			m_ptCursor.y = newCursor.y;
			NSLog(@"UpdateTouchedLayout new cursor of protrait :x:%f, y:%f", m_ptCursor.x, m_ptCursor.y);  
		}	
	}
	float newCardWidth = [CGameLayout GetCardWidth];
    float newCardHeight = [CGameLayout GetCardHeight];
    rect.origin.x = newcenter.x-newCardWidth/2.0;
	rect.origin.y = newcenter.y-newCardHeight/2.0;
	rect.size.width = newCardWidth;
	rect.size.height = newCardHeight;
	NSLog(@"UpdateTouchedLayout new rect:x:%f, y:%f, width:%f, height:%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);  
	[self setFrame: rect];
	[self setNeedsDisplay];
}	

//- (void)UpdateGameViewLayout
- (void)UpdateGameViewLayoutWithIndex:(int)i
{
	if(m_bDragDrop == NO)
	{
		[self UpdateNonTouchLayout:i];
	}
	else
	{
		[self UpdateTouchedLayout];
	}	
}	


- (BOOL)HitCard:(CGPoint)point
{
	CGRect rect = self.frame;
	if(CGRectContainsPoint(rect, point) == 1)
		return YES;
	else 
		return NO;
}

- (void)EnterDragAndDrop:(CGPoint)ptCur
{
	m_bDragDrop = YES;
	m_ptCursor.x = ptCur.x;
	m_ptCursor.y = ptCur.y;
	[self SetHighlight:YES];
	[self setNeedsDisplay];
}

- (void)MoveCursorTo:(CGPoint)ptCur
{
	if(m_bDragDrop == NO)
	{
		NSLog(@"MoveCursorTo failed Card: %i", m_Card);  
		return;
	}	
	
	float xOffset = ptCur.x - m_ptCursor.x;
	float yOffset = ptCur.y - m_ptCursor.y;

	m_ptCursor.x = ptCur.x;
	m_ptCursor.y = ptCur.y;
	
	NSLog(@"MoveCursorTo Card: %i to x:%f, y:%f", m_Card, xOffset, yOffset);  
	
	CGRect rect = self.frame;
	//CGRectOffset(rect, xOffset, yOffset);
	rect.origin.x += xOffset;
	rect.origin.y += yOffset;
	[self setFrame:rect];
	[self setNeedsDisplay];
}

- (void)CleanCursor
{
	NSLog(@"CleanCursor Card: %i", m_Card);  
	
	m_bDragDrop = NO;
	m_ptCursor.x = 0;
	m_ptCursor.y = 0;
	[self SetHighlight:NO];
}	

- (BOOL)IsDragAndDrop
{
	return m_bDragDrop;
}

- (CGPoint)GetCursorPoint
{
	return m_ptCursor; 
}

- (void)SetCursorPoint:(CGPoint)ptCur
{
	m_ptCursor.x = ptCur.x;
	m_ptCursor.y = ptCur.y;
}	

- (void)Hide
{
	m_bShow = NO;
	m_bHighlight = NO;
    [self setNeedsDisplay];
	[self setAlpha:0.0f];
	CGRect rect = CGRectMake(0.0, 0.0, 0.1, 0.1);
	[self setFrame:rect];
	m_CardState = GAME_CARD_STATE_NONE;
	[[self superview] sendSubviewToBack:self];
	[[self superview] setNeedsDisplay];
	[self setNeedsDisplay];
}

- (void)ShowAt:(CGRect)rect
{
	m_bShow = YES;
	m_bHighlight = NO;
	[self setFrame:rect];
	[self setAlpha:1.0f];
	[[self superview] bringSubviewToFront:self];
    [self setNeedsDisplay];
	[[self superview] setNeedsDisplay];
}	

- (void)Show
{
	m_bShow = YES;
	m_bHighlight = NO;
	[self setAlpha:1.0f];
	[[self superview] bringSubviewToFront:self];
    [self setNeedsDisplay];
	[[self superview] setNeedsDisplay];
}

- (void)ShowWithAlpha:(double)alpha
{
	m_bShow = YES;
	m_bHighlight = NO;
	[self setAlpha:alpha];
	[[self superview] setNeedsDisplay];
}

- (BOOL)IsLive
{
	return m_bShow;
}

- (BOOL)IsInOperand1
{
	if(m_bShow == NO)
		return NO;
	
	CGRect rect = [CGameLayout GetOperand1Rect];
	if(CGRectEqualToRect(rect, self.frame))
		return YES;
	
	return NO;
}

- (BOOL)IsInOperand2
{
	if(m_bShow == NO)
		return NO;
	
	CGRect rect = [CGameLayout GetOperand2Rect];
	if(CGRectEqualToRect(rect, self.frame))
		return YES;
	
	return NO;
}

- (BOOL)IsInResult
{
	if(m_bShow == NO)
		return NO;
	
	CGRect rect = [CGameLayout GetResultRect];
	if([ApplicationConfigure iPhoneDevice])
	{	
		if(CGRectEqualToRect(rect, self.frame))
			return YES;
	}
	else 
	{
		float x = self.frame.origin.x;
		float y = self.frame.origin.y;
		float w = self.frame.size.width;
		float h = self.frame.size.height;
		
		if(rect.origin.x == x && rect.origin.y == y 
		   && rect.size.width == w && rect.size.height == h)
			return YES;
	}	
	
	return NO;
}	

- (BOOL)IsInBasicSpace:(int)index
{
	if(m_bShow == NO)
		return NO;
	
	if(0 <= index && index < 4)
	{	
		CGRect rect = [CGameLayout GetBasicCardRect:index];
		if(CGRectEqualToRect(rect, self.frame))
			return YES;
	}	
	
	return NO;
}	

- (void)MoveToOperand1
{
	if(m_bShow == NO)
		return;
	
	m_CardState = GAME_CARD_STATE_OPERAND1;
	[self setFrame:[CGameLayout GetOperand1Rect]];
	[self setNeedsDisplay];
}	
 
- (void)MoveToOperand2
{
	if(m_bShow == NO)
		return;
	
	m_CardState = GAME_CARD_STATE_OPERAND2;
	[self setFrame:[CGameLayout GetOperand2Rect]];
	[self setNeedsDisplay];
}	

- (void)MoveToResult
{
	if(m_bShow == NO || [self IsBasicCard] == YES)
		return;

	m_CardState = GAME_CARD_STATE_RESULT;
	[self setFrame:[CGameLayout GetResultRect]];
	[self setNeedsDisplay];
}	

- (BOOL)IsCloseToOperand1
{
	if(m_bShow == NO)
		return NO;
	
	double sx = self.frame.origin.x;
	double sy = self.frame.origin.y;
	double sw = self.frame.size.width;
	double sh = self.frame.size.height;
	
	CGPoint pt = CGPointMake(sx, sy);
	CGRect rect = [CGameLayout GetOperand1Rect];
    if(CGRectContainsPoint(rect, pt))
		return YES;
	
	pt = CGPointMake(sx+sw, sy);
    if(CGRectContainsPoint(rect, pt))
		return YES;	
	
	pt = CGPointMake(sx+sw, sy+sh);
    if(CGRectContainsPoint(rect, pt))
		return YES;	
	
	pt = CGPointMake(sx, sy+sh);
    if(CGRectContainsPoint(rect, pt))
		return YES;	
	
	return NO;
}

- (BOOL)IsCloseToOperand2
{
	if(m_bShow == NO)
		return NO;
	
	double sx = self.frame.origin.x;
	double sy = self.frame.origin.y;
	double sw = self.frame.size.width;
	double sh = self.frame.size.height;
	
	CGPoint pt = CGPointMake(sx, sy);
	CGRect rect = [CGameLayout GetOperand2Rect];
    if(CGRectContainsPoint(rect, pt))
		return YES;
	
	pt = CGPointMake(sx+sw, sy);
    if(CGRectContainsPoint(rect, pt))
		return YES;	
	
	pt = CGPointMake(sx+sw, sy+sh);
    if(CGRectContainsPoint(rect, pt))
		return YES;	
	
	pt = CGPointMake(sx, sy+sh);
    if(CGRectContainsPoint(rect, pt))
		return YES;	
	
	return NO;
}	

- (int)GetCardState
{
	return m_CardState;
}

- (BOOL)AsOperand1
{
	BOOL bRet = NO;
	
	if(m_CardState == GAME_CARD_STATE_OPERAND1)
		bRet = YES;
	
	return bRet;
}

- (BOOL)AsOperand2
{
	BOOL bRet = NO;
	
	if(m_CardState == GAME_CARD_STATE_OPERAND2)
		bRet = YES;
	
	return bRet;
}

- (BOOL)AsResult
{
	BOOL bRet = NO;
	
	if(m_CardState == GAME_CARD_STATE_RESULT)
		bRet = YES;
	
	return bRet;
}

- (BOOL)AsNoUsed
{
	BOOL bRet = NO;
	
	if(m_CardState == GAME_CARD_STATE_NONE)
		bRet = YES;
	
	return bRet;
}	

- (void)ClearCardState
{
	m_CardState = GAME_CARD_STATE_NONE;
}	

- (void)SwitchTheme
{
	//if(IsTempCard(m_Card) == 1)
	//{
	//	[self LoadTempCardImages];
	//}
	[self setNeedsDisplay];
}

@end
