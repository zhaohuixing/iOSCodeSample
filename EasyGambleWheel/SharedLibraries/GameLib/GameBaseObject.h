//
//  GameBaseObject.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-08.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameConstants.h"
@interface GameBaseObject : NSObject
{
@protected
    id<GameStateDelegate>           m_Delegate;
}

-(void)RegisterDelegate:(id<GameStateDelegate>)delegate;
@end
