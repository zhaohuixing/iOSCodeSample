//
//  MainViewBottomStatusBarController.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-08-26.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdBannerHostView.h"
#import "CustomImageButton.h"
#import "NOMNewsMetaDataRecord.h"
#import "INOMCustomListCalloutInterfaces.h"
#import "INOMSocialServiceInterface.h"

@protocol MainViewBottomStatusBarControllerDelegate <NSObject>
-(void)AddChildView:(UIView*)child;
-(CGRect)GetFrame;

-(void)OpenToolbarButtonClick;
-(void)OnCloseToolbarView;
-(void)OnTweetButtonClick;

@end


@interface MainViewBottomStatusBarController : NSObject<INOMCustomListCalloutCaller, INOMCachedSoicalNewsContainer, NOMNewsMetaDataLocationUpdateDelegate>

-(id)initWithDelegate:(id<MainViewBottomStatusBarControllerDelegate>)delegate;

-(void)UpdateLayout;

-(void)ShowPopupToolbarButton:(BOOL)bShow;
-(void)SetPopupToolbarButtonDisplay:(BOOL)bYes;

-(void)SetDrivingButtonState:(BOOL)bEnable;

-(void)UpdateTwitterButtonStatus;
-(void)CleanNoneLocationTweetList;

-(void)AddNoneLocationTweetData:(NOMNewsMetaDataRecord*)pRecord;
-(CGPoint)GetTwitetrButtonAchor;
-(NSArray*)GetTweetList;
-(NOMNewsMetaDataRecord*)GetNewsMetaDataRecord:(NSString*)newsID;

-(void)StartTweetMetaDataLocationDecode:(int)index;

//
//INOMCustomListCalloutCaller methods
//
-(BOOL)PrepareCalloutList:(id<INOMCustomListCalloutDelegate>)callout;
-(CGPoint)GetViewPointFromCurrentLocation;
-(CLLocationCoordinate2D)GetCurrentLocation;
-(void)RegisterCallout:(id<INOMCustomListCalloutDelegate>)callout;

//
//INOMCachedSoicalNewsContainer methods
//
-(id)GetCachedSocialNews:(NSString*)newsID;

@end
