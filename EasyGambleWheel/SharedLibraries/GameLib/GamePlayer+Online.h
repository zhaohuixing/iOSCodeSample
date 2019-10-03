//
//  GamePlayer.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-09-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "GamePlayer.h"
#import "GameUtiltyObjects.h"


@interface GamePlayer (Online) 

-(void)LoadAppleGameCenterPlayerImage:(GKPlayer*)gkPlayer;

-(void)SetCachedTransferedChipNumber:(int)nCachedSentChips;

-(void)SetGKCenterMaster:(BOOL)bGKMaster;
-(BOOL)IsGKCenterMaster;

-(void)SetPlayerOnlineStatus:(BOOL)bOnlinePlayer;
-(BOOL)IsOnlinePlayer;

-(void)OpenOnlinePopupMenu;

-(void)OnOnLineChipBalance;
-(void)OnOnLineEarnChipBalance;
-(void)OnOnLineSendMoney;
-(void)OnOnLinePlayerMessage;
-(void)OnOnLinePlayerLocation;


-(NSString*)GetMyOnlineTextMessage;

-(void)ShowOnlineMessage:(NSString*)szText;

-(void)ShowBalance;

@end
