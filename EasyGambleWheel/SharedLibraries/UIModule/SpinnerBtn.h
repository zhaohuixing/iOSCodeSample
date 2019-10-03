//
//  SpinnerBtn.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-08-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SpinnerBtn : UIButton
{
@private
    UIActivityIndicatorView*    m_Spinner;
}

-(void)StartSpin;
-(void)StopSpin;
-(void)HideButton;

@end
