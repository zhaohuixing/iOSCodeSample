//
//  ApplicationMainView.h
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 2010-09-05.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <GameKit/GameKit.h>
#import "MainUIView.h"
#import "GameView.h"
#import "PointsView.h"
#import "ScoreView.h"
#import "SNSShareView.h"
#import "AdBannerHostView.h"
//#import "AdBannerView.h"
#import "LeaderBoardSelectView.h"
#import "GameCenterPostView.h"
#import "AchievementSelectView.h"
#import "AchievementPostView.h"
#import "ExtendAdView.h"
#import "HouseAdHostView.h"
#import "GameStatusBar.h"
#import "CustomDummyClickView.h"
#import "FriendView.h"
#import "RedeemClickAdHostView.h"

@interface ApplicationMainView : MainUIView<SKProductsRequestDelegate, SKPaymentTransactionObserver> 
{
	GameView*				m_GameView;
	PointsView*             m_PointsView;
	ScoreView*				m_ScoreView;
	SNSShareView*			m_ShareView;
    LeaderBoardSelectView*  m_LeaderBoardView;
    GameCenterPostView*     m_GameCenterPostView;
    //AchievementSelectView*  m_AchievementView;
    //AchievementPostView*    m_AchievementPostView;
    FriendView*              m_FriendView;

    
    AdBannerHostView*       m_AdViewBottom;    
    RedeemClickAdHostView*  m_RedeemAdView;
    ExtendAdView*           m_ExtendAdView;
    HouseAdHostView*        m_HouseAdView;
    CustomDummyClickView*   m_BuyitAlertView;
    
    int                     m_nFlashAdDisplayCount;
    BOOL                    m_bFlashAdShowing;

	CGImageRef				m_LandscapeCheckerImage;
	CGImageRef				m_ProtraitCheckerImage;
	//CGImageRef              m_TextureWood;

	NSMutableString*		log;
    
    UIActivityIndicatorView*    m_Spinner;
    
    //BOOL                    m_bAdsLoad;
    
    CustomDummyAlertView*     m_StatusBar;
    float                     m_StatusBarStartTime;  
}

@property (retain)				NSMutableString *log;

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message;

-(void)InitSubViews;
-(void)UpdateSubViewsOrientation;
-(void)UpdateAdViewsState;

-(void)OnTimerEvent;

-(void)OnOpenConfigureView:(id)sender;
-(void)OnOpenScoreView:(id)sender;
-(void)OnOpenShareView:(id)sender;
-(void)OnPurchase:(id)sender;

-(void)ResumeAds;
-(void)PauseAds;
//-(void)DelayLoadAds;

-(void)ShowSpinner;
-(void)HideSpinner;

- (void)SwitchToPaidVersion;
- (void)BuyAction;

-(void)OnLobbyStartedEvent;
-(void)ResetCurrentPlayingGame;
-(void)StartLobbyGame;
-(void)StartNewGame;

- (void)EnableLobbyUI:(BOOL)bEnable;
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
- (void)GameConfigureChange;
- (void)SetLobbyGameCardList:(NSArray*)array;
- (void)SetGamePlayerWinResult:(NSString*)playerID withResult:(NSArray*)array;
- (void)SetGamePlayerLoseResult:(NSString*)playerID;
- (void)SetGamePlayerState:(NSString *)playerID withState:(int)nState;
- (void)HandleLobbyGameNextDeal;

- (void)HandleAdRequest:(NSURL*)url;
- (void)AdViewClicked;
- (void)DismissExtendAdView;

- (int)NomiateGKCenterMasterInPeerToPeer;

- (BOOL)IsMySelfActive;
- (BOOL)IsPlayer1Active;
- (BOOL)IsPlayer2Active;
- (BOOL)IsPlayer3Active;
- (NSString*)GetMyPlayerID;
- (NSString*)GetPlayer1PlayerID;
- (NSString*)GetPlayer2PlayerID;
- (NSString*)GetPlayer3PlayerID;


- (void)OnOpenBuyitSuggest:(id)sender;
- (void)OnCloseBuyitSuggest:(id)sender;

-(void)OnOpenFriendView:(id)sender;
-(void)StopLobbyButtonSpin;

-(void)OnOpenRedeemViewForOnlineGame;
-(void)ShowRedeenAdViewForPostGameCenterScore:(int)nScore withPoint:(int)nPoint withSpeed:(int)nSpeed;
-(BOOL)ShowRedeenAdViewForAcceptInvitation;
-(void)CloseRedeemAdView;
-(void)PopupFreeVersionLobbyOption;
-(void)RedeemAdpopupViewClose;
-(void)CloseGameScorePostView:(BOOL)bResult;
-(void)OnGameCenterPostSucceed;
-(void)OnSNPostDone;

-(void)CheckTemporaryPaidFeatureAccess;
-(void)PostTemporaryAccessDayLeftOnStatusBar;
-(void)PostOneTimeTemporaryAccessOnStatusBar;
-(void)ShowStatusBar;
-(void)HideStatusBar;

@end
