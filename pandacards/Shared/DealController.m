//
//  DealController.m
//  MindFire
//
//  Created by Zhaohui Xing on 10-04-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "CardEquation.h"
#import "DealController.h"
#import "ResultView.h"
#import "GameBaseView.h"
#import "GameCard.h"
#import "CSignsBtn.h"
#import "GameView.h"
#import "CGameLayout.h"
#import "RenderHelper.h"
#import "Bulletin.h"
#import "GreetLayer.h"
#import "GameDeck.h"
#import "GameScore.h"
#import "GUILayout.h"
#import "ApplicationResource.h"
#import "ApplicationConfigure.h"
#import "GUIEventLoop.h"
#import "GameCenterConstant.h"
#import "GameMsgConstant.h"
#import "GameMsgFormatter.h"
#import "GameStatusBar.h"
#include "GameUtility.h"
#include "GameState.h"
#import "StringFactory.h"


#define GAME_SPEED_FAST_COUNT       10
#define GAME_SPEED_SLOW_COUNT       40


@implementation DealController
#define POINT(X)	[[points objectAtIndex:X] locationInView:m_DealView]

- (void)SetCurrentTime
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat:@"MM"];
	int month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	
	[dateFormatter setDateFormat:@"dd"];
	int day = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	
	[dateFormatter setDateFormat:@"yyyy"];
	int year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	
	[dateFormatter release];
	SetTodayDate(year, month, day);
}	

- (int)GetDealLeft
{
    return [m_Game getDealLeft];
}

- (void)Shuffle
{
    [m_Game shuffle];
}

- (void)initGame
{
	if((m_Game = [[GameDeck alloc] init]))
	{
		[m_Game shuffle];
	}	
}	


- (void)initCards
{
	CGRect rect;
	int nCard1, nCard2, nCard3, nCard4;
	[m_Game queryDeal:&nCard1 withCard2:&nCard2 withCard3:&nCard3 withCard4:&nCard4];
	
	rect = [CGameLayout GetBasicCardRect:0];
	m_BasicCard[0] = [[GameCard alloc] initCard:(nCard1) withRect:rect];
	m_BasicCard[0].backgroundColor = [UIColor clearColor];
	[m_DealView addSubview:m_BasicCard[0]];
	[m_BasicCard[0] release];
	
	rect = [CGameLayout GetBasicCardRect:1];
	m_BasicCard[1] = [[GameCard alloc] initCard:(nCard2) withRect:rect];
	m_BasicCard[1].backgroundColor = [UIColor clearColor];
	[m_DealView addSubview:m_BasicCard[1]];
	[m_BasicCard[1] release];
	
	rect = [CGameLayout GetBasicCardRect:2];
	m_BasicCard[2] = [[GameCard alloc] initCard:(nCard3) withRect:rect];
	m_BasicCard[2].backgroundColor = [UIColor clearColor];
	[m_DealView addSubview:m_BasicCard[2]];
	[m_BasicCard[2] release];
	
	rect = [CGameLayout GetBasicCardRect:3];
	m_BasicCard[3] = [[GameCard alloc] initCard:(nCard4) withRect:rect];
	m_BasicCard[3].backgroundColor = [UIColor clearColor];
	[m_DealView addSubview:m_BasicCard[3]];
	[m_BasicCard[3] release];
	
	
	for(int i = 0; i < 4; ++i)
	{
		rect = [CGameLayout GetTempCardRect:i];
		m_TempCard[i] = [[GameCard alloc] initCard:i+52 withRect:rect];
		m_TempCard[i].backgroundColor = [UIColor clearColor];
		[m_DealView addSubview:m_TempCard[i]];
		[m_TempCard[i] release];
		[m_TempCard[i] Hide];
		[m_BasicCard[i] Hide];
	}	
	
	rect = [CGameLayout GetSignsRect];
	m_SignsButton = [[CSignsBtn alloc] initView:rect];
	m_SignsButton.backgroundColor = [UIColor clearColor];
	[m_DealView addSubview:m_SignsButton];
	[m_SignsButton release];
}	

- (void)OnGotoNewGame:(id)sender
{
    m_bResultAnimation = NO;
    [self GotoNewGame];
}

- (id)initController:(GameView*)ParentView
{
    if ((self = [super init])) 
	{
        // Initialization code
		m_DealView = ParentView;
        [self SetCurrentTime];
		[self initGame];
        [self initCards];
		m_Scores = [[GameScore alloc] init];
		[m_Scores LoadScoresFromPreference:YES];
        
        
		CGRect rect = [CGameLayout GetDealCountAreaRect];
		m_Bulletin = [[Bulletin alloc] initWithFrame:rect];
        [m_Bulletin SetParent:self];
		[m_Bulletin setBackgroundColor:[UIColor clearColor]];
		[m_DealView addSubview:m_Bulletin];
		[m_Bulletin release];			  
		[self initCards];
		
        m_StatusBar = [[GameStatusBar alloc] initWithFrame:[CGameLayout GetGreetViewRect]];
        [m_StatusBar CloseView:NO];
        [m_DealView addSubview:m_StatusBar];
        [m_StatusBar release];
        
        
		m_Result = [[DealResult alloc] init];				
        float fResultViewSize = [CGameLayout GetResultViewSize];
		rect = CGRectMake(([GUILayout GetMainUIWidth]-fResultViewSize)/2.0, ([GUILayout GetMainUIHeight]-fResultViewSize)/2.0, fResultViewSize, fResultViewSize);
        m_ResultView = [[ResultViewParent alloc] initView:rect withGame:self];
        [m_DealView addSubview:m_ResultView]; 
        [m_DealView sendSubviewToBack:m_ResultView];
        m_ResultView.hidden = YES;
        [m_ResultView release];
        
        [GUIEventLoop RegisterEvent:GUIID_EVENT_GOTONEWGAMEBUTTON eventHandler:@selector(OnGotoNewGame:) eventReceiver:self eventSender:m_ResultView];
        
		m_DoCalculation = NO;
        m_bResultAnimation = NO;
        
        m_TimeStartDealCounting = 0;
        m_PercentOfTiming = 0.0; 
        m_bDealTimeCounting = NO;
        
		//[self EnterNewDeal];
	}
    return self;
}


- (void)UpdateGameViewLayout
{
    [m_DealView setNeedsDisplay];
    
	for(int i = 0; i < 4; ++i)
	{
		[m_BasicCard[i] UpdateGameViewLayoutWithIndex:i];
		[m_TempCard[i] UpdateGameViewLayoutWithIndex:i];
	}	
	CGRect rect = [CGameLayout GetSignsRect];
	[m_SignsButton setFrame:rect];
	[m_SignsButton setNeedsDisplay];
	rect = [CGameLayout GetDealCountAreaRect];
	[m_Bulletin setFrame:rect];
	[m_Bulletin setNeedsDisplay];
    [m_StatusBar setFrame:[CGameLayout GetGreetViewRect]];
    [m_StatusBar UpdateViewLayout];

    [m_ResultView UpdateGameViewLayout];
}	

