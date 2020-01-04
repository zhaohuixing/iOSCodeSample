/*
 *  GameState.h
 *  MindFire
 *
 *  Created by Zhaohui Xing on 2010-03-16.
 *  Copyright 2010 Zhaohui Xing. All rights reserved.
 *
 */

/*The game mode: game playing; game information display; online AD display*/
#define		ACTIVITY_GAME		0
#define		ACTIVITY_INFO		1	
#define		ACTIVITY_ONLINEAD	2


/*The game state: game playing; game result display*/
#define		GAME_STATE_PLAY		0
#define		GAME_STATE_RESULT	1


/*The game second level state: animation in running state or result state; drag and drop card*/
#define		GAME_SUBSTATE_NONE				0
#define		GAME_SUBSTATE_DNDREADY			1
#define		GAME_SUBSTATE_DND				2
#define		GAME_SUBSTATE_ANIMATION			3  

/*The game touch mode*/
#define		TOUCH_MODE_NONE					0
#define		TOUCH_MODE_ACTION				1

#define         GAME_CARD_STATE_NONE		0
#define         GAME_CARD_STATE_OPERAND1	1
#define         GAME_CARD_STATE_OPERAND2	2
#define         GAME_CARD_STATE_RESULT		3

#define			GAME_VIEWMODE_PLAY			0
#define			GAME_VIEWMODE_RESULT		1
#define			GAME_VIEWMODE_POINTS		2
#define			GAME_VIEWMODE_SCORE			3

#define			GAME_IPAD_THEME_CLASSIC		0
#define			GAME_IPAD_THEME_ANIMAL		1

#define         GAME_BACKGROUND_YELLOW      0
#define         GAME_BACKGROUND_GREEN       1
#define         GAME_BACKGROUND_BLUE        2
#define         GAME_BACKGROUND_RED         3
#define         GAME_BACKGROUND_CHECKER     4
#define         GAME_BACKGROUND_WOOD        5

#define         GAME_SPEED_NONE             0
#define         GAME_SPEED_SLOW             1
#define         GAME_SPEED_FAST             2


/*Initialize game state parameters*/
void InitializeStates();
void ResetStates();


/*Handling the game activity parameters*/
void SetActivity(int nActivity);
void SetActivityToGame();
void SetActivityToInfo();
void SetActivitytoOnlineAD();
int GetActivity();
int IsActivityGame();
int IsActivityInfo();
int IsActivityOnlineAD();

/*Handling game state*/
void SetGameState(int nState);
void SetStateToPlay();
void SetStateToResult();
int GetGameState();
int IsPlayState();
int IsResultState();


/*Handling the game secondary state*/
void ResetSubState();
void SetGameSubState(int nSubState);
void SetSubStateToDnDReady();
void SetSubStateToDnD();
void SetSubStateToanimation();
int GetGameSubState();
int IsInDnDReady();
int IsInDnD();
int IsInAnimation();

/*Touch mode handling*/
void ResetTouchMode();
void EnterTouchMode();
void LeaveTouchMode();
int IsInTouchMode();

//The game point
int GetGamePoint();
int GetGameDefaultPoint();
void SetGamePoint(int nPoint);
int GetCacheGamePoint();
void SetCacheGamePoint(int nPoint);

void SetGameSpeed(int);
int  GetGameSpeed();

//The iPad theme
void SetCardTheme(int nTheme);
int GetCardTheme();
void SetThemeToClassic();
void SetThemeToAnimal();
int IsClassicTheme();
int IsAnimalTheme();

void SetTodayDate(int nYear, int nMonth, int nDay);
int GetTodayYear();
int GetTodayMonth();
int GetTodayDay();

int UsingSOMA();

void SetGameBackground(int nBkgnd);
int GetGameBackground();

void setGameCenterLoggingin(int nYES);
int isGameCenterLoggingin();


