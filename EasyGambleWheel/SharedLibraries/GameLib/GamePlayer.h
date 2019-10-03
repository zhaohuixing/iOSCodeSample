//
//  GamePlayer.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-09-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "GameConstants.h"
#import "Packet.h"
#import "GameUtiltyObjects.h"
#import "TextMsgDisplay.h"
#import "TextMsgPoster.h"

@class GambleLobby;
@class ChoiceDisplay;
@class BetIndicator;
@class WinnerAnimator;
@class GambleLobbySeat;
@class PlayerPopupMenu;

@interface GamePlayer : NSObject<IOnlineGamePlayerPopupMenuDelegate, TextMsgBoardDelegate> 
{
@private
    int                     m_nReleaseVersion;
    
    int                     m_nOnlinePlayingState;
    
    //Controller
    id<GameControllerDelegate>  m_GameController;

    //Adornments
    BetIndicator*           m_BetLight;
    ChoiceDisplay*          m_ChoiceLight;
    GambleLobbySeat*        m_MySeat;
    WinnerAnimator*         m_WinFlyer;
    PlayerPopupMenu*        m_PopupMenu;
    TextMsgDisplay*         m_OnLineTextBoard;
    TextMsgPoster*          m_OnlineTextPost;
    
    //Bet
    int                     m_nChoiceNumber;    //Luck number for current bet
    int                     m_nBetMoney;        //The money/chip pledge for current bet
    
    //Wallet
    Packet*                 m_Packet;
    
    //Ids
    NSString*               m_PlayerName;
    NSString*               m_PlayerID;
    int                     m_nSeatID;
    
    //Current turn
    BOOL                    m_bMyturn2Play;
    BOOL                    m_bWinThisPlay;
    
    BOOL                    m_bEnablePlayCurrentGame;
    
    BOOL                    m_bAcitvated;
    BOOL                    m_bMyself;
    
@private
    int                     m_PlayerOnlineState;
    GKPlayer*               m_CachedGKMatchPlayer;
    
    int                     m_nCachedTransferedChip;
    
    
    BOOL                    m_bGKCenterMaster;
    
    BOOL                    m_bOnlinePlayer;
    
    UILabel*                m_OnlinePlayerNameTag;
    
    NSTimeInterval          m_MessageUIStartTime;
}

-(void)IntializePlayerInfo:(NSString*) szName withID:(NSString*)szID inSeat:(int)SeatID isMyself:(BOOL)bMyself inLobby:(id<GameControllerDelegate>)pController;
-(void)SetupPacket:(int)nChips;
-(BOOL)WinThisTime;
-(BOOL)IsMyTurn;
-(void)OnTimerEvent;
-(void)UpdateLayout;
-(void)GameStateChange;
-(void)Draw:(CGContextRef)context;
-(CGRect)GetSeatBound;
-(BOOL)CanPlayGame:(int)nType;

-(void)SetPlayerName:(NSString*)szName;
-(void)SetPlayerID:(NSString*)szPlayerID;
-(void)SetMySelfFlag:(BOOL)bMyself;
-(void)SetSeatID:(int)nSeatID;

-(NSString*)GetPlayerName;
-(NSString*)GetPlayerID;
-(BOOL)IsMyself;
-(int)GetSeatID;


-(BOOL)IsEnabled;
-(void)UpdateCurrentGamePlayablity;

-(void)SetMyTurn:(BOOL)bMyTurn;
-(int)GetPacketBalance;
-(int)AddMoneyToPacket:(int)nChips;
-(int)GenerateAutoOffLineBetLuckNumber:(int)nType;
-(int)GenerateAutoOffLineBetPledge:(int)nType;
-(CPinActionLevel*)GenerateAutoOffLineAction;

-(void)SetPlayResult:(BOOL)bWin;

-(void)MakePlayBet:(int)nLuckNumber withPledge:(int)nBetPledge;
-(void)ShowPlayBet;
-(void)ClearPlayBet;
-(int)GetPlayBetLuckNumber;
-(int)GetPlayBet;
-(BOOL)AlreadyMadePledge;

-(void)SetReleaseVersion:(int)nVersion;
-(int)GetReleaseVersion;
-(BOOL)CanProcessMoneyTransfer;

-(void)SetOnlinePlayingState:(int)nState;
-(int)GetOnlinePlayingState;
-(void)UpdateOnlinePlayingStateByMoneyBalance;

-(void)CancelPendingBet;

//Popup Menu events
-(void)ForceClosePopupMenu;
-(void)RegisterPopupMenuEvent;
-(void)RegisterOfflinePopupMenuEvent;
-(void)RegisterOfflinePopupMenuEventMe;
-(void)RegisterOfflinePopupMenuEventPlayer1;
-(void)RegisterOfflinePopupMenuEventPlayer2;
-(void)RegisterOfflinePopupMenuEventPlayer3;

-(void)OnOpenOfflinePopupMenuMe;
-(void)OnOpenOfflinePopupMenuPlayer1;
-(void)OnOpenOfflinePopupMenuPlayer2;
-(void)OnOpenOfflinePopupMenuPlayer3;

-(void)OnOfflineMeMoneyBalance;
-(void)OnOfflineMeClickToEarn;
-(void)OnOfflineMeSendMenoy;

-(void)OnOfflinePlayer1MoneyBalance;
-(void)OnOfflinePlayer1ClickToEarn;
-(void)OnOfflinePlayer1SendMenoy;

-(void)OnOfflinePlayer2MoneyBalance;
-(void)OnOfflinePlayer2ClickToEarn;
-(void)OnOfflinePlayer2SendMenoy;

-(void)OnOfflinePlayer3MoneyBalance;
-(void)OnOfflinePlayer3ClickToEarn;
-(void)OnOfflinePlayer3SendMenoy;

-(void)Activate:(BOOL)bActivated;
-(BOOL)IsActivated;

-(void)OnMenuEvent:(int)nEventID;

-(void)OnMsgBoardClose;

@end
