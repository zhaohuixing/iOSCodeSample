//
//  ApplicationMainView.h
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 2010-09-05.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "GameConstants.h"

#import "CCompassRender.h"

#import "CPinRender.h"
#import "CashMachine.h"
#import "CashEarnDisplay.h"
#import "WizardView.h"
#import "OverLayView.h"
#import "PledgeView.h"
#import "ScoreView.h"
#import "TransactionView.h"
#import "SpinnerBtn.h"
#import "GameCenterPostView.h"
#import "FriendView.h"
#import "GameConstants.h"
#import "GameStatusBar.h"
#import "AnimalThemePledgeView.h"
#import "InAppPurchaseSelectionView.h"
#import "GlossyMenuView.h"

@class GameView;

@interface ApplicationMainView : GlossyMenuView<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic)				NSMutableString *log;

-(void)InitSubViews;
-(void)UpdateSubViewsOrientation;
-(void)ShowSpinner;
-(void)HideSpinner;
-(GameView*)GetGameView;

-(void)OnTimerEvent;

-(void)InitializeDefaultPlayersConfiguration;

- (void)CloseTransactionProcess;
- (void)CloseStatusBar;

- (void)OpenPlayerPledgeView:(int)nSeat;
- (void)OnClosePlayerPledgeView;

- (void)OpenPlayerTransactionView:(int)nSeat;
- (void)OnClosePlayerTransactionView;

//Menu items methods
-(void)CreateMenu;
-(void)OnMenuHide;
-(void)OnMenuShow;
-(void)OnMenuEvent:(int)menuID;
-(void)OnMenuSetting:(id)sender;
-(void)OnMenuScore:(id)sender;
-(void)OnMenuShare:(id)sender;
-(void)OnMenuPlay:(id)sender;
-(void)OnMenuShare:(id)sender;
-(void)OnMenuFriend:(id)sender;

-(void)ResetSate;
-(BOOL)IsUIEventLocked;
-(void)OnGameStateChange;
-(void)OnPurchaseChips;

//???
- (int)GetMyCurrentMoney;
- (void)AddMoneyToMyAccount:(int)nChips;
- (int)GetPlayerCurrentMoney:(int)nSeat;
- (void)AddMoneyToPlayerAccount:(int)nChips SeatID:(int)nSeat;
- (BOOL)IsRedeemAdViewOpened;
- (NSString*)GetPlayerName:(int)nSeatID;
- (BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID;
- (void)PauseGame;
- (void)ResumeGame;
- (void)OnInAppPurchase;

- (id<GameControllerDelegate>)GetGameController;

- (void)GKOnlineRequestCancelled;
- (void)GKOnlineRequestDone;
-(void)OpenOnlineGKPlayerListViewForGameCenterGame;

- (void)CreateNewOnlineGame;
- (void)CreateSearchOnlineGame;
- (void)UpdateOnlineButtonsStatus;
- (void)StartOnlineButtonSpin;
- (void)StopOnlineButtonSpin;
- (void)CreateNewGKBTSessionGame;

- (void)ShowStatusBar:(NSString*)text;

-(void)GotoOnlineGame;
-(void)PurchaseInAppItem:(int)nItemIndex;

-(void)Terminate;
-(void)RegisterGKInvitationListener;

@end
