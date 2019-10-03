//
//  GameMsgConstant.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef __GAMEMSGCONSTANT_H__
#define __GAMEMSGCONSTANT_H__

//
//The message type ID constant
//
//text message type ID
#define GAME_MSG_TYPE_TEXT                  0

//Master candiate list
#define GAME_MSG_TYPE_MASTERCANDIATES       1

//Game playing turn shift
#define GAME_MSG_TYPE_GAMEPLAYSTART         2

//Game end play type
#define GAME_MSG_TYPE_GAMEPLAYEND           3

//Message type of game player start writting text message 
#define GAME_MSG_TYPE_STARTWRITTING         4

//Message type of game player start voice chatting  
#define GAME_MSG_TYPE_STARTCHATTING         5

//Message type of game player stop voice chatting  
#define GAME_MSG_TYPE_STOPCHATTING          6

//Message type of game player score update  
#define GAME_MSG_TYPE_SCOREUPDATE           7

//Message type of game player score update  
#define GAME_MSG_TYPE_GAMESETTINGSYNC       8

//
//The message key constant
//
//message type key
#define GAME_MSG_KEY_TYPE                   @"GMSG_TYPE"

//text message key
#define GAME_MSG_KEY_TEXTMSG                @"GMSG_TEXTMSG"

//Game compass message key
#define GAME_MSG_KEY_GAMESTART              @"GMSG_GAMESTART"

//Game pin message key
#define GAME_MSG_KEY_GAMEEND                @"GMSG_GAMEEND"

//master id key
#define GAME_MSG_KEY_MASTER_ID                          @"GMSG_MASTER_ID"

//non-master player one id key
#define GAME_MSG_KEY_PLAYERONE_ID                       @"GMSG_PLAYERONE_ID"

//non-master player two id key
#define GAME_MSG_KEY_PLAYERTWO_ID                       @"GMSG_PLAYERTWO_ID"

//non-master player three id key
#define GAME_MSG_KEY_PLAYERTHREE_ID                     @"GMSG_PLAYERTHREE_ID"

//set playing turn to next player
#define GAME_MSG_KEY_GAMENEXTTURN_ID                    @"GMSG_GAMETURNTONEXT"

//Best luck score
#define GAME_MSG_KEY_GAMESCORE_BEST                     @"GMSG_GAMESCORE_BEST"

//Configure level
#define GAME_MSG_KEY_GAMECONFIG_LEVEL                   @"GMSG_GAMECONFIG_LEVEL"

//Configure skill
#define GAME_MSG_KEY_GAMECONFIG_SKILL                   @"GMSG_GAMECONFIG_SKILL"

//Configure thunder
#define GAME_MSG_KEY_GAMECONFIG_THUNDER                 @"GMSG_GAMECONFIG_THUNDER"

//Best luck score
#define GAME_MSG_KEY_GAMESCORE_BEST                     @"GMSG_GAMESCORE_BEST"

//Game win msg value
#define GAMEMSG_VALUE_GAMEWIN                 1

//Game win msg value
#define GAMEMSG_VALUE_GAMELOSE                0


//AWS online post message key
#define AWS_MESSAGE_GAMER_NICKNAME_KEY                 @"AGNN"
#define AWS_MESSAGE_GAME_SETTINGINDEX_KEY              @"AGSI"
#define AWS_MESSAGE_GAME_RESULT_KEY                     @"AGR"
#define AWS_MESSAGE_GAME_TOTALSCORE_KEY                    @"AGTS"
#define AWS_MESSAGE_GAME_DEVICETYPE_KEY                    @"AGDT"


#endif
