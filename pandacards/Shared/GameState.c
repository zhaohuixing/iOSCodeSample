/*
 *  GameState.c
 *  MindFire
 *
 *  Created by Zhaohui Xing on 2010-03-16.
 *  Copyright 2010 Zhaohui xing. All rights reserved.
 *
 */
#include "GameState.h"

/*Initialize game state parameters*/
void InitializeStates()
{
	ResetStates();
}

void ResetStates()
{
	SetActivityToGame();
	SetStateToPlay();
	ResetSubState();
	ResetTouchMode();
}	


/*Handling the game activity parameters*/
static int m_nActivity = ACTIVITY_GAME;

void SetActivity(int nActivity)
{
	if(ACTIVITY_GAME <= nActivity && nActivity <= ACTIVITY_ONLINEAD)
	{
		m_nActivity = nActivity;
	}	
}

void SetActivityToGame()
{
	m_nActivity = ACTIVITY_GAME;
}

void SetActivityToInfo()
{
	m_nActivity = ACTIVITY_INFO;
}

void SetActivitytoOnlineAD()
{
	m_nActivity = ACTIVITY_ONLINEAD;
}	

int GetActivity()
{
	return m_nActivity;
}

int IsActivityGame()
{
	int nRet = 0;
	
	if(m_nActivity == ACTIVITY_GAME)
		nRet = 1;
		
	return nRet;
}

int IsActivityInfo()
{
	int nRet = 0;
	
	if(m_nActivity == ACTIVITY_INFO)
		nRet = 1;
	
	return nRet;
}	

int IsActivityOnlineAD()
{
	int nRet = 0;
	
	if(m_nActivity == ACTIVITY_ONLINEAD)
		nRet = 1;
	
	return nRet;
}	

/*Handling game state*/
static int m_nGameState = GAME_STATE_PLAY;

void SetGameState(int nState)
{
	if(GAME_STATE_PLAY <= m_nGameState && m_nGameState <= GAME_STATE_RESULT)
	{
		m_nGameState = nState; 
	}	
}

void SetStateToPlay()
{
	m_nGameState = GAME_STATE_PLAY; 
}

void SetStateToResult()
{
	m_nGameState = GAME_STATE_RESULT; 
}

int GetGameState()
{
	return m_nGameState;
}

int IsPlayState()
{
	int nRet = 0;
	
	if(m_nGameState == GAME_STATE_PLAY)
		nRet = 1;
	
	return nRet;
}

int IsResultState()
{
	int nRet = 0;
	
	if(m_nGameState == GAME_STATE_RESULT)
		nRet = 1;
	
	return nRet;
}	


/*Handling the game secondary state*/
static int m_nGameSubState = GAME_SUBSTATE_NONE;
#define		GAME_SUBSTATE_NONE				0
#define		GAME_SUBSTATE_DNDREADY			1
#define		GAME_SUBSTATE_DND				2
#define		GAME_SUBSTATE_ANIMATION			3  

void ResetSubState()
{
	m_nGameSubState = GAME_SUBSTATE_NONE;
}

void SetGameSubState(int nSubState)
{
	if(GAME_SUBSTATE_NONE <= m_nGameSubState && m_nGameSubState <= GAME_SUBSTATE_ANIMATION)
	{
		m_nGameSubState = nSubState;
	}	
}

void SetSubStateToDnDReady()
{
	m_nGameSubState = GAME_SUBSTATE_DNDREADY;
}

void SetSubStateToDnD()
{
	m_nGameSubState = GAME_SUBSTATE_DND;
}

void SetSubStateToanimation()
{
	m_nGameSubState = GAME_SUBSTATE_ANIMATION;
}

int GetGameSubState()
{
	return m_nGameSubState;
}

int IsInDnDReady()
{
	int nRet = 0;
	
	if(m_nGameSubState == GAME_SUBSTATE_DNDREADY)
		nRet = 1;
		
	return nRet;
}

int IsInDnD()
{
	int nRet = 0;
	
	if(m_nGameSubState == GAME_SUBSTATE_DND)
		nRet = 1;
	
	return nRet;
}

int IsInAnimation()
{
	int nRet = 0;
	
	if(m_nGameSubState == GAME_SUBSTATE_ANIMATION)
		nRet = 1;
	
	return nRet;
}

/*Touch mode handling*/
static int m_nTouchMode = TOUCH_MODE_NONE;
#define		TOUCH_MODE_NONE					0
#define		TOUCH_MODE_ACTION				1

void ResetTouchMode()
{
	m_nTouchMode = TOUCH_MODE_NONE;
}

void EnterTouchMode()
{
	m_nTouchMode = TOUCH_MODE_ACTION;
}

void LeaveTouchMode()
{
	m_nTouchMode = TOUCH_MODE_NONE;
}

int IsInTouchMode()
{
	int nRet = 0;

	if(m_nTouchMode == TOUCH_MODE_ACTION)
		nRet = 1;

	return nRet;
}	


//The game point
static int m_nGamePoint = 24;
int GetGamePoint()
{
	return m_nGamePoint;
}

int GetGameDefaultPoint()
{
	return 24;
}

void SetGamePoint(int nPoint)
{
	m_nGamePoint = nPoint;
}	

static int m_nCacheGamePoint = 24;

int GetCacheGamePoint()
{
	return m_nCacheGamePoint;
}

void SetCacheGamePoint(int nPoint)
{
	m_nCacheGamePoint = nPoint;
}	

//The game speed
static int m_nGameSpeed = GAME_SPEED_NONE;
void SetGameSpeed(int nSpeed)
{
    m_nGameSpeed = nSpeed;
}

int GetGameSpeed()
{
    return m_nGameSpeed;
}


//The iPad theme
static int m_nTheme = GAME_IPAD_THEME_ANIMAL;
void SetCardTheme(int nTheme)
{
	m_nTheme = nTheme;
}

int GetCardTheme()
{
	return m_nTheme;
}

void SetThemeToClassic()
{
	m_nTheme = GAME_IPAD_THEME_CLASSIC;
}

void SetThemeToAnimal()
{
	m_nTheme = GAME_IPAD_THEME_ANIMAL;
}

int IsClassicTheme()
{
	int nRet = 0;
	
	if(m_nTheme == GAME_IPAD_THEME_CLASSIC)
		nRet = 1;
	
	return nRet;
}
	
int IsAnimalTheme()
{
	int nRet = 0;
	
	if(m_nTheme == GAME_IPAD_THEME_ANIMAL)
		nRet = 1;
	
	return nRet;
}	


static int m_curDay;
static int m_curMonth;
static int m_curYear;

void SetTodayDate(int nYear, int nMonth, int nDay)
{
	m_curDay = nDay;
	m_curMonth = nMonth;
	m_curYear = nYear;
}

int GetTodayYear()
{
	return m_curYear;
}

int GetTodayMonth()
{
	return m_curMonth;
}

int GetTodayDay()
{
	return m_curDay;
}	

//Adopt Smaato AD system or not
int UsingSOMA()
{
	return 0;
}	

static int m_Background = GAME_BACKGROUND_YELLOW;

void SetGameBackground(int nBkgnd)
{
    m_Background = nBkgnd;
}

int GetGameBackground()
{
    return m_Background;
}

static int m_nLoggingin = 0;
void setGameCenterLoggingin(int nYES)
{
    m_nLoggingin = nYES;
}

int isGameCenterLoggingin()
{
    int nRet = 0;
    if(m_nLoggingin != 0)
        nRet = 1;
    return nRet;
}



