//
//  ConfigurationView.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameListView.h"

@interface ConfigurationView : FrameListView
{
//	CGPatternRef	m_Pattern;
    BOOL            m_bReloadList;
}

-(void)IntializeCongfigureList;
-(void)LoadSkill;
-(void)LoadLevel;
-(void)OnTimerEvent;

@end
