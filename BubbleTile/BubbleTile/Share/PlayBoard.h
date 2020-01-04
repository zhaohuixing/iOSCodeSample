//
//  PlayBoard.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-06.
//  Copyright 2011 xgadget. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PlayBoardController.h"

@interface PlayBoard : UIView 
{
    PlayBoardController*    m_GameController;
    BOOL                    m_bAnimation;
}

-(void)UpdateGameViewLayout;
-(void)StartNewGame:(BOOL)bLoadCacheData;
-(void)UndoGame;
-(void)ResetGame;
-(void)OnTomerEvent;
-(BOOL)InAnimation;
-(void)CheckBubbleState;
-(void)CleanBubbleCheckState;
-(void)TestSuite;
-(BOOL)IsWinAnimation;
-(BOOL)IsEasyAnimation;
-(void)StartEasyAnimation:(int)nSelectedType;
-(BOOL)IsGameComplete;
-(void)LoadGameSet:(NSMutableDictionary**)dataDict;
//-(void)LoadUndoList:(NSMutableDictionary**)dataDict withKey:(NSString*)szKey;
- (void)LoadUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index;
-(void)StartNewGameFromOpenFile:(BOOL)bRestart;


@end
