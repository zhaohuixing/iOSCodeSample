//
//  CCompass.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCompassRender.h"
#import "GameBaseObject.h"

@interface CCompass : GameBaseObject
{
    CCompassRender*     m_Painter;
}

- (void)OnTimerEvent;
- (void)DrawCompass:(CGContextRef)context withSize:(CGSize)size;
- (void)SetGameType:(int)nType theme:(int)themeType;
@end
