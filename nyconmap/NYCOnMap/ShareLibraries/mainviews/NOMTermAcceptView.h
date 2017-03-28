//
//  NOMTermAcceptView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NOMDocumentController.h"

@interface NOMTermAcceptView : UIView

+(double)GetDefaultBasicUISize;

-(void)OnOKButtonClick;
-(void)OnCancelButtonClick;

-(void)UpdateLayout;

-(void)OpenPrivacyView:(BOOL)bAnimation;
-(void)OpenTermOfUseView:(BOOL)bAnimation AcceptOption:(BOOL)bAccepted;
-(void)CloseView:(BOOL)bAnimation;
-(void)SetDocumentController:(NOMDocumentController*)document;

@end
