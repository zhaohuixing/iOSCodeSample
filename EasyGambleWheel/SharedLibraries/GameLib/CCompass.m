//
//  CCompass.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CCompass.h"
#import "ApplicationConfigure.h"

@implementation CCompass

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_Painter = [[CCompassRender alloc] init];
    }
    return self;
}

-(void)dealloc
{
}

-(void)DrawCompass:(CGContextRef)context withSize:(CGSize)size
{
    float fSize = [CCompassRender GetCompassRenderContextSize]; //[CCompassRender GetCompassImageSize];
    float sx = (size.width-fSize)*0.5;
    float sy = (size.width-fSize)*0.5;
    CGRect rt = CGRectMake(sx, sy, fSize, fSize);
    [m_Painter DrawCompass:context at:rt];
    if(m_Delegate)
    {   
        int nState = [m_Delegate GetGameState];
        if(nState == GAME_STATE_READY || nState == GAME_STATE_RESET)
        {    
            [m_Painter DrawGameReadyHighlight:context at:rt];
        }    
        else if(nState == GAME_STATE_RESULT)
        {
            int index = [m_Delegate GetWinScopeIndex];
            [m_Painter DrawGameResultHighlight:context at:rt index:index];
        }    
    }    
}

-(void)OnTimerEvent
{
    if(m_Delegate)
    {   
        int nState = [m_Delegate GetGameState];
        if(nState == GAME_STATE_READY || nState == GAME_STATE_RESET)
            [m_Painter OnTimerEventReady];
        else if(nState == GAME_STATE_RESULT)
            [m_Painter OnTimerEventResult];
    }    
}

- (void)SetGameType:(int)nType theme:(int)themeType
{
    [m_Painter SetCurrentGameType:nType theme:themeType];
}


@end
