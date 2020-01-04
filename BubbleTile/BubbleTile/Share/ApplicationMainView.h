//
//  ApplicationMainView.h
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 2010-09-05.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "DebogConsole.h"
#import "MainUIView.h"
#import "GameView.h"
#import "ScoreView.h"
#import "SNSShareView.h"
#import "AdBannerHostView.h"
#import "LeaderBoardSelectView.h"
#import "GameCenterPostView.h"
//#import "AchievementSelectView.h"
//#import "AchievementPostView.h"
#import "FriendView.h"
#import "WizardView.h"
#import "ExtendAdView.h"
#import "HouseAdHostView.h"
#import "GameFileSaveView.h"
#import "GameFileListView.h"
#import "PreviewView.h"
#import "PlayHelpView.h"
#import "PurchaseSuggestView.h"
#import "RedeemClickAdHostView.h"
#import "VerificationController.h"
#import "HelpView.h"
#import "PlayerOnlineStatusView.h"

@interface ApplicationMainView : MainUIView<SKProductsRequestDelegate, SKPaymentTransactionObserver, VerificationControllerDelegate> 
{
	GameView*				m_GameView;
	ScoreView*				m_ScoreView;
	SNSShareView*			m_ShareView;
    LeaderBoardSelectView*  m_LeaderBoardView;
    GameCenterPostView*     m_GameCenterPostView;
    FriendView*              m_FriendView;
    //AchievementSelectView*  m_AchievementView;
    //AchievementPostView*    m_AchievementPostView;
    WizardView*             m_Wizard;
    GameFileSaveView*       m_FileSaveView;
    GameFileListView*       m_FileListView;
    PreviewView*            m_PreviewView;
    PlayHelpView*           m_PlayHelpSelectionView;
    HelpView*               m_ScoreCalculationHelpView;
    PlayerOnlineStatusView* m_OnlinePlayerStatusView;
    
    AdBannerHostView*       m_AdViewBottom;    
    ExtendAdView*           m_ExtendAdView;
    HouseAdHostView*        m_HouseAdView;
    RedeemClickAdHostView*  m_RedeemAdView;
    
    CustomDummyAlertButtonView*     m_DummyAlert;
    PurchaseSuggestView*            m_PurchaseAskView;
    NSTimeInterval                  m_TimeStartShowm_PurchaseAskView;
    
    int                     m_nFlashAdDisplayCount;
    BOOL                    m_bFlashAdShowing;

	NSMutableString*		log;
    
    UIActivityIndicatorView*    m_Spinner;
 
    CustomDummyAlertView*     m_StatusBar;
    float                     m_StatusBarStartTime;  
    
#ifdef DEBUG
	UIButton*				m_TestSaveCacheButton;
	UIButton*				m_TestLoadCacheButton;
	UILabel*                m_DebugMsgDisplay;
#endif    

    int                     m_nPurchaseReciptCheckState;
}

@property (retain)				NSMutableString *log;

-(void)InitSubViews;
-(void)UpdateSubViewsOrientation;
-(void)UpdateAdViewsState;

-(void)OnTimerEvent;

//-(void)OnOpenConfigureView:(id)sender;
-(void)OnOpenScoreView:(id)sender;
-(void)OnOpenShareView:(id)sender;
-(void)OnPurchase:(id)sender;
-(void)OnFileSave:(id)sender;
-(void)OnPlayHelpViewOpen:(id)sender;

-(void)ResumeAds;
-(void)PauseAds;

-(void)ShowSpinner;
-(void)HideSpinner;

-(void)ShowFlashAdView;
-(void)HideFlashAdView;
-(void)OnFullScreenAdDone:(id)sender;

-(void)OnOpenWizardView:(id)sender;
-(void)OnPaidFeaturePopup:(id)sender;

- (void)SwitchToPaidVersion;
//- (void)BuyAction;

- (void)HandleAdRequest:(NSURL*)url;
- (void)AdViewClicked;
- (void)DismissExtendAdView;
- (void)StartNewGame:(BOOL)bLoadCacheData;
- (BOOL)IsGameComplete;
- (void)LoadGameSet:(NSMutableDictionary**)dataDict;
//- (void)LoadUndoList:(NSMutableDictionary**)dataDict withKey:(NSString*)szKey;
- (void)LoadUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index;

- (void)OpenPreviewView:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withLevel:(BOOL)bEasy withBubble:(enBubbleType)enBubbleType withSetting:(NSArray*)setting;

- (void)OnFileSaveViewClosed;
- (void)OnFileOpenViewCancelled;
- (void)OnFileOpenViewClosedForInAppPurchase;
- (void)OnFileOpenViewClosedWithSelectedGameFile;
- (void)OnGamePlayHelpViewClosed;
- (void)StartPlayHelpAnimation:(int)nSelectedType;
- (void)StartGameFromFile:(NSURL*)fileUrl;
- (void)OnCustomDummyAlertViewClosed;
- (void)OnGameWinEvent;
- (void)OnOpenScorHelpView;

- (void)GotoRedeemProcess;
- (void)OnSNPostDone;
- (void)RedeemAdpopupViewClose;
-(void)CheckTemporaryPaidFeatureAccess;
-(void)PostTemporaryAccessDayLeftOnStatusBar;
-(void)ShowStatusBar;
-(void)HideStatusBar;
-(void)CloseRedeemAdView;
-(void)repurchase;
-(void)ShowTextOnStatusBar:(NSString*)text;
#ifdef DEBUG
- (void)ShowDebugMessage:(NSString*)msg;
#endif

@end
