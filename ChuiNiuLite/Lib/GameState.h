/*
 *  GameState.h
 *  XXXXX
 *
 *  Created by Zhaohui Xing on 10-06-20.
 *  Copyright 2010 xgadget. All rights reserved.
 *
 */

int getRandNumber();
int getRandNumberBySeed(int nSeed);

void setGamePlayState(enGamePlayState enState);
void playGame();
void pauseGame();
void resetGame();
void setGameResultWin();
void setGameResultLose();
void setDisplayAD(int nShow);
enGamePlayState getGamePlayState();
int isGamePlayPlaying();
int isGamePlayPaused();
int isGamePlayReady();
int isGameResult();
int isGameResultWin();
int isGameResultLose();
int isDisplayAD();

void setGameCenterLoggingin(int nYES);
int isGameCenterLoggingin();
