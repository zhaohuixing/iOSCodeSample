//
//  NonTouchableImageView.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-13.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "NonTouchableImageView.h"

@implementation NonTouchableImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // If the hitView is THIS view, return nil and allow hitTest:withEvent: to
    // continue traversing the hierarchy to find the underlying view.
    if (hitView == self)
    {
        return nil;
    }
    
    // Else return the hitView (as it could be one of this view's buttons):
    return hitView;
}

@end
