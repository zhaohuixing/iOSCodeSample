//
//  RoboListBoard.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-08-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoboListBoard : UIView
{
@private
    CGPoint                     m_AchorPoint;
    UILabel*                    m_Title;
    CGImageRef                  m_Image1;
    CGImageRef                  m_Image2;
    CGImageRef                  m_Image3;

}

-(void)SetAchorAtTop:(float)fPostion;
-(void)SetAchorAtBottom:(float)fPostion;
-(void)UpdateViewLayout;
-(void)SetTitle:(NSString*)szTitle;
-(void)SetImage1:(CGImageRef)image;
-(void)SetImage2:(CGImageRef)image;
-(void)SetImage3:(CGImageRef)image;
-(void)ResetImages;

@end
