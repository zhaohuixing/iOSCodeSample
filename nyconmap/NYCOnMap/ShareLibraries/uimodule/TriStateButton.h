//
//  TriStateButton.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLayoutButton.h"

@interface TriStateButton : AutoLayoutButton

-(void)UpdateState;
-(int)GetState;
-(void)SetState:(int)nState;
-(void)SetImage:(CGImageRef)image1 Image2:(CGImageRef)image2 Image3:(CGImageRef)image3;

@end
