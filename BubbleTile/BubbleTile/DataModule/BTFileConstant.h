//
//  BTFileConstant.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 2012-01-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef BubbleTile_BTFileConstant_h
#define BubbleTile_BTFileConstant_h

#define BT_GAMESAVEDFILE_FOLDER             @"GameFiles"
#define BT_GAMEUNCOMPLETEDFILE_FOLDER       @"GameCacheFile"
#define BT_GAMECACHE_FILENAME               @"BTGameCache.btf"
#define BT_GAMEFILE_EXTENSION               @"btf"
#define BT_INBOX_FOLDER                     @"Inbox"


#define BT_DEVICEID_IPHONE                  0             //iPhone/iPod Touch
#define BT_DEVICEID_IPAD                    1             //iPad
#define BT_DEVICEID_ANDROID                 2             //Android device
#define BT_DEVICEID_WINDOWSPHONE            3             //Windows Phone/XBox
#define BT_DEVICEID_MAC                     4             //MAC computer
#define BT_DEVICEID_WINDOWS                 5             //Windows computer
#define BT_DEVICEID_WEB                     6             //Web


/////////////////////////////////////////////////////////
//
//Header Keys
//
/////////////////////////////////////////////////////////
#define BTF_ORIGINAL_FILE_NAME            @"FNAME"              //Value is string
#define BTF_LASTPLAY_TIME                 @"LPTIME"             //Value is string
#define BTF_ORIGINAL_TIME                 @"TIME"               //Value is string

#define BTF_ORIGINAL_CREATOR              @"AUTHOR"             //Value is string
#define BTF_ORIGINAL_EMAIL                @"EMAIL"              //Value is string
#define BTF_ORIGINAL_AGCPLAYERID          @"AGCPID"             //Value is string

#define BTF_ORIGINAL_GPSENABLE            @"GPSBOOL"            //Value is boolean
#define BTF_ORIGINAL_LOCATIONGPSX         @"GPSX"               //Value is float
#define BTF_ORIGINAL_LOCATIONGPSY         @"GPSY"               //Value is float

#define BTF_ORIGINAL_DEVICE               @"DEVICE"             //Value is integter,
                                                                //0: iPhone, 
                                                                //1: iPAD, 
                                                                //2: Android, 
                                                                //3: Window Phone/XBox, 
                                                                //4: MAC
                                                                //5: Windows

#define BTF_ORIGINAL_VERSION              @"VERSION"            //Value is string,

#define BTF_GAME_GAMETYPE                 @"GAME"               //Value is integter, 0: Bubble Tile, 1: traditional slide puzzle

#define BTF_GAME_BUBBLE                   @"BUBBLE"             //Value is integter,
                                                                //0:Color
                                                                //1:Star
                                                                //2:Frog    

#define BTF_GAME_GRIDTYPE                 @"GRID"               //Value is integter,
                                                                //0: triangle
                                                                //1: Square
                                                                //2: Diamond
                                                                //3: Hexagon

#define BTF_GAME_LAYOUTTYPE               @"LAYOUT"             //Value is integter,
                                                                //0: Matrix
                                                                //1: Snake
                                                                //2: Spiral

#define BTF_GAME_EDGE                     @"EDGE"               //Value is integter,

#define BTF_GAME_LEVEL                    @"LEVEL"              //Value is integter,
                                                                //0: Easy
                                                                //1: Difficulty

#define BTF_GAME_HIDDENBUBBLE_INDEX       @"HINDEX"             //Value is integter, for traditional slide puzzle game

#define BTF_GAME_GAMESET                  @"GSET"               //Value is integter array for bubble index setting,

#define BTF_GAME_GAMEEASYSOLUTION         @"EASYWAY"            //Value is integter array for playing steps,


/////////////////////////////////////////////////////////
//
//Playing record Key prefixs
//
/////////////////////////////////////////////////////////
#define BTF_RECORD_PLAY_COUNT_KEY         @"RECORDS"             //Value is integer
#define BTF_RECORD_PLAY_TIME_PREFIX       @"RTIME"              //Value is string

#define BTF_RECORD_PLAYER_PREFIX          @"RPLAYER"             //Value is string
#define BTF_RECORD_EMAIL_PREFIX           @"REMAIL"              //Value is string
#define BTF_RECORD_AGCPLAYERID_PREFIX     @"RAGCPID"             //Value is string

#define BTF_RECORD_GPSENABLE_PREFIX       @"RGPSBOOL"            //Value is boolean
#define BTF_RECORD_LOCATIONGPSX_PREFIX    @"RGPSX"               //Value is float
#define BTF_RECORD_LOCATIONGPSY_PREFIX    @"RGPSY"               //Value is float

#define BTF_RECORD_DEVICE_PREFIX          @"RDEVICE"             //Value is integter,
//0: iPhone, 
//1: iPAD, 
//2: Android, 
//3: Window Phone/XBox, 
//4: MAC
//5: Windows

#define BTF_RECORD_VERSION_PREFIX         @"RVERSION"            //Value is string,

#define BTF_RECORD_PLAYING_STATE_PREFIX        @"RSTATE"               //Value is integter
                                                                        //0: playing completed game file
                                                                        //1: playing uncompleted game file

#define BTF_RECORD_PLAYING_STEPS_PREFIX        @"RSTEP"               //Value is integter array for player steps


//AWS online post message key
#define AWS_MESSAGE_GAMER_NICKNAME_KEY                 @"AGNN"
#define AWS_MESSAGE_GAME_GRID_KEY                       @"AGG"
#define AWS_MESSAGE_GAME_LAYOUT_KEY                     @"AGL"
#define AWS_MESSAGE_GAME_UNIT_KEY                       @"AGU"
#define AWS_MESSAGE_GAME_RESULT_KEY                     @"AGR"
#define AWS_MESSAGE_GAME_TOTALSCORE_KEY                    @"AGTS"
#define AWS_MESSAGE_GAME_DEVICETYPE_KEY                    @"AGDT"

#endif
