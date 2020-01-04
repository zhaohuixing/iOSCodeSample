//
//  GameAchievementHelper.m
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 11-04-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "GameAchievementHelper.h"
#import "GameCenterConstant.h"
#import "ScoreRecord.h"

@implementation GameAchievementHelper


+(NSString*)GetLeaderBoardIDByPoint:(int)nPoint withSpeed:(int)nSpeed
{
    switch(nPoint)
    {
        case 27:
            if(nSpeed == 1)
                return _27_POINT_GAME_SLOW_;
            else if(nSpeed == 2)
                return _27_POINT_GAME_FAST_;
            break;
        case 24:
            if(nSpeed == 1)
                return _24_POINT_GAME_SLOW_;
            else if(nSpeed == 2)
                return _24_POINT_GAME_FAST_;
            break;
        case 21:
            if(nSpeed == 1)
                return _21_POINT_GAME_SLOW_;
            else if(nSpeed == 2)
                return _21_POINT_GAME_FAST_;
            break;
        case 18:
            if(nSpeed == 1)
                return _18_POINT_GAME_SLOW_;
            else if(nSpeed == 2)
                return _18_POINT_GAME_FAST_;
            break;
    }
    return _24_POINT_GAME_SLOW_;
}

+(NSString*)GetLeaderBoardIDByIndex:(int)nIndex
{
    switch(nIndex)
    {
        case 0:
            return _24_POINT_GAME_SLOW_;
        case 1:
            return _24_POINT_GAME_FAST_;
        case 2:
            return _21_POINT_GAME_SLOW_;
        case 3:
            return _21_POINT_GAME_FAST_;
        case 4:
            return _18_POINT_GAME_SLOW_;
        case 5:
            return _18_POINT_GAME_FAST_;
        case 6:
            return _27_POINT_GAME_SLOW_;
        case 7:
            return _27_POINT_GAME_FAST_;
        case 8:
            return _ALL_GAME_RECORD_;
    }
    return _24_POINT_GAME_SLOW_;
}

+(NSString*)GetAchievementIDByPoint:(int)nPoint
{
    switch(nPoint)
    {
        case 27:
            return _27_POINT_ACHIEVEMENT_;
        case 24:
            return _24_POINT_ACHIEVEMENT_;
        case 21:
            return _21_POINT_ACHIEVEMENT_;
        case 18:
            return _18_POINT_ACHIEVEMENT_;
        default:
            return _N_POINT_ACHIEVEMENT_;
    }
}

+(NSString*)GetAchievementIDByIndex:(int)nIndex
{
    switch(nIndex)
    {
        case 3:
            return _27_POINT_ACHIEVEMENT_;
        case 2:
            return _24_POINT_ACHIEVEMENT_;
        case 1:
            return _21_POINT_ACHIEVEMENT_;
        case 0:
            return _18_POINT_ACHIEVEMENT_;
        default:
            return _N_POINT_ACHIEVEMENT_;
    }
}

+(int)GetAchievementPointByPoint:(int)nPoint
{
    switch(nPoint)
    {
        case 27:
            return _REGULAR_ACHIEVEMENT_POINT_;
        case 24:
            return _REGULAR_ACHIEVEMENT_POINT_;
        case 21:
            return _REGULAR_ACHIEVEMENT_POINT_;
        case 18:
            return _REGULAR_ACHIEVEMENT_POINT_;
        default:
            return _N_ACHIEVEMENT_POINT_;
    }
    
}

+(int)GetAchievementWinCountByPoint:(int)nPoint
{
    switch(nPoint)
    {
        case 27:
            return _27_POINT_WINCOUNT_;
        case 24:
            return _24_POINT_WINCOUNT_;
        case 21:
            return _21_POINT_WINCOUNT_;
        case 18:
            return _18_POINT_WINCOUNT_;
        default:
            return _N_POINT_WINCOUNT_;
    }
}

+(float)GetPointAchievementPercent:(int)nPoint withScore:(int)nScore
{
    float fRet = 0.0;
    float fWinPoint = (float)[GameAchievementHelper GetAchievementPointByPoint:nPoint];
    float fWinCount = (float)[GameAchievementHelper GetAchievementWinCountByPoint:nPoint];
    fRet = ((float)nScore)*100.0/(fWinPoint*fWinCount);
    return fRet;
}

@end
