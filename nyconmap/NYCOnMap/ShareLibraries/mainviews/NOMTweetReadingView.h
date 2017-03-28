//
//  NOMTweetReadView.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2/7/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "NOMNewsMetaDataRecord.h"

@interface NOMTweetReadingView : UIView

+(double)GetDefaultBasicUISize;

-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(void)SetTweetContent:(NOMNewsMetaDataRecord*)pTweetRecord;
-(void)OpenTweetLink:(NSString*)linkURL;

-(void)OnCloseButtonClick;
-(void)OnLinkButtonClick;
-(void)OnRetweetButtonClick;

-(void)UpdateLayout;

@end
