//
//  NOMWebBrowserContainer.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2/10/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NOMWebBrowserContainer : UIView<UIWebViewDelegate>

-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(void)LoadURL:(NSString*)szURL;
-(void)UpdateLayout;

@end
