//
//  ButttonCell.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListConstants.h"

@interface ButtonCell : UIView <ListCellTemplate> 
{
    UILabel*                    m_Text;
    UIButton*                   m_Button;
    int                         m_nCtrlID;
}

- (id)initWithFrame:(CGRect)frame withImage:(NSString*)szImage withHighLightImage:(NSString*)szHLImage;
-(void)RegisterControlID:(int)nID;

@end
