//
//  CGambleWheel.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameUtiltyObjects.h"
#import "CCompass.h"
#import "CPointer.h"

@class CPinActionLevel; 
@interface CGambleWheel : GameBaseObject
{
    CCompass*       m_Compass;
    CPointer*       m_Pointer;
}

+(float)GetRenderSize;

- (void)OnTimerEvent;
- (void)Draw:(CGContextRef)context inRect:(CGRect)rect;
- (void)StartSpin:(CPinActionLevel*)action;
- (void)RegisterDelegate:(id<GameStateDelegate>)delegate;
- (void)SetGameType:(int)nType theme:(int)themeType;
- (void)Stop;
@end
