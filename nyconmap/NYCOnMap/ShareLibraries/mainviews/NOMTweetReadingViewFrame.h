//
//  NOMTweetReadingViewFrame.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2/7/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NOMNewsMetaDataRecord.h"


@class NOMTweetReadingView;

@interface NOMTweetReadingViewFrame : UIScrollView<UIScrollViewDelegate>
{
}

-(void)CloseView;
-(void)RestoreScrollViewDefaultPosition;
-(void)SetTweetContent:(NOMNewsMetaDataRecord*)pTweetRecord;

-(void)UpdateLayout;

@end
