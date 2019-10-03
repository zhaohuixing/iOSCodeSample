//
//  ApplicationMainView.h
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 2010-09-05.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MainUIView.h"
#import "GameView.h"
#import "ConfigurationView.h"
#import "ScoreView.h"
#import "SNSShareView.h"
//#import "Ad320x50View.h"
//#import "AdBannerView.h"
#import "AdBannerHostView.h"
#import "LeaderBoardSelectView.h"
#import "GameCenterPostView.h"
#import "AchievementSelectView.h"
#import "AchievementPostView.h"
#import "ExtendAdView.h"
#import "HouseAdHostView.h"
#import "RedeemClickAdHostView.h"
#import "CustomDummyAlertView.h"
#import "FriendView.h"
#import "HelpView.h"
#import "PlayerOnlineStatusView.h"

@interface ApplicationMainView : MainUIView<SKProductsRequestDelegate, SKPaymentTransactionObserver>  
{
	GameView*				m_GameView;
	ConfigurationView*		m_ConfigureView;
	ScoreView*				m_ScoreView;
	SNSShareView*			m_ShareView;
    LeaderBoardSelectView*  m_LeaderBoardView;
    GameCenterPostView*     m_GameCenterPostView;
    AchievementSelectView*  m_AchievementView;
    AchievementPostView*    m_AchievementPostView;
    FriendView*              m_FriendView; 
    HelpView*               m_HelpView;
    PlayerOnlineStatusView* m_OnlinePlayerStatusView;
    
    AdBannerHostView*       m_AdViewBottom;    
    RedeemClickAdHostView*  m_AdFlashView;
    ExtendAdView*           m_ExtendAdView;
    HouseAdHostView*        m_HouseAdView;
    
	CGImageRef				m_LandscapeCheckerImage;
	CGImageRef				m_ProtraitCheckerImage;

    int                     m_nFlashAdDisplayCount;
    BOOL                    m_bFlashAdShowing;
	NSMutableString*		log;

    UIActivityIndicatorView*    m_Spinner;
    
    BOOL                    m_bAdsLoad;
    
    CustomDummyAlertView*     m_StatusBar;    
    float                     m_StatusBarStartTime;  
    
}

@property (retain)				NSMutableString *log;

-(void)InitSubViews;
-(void)UpdateSubViewsOrientation;
-(void)UpdateAdViewsState;

-(void)OnTimerEvent;

-(void)OnOpenConfigureView:(id)sender;
-(void)OnOpenScoreView:(id)sender;
-(void)OnOpenShareView:(id)sender;
-(void)OnOpenFriendView:(id)sender;

-(void)ResumeAds;
-(void)PauseAds;

-(void)ShowSpinner;
-(void)HideSpinner;
-(void)DelayLoadAds;

-(void)ShowFlashAdView;
-(void)HideFlashAdView;
-(void)OneFuldlScreenAdDone:(id)sender;


- (void)SwitchToPaidVersion;
- (void)BuyAction;

-(void)OnLobbyStartedEvent;
-(void)ResetCurrentPlayingGame;
-(void)StartLobbyGame;

- (void)EnableLobbyUI:(BOOL)bEnable;
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
- (void)GameConfigureChange;

- (void)HandleAdRequest:(NSURL*)url;
- (void)AdViewClicked;
- (void)DismissExtendAdView;
- (void)InterstitialAdViewClicked;
- (void)CloseRedeemAdView;

- (BOOL)IsMySelfActive;
- (BOOL)IsPlayer1Active;
- (BOOL)IsPlayer2Active;
- (BOOL)IsPlayer3Active;
- (NSString*)GetMyPlayerID;
- (NSString*)GetPlayer1PlayerID;
- (NSString*)GetPlayer2PlayerID;
- (NSString*)GetPlayer3PlayerID;

- (int)NomiateGKCenterMasterInPeerToPeer;
- (void)StartNewLobbyGame;

-(void)ShowStatusBar:(NSString*)text;
-(void)HideStatusBar;
-(void)OnPostGameWinMessage;
-(void)OnPostGameLostMessage;
-(void)ShowLobbyButton;
-(void)HideLobbyButton;
-(void)OnOpenHelpView;

-(void) repurchase;
-(void)OnOpenOnlineGamerStatusView;
-(void)OnAWSServiceFailed;
@end
