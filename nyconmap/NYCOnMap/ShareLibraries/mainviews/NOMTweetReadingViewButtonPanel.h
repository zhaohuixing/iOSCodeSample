//
//  NOMTweetReadingViewButtonPanel.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-22.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMTweetReadingViewButtonPanel : UIView

-(void)UpdateLayout;

-(void)EnableLinkButton:(BOOL)bEnable;
-(void)EnableRetweetButton:(BOOL)bEnable;


@end
