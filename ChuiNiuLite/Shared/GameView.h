//
//  GameView.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-27.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GameControllerDelegate.h"
#import "GlossyMenuView.h"

@class GameScene;
@class TextMsgPoster;
@class GameRobo2;
@class SpinnerBtn;
@class PlayerBadget;

@interface GameView : GlossyMenuView <GameControllerDelegate, GameTimerEventDelgate, AVAudioPlayerDelegate> 
{
	UIButton*				m_SystemButton;
	UIButton*				m_PlayButton;
	UIButton*				m_HelpButton;
	UIButton*				m_MouthButton;
	UIButton*				m_FingerButton;
	SpinnerBtn*			m_LobbyButton;
	SpinnerBtn*			m_LobbyCloseButton;
	UIButton*			m_MicButton;
	UIButton*			m_MicMuteButton;
	UIButton*			m_TextMsgButton;
    TextMsgPoster*      m_TextMsgEditor;
    GameRobo2*          m_Avatar1;
    GameRobo2*          m_Avatar2;
    GameRobo2*          m_Avatar3;
    PlayerBadget*       m_Badget;
	
    
    GameScene*				m_Game;
	int						m_nLoseSceneFlash;
    BOOL					m_bMenuAnimtation;
}

@property (nonatomic, retain)			GameScene*	m_Game;
@property (nonatomic)int				m_nLoseSceneFlash;

-(void)CreateMenu;
-(void)OnMenuHide;
-(void)OnMenuShow;
-(void)OnMenuEvent:(int)menuID;
-(void)OnMenuPlay:(id)sender;
-(void)OnMenuSound:(id)sender;
-(void)OnMenuBkGnd:(id)sender;
-(void)OnMenuSetting:(id)sender;
-(void)OnMenuScore:(id)sender;
-(void)OnMenuShare:(id)sender;
-(void)OnMenuClock:(id)sender;
-(void)OnMenuBuyIt:(id)sender;
-(void)PlayButtonClick;
-(void)StartNewLobbyGame;

-(void)onTimerEvent:(id)sender;
-(BOOL)isPlayingSound;
-(void)playSound:(int)sndID;
-(void)stopSound:(int)sndID;
-(void)playBlockageSound;
-(void)switchToBackgroundSound;
		

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player;
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags;

-(void)playBackgroundSound;
-(void)stopAllSoundPlay;
-(void)pauseSoundPlay;
-(void)resumeSoundPlay;
	
-(void)updateGameEndState;
-(void)updatePlayerLobbyWinScore;
-(void)invalidate;

-(void)startGame;
-(void)resetGame;
-(void)stopGame;
-(void)pauseGame;
-(void)resumeGame;
-(void)setButtonsLabel;
-(void)initButtons;
-(void)updateGameLayout;
-(BOOL)GameOverPresentationDone;

-(BOOL)IsUIEventLocked;
-(void)RemovePurchaseButton;

- (void)EnableLobbyUI:(BOOL)bEnable;
- (void)OnLobbyStartedEvent;
- (void)ResetCurrentPlayingGame;
- (void)ShowLobbyControls:(BOOL)bShow;
- (void)HandleDebugMsg:(NSString*)msg;
- (void)AddPlayerAvatarInLobby:(NSString*)playerID withName:(NSString*)szName;
- (void)RemovePlayerAvatarFromLobby:(NSString*)playerID;
- (void)ShowTextMessage:(NSString*)szText from:(NSString*)playerID;
- (void)PlayerStartWriteTextMessage:(NSString*)playerID;
- (void)PlayerStartTalking:(NSString*)playerID;
- (void)PlayerStopTalking:(NSString*)playerID;
- (BOOL)SetPlayerAvatarAsMaster:(NSString*)playerID;
- (BOOL)SetPlayerAvatarHighLight:(NSString*)playerID;
- (BOOL)IsPlayerAvatarHighLight:(NSString*)playerID;
- (BOOL)HasAvatar;
- (void)UpdateActivePlayerScore;
- (void)SetPlayerBestScore:(NSString*)playerID withScore:(int)nBest;
- (void)SetGamePlayerResult:(NSString*)playerID withResult:(int)nResult;

- (BOOL)IsMySelfActive;
- (BOOL)IsPlayer1Active;
- (BOOL)IsPlayer2Active;
- (BOOL)IsPlayer3Active;
- (NSString*)GetMyPlayerID;
- (NSString*)GetPlayer1PlayerID;
- (NSString*)GetPlayer2PlayerID;
- (NSString*)GetPlayer3PlayerID;

- (int)NomiateGKCenterMasterInPeerToPeer;

-(void)HideNonPlayingButtons;
-(void)ShowNonPlayingButtons;
-(void)ShowLobbyButton;
-(void)HideLobbyButton;

@end
