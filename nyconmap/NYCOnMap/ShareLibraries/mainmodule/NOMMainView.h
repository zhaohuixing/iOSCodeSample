//
//  NOMMainView.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NOMDocumentController.h"
#import "IMainViewDelegate.h"
#import "MainViewBottomStatusBarController.h"
#import "INOMCustomListCalloutInterfaces.h"


@interface NOMMainView : UIView<MainViewBottomStatusBarControllerDelegate, IMainViewDelegate, INOMCustomListCalloutDelegate>

-(void)UpdateLayout:(BOOL)bUpdateSubViewLayout;
-(void)SetDocumentController:(NOMDocumentController*)document;
-(void)OnMenuEvent:(int)nMenuID;
-(void)HandlePlanCompleted:(NSString*)kml;
-(void)MakeAppLocationOnMap;
-(void)StartFindLocationForPosting;
-(void)AddressFindingViewClosed:(BOOL)bOK;
-(void)CloseCallout;
-(void)ShowNewsCalloutAt:(CGPoint)pt withAnimation:(BOOL)bYes;

-(void)AddNoLocationSocialNewsData:(id)newsData;
-(void)RemoveAllNoLocationSocialNewsData;

- (BOOL)HandleRemoteNotificationData:(NSDictionary *)userInfo;

-(void)OpenTermOfUseView:(BOOL)bAccept;

//
//INOMCustomListCalloutDelegate methods
//
-(void)OpenListCallout:(id<INOMCustomListCalloutCaller>)caller;
-(void)AddCalloutItem:(id<INOMCustomListCalloutItem>)calloutItem;
-(id<INOMCustomListCalloutDelegate>)GetCalloutDelegate;

@end
