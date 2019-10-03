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
#define GAME_MSG_TYPE_GAMEPLAYNEXTTURN      2

//Game type
#define GAME_MSG_TYPE_PLAYERBALANCE         3

//Game player bet type
#define GAME_MSG_TYPE_PLAYERBET             4

//Game play type
#define GAME_MSG_TYPE_ACTIONLEVEL           5

//Message type of game player start writting text message 
#define GAME_MSG_TYPE_STARTWRITTING         6

//Message type of game player start voice chatting  
#define GAME_MSG_TYPE_STARTCHATTING         7

//Message type of game player stop voice chatting  
#define GAME_MSG_TYPE_STOPCHATTING          8

//Message game player state update  
#define GAME_MSG_TYPE_PLAYERSTATE           9

//Message online game setting update  
#define GAME_MSG_TYPE_GAMESETTINGSYNC       10

//Message online game player transfter game chips  
#define GAME_MSG_TYPE_MONEYTRANSFER         11

//Message online game player transfter game chips  
#define GAME_MSG_TYPE_PLAYERPLAYABLITY      12

#define GAME_MSG_TYPE_MONEYTRANSFERRECEIPT         13

//Message online game player transfter game chips
#define GAME_MSG_TYPE_CANCELPENDINGBET      14

//Message online game player transfter game chips
#define GAME_MSG_TYPE_PLAYERPLAYABLITY      15

//Message type of AWS Game master game setting not received
#define GAME_MSG_TYPE_AWSGAMEMASTERSETTINGNOTRECEIVED   16

//Message type of AWS Game setting not received
#define GAME_MSG_TYPE_AWSGAMEPEERBALANCENOTRECEIVED   17

//
//The message key constant
//
//message type key
#define GAME_MSG_KEY_TYPE                   @"GMSG_TYPE"

//text message key
#define GAME_MSG_KEY_TEXTMSG                @"GMSG_TEXTMSG"

//Game type message key (online game setting sync)
#define GAME_MSG_KEY_GAMETYPEMSG            @"GMSG_GAMETYPE"

//Game online play turn key
#define GAME_MSG_KEY_ONLINEPLAYSEQUENCE     @"GMSG_OLPSEQ"

//Game type message key (online game setting sync)
#define GAME_MSG_KEY_THEMETYPEMSG           @"GMSG_THEMETYPE"

//Game pin message key
#define GAME_MSG_KEY_PLAYERBET              @"GMSG_PLAYERBET"

//Game playing action level related message key
#define GAME_MSG_KEY_ACTION_FASTCYCLE               @"GMSG_ATFAST"
#define GAME_MSG_KEY_ACTION_MEDIUMCYCLE             @"GMSG_ATMEDIUM"
#define GAME_MSG_KEY_ACTION_SLOWCYCLE               @"GMSG_ATSLOW"
#define GAME_MSG_KEY_ACTION_SLOWANGLE               @"GMSG_ATSLOWANGLE"
#define GAME_MSG_KEY_ACTION_VIBCYCLE                @"GMSG_ATVIB"
#define GAME_MSG_KEY_ACTION_CLOCKWISE               @"GMSG_ATDIR"

//Game player pledge lucky number key for general purpose
#define GAME_MSG_KEY_PLEDGET_LUCKYNUMBER                @"GMSG_LUCKYNUMBER"

//Game player pledge bet key for general purpose
#define GAME_MSG_KEY_PLEDGET_BET                        @"GMSG_BET"

//Game player chips' balance key for general purpose
#define GAME_MSG_KEY_PLAYER_CHIPS_BALANCE               @"GMSG_BALANCE"

//Game player ID message key for general purpose
#define GAME_MSG_KEY_PLAIN_PLAYER_ID                    @"GMSG_PID"

//master id key
#define GAME_MSG_KEY_MASTER_ID                          @"GMSG_MID"

//non-master player one id key
#define GAME_MSG_KEY_PLAYERONE_ID                       @"GMSG_P1ID"

//non-master player two id key
#define GAME_MSG_KEY_PLAYERTWO_ID                       @"GMSG_P2ID"

//non-master player three id key
#define GAME_MSG_KEY_PLAYERTHREE_ID                     @"GMSG_P3ID"

//set playing turn to next player
#define GAME_MSG_KEY_GAMENEXTTURN_ID                    @"GMSG_GNTID"

//Player state update message key
#define GAME_MSG_KEY_PLAYERSTATE                        @"GMSG_PLAYERSTATE"

//id key for sender player ID transfter game chips  
#define GAME_MSG_KEY_MONEYSENDER                        @"GMSG_CHIPSENDER"

//id key for sender player ID transfter game chips  
#define GAME_MSG_KEY_MONEYRECIEVER                      @"GMSG_CHIPRECIEVER"

//id key for sender player ID transfter game chips  
#define GAME_MSG_KEY_TRANSMONEYMOUNT                    @"GMSG_TRANSCHIP"

//id key for player playablity  
#define GAME_MSG_KEY_PLAYERPLAYABLITY                   @"GMSG_PLAYABLITY"


#endif
