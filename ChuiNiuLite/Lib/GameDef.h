/*
 *  GameDef.h
 *  XXXXX
 *
 *  Created by Zhaohui Xing on 10-06-26.
 *  Copyright 2010 xgadget. All rights reserved.
 *
 */
//#define			GAME_MODE_PLAY						0
//#define			GAME_MODE_RECORD					1
//#define			GAME_MODE_CONFIGURE					2
//#define			GAME_MODE_FIRST						GAME_MODE_PLAY
//#define			GAME_MODE_LAST						GAME_MODE_CONFIGURE

#define         GAME_RATIO_ZOOM                     1.4

#define			GAME_SCREEN_FRAME_X_P_IPHONE		320
#define			GAME_SCREEN_FRAME_Y_P_IPHONE		480
#define			GAME_SCREEN_FRAME_X_L_IPHONE		480
#define			GAME_SCREEN_FRAME_Y_L_IPHONE		320
#define			GAME_SCREEN_VIEW_HEAD_P_IPHONE		64
#define			GAME_SCREEN_VIEW_HEAD_L_IPHONE		52

#define			GAME_SCREEN_VIEW_X_P_IPHONE			320
#define			GAME_SCREEN_VIEW_Y_P_IPHONE			416
#define			GAME_SCREEN_VIEW_X_L_IPHONE			480
#define			GAME_SCREEN_VIEW_Y_L_IPHONE			268

#define			GAME_PLAYER_WIDTH_IPHONE			120
#define			GAME_PLAYER_HEIGHT_IPHONE			90

#define         GAME_PLAYER_BULLET_HEIGHT_IPHONE	90
#define         GAME_PLAYER_BULLET_WIDTH_IPHONE		56

#define			GAME_BLOCKAGE_SIZE_IPHONE			64

#define         GAME_PLAYER_BULLET_START_PERCENT_X  0.10	
#define         GAME_PLAYER_BULLET_START_PERCENT_Y  0.05	
#define         GAME_PLAYER_BULLET_CHANGE_PERCENT_X 0.07	
#define         GAME_PLAYER_BULLET_CHANGE_PERCENT_Y 0.14	

#define			GAME_TARGET_WIDTH_IPHONE			150    //180
#define			GAME_TARGET_HEIGHT_IPHONE			100    //90
#define			GAME_TARGET_BULLET_WIDTH_IPHONE		40
#define			GAME_TARGET_BULLET_HEIGHT_IPHONE	32

#define         GAME_TARGET_BULLET_START_PERCENT_X  0.3	
#define         GAME_TARGET_BULLET_START_PERCENT_Y  0.3	
#define         GAME_TARGET_BULLET_CHANGE_PERCENT_X 0.1	
#define         GAME_TARGET_BULLET_CHANGE_PERCENT_Y 0.1	


#define			GAME_SCREEN_FRAME_X_P_IPAD			768
#define			GAME_SCREEN_FRAME_Y_P_IPAD			1024
#define			GAME_SCREEN_FRAME_X_L_IPAD			1024
#define			GAME_SCREEN_FRAME_Y_L_IPAD			768
#define			GAME_SCREEN_VIEW_HEAD_P_IPAD		64
#define			GAME_SCREEN_VIEW_HEAD_L_IPAD		64
#define			GAME_SCREEN_VIEW_X_P_IPAD			768
#define			GAME_SCREEN_VIEW_Y_P_IPAD			960
#define			GAME_SCREEN_VIEW_X_L_IPAD			1024
#define			GAME_SCREEN_VIEW_Y_L_IPAD			704

#define			GAME_BIRD_WIDTH                     150 //200
#define			GAME_BIRD_HEIGHT                    90 //120

#define			GAME_BIRD_BUBBLE_WIDTH              60
#define			GAME_BIRD_BUBBLE_HEIGHT             30

#define			GAME_PLAYER_WIDTH_IPAD				200//240
#define			GAME_PLAYER_HEIGHT_IPAD				150//180
#define         GAME_PLAYER_BULLET_HEIGHT_IPAD		120
#define         GAME_PLAYER_BULLET_WIDTH_IPAD		80

#define			GAME_TARGET_BULLET_WIDTH_IPAD		60
#define			GAME_TARGET_BULLET_HEIGHT_IPAD		50

#define			GAME_TARGET_WIDTH_IPAD				300 //240 //300
#define			GAME_TARGET_HEIGHT_IPAD				200 //160 //160

#define			GAME_BLOCKAGE_SIZE_IPAD				100

#define         GAME_GRASSLAND_HEIGHT_IPHONE        