- (void)dealloc 
{
	for(int i = 0; i < 4; ++i)
	{
		[m_BasicCard[i] release];
		[m_TempCard[i] release];
	}	
	[m_SignsButton release];
	[m_Scores SaveScoresToPreference];
    [m_Scores release];
    [super dealloc];
}

- (void)OnTimerEvent
{
	for(int i = 0; i < 4; ++i)
	{
		[m_BasicCard[i] OnTimerEvent];
		[m_TempCard[i] OnTimerEvent];
	}
	if(m_bDealTimeCounting == YES)
    {
        NSTimeInterval currentTime = [[NSProcessInfo  processInfo] systemUptime];
        float timeStep = currentTime - m_TimeStartDealCounting;
        float fCount = GAME_SPEED_SLOW_COUNT;
        if(GetGameSpeed() == GAME_SPEED_FAST)
            fCount = GAME_SPEED_FAST_COUNT;
        
        if(fCount <= timeStep)
        {
            m_bDealTimeCounting = NO;
            [m_DealView NextButtonClick];
            return;
        }
        else 
        {
            m_PercentOfTiming = timeStep/fCount;
        }
        
    }
	[m_SignsButton OnTimerEvent];
	[m_Bulletin OnTimerEvent];
	if(m_StatusBar.hidden == NO)
        [m_StatusBar OnTimerEvent];
}	

- (float)GetTimeSpentRatio
{
    if(m_bDealTimeCounting == NO)
        return 0.0;
    
    return m_PercentOfTiming;
}

- (void)HandleGameTimingCount
{
    if(GetGameSpeed() != GAME_SPEED_NONE)
    {
        m_bDealTimeCounting = YES;
        m_TimeStartDealCounting = [[NSProcessInfo  processInfo] systemUptime];
        m_PercentOfTiming = 0.0;
    }
}

- (void)OnBasicCardShow1:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_BasicCard[0] Show];
	if(m_DealView.m_nAnimationLock <= 0)
	{
        if(m_StatusBar.hidden == NO)
            [m_StatusBar CloseView:YES];
        [m_SignsButton setNeedsDisplay];
        [m_Bulletin setNeedsDisplay];
        
        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
        if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
        {
            id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
            if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
            {
                [self UndoDeal];
            }    
        }    
        [self HandleGameTimingCount];
	}	
}	

- (void)OnBasicCardShow2:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_BasicCard[1] Show];
	if(m_DealView.m_nAnimationLock <= 0)
	{
        if(m_StatusBar.hidden == NO)
            [m_StatusBar CloseView:YES];
        [m_SignsButton setNeedsDisplay];
        [m_Bulletin setNeedsDisplay];
        
        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
        if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
        {
            id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
            if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
            {
                [self UndoDeal];
            }    
        }    
        [self HandleGameTimingCount];
	}	
}	

- (void)OnBasicCardShow3:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_BasicCard[2] Show];
	if(m_DealView.m_nAnimationLock <= 0)
	{
        if(m_StatusBar.hidden == NO)
            [m_StatusBar CloseView:YES];
        [m_SignsButton setNeedsDisplay];
        [m_Bulletin setNeedsDisplay];
        
        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
        if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
        {
            id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
            if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
            {
                [self UndoDeal];
            }    
        }    
        [self HandleGameTimingCount];
	}	
}	

- (void)OnBasicCardShow4:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_BasicCard[3] Show];
	if(m_DealView.m_nAnimationLock <= 0)
	{
        if(m_StatusBar.hidden == NO)
            [m_StatusBar CloseView:YES];
        [m_SignsButton setNeedsDisplay];
        [m_Bulletin setNeedsDisplay];
        
        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
        if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
        {
            [self UndoDeal];
        } 
        [self HandleGameTimingCount];
	}	
}	

- (void)EnterNewDeal
{
	m_DealView.m_nAnimationLock = 4;
	CGRect rect;
	for(int i = 0; i < 4; ++i)
	{	
		rect = [CGameLayout GetBasicCardRect:i];
		[m_BasicCard[i] setFrame:rect];
		[m_BasicCard[i] ShowWithAlpha:0.0];
		[m_BasicCard[i] SetHighlight:NO];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(OnBasicCardShow1:)];
	[m_BasicCard[0] setAlpha:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:m_BasicCard[0] cache:YES];
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(OnBasicCardShow2:)];
	[m_BasicCard[1] setAlpha:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:m_BasicCard[1] cache:YES];
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(OnBasicCardShow3:)];
	[m_BasicCard[2] setAlpha:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:m_BasicCard[2] cache:YES];
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(OnBasicCardShow4:)];
	[m_BasicCard[3] setAlpha:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:m_BasicCard[3] cache:YES];
	[UIView commitAnimations];
}	

- (void)GoToNextDeal
{
	if([m_Game isEmpty] == NO)
	{	
		int nCard1, nCard2, nCard3, nCard4;
		[m_Game queryDeal:&nCard1 withCard2:&nCard2 withCard3:&nCard3 withCard4:&nCard4];
		[m_BasicCard[0] SetCard:nCard1];
		[m_BasicCard[1] SetCard:nCard2];
		[m_BasicCard[2] SetCard:nCard3];
		[m_BasicCard[3] SetCard:nCard4];
		[m_SignsButton Reset];
		[self EnterNewDeal];
	}
	else 
	{
        if(m_StatusBar.hidden == NO)
            [m_StatusBar CloseView:YES];
        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
        if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
        {
            return;
        }
        
		if(0 < [m_Game.m_Answers GetSize])
		{	
			[self GotoResult];
		}
		else 
		{
			[m_DealView StartNewGame];
		}
	}
}

- (BOOL)IsGameComplete
{
	for(int i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES || [m_TempCard[i] IsLive] == YES)
            return NO;
	}
    BOOL bRet = [m_Game isEmpty];
    return bRet;
}

- (void)OnBasicCardHide1:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_BasicCard[0] Hide];
	if(m_DealView.m_nAnimationLock <= 0)
	{
		[self GoToNextDeal];	
	}	
}	

- (void)OnBasicCardHide2:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_BasicCard[1] Hide];
	if(m_DealView.m_nAnimationLock <= 0)
	{
		[self GoToNextDeal];	
	}	
}	

- (void)OnBasicCardHide3:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_BasicCard[2] Hide];
	if(m_DealView.m_nAnimationLock <= 0)
	{
		[self GoToNextDeal];	
	}	
}	

- (void)OnBasicCardHide4:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_BasicCard[3] Hide];
	if(m_DealView.m_nAnimationLock <= 0)
	{
		[self GoToNextDeal];	
	}	
}	

- (void)OnTempCardHide1:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_TempCard[0] Hide];
	if(m_DealView.m_nAnimationLock <= 0)
	{
		[self GoToNextDeal];	
	}	
}	

- (void)OnTempCardHide2:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_TempCard[1] Hide];
	if(m_DealView.m_nAnimationLock <= 0)
	{
		[self GoToNextDeal];	
	}	
}	

