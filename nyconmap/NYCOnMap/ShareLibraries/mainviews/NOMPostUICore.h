//
//  NOMPostUICore.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NOMImageHelper.h"
#import "NOMGEOPlanAnnotationView.h"

@interface NOMPostUICore : UIView<UITextFieldDelegate, UITextViewDelegate, /*MKMapViewDelegate,*/ IImageReceiverDelegate, IGEOPlanAnnotationViewHost>

-(void)CleanControlState;
-(void)UpdateLayout;
-(float)GetPostViewHeight;

-(void)OpenView;
-(void)SetKML:(NSString*)kml;
-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span;
-(void)SetReferenceInfo:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType isTTweet:(BOOL)bTwitterTweet;

-(double)GetZoomFactor;
-(void)SetPinDragState:(BOOL)bYES;

-(NSString*)GetSubject;
-(NSString*)GetPost;
-(NSString*)GetKeywords;
-(NSString*)GetCopyright;
-(NSString*)GetGeographicKML;
-(UIImage*)GetImage;
-(void)HideKeyboard;

@end
