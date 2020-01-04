//
//  EasyShuffleSuite.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-09-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "CUndoCommand.h"

@interface EasyShuffleSuite : NSObject
{
@protected    
    enGridType          m_GridType;
    int                 m_nCount;
    //Using CUndoCommand object to record easy level step
    NSMutableArray*     m_StepList;

@private
    int                 m_nCachedIndex;
}

-(int)GetBubbleCount;
-(int)GetSteps;
-(enGridType)GetType;
-(CUndoCommand*)GetStep:(int)nIndex;
-(void)Shuffle:(enGridType)enType withBubble:(int)nCount;
-(BOOL)IsValid;
-(void)SaveGameEasySolution:(NSMutableArray*)easySolution;
-(void)LoadFromGameEasySolution:(NSArray*)easySolution;

@end