- (void)OnTempCardHide3:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_TempCard[2] Hide];
	if(m_DealView.m_nAnimationLock <= 0)
	{
		[self GoToNextDeal];	
	}	
}	

- (void)OnTempCardHide4:(id)sender
{
	--m_DealView.m_nAnimationLock;
	[m_TempCard[3] Hide];
	if(m_DealView.m_nAnimationLock <= 0)
	{
		[self GoToNextDeal];	
	}	
}	


- (BOOL)MoveOutOldDeal
{
	m_DealView.m_nAnimationLock = 0;
    m_bDealTimeCounting = NO;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if([m_BasicCard[0] IsLive] == YES)
	{
		++m_DealView.m_nAnimationLock; 
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[0] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardHide1:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[0] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_BasicCard[1] IsLive] == YES)
	{
		++m_DealView.m_nAnimationLock; 
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[1] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardHide2:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[1] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_BasicCard[2] IsLive] == YES)
	{
		++m_DealView.m_nAnimationLock; 
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[2] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardHide3:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[2] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_BasicCard[3] IsLive] == YES)
	{
		++m_DealView.m_nAnimationLock; 
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[3] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardHide4:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[3] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_TempCard[0] IsLive] == YES)
	{
		++m_DealView.m_nAnimationLock; 
		[UIView beginAnimations:nil context:context];
		[m_TempCard[0] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardHide1:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[0] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_TempCard[1] IsLive] == YES)
	{
		++m_DealView.m_nAnimationLock; 
		[UIView beginAnimations:nil context:context];
		[m_TempCard[1] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardHide2:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[1] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_TempCard[2] IsLive] == YES)
	{
		++m_DealView.m_nAnimationLock; 
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardHide3:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[2] cache:YES];
		[UIView commitAnimations];
		[m_TempCard[2] setAlpha:0.0];
	}	
	
	if([m_TempCard[3] IsLive] == YES)
	{
		++m_DealView.m_nAnimationLock; 
		[UIView beginAnimations:nil context:context];
		[m_TempCard[3] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardHide4:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[3] cache:YES];
		[UIView commitAnimations];
	}
	if(m_DealView.m_nAnimationLock == 0)
		return NO;
	else
		return YES;
}	


- (void) touchesBegan : (NSSet*)touches withEvent: (UIEvent*)event
{
	if(0 < m_DealView.m_nAnimationLock)
		return;
	
	NSArray *points = [touches allObjects];
	m_nTouchSemphore += points.count;
	CGPoint pt;
	//NSLog(@"touchesBegan pt counts: %i", points.count);  
	//NSLog(@"touchesBegan m_nTouchSemphore: %i", m_nTouchSemphore);  
	BOOL bHitBtn = NO;
	
	for(int i = 0; i < 4; ++i)
	{
		for(int j = 0; j < points.count; ++j)
		{	
			pt = POINT(j);
			//NSLog(@"touchesBegin pt%i, x:%f, y:%f", j, pt.x, pt.y);  
			
			if([m_BasicCard[i] IsDragAndDrop] == 0 && [m_BasicCard[i] HitCard:pt] == 1)
			{
				[m_BasicCard[i] EnterDragAndDrop:pt];
				[m_DealView bringSubviewToFront:m_BasicCard[i]];
				break;
			}
			if([m_TempCard[i] IsDragAndDrop] == 0 && [m_TempCard[i] HitCard:pt] == 1)
			{
				[m_TempCard[i] EnterDragAndDrop:pt];
				[m_DealView bringSubviewToFront:m_TempCard[i]];
				break;
			}
			
			if(bHitBtn == NO)
			{
				bHitBtn = [m_SignsButton HitBtn:pt];
				if(bHitBtn == YES)
					[m_SignsButton SetHighlight];
			}	
		}	
	}	
}	

- (void) handleTouchesMotion: (NSSet*)touches withEvent: (UIEvent*)event
{
	if(0 < m_DealView.m_nAnimationLock)
		return;
	
	NSArray *points = [touches allObjects];
	CGPoint pt;
	
	BOOL bHitBtn = [m_SignsButton IsHighlight];
	BOOL bHitCard;
	
	for(int j = 0; j < points.count; ++j)
	{	
		pt = POINT(j);
		bHitCard = NO;
		for(int i = 0; i < 4; ++i)
		{
			if([m_BasicCard[i] IsDragAndDrop] == 1 && [m_BasicCard[i] HitCard:pt] == 1)
			{
				bHitCard = YES;
				[m_BasicCard[i] MoveCursorTo:pt];
				break;
			}
			if([m_TempCard[i] IsDragAndDrop] == 1 && [m_TempCard[i] HitCard:pt] == 1)
			{
				bHitCard = YES;
				[m_TempCard[i] MoveCursorTo:pt];
				break;
			}
		}
		//If touchBegan didnot hit signsbutton, then do nothing.
		//Otherwise check whether switch the hit sign.
		if(bHitCard == NO && bHitBtn == YES)
		{
			bHitBtn = [m_SignsButton HitBtn:pt];
			if(bHitBtn == YES)
				[m_SignsButton SetHighlight];
		}	
	}
	if(bHitBtn == NO)
		[m_SignsButton RemoveHighlight];
}	

- (void) touchesMoved: (NSSet*)touches withEvent: (UIEvent*)event
{
	if(0 < m_DealView.m_nAnimationLock)
		return;
	
	[self handleTouchesMotion:touches withEvent:event];
}	

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(0 < m_DealView.m_nAnimationLock)
		return;
	
	NSArray *points = [touches allObjects];
	m_nTouchSemphore -= points.count;
	//NSLog(@"touchesEnded pt counts: %i", points.count);  
	//NSLog(@"touchesEnded m_nTouchSemphore: %i", m_nTouchSemphore);  
	
	//if([self CheckDealRightAnswer] == YES)
	BOOL bHitBtn = NO;
	BOOL bHitCard;
	CGPoint pt;
	
	if([self IsDealCalculationComplete] == YES)
	{
		if(m_nTouchSemphore == 0)
		{
			for(int j = 0; j < points.count; ++j)
			{
				pt = POINT(j);
				bHitCard = NO;
				for(int i = 0; i < 4; ++i)
				{	
					//NSLog(@"touchesEnd pt%i, x:%f, y:%f", j, pt.x, pt.y);  
					if([m_BasicCard[i] IsDragAndDrop] == 1 && [m_BasicCard[i] HitCard:pt] == 1)
					{
						bHitCard = YES;
						break;
					}
					if([m_TempCard[i] IsDragAndDrop] == 1 && [m_TempCard[i] HitCard:pt] == 1)
					{
						bHitCard = YES;
						break;
					}
				}
				if([m_SignsButton IsHighlight] == YES && bHitCard == NO)
				{
					bHitBtn = [m_SignsButton HitBtn:pt];
					if(bHitBtn == YES)
					{	
						[m_SignsButton RemoveHighlight];
						[self DoCalculate];
						return;
					}	
				}	
			}	
		}	
		
		m_nTouchSemphore = 0;
		if([self IsDealFinalAnswerRight] == YES)
		{	
			[self CloseCurrentDealWithRightAnswer];
		}	
		else
		{	
			[self CloseCurrentDealWithoutRightAnswer];
		}	

		return;
	}	
	
	if(m_nTouchSemphore <= 0)
	{
		[self RestoreNonTouchState];
		[self DoCalculate];
		return;
	}
	
	for(int j = 0; j < points.count; ++j)
	{
		pt = POINT(j);
		bHitCard = NO;
		for(int i = 0; i < 4; ++i)
		{	
			//NSLog(@"touchesEnd pt%i, x:%f, y:%f", j, pt.x, pt.y);  
			if([m_BasicCard[i] IsDragAndDrop] == 1 && [m_BasicCard[i] HitCard:pt] == 1)
			{
				[self RestoreBasicCardNonTouch:i];
				bHitCard = YES;
				break;
			}
			if([m_TempCard[i] IsDragAndDrop] == 1 && [m_TempCard[i] HitCard:pt] == 1)
			{
				[self RestoreTempCardNonTouch:i];
				bHitCard = YES;
				break;
			}
		}
		if([m_SignsButton IsHighlight] == YES && bHitCard == NO)
		{
			bHitBtn = [m_SignsButton HitBtn:pt];
			if(bHitBtn == YES)
				[m_SignsButton RemoveHighlight];
		}	
	}	
	[self DoCalculate];
}	

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self RestoreNonTouchState];
}	

