//
//  NOMAddressFinderViewButtonPanel.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-11.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMAddressFinderViewButtonPanel : UIView

-(void)UpdateLayout;

-(void)SetCheckButtonEnable:(BOOL)bEnable;
-(void)SetOKButtonEnable:(BOOL)bEnable;
-(void)SetCancelButtonEnable:(BOOL)bEnable;


@end
