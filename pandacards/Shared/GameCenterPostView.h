//
//  GameCenterPostView.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameListView.h"
#import "ButtonCell.h"

@interface GameCenterPostView : FrameListView 
{
	UILabel*			m_Label2012;
    BOOL                m_bPostSucceded;
}

-(void)IntializeScoreList;
-(void)SetPostResult:(BOOL)bPostSucceeded;

@end