- (void)RestoreNonTouchState
{
	m_nTouchSemphore = 0;
	for(int i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsDragAndDrop] == 1)
		{
			[self RestoreBasicCardNonTouch:i];
		}
		if([m_TempCard[i] IsDragAndDrop] == 1)
		{
			[self RestoreTempCardNonTouch:i];
		}
	}
	[m_SignsButton RemoveHighlight];
}

- (void)RestoreBasicCardNonTouch:(int)nIndex
{
	if(0 <= nIndex && nIndex < 4)
	{	
		[m_BasicCard[nIndex] CleanCursor];
		[self DecideBasicCardState:nIndex];
	}	
}

- (void)RestoreTempCardNonTouch:(int)nIndex
{
	if(0 <= nIndex && nIndex < 4)
	{	
		[m_TempCard[nIndex] CleanCursor];
		[self DecideTempCardState:nIndex];
	}	
}	

- (BOOL)IsOperandEmpty:(int)index
{
	for(int i = 0; i < 4; ++i)
	{
		if(index == 0)
		{	
			if([m_BasicCard[i] IsLive] == YES && [m_BasicCard[i] AsOperand1] == YES)
			{ 
				return NO;
			}
			if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsOperand1] == YES)
			{ 
				return NO;
			}
		}
		else 
		{	
			if([m_BasicCard[i] IsLive] == YES && [m_BasicCard[i] AsOperand2] == YES)
			{ 
				return NO;
			}
			if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsOperand2] == YES)
			{ 
				 return NO;
			}
		}
	}	
	return YES;
}	

- (BOOL)CardInOperandArea:(BOOL)bOperand1 exceptCardindex:(int)myIndex exceptCardType:(BOOL)bBasic cardIndex:(int *)index 
{
	BOOL bBasicCard = YES;
	
	*index = -1;
	
	int i;
	for(i = 0; i < 4; ++i)
	{
		if(bBasic == YES && i == myIndex)
			continue;
		if([m_BasicCard[i] IsLive] == NO)
			continue;
		if(bOperand1 == YES)
		{	
			if([m_BasicCard[i] IsInOperand1] == YES)
			{
				*index = i;
				bBasicCard = YES;
				return bBasicCard;
			}	
		}
		else 
		{
			if([m_BasicCard[i] IsInOperand2] == YES)
			{
				*index = i;
				bBasicCard = YES;
				return bBasicCard;
			}	
		}
	}	
	
	for(i = 0; i < 4; ++i)
	{
		if(bBasic == NO && i == myIndex)
			continue;
		if([m_TempCard[i] IsLive] == NO)
			continue;
		if(bOperand1 == YES)
		{	
			if([m_TempCard[i] IsInOperand1] == YES)
			{
				*index = i;
				bBasicCard = NO;
				return bBasicCard;
			}	
		}
		else 
		{
			if([m_TempCard[i] IsInOperand2] == YES)
			{
				*index = i;
				bBasicCard = NO;
				return bBasicCard;
			}	
		}
	}	
	
	return bBasicCard;
}	

- (void)MoveOldCardToOperand:(int)i withCardtype:(BOOL)bBasicCard toOperand1:(BOOL)bOperand1
{
	if(bBasicCard == YES)
	{
		if(bOperand1 == YES)
			[m_BasicCard[i] MoveToOperand1];
		else 
			[m_BasicCard[i] MoveToOperand2];
	}
	else 
	{
		//??????????????????????????????????????????
		//??????????????????????????????????????????
		//??????????????????????????????????????????
		if(bOperand1 == YES)
			[m_TempCard[i] MoveToOperand1];
		else 
			[m_TempCard[i] MoveToOperand2];
		//??????????????????????????????????????????
		//??????????????????????????????????????????
		//??????????????????????????????????????????
	}
}	

- (int)GetAviableSpace
{
	int i, j;
	for(i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == NO)
		{
			BOOL bUsed = NO;
			for(j = 0; j < 4; ++j)
			{
				if([m_TempCard[j] IsLive] == YES && [m_TempCard[j] IsInBasicSpace:i] == YES)
				{
					bUsed = YES;
					break;
				}	
			}
			if(bUsed == NO)
			{
				return i;
			}	
		}	
	}
	return -1;
}	

- (int)QueryAviableSpaceByTempCard:(int)index
{
	int i, j;
	for(i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == NO)
		{
			BOOL bUsed = NO;
			for(j = 0; j < 4; ++j)
			{
				if([m_TempCard[j] IsLive] == YES && [m_TempCard[j] IsInBasicSpace:i] == YES)
				{
					if(index == j)
					{
						return i;
					}	
					else 
					{
						bUsed = YES;
						break;
					}
				}	
			}
			if(bUsed == NO)
			{
				return i;
			}	
		}	
	}
	return -1;
}	

- (void)MoveOldCardBacktoOrigin:(int)i withCardtype:(BOOL)bBasicCard
{
	if(bBasicCard == YES)
	{
		CGRect rect = [CGameLayout GetBasicCardRect:i];
		[m_BasicCard[i] setFrame:rect];
		[m_BasicCard[i] ClearCardState];
		[m_BasicCard[i] setNeedsDisplay];
	}
	else 
	{
		//Find The first empty basic card space
		int nPos = [self GetAviableSpace];
		if(nPos == -1)
			return;
		
		CGRect rect = [CGameLayout GetBasicCardRect:nPos];
		[m_TempCard[i] setFrame:rect];
		[m_TempCard[i] ClearCardState];
		[m_TempCard[i] setNeedsDisplay];
	}
	
}	

