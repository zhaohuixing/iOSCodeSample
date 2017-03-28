//
//  NOMGEOPlanPanel.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-26.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NOMGEOPlanPanel : UIView

+(CGFloat)GetSmallDemensionSize;

-(void)UpdateLayout;
-(void)Reset;

-(void)UpdateUndoButton:(BOOL)bShow;
//-(void)UpdateSyncButton:(BOOL)bShow;

@end
