//
//  NOMSpotSchoolZoneContentView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMSpotSchoolZoneContentView : UIView<UITextFieldDelegate>

-(float)GetContentViewHeight;
-(void)UpdateLayout;


-(void)Reset;
-(void)SetAddress:(NSString*)address;
-(void)SetName:(NSString*)name;

-(NSString*)GetAddress;
-(NSString*)GetName;

@end
