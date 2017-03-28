//
//  NOMSpotViewButtonPanel.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-24.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMSpotViewButtonPanel : UIView

-(void)UpdateLayout;
-(BOOL)IsTwitterEnable;
-(void)SetTwitterEnabling:(BOOL)bTwitterEnable;
+(double)GetDefaultBasicUISize;


@end
