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
//#import "FacebookPoster.h"

@interface SNSShareView : FrameListView 
{
	//CGPatternRef        m_Pattern;
    //FacebookPoster*     m_FacebookPoster;
    BOOL                m_bDefaultLanguage;

    MultiButtonCell*         m_pPostCell1;
    MultiButtonCell*         m_pPostCell2;
    MultiButtonCell*         m_pPostCell3;
    
}

- (void)InitializePostList;

@end
