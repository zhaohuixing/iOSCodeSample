//
//  CustomImageButton.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-10.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageButton : UIButton
{
@private
    CGImageRef          m_CustomImage;
}

-(void)SetCustomImage:(CGImageRef)image;

@end
