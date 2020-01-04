//
//  CGameLayout.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-27.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "CGameLayout.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#include "GameUtility.h"


CGRect g_BasicCardRect[4];
CGRect g_TempCardRect[4];
CGRect g_EqnViewRect[3];

@implementation CGameLayout

+ (float)GetGameViewWidth_P
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return GAME_VIEW_X_P_IPHONE;
	}
	else 
	{
		return GAME_VIEW_X_P_IPAD;
	}
}

+ (float) GetGameViewWidth_L
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return GAME_VIEW_X_L_IPHONE;
	}
	else 
	{
		return GAME_VIEW_X_L_IPAD;
	}
}


+ (void)initializeLayout
{
	float fstartx, fstarty, fcardw, fcardh, fcardm;
	fcardw = [CGameLayout GetCardWidth];  
	fcardh = [CGameLayout GetCardHeight]; 
	fcardm = [CGameLayout GetCardMargin];
	fstarty = fcardm*2+[GUILayout GetTitleBarHeight];//[GUILayout GetDefaultTitleBarHeight];
	if([ApplicationConfigure iPADDevice])
        fstarty += fcardm*3;    
        
	fstartx = ([CGameLayout GetGameViewWidth_P] - (fcardw*4.0+fcardm*3.0))/2.0;

	int i;
	for(i = 0; i < 4; ++i)
	{	
		g_BasicCardRect[i] = CGRectMake(fstartx+(fcardw + fcardm)*i, fstarty, fcardw, fcardh);
		g_TempCardRect[i] = CGRectMake(fstartx+(fcardw + fcardm)*i, fstarty, fcardw, fcardh);
	}
    
    float ratio = (fcardw*4+fcardm*3)/fcardh;
    float eh = fcardh*2/3;
    float ew = ratio*eh;
    float ex = ([CGameLayout GetResultViewSize] - ew)/2.0;//([CGameLayout GetGameViewWidth_P] - ew)/2.0; 
    
	for(i = 0; i < 3; ++i)
	{	
		g_EqnViewRect[i] = CGRectMake(ex, fcardm*2+fstarty+(eh + fcardm)*i, ew, eh);
	}
}

+ (void)Intialize
{
    [CGameLayout initializeLayout];
}	

+ (CGRect)GetBasicCardRect:(int)nIndex
{
	if(0 <= nIndex && nIndex < 4)
	{
			return g_BasicCardRect[nIndex];	
	}
	else 
	{
		return g_BasicCardRect[0];
	}
}

+ (CGRect)GetTempCardRect:(int)nIndex
{
	if(0 <= nIndex && nIndex < 4)
	{
		return g_TempCardRect[nIndex];	
	}
	else 
	{
		return g_TempCardRect[0];
	}
}	


+ (CGPoint)ChangeToLandscape:(CGPoint)pt
{
	CGPoint retPt;
	retPt.y = [GUILayout GetContentViewHeight]-pt.x;
	retPt.x = pt.y;
	return retPt;
}

+ (CGPoint)ChangeToProtrait:(CGPoint)pt
{
	CGPoint retPt;
	retPt.x = [GUILayout GetContentViewHeight]-pt.y;
	retPt.y = pt.x;
	return retPt;
}  	


+ (float)GetBulletinUnitSize
{
	if([ApplicationConfigure iPhoneDevice])
	{
        return GAME_SCORE_UNIT_SIZE;
    }
    else
    {
        return GAME_SCORE_UNIT_SIZE*5/3;
    }
}


+ (CGRect)GetDealCountAreaRect
{
	CGRect rect;

	rect.origin.y = 0;
    rect.size.width = 2*[CGameLayout GetBulletinUnitSize];
	rect.origin.x = [GUILayout GetContentViewWidth] - rect.size.width;
	rect.size.height = [CGameLayout GetBulletinUnitSize];

	return rect;
}

+ (CGRect)GetScoreAreaRect
{
	CGRect rect;
	
	rect.origin.y = 0;
    rect.size.width = 2*[CGameLayout GetBulletinUnitSize];
	rect.origin.x = [GUILayout GetContentViewWidth] - rect.size.width;
	rect.size.height = [CGameLayout GetBulletinUnitSize];
	
	return rect;
}

+ (CGRect)GetOperand1Rect
{
	CGRect rect = [CGameLayout GetBasicCardRect:0];
	rect.origin.y = rect.origin.y + [CGameLayout GetCardMargin]*3 + rect.size.height; 
	return rect;
}

+ (CGRect)GetOperand2Rect
{
	CGRect rect = [CGameLayout GetBasicCardRect:2];
	rect.origin.y = rect.origin.y + [CGameLayout GetCardMargin]*3 + rect.size.height; 
	return rect;
}

+ (CGRect)GetResultRect
{
	CGRect rect = [CGameLayout GetBasicCardRect:3];
	rect.origin.y = rect.origin.y + [CGameLayout GetCardMargin]*3 + rect.size.height; 
	return rect;
}

