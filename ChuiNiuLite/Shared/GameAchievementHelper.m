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


+(float)get_SkillOne_LevelOnePercent
{
    float fRet = 0.0;
    
    float fFactor = _LEVEL_ONE_ACHIEVEMENT_POINT_*_SKILL_ONE_LEVEL_ONE_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_ONE atLevel:GAME_PLAY_LEVEL_ONE];
    //fScore = 30.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)get_SkillTwo_LevelOnePercent
{
    float fRet = 0.0;

    float fFactor = _LEVEL_ONE_ACHIEVEMENT_POINT_*_SKILL_TWO_LEVEL_ONE_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_TWO atLevel:GAME_PLAY_LEVEL_ONE];
    //fScore = 20.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)get_SkillThree_LevelOnePercent
{
    float fRet = 0.0;

    float fFactor = _LEVEL_ONE_ACHIEVEMENT_POINT_*_SKILL_THREE_LEVEL_ONE_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_THREE atLevel:GAME_PLAY_LEVEL_ONE];
    //fScore = 40.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)GetCurrentLevelOnePercent
{
    float fRet = 0.0;
    
    fRet = [GameAchievementHelper get_SkillOne_LevelOnePercent];
    fRet += [GameAchievementHelper get_SkillTwo_LevelOnePercent]; 
    fRet += [GameAchievementHelper get_SkillThree_LevelOnePercent]; 
    
    return fRet;
}

+(float)get_SkillOne_LevelTwoPercent
{
    float fRet = 0.0;
    
    float fFactor = _LEVEL_TWO_ACHIEVEMENT_POINT_*_SKILL_ONE_LEVEL_TWO_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_ONE atLevel:GAME_PLAY_LEVEL_TWO];
    //fScore = 20.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)get_SkillTwo_LevelTwoPercent
{
    float fRet = 0.0;

    float fFactor = _LEVEL_TWO_ACHIEVEMENT_POINT_*_SKILL_TWO_LEVEL_TWO_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_TWO atLevel:GAME_PLAY_LEVEL_TWO];
    //fScore = 30.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)get_SkillThree_LevelTwoPercent
{
    float fRet = 0.0;
    
    float fFactor = _LEVEL_TWO_ACHIEVEMENT_POINT_*_SKILL_THREE_LEVEL_TWO_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_THREE atLevel:GAME_PLAY_LEVEL_TWO];
    //fScore = 20.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)GetCurrentLevelTwoPercent
{
    float fRet = 0.0;
    
    fRet = [GameAchievementHelper get_SkillOne_LevelTwoPercent];
    fRet += [GameAchievementHelper get_SkillTwo_LevelTwoPercent]; 
    fRet += [GameAchievementHelper get_SkillThree_LevelTwoPercent]; 
    
    return fRet;
}

+(float)get_SkillOne_LevelThreePercent
{
    float fRet = 0.0;
    
    float fFactor = _LEVEL_THREE_ACHIEVEMENT_POINT_*_SKILL_ONE_LEVEL_THREE_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_ONE atLevel:GAME_PLAY_LEVEL_THREE];
    //fScore = 20.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)get_SkillTwo_LevelThreePercent
{
    float fRet = 0.0;
    
    float fFactor = _LEVEL_THREE_ACHIEVEMENT_POINT_*_SKILL_TWO_LEVEL_THREE_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_TWO atLevel:GAME_PLAY_LEVEL_THREE];
    //fScore = 20.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)get_SkillThree_LevelThreePercent
{
    float fRet = 0.0;
    
    float fFactor = _LEVEL_THREE_ACHIEVEMENT_POINT_*_SKILL_THREE_LEVEL_THREE_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_THREE atLevel:GAME_PLAY_LEVEL_THREE];
    //fScore = 20.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)GetCurrentLevelThreePercent
{
    float fRet = 0.0;
    
    fRet = [GameAchievementHelper get_SkillOne_LevelThreePercent];
    fRet += [GameAchievementHelper get_SkillTwo_LevelThreePercent]; 
    fRet += [GameAchievementHelper get_SkillThree_LevelThreePercent]; 
    
    return fRet;
}

+(float)get_SkillOne_LevelFourPercent
{
    float fRet = 0.0;
    
    float fFactor = _LEVEL_FOUR_ACHIEVEMENT_POINT_*_SKILL_ONE_LEVEL_FOUR_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_ONE atLevel:GAME_PLAY_LEVEL_FOUR];
    //fScore = 20.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)get_SkillTwo_LevelFourPercent
{
    float fRet = 0.0;
    
    float fFactor = _LEVEL_FOUR_ACHIEVEMENT_POINT_*_SKILL_TWO_LEVEL_FOUR_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_TWO atLevel:GAME_PLAY_LEVEL_FOUR];
    //fScore = 20.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}

+(float)get_SkillThree_LevelFourPercent
{
    float fRet = 0.0;
    
    float fFactor = _LEVEL_FOUR_ACHIEVEMENT_POINT_*_SKILL_THREE_LEVEL_FOUR_WINCOUNT_;
    float fScore = (float)[ScoreRecord getScore:GAME_SKILL_LEVEL_THREE atLevel:GAME_PLAY_LEVEL_FOUR];
    //fScore = 20.0;
    fRet = fScore/fFactor*100.0;  
    
    return fRet;
}


+(float)GetCurrentLevelFourPercent
{
    float fRet = 0.0;
    
    fRet = [GameAchievementHelper get_SkillOne_LevelFourPercent];
    fRet += [GameAchievementHelper get_SkillTwo_LevelFourPercent]; 
    fRet += [GameAchievementHelper get_SkillThree_LevelFourPercent]; 
    
    return fRet;
}


@end
