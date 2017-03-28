//
//  TwoStateButton.h
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoStateButton : UIButton

-(void)SetState:(BOOL)bStateOne;
-(void)SetStateImage:(UIImage*)image1 withImageTwo:(UIImage*)image2;

@end
