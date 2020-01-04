//
//  DealView.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-16.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GlossyMenuView.h"

@class GameBaseView;
@class GameCard;
@class CSignsBtn;
@class DealController;
@class TextMsgPoster;
@class GameRobo2;
@class SpinnerBtn;
@class PlayerBadget;
@class DealResult;

@interface GameView : GlossyMenuView 
{
	UIButton*				m_SystemButton;
	UIButton*				m_UndoButton;
	UIButton*				m_NextButton;
	SpinnerBtn*			m_LobbyButton;
	SpinnerBtn*			m_LobbyCloseButton;
	//UIButton*			m_MicButton;
	//UIButton*			m_MicMuteButton;
	UIButton*			m_TextMsgButton;
    TextMsgPoster*      m_TextMsgEditor;
    GameRobo2*          m_Avatar1;
    GameRobo2*          m_Avatar2;
    GameRobo2*          m_Avatar3;
    PlayerBadget*       m_Badget;
	
    
    
    DealController*			m_DealController;
	int						m_nTouchSemphore;
	int						m_nAnimationLock;
    BOOL					m_bMenuAnimtation;
    BOOL                    m_bFlagForHideAndPlay;
    UIView*                 m_Overlay;
    int                     m_nCachedPoint;
    int                     m_nCachedSpeed;
    
    int                     m_nGhostIndex;
    NSTimeInterval          m_fGhostTimerCount;
}

@property  int m_nAnimationLock;

- (id)initWithFrame:(CGRect)frame;
- (int)GetViewType;
- (void)OnTimerEvent;
- (void)UpdateGameViewLayout;
- (void)UndoDeal;
- (void)NextDeal;
- (void)StartNewGame;
- (void)LobbyGameStartNewGame;
- (void)SwitchTheme;
- (BOOL)GameOverPresentationDone;
- (void)CancelTouchState;

-(void)CreateMenu;
-(void)OnMenuHide;
-(void)OnMenuShow;
-(void)OnMenuEvent:(int)menuID;
-(void)OnMenuPlay:(id)sender;
-(void)OnMenuTheme:(id)sender;
-(void)OnMenuPoints:(id)sender;
-(void)OnMenuBuyIt:(id)sender;
-(void)OnMenuFriend:(id)sender;
-(void)OnPointsChange;

-(BOOL)IsUIEventLocked;
-(void)RemovePurchaseButton;
-(void)NextButtonClick;

//-(void)SynchonzeGameCardList;

- (void)EnableLobbyUI:(BOOL)bEnable;
- (void)OnLobbyStartedEvent;
- (void)ResetCurrentPlayingGame;
- (void)ShowLobbyControls:(BOOL)bShow;
- (void)HandleDebugMsg:(NSString*)msg;
- (void)AddPlayerAvatarInLobby:(NSString*)playerID withName:(NSString*)szName;
- (void)AddMyselfAvatarInLobby:(NSString*)playerID withName:(NSString*)szName;
- (void)AddPlayerAvatarInLobby2:(GKPlayer*)player;
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
- (void)SetLobbyGameCardList:(NSArray*)array;
- (void)SetGamePlayerWinResult:(NSString*)playerID withResult:(NSArray*)array;
- (void)SetGamePlayerLoseResult:(NSString*)playerID;
- (void)SetGamePlayerState:(NSString *)playerID withState:(int)nState;
- (void)HandleLobbyGameNextDeal;
- (void)SetMyselfResultStateAs:(BOOL)bWin withResult:(DealResult*)result;

- (int)NomiateGKCenterMasterInPeerToPeer;

- (BOOL)IsMySelfActive;
- (BOOL)IsPlayer1Active;
- (BOOL)IsPlayer2Active;
- (BOOL)IsPlayer3Active;
- (NSString*)GetMyPlayerID;
- (NSString*)GetPlayer1PlayerID;
- (NSString*)GetPlayer2PlayerID;
- (NSString*)GetPlayer3PlayerID;
- (void)SetMyselfPlayState;
- (void)HandleLobbyGameDealEndProcess;
- (void)StopLobbyButtonSpin;
- (void)PopupFreeVersionLobbyOption;
@end