- (void)DecideBasicCardState:(int)i
{
	BOOL bBasicCard;
	int nOldCard;
	if(0 <= i && i < 4)
	{	
		if([m_BasicCard[i] IsCloseToOperand1] == YES && [m_BasicCard[i] AsOperand1] == NO)
		{
			bBasicCard = [self CardInOperandArea:YES exceptCardindex:i exceptCardType:YES cardIndex:&nOldCard]; 
			if(0 <= nOldCard)
			{
				if([m_BasicCard[i] AsOperand2] == NO)
					[self MoveOldCardBacktoOrigin:nOldCard withCardtype:bBasicCard];
				else
					[self MoveOldCardToOperand:nOldCard withCardtype:bBasicCard toOperand1:NO];
			}	
			[m_BasicCard[i] MoveToOperand1];
		}
		else if([m_BasicCard[i] IsCloseToOperand2] == YES && [m_BasicCard[i] AsOperand2] == NO)
		{
			bBasicCard = [self CardInOperandArea:NO exceptCardindex:i exceptCardType:YES cardIndex:&nOldCard]; 
			if(0 <= nOldCard)
			{
				if([m_BasicCard[i] AsOperand1] == NO)
					[self MoveOldCardBacktoOrigin:nOldCard withCardtype:bBasicCard];
				else
					[self MoveOldCardToOperand:nOldCard withCardtype:bBasicCard toOperand1:YES];
			}	
			[m_BasicCard[i] MoveToOperand2];
		}
		else
		{	
			if([m_BasicCard[i] AsNoUsed] == YES)
			{
				if([self IsOperandEmpty:0] == YES)
				{
					[m_BasicCard[i] MoveToOperand1];
					return;
				}	
				if([self IsOperandEmpty:1] == YES)
				{
					[m_BasicCard[i] MoveToOperand2];
					return;
				}	
			}
			CGRect rect = [CGameLayout GetBasicCardRect:i];
			[m_BasicCard[i] setFrame:rect];
			[m_BasicCard[i] ClearCardState];
			[m_BasicCard[i] setNeedsDisplay];
		}	
	}	
}

//??????????????????????????????????????????
//How to handle result??????????????????
//??????????????????????????????????????????
- (void)DecideTempCardState:(int)i
{
	BOOL bBasicCard;
	int nOldCard;
	if(0 <= i && i < 4)
	{	
		if([m_TempCard[i] IsCloseToOperand1] == YES && [m_TempCard[i] AsOperand1] == NO)
		{
			//How to handle result??????????????????
			//How to handle result??????????????????
			//How to handle result??????????????????
			bBasicCard = [self CardInOperandArea:YES exceptCardindex:i exceptCardType:NO cardIndex:&nOldCard]; 
			if(0 <= nOldCard)
			{
				if([m_TempCard[i] AsOperand2] == YES)
				{
					[self MoveOldCardToOperand:nOldCard withCardtype:bBasicCard toOperand1:NO];
				}
				else if([m_TempCard[i] AsResult] == YES)
				{
					if([self FinishCalculate] == NO)
						return;
				}
				else 
				{	
					[self MoveOldCardBacktoOrigin:nOldCard withCardtype:bBasicCard];
				}	
			}	
			//How to handle result??????????????????
			//How to handle result??????????????????
			//How to handle result??????????????????
			//How to handle result??????????????????
			[m_TempCard[i] MoveToOperand1];
		}
		else if([m_TempCard[i] IsCloseToOperand2] == YES && [m_TempCard[i] AsOperand2] == NO)
		{
			bBasicCard = [self CardInOperandArea:NO exceptCardindex:i exceptCardType:NO cardIndex:&nOldCard]; 
			//How to handle result??????????????????
			//How to handle result??????????????????
			//How to handle result??????????????????
			if(0 <= nOldCard)
			{
				if([m_TempCard[i] AsOperand1] == YES)
				{
					[self MoveOldCardToOperand:nOldCard withCardtype:bBasicCard toOperand1:YES];
				}
				else if([m_TempCard[i] AsResult] == YES)
				{
					if([self FinishCalculate] == NO)
						return;
				}
				else 
				{	
					[self MoveOldCardBacktoOrigin:nOldCard withCardtype:bBasicCard];
				}	
			}	
			//How to handle result??????????????????
			//How to handle result??????????????????
			//How to handle result??????????????????
			[m_TempCard[i] MoveToOperand2];
		}
		else
		{	
			if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsNoUsed] == YES)
			{
				if([self IsOperandEmpty:0] == YES)
				{
					[m_TempCard[i] MoveToOperand1];
					return;
				}	
				if([self IsOperandEmpty:1] == YES)
				{
					[m_TempCard[i] MoveToOperand2];
					return;
				}	
			}
			
			int nRet = [self QueryAviableSpaceByTempCard:i];
			if(nRet < 0)
			{	
				if([m_TempCard[i] AsResult] == YES)
				{
					[self FinishCalculate];
					nRet = [self GetAviableSpace];
					if(nRet < 0)
						return;
				}
				else 
				{
					return;
				}
			}	
			if([m_TempCard[i] AsResult] == YES)
			{
				[self FinishCalculate];
			}
			CGRect rect = [CGameLayout GetBasicCardRect:nRet];
			[m_TempCard[i] setFrame:rect];
			[m_TempCard[i] ClearCardState];
			[m_TempCard[i] setNeedsDisplay];
		}	
	}	
}	
//??????????????????????????????????????????
//??????????????????????????????????????????
//??????????????????????????????????????????

- (int)getOperand1Value
{
	int nRet = -1;
	int i = 0;
	
	//Check value1
	for(i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES)
		{
			if([m_BasicCard[i] AsOperand1] == YES)
			{
				nRet = [m_BasicCard[i] GetCardValue];
				break;
			}	
		}	
	}	
	if(nRet == -1)
	{
		for(i = 0; i < 4; ++i)
		{
			if([m_TempCard[i] IsLive] == YES)
			{
				if([m_TempCard[i] AsOperand1] == YES)
				{
					nRet = [m_TempCard[i] GetCardValue];
					break;
				}	
			}	
		}	
	}	
	
	return nRet;
}	

- (int)getOperand2Value
{
	int nRet = -1;
	int i = 0;
	
	//Check value1
	for(i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES)
		{
			if([m_BasicCard[i] AsOperand2] == YES)
			{
				nRet = [m_BasicCard[i] GetCardValue];
				break;
			}	
		}	
	}	
	if(nRet == -1)
	{
		for(i = 0; i < 4; ++i)
		{
			if([m_TempCard[i] IsLive] == YES)
			{
				if([m_TempCard[i] AsOperand2] == YES)
				{
					nRet = [m_TempCard[i] GetCardValue];
					break;
				}	
			}	
		}	
	}	
	
	return nRet;
}	

- (int)getResultValue
{
	int nRet = -1;
	int i = 0;
	
	for(i = 0; i < 4; ++i)
	{
		if([m_TempCard[i] IsLive] == YES)
		{
			if([m_TempCard[i] AsResult] == YES)
			{
				nRet = [m_TempCard[i] GetCardValue];
				break;
			}	
		}	
	}	
	
	return nRet;
}	

