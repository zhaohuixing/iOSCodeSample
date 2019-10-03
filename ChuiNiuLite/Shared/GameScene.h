//
//  GameScene.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-27.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameEventNotification.h" 

@class GameView;
@class PlayerObject;
@class Gun;
@class TargetObject;
@class AlienMaster;
@class GameGround;
@class ClockObject;

@interface GameScene : NSObject <GameEventNotification>
{
	GameView*		m_GameView;
	PlayerObject*   m_Player;
	Gun*			m_PlayerGun;
	TargetObject*   m_Target;
	Gun*			m_TargetGun;
	AlienMaster*	m_Aliens;
	GameGround*		m_Ground;
	ClockObject*	m_Clock;
	
	
	int				m_nGameTimeLength;
	int				m_nGameTimeCounter;
	int				m_nThunderThreshod;
	int				m_nThunderStep;
    int             m_nThunderLength;
    int             m_nThunderType;     //0: 1 vertical; 1:1 horizontal; 2: 1 verical, 1 horz; 3 2 vertical; 4 2 horz
	
	CGColorSpaceRef		m_ShadowClrSpace;
	CGColorRef			m_ShadowClrs;
	CGSize				m_ShadowSize;
	BOOL				m_bDirty;
    
	CGImageRef			m_LightImage1;
	CGImageRef			m_LightImage2;
    float               m_fGameStartTimeStample;
    float               m_fGamePauseTime;
    
    BOOL                m_bHandlePostWinGameOptions;
    BOOL                m_bHandlePostLostGameAction;
}

@property (nonatomic, retain)GameView*	m_GameView;


-(void)onTimerEvent;
-(float)getSceneWidth;
-(float)getSceneHeight;
-(void)invalidRender;
-(void)updateGameLayout;
-(void)drawGame:(CGContextRef)context inRect:(CGRect)rect;
-(void)drawGameSceneWin:(CGContextRef)context inRect:(CGRect)rect;

-(void)touchBegan:(CGPoint)pt;
-(void)touchMoved:(CGPoint)pt;
-(void)touchEnded:(CGPoint)pt;

//GameEventNotification function
-(void)GameLose;
-(void)GameWin;
-(BOOL)IsPlayingSound;
-(void)PlaySound:(int)sndID;
-(void)StopSound:(int)sndID;
-(void)PlayBlockageSound;
-(void)SwitchToBackgroundSound;

-(void)handleLoseResult;
-(void)handleWinResult;

-(void)startNewGame;
-(void)pauseGame;
-(void)resumeGame;
-(void)endGame;
-(void)resetGameScene;
-(void)adjustPlayerInProtraitMode;

-(BOOL)ShouldHandlePostWinningOptions;
-(BOOL)ShouldHandlePostLostAction;

@end
