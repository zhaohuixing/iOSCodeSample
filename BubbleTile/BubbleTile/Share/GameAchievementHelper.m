//
//  GameAchievementHelper.m
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 11-04-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "stdinc.h"
#import "GameAchievementHelper.h"
#import "GameCenterConstant.h"
//#import "ScoreRecord.h"

@implementation GameAchievementHelper


+(NSString*)GetLeaderBoardIDByIndex:(int)nIndex
{
    switch(nIndex)
    {
        case _SQUARE3_DIFFICULT_GAME_INDEX_:
            return _SQUARE3_DIFFICULT_GAME_;
            
        case _TOTAL_DIFFICULT_GAMESCORE_INDEX_:
            return _TOTAL_DIFFICULT_GAMESCORE_;
        
        case _TOTAL_EASY_GAMESCORE_INDEX_:
            return _TOTAL_EASY_GAMESCORE_;
        
        default:
            return _TOTAL_GAMESCORE_;
    }
}


@end
