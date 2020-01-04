//
//  CUndoCommand.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"


@interface CUndoCommand : NSObject 
{
    enBubbleMotion      m_Motion;
    enMotionDirection   m_Direction;
    int                 m_PositionIndex;
}

@property (nonatomic)enBubbleMotion      m_Motion;
@property (nonatomic)enMotionDirection   m_Direction;
@property (nonatomic)int                 m_PositionIndex;

-(int)GetEncodeValue;
-(void)SetFromEncodeValue:(int)nEncode;

@end
