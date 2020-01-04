//
//  DebogConsole.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#undef DEBUG
#endif


@interface DebogConsole : NSObject

+(BOOL)IsEnabled;
+(void)ShowDebugMsg:(NSString*)msg;

@end
