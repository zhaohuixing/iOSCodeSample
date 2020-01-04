//
//  GameAchievementHelper.h
//  XXXXX
//
//  Created by Zhaohui Xing on 2011-04-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameAchievementHelper : NSObject 
{
    
}

+(NSString*)GetLeaderBoardIDByPoint:(int)nPoint withSpeed:(int)nSpeed;
+(NSString*)GetLeaderBoardIDByIndex:(int)nIndex;
+(NSString*)GetAchievementIDByPoint:(int)nPoint;
+(NSString*)GetAchievementIDByIndex:(int)nIndex;

+(int)GetAchievementPointByPoint:(int)nPoint;
+(int)GetAchievementWinCountByPoint:(int)nPoint;

+(float)GetPointAchievementPercent:(int)nPoint withScore:(int)nScore;

@end
