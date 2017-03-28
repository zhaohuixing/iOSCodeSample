//
//  XZCareActivitiesIconTableViewCell.m
//  XZCareCore
//
//  Created by Zhaohui Xing on 2015-09-29.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "UIColor+XZCareAppearance.h"
#import "UIFont+XZCareAppearance.h"
#import "XZCareBadgeLabel.h"
#import "XZCareActivitiesIconTableViewCell.h"

@implementation XZCareActivitiesIconTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupAppearance];
    self.countLabel.text = @"";
    self.subTitleLabel.text = @"";
    self.hidesSubTitle = NO;
//    if(self.titleLabel != nil)
//    {
//        self.titleLabel.hidden = YES;
//    }
//    self.titleLabel = nil;
}

- (void)setupAppearance
{
//    self.titleLabel.textColor = [UIColor appSecondaryColor1];
//    self.titleLabel.font = [UIFont appRegularFontWithSize:16.f];
    
    self.subTitleLabel.textColor = [UIColor appSecondaryColor3];
    self.subTitleLabel.font = [UIFont appRegularFontWithSize:14.f];
}

- (void)setHidesSubTitle:(BOOL)hidesSubTitle
{
    [self setNeedsDisplay];
}

-(void)setIcon:(UIImage*)icon
{
    [self.iconView setImage:icon];
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
