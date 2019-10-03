//
//  AppleGameCenterEngine.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
@import UIKit;
@import GameKit;

#import "GameCenterConstant.h"

@interface AppleGameCenterEngine : NSObject
{
@private    
	id <GameCenterManagerDelegate, GKMatchmakerViewControllerDelegate, NSObject>              m_GameCenterManager;
    id <GameCenterOnlinePlayDelegate, NSObject>           m_OnlineGameController;
}

-(void)AttachDelegates:(id<GameCenterManagerDelegate, GKMatchmakerViewControllerDelegate, NSObject>)pMainDelegate with:(id <GameCenterOnlinePlayDelegate>)pControllerDelegate;
-(void)StartNewGameCenterSession:(int)nMaxPlayer;
-(void)StartNewGameCenterSessionWithPlayer:(NSString*)playerID;
-(void)AutoSearchGameCenterSession;
-(void)AddReplacementPlyerToGameSession:(GKMatch*)match;
-(void)AutoHandleGameSessionInvitation;
-(void)StartGKBTSession;

@end
