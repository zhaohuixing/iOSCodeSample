//
//  NOMTermAcceptUICore.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMTermAcceptUICore : UIView<UITextFieldDelegate, UITextViewDelegate>

-(void)UpdateLayout;

-(void)OpenPrivacyView;
-(void)OpenTermOfUseView;


@end
