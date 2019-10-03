/*
 *  GameState.c
 *  XXXXXX
 *
 *  Created by Zhaohui Xing on 10-06-20.
 *  Copyright 2010 xgadget. All rights reserved.
 *
 */
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include "GameDef.h"
#include "GameState.h"

int getRandNumber()
{
	int nRet = 0;
	srand((unsigned)time(NULL));
	nRet = rand();
	return nRet;
}

int getRandNumberBySeed(int nSeed)
{
	int nRet = 0;
	srand((unsigned)nSeed);
	nRet = rand();
	return nRet;
}

static enGamePlayState m_enGameState = GAME_PLAY_READY;
void setGamePlayState(enGamePlayState enState)
{
	m_enGameState = enState;
}

void playGame()
{
	m_enGameState = GAME_PLAY_PLAY;
}

void pauseGame()
{
	m_enGameState = GAME_PLAY_PAUSE;
}

void resetGame()
{
	m_enGameState = GAME_PLAY_READY;
}

enGamePlayState getGamePlayState()
{
	return m_enGameState;
}

int isGamePlayPlaying()
{
	int nRet = 0;
	
	if(m_enGameState == GAME_PLAY_PLAY)
		nRet = 1;
	
	return nRet;
}

int isGamePlayPaused()
{
	int nRet = 0;
	
	if(m_enGameState == GAME_PLAY_PAUSE)
		nRet = 1;
	
	return nRet;
}

int isGamePlayReady()
{
	int nRet = 0;
	
	if(m_enGameState == GAME_PLAY_READY)
		nRet = 1;
	
	return nRet;
}	

void setGameResultWin()
{
	m_enGameState = GAME_PLAY_RESULT_WIN;
}

void setGameResultLose()
{
	m_enGameState = GAME_PLAY_RESULT_LOSE;
}

int isGameResult()
{
	int nRet = 0;
	
	if(m_enGameState == GAME_PLAY_RESULT_WIN || m_enGameState == GAME_PLAY_RESULT_LOSE)
		nRet = 1;
	
	return nRet;
}

int isGameResultWin()
{
	int nRet = 0;
	
	if(m_enGameState == GAME_PLAY_RESULT_WIN)
		nRet = 1;
	
	return nRet;
}

int isGameResultLose()
{
	int nRet = 0;
	
	if(m_enGameState == GAME_PLAY_RESULT_LOSE)
		nRet = 1;
	
	return nRet;
}	


static int m_nShow = 0;
void setDisplayAD(int nShow)
{
    m_nShow = nShow;
}

int isDisplayAD()
{
    int nRet = 0;
    if(m_nShow != 0)
        nRet = 1;
    return nRet;
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


