//
//  GameCenterPostDelegate.h
//  LuckyCompass
//
//  Created by Zhaohui Xing on 2011-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GameCenterPostDelegate <NSObject>
- (void) OpenLeaderBoardView:(int)boardIndex;
- (void) OpenLeaderBoardViewByPoint:(int)nPoint;
- (void) OpenAchievementViewBoardView:(int)boardIndex;
- (void) PostGameCenterScore:(int)nScore withBoard:(int)boardIndex;
- (void) PostGameCenterScoreByPoint:(int)nScore withPoint:(int)nPoint;
- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex;
- (void) PostAchievementByPoint:(float)achievement withPoint:(int)nPoint;
- (void) PostTwitterMessage:(NSString*)tweet;

- (void)PostAWSWonMessage:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withScore:(int)nScore;
- (id)GetAWSMessager;
- (BOOL)IsAWSMessagerEnabled;
- (NSString*)GetDefaultAWSNickName;
- (NSMutableArray *)GetAWSMessagesQueue;
- (void)InitAWSMessager;

- (void)PostCurrentGameScoreOnline;
@end