- (void)setResultCard:(int)nResult
{
	int i;
	for(i = 0; i < 4; ++i)
	{
		if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsResult] == YES)
		{
			[m_TempCard[i] SetCard:(nResult+52)];
			[m_TempCard[i] setNeedsDisplay];
			return;
		}	
	}	
	
	for(i = 0; i < 4; ++i)
	{
		if([m_TempCard[i] IsLive] == NO)
		{
			[m_TempCard[i] SetCard:(nResult+52)];
			CGRect rect = [CGameLayout GetResultRect];
			[m_TempCard[i] ShowAt:rect];
			[m_TempCard[i] MoveToResult];
			[m_TempCard[i] setNeedsDisplay];
			return;
		}	
	}	
}

- (void)removeResultCard
{
	int i;
	for(i = 0; i < 4; ++i)
	{
		if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsResult] == YES)
		{
			[m_TempCard[i] Hide];
			return;
		}	
	}	
}	

- (void)DoCalculate
{
	int nValue1 = -1;
	int nValue2 = -1;
	int nOperation = -1;
	
	//Check value1
	nValue1 = [self getOperand1Value];
	if(nValue1 < 0)
	{	
		[self removeResultCard];
		return;
	}	
	
	//Check value2
	nValue2 = [self getOperand2Value];
	if(nValue2 < 0)
	{	
		[self removeResultCard];
		return;
	}	
	
	//Check operation
	nOperation = [m_SignsButton GetOperation];
	if(nOperation == -1)
	{	
		[self removeResultCard];
		return;
	}	
	
	int nRet = CardCalculation(nValue1, nValue2, nOperation);
	if(0 <= nRet)
	{
		[self setResultCard:nRet];
		m_DoCalculation = YES;
	}
	else 
	{
		[self removeResultCard];
	}
	
}

- (int)getOperand1Index
{
	int nRet = -1;
	int i = 0;
	
	//Check value1
	for(i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES)
		{
			if([m_BasicCard[i] AsOperand1] == YES)
			{
				nRet = [m_BasicCard[i] GetCard];
				break;
			}	
		}	
	}	
	if(nRet == -1)
	{
		for(i = 0; i < 4; ++i)
		{
			if([m_TempCard[i] IsLive] == YES)
			{
				if([m_TempCard[i] AsOperand1] == YES)
				{
					nRet = [m_TempCard[i] GetCard];
					break;
				}	
			}	
		}	
	}	
	
	return nRet;
}	

- (int)getOperand2Index
{
	int nRet = -1;
	int i = 0;
	
	//Check value1
	for(i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES)
		{
			if([m_BasicCard[i] AsOperand2] == YES)
			{
				nRet = [m_BasicCard[i] GetCard];
				break;
			}	
		}	
	}	
	if(nRet == -1)
	{
		for(i = 0; i < 4; ++i)
		{
			if([m_TempCard[i] IsLive] == YES)
			{
				if([m_TempCard[i] AsOperand2] == YES)
				{
					nRet = [m_TempCard[i] GetCard];
					break;
				}	
			}	
		}	
	}	
	
	return nRet;
}	

- (int)getResultIndex
{
	int nRet = -1;
	int i = 0;
	
	for(i = 0; i < 4; ++i)
	{
		if([m_TempCard[i] IsLive] == YES)
		{
			if([m_TempCard[i] AsResult] == YES)
			{
				nRet = [m_TempCard[i] GetCard];
				break;
			}	
		}	
	}	
	
	return nRet;
}	

- (void)hideOperands
{
	for(int i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES && ([m_BasicCard[i] AsOperand1] == YES || [m_BasicCard[i] AsOperand2] == YES))
		{
			[m_BasicCard[i] Hide];
		}	
		if([m_TempCard[i] IsLive] == YES && ([m_TempCard[i] AsOperand1] == YES || [m_TempCard[i] AsOperand2] == YES))
		{
			[m_TempCard[i] Hide];
		}	
	}	
}


- (BOOL)FinishCalculate
{
	BOOL bRet = NO;
	int nIndex1 = [self getOperand1Index];
	if(nIndex1 < 0)
		return bRet;
	
	int nIndex2 = [self getOperand2Index];
	if(nIndex2 < 0)
		return bRet;
	
	int nResult = [self getResultIndex];
	if(nResult < 0)
		return bRet;
	
	int nOperation = [m_SignsButton GetOperation];
	
	CardEquation* cardeqn = [[[CardEquation alloc] init] autorelease];
	cardeqn.m_nOperation = nOperation;
	cardeqn.m_Operand1Card = nIndex1;  //This the card index, not card value
	cardeqn.m_Operand2Card = nIndex2;  //This the card index, not card value
	cardeqn.m_ResultCard = nResult;  //This the card index, not card value
	[m_Result AddEquation:cardeqn];
	m_DoCalculation = NO;
	
	[self hideOperands];
	[m_SignsButton Reset];
	
	bRet = YES;
	return bRet;
}	

- (BOOL)IsDealCalculationComplete
{
	BOOL bRet = NO;

	int nNouseTempCard = 0;
	int nResultTempCard = 0;
	for(int i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES && [m_BasicCard[i] AsNoUsed] == YES)
		{
			return NO;
		}	
		if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsNoUsed] == YES)
		{
			nNouseTempCard++;
			if(1 < nNouseTempCard)
				return NO;
		}	
		if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsResult] == YES)
		{
			if(0 < nNouseTempCard)
				return NO;
			
			nResultTempCard++;
		}	
	}	
	
	if(nResultTempCard == 1 && nNouseTempCard == 0)
		bRet = YES;
	else if(nResultTempCard == 0 && nNouseTempCard == 1)
	{
		int nIndex1 = [self getOperand1Index];
		int nIndex2 = [self getOperand2Index];
		if(nIndex1 < 0 && nIndex2 < 0)
			bRet = YES;
	}	
	
	return bRet;
}

- (BOOL)IsDealFinalAnswerRight
{
	BOOL bRet = NO;
	
	int nNouseTempCard = 0;
	int nResultTempCard = 0;
	int nResult = -1;
	for(int i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES && [m_BasicCard[i] AsNoUsed] == YES)
		{
			return NO;
		}	
		if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsNoUsed] == YES)
		{
			nNouseTempCard++;
			nResult = [m_TempCard[i] GetCardValue];
			if(1 < nNouseTempCard)
				return NO;
		}	
		if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsResult] == YES)
		{
			if(0 < nNouseTempCard)
				return NO;
			
			nResult = [m_TempCard[i] GetCardValue];
			nResultTempCard++;
		}	
	}	
	
	if(nResultTempCard == 1 && nNouseTempCard == 0)
	{	
		if(nResult == GetGamePoint())
			bRet = YES;
	}
	else if(nResultTempCard == 0 && nNouseTempCard == 1)
	{
		int nIndex1 = [self getOperand1Index];
		int nIndex2 = [self getOperand2Index];
		if(nIndex1 < 0 && nIndex2 < 0 && nResult == GetGamePoint())
			bRet = YES;
	}	
	
	return bRet;
}	

