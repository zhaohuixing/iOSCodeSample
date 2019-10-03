//
//  DealView.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-16.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "ApplicationResource.h"
#import "ApplicationMainView.h"
#import "GUIEventLoop.h"
#import "CGameSectionManager.h"
#import "GameView.h"
#import "GUILayout.h"
#import "GlossyMenuItem.h"
#import "MultiChoiceGlossyMenuItem.h"
#import "ImageLoader.h"
#import "Configuration.h"
#import "StringFactory.h"
#import "SoundSource.h"
#import "MainAppViewController.h"
#import "ScoreRecord.h"


@interface GameView () <GameUIDelegate, AVAudioPlayerDelegate>
{
    CGameSectionManager*    m_GameController;
}
@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_GameController = [[CGameSectionManager alloc] init];
        [m_GameController SetGameType:[Configuration getCurrentGameType] theme:[Configuration getCurrentGameTheme]];
        [SoundSource InitializeSoundSource:self];
        
	}
    return self;
}

-(void)GotoOfflineGame
{
    [m_GameController GotoOfflineGame];
}

-(void)Terminate
{
    [m_GameController Terminate];
}

-(void)RegisterGKInvitationListener
{
    [m_GameController RegisterGKInvitationListener];
}

-(void)InitializeDefaultPlayersConfiguration
{
    [m_GameController InitializeDefaultPlayersConfiguration];
}

-(void)DelayRegisterGameController
{
    [m_GameController DelayRegisterGameController];
    if([ScoreRecord GetEnableAdBanner] == YES || [ScoreRecord GetMyChipBalance] == 0)
    {
        [(MainAppViewController*)[GUILayout GetRootViewController] setAdBannerEnable:YES];
    }
}

- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);

    CGRect drawRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [m_GameController Draw:context inRect:drawRect];
	CGContextRestoreGState(context);
}


- (void)dealloc 
{
    [SoundSource ReleaseSoundSource];
}

- (void)OnTimerEvent
{
    [m_GameController OnTimerEvent];
	[self setNeedsDisplay];
}	

- (void)UpdateGameLayout
{
    [m_GameController UpdateGameLayout];
    [self setNeedsDisplay];
}	

- (BOOL)canBecomeFirstResponder 
{
	return YES;
}

- (void)UpdateGameUI
{
    [GUIEventLoop SendEvent:GUIID_EVENT_GAMESTATECHANGE eventSender:self];
    [self setNeedsDisplay];
}

-(void)RegisterSubUIObject:(id)subUI
{
    if([subUI isKindOfClass:[UIView class]])
    {
        [self addSubview:subUI];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects];
    int nCount = (int)[allTouches count];
    if(0 < nCount)
    {	
        CGPoint pt = [[allTouches objectAtIndex:0] locationInView:self];
        [m_GameController OnTouchBegin:pt];
    }
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects];
    int nCount = (int)[allTouches count];
    if(0 < nCount)
    {	
        CGPoint pt = [[allTouches objectAtIndex:0] locationInView:self];
        [m_GameController OnTouchMove:pt];
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects];
    int nCount = (int)[allTouches count];
    if(0 < nCount)
    {	
        CGPoint pt = [[allTouches objectAtIndex:0] locationInView:self];
        [m_GameController OnTouchEnd:pt];
    }
    [self setNeedsDisplay];
    return;         
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects];
    int nCount = (int)[allTouches count];
    if(0 < nCount)
    {	
        CGPoint pt = [[allTouches objectAtIndex:0] locationInView:self];
        [m_GameController OnTouchCancel:pt];
    }
    
    [self setNeedsDisplay];
}

//???
- (int)GetMyCurrentMoney
{
    return [m_GameController GetMyCurrentMoney];
}

- (void)AddMoneyToMyAccount:(int)nChips
{
    [m_GameController AddMoneyToMyAccount:nChips];
}

- (int)GetPlayerCurrentMoney:(int)nSeat
{
    return [m_GameController GetPlayerCurrentMoney:nSeat];
}

- (void)AddMoneyToPlayerAccount:(int)nChips SeatID:(int)nSeat
{
    [m_GameController AddMoneyToPlayerAccount:nChips inSeat:nSeat];
}

- (void)RedeemAdViewClosed
{
    [m_GameController RedeemAdViewClosed];
}

- (BOOL)CanOpenRedeemView
{
    BOOL bRet = YES;
    if([(ApplicationMainView*)self.superview IsRedeemAdViewOpened])
        bRet = NO;
    
    return bRet;
}

-(NSString*)GetPlayerName:(int)nSeatID
{
    return [m_GameController GetPlayerName:nSeatID];
}

-(void)CancelPendPlayerBet
{
    [m_GameController CancelPendPlayerBet];
    
    [self setNeedsDisplay];
}

-(int)GetGameType
{
    return [m_GameController GetGameType];
}

-(int)GetGameState
{
    return [m_GameController GetGameState];
}

-(void)SetSystemOnHold:(BOOL)bOnHold
{
    [m_GameController SetSystemOnHold:bOnHold];
}

-(BOOL)IsOnline
{
    return [m_GameController IsOnline];
}

-(void)ResetGameStateAndType
{
    [m_GameController ResetGameStateAndType];
    [self setNeedsDisplay];
}

-(BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID
{
    return [m_GameController CanPlayerPlayGame:nType inSeat:nSeatID];
}

-(void)PlayerFinishPledge:(int)nSeat withNumber:(int)nLuckNumber withBet:(int)nBetMoney
{
    [m_GameController PlayerFinishPledge:nSeat withNumber:nLuckNumber withBet:nBetMoney];
}

-(void)PlayerTranfereChipsFrom:(int)nSeat To:(int)nReceiverID withChips:(int)nChips
{
    [m_GameController PlayerTranfereChipsFrom:nSeat To:nReceiverID withChips:nChips];
}

-(void)MakePlayerManualPledge:(int)nSeatID
{
    [(ApplicationMainView*)self.superview OpenPlayerPledgeView:nSeatID];
}

-(void)MakePlayerTransaction:(int)nSeatID
{
    [(ApplicationMainView*)self.superview OpenPlayerTransactionView:nSeatID];
}

- (CGameSectionManager*)GetGameController
{
    return m_GameController;
}

/*
-(void)StartNewGame
{
    //[m_GameLobby StartNewGame];
    [m_GameController StartNewGame];
}
*/

- (void)PauseGame
{
    [m_GameController PauseGame];
}

- (void)ResumeGame
{
    [m_GameController ResumeGame];
}

-(void)UpdateForGameStateChange
{
    [m_GameController UpdateForGameStateChange];
    [self UpdateGameUI];
}

-(void)UpdateForGameTypeChange
{
    [m_GameController UpdateForGameTypeChange];
    [self UpdateGameUI];
}

-(void)HoldMyTurnIfNeeded
{
    [m_GameController HoldMyTurnIfNeeded];
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	[SoundSource StopPlaySoundFile:player];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if(player && flag == YES)
		[SoundSource StopPlaySoundFile:player];
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
}

-(GamePlayer*)GetMyself
{
    return [m_GameController GetMyself];
}

@end
