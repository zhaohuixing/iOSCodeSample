//
//  SNSShareView.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameListView.h"
#import "MultiButtonCell.h"
#import "FacebookPoster.h"
//#import "RenRenPoster.h"
//#import "QQPoster.h"

@interface SNSShareView : FrameListView 
{
    //FacebookPoster*     m_FacebookPoster;
    BOOL                m_bDefaultLanguage;
}

- (void)InitializePostList;

@end