- (BOOL)CheckDealRightAnswer
{
	for(int i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES && [m_BasicCard[i] AsNoUsed] == YES)
		{
			return NO;
		}	
		if([m_TempCard[i] IsLive] == YES && [m_TempCard[i] AsNoUsed] == YES)
		{
			return NO;
		}	
	}	
	//Check value1
	int nValue1 = [self getOperand1Value];
	if(nValue1 < 0)
	{	
		return NO;
	}	
	
	//Check value2
	int nValue2 = [self getOperand2Value];
	if(nValue2 < 0)
	{	
		return NO;
	}	
	
	int nResult = [self getResultValue];
	if(nResult == GetGamePoint())
	{	
		//[self CloseCurrentDealWithRightAnswer];
		return YES;
	}	
	
	return NO;
	
}	

- (void)ClearCalculationQueue
{
	[m_Result Clear];
}

- (void)SubmitLeftEquation
{
	int nIndex1 = [self getOperand1Index];
	if(nIndex1 < 0)
		return;
	
	int nIndex2 = [self getOperand2Index];
	if(nIndex2 < 0)
		return;
	
	int nResult = [self getResultIndex];
	if(nResult < 0)
		return;
	
	int nOperation = [m_SignsButton GetOperation];
	
	CardEquation* cardeqn = [[[CardEquation alloc] init] autorelease];
	cardeqn.m_nOperation = nOperation;
	cardeqn.m_Operand1Card = nIndex1;  //This the card index, not card value
	cardeqn.m_Operand2Card = nIndex2;  //This the card index, not card value
	cardeqn.m_ResultCard = nResult;  //This the card index, not card value
	[m_Result AddEquation:cardeqn];
	m_DoCalculation = NO;
}

- (void)HandleLobbyGameDealWin
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if(m_DoCalculation == YES)
        {
            [self SubmitLeftEquation];
        }
        
        GameMessage* msg = [[GameMessage alloc] init];
        [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMEPLAYENDWIN];
        NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
        [self FormatWinResultArray:array];
        [GameMsgFormatter AddMsgArray:msg withKey:GAME_MSG_KEY_GAME_WINRESULT withArray:array];
        [GameMsgFormatter EndFormatMsg:msg];
        [pGKDelegate SendMessageToAllplayers:msg];
        [msg release];
        //[m_Game.m_Answers AddAnswer:m_Result];
        [m_DealView SetMyselfResultStateAs:YES withResult:m_Result];
        [self ShowStatusBar:[StringFactory GetString_YouWin] showFlag:YES];
        
        [m_Bulletin AddWinScore];
        [m_Result release];
        m_Result = [[DealResult alloc] init];
    }
}

- (void)CloseCurrentDealWithRightAnswer
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        [self HandleLobbyGameDealWin];
        return;
    }
    
    [self ShowStatusBar:[StringFactory GetString_YouWin] showFlag:YES];
	
	[m_Bulletin AddWinScore];
	if(m_DoCalculation == YES)
	{
		[self SubmitLeftEquation];
	}	
	[m_Game.m_Answers AddAnswer:m_Result];
    [m_Result release];
	m_Result = [[DealResult alloc] init];
	[self MoveOutOldDeal];
}	

- (void)HandleLobbyGameDealLose
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        GameMessage* msg = [[GameMessage alloc] init];
        [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMEPLAYENDLOSE];
        [GameMsgFormatter EndFormatMsg:msg];
        [pGKDelegate SendMessageToAllplayers:msg];
        [msg release];
        [self ShowStatusBar:[StringFactory GetString_YouLose] showFlag:NO];
        
        [m_DealView SetMyselfResultStateAs:NO withResult:m_Result];
        [self ClearCalculationQueue];
    }
}

- (void)CloseCurrentDealWithoutRightAnswer
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        [self HandleLobbyGameDealLose];
        return;
    }
    
    [self ShowStatusBar:[StringFactory GetString_YouLose] showFlag:NO];
	
	[self ClearCalculationQueue];
	[self MoveOutOldDeal];
}	

- (void)UndoDeal
{
	if(0 < m_DealView.m_nAnimationLock)
		return;
	
	CGRect rect;
	for(int i = 0; i < 4; ++i)
	{
		rect = [CGameLayout GetBasicCardRect:i];
		[m_BasicCard[i] setFrame:rect];
		[m_BasicCard[i] Show];
		[m_BasicCard[i] ClearCardState];
		[m_BasicCard[i] setNeedsDisplay];
		
		[m_TempCard[i] Hide];
		[m_TempCard[i] ClearCardState];
		[m_TempCard[i] setNeedsDisplay];
	}
	[m_SignsButton Reset];
	[self ClearCalculationQueue];
}	


- (void)ForceToNextDeal
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
	if(0 < m_DealView.m_nAnimationLock && [pGKDelegate IsInLobby] == NO)
		return;
	
	if([self IsDealFinalAnswerRight] == YES)
		[self CloseCurrentDealWithRightAnswer];
	else 
		[self CloseCurrentDealWithoutRightAnswer];
}	

-(void)SynchonzeGameCardList
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES && [pGKDelegate IsGameLobbyMaster] == YES)
    {
        GameMessage* msg = [[GameMessage alloc] init];
        [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMECARDLIST];
        NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
        [self ForamtNewGameArray:array];
        [GameMsgFormatter AddMsgArray:msg withKey:GAME_MSG_KEY_GAME_CARDLIST withArray:array];
        [GameMsgFormatter EndFormatMsg:msg];
        [pGKDelegate SendMessageToAllplayers:msg];
        [msg release];
    }
}

- (void)StartNewGame
{
	[m_Bulletin Reset];
	[m_ResultView EndResult];
    [self ClearCalculationQueue];
	
	if(0 < m_DealView.m_nAnimationLock)
		return;

    [self Shuffle];
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES && [pGKDelegate IsGameLobbyMaster] == YES)
    {
        [self SynchonzeGameCardList];
		[self GoToNextDeal];
        return;
    }
    
	if([self MoveOutOldDeal] == NO)
	{
		[self GoToNextDeal];
	}	
    
}	

- (void)StartNewLobbyGameWithoutShuffle
{
	[m_Bulletin Reset];
	[m_ResultView EndResult];
    [self ClearCalculationQueue];
	
	if(0 < m_DealView.m_nAnimationLock)
		m_DealView.m_nAnimationLock = 0;
    
	if([self MoveOutOldDeal] == NO)
	{
		[self GoToNextDeal];
	}	
    
}

- (void)SwitchTheme
{
	for(int i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES)
		{
			[m_BasicCard[i] SwitchTheme];
		}	
		if([m_TempCard[i] IsLive] == YES)
		{
			[m_TempCard[i] SwitchTheme];
		}	
	}
}	

- (BOOL)IsResultValid
{
    BOOL bRet = (m_Game != nil && m_Game.m_Answers != nil && 0 < [m_Game.m_Answers GetSize]);
    
    return bRet;
}

