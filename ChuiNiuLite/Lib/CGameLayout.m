//
//  CGameLayout.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 10-11-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#include "libinc.h" 
#include "GameState.h"
#import "CGameLayout.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"

#define 	m_fGameSceneMeasureHeight	768.0  	//The game scene measure height;
#define 	m_fGameSceneMeasureWidth	1024.0  //The game scene measure width;
#define 	m_fGameSceneMeasureRatio	0.75 	//The game scene measure ratio height/width;


static float	m_fDeviceClientWidth;  		//The real game client area width;
static float	m_fDeviceClientHeight;  	//The real game client area height;
static BOOL		m_bDeviceLandscape;  	//The real game client area height;

static float	m_fGameSceneDeviceWidth;  			//The real game scene window screen width;
static float	m_fGameSceneDeviceHeight;  		//The real game scene window screen height;

static float	m_fGameSceneDMScaleX;  			//The real window screen width;
static float	m_fGameSceneDMScaleY;  		//The real window screen height;

static float	m_fGameSceneOriginXInDeviceClient;
static float	m_fGameSceneOriginYInDeviceClient;


@implementation CGameLayout

+ (void)InitializeLayout
{
	float w = [GUILayout GetContentViewWidth];
	float h = [GUILayout GetContentViewHeight];
	m_fDeviceClientHeight = h;  		//The real window screen height;
	m_fDeviceClientWidth = w;  		//The real game client area width;
	
	if(w < h) //device orientation: protrait
		m_bDeviceLandscape = NO;
	else
		m_bDeviceLandscape = YES;
	
	if(m_bDeviceLandscape == true)
	{
		m_fGameSceneDeviceWidth = m_fDeviceClientWidth;  								//The real window screen width;
		m_fGameSceneDeviceHeight = m_fDeviceClientHeight;  								//The real window screen height;
		m_fGameSceneDMScaleX = m_fGameSceneDeviceWidth/m_fGameSceneMeasureWidth;  			//The real window screen width;
		m_fGameSceneDMScaleY = m_fDeviceClientHeight/m_fGameSceneMeasureHeight;  		//The real window screen height;
	}
	else
	{
		m_fGameSceneDeviceHeight = m_fDeviceClientHeight;  								//The real window screen height;
		m_fGameSceneDeviceWidth = m_fGameSceneDeviceHeight/m_fGameSceneMeasureRatio;  		//The real window screen width;
		m_fGameSceneDMScaleX = m_fGameSceneDeviceWidth/m_fGameSceneMeasureWidth;  			//The real window screen width;
		m_fGameSceneDMScaleY = m_fDeviceClientHeight/m_fGameSceneMeasureHeight;  		//The real window screen height;
	}
	
	m_fGameSceneOriginXInDeviceClient = m_fDeviceClientWidth/2.0f;
	m_fGameSceneOriginYInDeviceClient = m_fDeviceClientHeight;
}

+ (float)GameSceneToDeviceX:(float) measureX
{
	float x = measureX*m_fGameSceneDMScaleX;
	float fRet = x + m_fGameSceneOriginXInDeviceClient;
	return fRet;
}

+ (float)GameSceneToDeviceY:(float) measureY
{
	float y = measureY*m_fGameSceneDMScaleY;
	float fRet = m_fGameSceneOriginYInDeviceClient - y;
	return fRet;
}

+ (float)DeviceToGameSceneX:(float) x
{
	float fRet = (x - m_fGameSceneOriginXInDeviceClient)/m_fGameSceneDMScaleX;
	return fRet;
}

+ (float)DeviceToGameSceneY:(float) y
{
	float fRet = (m_fGameSceneOriginYInDeviceClient - y)/m_fGameSceneDMScaleY;
	return fRet;
}

//Convert game object size to device unit, using Y scale since
//Game scene physic layout is take device height as reference.
+ (float)ObjectMeasureToDevice:(float) v
{
	float fRet = v*m_fGameSceneDMScaleY;
	return fRet;
}

+ (float)DeviceToObjectMeasure:(float) v
{
	float fRet = v/m_fGameSceneDMScaleY;
	return fRet;
}

+ (float)GetGameSceneOriginXInDevice
{
	return m_fGameSceneOriginXInDeviceClient;
}

+ (float)GetGameSceneOriginYInDevice
{
	return m_fGameSceneOriginYInDeviceClient;
}

+ (float)GetGameClientDeviceWidth
{
	return m_fDeviceClientWidth;
}

+ (float)GetGameClientDeviceHeight
{
	return m_fDeviceClientHeight;
}

+ (float)GetGameSceneDeviceWidth
{
	return m_fGameSceneDeviceWidth;
}

