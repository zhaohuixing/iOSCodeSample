//
//  NOMPostView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPostViewController.h"

@interface NOMPostView : UIView

+(double)GetDefaultBasicUISize;

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(void)SetTwitterEnabling:(BOOL)bTwitterEnable;


-(void)OnOKButtonClick;
-(void)OnCancelButtonClick;

-(void)UpdateLayout;
-(void)RegisterController:(id<IPostViewController>)controller;

-(NSString*)GetSubject;
-(NSString*)GetPost;
-(NSString*)GetKeywords;
-(NSString*)GetCopyright;
-(NSString*)GetGeographicKML;
-(UIImage*)GetImage;
-(BOOL)AllowTwitterShare;

-(void)OpenMapElementView;
-(void)HandlePlanCompleted:(NSString*)kml;

-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span;
-(void)SetReferenceInfo:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType isTTweet:(BOOL)bTwitterTweet;

-(void)HideKeyboard;

@end
