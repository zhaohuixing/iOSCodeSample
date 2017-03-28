//
//  ToolbarButton.h
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-05.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolbarButton : UIView
{
@private
    CGGradientRef       m_BlueGradient;
    CGColorSpaceRef     m_BlueColorspace;
    
    CGImageRef          m_TransparentPattern;
    
    
    UIImageView*        m_StatusSign;
    UILabel*            m_Label;
    
    int                 m_nEventID;
}

-(void)SetLabel:(NSString*)text;
-(void)SetEventID:(int)nEventID;

@end
