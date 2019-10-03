//
//  GameBaseObject.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-08.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameBaseObject.h"

@implementation GameBaseObject

-(void)RegisterDelegate:(id<GameStateDelegate>)delegate
{
    m_Delegate = delegate;
}

@end