+ (float)GetGameSceneDeviceHeight
{
	return m_fGameSceneDeviceHeight;
}

+ (float)GetGameSceneWidth
{
	return m_fGameSceneMeasureWidth;
}

+ (float)GetGameSceneHeight
{
	return m_fGameSceneMeasureHeight;
}

+ (float)GetGameSceneDMScaleX
{
	return m_fGameSceneDMScaleX;
}

+ (float)GetGameSceneDMScaleY
{
	return m_fGameSceneDMScaleY;
}

+ (float)GetGameSceneDMScaleMin
{
	if(m_fGameSceneDMScaleY <= m_fGameSceneDMScaleX)
		return m_fGameSceneDMScaleY;
	else
		return m_fGameSceneDMScaleX;
}

+ (float)GetCowHeight
{
	return GAME_TARGET_HEIGHT_IPAD;
}

+ (float)GetCowWidth
{
	return GAME_TARGET_WIDTH_IPAD;
}	

+ (float)GetDogHeight
{
	return GAME_PLAYER_HEIGHT_IPAD;
}

+ (float)GetDogWidth
{
	return GAME_PLAYER_WIDTH_IPAD;
}

+ (float)GetPlayerBulletWidth
{
	return GAME_PLAYER_BULLET_WIDTH_IPAD;
}

+ (float)GetPlayerBulletHeight
{
	return GAME_PLAYER_BULLET_HEIGHT_IPAD;
}

+ (float)GetPlayerBulletStartRatioX
{
	return GAME_PLAYER_BULLET_START_PERCENT_X;
}

+ (float)GetPlayerBulletStartRatioY
{
	return GAME_PLAYER_BULLET_START_PERCENT_Y;
}

+ (float)GetPlayerBulletChangeRatioX
{
	return GAME_PLAYER_BULLET_CHANGE_PERCENT_X;
}

+ (float)GetPlayerBulletChangeRatioY{
	return GAME_PLAYER_BULLET_CHANGE_PERCENT_Y;
}	

+ (float)GetTargetBulletWidth
{
	return GAME_TARGET_BULLET_WIDTH_IPAD;
}

+ (float)GetTargetBulletHeight
{
	return GAME_TARGET_BULLET_HEIGHT_IPAD;
}

+ (float)GetTargetBulletStartRatioX
{
	return GAME_TARGET_BULLET_START_PERCENT_X;
}

+ (float)GetTargetBulletStartRatioY
{
	return GAME_TARGET_BULLET_START_PERCENT_Y;
}

+ (float)GetTargetBulletChangeRatioX
{
	return GAME_TARGET_BULLET_CHANGE_PERCENT_X;
}

+ (float)GetTargetBulletChangeRatioY
{
	return GAME_TARGET_BULLET_CHANGE_PERCENT_Y;
}	

+ (float)GetRockSize
{
	return GAME_BLOCKAGE_SIZE_IPAD;
}

+ (float)GetGameSceneWiningCenterY
{
	float fRet = 0.4*[CGameLayout GetGameSceneHeight];
	return fRet; 
}

+ (float)GetRainBowWidth
{
	return GAME_RAINBOW_WIDTH_IPAD;
}

+ (float)GetClockRadius
{
	return (GAME_CLOCK_RADIUM*1.4);
}

+ (float)GetRainBowSpeed
{
	float fRet = 0;
	
	if([ApplicationConfigure iPADDevice])
		fRet = GAME_RAINBOW_DEFAULT_SPEED_IPAD;
	else
		fRet = GAME_RAINBOW_DEFAULT_SPEED_IPHONE;
	
	return fRet;
}	

+ (int)GetRainBowTimerStep
{
	int nRet = 1;//GAME_TIMER_DEFAULT_ALIEN_STEP;
	
	return nRet;
}

+ (int) GetRainBowPlayTime
{
	int nRet = 0;
	float fRainbowWidth = [CGameLayout GetRainBowWidth];
	float fSceneWidth = [CGameLayout GetGameSceneWidth];
	float fSpeed = [CGameLayout GetRainBowSpeed];
	float fMovement = (fRainbowWidth+fSceneWidth)*0.5;
	float fTiming = fMovement/fSpeed;
	int nStep = [CGameLayout GetRainBowTimerStep];
	
	nRet =(int)(((float)nStep)*fTiming);
	return nRet;
}	

+ (float)GetGrassUnitHeight
{
    return [CGameLayout GetDogHeight]*0.25;
}

+ (float)GetGrassUnitWidth
{
    return [CGameLayout GetGrassUnitHeight]*3.0;
}

+ (float)GetGrassUnitNumber
{
	if([ApplicationConfigure iPADDevice])
		return 12;
	else
		return 16;
}


@end
