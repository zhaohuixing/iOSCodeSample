//
//  CGameSectionManager+GKOnline.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CGameSectionManager.h"

@interface CGameSectionManager (GKOnline)

//GameControllerDelegate methods
-(void)StartGKGameAsMaster:(GKMatch*)match;
-(void)StartGKGameAsParticipant:(GKMatch*)match;
-(void)AddGKPlayerToOnlineGame:(NSString*)playerID;

-(void)PopupGKMatchWindow;
-(void)StartGKMatchAutoSearch;
-(void)PopupGKMatchWindowForPlayWith:(NSString*)szPlayerID;

//GameCenterOnlinePlayDelegate functions
- (void)joinExistedMatch:(GKMatch*)gameMatch;

-(void)SetGKBTPeerID:(NSString*)peerID;
-(void)SetGKBTMyID:(NSString*)myID;
-(void)AdviseGKBTSession:(GKSession*)session;
-(void)StartGKBTSessionGamePreset;        

@end
