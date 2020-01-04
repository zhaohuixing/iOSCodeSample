//
//  DealView.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-16.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlossyMenuView.h"
#import "PlayBoard.h"
#import "FlagIconView.h"
#import "CustomModalAlertView.h"

@interface GameView : GlossyMenuView
{
	UIButton*				m_SystemButton;
	UIButton*				m_ResetButton;
	UIButton*				m_NextButton;
	UIButton*				m_CheckButton;
	UIButton*				m_UndoButton;
	UIButton*				m_WizardButton;
    BOOL					m_bMenuAnimtation;
    BOOL                    m_bFlagForHideAndPlay;


    PlayBoard*              m_GameBoard;
    UIView*                 m_Overlay;
    FlagIconView*           m_LayoutSign;
	UILabel*                m_PlaysLabel;
    BOOL                    m_bShowQMark;
}

//@property (nonatomic) int m_nAnimationLock;

- (id)initWithFrame:(CGRect)frame;
- (void)OnTimerEvent;
- (void)UpdateGameViewLayout;
- (void)StartNewGame:(BOOL)bLoadCacheData;
- (void)UndoGame;
- (void)ResetGame;
- (BOOL)IsGameComplete;

-(void)CreateMenu;
-(void)OnMenuHide;
-(void)OnMenuShow;
-(void)OnMenuEvent:(int)menuID;
-(void)OnMenuSetting:(id)sender;
-(void)OnMenuScore:(id)sender;
-(void)OnMenuShare:(id)sender;
-(void)OnMenuBuyIt:(id)sender;
-(void)OnMenuBkGnd:(id)sender;
-(void)OnMenuScoreView:(id)sender;
-(void)ResetSate;
-(BOOL)IsEasyAnimation;


-(BOOL)IsUIEventLocked;
-(void)RemovePurchaseButton;
-(void)LoadGameSet:(NSMutableDictionary**)dataDict;
//-(void)LoadUndoList:(NSMutableDictionary**)dataDict withKey:(NSString*)szKey;
- (void)LoadUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index;

-(void)SaveCurrentGameToFile;
-(void)ClearupFileManagerData;

-(void)StartNewGameFromOpenFile:(BOOL)bRestart;
-(void)OnResetEasyShuffle:(id)sender;
-(void)StartPlayHelpAnimation:(int)nSelectedType;

@end
