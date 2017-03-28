//
//  NOMPostViewButtonPanel.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMPostViewButtonPanel : UIView

-(void)UpdateLayout;
-(BOOL)IsTwitterEnable;
-(void)SetTwitterEnabling:(BOOL)bTwitterEnable;

@end
