//
//  AchievementPostView.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-04-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameListView.h"
#import "ButtonCell.h"

@interface AchievementPostView : FrameListView 
{
	CGPatternRef        m_Pattern;
	UILabel*			m_Label2012;
}

-(void)IntializeScoreList;

@end
