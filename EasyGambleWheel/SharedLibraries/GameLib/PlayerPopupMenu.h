//
//  PlayerPopupMenu.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameConstants.h"

@interface PlayerPopupMenu : UIView
{
    NSTimeInterval      m_TimeStartShowBalance;
}
-(void)OpenMenu;
-(void)CloseMenu;
-(void)AddMenuItem:(int)nEventID withLabel:(NSString*)label;
-(void)AddOnlinePlayerMenuItem:(int)nEventID withLabel:(NSString*)label withDelegate:(id<IOnlineGamePlayerPopupMenuDelegate>)delegate;
-(void)OnTimerEvent;
@end
