//
//  AdBannerHostView.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdBannerHostView : UIView

-(void)UpdateLayout;
+(CGFloat)GetADBannerHeight;
-(void)DismissAdBanner;
-(BOOL)HasAds;

@end
