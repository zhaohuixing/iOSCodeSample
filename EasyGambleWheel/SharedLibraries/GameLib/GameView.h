//
//  GameView.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 2010-03-16.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GameConstants.h"
#import "GamePlayer.h"

@class CGameSectionManager; 

@interface GameView : UIView

//@property (nonatomic) int m_nAnimationLock;

- (id)initWithFrame:(CGRect)frame;
- (void)OnTimerEvent;
- (void)UpdateGameLayout;
-(void)InitializeDefaultPlayersConfiguration;
//GameUIDelegate methods
-(void)UpdateGameUI;
-(void)RegisterSubUIObject:(id)subUI;
-(void)MakePlayerManualPledge:(int)nSeatID;
-(void)MakePlayerTransaction:(int)nSeatID;
-(void)UpdateForGameStateChange;
-(void)UpdateForGameTypeChange;
-(void)DelayRegisterGameController;
-(GamePlayer*)GetMyself;

//???
- (int)GetMyCurrentMoney;
- (void)AddMoneyToMyAccount:(int)nChips;
- (int)GetPlayerCurrentMoney:(int)nSeat;
- (void)AddMoneyToPlayerAccount:(int)nChips SeatID:(int)nSeat;

- (void)RedeemAdViewClosed;
- (BOOL)CanOpenRedeemView;


-(NSString*)GetPlayerName:(int)nSeatID;

-(void)CancelPendPlayerBet;
-(int)GetGameType;
-(int)GetGameState;
-(void)SetSystemOnHold:(BOOL)bOnHold;
-(BOOL)IsOnline;
-(void)ResetGameStateAndType;
-(BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID;
-(void)PlayerFinishPledge:(int)nSeat withNumber:(int)nLuckNumber withBet:(int)nBetMoney;   
-(void)PlayerTranfereChipsFrom:(int)nSeat To:(int)nReceiverID withChips:(int)nChips;   

//-(void)StartNewGame;
- (void)PauseGame;
- (void)ResumeGame;

- (CGameSectionManager*)GetGameController;

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player;
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags;

-(void)HoldMyTurnIfNeeded;

-(void)Terminate;
-(void)RegisterGKInvitationListener;
-(void)GotoOfflineGame;

@end
