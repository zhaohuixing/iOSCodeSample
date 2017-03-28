//
//  NOMViewController.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NOMImageHelper.h"

@interface NOMViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, IImageSelectorDelegate>

-(void)InitializeMobilePushEndPointARN;
+(void)RegisterGlobalController:(NOMViewController*)controller;

-(void)ApplicationBecomeActive;
-(void)ApplicationBecomeInActive;
- (BOOL)HandleRemoteNotificationData:(NSDictionary *)userInfo;

//
//Apple Watch opening event
//
-(void)HandleAppleWatchOpenRequest:(NSMutableDictionary*)appData;

@end
