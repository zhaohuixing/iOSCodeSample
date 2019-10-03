//
//  GUIEventLoop.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@import UIKit;


@interface GUIEventLoop : NSObject 
{
}

+(void)RegisterEvent:(int)event eventHandler:(SEL)handler eventReceiver:(id)observer eventSender:(id)sender;
+(void)SendEvent:(int)event eventSender:(id)sender;
+(void)PostEvent:(int)event;
+(void)RemoveEvent:(int)event eventReceiver:(id)observer eventSender:(id)sender;

@end
