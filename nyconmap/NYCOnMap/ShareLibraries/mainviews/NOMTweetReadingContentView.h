//
//  NOMTweetReadingContentView.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2/7/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CustomGlossyButton.h"
//#import "NonTouchableLabel.h"
//#import "NonTouchableImageView.h"
//#import "NOMNewsMetaDataRecord.h"

//@class NOMTweetReadingViewFrame;
@class NOMTweetReadingView;
@class NOMNewsMetaDataRecord;

@interface NOMTweetReadingContentView : UIView<UITextViewDelegate>

-(float)GetViewHeight:(BOOL)bHasImageView;
-(void)SetTweetContent:(NOMNewsMetaDataRecord*)pTweetRecord;
-(void)UpdateLayout;

@end