+ (CGRect)GetSignsRect
{
	CGRect rect = [CGameLayout GetBasicCardRect:1];
	rect.origin.y = rect.origin.y + [CGameLayout GetCardMargin]*3 + rect.size.height; 
	float w = [CGameLayout GetGameSignOutterSize];
	
	float cx = rect.origin.x + rect.size.width*0.5;
	float cy = rect.origin.y + rect.size.height*0.5;

	float sx = cx - w*0.5;
	float sy = cy - w*0.5;
	CGRect rt = CGRectMake(sx, sy, w, w);
	return rt;
}	

+ (float)GetEqnImageWidth
{
	float fcardw = [CGameLayout GetCardWidth];  
	float fcardm = [CGameLayout GetCardMargin];
    float fRet = fcardw*4+fcardm*3;
    return fRet;
}


+ (float)GetEqnImageHeight
{
    float fRet = [CGameLayout GetCardHeight];
    return fRet;
}


+ (CGRect)GetEqnViewRect:(int)nIndex
{
	if(0 <= nIndex && nIndex < 3)
	{
		return g_EqnViewRect[nIndex];	
	}
	else 
	{
		return g_EqnViewRect[0];
	}
}	

+ (float)GetResultViewSize
{
    if([ApplicationConfigure iPADDevice])
        return 560;
    else
        return 260;
}

+ (float) GetGameGreetViewWidth
{
    float fUnitSize = [CGameLayout GetStatusBarAnimatorSize];
    float fEdge = [GUILayout GetDefaultAlertUIEdge];

    float fRet = fUnitSize*4 + fEdge*12;
    return fRet;
}

+ (float)GetStatusBarAnimatorSize
{
	if([ApplicationConfigure iPhoneDevice])
	{
        return GAME_STATUS_BAR_ANIMATOR_SIZE_IPHONE;
    }
    else
    {
        return GAME_STATUS_BAR_ANIMATOR_SIZE_IPAD;
    }
}

+ (float) GetGameGreetViewHeight
{
    float fUnitSize = [CGameLayout GetStatusBarAnimatorSize];
    float fEdge = [GUILayout GetDefaultAlertUIEdge];
    
    float fRet = fUnitSize + fEdge*6;
    return fRet;
}	

+ (CGRect)GetGreetViewRect
{
	float w, h, gw, gh;
	w = [GUILayout GetContentViewWidth];
	h = [GUILayout GetContentViewHeight];
	gw = [CGameLayout GetGameGreetViewWidth]; 
	gh = [CGameLayout GetGameGreetViewHeight];
	
	CGRect rect = CGRectMake((w-gw)*0.5, (h-gh)*0.5, gw, gh);	
	
	return rect;
}


+ (float) GetCardWidth
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return CARD_WIDTH_P_IPHONE;
	}
	else 
	{
		return CARD_WIDTH_P_IPAD;
	}
}

+ (float) GetCardHeight
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return CARD_HEIGHT_P_IPHONE;
	}
	else 
	{
		return CARD_HEIGHT_P_IPAD;
	}
}

+ (float) GetCardCornerWidth
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return CARD_CORNCER_X_IPHONE;
	}
	else 
	{
		return CARD_CORNCER_X_IPAD;
	}
}

+ (float) GetCardCornerHeight
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return CARD_CORNCER_Y_IPHONE;
	}
	else 
	{
		return CARD_CORNCER_Y_IPAD;
	}
}

+ (float) GetCardCornerRadium
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return CARD_CORNCER_R_IPHONE;
	}
	else 
	{
		return CARD_CORNCER_R_IPAD;
	}
}	

+ (float) GetCardMargin
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return CARD_MARGIN_IPHONE;
	}
	else 
	{
		return CARD_MARGIN_IPAD;
	}
}	

+ (float) GetCardSignHeight
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return CARD_SIGN_HEIGHT_IPHONE;
	}
	else 
	{
		return CARD_SIGN_HEIGHT_IPAD;
	}
}

+ (float) GetCardAnimalSignHeight
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return CARD_ANIMAL_SIGN_HEIGHT_IPHONE;
	}
	else 
	{
		return CARD_ANIMAL_SIGN_HEIGHT_IPAD;
	}
}


+ (float) GetCardInnerMargin
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return CARD_INNER_MARGIN_IPHONE;
	}
	else 
	{
		return CARD_INNER_MARGIN_IPAD;
	}
}	

+ (float) GetGameSignOutterSize
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return GAME_SIGNS_OUTTER_SIZE_IPHONE;
	}
	else 
	{
		return GAME_SIGNS_OUTTER_SIZE_IPAD;
	}
}

+ (float) GetGameSignInnerSize
{
	if([ApplicationConfigure iPhoneDevice])
	{
		return GAME_SIGNS_INNER_SIZE_IPHONE;
	}
	else 
	{
		return GAME_SIGNS_INNER_SIZE_IPAD;
	}
}	

@end
