//
//  ActivePlayerAnimator.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivePlayerAnimator : UIView

-(BOOL)IsActive;
-(void)StartAnimation;
-(void)StopAnimation;
-(void)FlyOut;
-(void)FlyIn;

@end