- (int)GetResultCount
{
    int n = [m_Game.m_Answers GetSize];
    return n;
}

- (DealResult*)GetResult:(int)index
{
    DealResult* pRet = nil;
    
    if(0 <= index && index < [m_Game.m_Answers GetSize])
    {    
        pRet = [m_Game.m_Answers GetAnswer:index];
    }
    return pRet;
}


- (void)OnResultViewShow:(id)sender
{
    m_bResultAnimation = NO;
    int nPoint = GetGamePoint();
    int nScore = [self GetResultCount];
    [m_ResultView StartResult:nPoint withScore:nScore];
}

- (void)AddNewGameScore
{
	[self SetCurrentTime];
	int nScore = [m_Game.m_Answers GetSize];
	[m_Scores AddScore:GetGamePoint() withSpeed: GetGameSpeed() withScore:(double)nScore];
	[m_Scores SaveScoresToPreference];
}	

- (void)GotoResult
{
    [GUIEventLoop SendEvent:GUIID_EVENT_OPENPURCHASEALERT eventSender:self];
	[self AddNewGameScore];

    m_bResultAnimation = YES;

    [self OnResultViewShow:nil];
    [m_ResultView OpenView];
    
}

- (void)GotoNewGame
{
    m_bResultAnimation = NO;
    [m_DealView StartNewGame];
    [GUIEventLoop SendEvent:GUIID_EVENT_CLOSEPURCHASEALERT eventSender:self];
}

- (BOOL)InAnimation
{
    BOOL bRet = NO;
    
    if(m_bResultAnimation == YES)
        bRet = YES;
    
    return bRet;
}

- (void)SaveScores
{
	[m_Scores SaveScoresToPreference];
}

- (void)SavePoints
{
	[m_Scores SaveGamePoints];
}

- (void)SaveSpeed
{
    [m_Scores SaveGameSpeed];
}

- (void)SaveBackground
{
	[m_Scores SaveBackground];
}

- (BOOL)FormatWinResultArray:(NSMutableArray*)array
{
    BOOL bRet = NO;
    
    if(m_Result != nil)
    {
        [m_Result ToFormatArray:array];
        bRet = YES;
    }
    
    return bRet;
}

- (BOOL)ForamtNewGameArray:(NSMutableArray*)array
{
    BOOL bRet = NO;
   
    if(m_Game != nil)
    {
        [m_Game ToFormatArray:array];
        bRet = YES;
    }
    
    return bRet;
}

- (BOOL)SetNewGameFromFormatArray:(NSArray*)array
{
    BOOL bRet = NO;
    
    if(m_Game != nil)
    {
        [m_Game FromFormatArray:array];
        bRet = YES;
    }
    
    return bRet;
}

- (void)OnBasicCardReset1:(id)sender
{
    [m_BasicCard[0] Hide];
}

- (void)OnBasicCardReset2:(id)sender
{
    [m_BasicCard[1] Hide];
}

- (void)OnBasicCardReset3:(id)sender
{
    [m_BasicCard[2] Hide];
}

- (void)OnBasicCardReset4:(id)sender
{
    [m_BasicCard[3] Hide];
}

- (void)OnTempCardReset1:(id)sender
{
    [m_TempCard[0] Hide];
}

- (void)OnTempCardReset2:(id)sender
{
    [m_TempCard[1] Hide];
}

- (void)OnTempCardReset3:(id)sender
{
    [m_TempCard[2] Hide];
}

- (void)OnTempCardReset4:(id)sender
{
    [m_TempCard[3] Hide];
}

- (void)ResetGame
{
	m_DealView.m_nAnimationLock = 0;
	CGContextRef context = UIGraphicsGetCurrentContext();
	if([m_BasicCard[0] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[0] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardReset1:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[0] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_BasicCard[1] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[1] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardReset2:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[1] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_BasicCard[2] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[2] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardReset3:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[2] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_BasicCard[3] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[3] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardReset4:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[3] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_TempCard[0] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_TempCard[0] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardReset1:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[0] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_TempCard[1] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_TempCard[1] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardReset2:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[1] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_TempCard[2] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_TempCard[2] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardReset3:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[2] cache:YES];
		[UIView commitAnimations];
	}	
	
	if([m_TempCard[3] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_TempCard[3] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardReset4:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[3] cache:YES];
		[UIView commitAnimations];
	}
    [m_Game clear];
	[m_Bulletin Reset];
	[m_ResultView EndResult];
    [self ClearCalculationQueue];
}

- (void)ResetLobbyGameDeal
{
	m_DealView.m_nAnimationLock = 0;
	CGContextRef context = UIGraphicsGetCurrentContext();
	if([m_BasicCard[0] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[0] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardReset1:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[0] cache:NO];
		[UIView commitAnimations];
        //NSLog(@"ResetLobbyGameDeal m_BasicCard[0] Curup");
	}	
	
	if([m_BasicCard[1] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[1] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardReset2:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[1] cache:NO];
		[UIView commitAnimations];
        //NSLog(@"ResetLobbyGameDeal m_BasicCard[1] Curup");
	}	
	
	if([m_BasicCard[2] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[2] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardReset3:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[2] cache:NO];
		[UIView commitAnimations];
        //NSLog(@"ResetLobbyGameDeal m_BasicCard[2] Curup");
	}	
	
	if([m_BasicCard[3] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_BasicCard[3] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnBasicCardReset4:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_BasicCard[3] cache:NO];
		[UIView commitAnimations];
        //NSLog(@"ResetLobbyGameDeal m_BasicCard[3] Curup");
	}	
	
	if([m_TempCard[0] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_TempCard[0] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardReset1:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[0] cache:NO];
		[UIView commitAnimations];
        //NSLog(@"ResetLobbyGameDeal m_TempCard[0] Curup");
	}	
	
	if([m_TempCard[1] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_TempCard[1] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardReset2:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[1] cache:NO];
		[UIView commitAnimations];
        //NSLog(@"ResetLobbyGameDeal m_TempCard[1] Curup");
	}	
	
	if([m_TempCard[2] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_TempCard[2] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardReset3:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[2] cache:NO];
		[UIView commitAnimations];
        //NSLog(@"ResetLobbyGameDeal m_TempCard[2] Curup");
	}	
	
	if([m_TempCard[3] IsLive] == YES)
	{
		[UIView beginAnimations:nil context:context];
		[m_TempCard[3] setAlpha:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnTempCardReset4:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:m_TempCard[3] cache:NO];
		[UIView commitAnimations];
        //NSLog(@"ResetLobbyGameDeal m_TempCard[3] Curup");
	}
    m_bDealTimeCounting = NO;
    [self ClearCalculationQueue];
}

- (BOOL)IsGameDealComplete
{
	for(int i = 0; i < 4; ++i)
	{
		if([m_BasicCard[i] IsLive] == YES || [m_TempCard[i] IsLive] == YES)
            return NO;
	}
    
    return YES;
}


- (void)ShowStatusBar:(NSString*)text showFlag:(BOOL)bWin
{
    [m_StatusBar SetWinState:bWin];
}

@end
