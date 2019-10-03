//
//  PlayerPopupMenuItem.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameConstants.h"

@interface PlayerPopupMenuItem : UIView
{
    UILabel*                                m_MenuLabel;
    int                                     m_nMenuEventID;
    id<IOnlineGamePlayerPopupMenuDelegate>  m_Delegate;
}

-(void)RegisterMenuItem:(int)nEventID withLabel:(NSString*)label;
-(void)RegisterOnlinePlayerMenuItem:(int)nEventID withLabel:(NSString*)label withDelegate:(id<IOnlineGamePlayerPopupMenuDelegate>)delegate;
-(void)OnCloseMenuItem;

@end
