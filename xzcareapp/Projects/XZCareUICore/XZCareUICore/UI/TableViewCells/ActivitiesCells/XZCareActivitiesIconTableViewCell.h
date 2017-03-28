//
//  XZCareActivitiesIconTableViewCell.h
//  XZCareCore
//
//  Created by Zhaohui Xing on 2015-09-29.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <XZCareUICore/XZCareActivitiesTintedTableViewCell.h>

@interface XZCareActivitiesIconTableViewCell : XZCareActivitiesTintedTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

-(void)setIcon:(UIImage*)icon;

@end
