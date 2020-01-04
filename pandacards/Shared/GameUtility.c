/*
 *  GameUtility.cpp
 *  MindFire
 *
 *  Created by ZXing on 23/10/2009.
 *  Copyright 2009 Zhaohui Xing. All rights reserved.
 *
 */
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

#include "GameUtility.h"

int GetCardType(int card)
{
	if(card < 0)
		return CARD_INVALID;
	else if(52 <= card)
		return CARD_TEMPCARD;
		
	return card/13;
}

int GetCardValue(int card)
{
	if(card < 0)
		return CARD_NUMBER_INVALID;
	else if(52 <= card)
		return card-52;
	
	return (card)%13+1;	
}

int IsCardValid(int card)
{
	int nRet = 0;
	
	if(0 <= card)
		nRet = 1;
	
	return nRet;
}

int IsBasicCard(int card)
{
	int nRet = 0;
	
	if(0 <= card && card < 52)
		nRet = 1;
	
	return nRet;
}

int IsTempCard(int card)
{
	int nRet = 0;
	if(52 <= card)
		nRet = 1;
	
	return nRet;
}

int GetRandom()
{
	int n;
	srand(time(NULL));
	n = rand();
	return n;
}

int CardCalculation(int nValue1, int nValue2, int nOperation)
{
	int nRet = -1;
	if(nOperation == GAME_CALCULATION_PLUS)
	{
		nRet = nValue1 + nValue2;
	}
	else if(nOperation == GAME_CALCULATION_MINUES)
	{
		nRet = nValue1 - nValue2;
		if(nRet < 0)
			nRet = -1;
	}	
	else if(nOperation == GAME_CALCULATION_TIME)
	{
		nRet = nValue1 * nValue2;
	}	
	else if(nOperation == GAME_CALCULATION_DIVIDE)
	{
		if(nValue2 != 0)
		{	
			int nRem = nValue1 % nValue2;
			if(nRem == 0)
			{
				nRet = nValue1/nValue2;
			}	
		}		
	}	
	
	return nRet;
}	

/*
double GetPointPickerWidth()
{
	if(m_iDeviceOS == IOS_IPHONE)
	{
		if(IsProtrait() == 1)
		{
			return GAME_POINTPICKER_WIDTH_IPHONE_P;
		}
		else 
		{
			return GAME_POINTPICKER_WIDTH_IPHONE_L;
		}
	}
	else 
	{
		return GAME_POINTPICKER_WIDTH_IPAD;
	}

}

double GetPointPickerHeight()
{
	if(m_iDeviceOS == IOS_IPHONE)
	{
		if(IsProtrait() == 1)
		{
			return GAME_POINTPICKER_HEIGHT_IPHONE_P;
		}
		else 
		{
			return GAME_POINTPICKER_HEIGHT_IPHONE_L;
		}
	}
	else 
	{
		return GAME_POINTPICKER_HEIGHT_IPAD;
	}
}	*/



