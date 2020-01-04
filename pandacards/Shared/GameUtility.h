/*
 *  GameUtility.h
 *  MindFire
 *
 *  Created by ZXing on 23/10/2009.
 *  Copyright 2009 Zhaohui Xing. All rights reserved.
 *
 */
#define			IOS_IPHONE					0
#define			IOS_IPAD					1

#define			ISYS_PROTRAIT				0
#define			ISYS_LANDSCAPE				1


#define			CARD_INVALID				-1
#define			CARD_SPADE					0
#define			CARD_DIAMOND				1
#define			CARD_CLUB					2
#define			CARD_HEART					3
#define			CARD_TEMPCARD				4
#define			CARD_NUMBER_INVALID			-1

#define			GAME_VIEW_MAIN				0;
#define			GAME_VIEW_GAME				1;
#define			GAME_VIEW_SCORE				2;
#define			GAME_VIEW_POINT				3;
#define			GAME_VIEW_PLAYVIEW			4;
#define			GAME_VIEW_SIGNSLIDER		5;
#define			GAME_VIEW_CARD				6;
#define			GAME_VIEW_DEAL				7;
#define			GAME_VIEW_RESULTVIEW		8;
#define			GAME_VIEW_BULLETIN			9;
#define			GAME_VIEW_EQNVIEW			10;
#define			GAME_VIEW_GREETTING			11;

#define			GAME_VIEW_INVALID			-1;

#define			CARD_WIDTH_P_IPHONE			71
#define			CARD_HEIGHT_P_IPHONE		96
#define			CARD_WIDTH_L_IPHONE			96
#define			CARD_HEIGHT_L_IPHONE		71
#define			CARD_CORNCER_X_IPHONE		20
#define			CARD_CORNCER_Y_IPHONE		20
#define			CARD_CORNCER_R_IPHONE		0.5
#define			CARD_MARGIN_IPHONE			4
#define			CARD_SIGN_HEIGHT_IPHONE		35
#define         CARD_ANIMAL_SIGN_HEIGHT_IPHONE    45
#define			CARD_INNER_MARGIN_IPHONE	10

#define			CARD_SIGN_XY_RATIO			1.04

#define			CARD_WIDTH_P_IPAD			120
#define			CARD_HEIGHT_P_IPAD			162
#define			CARD_WIDTH_L_IPAD			162
#define			CARD_HEIGHT_L_IPAD			120
#define			CARD_CORNCER_X_IPAD			20
#define			CARD_CORNCER_Y_IPAD			20
#define			CARD_CORNCER_R_IPAD			0.5
#define			CARD_MARGIN_IPAD			8
#define			CARD_SIGN_HEIGHT_IPAD		75
#define         CARD_ANIMAL_SIGN_HEIGHT_IPAD    96
#define			CARD_INNER_MARGIN_IPAD		15

#define			GAME_VIEW_X_P_IPHONE		320
#define			GAME_VIEW_Y_P_IPHONE		480
#define			GAME_VIEW_X_L_IPHONE		480
#define			GAME_VIEW_Y_L_IPHONE		320

#define			GAME_VIEW_HEAD_P_IPHONE		64
#define			GAME_VIEW_HEAD_L_IPHONE		52

#define			GAME_GREET_VIEW_WIDTH_IPHONE	300
#define			GAME_GREET_VIEW_HEIGHT_IPHONE	100

#define			GAME_POINTPICKER_WIDTH_IPHONE_P		320
#define			GAME_POINTPICKER_HEIGHT_IPHONE_P	160

#define			GAME_POINTPICKER_WIDTH_IPHONE_L		480
#define			GAME_POINTPICKER_HEIGHT_IPHONE_L	160


#define			GAME_VIEW_X_P_IPAD			768
#define			GAME_VIEW_Y_P_IPAD			1024
#define			GAME_VIEW_X_L_IPAD			1024
#define			GAME_VIEW_Y_L_IPAD			768

#define			GAME_VIEW_HEAD_P_IPAD		64
#define			GAME_VIEW_HEAD_L_IPAD		64

#define			GAME_GREET_VIEW_WIDTH_IPAD	400
#define			GAME_GREET_VIEW_HEIGHT_IPAD	100

#define			GAME_POINTPICKER_WIDTH_IPAD		400
#define			GAME_POINTPICKER_HEIGHT_IPAD	240

#define         GAME_SIGNS_OUTTER_SIZE_IPHONE	72
#define         GAME_SIGNS_INNER_SIZE_IPHONE	64


#define         GAME_SIGNS_OUTTER_SIZE_IPAD		104.0
#define         GAME_SIGNS_INNER_SIZE_IPAD		96.0

#define         GAME_SIGNS_IMAGE_UNIT_SIZE	28.0

#define			GAME_SCORE_UNIT_SIZE			36.0
#define			GAME_SCORE_IMAGE_SIZE			24.0

#define         GAME_CALCULATION_NONE		-1
#define         GAME_CALCULATION_PLUS		0
#define         GAME_CALCULATION_MINUES		1
#define         GAME_CALCULATION_TIME		2
#define         GAME_CALCULATION_DIVIDE		3
#define         GAME_CALCULATION_EQUALTO	4

#define         GAME_MCBANNER_EDGE_HEIGHT	60

#define         GAME_STATUS_BAR_ANIMATOR_SIZE_IPHONE	56
#define         GAME_STATUS_BAR_ANIMATOR_SIZE_IPAD      140

#define AVATAR_ANIMATION_TIMEINTERNVAL      0.3
#define AVATAR_SHOW_TIMEINTERNVAL      20.0

//card information handling functions;
int GetCardType(int card);
int GetCardValue(int card);
int GetRandom();
int IsCardValid(int card);
int IsBasicCard(int card);
int IsTempCard(int card);

int CardCalculation(int nValue1, int nValue2, int nOperation);

//double GetPointPickerWidth();
//double GetPointPickerHeight();

