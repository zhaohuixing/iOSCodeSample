//
//  DealController.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-15.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DealResult.h"

@class GameBaseView;
@class GameController;
@class GameCard;
@class CSignsBtn;
@class GameView;
@class Bulletin;
@class GreetLayer;
@class GameDeck;
@class GameScore;
@class ResultView;
@class ResultViewParent;
@class GameStatusBar;

@interface DealController : NSObject 
{
	GameView*				m_DealView;
	GameCard*				m_BasicCard[4];
	GameCard*				m_TempCard[4];
	CSignsBtn*				m_SignsButton;	
	Bulletin*				m_Bulletin;
	//GreetLayer*				m_GreetLayer;
    GameStatusBar*          m_StatusBar;

	int						m_nTouchSemphore;
    BOOL                    m_bResultAnimation;
    
	DealResult*				m_Result;
	BOOL					m_DoCalculation;

	GameDeck*				m_Game;
	GameScore*				m_Scores;

	//ResultView*				m_ResultView;
	ResultViewParent*				m_ResultView;
    
    
    NSTimeInterval          m_TimeStartDealCounting;
    float                   m_PercentOfTiming;
    BOOL                    m_bDealTimeCounting;
}

- (id)initController:(GameView*)ParentView;
- (void)UpdateGameViewLayout;
- (void)OnTimerEvent;
- (void)EnterNewDeal;
- (void)GoToNextDeal;
- (BOOL)MoveOutOldDeal;
- (void)touchesBegan:(NSSet*)touches withEvent: (UIEvent*)event;
- (void)touchesMoved:(NSSet*)touches withEvent: (UIEvent*)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)RestoreNonTouchState;
- (void)RestoreBasicCardNonTouch:(int)nIndex;
- (void)RestoreTempCardNonTouch:(int)nIndex;
- (void)DecideBasicCardState:(int)nIndex;
- (void)DecideTempCardState:(int)nIndex;
- (void)DoCalculate;
- (BOOL)FinishCalculate;
- (BOOL)IsDealCalculationComplete;
- (BOOL)CheckDealRightAnswer;
- (BOOL)IsDealFinalAnswerRight;
- (void)CloseCurrentDealWithRightAnswer;
- (void)CloseCurrentDealWithoutRightAnswer;
- (BOOL)IsOperandEmpty:(int)index;
- (void)UndoDeal;
- (void)ForceToNextDeal;
- (void)StartNewGame;
- (void)StartNewLobbyGameWithoutShuffle;
- (void)SubmitLeftEquation;
- (void)SwitchTheme;
- (void)Shuffle;
- (int)GetDealLeft;
- (BOOL)IsGameComplete;
- (BOOL)IsGameDealComplete;
- (void)ClearCalculationQueue;

- (BOOL)IsResultValid;
- (int)GetResultCount;
- (DealResult*)GetResult:(int)index;
- (void)GotoResult;
- (void)GotoNewGame;

- (BOOL)InAnimation;
- (void)SaveScores;
- (void)SavePoints;
- (void)SaveSpeed;
- (void)SaveBackground;

- (BOOL)FormatWinResultArray:(NSMutableArray*)array;
- (BOOL)ForamtNewGameArray:(NSMutableArray*)array;
- (BOOL)SetNewGameFromFormatArray:(NSArray*)array;
- (void)ResetGame;
- (void)ResetLobbyGameDeal;

- (float)GetTimeSpentRatio;

- (void)ShowStatusBar:(NSString*)text showFlag:(BOOL)bWin;

@end