#define         GAME_TIMER_INTERVAL					0.01
#define         GAME_TIMER_GAME_TIME				1000           //12000
#define         GAME_TIMER_PLAYER_STEP				4//10
#define         GAME_TIMER_DEFAULT_BULLET_STEP		4//10
#define         GAME_TIMER_TARGET_STEP				2//4 //15
#define         GAME_TIMER_DEFAULT_ALIEN_STEP       20  ///28       
#define         GAME_TIMER_DEFAULT_BLOCK_STEP       30       
#define         GAME_TIMER_DEFAULT_CLOCK_UPDATE     10  //100       


#define         GAME_DEFAULT_PLAYER_BULLET_SPEED_X	0
#define         GAME_DEFAULT_PLAYER_BULLET_SPEED_Y	20
#define         GAME_DEFAULT_PLAYER_BULLET_NUMBER	15
#define         GAME_DEFAULT_PLAYER_BULLET_SIZE		30
#define         GAME_DEFAULT_PLAYER_BULLET_BLAST_STEP 3
#define			GAME_DEFAULT_PLAYER_ALIEN_BLAST_STEP 3
#define         GAME_DEFAULT_PLAYER_DEATH_STEP		4


#define         GAME_DEFAULT_TARGET_SPEED_X			0
#define         GAME_DEFAULT_TARGET_SPEED_Y			-1
#define         GAME_DEFAULT_TARGET_FLOAT_SPEED_Y	16
#define         GAME_DEFAULT_TARGET_FLOAT_SPEED_X	0

#define         GAME_DEFAULT_TARGET_BULLET_SPEED_X	8
#define         GAME_DEFAULT_TARGET_BULLET_SPEED_Y	-16

#define         GAME_DEFAULT_TARGET_SHOOT_THRESHED	20

#define         GAME_DEFAULT_TARGET_HIT_THRESHED	10
#define         GAME_DEFAULT_TARGET_HIT_DEDUCABLE	3

#define         GAME_DEFAULT_ALIEN_NUMBER			16 //8
#define         GAME_DEFAULT_ALIEN_SPEED_X			8 //10
#define         GAME_DEFAULT_ALIEN_SPEED_Y			0
#define         GAME_DEFAULT_ALIEN_SIZE_WIDTH		200
#define         GAME_DEFAULT_ALIEN_SIZE_HEIGHT		150
#define         GAME_DEFAULT_ALIEN_POINT_OFFSET     180.0 	
#define         GAME_DEFAULT_ALIEN_SHOOT_THRESHED	40 //80

#define         GAME_DEFAULT_BLOCK_NUMBER			5
#define         GAME_DEFAULT_BLOCK_SPEED_X			8
#define         GAME_DEFAULT_BLOCK_SPEED_Y			0
#define         GAME_DEFAULT_BLOCK_SHOOT_THRESHED	120

#define         GAME_RAINBOW_WIDTH_IPHONE			300
#define         GAME_RAINBOW_WIDTH_IPAD				600
#define         GAME_RAINBOW_DEFAULT_SPEED_IPHONE	8
#define         GAME_RAINBOW_DEFAULT_SPEED_IPAD		10

/*
The game scence coordinate system: 
origin x:  the device screen center
origin y:  the device screem bottom 
*/

#define			GAME_SCENCE_HEIGHT_IPHONE			416 //(GAME_SCREEN_FRAME_Y_P_IPHONE-GAME_SCREEN_VIEW_HEAD_P_IPHONE)

#define			GAME_SCENCE_DEMSION_RATIO_IPHONE	1.791044776119403 //GAME_SCREEN_FRAME_X_L_IPHONE/(GAME_SCREEN_FRAME_Y_L_IPHONE-GAME_SCREEN_VIEW_HEAD_L_IPHONE)

#define			GAME_SCENCE_WIDTH_IPHONE			746 //GAME_SCENCE_HEIGHT_IPHONE*GAME_SCENCE_DEMSION_RATIO_IPHONE=745.074626865671642

#define			GAME_SCENCE_SMALLSCREEN_SCALE_IPHONE  	0.64343163538874 //GAME_SCREEN_FRAME_X_L_IPHONE/GAME_SCENCE_WIDTH_IPHONE

#define			GAME_SCENCE_HEIGHT_IPAD				960 //(GAME_SCREEN_FRAME_Y_P_IPAD-GAME_SCREEN_VIEW_HEAD_P_IPAD)

#define			GAME_SCENCE_DEMSION_RATIO_IPAD		1.454545454545455 //GAME_SCREEN_FRAME_X_L_IPAD/(GAME_SCREEN_FRAME_Y_L_IPAD-GAME_SCREEN_VIEW_HEAD_L_IPAD)

#define			GAME_SCENCE_WIDTH_IPAD				1396.4 //GAME_SCENCE_HEIGHT_IPAD*GAME_SCENCE_DEMSION_RATIO_IPAD=1396.363636363636364

#define			GAME_SCENCE_SMALLSCREEN_SCALE_IPAD  0.733333333333333 //GAME_SCREEN_FRAME_X_L_IPAD/GAME_SCENCE_WIDTH_IPAD

