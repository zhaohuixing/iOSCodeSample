//
//  ApplicationController+Online.h
//  MindFire
//
//  Created by Zhaohui Xing on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ApplicationController.h"

@interface ApplicationController (Online)

-(BOOL)HasGameMaster;
-(void)StartCenterMasterCheck;
-(void)StopCenterMasterCheck;

-(void)HandleGameMasterCheck;

- (BOOL)IsMySelfActive;
- (BOOL)IsPlayer1Active;
- (BOOL)IsPlayer2Active;
- (BOOL)IsPlayer3Active;
- (NSString*)GetMyPlayerID;
- (NSString*)GetPlayer1PlayerID;
- (NSString*)GetPlayer2PlayerID;
- (NSString*)GetPlayer3PlayerID;

- (void)StartMasterCountingForNewGame;
- (void)HandleStartMasterCountingForNewGame;



@end
