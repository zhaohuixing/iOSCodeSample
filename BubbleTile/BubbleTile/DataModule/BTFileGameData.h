//
//  BTFileGameData.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BTFileConstant.h"
#import "GameMessage.h"

@interface BTFileGameData : NSObject
{
    int                     m_GameType; 
    int                     m_Bubble;
    int                     m_GridType;
    int                     m_GridLayout;
    int                     m_GridEdge;
    int                     m_GameLevel;
    int                     m_HiddenBubbleIndex; //For traditional slide type game
    NSMutableArray*         m_GameSet;
    NSMutableArray*         m_EasySolution;
}

@property (nonatomic)int                                        m_GameType;
@property (nonatomic)int                                        m_Bubble;
@property (nonatomic)int                                        m_GridType;
@property (nonatomic)int                                        m_GridLayout;
@property (nonatomic)int                                        m_GridEdge;
@property (nonatomic)int                                        m_GameLevel;
@property (nonatomic)int                                        m_HiddenBubbleIndex;
@property (nonatomic, readonly, retain)NSMutableArray*          m_GameSet;
@property (nonatomic, readonly, retain)NSMutableArray*          m_EasySolution;

/*-(void)SetGameParams:(int)nBubble type:(int)nGridType layout:(int)nLayout edge:(int)nEdge level:(int)nLevel gameset:(NSArray*)arrayGameSet easysolution:(NSArray*)arrayEasyWay;*/

-(void)SaveToMessage:(GameMessage*)msg;
-(void)LoadFromMessage:(NSDictionary*)msgData;
-(BOOL)IsValid;
@end