#define			GAME_SCENCE_GROUND_HEIGHT			0 //10

#define         GAME_SCENCE_WIN_SIGN_CENTER_Y_RATIO 0.539		

//Constant for iPhone/iPod touch
#define			GAMEDEVICE_IPHONE					0

//Constant for iPad
#define			GAMEDEVICE_IPAD						1

//Constant for iPhone/iPod touch
#define			GAMEDEVICE_PROTRAIT					0

//Constant for iPad
#define			GAMEDEVICE_LANDSCAPE				1

#define			GAME_BACKGROUND_DEFAULT				0
#define			GAME_BACKGROUND_CHECKER				1
#define			GAME_BACKGROUND_NIGHT				2
#define			GAME_BACKGROUND_COUNT				3




/*
 Level 1 (0 index): 
 Player -- no jump
 Target -- no shoot
 Target -- no blowout
 Alien  -- no knockdown target
 
 Level 2 (1 index): 
 Player -- no jump
 Target -- no shoot
 Target -- blowout
 Alien  -- knockdown target
 
 Level 3 (2 index): 
 Player -- no jump
 Target -- shoot
 Target -- blowout
 Alien  -- knockdown target
 
 Level 4 (3 index): 
 Player -- jump
 Target -- shoot
 Target -- blowout
 Alien  -- knockdown target
 
 */ 
#define			GAME_PLAY_LEVELS					4
#define			GAME_PLAY_LEVEL_ONE					0
#define			GAME_PLAY_LEVEL_TWO					1
#define			GAME_PLAY_LEVEL_THREE				2
#define			GAME_PLAY_LEVEL_FOUR				3

#define			GAME_SKILL_LEVELS					3
#define			GAME_SKILL_LEVEL_ONE				0
#define			GAME_SKILL_LEVEL_TWO				1
#define			GAME_SKILL_LEVEL_THREE				2

#define         GAME_SOUND_ID_PLAYERSHOOT			0
#define         GAME_SOUND_ID_TARGETHORN			1
#define         GAME_SOUND_ID_TARGETSHOOT			2
#define         GAME_SOUND_ID_TARGETKNOCKDOWN		3
#define         GAME_SOUND_ID_BLAST					4
#define         GAME_SOUND_ID_COLLISION				5
#define         GAME_SOUND_ID_JUMP					6
#define         GAME_SOUND_ID_CRASH					7
#define         GAME_SOUND_ID_THUNDER				8

#define         GAME_CLOCK_RADIUM					30

#define			GAME_MAXMUM_SCORE_NUMBER			999999


typedef enum 
{
	GAME_OBJECT_NONE,
	GAME_OBJECT_BULLET,
	GAME_OBJECT_TARGET,
	GAME_OBJECT_ALIEN,
	GAME_OBJECT_PLAYER
} enObjectType;

typedef enum 
{
	GAME_HITOBJECT_NONE,
	GAME_HITOBJECT_BULLET,
	GAME_HITOBJECT_TARGET,
	GAME_HITOBJECT_ALIEN,
	GAME_HITOBJECT_PLAYER
} enHitObjectState;

typedef enum
{
	GAME_BULLET_READY,
	GAME_BULLET_SHOOTTING,
	GAME_BULLET_BLAST
} enBulletState; 	

typedef enum
{
	GAME_PLAYER_STOP,
	GAME_PLAYER_MOTION,
	GAME_PLAYER_JUMP,
	GAME_PLAYER_SHOOT,
	GAME_PLAYER_SHOOTANDMOTION,
	GAME_PLAYER_SHOOTANDJUMP,
	GAME_PLAYER_DEAD
} enPlayerState; 	

typedef enum
{
	GAME_TARGET_NORMAL,
	GAME_TARGET_SHOOT,		// target shoot out			
	GAME_TARGET_BLOWOUT,	// player blow out too much to break the target			
	GAME_TARGET_CRASH,		// fallingdwon naturally by not knockdown			
	GAME_TARGET_KNOCKDOWN,	// hit by alien
} enTargetState; 	

typedef enum
{
	GAME_ALIEN_STOP,
	GAME_ALIEN_MOTION,
	GAME_ALIEN_BLAST
} enAlienState; 	

typedef enum
{
	GAME_ALIEN_TYPE_CLOUD,
	GAME_ALIEN_TYPE_BIRD,
	GAME_ALIEN_TYPE_BIRD_BUBBLE
} enAlienType; 	

typedef enum
{
	GAME_ALIEN_BIRD_MOTION,
	GAME_ALIEN_BIRD_SHOOT
} enAlienBirdState; 	

typedef enum
{
	GAME_PLAY_READY,
	GAME_PLAY_PLAY,
	GAME_PLAY_PAUSE,
	GAME_PLAY_RESULT_WIN,
	GAME_PLAY_RESULT_LOSE,
} enGamePlayState;	


