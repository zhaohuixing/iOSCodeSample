//
//  BlockTarget.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 10-08-10.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BlockTarget
-(void)pushBack:(CGPoint)pt;
-(BOOL)blockBy:(id)blockage;
-(BOOL)hitTestWithBlockage:(id)blockage;
-(void)escapeFromBlockage:(id)blockage;

@end

@protocol BlockDelegate
-(void)detachTarget;
@end
