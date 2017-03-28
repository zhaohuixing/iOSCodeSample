//
//  TwoStateButton.m
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "TwoStateButton.h"

@interface TwoStateButton ()
{
    UIImage*        m_StateOneImage;
    UIImage*        m_StateTwoimage;
}
@end

@implementation TwoStateButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_StateOneImage = [UIImage imageNamed:@"closearchor.png"];
        m_StateTwoimage = [UIImage imageNamed:@"back200.png"];
        [self setBackgroundImage:m_StateOneImage forState:UIControlStateNormal];

    }
    return self;
}

-(void)SetStateImage:(UIImage*)image1 withImageTwo:(UIImage*)image2
{
    m_StateOneImage = image1;
    m_StateTwoimage = image2;
}


-(void)SetState:(BOOL)bStateOne
{
    if(bStateOne)
    {
        [self setBackgroundImage:m_StateOneImage forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundImage:m_StateTwoimage forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
