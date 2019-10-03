//
//  FriendView.h
//  XXXXX
//
//  Created by Zhaohui Xing on 2011-06-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameListView.h"


@interface FriendView : FrameListView 
{
    UIActivityIndicatorView*    m_Spinner;
}

-(void)LoadFriends;

@end
